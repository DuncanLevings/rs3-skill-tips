-- near-ready quests stay bounded, while ordinary method tips remain strict.
local lu = require("luaunit")
local client = require("tests/support/client")

local function tip()
    return {
        id = "test.near",
        kind = "quest",
        quest = "TEST_NEAR",
        skills = { "ANY" },
        title = "Unlock",
        hook = "Useful benefit",
        aspiration_hook = "A useful unlock to work towards",
        why = "Lasting benefit",
        how = { "Explore the quest" },
        members = true,
        priority = 1,
        requirements = {
            skills = { CONSTRUCTION = 50, CRAFTING = 50, AGILITY = 50, MINING = 50, FISHING = 50 },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = { { type = "requirements_met", skill = "ANY" } },
    }
end

local function world(root)
    local fake = client.new(root)
    local levels = { CONSTRUCTION = 50, CRAFTING = 50, AGILITY = 50, MINING = 50, FISHING = 50 }
    local state = {
        level = function(skill)
            return levels[skill]
        end,
        quest_done = function()
            return false
        end,
    }
    return fake, levels, state, fake.load("src/coach/quest_readiness")
end

return function(root)
    local suite = {}

    function suite:test_four_missing_skills_and_twenty_total_levels_are_inclusive()
        local _, levels, state, readiness = world(root)
        levels.CONSTRUCTION, levels.CRAFTING, levels.AGILITY, levels.MINING = 42, 43, 47, 48
        local result = readiness.assess(tip(), state)
        lu.assertTrue(result.eligible)
        lu.assertFalse(result.fully_met)
        lu.assertEquals(#result.missing, 4)
        lu.assertEquals(result.total_gap, 20)
        levels.MINING = 47
        lu.assertFalse(readiness.assess(tip(), state).eligible)
    end

    function suite:test_nine_level_gap_and_five_missing_skills_defer()
        local _, levels, state, readiness = world(root)
        levels.CONSTRUCTION = 41
        lu.assertFalse(readiness.assess(tip(), state).eligible)
        for skill in pairs(levels) do
            levels[skill] = 49
        end
        lu.assertFalse(readiness.assess(tip(), state).eligible)
    end

    function suite:test_unknown_or_invalid_mandatory_levels_never_qualify()
        local _, levels, state, readiness = world(root)
        levels.CONSTRUCTION = nil
        lu.assertFalse(readiness.assess(tip(), state).eligible)
        for _, value in ipairs({ 0, false, "50", math.huge, 0 / 0 }) do
            levels.CONSTRUCTION = value
            lu.assertFalse(readiness.assess(tip(), state).eligible)
        end
    end

    function suite:test_aspirations_are_opt_in_and_never_relax_method_requirements()
        local fake, levels, state, readiness = world(root)
        local candidate = tip()
        levels.CONSTRUCTION = 49
        candidate.aspiration = nil
        lu.assertFalse(readiness.assess(candidate, state).eligible)
        candidate = tip()
        candidate.kind = "method"
        lu.assertFalse(readiness.assess(candidate, state).eligible)
        lu.assertTrue(#fake.load("src/tips/schema").problems(candidate) > 0)
        local penguin = fake.load("src/tips/catalogue").get("agility.method.penguin")
        levels.AGILITY, levels.CONSTRUCTION, levels.CRAFTING = 30, 31, 30
        levels.HUNTER, levels.THIEVING = 10, 15
        lu.assertFalse(fake.load("src/coach/eligibility").allows(penguin, "AGILITY", state))
        levels.CONSTRUCTION = 34
        lu.assertTrue(fake.load("src/coach/eligibility").allows(penguin, "AGILITY", state))
    end

    function suite:test_either_combat_style_counts_as_one_path_and_respects_mutes()
        local fake, levels, state, readiness = world(root)
        local candidate = fake.load("src/tips/catalogue").get("quest.world_wakes")
        levels.MAGIC, levels.RANGED = 68, 1
        local result = readiness.assess(candidate, state)
        lu.assertTrue(result.eligible)
        lu.assertEquals(result.total_gap, 8)
        lu.assertEquals(#result.missing, 1)
        levels.MAGIC = 67
        lu.assertFalse(readiness.assess(candidate, state).eligible)
        levels.MAGIC, levels.RANGED = nil, 68
        lu.assertTrue(readiness.assess(candidate, state).eligible)
        fake.load("src/storage/settings").set("muted_skills", { RANGED = true })
        lu.assertFalse(readiness.assess(candidate, state).eligible)
    end

    function suite:test_mandatory_and_alternative_requirements_never_double_count()
        local fake, levels, state, readiness = world(root)
        local candidate = tip()
        candidate.requirements =
            { skills = { MAGIC = 70 }, any_skills = { MAGIC = 76, RANGED = 76 } }
        levels.MAGIC, levels.RANGED = 68, 1
        local result = readiness.assess(candidate, state)
        lu.assertEquals(result.total_gap, 8)
        lu.assertEquals(#result.missing, 1)
        lu.assertEquals(fake.load("src/ui/requirement_list").missing(candidate, state), {
            "- Magic 70 (you're level 68)",
            "- Magic 76 or Ranged 76",
        })
        levels.RANGED = 76
        result = readiness.assess(candidate, state)
        lu.assertEquals(result.total_gap, 2)
        lu.assertEquals(#result.missing, 1)
    end

    function suite:test_near_ready_copy_and_list_show_only_remaining_levels()
        local fake, levels, state = world(root)
        local requirements = fake.load("src/ui/requirement_list")
        local candidate = tip()
        levels.CONSTRUCTION = 48
        lu.assertEquals(requirements.hook(candidate, state), candidate.aspiration_hook)
        lu.assertEquals(requirements.label(candidate, state), "Still need:")
        lu.assertEquals(
            requirements.missing(candidate, state),
            { "- Construction 50 (you're level 48)" }
        )
        levels.CONSTRUCTION = 50
        lu.assertEquals(requirements.hook(candidate, state), candidate.hook)
        lu.assertEquals(requirements.missing(candidate, state), {})
        candidate = fake.load("src/tips/catalogue").get("quest.world_wakes")
        levels.MAGIC, levels.RANGED = 68, 1
        lu.assertEquals(requirements.missing(candidate, state), { "- Magic 76 or Ranged 76" })
    end

    function suite:test_completed_and_unknown_quests_still_defer()
        local fake, levels, state = world(root)
        levels.CONSTRUCTION = 48
        local eligibility = fake.load("src/coach/eligibility")
        ---@type boolean?
        local done = false
        state.quest_done = function()
            return done
        end
        lu.assertTrue(eligibility.quest_ready(tip(), state))
        done = true
        lu.assertFalse(eligibility.quest_ready(tip(), state))
        done = nil
        lu.assertFalse(eligibility.quest_ready(tip(), state))
    end

    function suite:test_fully_ready_quest_precedes_a_higher_sorted_aspiration()
        local fake, levels, state = world(root)
        local near = tip()
        near.id = "test.a_near"
        local ready = tip()
        ready.id, ready.quest = "test.z_ready", "TEST_READY"
        ready.requirements.skills = { FISHING = 50 }
        ready.aspiration, ready.aspiration_hook = nil, nil
        fake.load("src/tips/skills/mining")[1] = near
        fake.load("src/tips/skills/mining")[2] = ready
        local progress = fake.load("src/storage/tip_progress")
        progress.use_character("alice")
        levels.CONSTRUCTION = 48
        -- only the two synthetic quests have readable unfinished status.
        state.quest_done = function(name)
            if name == near.quest or name == ready.quest then
                return false
            end
        end
        local engine = fake.load("src/coach/engine")
        local shown = {}
        engine.start({
            state = state,
            now = function()
                return 100
            end,
            show_card = function(candidate, handlers)
                shown[#shown + 1] = { id = candidate.id, handlers = handlers }
                return true
            end,
        })
        engine.on_quiet()
        lu.assertEquals(shown[1].id, ready.id)
        shown[1].handlers.on_closed()
        engine.reset_pacing()
        engine.on_quiet()
        lu.assertEquals(shown[2].id, near.id)
        engine.stop()
    end

    function suite:test_live_combat_level_event_can_queue_a_nearby_unlock_without_interrupting()
        local fake = client.new(root)
        fake.player.levels[6] = 68
        fake.quests.WORLD_WAKES = { hasFinishedQuest = false }
        local app = fake.load("src/app")
        app.start()
        fake.fire("Logic", { logicTick = 0 })
        fake.fire(
            "SkillTransmit",
            { skill = 6, oldXP = 100, newXP = 200, oldGameplayLevel = 67, newGameplayLevel = 68 }
        )
        local progress = fake.load("src/storage/tip_progress")
        lu.assertTrue(progress.queued_quests()["quest.world_wakes"])
        fake.fire("Logic", { logicTick = 2950 })
        lu.assertEquals(#fake.windows, 0)
        fake.fire("Logic", { logicTick = 3000 })
        lu.assertEquals(#fake.windows, 1)
        lu.assertEquals(progress.recent_tips()[1].id, "quest.world_wakes")
        app.stop()
    end

    function suite:test_every_selected_tip_uses_approved_limits_and_has_source_requirements()
        local fake = client.new(root)
        local catalogue = fake.load("src/tips/catalogue")
        local count = 0
        for _, candidate in ipairs(catalogue.quest_tips()) do
            if candidate.aspiration then
                count = count + 1
                lu.assertEquals(
                    candidate.aspiration,
                    { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 }
                )
                lu.assertStrContains(type(candidate.aspiration_hook), "string")
            end
        end
        lu.assertEquals(count, 26)
        lu.assertEquals(#catalogue.quest_tips(), 45)
        local city = catalogue.get("quest.animate_dead")
        lu.assertEquals(city.requirements.skills.MAGIC, 84)
        local ring = catalogue.get("quest.passive_vigour")
        lu.assertTrue(ring.requirements.skills.ATTACK >= 62)
        lu.assertTrue(ring.requirements.skills.DUNGEONEERING >= 62)
        lu.assertEquals(catalogue.get("quest.ungael_rituals").requirements.skills.NECROMANCY, 80)
        lu.assertEquals(catalogue.get("quest.ungael_rituals").requirements.skills.CONSTRUCTION, 54)
        lu.assertEquals(catalogue.get("quest.lunar_utilities").requirements.skills.MAGIC, 77)
    end

    function suite:test_schema_rejects_missing_invalid_or_nonquest_aspiration_fields()
        local fake = client.new(root)
        local schema = fake.load("src/tips/schema")
        for _, bad in ipairs({ 0, -1, 1.5, "4", false }) do
            local candidate = tip()
            candidate.aspiration.max_missing_skills = bad
            lu.assertTrue(#schema.problems(candidate) > 0)
        end
        local candidate = tip()
        candidate.aspiration_hook = nil
        lu.assertTrue(#schema.problems(candidate) > 0)
    end

    return suite
end
