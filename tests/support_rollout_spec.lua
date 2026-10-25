-- four-skill event routing, source gates and native ownership edge cases.
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
    for _, name in pairs(fake.load("src/data/skills").NAMES) do
        levels[name] = 120
    end
    local state = {
        level = function(name)
            return levels[name]
        end,
        quest_done = function(name)
            return quests[name]
        end,
        owns_item = function()
            return false
        end,
    }
    return fake, progress, levels, quests, state
end

return function(root)
    local suite = {}

    function suite:test_four_skills_reach_cards_through_sustained_xp_events()
        for name, level in pairs({ AGILITY = 35, THIEVING = 10, PRAYER = 30, SUMMONING = 31 }) do
            local fake = client.new(root)
            local number = fake.load("src/data/skills").number(name)
            fake.player.levels[number] = level
            local progress = fake.load("src/storage/tip_progress")
            progress.use_character("test_player")
            progress.allow_existing_methods()
            local app = fake.load("src/app")
            app.start()
            fake.fire("Logic", { logicTick = 0 })
            for drop = 1, 3 do
                fake.fire("Logic", { logicTick = drop * 250 })
                fake.fire(
                    "SkillTransmit",
                    { skill = number, oldXP = drop * 100, newXP = drop * 100 + 10 }
                )
                if drop < 3 then
                    lu.assertEquals(#progress.recent_tips(), 0)
                end
            end
            lu.assertEquals(#progress.recent_tips(), 1, name)
            lu.assertStrContains(progress.recent_tips()[1].id, name:lower() .. ".method.")
            app.stop()
        end
    end

    function suite:test_non_head_outfit_pieces_never_cross_teach_the_shared_category()
        for _, case in ipairs({
            { "WOF51_SKILL_SUMMONING_GLOVES", "summoning.shaman_outfit", "prayer.first_age" },
            { "WOF36_SKILL_PRAYER_RING", "prayer.first_age", "agility.nimble_outfit" },
            { "TRH85_AGILITY_HANDS", "agility.nimble_outfit", "summoning.shaman_outfit" },
            { "TRH90_PRIFDDINAS_FEET", "thieving.camouflage", "thieving.black_ibis" },
        }) do
            local fake, progress = world(root)
            fake.inventories[94] = { { item = case[1], category = 2739 } }
            fake.load("src/coach/item_knowledge").observe()
            lu.assertTrue(progress.is_known(case[2]))
            lu.assertFalse(progress.is_known(case[3]))
        end
    end

    function suite:test_drained_ectoplasmator_remains_known_after_storage()
        local fake, progress = world(root)
        fake.inventories[94] = { { item = "HW2012_ECTOPLASMATOR_UPGRADED_EMPTY", category = 4210 } }
        fake.load("src/coach/item_knowledge").observe()
        lu.assertTrue(progress.is_known("prayer.ectoplasmator"))
        fake.inventories[94] = {}
        progress.use_character("bob")
        progress.use_character("alice")
        lu.assertTrue(progress.is_known("prayer.ectoplasmator"))
    end

    function suite:test_upgraded_bag_suppresses_basic_advice_but_not_the_reverse()
        for _, upgraded in ipairs({ false, true }) do
            local fake, progress = world(root)
            fake.inventories[94] = {
                {
                    item = upgraded and "INVENT_THIEVING_BAG_MUSHROOM_UNCHARGED"
                        or "INVENT_THIEVING_BAG_UNCHARGED",
                    category = -1,
                },
            }
            fake.load("src/coach/item_knowledge").observe()
            lu.assertTrue(progress.is_known("thieving.pickpocketing_bag"))
            lu.assertEquals(progress.is_known("thieving.mushroomy_bag"), upgraded)
        end
    end

    function suite:test_spirit_moths_wait_for_hunter_but_can_point_to_the_quest()
        local fake, _, levels, quests, state = world(root)
        local tip = fake.load("src/tips/catalogue").get("agility.method.spirit_moths")
        local eligibility = fake.load("src/coach/eligibility")
        levels.AGILITY, levels.HUNTER = 80, 85
        lu.assertTrue(eligibility.allows(tip, "AGILITY", state))
        quests.QUEST_WENDLE_HERALDS = true
        lu.assertTrue(eligibility.allows(tip, "AGILITY", state))
        levels.HUNTER = 84
        lu.assertFalse(eligibility.allows(tip, "AGILITY", state))
        levels.HUNTER = nil
        lu.assertFalse(eligibility.allows(tip, "AGILITY", state))
    end

    function suite:test_source_levels_do_not_become_guessed_wear_or_host_requirements()
        local fake, _, levels, _, state = world(root)
        local catalogue = fake.load("src/tips/catalogue")
        local eligibility = fake.load("src/coach/eligibility")
        levels.AGILITY, levels.DEFENCE = 85, 1
        lu.assertTrue(eligibility.allows(catalogue.get("agility.agile_clothing"), "AGILITY", state))
        levels.PRAYER, levels.CONSTRUCTION = 30, 1
        lu.assertTrue(eligibility.allows(catalogue.get("prayer.method.altars"), "PRAYER", state))
        levels.SUMMONING, levels.DUNGEONEERING, levels.DEFENCE = 50, 50, 49
        lu.assertFalse(
            eligibility.allows(catalogue.get("summoning.spirit_cape"), "SUMMONING", state)
        )
        levels.DEFENCE = 50
        lu.assertTrue(
            eligibility.allows(catalogue.get("summoning.spirit_cape"), "SUMMONING", state)
        )
    end

    function suite:test_diary_goal_defers_missing_task_levels_and_low_tier_cloak_is_not_enough()
        local fake, progress, levels, _, state = world(root)
        local catalogue = fake.load("src/tips/catalogue")
        local eligibility = fake.load("src/coach/eligibility")
        local tip = catalogue.get("thieving.ardougne_cloak")
        levels.THIEVING, levels.HERBLORE = 38, 56
        lu.assertFalse(eligibility.allows(tip, "THIEVING", state))
        levels.HERBLORE = nil
        lu.assertFalse(eligibility.allows(tip, "THIEVING", state))
        levels.HERBLORE = 57
        lu.assertTrue(eligibility.allows(tip, "THIEVING", state))
        fake.inventories[94] = { { item = "ATAR_CLOAK_EASY", category = 753 } }
        fake.load("src/coach/item_knowledge").observe()
        lu.assertFalse(progress.is_known(tip.id))
        fake.inventories[94] = { { item = "ATAR_CLOAK_MED", category = 753 } }
        fake.load("src/coach/item_knowledge").observe()
        lu.assertTrue(progress.is_known(tip.id))
    end

    function suite:test_niche_windows_expire_without_hiding_later_charm_families()
        local fake, _, levels, quests, state = world(root)
        quests.PLAGUES_END = true
        local catalogue = fake.load("src/tips/catalogue")
        local eligibility = fake.load("src/coach/eligibility")
        for _, case in ipairs({
            { "agility.alt.serenity", "AGILITY", 94 },
            { "prayer.alt.sand", "PRAYER", 49 },
            { "summoning.alt.spirit_jelly", "SUMMONING", 72 },
        }) do
            levels[case[2]] = case[3]
            lu.assertTrue(eligibility.allows(catalogue.get(case[1]), case[2], state))
            levels[case[2]] = case[3] + 1
            lu.assertFalse(eligibility.allows(catalogue.get(case[1]), case[2], state))
        end
        levels.SUMMONING = 110
        lu.assertTrue(
            eligibility.allows(catalogue.get("summoning.alt.geyser_titan"), "SUMMONING", state)
        )
    end

    function suite:test_user_exclusions_do_not_reappear_as_tips_or_ownership_aliases()
        local fake, progress = world(root)
        fake.inventories[94] = { { item = "TRH5_PEGASUS_BOOTS_5", category = 3168 } }
        fake.load("src/coach/item_knowledge").observe()
        lu.assertFalse(progress.is_known("agility.nimble_outfit"))
        for _, tip in ipairs(fake.load("src/tips/catalogue").all()) do
            lu.assertNil(tip.title:lower():find("silverhawk", 1, true))
            if tip.kind ~= "quest" then
                for _, skill in ipairs(tip.skills) do
                    lu.assertNotEquals(skill, "DUNGEONEERING")
                    lu.assertNotEquals(skill, "SLAYER")
                end
            end
        end
    end

    function suite:test_cave_goblin_training_points_towards_city_access()
        local fake, _, levels, quests, state = world(root)
        local catalogue = fake.load("src/tips/catalogue")
        local eligibility = fake.load("src/coach/eligibility")
        local tip = catalogue.get("thieving.method.cave_goblins")
        local city_quest = tip.requirements.quests[1]
        levels.THIEVING = 36
        lu.assertTrue(eligibility.allows(tip, "THIEVING", state))
        quests[city_quest] = false
        lu.assertTrue(eligibility.allows(tip, "THIEVING", state))
        quests[city_quest] = true
        lu.assertTrue(eligibility.allows(tip, "THIEVING", state))
        levels.THIEVING = 38
        lu.assertFalse(eligibility.allows(tip, "THIEVING", state))
        lu.assertTrue(
            eligibility.allows(catalogue.get("thieving.method.master_farmers"), "THIEVING", state)
        )
    end

    return suite
end
