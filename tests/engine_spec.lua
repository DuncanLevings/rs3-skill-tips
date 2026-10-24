local lu = require("luaunit")
local client = require("tests/support/client")

-- engine running in a fake client with a controllable clock and a card that just records
local function setup(root, options)
    options = options or {}
    local fake = client.new(root)
    local now = 1000
    local shown = {}

    local engine = fake.load("src/coach/engine")
    local owned_items = fake.load("src/storage/owned_items")
    local tip_progress = fake.load("src/storage/tip_progress")
    local settings = fake.load("src/storage/settings")

    owned_items.use_character("alice")
    tip_progress.use_character("alice")

    if options.bank_seen ~= false then
        owned_items.update_from_bank({}, {}, function()
            return 0
        end, function()
            return 0
        end)
    end

    engine.start({
        state = fake.load("src/game/player_state"),
        now = function()
            return now
        end,
        show_card = function(tip, handlers)
            shown[#shown + 1] = { tip = tip, handlers = handlers }
        end,
    })

    return {
        fake = fake,
        engine = engine,
        settings = settings,
        tip_progress = tip_progress,
        shown = shown,
        advance = function(seconds)
            now = now + seconds
        end,
        close_card = function(action)
            local card = shown[#shown]
            card.handlers[action]()
            card.handlers.on_closed()
        end,
    }
end

return function(root)
    local suite = {}

    function suite:test_training_alone_does_not_show_the_ore_box_tip()
        local world = setup(root)
        world.engine.on_training("MINING")

        -- a mining method tip may show, the ore box waits for a full backpack
        for _, card in ipairs(world.shown) do
            lu.assertNotEquals(card.tip.id, "mining.ore_box")
        end
    end

    function suite:test_mining_without_an_ore_box_shows_the_ore_box_tip()
        local world = setup(root)

        world.engine.on_backpack_full("MINING")

        lu.assertEquals(#world.shown, 1)
        lu.assertEquals(world.shown[1].tip.id, "mining.ore_box")
    end

    function suite:test_no_ore_box_tip_when_one_is_in_the_backpack()
        local world = setup(root)
        world.fake.inventories[93] = { { item = "MINING_OREBOX_IRON", category = 4448 } }

        world.engine.on_backpack_full("MINING")

        lu.assertEquals(#world.shown, 0)
    end

    function suite:test_higher_tiers_are_caught_by_the_shared_category()
        local world = setup(root)
        world.fake.inventories[94] = { { item = "SOME_OTHER_TIER", category = 4448 } }

        world.engine.on_backpack_full("MINING")

        lu.assertEquals(#world.shown, 0)
    end

    function suite:test_item_tips_wait_until_the_bank_has_been_seen()
        local world = setup(root, { bank_seen = false })

        world.engine.on_backpack_full("MINING")

        lu.assertEquals(#world.shown, 0)
    end

    function suite:test_other_skills_do_not_get_mining_tips()
        local world = setup(root)

        world.engine.on_backpack_full("FISHING")

        lu.assertEquals(#world.shown, 0)
    end

    function suite:test_only_one_card_at_a_time_and_not_twice_a_session()
        local world = setup(root)

        world.engine.on_backpack_full("MINING")
        world.engine.on_backpack_full("MINING")
        lu.assertEquals(#world.shown, 1)

        world.close_card("on_later")
        world.advance(3600)
        world.engine.on_backpack_full("MINING")

        lu.assertEquals(#world.shown, 1)
    end

    function suite:test_dismiss_and_pin_are_saved()
        local world = setup(root)

        world.engine.on_backpack_full("MINING")
        world.close_card("on_pin")

        lu.assertTrue(world.tip_progress.is_pinned("mining.ore_box"))

        local dismissed = setup(root)
        dismissed.engine.on_backpack_full("MINING")
        dismissed.close_card("on_dismiss")

        lu.assertTrue(dismissed.tip_progress.is_dismissed("mining.ore_box"))
    end

    function suite:test_quiet_after_combat_xp()
        local world = setup(root)

        world.engine.on_combat()
        world.advance(30)
        world.engine.on_backpack_full("MINING")
        lu.assertEquals(#world.shown, 0)

        world.advance(31)
        world.engine.on_backpack_full("MINING")
        lu.assertEquals(#world.shown, 1)
    end

    function suite:test_settings_can_mute_a_skill_or_turn_tips_off()
        local world = setup(root)

        world.settings.set("muted_skills", { MINING = true })
        world.engine.on_backpack_full("MINING")
        world.settings.set("muted_skills", {})
        world.settings.set("tips_enabled", false)
        world.engine.on_backpack_full("MINING")

        lu.assertEquals(#world.shown, 0)
    end

    function suite:test_reset_lets_a_dismissed_tip_show_again()
        local world = setup(root)

        world.engine.on_backpack_full("MINING")
        world.close_card("on_dismiss")
        world.tip_progress.reset_dismissed()
        world.engine.reset_pacing()
        world.engine.on_backpack_full("MINING")

        lu.assertEquals(#world.shown, 2)
    end

    function suite:test_stage_comes_from_levels()
        local engine = client.new(root).load("src/coach/engine")

        lu.assertEquals(engine.stage({ level_range = { 70, 80 } }), "late")
        lu.assertEquals(engine.stage({ requirements = { skills = { SMITHING = 40 } } }), "mid")
        lu.assertEquals(engine.stage({}), "early")
    end

    function suite:test_dismissed_tip_reappears_only_after_its_timer()
        local world = setup(root)
        world.tip_progress.start()
        world.fake.fire("Logic", { logicTick = 1 })
        world.engine.on_backpack_full("MINING")
        lu.assertEquals(#world.shown, 1)
        world.close_card("on_dismiss")
        world.advance(2 * 3600)
        world.fake.fire("Logic", { logicTick = 1 + 2 * 3600 * 50 })
        world.engine.on_backpack_full("MINING")
        lu.assertEquals(#world.shown, 1)
        world.advance(3600)
        world.fake.fire("Logic", { logicTick = 1 + 3 * 3600 * 50 })
        world.engine.on_backpack_full("MINING")
        lu.assertEquals(#world.shown, 2)
        lu.assertEquals(world.shown[2].tip.id, "mining.ore_box")
        world.tip_progress.stop()
    end

    return suite
end
