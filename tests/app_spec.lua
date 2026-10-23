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
        lu.assertEquals(fake.logs[#fake.logs], "Skilling Coach started.")

        app.stop()
    end

    function suite:test_starting_twice_does_not_subscribe_twice()
        local fake = client.new(root)
        local app = fake.load("src/app")

        app.start()
        app.start()

        lu.assertEquals(fake.subscription_count("ContentLayerReady"), 1)
        lu.assertEquals(#fake.logs, 1)

        app.stop()
    end

    function suite:test_stop_unsubscribes_and_destroys_open_views()
        local fake = client.new(root)
        local app = fake.load("src/app")

        app.start()
        fake.fire("ContentLayerReady", { component = {} })
        fake.fire("SettingsLayerReady", { component = {} })
        app.stop()

        lu.assertEquals(fake.subscription_count("ContentLayerReady"), 0)
        lu.assertEquals(fake.subscription_count("SettingsLayerReady"), 0)
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

    return suite
end
