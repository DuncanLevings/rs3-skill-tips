local lu = require("luaunit")
local client = require("tests/support/client")

return function(root)
    local suite = {}

    local function bank_world()
        local fake = client.new(root)
        fake.player.name = "Alice"
        fake.load("src/tips/catalogue").load()
        return fake, fake.load("src/game/inventories"), fake.load("src/storage/owned_items")
    end

    function suite:test_open_bank_is_snapshotted_on_start_and_retained_after_closing()
        local fake, inventories, owned = bank_world()
        fake.inventories[95] = {
            { item = "MINING_OREBOX_IRON", category = 4448 },
            { item = "COINS", count = 100 },
        }
        inventories.start()
        lu.assertTrue(owned.bank_seen())
        lu.assertTrue(owned.in_bank("MINING_OREBOX_IRON"))
        lu.assertTrue(owned.category_in_bank(4448))
        lu.assertFalse(owned.in_bank("COINS"))
        fake.inventories[95] = nil
        fake.fire("InventoryUpdated", { inv = { id = 95 } })
        lu.assertTrue(owned.in_bank("MINING_OREBOX_IRON"))
        fake.inventories[95] = {}
        fake.fire("InventoryAdded", { inv = { id = 95 } })
        lu.assertFalse(owned.in_bank("MINING_OREBOX_IRON"))
        lu.assertFalse(owned.category_in_bank(4448))
        lu.assertEquals(fake.logs, {})
    end

    function suite:test_bank_event_before_character_poll_is_saved_to_the_new_character()
        local fake, inventories, owned = bank_world()
        fake.inventories[95] = { { item = "MINING_OREBOX_IRON" } }
        inventories.start()
        fake.player.name = "Bob"
        fake.inventories[95] = {}
        fake.fire("InventoryUpdated", { inv = { id = 95 } })
        lu.assertFalse(owned.in_bank("MINING_OREBOX_IRON"))
        owned.use_character("alice")
        lu.assertTrue(owned.in_bank("MINING_OREBOX_IRON"))
        owned.use_character("bob")
        lu.assertTrue(owned.bank_seen())
        lu.assertFalse(owned.in_bank("MINING_OREBOX_IRON"))
    end

    function suite:test_logged_out_bank_and_callbacks_from_old_owner_do_nothing()
        local fake, inventories, owned = bank_world()
        inventories.start()
        inventories.start()
        lu.assertEquals(fake.subscription_count("InventoryAdded"), 1)
        local old = fake.handlers.InventoryAdded.skilling_coach_inventories
        inventories.stop()
        inventories.start()
        fake.inventories[95] = { { item = "MINING_OREBOX_IRON" } }
        old({ inv = { id = 95 } })
        lu.assertFalse(owned.bank_seen())
        fake.player = nil
        fake.fire("InventoryAdded", { inv = { id = 95 } })
        lu.assertFalse(owned.bank_seen())
        inventories.stop()
        lu.assertEquals(fake.total_subscriptions(), 0)
        lu.assertEquals(fake.logs, {})
    end

    function suite:test_missing_and_expired_native_inventory_reads_are_safe()
        local lookups = {
            function()
                error("expired native inventory")
            end,
            function()
                return setmetatable({}, {
                    __index = function()
                        error("expired property")
                    end,
                })
            end,
            function()
                return {
                    isValid = true,
                    GetTotal = function()
                        return nil
                    end,
                    GetCategoryTotal = function()
                        return nil
                    end,
                }
            end,
        }
        for _, lookup in ipairs(lookups) do
            local fake, inventories = bank_world()
            fake.environment.Inventory.Find = lookup
            lu.assertFalse(inventories.carrying_item("MINING_OREBOX_IRON"))
            lu.assertFalse(inventories.carrying_category(4448))
            lu.assertNil(inventories.backpack_free_slots())
        end
    end

    function suite:test_player_vars_quests_and_achievements_preserve_false_and_fail_safely()
        local fake = client.new(root)
        local state = fake.load("src/game/player_state")
        fake.varbits.MY_VAR = 0
        fake.quests.MY_QUEST = { hasFinishedQuest = false, name = "A quest" }
        fake.achievements.MY_ACHIEVEMENT = { progress = 0 }
        fake.player.levels[14] = 42
        lu.assertEquals(state.level("MINING"), 42)
        lu.assertNil(state.level("NOT_A_SKILL"))
        lu.assertEquals(state.varbit("MY_VAR"), 0)
        lu.assertFalse(state.quest_done("MY_QUEST"))
        lu.assertEquals(state.quest_name("MY_QUEST"), "A quest")
        lu.assertFalse(state.achievement_done("MY_ACHIEVEMENT"))
        fake.achievements.MY_ACHIEVEMENT.progress = -2
        lu.assertTrue(state.achievement_done("MY_ACHIEVEMENT"))
        lu.assertNil(state.varbit("MISSING"))
        lu.assertNil(state.quest_done("MISSING"))
        lu.assertNil(state.achievement_done("MISSING"))
        fake.environment.var.VarPlayer = setmetatable({}, {
            __index = function()
                error("unavailable native var")
            end,
        })
        lu.assertNil(state.varbit("MY_VAR"))
        fake.player = nil
        lu.assertNil(state.level("MINING"))
        lu.assertNil(state.quest_done("MY_QUEST"))
        lu.assertNil(state.achievement_done("MY_ACHIEVEMENT"))
    end

    function suite:test_clock_ignores_queued_callbacks_after_stop_and_restart()
        local fake = client.new(root)
        local clock = fake.load("src/game/clock")
        clock.start()
        clock.start()
        lu.assertEquals(fake.subscription_count("Logic"), 1)
        fake.fire("Logic", { logicTick = 500 })
        lu.assertEquals(clock.now(), 10)
        local old = fake.handlers.Logic.skilling_coach_clock
        clock.stop()
        clock.start()
        old({ logicTick = 1000 })
        lu.assertEquals(clock.now(), 0)
        fake.fire("Logic", { logicTick = 50 })
        lu.assertEquals(clock.now(), 1)
        clock.stop()
        lu.assertEquals(fake.total_subscriptions(), 0)
    end

    return suite
end
