local lu = require("luaunit")
local client = require("tests/support/client")

return function(root)
    local suite = {}

    function suite:test_start_hooks_up_the_ribbon_and_settings_panels()
        local fake = client.new(root)
        local app = fake.load("src/app")

        app.start()

        lu.assertEquals(fake.subscription_count("ContentLayerReady"), 1)
        lu.assertEquals(fake.subscription_count("SettingsLayerReady"), 1)
        lu.assertEquals(fake.subscription_count("SkillTransmit"), 1)
        lu.assertEquals(fake.logs[#fake.logs], "Skilling Coach started.")

        app.stop()
    end

    function suite:test_starting_twice_does_not_subscribe_twice()
        local fake = client.new(root)
        local app = fake.load("src/app")

        app.start()
        local after_first = fake.total_subscriptions()
        app.start()

        lu.assertEquals(fake.total_subscriptions(), after_first)
        lu.assertEquals(#fake.logs, 1)

        app.stop()
    end

    function suite:test_stop_unsubscribes_everything_and_destroys_open_views()
        local fake = client.new(root)
        local app = fake.load("src/app")

        app.start()
        fake.fire("ContentLayerReady", { component = {} })
        fake.fire("SettingsLayerReady", { component = {} })
        app.stop()

        lu.assertEquals(fake.total_subscriptions(), 0)
        lu.assertEquals(#fake.views, 2)
        lu.assertTrue(fake.views[1].destroyed)
        lu.assertTrue(fake.views[2].destroyed)
        lu.assertEquals(fake.logs[#fake.logs], "Skilling Coach stopped.")
    end

    function suite:test_reopening_the_ribbon_replaces_the_old_view()
        local fake = client.new(root)
        local app = fake.load("src/app")

        app.start()
        fake.fire("ContentLayerReady", { component = {} })
        fake.fire("ContentLayerReady", { component = {} })

        lu.assertTrue(fake.views[1].destroyed)
        lu.assertFalse(fake.views[2].destroyed)

        app.stop()
    end

    function suite:test_start_fails_clearly_without_prettyui()
        local fake = client.new(root)
        fake.environment.prettyui = nil
        local app = fake.load("src/app")

        lu.assertErrorMsgContains("needs PrettyUI", app.start)
    end

    function suite:test_character_switch_clears_old_card_and_restores_separate_progress()
        local fake = client.new(root)
        fake.player.name = "Alice"
        fake.inventories[95] = {}
        local app = fake.load("src/app")
        local engine = fake.load("src/coach/engine")
        local progress = fake.load("src/storage/tip_progress")
        local owned = fake.load("src/storage/owned_items")
        app.start()
        engine.on_backpack_full("MINING")
        lu.assertEquals(#fake.windows, 1)
        progress.pin("mining.ore_box")
        fake.player.name = "Bob"
        fake.inventories[95] = nil
        fake.fire("ServerLogic")
        lu.assertTrue(fake.windows[1].destroyed)
        lu.assertFalse(progress.is_pinned("mining.ore_box"))
        lu.assertFalse(progress.was_shown("mining.ore_box"))
        lu.assertFalse(owned.bank_seen())
        fake.inventories[95] = {}
        fake.fire("InventoryAdded", { inv = { id = 95 } })
        engine.on_backpack_full("MINING")
        lu.assertEquals(#fake.windows, 2)
        fake.player = nil
        fake.fire("ServerLogic")
        lu.assertTrue(fake.windows[2].destroyed)
        lu.assertFalse(owned.bank_seen())
        fake.player = { name = "Alice", levels = {} }
        fake.fire("ServerLogic")
        lu.assertTrue(progress.is_pinned("mining.ore_box"))
        app.stop()
    end

    function suite:test_character_change_before_server_poll_does_not_mix_xp_history()
        local fake = client.new(root)
        local app = fake.load("src/app")
        local engine = fake.load("src/coach/engine")
        local trained = {}
        engine.on_training = function(skill)
            trained[#trained + 1] = skill
        end
        app.start()
        local function xp()
            fake.fire("SkillTransmit", { skill = 14, oldXP = 100, newXP = 110 })
        end
        xp()
        xp()
        fake.player.name = "Bob"
        xp()
        lu.assertEquals(trained, {})
        xp()
        xp()
        lu.assertEquals(trained, { "MINING" })
        app.stop()
    end

    function suite:test_old_character_callback_cannot_switch_progress_after_restart()
        local fake = client.new(root)
        local app = fake.load("src/app")
        local progress = fake.load("src/storage/tip_progress")
        app.start()
        local old = fake.handlers.ServerLogic.skilling_coach_character
        app.stop()
        app.start()
        progress.pin("mining.ore_box")
        fake.player.name = "Bob"
        old()
        lu.assertTrue(progress.is_pinned("mining.ore_box"))
        fake.fire("ServerLogic")
        lu.assertFalse(progress.is_pinned("mining.ore_box"))
        app.stop()
        lu.assertEquals(fake.total_subscriptions(), 0)
    end

    function suite:test_reward_level_up_only_displays_after_real_training()
        local fake = client.new(root)
        local method = {
            id = "test.method",
            kind = "method",
            skills = { "MINING" },
            priority = 1,
            level_range = { 70, 79 },
            members = false,
            title = "Test method",
            hook = "Test benefit",
            why = "Test use",
            how = { "Test direction" },
            triggers = { { type = "level_reached", skill = "MINING", level = 70 } },
        }
        fake.load("src/tips/catalogue").for_skill = function()
            return { method }
        end
        local app = fake.load("src/app")
        local progress = fake.load("src/storage/tip_progress")
        fake.player.levels[14] = 70
        app.start()
        fake.fire("MiniMenuEntrySelected", { entry = { actionType = 30, verbText = "Confirm" } })
        fake.fire("SkillTransmit", {
            skill = 14,
            oldXP = 100,
            newXP = 200,
            oldGameplayLevel = 69,
            newGameplayLevel = 70,
        })
        lu.assertEquals(#fake.windows, 0)
        lu.assertEquals(progress.pending_level_up("MINING"), { old = 69, new = 70 })
        fake.fire("Logic", { logicTick = 1600 })
        fake.fire("MiniMenuEntrySelected", { entry = { verbText = "Mine", locData = {} } })
        for index = 1, 3 do
            fake.fire("Logic", { logicTick = 1600 + index * 150 })
            fake.fire("SkillTransmit", { skill = 14, oldXP = 200, newXP = 210 })
        end
        lu.assertEquals(#fake.windows, 1)
        lu.assertNil(progress.pending_level_up("MINING"))
        lu.assertEquals(fake.logs[#fake.logs], "Skilling Coach started.")
        app.stop()
    end

    return suite
end
