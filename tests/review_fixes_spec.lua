-- one spec per bug found in the phase 2-5 review, so none of them can quietly come back

local lu = require("luaunit")
local client = require("tests/support/client")

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

local function open_card(fake, animate)
    local tip_card = fake.load("src/ui/tip_card")
    local tip = fake.load("src/tips/catalogue").get("mining.ore_box")
    local handlers, calls = recording_handlers()
    local shown = tip_card.show(tip, handlers, {
        state = fake.load("src/game/player_state"),
        animate = animate,
    })

    return tip_card, calls, fake.windows[#fake.windows], shown
end

local function frames(fake, count)
    for _ = 1, count do
        fake.fire("Draw", { timeDeltaSecs = 0.016 })
    end
end

-- engine with a bank already seen and a card function the spec controls
local function engine_world(root, show_card)
    local fake = client.new(root)
    local owned_items = fake.load("src/storage/owned_items")
    local tip_progress = fake.load("src/storage/tip_progress")
    local engine = fake.load("src/coach/engine")
    local now = 0

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
            return now
        end,
        show_card = show_card,
    })

    return fake, engine, function(seconds)
        now = now + seconds
    end
end

return function(root)
    local suite = {}

    function suite:test_grabbing_the_card_while_it_slides_out_still_closes_it()
        local fake = client.new(root)
        local tip_card, calls, window = open_card(fake, true)
        frames(fake, 50)

        -- pin, then grab the card body part way through the slide out
        fake.sprites[5].hooks.ONCLICK()
        frames(fake, 5)
        local body = fake.layers[1]
        body.hooks.ONCLICK(body, 10, 10)
        body.hooks.ONHOLD(body, 300, 300)
        frames(fake, 60)

        lu.assertEquals(calls, { "on_pin", "on_closed" })
        lu.assertTrue(window.destroyed)
        lu.assertFalse(tip_card.is_open())
        lu.assertEquals(fake.total_subscriptions(), 0)
    end

    function suite:test_grabbing_a_card_mid_slide_in_finishes_the_slide()
        local fake = client.new(root)
        -- far from every edge, so it floats in with a fade
        fake.saved.skilling_coach_card = { version = 1, x_ratio = 0.5, y_ratio = 0.5 }
        local tip_card, _, window = open_card(fake, true)
        frames(fake, 3)

        local body = fake.layers[1]
        body.hooks.ONCLICK(body, 10, 10)

        lu.assertEquals(window.root.alpha, 1)
        lu.assertEquals(window.root.x, window.options.x)
        lu.assertEquals(fake.subscription_count("Draw"), 0)

        tip_card.destroy()
    end

    function suite:test_a_card_that_fails_to_build_cleans_up_and_says_so()
        local fake = client.new(root)
        -- something the header needs is gone, like a prettyui update could do
        fake.environment.prettyui.Tooltip = nil
        local tip_card, _, window, shown = open_card(fake, true)

        lu.assertFalse(shown)
        lu.assertFalse(tip_card.is_open())
        lu.assertTrue(window.destroyed)
        lu.assertEquals(fake.total_subscriptions(), 0)
        lu.assertStrContains(fake.logs[#fake.logs], "couldn't show a tip card")
    end

    function suite:test_an_error_while_showing_a_card_does_not_block_later_tips()
        local attempts = 0
        local fake, engine, advance = engine_world(root, function()
            attempts = attempts + 1
            error("card broke")
        end)

        engine.on_backpack_full("MINING")
        advance(3600)
        engine.on_backpack_full("MINING")

        lu.assertEquals(attempts, 2)
        lu.assertStrContains(fake.logs[1], "couldn't show tip mining.ore_box")
    end

    function suite:test_prettyui_internals_never_throw_when_fields_are_missing()
        local internals = client.new(root).load("src/ui/prettyui_internals")
        local bare = {}

        internals.hide_title_bar(bare)
        internals.restore_plain_frame(bare)
        internals.set_content_height(bare, 10)
        internals.set_window_size(bare, 10, 10)
        internals.show_window(bare)
        internals.scroll_by(bare, 5)
        internals.set_text(nil, "x")

        lu.assertNil(internals.background_sprite(bare))
        lu.assertNil(internals.content_layer(bare))
        lu.assertNil(internals.content_height(bare))
        lu.assertNil(internals.tooltip_root(bare))
    end

    function suite:test_slide_out_starts_from_where_the_card_was_dragged_to()
        local fake = client.new(root)
        local tip_card, _, window = open_card(fake, true)
        frames(fake, 50)

        -- dragged, then Later pressed before placement had a chance to notice the move
        window.root:SetPos(400, 300)
        fake.buttons.Later()
        frames(fake, 1)

        -- floating card, so after one frame its still within a short float of the drag spot
        -- (before the fix it jumped back to its old resting place at the left edge first)
        lu.assertTrue(math.abs(window.root.x - 400) <= 24)
        lu.assertTrue(math.abs(window.root.y - 300) <= 24)

        frames(fake, 60)
        lu.assertFalse(tip_card.is_open())
    end

    function suite:test_gathering_does_not_check_the_backpack_every_tick()
        local fake = client.new(root)
        local lookups = 0
        local find = fake.environment.Inventory.Find
        fake.environment.Inventory.Find = function(...)
            lookups = lookups + 1
            return find(...)
        end

        fake.load("src/game/clock").start()
        fake.load("src/game/activity_watch").start({
            on_training = function() end,
            on_combat = function() end,
            on_backpack_full = function() end,
        })
        fake.fire("MiniMenuEntrySelected", { entry = { verbText = "Mine", locData = {} } })
        lookups = 0

        for tick = 1, 24 do
            fake.fire("Logic", { logicTick = tick })
        end

        lu.assertEquals(lookups, 0)
    end

    function suite:test_bank_snapshot_only_saves_when_something_changed()
        local fake = client.new(root)
        local owned_items = fake.load("src/storage/owned_items")
        local saves = 0
        local db = fake.environment.PersistentDB

        -- stands in for PersistentDB and counts the writes
        fake.environment.PersistentDB = {
            GetStructuredData = function(_, key)
                return db:GetStructuredData(key)
            end,
            SetStructuredData = function(_, key, value)
                saves = saves + 1
                return db:SetStructuredData(key, value)
            end,
        }
        local bank = { MINING_OREBOX_IRON = 1 }
        local function snapshot()
            owned_items.update_from_bank({ MINING_OREBOX_IRON = true }, {}, function(item)
                return bank[item]
            end, function()
                return 0
            end)
        end

        owned_items.use_character("alice")
        snapshot()
        snapshot()
        snapshot()
        lu.assertEquals(saves, 1)

        bank = {}
        snapshot()
        lu.assertEquals(saves, 2)
        lu.assertFalse(owned_items.in_bank("MINING_OREBOX_IRON"))
    end

    function suite:test_a_level_trigger_that_doesnt_fit_doesnt_hide_the_next_trigger()
        local triggers = client.new(root).load("src/coach/triggers")
        local tip = {
            kind = "method",
            triggers = {
                { type = "level_reached", skill = "MINING", level = 70 },
                { type = "training", skill = "MINING" },
            },
        }
        local context = {
            skill = "MINING",
            kind = "training",
            level = 50,
            pending = { old = 60, new = 75 },
        }

        lu.assertTrue(triggers.matches(tip, context))
    end

    function suite:test_mute_list_leaves_out_combat_skills()
        local fake = client.new(root)
        local app = fake.load("src/app")
        app.start()
        fake.fire("SettingsLayerReady", { component = {} })

        local mute_choices = fake.checkboxes[#fake.checkboxes].choices
        local names = {}

        for _, choice in ipairs(mute_choices) do
            names[choice.value] = true
        end

        lu.assertTrue(names.MINING)
        lu.assertTrue(names.SLAYER)
        lu.assertNil(names.ATTACK)
        lu.assertNil(names.NECROMANCY)
        lu.assertEquals(#mute_choices, 22)

        app.stop()
    end

    return suite
end
