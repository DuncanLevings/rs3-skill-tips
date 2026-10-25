-- the woodcutting, fishing and shared pilot tips going through the real engine

local lu = require("luaunit")
local client = require("tests/support/client")

local SKILL_NUMBERS = { MINING = 14, WOODCUTTING = 8, FISHING = 10 }

local function setup(root, skill, level)
    local fake = client.new(root)
    local shown = {}

    fake.player.levels[SKILL_NUMBERS[skill]] = level

    local owned_items = fake.load("src/storage/owned_items")
    local tip_progress = fake.load("src/storage/tip_progress")
    local engine = fake.load("src/coach/engine")

    owned_items.use_character("alice")
    tip_progress.use_character("alice")
    owned_items.update_from_bank({}, {}, function()
        return 0
    end, function()
        return 0
    end)

    engine.start({
        state = fake.load("src/game/player_state"),
        now = function()
            return 1000
        end,
        show_card = function(tip, handlers)
            shown[#shown + 1] = { tip = tip, handlers = handlers }
        end,
    })

    return fake, engine, shown
end

local function first_tip(root, skill, level)
    local _, engine, shown = setup(root, skill, level)
    engine.on_training(skill)
    return shown[1] and shown[1].tip.id
end

return function(root)
    local suite = {}

    function suite:test_woodcutting_brackets()
        lu.assertEquals(first_tip(root, "WOODCUTTING", 25), "woodcutting.method.willow")
        lu.assertEquals(first_tip(root, "WOODCUTTING", 70), "woodcutting.method.choking_ivy")
        lu.assertEquals(first_tip(root, "WOODCUTTING", 101), "woodcutting.method.eternal_magic")
    end

    function suite:test_fishing_brackets()
        lu.assertEquals(first_tip(root, "FISHING", 45), "fishing.method.fly_fishing")
        lu.assertEquals(first_tip(root, "FISHING", 90), "fishing.method.croesus_front")
        lu.assertEquals(first_tip(root, "FISHING", 95), "fishing.method.fishing_frenzy")
        -- at exactly 99 the cape is the closer match, which is the right moment for it
        lu.assertEquals(first_tip(root, "FISHING", 99), "fishing.cape")
    end

    function suite:test_wood_box_only_on_a_full_backpack()
        local _, engine, shown = setup(root, "WOODCUTTING", 30)

        engine.on_training("WOODCUTTING")
        lu.assertNotEquals(shown[1].tip.id, "woodcutting.wood_box")

        local _, box_engine, box_shown = setup(root, "WOODCUTTING", 30)
        box_engine.on_backpack_full("WOODCUTTING")
        lu.assertEquals(box_shown[1].tip.id, "woodcutting.wood_box")
    end

    function suite:test_shared_tips_are_reachable_from_every_gathering_skill()
        local fake = client.new(root)
        local catalogue = fake.load("src/tips/catalogue")

        for _, skill in ipairs({ "MINING", "WOODCUTTING", "FISHING" }) do
            local ids = {}

            for _, tip in ipairs(catalogue.for_skill(skill)) do
                ids[tip.id] = true
            end

            lu.assertTrue(ids["shared.grace_of_the_elves"], skill)
            lu.assertTrue(ids["shared.crystallise"], skill)
        end
    end

    function suite:test_owning_grace_hides_it_for_every_skill()
        local fake = client.new(root)
        local eligibility = fake.load("src/coach/eligibility")
        local grace = fake.load("src/tips/catalogue").get("shared.grace_of_the_elves")
        local state = fake.load("src/game/player_state")
        fake.load("src/storage/owned_items").update_from_bank({}, {}, function()
            return 0
        end, function()
            return 0
        end)

        fake.player.levels[10] = 80
        fake.player.levels[14] = 80
        lu.assertTrue(eligibility.allows(grace, "FISHING", state))

        fake.inventories[94] = { { item = "ALCH_ONYX_SKILL_NECKLACE_USED" } }

        lu.assertFalse(eligibility.allows(grace, "FISHING", state))
        lu.assertFalse(eligibility.allows(grace, "MINING", state))
    end

    function suite:test_expensive_items_wait_for_the_active_skill()
        local fake = client.new(root)
        local eligibility = fake.load("src/coach/eligibility")
        local catalogue = fake.load("src/tips/catalogue")
        local levels = { MINING = 79, FISHING = 80, WOODCUTTING = 1 }
        local state = {
            level = function(skill)
                return levels[skill]
            end,
            owns_item = function()
                return false
            end,
            owns_category = function()
                return false
            end,
        }
        fake.load("src/storage/owned_items").update_from_bank({}, {}, function()
            return 0
        end, function()
            return 0
        end)

        local grace = catalogue.get("shared.grace_of_the_elves")
        local brooch = catalogue.get("mining.brooch_of_the_gods")
        lu.assertFalse(eligibility.allows(grace, "MINING", state))
        lu.assertFalse(eligibility.allows(brooch, "MINING", state))
        lu.assertTrue(eligibility.allows(grace, "FISHING", state))
        lu.assertFalse(eligibility.allows(grace, "WOODCUTTING", state))
        levels.MINING = 80
        lu.assertTrue(eligibility.allows(grace, "MINING", state))
        lu.assertTrue(eligibility.allows(brooch, "MINING", state))
        levels.MINING = nil
        lu.assertFalse(eligibility.allows(brooch, "MINING", state))
        lu.assertEquals(eligibility.stage(grace), "late")
    end

    function suite:test_varrock_armour_waits_for_every_diary_skill()
        local fake = client.new(root)
        local eligibility = fake.load("src/coach/eligibility")
        local tip = fake.load("src/tips/catalogue").get("mining.varrock_armour")
        local levels = { AGILITY = 13, CRAFTING = 8, FISHING = 20, MINING = 10 }
        local state = {
            level = function(skill)
                return levels[skill]
            end,
            owns_item = function()
                return false
            end,
        }
        fake.load("src/storage/owned_items").update_from_bank({}, {}, function()
            return 0
        end, function()
            return 0
        end)

        lu.assertTrue(eligibility.allows(tip, "MINING", state))
        for skill, needed in pairs(tip.requirements.skills) do
            levels[skill] = needed - 1
            lu.assertFalse(eligibility.allows(tip, "MINING", state), skill)
            levels[skill] = nil
            lu.assertFalse(eligibility.allows(tip, "MINING", state), skill)
            levels[skill] = needed
        end
    end

    function suite:test_scripture_waits_for_boss_access_and_active_skill()
        local fake = client.new(root)
        local eligibility = fake.load("src/coach/eligibility")
        local tip = fake.load("src/tips/catalogue").get("shared.scripture_of_elidinis")
        local levels = { MINING = 80, FISHING = 80, WOODCUTTING = 80 }
        for _, skill in ipairs(tip.skills) do
            levels[skill] = 80
        end
        for skill, needed in pairs(tip.requirements.skills) do
            levels[skill] = math.max(levels[skill] or 0, needed)
        end
        ---@type boolean?
        local finished = true
        local state = {
            level = function(skill)
                return levels[skill]
            end,
            quest_done = function(quest)
                lu.assertEquals(quest, "QUEST_AMASCUT")
                return finished
            end,
            owns_item = function()
                return false
            end,
        }
        fake.load("src/storage/owned_items").update_from_bank({}, {}, function()
            return 0
        end, function()
            return 0
        end)
        for _, skill in ipairs(tip.skills) do
            lu.assertTrue(eligibility.allows(tip, skill, state))
            local original = levels[skill]
            levels[skill] = 79
            lu.assertFalse(eligibility.allows(tip, skill, state))
            levels[skill] = original
        end
        for skill, needed in pairs(tip.requirements.skills) do
            levels[skill] = needed - 1
            lu.assertFalse(eligibility.allows(tip, "MINING", state), skill)
            levels[skill] = nil
            lu.assertFalse(eligibility.allows(tip, "MINING", state), skill)
            levels[skill] = needed
        end
        finished = false
        lu.assertTrue(eligibility.allows(tip, "MINING", state))
        finished = nil
        lu.assertTrue(eligibility.allows(tip, "MINING", state))
    end

    function suite:test_reward_and_cross_skill_gates()
        local fake = client.new(root)
        local eligibility = fake.load("src/coach/eligibility")
        local catalogue = fake.load("src/tips/catalogue")
        fake.load("src/storage/owned_items").update_from_bank({}, {}, function()
            return 0
        end, function()
            return 0
        end)
        local ids = {
            "shared.ring_of_whispers",
            "shared.crystallise",
            "mining.golden_mining_suit",
            "mining.pontifex_ring",
            "mining.golem_outfit",
            "woodcutting.lumberjack_outfit",
            "woodcutting.strung_rabbit_foot",
            "woodcutting.sentinel_outfit",
            "fishing.shark_outfit",
            "fishing.dragon_harpoon",
            "fishing.crystal_fishing_rod",
            "fishing.rod_o_matic",
        }
        for _, id in ipairs(ids) do
            local tip = catalogue.get(id)
            local levels, quests = {}, {}
            for skill, needed in pairs((tip.requirements or {}).skills or {}) do
                levels[skill] = needed
            end
            for _, quest in ipairs((tip.requirements or {}).quests or {}) do
                quests[quest] = false
            end
            local active = tip.skills[1]
            levels[active] = levels[active] or 80
            local state = {
                level = function(skill)
                    return levels[skill]
                end,
                quest_done = function(quest)
                    return quests[quest]
                end,
                owns_item = function()
                    return false
                end,
                owns_category = function()
                    return false
                end,
            }
            lu.assertTrue(eligibility.allows(tip, active, state), id)
            if tip.require_all_levels then
                for skill, needed in pairs(tip.requirements.skills) do
                    levels[skill] = needed - 1
                    lu.assertFalse(eligibility.allows(tip, active, state), id .. ": " .. skill)
                    levels[skill] = needed
                end
            end
            if tip.require_quests_complete then
                for _, quest in ipairs(tip.requirements.quests) do
                    quests[quest] = false
                    lu.assertFalse(eligibility.allows(tip, active, state), id)
                    quests[quest] = nil
                    lu.assertFalse(eligibility.allows(tip, active, state), id)
                    quests[quest] = false
                end
            end
        end
    end

    return suite
end
