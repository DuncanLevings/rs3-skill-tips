local lu = require("luaunit")
local client = require("tests/support/client")

local function world(root)
    local fake = client.new(root)
    local app = fake.load("src/app")
    app.start()
    return fake, app, fake.load("src/storage/tip_progress"), fake.load("src/ui/coach_window")
end

local function controls(fake)
    local result = {}
    for _, tooltip in ipairs(fake.tooltips or {}) do
        local image = tooltip.target
        result[#result + 1] = {
            root = image.parent,
            image = image,
            tooltip = tooltip,
            action = image.hooks.ONCLICK,
            options = image.parent,
        }
    end
    return result
end

return function(root)
    local suite = {}

    function suite:test_pinned_rows_are_narrow_minimal_and_unpin_immediately()
        local fake, app, progress, coach = world(root)
        progress.pin("mining.ore_box")
        coach.open()
        local window = fake.windows[1]
        lu.assertTrue(window.options.width >= 200 and window.options.width <= 320)
        lu.assertEquals(fake.labels[1].options.text, "Ore box")
        lu.assertNil(fake.labels[1].options.text:find("Backpack", 1, true))
        local unpin = controls(fake)[1]
        lu.assertEquals(unpin.tooltip.options.text, "Unpin Ore box")
        lu.assertEquals(unpin.options.width, 24)
        local title = fake.labels[1].options
        lu.assertEquals(unpin.root.x_anchor, 1)
        local action_x = window.content.width + unpin.options.x
        lu.assertTrue(action_x - title.x - title.width >= 20)
        lu.assertEquals(window.content.width - action_x - unpin.options.width, 4)
        lu.assertTrue(window.options.height >= 96)
        lu.assertEquals(unpin.image.alpha, 0.65)
        unpin.action()
        lu.assertEquals(progress.pinned_ids(), {})
        lu.assertTrue(window.destroyed)
        lu.assertTrue(unpin.root.destroyed)
        lu.assertTrue(fake.windows[2].options.height >= 100)
        lu.assertEquals(fake.windows[2].options.width, 240)
        app.stop()
        lu.assertEquals(fake.total_subscriptions(), 0)
    end

    function suite:test_close_preserves_pins_and_drag_position_survives_reopen()
        local fake, app, progress, coach = world(root)
        progress.pin("mining.ore_box")
        coach.open()
        local window = fake.windows[1]
        lu.assertNil(fake.layers and fake.layers[1].hooks.ONHOLD)
        local initial_x = window.root.x
        window.root:SetPos(initial_x - 50, window.root.y + 20)
        lu.assertEquals(window.root.x, initial_x - 50)
        local moved_x, moved_y = window.root.x, window.root.y
        window:Close()
        lu.assertTrue(progress.is_pinned("mining.ore_box"))
        coach.open()
        local reopened = fake.windows[#fake.windows]
        lu.assertAlmostEquals(reopened.root.x, moved_x, 1)
        lu.assertAlmostEquals(reopened.root.y, moved_y, 1)
        lu.assertNil(fake.saved.skilling_coach_card)
        app.stop()
    end

    function suite:test_many_and_long_titles_cap_height_scroll_and_shrink_after_unpin()
        local fake, app, progress, coach = world(root)
        local catalogue = fake.load("src/tips/catalogue")
        local real_get = catalogue.get
        catalogue.get = function(id)
            return id:match("^tip") and { id = id, title = string.rep("A long title ", 6) }
                or real_get(id)
        end
        for index = 1, 12 do
            progress.pin("tip" .. index)
        end
        coach.open()
        local window = fake.windows[1]
        lu.assertTrue(window.options.width >= 200 and window.options.width <= 320)
        lu.assertTrue(window.options.height <= 420)
        lu.assertTrue(window.contentHeight > window.root.height)
        lu.assertTrue(fake.labels[1].options.height > 32)
        window:ScrollBy(32)
        lu.assertEquals(window.scrollY, 32)
        for index = 1, 11 do
            progress.unpin("tip" .. index)
        end
        lu.assertTrue(fake.windows[#fake.windows].options.height < window.options.height)
        app.stop()
    end

    function suite:test_old_unpin_and_geometry_callbacks_do_not_affect_a_new_character()
        local fake, app, progress, coach = world(root)
        progress.pin("mining.ore_box")
        coach.open()
        local old_unpin = controls(fake)[1].action
        local old_tick = fake.handlers.Logic.skilling_coach_content_geometry
        fake.player.name = "Bob"
        fake.fire("ServerLogic")
        progress.pin("mining.ore_box")
        old_unpin()
        old_tick({ logicTick = 25 })
        lu.assertTrue(progress.is_pinned("mining.ore_box"))
        fake.player = nil
        fake.fire("ServerLogic")
        lu.assertTrue(fake.windows[#fake.windows].destroyed)
        app.stop()
    end

    function suite:test_game_resize_caps_window_and_keeps_it_on_screen()
        local fake, app, progress, coach = world(root)
        progress.pin("mining.ore_box")
        coach.open()
        fake.game_area.width, fake.game_area.height = 240, 160
        fake.fire("Logic", { logicTick = 25 })
        local window = fake.windows[#fake.windows]
        lu.assertTrue(window.root.width <= 240)
        lu.assertTrue(window.root.height <= 96)
        lu.assertTrue(window.root.x >= 0 and window.root.x + window.root.width <= 240)
        lu.assertTrue(window.root.y >= 0 and window.root.y + window.root.height <= 160)
        app.stop()
    end

    function suite:test_history_keeps_last_ten_without_reversing_dismissals_or_pins()
        local fake, app, progress = world(root)
        progress.dismiss("first")
        progress.pin("tip")
        for index = 1, 12 do
            progress.mark_shown("tip" .. index)
        end
        local recent = progress.recent_tips()
        lu.assertEquals(#recent, 10)
        lu.assertEquals(recent[1].id, "tip12")
        lu.assertEquals(recent[10].id, "tip3")
        recent[1].id = "changed"
        lu.assertEquals(progress.recent_tips()[1].id, "tip12")
        progress.use_character("bob")
        lu.assertEquals(progress.recent_tips(), {})
        progress.use_character("test_player")
        lu.assertEquals(#progress.recent_tips(), 10)
        lu.assertTrue(progress.is_dismissed("first"))
        lu.assertTrue(progress.is_pinned("tip"))
        app.stop()
        local reload = client.new(root)
        reload.saved = fake.saved
        local loaded = reload.load("src/storage/tip_progress")
        loaded.use_character("test_player")
        lu.assertEquals(loaded.recent_tips()[1].id, "tip12")
        lu.assertTrue(loaded.is_dismissed("first"))
    end

    function suite:test_corrupt_history_recovers_without_losing_other_progress()
        local fake = client.new(root)
        fake.saved.skilling_coach_progress_alice = {
            version = 1,
            pinned = { tip = true },
            dismissed = { hidden = true },
            recent_tips = {
                false,
                { id = "good", order = 4 },
                { id = "", order = 5 },
                { id = "bad", order = "bad" },
            },
            queued_quests = { good = true, bad = 1 },
        }
        local progress = fake.load("src/storage/tip_progress")
        progress.use_character("alice")
        lu.assertEquals(progress.recent_tips(), { { id = "good", order = 4 } })
        lu.assertEquals(progress.queued_quests(), { good = true })
        lu.assertTrue(progress.is_pinned("tip"))
        lu.assertTrue(progress.is_dismissed("hidden"))
    end

    function suite:test_ribbon_is_only_a_launcher_and_history_is_its_own_window()
        local fake, app, progress = world(root)
        fake.fire("ContentLayerReady", { component = {} })
        local view = fake.views[1]
        lu.assertEquals(#fake.windows, 0)
        lu.assertEquals(#view.buttons, 2)
        lu.assertEquals(view.buttons[1].text, "Pinned tips")
        lu.assertEquals(view.buttons[2].text, "Recent tips")
        lu.assertEquals(view.texts[1].text, "Skilling Coach")
        lu.assertTrue(view.buttons[1].options.width > 0)
        lu.assertEquals(view.buttons[1].options.width, view.buttons[2].options.width)
        progress.mark_shown("mining.ore_box")
        lu.assertEquals(#fake.windows, 0)
        view.buttons[2].action()
        local history_window = fake.windows[1]
        lu.assertEquals(history_window.options.title, "Recent tips")
        lu.assertEquals(fake.labels[1].options.text, "Ore box")
        local item, title, body = fake.sprites[1], fake.labels[1].options, fake.labels[2].options
        lu.assertEquals(item.object_id, 123)
        lu.assertEquals(title.x - item.x - item.width, 8)
        lu.assertEquals(title.y + title.height / 2, item.y + item.height / 2)
        lu.assertTrue(body.y >= item.y + item.height + 4)
        lu.assertEquals(controls(fake)[1].tooltip.options.text, "Pin tip")
        progress.mark_shown("removed.tip")
        lu.assertEquals(fake.load("src/ui/recent_history").rows()[1].id, "mining.ore_box")
        app.stop()
        lu.assertTrue(history_window.destroyed)
        lu.assertEquals(fake.total_subscriptions(), 0)
    end

    function suite:test_settings_have_live_controls_and_no_production_reset()
        local fake, app = world(root)
        fake.fire("SettingsLayerReady", { component = {} })
        local view = fake.views[1]
        for _, button in ipairs(view.buttons) do
            lu.assertNil(button.text:lower():find("dismiss", 1, true))
            lu.assertNil(button.text:lower():find("restore", 1, true))
        end
        local settings = fake.load("src/storage/settings")
        fake.checkboxes[1].options.onChange(nil, {}, "tips_enabled", false)
        lu.assertFalse(settings.get("tips_enabled"))
        fake.sliders[1].onChange(nil, 12)
        lu.assertEquals(settings.get("cooldown_minutes"), 12)
        fake.checkboxes[#fake.checkboxes].options.onChange(nil, {}, "MINING", true)
        lu.assertEquals(settings.get("muted_skills"), { MINING = true })
        fake.keybind_fields[1].onChange(nil, { 65, 66 })
        lu.assertEquals(settings.get("pinned_keybind"), { 65, 66 })
        local old = fake.checkboxes[1].options.onChange
        fake.fire("SettingsLayerReady", { component = {} })
        old(nil, {}, "tips_enabled", true)
        lu.assertFalse(settings.get("tips_enabled"))
        app.stop()
    end

    function suite:test_dev_reset_is_explicitly_opt_in()
        local fake = client.new(root)
        local settings_page = fake.load("src/ui/settings_page")
        local called = 0
        settings_page.start({
            reset_tips = function()
                called = called + 1
            end,
        })
        fake.fire("SettingsLayerReady", { component = {} })
        local buttons = fake.views[1].buttons
        lu.assertEquals(buttons[#buttons].text, "Reset dismissals (development)")
        buttons[#buttons].action()
        lu.assertEquals(called, 1)
        settings_page.stop()
    end

    function suite:test_keybind_is_unbound_and_opens_once_per_press_without_capture()
        local fake, app = world(root)
        local settings = fake.load("src/storage/settings")
        lu.assertEquals(settings.get("pinned_keybind"), {})
        fake.keys[65] = true
        fake.fire("Logic", { logicTick = 1 })
        lu.assertEquals(#fake.windows, 0)
        settings.set("pinned_keybind", { 65 })
        fake.capturing = true
        fake.fire("Logic", { logicTick = 2 })
        lu.assertEquals(#fake.windows, 0)
        fake.capturing = false
        fake.fire("Logic", { logicTick = 3 })
        lu.assertEquals(#fake.windows, 1)
        fake.fire("Logic", { logicTick = 4 })
        lu.assertEquals(#fake.windows, 1)
        fake.keys[65] = false
        fake.fire("Logic", { logicTick = 5 })
        fake.keys[65] = true
        fake.fire("Logic", { logicTick = 6 })
        lu.assertEquals(#fake.windows, 1)
        lu.assertTrue(fake.windows[1].destroyed)
        fake.fire("Logic", { logicTick = 7 })
        lu.assertEquals(#fake.windows, 1)
        fake.keys[65] = false
        fake.fire("Logic", { logicTick = 8 })
        fake.keys[65] = true
        fake.fire("Logic", { logicTick = 9 })
        lu.assertEquals(#fake.windows, 2)
        app.stop()
    end

    function suite:test_invalid_keybinds_are_rejected()
        local settings = client.new(root).load("src/storage/settings")
        lu.assertFalse(settings.set("pinned_keybind", { 1, 1 }))
        lu.assertFalse(settings.set("pinned_keybind", { 1, 2, 3 }))
        lu.assertFalse(settings.set("pinned_keybind", { "key" }))
        lu.assertFalse(settings.set("pinned_keybind", { [-1] = 65 }))
        lu.assertTrue(settings.set("pinned_keybind", {}))
    end

    function suite:test_tip_titles_share_longest_column_and_keep_unpin_inside_window()
        local fake, app, progress, coach = world(root)
        local catalogue = fake.load("src/tips/catalogue")
        catalogue.get = function(id)
            return { id = id, title = id == "a" and "Short" or "A much longer tip title" }
        end
        progress.pin("a")
        progress.pin("b")
        coach.open()
        lu.assertEquals(fake.labels[1].options.width, fake.labels[2].options.width)
        lu.assertEquals(controls(fake)[1].options.x, controls(fake)[2].options.x)
        for _, button in ipairs(controls(fake)) do
            lu.assertEquals(button.options.width, 24)
            lu.assertTrue(
                button.options.x + button.options.width <= fake.windows[1].root.width - 18
            )
        end
        app.stop()
    end

    function suite:test_history_stays_fixed_scrolls_and_moves_independently_of_tips()
        local fake, app, progress, coach = world(root)
        coach.open_history()
        local empty_height = fake.windows[1].root.height
        local catalogue = fake.load("src/tips/catalogue")
        local original_get = catalogue.get
        catalogue.get = function(id)
            if id:match("^history%.") then
                return {
                    id = id,
                    title = "History tip " .. id,
                    hook = string.rep("A useful tip. ", 12),
                }
            end
            return original_get(id)
        end
        for index = 1, 10 do
            progress.mark_shown("history." .. index)
        end
        local window = fake.windows[#fake.windows]
        lu.assertEquals(window.root.height, empty_height)
        lu.assertEquals(window.root.height, 400)
        lu.assertTrue(window.options.resizable)
        lu.assertTrue(window.root.height <= 420)
        lu.assertTrue(window.contentHeight > window.root.height)
        window:ScrollBy(32)
        lu.assertEquals(window.scrollY, 32)
        lu.assertNil(fake.layers and fake.layers[1].hooks.ONHOLD)
        window.root:SetPos(window.root.x + 40, window.root.y + 10)
        local x, y = window.root.x, window.root.y
        window:Close()
        coach.open_history()
        local reopened = fake.windows[#fake.windows]
        lu.assertAlmostEquals(reopened.root.x, x, 1)
        lu.assertAlmostEquals(reopened.root.y, y, 1)
        lu.assertNotNil(fake.saved.skilling_coach_history)
        lu.assertNil(fake.saved.skilling_coach_goals)
        coach.open()
        lu.assertTrue(fake.windows[#fake.windows].root.x > x)
        app.stop()
        lu.assertTrue(reopened.destroyed)
        lu.assertEquals(fake.total_subscriptions(), 0)
    end

    function suite:test_history_old_callbacks_and_character_changes_are_guarded()
        local fake, app, progress, coach = world(root)
        progress.mark_shown("mining.ore_box")
        coach.open_history()
        local first = fake.windows[1]
        local old_tick = fake.handlers.Logic.skilling_coach_history_geometry
        fake.player.name = "Bob"
        fake.fire("ServerLogic")
        lu.assertTrue(first.destroyed)
        old_tick({ logicTick = 25 })
        lu.assertEquals(progress.recent_tips(), {})
        lu.assertEquals(fake.labels[#fake.labels].options.text, "No tips shown yet.")
        app.stop()
    end

    function suite:test_settings_launch_history_without_embedded_log()
        local fake, app, progress = world(root)
        progress.mark_shown("mining.ore_box")
        fake.fire("SettingsLayerReady", { component = {} })
        local recent
        for _, button in ipairs(fake.views[1].buttons) do
            if button.text == "Recent tips" then
                recent = button.action
            end
        end
        lu.assertNotNil(recent)
        lu.assertEquals(#fake.windows, 0)
        recent()
        lu.assertEquals(fake.windows[1].options.title, "Recent tips")
        app.stop()
    end

    function suite:test_pin_from_recent_tips_keeps_dismissal_and_updates_the_tip_window()
        local fake, app, progress, coach = world(root)
        progress.dismiss("mining.ore_box")
        progress.mark_shown("mining.ore_box")
        coach.open()
        coach.open_history()
        local pin = controls(fake)[#controls(fake)]
        lu.assertEquals(pin.tooltip.options.text, "Pin tip")
        pin.action()
        lu.assertTrue(progress.is_pinned("mining.ore_box"))
        lu.assertTrue(progress.is_dismissed("mining.ore_box"))
        lu.assertEquals(#progress.recent_tips(), 1)
        local last = controls(fake)[#controls(fake)]
        lu.assertEquals(last.tooltip.options.text, "Already pinned")
        lu.assertEquals(last.image.alpha, 0.55)
        lu.assertNotNil(fake.saved.skilling_coach_progress_test_player.pinned["mining.ore_box"])
        app.stop()
    end

    function suite:test_recent_tips_remembers_user_resize_and_does_not_resize_with_content()
        local fake, app, progress, coach = world(root)
        coach.open_history()
        local window = fake.windows[1]
        lu.assertEquals(window.root.width, 360)
        lu.assertEquals(window.root.height, 400)
        window.root:SetSize(500, 480)
        fake.fire("Logic", { logicTick = 25 })
        fake.fire("Logic", { logicTick = 50 })
        local resized = fake.windows[#fake.windows]
        lu.assertEquals(resized.root.width, 500)
        lu.assertEquals(resized.root.height, 480)
        progress.mark_shown("mining.ore_box")
        local updated = fake.windows[#fake.windows]
        lu.assertEquals(updated.root.width, 500)
        lu.assertEquals(updated.root.height, 480)
        updated:Close()
        coach.open_history()
        lu.assertEquals(fake.windows[#fake.windows].root.width, 500)
        lu.assertEquals(fake.windows[#fake.windows].root.height, 480)
        app.stop()
    end

    function suite:test_list_icons_match_pin_artwork_position_hover_and_release_tooltips()
        local fake, app, progress, coach = world(root)
        progress.mark_shown("mining.ore_box")
        coach.open_history()
        local pin = controls(fake)[1]
        lu.assertEquals(pin.root.x_anchor, 1)
        lu.assertEquals(pin.root.x, -28)
        lu.assertEquals(pin.image.sprite, fake.environment.id.Sprite.RS3_ICON_PINNED_24PX_2)
        fake.game_area.xyGlobal = { x = 100, y = 50 }
        pin.image.xyGlobal = { x = 500, y = 300 }
        pin.image.hooks.ONMOUSEOVER()
        lu.assertEquals(pin.image.sprite, fake.environment.id.Sprite.RS3_ICON_PINNED_24PX_3)
        lu.assertTrue(pin.tooltip.shown)
        lu.assertEquals(pin.tooltip.root.x, 352)
        lu.assertEquals(pin.tooltip.root.y, 216)
        pin.image.hooks.ONMOUSELEAVE()
        lu.assertFalse(pin.tooltip.shown)
        pin.action()
        lu.assertTrue(pin.tooltip.destroyed)
        local disabled = controls(fake)[#controls(fake)]
        lu.assertEquals(disabled.image.alpha, 0.55)
        lu.assertEquals(disabled.image.sprite, fake.environment.id.Sprite.RS3_ICON_PINNED_24PX_1)
        lu.assertEquals(
            fake.labels[#fake.labels].options.text,
            "Backpack full? An ore box lets you keep mining for longer between bank trips."
        )
        disabled.action()
        lu.assertTrue(progress.is_pinned("mining.ore_box"))
        coach.open()
        local unpin = controls(fake)[#controls(fake)]
        lu.assertEquals(#fake.lines, 2)
        app.stop()
        lu.assertTrue(unpin.tooltip.destroyed)
    end

    function suite:test_unpin_cross_works_without_custom_resources()
        local fake, app, progress, coach = world(root)
        fake.environment.Plugin.resources = {}
        progress.pin("mining.ore_box")
        coach.open()
        local unpin = controls(fake)[1]
        lu.assertEquals(#fake.lines, 2)
        local stroke = fake.lines[1]
        local normal_colour = stroke.colour
        fake.game_area.xyGlobal = { x = 0, y = 0 }
        unpin.image.xyGlobal = { x = 200, y = 200 }
        unpin.image.hooks.ONMOUSEOVER()
        lu.assertNotEquals(stroke.colour, normal_colour)
        lu.assertTrue(unpin.tooltip.shown)
        unpin.image.hooks.ONMOUSELEAVE()
        lu.assertEquals(stroke.colour, normal_colour)
        unpin.action()
        lu.assertFalse(progress.is_pinned("mining.ore_box"))
        app.stop()
    end

    function suite:test_missing_resource_keeps_keybind_window_open_and_unpin_usable()
        local fake = client.new(root)
        fake.environment.Plugin.resources = {}
        local app = fake.load("src/app")
        app.start()
        local progress = fake.load("src/storage/tip_progress")
        progress.pin("mining.ore_box")
        fake.load("src/storage/settings").set("pinned_keybind", { 65 })
        fake.keys[65] = true
        fake.fire("Logic", { logicTick = 1 })
        fake.fire("Logic", { logicTick = 2 })
        local window = fake.windows[1]
        lu.assertEquals(#fake.windows, 1)
        lu.assertFalse(window.destroyed)
        local unpin = controls(fake)[1]
        lu.assertEquals(#fake.lines, 2)
        unpin.action()
        lu.assertFalse(progress.is_pinned("mining.ore_box"))
        app.stop()
    end

    function suite:test_failed_toggle_consumes_held_press_before_error()
        local fake = client.new(root)
        fake.load("src/storage/settings").set("pinned_keybind", { 65 })
        local keybind, calls = fake.load("src/ui/keybind"), 0
        keybind.start(function()
            calls = calls + 1
            error("test window failure")
        end)
        fake.keys[65] = true
        fake.fire("Logic", {})
        fake.fire("Logic", {})
        lu.assertEquals(calls, 1)
        fake.keys[65] = false
        fake.fire("Logic", {})
        fake.keys[65] = true
        fake.fire("Logic", {})
        lu.assertEquals(calls, 2)
        keybind.stop()
    end

    return suite
end
