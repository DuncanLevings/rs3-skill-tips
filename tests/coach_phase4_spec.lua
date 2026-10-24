local lu = require("luaunit")
local client = require("tests/support/client")

-- Synthetic tips exercise the engine without adding unfinished content to the live catalogue.
local function tip(id, minimum, maximum, priority)
    return {
        id = id,
        kind = "method",
        skills = { "MINING" },
        members = false,
        level_range = { minimum, maximum },
        priority = priority or 2,
        triggers = { { type = "level_reached", skill = "MINING", level = minimum } },
    }
end

local function world(root, tips, level)
    local fake = client.new(root)
    fake.player.levels[14] = level or 70
    local catalogue = fake.load("src/tips/catalogue")
    catalogue.for_skill = function()
        return tips
    end
    local engine = fake.load("src/coach/engine")
    local progress = fake.load("src/storage/tip_progress")
    local settings = fake.load("src/storage/settings")
    progress.use_character("test_player")
    local shown, now = {}, 1000
    local deps = {
        state = fake.load("src/game/player_state"),
        now = function()
            return now
        end,
        show_card = function(candidate, handlers)
            shown[#shown + 1] = { tip = candidate, handlers = handlers }
        end,
    }
    engine.start(deps)
    return {
        fake = fake,
        engine = engine,
        progress = progress,
        settings = settings,
        shown = shown,
        advance = function(seconds)
            now = now + seconds
        end,
        close = function()
            shown[#shown].handlers.on_closed()
        end,
        restart = function()
            engine.start(deps)
        end,
    }
end

return function(root)
    local suite = {}

    function suite:test_ranking_prefers_current_skill_before_priority()
        local current = tip("mining", 70, 99, 4)
        local general = tip("general", 70, 99, 1)
        general.skills = { "ANY" }
        general.triggers[1].skill = "ANY"
        local w = world(root, { general, current })
        w.engine.on_training("MINING")
        lu.assertEquals(w.shown[1].tip.id, "mining")
    end

    function suite:test_ranking_uses_priority_then_closest_level_then_id()
        local w = world(root, { tip("far", 50, 99, 1), tip("near", 69, 99, 2) })
        w.engine.on_training("MINING")
        lu.assertEquals(w.shown[1].tip.id, "far")
        w = world(root, { tip("far", 50, 99), tip("near", 69, 99) })
        w.engine.on_training("MINING")
        lu.assertEquals(w.shown[1].tip.id, "near")
        w = world(root, { tip("z", 69, 99), tip("a", 69, 99) })
        w.engine.on_training("MINING")
        lu.assertEquals(w.shown[1].tip.id, "a")
    end

    function suite:test_92_miner_gets_current_bracket_and_never_iron_or_future_method()
        local w = world(
            root,
            { tip("iron", 10, 19, 1), tip("current", 90, 99), tip("future", 100, 110, 1) },
            92
        )
        w.engine.on_training("MINING")
        lu.assertEquals(w.shown[1].tip.id, "current")
        w.close()
        w.advance(1000)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 1)
    end

    function suite:test_method_upper_boundary_is_inclusive_and_unknown_level_waits()
        local w = world(root, { tip("method", 10, 19) }, 19)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 1)
        w = world(root, { tip("method", 10, 19) }, 20)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 0)
        w.fake.environment.Player.GetLevelUncapped = function()
            return nil
        end
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 0)
    end

    function suite:test_level_crossing_after_first_training_queues_current_bracket()
        local w = world(root, { tip("new", 70, 79) }, 69)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 0)
        w.fake.player.levels[14] = 70
        w.engine.on_level_up("MINING", 69, 70)
        lu.assertEquals(#w.shown, 0)
        w.engine.on_training("MINING")
        lu.assertEquals(w.shown[1].tip.id, "new")
        lu.assertNil(w.progress.pending_level_up("MINING"))
    end

    function suite:test_multi_level_reward_does_not_resurrect_passed_brackets()
        local w = world(root, { tip("old", 20, 29, 1), tip("new", 70, 79) }, 75)
        w.engine.on_level_up("MINING", 19, 75)
        lu.assertEquals(#w.shown, 0)
        w.engine.on_training("MINING")
        lu.assertEquals(w.shown[1].tip.id, "new")
    end

    function suite:test_cooldown_retains_level_tip_and_uses_live_duration()
        local w = world(root, { tip("first", 60, 69), tip("next", 70, 79) }, 69)
        w.engine.on_training("MINING")
        w.close()
        w.fake.player.levels[14] = 70
        w.engine.on_level_up("MINING", 69, 70)
        w.advance(119)
        w.settings.set("cooldown_minutes", 2)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 1)
        lu.assertNotNil(w.progress.pending_level_up("MINING"))
        w.advance(1)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 2)
        lu.assertEquals(w.shown[2].tip.id, "next")
    end

    function suite:test_session_cap_and_zero_unlimited_are_applied_live()
        local w = world(root, { tip("a", 70, 79), tip("b", 70, 79), tip("c", 70, 79) })
        w.settings.set("session_cap", 1)
        w.engine.on_training("MINING")
        w.close()
        w.advance(600)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 1)
        w.settings.set("session_cap", 0)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 2)
        w.close()
        w.advance(600)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 3)
    end

    function suite:test_combat_extends_quiet_period_and_reset_does_not_bypass_it()
        local w = world(root, { tip("a", 70, 79) })
        w.engine.on_combat()
        w.advance(59)
        w.engine.on_combat()
        w.engine.reset_pacing()
        w.advance(59)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 0)
        w.advance(1)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 1)
    end

    function suite:test_filters_apply_before_ranking_without_hiding_aspirational_requirements()
        local best = tip("best", 70, 79, 1)
        best.members = true
        local allowed = tip("allowed", 70, 79)
        allowed.requirements = { skills = { SMITHING = 90 }, quests = { "UNFINISHED" } }
        local w = world(root, { best, allowed })
        w.settings.set("show_members", false)
        w.engine.on_training("MINING")
        lu.assertEquals(w.shown[1].tip.id, "allowed")
        w.close()
        w.advance(600)
        w.settings.set("show_members", true)
        w.settings.set("show_late", false)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 1)
    end

    function suite:test_known_pinned_dismissed_and_disabled_methods_are_filtered()
        local known = tip("known", 70, 79, 1)
        known.known_when = { { type = "has_level", skill = "MINING", level = 1 } }
        local w = world(
            root,
            { known, tip("pinned", 70, 79), tip("dismissed", 70, 79), tip("last", 70, 79) }
        )
        w.progress.pin("pinned")
        w.progress.dismiss("dismissed")
        w.settings.set("show_methods", false)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 0)
        w.settings.set("show_methods", true)
        w.engine.on_training("MINING")
        lu.assertEquals(w.shown[1].tip.id, "last")
    end

    function suite:test_old_card_actions_and_close_cannot_mutate_a_new_session_or_card()
        local w = world(root, { tip("a", 70, 79), tip("b", 70, 79), tip("c", 70, 79) })
        w.engine.on_training("MINING")
        local old = w.shown[1].handlers
        w.close()
        w.advance(600)
        w.engine.on_training("MINING")
        old.on_dismiss()
        old.on_closed()
        w.advance(600)
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 2)
        lu.assertFalse(w.progress.is_dismissed("a"))
        local second = w.shown[2].handlers
        w.restart()
        second.on_pin()
        lu.assertFalse(w.progress.is_pinned("b"))
        w.engine.stop()
        second.on_dismiss()
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 2)
    end

    function suite:test_backpack_only_tip_cannot_leak_through_catch_up_or_level_up()
        local box = tip("box", 1, 120, 1)
        box.kind = "convenience"
        box.triggers = { { type = "backpack_full", skill = "MINING" } }
        local w = world(root, { box }, 92)
        w.engine.on_level_up("MINING", 91, 92)
        w.engine.on_training("MINING")
        w.engine.on_backpack_full("WOODCUTTING")
        lu.assertEquals(#w.shown, 0)
        w.engine.on_backpack_full("MINING")
        lu.assertEquals(#w.shown, 1)
    end

    function suite:test_development_bypasses_cooldown_without_changing_saved_setting()
        local w = world(root, { tip("a", 70, 79), tip("b", 70, 79) })
        w.fake.load("src/development").ENABLED = true
        w.settings.set("cooldown_minutes", 30)
        w.engine.on_training("MINING")
        w.close()
        w.engine.on_training("MINING")
        lu.assertEquals(#w.shown, 2)
        lu.assertEquals(w.settings.get("cooldown_minutes"), 30)
    end

    function suite:test_development_keeps_cap_combat_and_release_cooldown()
        local fake = client.new(root)
        local settings = fake.load("src/storage/settings")
        local development = fake.load("src/development")
        local gate = fake.load("src/coach/pacing").new()
        development.ENABLED = true
        gate.shown(100)
        lu.assertTrue(gate.allows(100))
        development.ENABLED = false
        lu.assertFalse(gate.allows(100))
        development.ENABLED = true
        settings.set("session_cap", 1)
        lu.assertFalse(gate.allows(100))
        settings.set("session_cap", 0)
        gate.combat(100)
        lu.assertFalse(gate.allows(100))
        lu.assertTrue(gate.allows(160))
    end

    return suite
end
