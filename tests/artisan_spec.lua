-- artisan access, ownership and the shared activity path; no new reward bypasses.
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
    }
    return fake, progress, levels, quests, state
end

return function(root)
    local suite = {}

    function suite:test_artisan_batches_use_real_skill_events_after_make_x_guard()
        for skill, level in pairs({
            SMITHING = 30,
            CRAFTING = 30,
            FLETCHING = 30,
            COOKING = 30,
            HERBLORE = 30,
            FIREMAKING = 30,
            RUNECRAFTING = 30,
            CONSTRUCTION = 40,
            INVENTION = 30,
        }) do
            local fake = client.new(root)
            local skills = fake.load("src/data/skills")
            for _, name in pairs(skills.NAMES) do
                fake.player.levels[skills.number(name)] = 120
            end
            local number = skills.number(skill)
            fake.player.levels[number] = level
            local progress = fake.load("src/storage/tip_progress")
            progress.use_character("test_player")
            progress.allow_existing_methods()
            local app = fake.load("src/app")
            app.start()
            fake.fire("Logic", { logicTick = 0 })
            fake.fire("MiniMenuEntrySelected", { entry = { actionType = 30, verbText = "Make" } })
            fake.fire("SkillTransmit", { skill = number, oldXP = 100, newXP = 110 })
            lu.assertEquals(#progress.recent_tips(), 0)
            for drop = 1, 3 do
                fake.fire("Logic", { logicTick = drop * 250 })
                fake.fire(
                    "SkillTransmit",
                    { skill = number, oldXP = 100 * drop + 10, newXP = 100 * drop + 20 }
                )
                if drop < 3 then
                    lu.assertEquals(#progress.recent_tips(), 0, skill)
                end
            end
            lu.assertEquals(#progress.recent_tips(), 1, skill)
            lu.assertStrContains(progress.recent_tips()[1].id, skill:lower() .. ".method.")
            app.stop()
        end
    end

    function suite:test_partial_sets_and_modified_heads_do_not_cross_teach_shared_categories()
        for _, case in ipairs({
            { "TRH85_FLETCHING_BOOTS", "fletching.fletcher_outfit", "crafting.artisan_outfit" },
            {
                "TRH28_CRAFTING_HEAD_UPGRADED",
                "crafting.artisan_outfit",
                "herblore.botanist_outfit",
            },
            {
                "TRH58_HERBLORE_HEAD_UPGRADED",
                "herblore.botanist_outfit",
                "cooking.sous_chef_outfit",
            },
            { "RDEN2_BOOTS", "herblore.factory_outfit", "herblore.botanist_outfit" },
            {
                "CON_ELITE_SKILLING_BOOTS",
                "construction.master_outfit",
                "construction.constructor_outfit",
            },
            {
                "TRH33_ETHEREAL_FEET_INFINITY",
                "runecrafting.ethereal_outfits",
                "runecrafting.master_robes",
            },
        }) do
            local fake, progress = world(root)
            fake.inventories[94] = { { item = case[1], category = 2739 } }
            fake.load("src/coach/item_knowledge").observe()
            lu.assertTrue(progress.is_known(case[2]), case[1])
            lu.assertFalse(progress.is_known(case[3]), case[1])
            fake.inventories[94] = {}
            progress.use_character("bob")
            progress.use_character("alice")
            lu.assertTrue(progress.is_known(case[2]))
        end
    end

    function suite:test_uncharged_upgrade_suppresses_basic_hammer_but_not_unowned_crystal_upgrade()
        local fake, progress = world(root)
        fake.inventories[94] = { { item = "INVENT_ENHANCED_HAMMER_UNCHARGED", category = -1 } }
        fake.load("src/coach/item_knowledge").observe()
        lu.assertTrue(progress.is_known("smithing.hammer_tron"))
        lu.assertFalse(progress.is_known("smithing.crystal_hammer"))
    end

    function suite:test_bought_binding_rod_input_does_not_require_eighty_crafting()
        local fake, _, levels, _, state = world(root)
        local tip = fake.load("src/tips/catalogue").get("runecrafting.binding_rod")
        levels.RUNECRAFTING, levels.INVENTION, levels.CRAFTING = 71, 22, 1
        local eligibility = fake.load("src/coach/eligibility")
        lu.assertTrue(eligibility.allows(tip, "RUNECRAFTING", state))
        levels.RUNECRAFTING = 70
        lu.assertFalse(eligibility.allows(tip, "RUNECRAFTING", state))
    end

    function suite:test_fenmoor_waits_for_both_skills_and_points_to_source_quest()
        local fake, _, levels, quests, state = world(root)
        local tip = fake.load("src/tips/catalogue").get("fletching.alt.fenmoor")
        local eligibility = fake.load("src/coach/eligibility")
        levels.FLETCHING, levels.WOODCUTTING = 65, 65
        lu.assertTrue(eligibility.allows(tip, "FLETCHING", state))
        quests.QUEST_WENDLE_HERALDS = false
        lu.assertTrue(eligibility.allows(tip, "FLETCHING", state))
        quests.QUEST_WENDLE_HERALDS = true
        lu.assertTrue(eligibility.allows(tip, "FLETCHING", state))
        levels.WOODCUTTING = 64
        lu.assertFalse(eligibility.allows(tip, "FLETCHING", state))
        levels.WOODCUTTING = nil
        lu.assertFalse(eligibility.allows(tip, "FLETCHING", state))
    end

    function suite:test_shared_quest_reward_checks_active_skill_and_completion()
        local fake, _, levels, quests, state = world(root)
        local tip = fake.load("src/tips/catalogue").get("shared.amulet_of_offerings")
        local eligibility = fake.load("src/coach/eligibility")
        quests.QUEST_AMASCUT = false
        levels.CRAFTING, levels.FLETCHING = 80, 79
        lu.assertTrue(eligibility.allows(tip, "CRAFTING", state))
        lu.assertFalse(eligibility.allows(tip, "FLETCHING", state))
        levels.FLETCHING = 80
        lu.assertTrue(eligibility.allows(tip, "FLETCHING", state))
        quests.QUEST_AMASCUT = true
        lu.assertFalse(eligibility.allows(tip, "CRAFTING", state))
    end

    function suite:test_infrequent_invention_siphons_do_not_weaken_reward_filtering()
        local tracker = client.new(root).load("src/game/skill_activity").new()
        lu.assertFalse(tracker.xp("INVENTION", 0))
        lu.assertFalse(tracker.xp("INVENTION", 121))
        lu.assertFalse(tracker.xp("INVENTION", 242))
        tracker.click({ action_type = 30, verb = "Continue" }, 243)
        lu.assertFalse(tracker.xp("INVENTION", 243))
        lu.assertFalse(tracker.xp("INVENTION", 244))
    end

    function suite:test_expansive_pouch_requires_divination_and_replaces_older_pouch_advice()
        local fake, progress, levels, _, state = world(root)
        local tip = fake.load("src/tips/catalogue").get("runecrafting.expansive_pouch")
        local eligibility = fake.load("src/coach/eligibility")
        levels.RUNECRAFTING, levels.DIVINATION = 105, 94
        lu.assertFalse(eligibility.allows(tip, "RUNECRAFTING", state))
        levels.DIVINATION = nil
        lu.assertFalse(eligibility.allows(tip, "RUNECRAFTING", state))
        levels.DIVINATION = 95
        lu.assertTrue(eligibility.allows(tip, "RUNECRAFTING", state))
        fake.inventories[94] = { { item = "RCU_POUCH_EXPANSIVE", category = 4222 } }
        fake.load("src/coach/item_knowledge").observe()
        lu.assertTrue(progress.is_known("runecrafting.expansive_pouch"))
        lu.assertTrue(progress.is_known("runecrafting.pouches"))
        lu.assertTrue(progress.is_known("runecrafting.catalyst"))
    end

    return suite
end
