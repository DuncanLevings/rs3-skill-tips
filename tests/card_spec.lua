local lu = require("luaunit")
local client = require("tests/support/client")

local AREA = { width = 1920, height = 1009 }

local function card_at(x, y)
    return { x = x, y = y, width = 340, height = 200 }
end

-- handlers that record which ones were called, in order
local function recording_handlers()
    local calls = {}
    local handlers = {}

    for _, name in ipairs({ "on_pin", "on_dismiss", "on_later", "on_closed" }) do
        handlers[name] = function()
            calls[#calls + 1] = name
        end
    end

    return handlers, calls
end

local function open_ore_box_card(fake, animate)
    local tip_card = fake.load("src/ui/tip_card")
    local tip = fake.load("src/tips/catalogue").get("mining.ore_box")
    local handlers, calls = recording_handlers()

    tip_card.show(tip, handlers, { state = fake.load("src/game/player_state"), animate = animate })

    return tip_card, calls, fake.windows[#fake.windows]
end

local function run_frames(fake, count)
    for _ = 1, count do
        fake.fire("Draw", { timeDeltaSecs = 0.016 })
    end
end

local function run_logic_ticks(fake, count)
    for tick = 1, count do
        fake.fire("Logic", { logicTick = tick })
    end
end

return function(root)
    local suite = {}

    function suite:test_nearest_edge()
        local motion = client.new(root).load("src/ui/card_motion")

        lu.assertEquals(motion.nearest_edge(card_at(0, 400), AREA), "left")
        lu.assertEquals(motion.nearest_edge(card_at(1580, 400), AREA), "right")
        lu.assertEquals(motion.nearest_edge(card_at(800, 5), AREA), "top")
        lu.assertEquals(motion.nearest_edge(card_at(800, 800), AREA), "bottom")
    end

    function suite:test_docked_cards_hide_fully_off_screen_without_fading()
        local motion = client.new(root).load("src/ui/card_motion")

        lu.assertEquals({ motion.hidden_position(card_at(0, 400), AREA) }, { -340, 400, false })
        lu.assertEquals({ motion.hidden_position(card_at(1580, 400), AREA) }, { 1920, 400, false })
        lu.assertEquals({ motion.hidden_position(card_at(800, 0), AREA) }, { 800, -200, false })
        lu.assertEquals({ motion.hidden_position(card_at(800, 809), AREA) }, { 800, 1009, false })
    end

    function suite:test_floating_cards_move_a_little_and_fade()
        local motion = client.new(root).load("src/ui/card_motion")

        lu.assertEquals({ motion.hidden_position(card_at(300, 400), AREA) }, { 276, 400, true })
    end

    function suite:test_card_is_created_where_it_rests_then_slides_in_and_stays()
        local fake = client.new(root)
        local _, _, window = open_ore_box_card(fake, true)
        local rest_y = window.options.y

        -- created at its resting spot, then moved off screen for the slide
        lu.assertEquals(window.options.x, 0)
        lu.assertEquals(window.root.positions[2].x, -360)

        run_frames(fake, 40)

        lu.assertEquals(window.root.x, 0)
        lu.assertEquals(window.root.y, rest_y)
    end

    function suite:test_pin_slides_the_card_back_out()
        local fake = client.new(root)
        local tip_card, calls, window = open_ore_box_card(fake, true)
        run_frames(fake, 40)

        fake.sprites[5].hooks.ONCLICK()
        run_frames(fake, 40)

        lu.assertEquals(calls, { "on_pin", "on_closed" })
        lu.assertTrue(window.destroyed)
        lu.assertFalse(tip_card.is_open())
        lu.assertEquals(fake.total_subscriptions(), 0)
    end

    function suite:test_everything_shows_at_once_and_met_requirements_are_left_out()
        local fake = client.new(root)
        -- smithing is skill 13, the ore box needs level 1
        fake.player.levels[13] = 5
        local tip_card = open_ore_box_card(fake, false)
        local text = table.concat(fake.texts, "\n")

        lu.assertStrContains(text, "Ore box")
        lu.assertStrContains(text, "Smith a bronze ore box at an anvil")
        lu.assertFalse(text:find("100", 1, true) ~= nil)
        lu.assertFalse(text:find("Needs:", 1, true) ~= nil)
        lu.assertFalse(text:find("Wiki", 1, true) ~= nil)
        lu.assertNil(fake.buttons["How it works"])

        tip_card.destroy()
    end

    function suite:test_item_icon_sits_beside_the_title_with_room_for_pin()
        local fake = client.new(root)
        local tip_card, _, window = open_ore_box_card(fake, false)
        local icon = fake.sprites[4]
        local title = fake.labels[1]

        lu.assertEquals(icon.width, 28)
        lu.assertEquals(title.x - (icon.x + icon.width), 8)
        lu.assertEquals(title.options.text, "Ore box")
        lu.assertEquals(window.options.title, " ")
        lu.assertTrue(window.titleText.hidden)
        lu.assertTrue(window.closeButton.hidden)
        lu.assertNil(fake.sprite_buttons)
        lu.assertNil(fake.canvases)
        lu.assertEquals(fake.sprites[5].sprite, 3)
        lu.assertFalse(fake.sprites[5].clickthrough)
        lu.assertTrue(fake.sprites[5].enabled)
        lu.assertEquals(fake.tooltips[1].target, fake.sprites[5])
        lu.assertEquals(fake.tooltips[1].parent, fake.game_area)
        lu.assertEquals(fake.tooltips[1].options.text, "Pin as a goal")
        fake.game_area.xyGlobal = { x = 100, y = 50 }
        fake.sprites[5].xyGlobal = { x = 500, y = 250 }
        fake.sprites[5].hooks.ONMOUSEOVER()
        lu.assertTrue(fake.tooltips[1].shown)
        lu.assertEquals(fake.tooltips[1].root.x, 352)
        lu.assertEquals(fake.tooltips[1].root.y, 166)
        -- At the top-right edge, flip below and keep the tooltip on screen.
        fake.sprites[5].xyGlobal = { x = 2000, y = 52 }
        run_logic_ticks(fake, 1)
        lu.assertEquals(fake.tooltips[1].root.x, 1792)
        lu.assertEquals(fake.tooltips[1].root.y, 32)
        fake.sprites[5].hooks.ONMOUSELEAVE()
        lu.assertFalse(fake.tooltips[1].shown)
        lu.assertNil(fake.buttons.Pin)
        lu.assertNil(window.has_divider)
        lu.assertEquals(window.actions[1].options.marginTop, 8)
        lu.assertEquals(window.actions[1].label, "Dismiss")
        lu.assertEquals(window.actions[2].label, "Later")

        tip_card.destroy()
        lu.assertTrue(fake.tooltips[1].destroyed)
    end

    function suite:test_missing_item_config_keeps_the_title_readable()
        local fake = client.new(root)
        fake.environment.config.Obj = {}
        local tip_card, _, window = open_ore_box_card(fake, false)

        lu.assertEquals(#fake.sprites, 8)
        lu.assertEquals(fake.labels[1].options.text, "Ore box")
        lu.assertEquals(fake.labels[1].x, 12)

        tip_card.destroy()
    end

    function suite:test_the_windows_own_close_button_counts_as_later()
        local fake = client.new(root)
        local tip_card, calls, window = open_ore_box_card(fake, false)

        window:Close()

        lu.assertEquals(calls, { "on_later", "on_closed" })
        lu.assertFalse(tip_card.is_open())
    end

    function suite:test_body_drag_moves_the_card_and_stops_on_release()
        local fake = client.new(root)
        local tip_card, _, window = open_ore_box_card(fake, false)
        local body = fake.layers[1]
        local start_x, start_y = window.root.x, window.root.y
        body.hooks.ONCLICK(body, 100, 80)
        body.hooks.ONHOLD(body, 150, 110)
        lu.assertEquals(window.root.x, start_x + 50)
        lu.assertEquals(window.root.y, start_y + 30)
        body.hooks.ONHOLD(body, 100, 80)
        lu.assertEquals(window.root.x, start_x + 50)
        body.hooks.ONRELEASE()
        body.hooks.ONHOLD(body, 180, 180)
        lu.assertEquals(window.root.x, start_x + 50)
        run_logic_ticks(fake, 75)
        lu.assertNotNil(fake.saved.skilling_coach_card)
        tip_card.destroy()
        lu.assertEquals(fake.total_subscriptions(), 0)
    end

    function suite:test_old_saved_height_cannot_leave_a_short_tip_in_a_tall_card()
        local fake = client.new(root)
        fake.saved.skilling_coach_card = { version = 1, width = 360, height = 900 }
        local placement = fake.load("src/ui/card_placement")
        lu.assertEquals(placement.rect_for(AREA, 240, 480).height, 240)
        lu.assertEquals(placement.rect_for(AREA, 900, 480).height, 480)
    end

    function suite:test_saved_width_is_measured_before_the_card_height_is_chosen()
        local narrow = client.new(root)
        narrow.saved.skilling_coach_card = { version = 1, width = 260, height = 900 }
        local narrow_card, _, narrow_window = open_ore_box_card(narrow, false)
        local wide = client.new(root)
        wide.saved.skilling_coach_card = { version = 1, width = 520, height = 900 }
        local wide_card, _, wide_window = open_ore_box_card(wide, false)
        lu.assertTrue(narrow_window.options.height > wide_window.options.height)
        lu.assertTrue(narrow_window.options.height <= 480)
        narrow_card.destroy()
        wide_card.destroy()
    end

    function suite:test_destroying_on_shutdown_is_not_a_close()
        local fake = client.new(root)
        local tip_card, calls = open_ore_box_card(fake, false)

        tip_card.destroy()

        lu.assertEquals(calls, {})
    end

    function suite:test_a_moved_card_is_remembered_for_the_next_one()
        local fake = client.new(root)
        local tip_card, _, window = open_ore_box_card(fake, false)

        -- the player drags it to the right and makes it wider
        window.root.x = 1400
        window.root.width = 420
        run_logic_ticks(fake, 75)

        lu.assertNotNil(fake.saved.skilling_coach_card)
        lu.assertNil(fake.saved.skilling_coach_card.height)

        tip_card.destroy()
        local _, _, next_window = open_ore_box_card(fake, false)

        lu.assertEquals(next_window.options.width, 420)
        lu.assertEquals(next_window.options.x, 1400)

        tip_card.destroy()
    end

    return suite
end
