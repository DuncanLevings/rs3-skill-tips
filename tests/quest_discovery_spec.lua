-- level-qualified discoveries, quest-dependent copy and cross-style account unlocks.
local lu = require("luaunit")
local client = require("tests/support/client")

local function world(root)
    local fake = client.new(root)
    local progress = fake.load("src/storage/tip_progress")
    progress.use_character("alice")
    local bank = fake.load("src/storage/owned_items")
    bank.use_character("alice")
    bank.update_from_bank({}, {}, function()
        return 0
    end, function()
        return 0
    end)
    local levels, quests = {}, {}
    for _, skill in pairs(fake.load("src/data/skills").NAMES) do
        levels[skill] = 120
    end
    local state = {
        level = function(skill)
            return levels[skill]
        end,
        quest_done = function(name)
            return quests[name]
        end,
        owns_item = function()
            return false
        end,
        owns_category = function()
            return false
        end,
    }
    return fake, levels, quests, state
end

return function(root)
    local suite = {}

    function suite:test_unfinished_quest_changes_guidance_without_hiding_qualified_methods()
        local fake, levels, quests, state = world(root)
        local tip = fake.load("src/tips/catalogue").get("mining.method.corrupted_ore")
        local eligibility = fake.load("src/coach/eligibility")
        local requirements = fake.load("src/ui/requirement_list")
        levels.MINING = 89
        lu.assertTrue(eligibility.allows(tip, "MINING", state))
        lu.assertEquals(requirements.steps(tip, state), tip.quest_how)
        quests.PLAGUES_END = false
        lu.assertTrue(eligibility.allows(tip, "MINING", state))
        quests.PLAGUES_END = true
        lu.assertTrue(eligibility.allows(tip, "MINING", state))
        lu.assertEquals(requirements.steps(tip, state), tip.how)
        levels.HERBLORE = 74
        lu.assertFalse(eligibility.allows(tip, "MINING", state))
        levels.HERBLORE = nil
        lu.assertFalse(eligibility.allows(tip, "MINING", state))
    end

    function suite:test_guaranteed_rewards_stop_at_completion_but_other_tools_remain_useful()
        local fake, _, quests, state = world(root)
        local catalogue = fake.load("src/tips/catalogue")
        local eligibility = fake.load("src/coach/eligibility")
        local reward = catalogue.get("shared.ring_of_whispers")
        local quest = reward.requirements.quests[1]
        quests[quest] = false
        lu.assertTrue(eligibility.allows(reward, "MINING", state))
        quests[quest] = true
        lu.assertFalse(eligibility.allows(reward, "MINING", state))
        quests.PLAGUES_END = true
        local tool = catalogue.get("fishing.crystal_fishing_rod")
        lu.assertTrue(eligibility.allows(tool, "FISHING", state))
        state.owns_item = function()
            return true
        end
        lu.assertFalse(eligibility.allows(tool, "FISHING", state))
    end

    function suite:test_unfinished_quest_can_be_discovered_in_an_existing_method_bracket()
        local fake, levels, quests, state = world(root)
        local tip = fake.load("src/tips/catalogue").get("mining.method.corrupted_ore")
        local eligibility = fake.load("src/coach/eligibility")
        levels.MINING = 89
        fake.load("src/storage/tip_progress").capture_starting_levels(state)
        quests.PLAGUES_END = false
        lu.assertTrue(eligibility.allows(tip, "MINING", state))
        quests.PLAGUES_END = true
        lu.assertFalse(eligibility.allows(tip, "MINING", state))
        quests.PLAGUES_END = nil
        lu.assertFalse(eligibility.allows(tip, "MINING", state))
        quests.PLAGUES_END = false
        levels.MINING = tip.level_range[2] + 1
        lu.assertFalse(eligibility.allows(tip, "MINING", state))
    end

    function suite:test_world_wakes_accepts_either_combat_style_and_respects_mutes()
        local fake, levels, quests, state = world(root)
        local tip = fake.load("src/tips/catalogue").get("quest.world_wakes")
        local eligibility = fake.load("src/coach/eligibility")
        quests[tip.quest] = false
        levels.MAGIC, levels.RANGED = 75, 76
        lu.assertTrue(eligibility.quest_ready(tip, state))
        levels.MAGIC, levels.RANGED = 76, 75
        lu.assertTrue(eligibility.quest_ready(tip, state))
        fake.load("src/storage/settings").set("muted_skills", { MAGIC = true })
        levels.RANGED = 67
        lu.assertFalse(eligibility.quest_ready(tip, state))
        levels.RANGED = 76
        lu.assertTrue(eligibility.quest_ready(tip, state))
        levels.MAGIC, levels.RANGED = nil, 75
        lu.assertTrue(eligibility.quest_ready(tip, state))
        levels.RANGED = 67
        lu.assertFalse(eligibility.quest_ready(tip, state))
        lu.assertEquals(eligibility.stage(tip), "late")
    end

    function suite:test_combat_style_level_queues_once_and_obeys_combat_pacing()
        local fake, levels, quests, state = world(root)
        local catalogue = fake.load("src/tips/catalogue")
        local tip = catalogue.get("quest.world_wakes")
        quests[tip.quest] = false
        levels.MAGIC, levels.RANGED = 1, 76
        local progress = fake.load("src/storage/tip_progress")
        local engine = fake.load("src/coach/engine")
        local now, shown = 100, {}
        engine.start({
            state = state,
            now = function()
                return now
            end,
            show_card = function(candidate)
                shown[#shown + 1] = candidate.id
                return true
            end,
        })
        engine.on_level_up("RANGED", 75, 76)
        lu.assertTrue(progress.queued_quests()[tip.id])
        engine.on_combat()
        engine.on_quiet()
        lu.assertEquals(shown, {})
        now = now + fake.load("src/storage/settings").get("combat_quiet_seconds")
        engine.on_quiet()
        lu.assertEquals(shown, { tip.id })
        engine.stop()
        for _, skill in ipairs({ "MAGIC", "RANGED" }) do
            local count = 0
            for _, candidate in ipairs(catalogue.for_skill(skill)) do
                if candidate.id == tip.id then
                    count = count + 1
                end
            end
            lu.assertEquals(count, 1)
        end
    end

    function suite:test_soul_split_keeps_use_level_and_prerequisite_chain_levels()
        local fake, levels, quests, state = world(root)
        local tip = fake.load("src/tips/catalogue").get("quest.soul_split")
        local eligibility = fake.load("src/coach/eligibility")
        quests[tip.quest] = false
        lu.assertTrue(eligibility.quest_ready(tip, state))
        levels.PRAYER = 91
        lu.assertTrue(eligibility.quest_ready(tip, state))
        lu.assertFalse(fake.load("src/coach/quest_readiness").assess(tip, state).fully_met)
        levels.PRAYER = 83
        lu.assertFalse(eligibility.quest_ready(tip, state))
        levels.PRAYER = 92
        lu.assertTrue(eligibility.quest_ready(tip, state))
        levels.THIEVING = 65
        lu.assertTrue(eligibility.quest_ready(tip, state))
        levels.THIEVING = 57
        lu.assertFalse(eligibility.quest_ready(tip, state))
        levels.THIEVING = 66
        lu.assertTrue(eligibility.quest_ready(tip, state))
        quests[tip.quest] = true
        lu.assertFalse(eligibility.quest_ready(tip, state))
    end

    function suite:test_partial_fairy_ring_unlock_does_not_require_full_quest_levels()
        local fake, levels, quests, state = world(root)
        local tip = fake.load("src/tips/catalogue").get("quest.fairy_rings")
        local eligibility = fake.load("src/coach/eligibility")
        levels.FARMING, levels.HERBLORE = 1, 1
        quests[tip.quest] = false
        lu.assertTrue(eligibility.quest_ready(tip, state))
        levels.WOODCUTTING = 35
        lu.assertTrue(eligibility.quest_ready(tip, state))
        levels.WOODCUTTING = 27
        lu.assertFalse(eligibility.quest_ready(tip, state))
    end

    function suite:test_schema_checks_quest_guidance_and_alternative_skill_requirements()
        local fake = client.new(root)
        local schema = fake.load("src/tips/schema")
        local tip = fake.load("src/tips/catalogue").get("quest.world_wakes")
        tip.requirements.any_skills = { INVALID = 76 }
        lu.assertTrue(#schema.problems(tip) > 0)
        tip.requirements.any_skills = { MAGIC = 76 }
        lu.assertEquals(schema.problems(tip), {})
        tip.quest_how = { false }
        lu.assertTrue(#schema.problems(tip) > 0)
    end

    return suite
end
