-- outfits whose pieces share item categories, upgraded tools and account-access gates.
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
    local levels, quests, owned = {}, {}, {}
    local skills = fake.load("src/data/skills")
    for _, skill in pairs(skills.NAMES) do
        levels[skill] = 120
    end
    local state = {
        level = function(skill)
            return levels[skill]
        end,
        quest_done = function(quest)
            return quests[quest]
        end,
        owns_item = function(config)
            return owned[config] == true
        end,
    }
    return fake, progress, levels, quests, owned, state
end

return function(root)
    local suite = {}

    function suite:test_shared_basic_outfit_category_never_cross_teaches_another_skill()
        for _, case in ipairs({
            {
                "TRH58_FARMING_HEAD_UPGRADED",
                "farming.farmers_outfit",
                "divination.diviners_outfit",
            },
            {
                "WOF55_SKILL_DIVINATION_HANDS",
                "divination.diviners_outfit",
                "farming.farmers_outfit",
            },
        }) do
            local fake, progress = world(root)
            fake.inventories[94] = { { item = case[1], category = 2739 } }
            fake.load("src/coach/item_knowledge").observe()
            lu.assertTrue(progress.is_known(case[2]))
            lu.assertFalse(progress.is_known(case[3]))
        end
    end

    function suite:test_single_piece_from_every_elite_variant_teaches_the_family()
        for _, case in ipairs({
            { "TRH127_DESERT_FEET", 4174, "hunter.trapper_outfits" },
            { "TRH127_JUNGLE_HANDS", 4175, "hunter.trapper_outfits" },
            { "TRH127_ARCTIC_BODY", 4176, "hunter.trapper_outfits" },
            { "TRH127_VOLCANIC_LEGS", 4177, "hunter.trapper_outfits" },
            { "TRH75_ENERGY_FEET", 3698, "divination.divination_outfits" },
            { "TRH75_CHRONICLE_BODY", 3699, "divination.divination_outfits" },
            { "TRH75_MEMORY_HANDS", 3700, "divination.divination_outfits" },
            { "TRH75_ELDER_LEGS", 3701, "divination.divination_outfits" },
            { "POF_REWARDS_TRH_ANIMALS_HANDS", 4361, "farming.master_outfit" },
            { "POF_REWARDS_TRH_CROPS_BODY", 4362, "farming.master_outfit" },
            { "POF_REWARDS_TRH_TREES_FEET", 4363, "farming.master_outfit" },
            { "POF_REWARDS_TRH_MASTER_LEGS", 4364, "farming.master_outfit" },
        }) do
            local fake, progress = world(root)
            fake.inventories[94] = { { item = case[1], category = case[2] } }
            fake.load("src/coach/item_knowledge").observe()
            lu.assertTrue(progress.is_known(case[3]), case[1])
        end
    end

    function suite:test_augmented_higher_mattocks_suppress_earlier_upgrade_advice()
        local fake, progress = world(root)
        fake.inventories[94] =
            { { item = "TIME_SPACE_MATTOCK_AUGMENTED_UNCHARGED", category = 4604 } }
        fake.load("src/coach/item_knowledge").observe()
        for _, key in ipairs({
            "dragon_mattock",
            "crystal_mattock",
            "imcando_mattock",
            "time_space_mattock",
        }) do
            lu.assertTrue(progress.is_known("archaeology." .. key), key)
        end
        local another, separate = world(root)
        another.inventories[94] = { { item = "DRAGON_MATTOCK_AUGMENTED", category = 4604 } }
        another.load("src/coach/item_knowledge").observe()
        lu.assertTrue(separate.is_known("archaeology.dragon_mattock"))
        lu.assertFalse(separate.is_known("archaeology.crystal_mattock"))
    end

    function suite:test_combined_fragment_covers_both_hunter_and_farming()
        local fake, progress = world(root)
        fake.inventories[94] = { { item = "QUEST_ENDGAME_SHARD_COMBINED", category = -1 } }
        fake.load("src/coach/item_knowledge").observe()
        lu.assertTrue(progress.is_known("hunter.catalyst_fragment"))
        lu.assertTrue(progress.is_known("farming.catalyst_fragment"))
        lu.assertFalse(progress.is_known("farming.magic_watering_can"))
    end

    function suite:test_hooded_retro_cape_uses_the_correct_native_id_and_does_not_hide_other_capes()
        local fake, progress = world(root)
        fake.inventories[94] = { { item = "SKILLCAPE_ARCHAEOLOGY_HOODED_RETRO", category = 27 } }
        fake.load("src/coach/item_knowledge").observe()
        lu.assertTrue(progress.is_known("archaeology.cape"))
        lu.assertFalse(progress.is_known("farming.cape"))
        lu.assertFalse(progress.is_known("archaeology.master_cape"))
    end

    function suite:test_critical_source_levels_defer_when_low_or_unknown()
        for _, case in ipairs({
            {
                "hunter.hypnowand",
                "HUNTER",
                { HUNTER = 80, ARCHAEOLOGY = 103, DUNGEONEERING = 95 },
            },
            { "archaeology.sash_brush", "ARCHAEOLOGY", { ARCHAEOLOGY = 103, DUNGEONEERING = 95 } },
            { "archaeology.auto_screener", "ARCHAEOLOGY", { ARCHAEOLOGY = 70, INVENTION = 67 } },
            {
                "divination.divine_conversion",
                "DIVINATION",
                { DIVINATION = 85, ARCHAEOLOGY = 98, INVENTION = 86 },
                "WORLD_WAKES",
            },
            {
                "divination.memory_dowser",
                "DIVINATION",
                { DIVINATION = 80, ARCHAEOLOGY = 86 },
                "QUEST_AMASCUT",
            },
        }) do
            local fake, _, levels, quests, _, state = world(root)
            local tip = fake.load("src/tips/catalogue").get(case[1])
            local eligibility = fake.load("src/coach/eligibility")
            for _, quest in ipairs((tip.requirements or {}).quests or {}) do
                quests[quest] = true
            end
            for skill, needed in pairs(case[3]) do
                levels[skill] = needed
            end
            lu.assertTrue(eligibility.allows(tip, case[2], state), case[1])
            for skill, needed in pairs(case[3]) do
                levels[skill] = needed - 1
                lu.assertFalse(eligibility.allows(tip, case[2], state), case[1] .. skill)
                levels[skill] = nil
                lu.assertFalse(eligibility.allows(tip, case[2], state), case[1] .. skill)
                levels[skill] = needed
            end
            if case[4] then
                quests[case[4]] = nil
                lu.assertTrue(eligibility.allows(tip, case[2], state))
                quests[case[4]] = false
                lu.assertTrue(eligibility.allows(tip, case[2], state))
            end
        end
    end

    function suite:test_starting_level_does_not_hide_new_discoveries_or_alternatives()
        local fake, progress, _, quests, _, state = world(root)
        progress.capture_starting_levels(state)
        quests.EAGLES_PEAK = true
        local catalogue = fake.load("src/tips/catalogue")
        local eligibility = fake.load("src/coach/eligibility")
        for _, case in ipairs({
            { "hunter.alt.birdhouses", "HUNTER" },
            { "hunter.alt.skillchompas", "HUNTER" },
            { "divination.alt.guthixian_cache", "DIVINATION" },
            { "farming.alt.player_owned_farm", "FARMING" },
            { "archaeology.soil_box", "ARCHAEOLOGY" },
        }) do
            lu.assertTrue(eligibility.allows(catalogue.get(case[1]), case[2], state), case[1])
        end
    end

    function suite:test_observed_outfits_remain_known_after_destroying_and_reloading()
        local fake, progress = world(root)
        fake.inventories[94] = { { item = "ARCH_ELITE_SKILLING_BOOTS", category = 4611 } }
        fake.load("src/coach/item_knowledge").observe()
        fake.inventories[94] = {}
        progress.use_character("bob")
        lu.assertFalse(progress.is_known("archaeology.master_outfit"))
        progress.use_character("alice")
        lu.assertTrue(progress.is_known("archaeology.master_outfit"))
    end

    function suite:test_engram_relevance_waits_for_seventy_without_inventing_a_use_requirement()
        local fake, _, levels, _, _, state = world(root)
        local tip = fake.load("src/tips/catalogue").get("divination.alt.charging_engrams")
        local eligibility = fake.load("src/coach/eligibility")
        lu.assertEquals(tip.requirements.skills.DIVINATION, 1)
        lu.assertEquals(tip.min_training_level, 70)
        for _, level in ipairs({ 1, 35, 69 }) do
            levels.DIVINATION = level
            lu.assertFalse(eligibility.allows(tip, "DIVINATION", state))
        end
        levels.DIVINATION = 70
        lu.assertTrue(eligibility.allows(tip, "DIVINATION", state))
    end

    function suite:test_bought_birdhouses_do_not_require_crafting_or_fletching()
        local fake, _, levels, _, _, state = world(root)
        local tip = fake.load("src/tips/catalogue").get("hunter.alt.birdhouses")
        local eligibility = fake.load("src/coach/eligibility")
        levels.HUNTER, levels.CRAFTING, levels.FLETCHING = 5, 1, 1
        lu.assertTrue(eligibility.allows(tip, "HUNTER", state))
        levels.HUNTER = 4
        lu.assertFalse(eligibility.allows(tip, "HUNTER", state))
    end

    function suite:test_gathering_alternatives_enforce_declared_levels_and_source_quests()
        local fake, _, levels, quests, _, state = world(root)
        local catalogue = fake.load("src/tips/catalogue")
        local eligibility = fake.load("src/coach/eligibility")
        local checked = 0
        local gathering = { HUNTER = true, DIVINATION = true, ARCHAEOLOGY = true, FARMING = true }
        for _, tip in ipairs(catalogue.all()) do
            local skill = tip.skills[1]
            if gathering[skill] and tip.kind == "method" and not tip.main_method then
                levels[skill] = tip.level_range[1]
                for _, quest in
                    ipairs(tip.require_quests_complete and (tip.requirements or {}).quests or {})
                do
                    quests[quest] = true
                end
                lu.assertTrue(eligibility.allows(tip, skill, state), tip.id)
                for required, minimum in pairs((tip.requirements or {}).skills or {}) do
                    local original = levels[required]
                    levels[required] = minimum - 1
                    lu.assertFalse(eligibility.allows(tip, skill, state), tip.id .. required)
                    levels[required] = nil
                    lu.assertFalse(eligibility.allows(tip, skill, state), tip.id .. required)
                    levels[required] = original
                end
                for _, quest in
                    ipairs(tip.require_quests_complete and (tip.requirements or {}).quests or {})
                do
                    quests[quest] = false
                    lu.assertFalse(eligibility.allows(tip, skill, state), tip.id .. quest)
                    quests[quest] = nil
                    lu.assertFalse(eligibility.allows(tip, skill, state), tip.id .. quest)
                    quests[quest] = true
                end
                checked = checked + 1
                levels[skill] = 120
            end
        end
        lu.assertTrue(checked >= 37)
    end

    return suite
end
