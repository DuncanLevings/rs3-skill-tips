local lu = require("luaunit")
local client = require("tests/support/client")

return function(root)
    local suite = {}

    function suite:test_settings_start_from_defaults()
        local settings = client.new(root).load("src/storage/settings")

        lu.assertTrue(settings.get("tips_enabled"))
        lu.assertEquals(settings.get("cooldown_minutes"), 10)
        lu.assertEquals(settings.get("muted_skills"), {})
    end

    function suite:test_one_bad_saved_setting_does_not_reset_the_others()
        local fake = client.new(root)
        fake.saved.skilling_coach_settings = {
            version = 1,
            cooldown_minutes = 25,
            session_cap = "lots",
            muted_skills = { MINING = true, NOT_A_SKILL = true },
        }
        local settings = fake.load("src/storage/settings")

        lu.assertEquals(settings.get("cooldown_minutes"), 25)
        lu.assertEquals(settings.get("session_cap"), 6)
        lu.assertEquals(settings.get("muted_skills"), {})
    end

    function suite:test_settings_reject_bad_values_and_save_good_ones()
        local fake = client.new(root)
        local settings = fake.load("src/storage/settings")

        lu.assertFalse(settings.set("cooldown_minutes", 1))
        lu.assertFalse(settings.set("made_up", true))
        lu.assertTrue(settings.set("cooldown_minutes", 30))
        lu.assertEquals(fake.saved.skilling_coach_settings.cooldown_minutes, 30)
    end

    function suite:test_editing_a_returned_table_does_not_change_the_setting()
        local settings = client.new(root).load("src/storage/settings")

        settings.get("muted_skills").MINING = true

        lu.assertEquals(settings.get("muted_skills"), {})
    end

    function suite:test_character_keys_are_safe_and_lowercase()
        local character_key = client.new(root).load("src/storage/character_key")

        lu.assertEquals(character_key.from_name("Retsu\194\160Zorubu"), "retsu__zorubu")
        lu.assertEquals(character_key.from_name("Zezima"), "zezima")
        lu.assertEquals(character_key.from_name("Alice_42!"), "alice_42_")
        lu.assertEquals(character_key.from_name("\195\137Player"), "__player")
        lu.assertNil(character_key.from_name(false))
        lu.assertNil(character_key.from_name(""))
    end

    function suite:test_tip_progress_is_kept_per_character()
        local fake = client.new(root)
        local tip_progress = fake.load("src/storage/tip_progress")

        tip_progress.use_character("alice")
        tip_progress.dismiss("mining.ore_box")
        tip_progress.pin("fishing.barrel")
        tip_progress.use_character("bob")

        lu.assertFalse(tip_progress.is_dismissed("mining.ore_box"))

        tip_progress.use_character("alice")

        lu.assertTrue(tip_progress.is_dismissed("mining.ore_box"))
        lu.assertEquals(tip_progress.pinned_ids(), { "fishing.barrel" })
        lu.assertNotNil(fake.saved.skilling_coach_progress_alice)
    end

    function suite:test_damaged_progress_keeps_what_still_makes_sense()
        local fake = client.new(root)
        fake.saved.skilling_coach_progress_alice = {
            version = 1,
            dismissed = { ["mining.ore_box"] = true, [5] = true, other = "yes" },
            pinned = "broken",
        }
        local tip_progress = fake.load("src/storage/tip_progress")

        tip_progress.use_character("alice")

        lu.assertTrue(tip_progress.is_dismissed("mining.ore_box"))
        lu.assertFalse(tip_progress.is_dismissed("other"))
        lu.assertEquals(tip_progress.pinned_ids(), {})
    end

    function suite:test_reset_brings_back_dismissed_and_shown_tips()
        local tip_progress = client.new(root).load("src/storage/tip_progress")

        tip_progress.use_character("alice")
        tip_progress.dismiss("mining.ore_box")
        tip_progress.mark_shown("fishing.barrel")
        tip_progress.reset_dismissed()

        lu.assertFalse(tip_progress.is_dismissed("mining.ore_box"))
        lu.assertFalse(tip_progress.was_shown("fishing.barrel"))
    end

    function suite:test_bank_snapshot_only_keeps_relevant_items()
        local fake = client.new(root)
        local owned_items = fake.load("src/storage/owned_items")
        local bank = { MINING_OREBOX_IRON = 1, COINS = 5000 }

        owned_items.use_character("alice")
        lu.assertFalse(owned_items.bank_seen())

        owned_items.update_from_bank(
            { MINING_OREBOX_IRON = true, MINING_OREBOX_BRONZE = true },
            { [4448] = true },
            function(item)
                return bank[item]
            end,
            function(category)
                return category == 4448 and 1 or 0
            end
        )

        lu.assertTrue(owned_items.bank_seen())
        lu.assertTrue(owned_items.in_bank("MINING_OREBOX_IRON"))
        lu.assertFalse(owned_items.in_bank("MINING_OREBOX_BRONZE"))
        lu.assertFalse(owned_items.in_bank("COINS"))
        lu.assertTrue(owned_items.category_in_bank(4448))
        lu.assertNil(fake.saved.skilling_coach_owned_alice.items.COINS)
    end

    function suite:test_listeners_hear_about_pins_until_they_stop_listening()
        local tip_progress = client.new(root).load("src/storage/tip_progress")
        local heard = 0

        tip_progress.use_character("alice")
        tip_progress.listen("window", function()
            heard = heard + 1
        end)
        tip_progress.pin("mining.ore_box")
        tip_progress.unpin("mining.ore_box")
        tip_progress.stop_listening("window")
        tip_progress.pin("mining.ore_box")

        lu.assertEquals(heard, 2)
    end

    function suite:test_pinning_redraws_an_open_ribbon_window()
        local fake = client.new(root)
        local app = fake.load("src/app")
        local tip_progress = fake.load("src/storage/tip_progress")

        app.start()
        fake.fire("ContentLayerReady", { component = {} })
        fake.views[1].buttons[1].action()
        tip_progress.pin("mining.ore_box")

        lu.assertTrue(fake.windows[1].destroyed)
        lu.assertEquals(fake.windows[#fake.windows].options.title, "Pinned tips")
        lu.assertEquals(fake.tooltips[#fake.tooltips].options.text, "Unpin Ore box")
        lu.assertEquals(fake.labels[#fake.labels].options.text, "Ore box")

        app.stop()
    end

    function suite:test_a_failed_save_is_logged_and_the_change_kept()
        local fake = client.new(root)
        fake.fail_saves = true
        local tip_progress = fake.load("src/storage/tip_progress")

        tip_progress.use_character("alice")
        tip_progress.dismiss("mining.ore_box")

        lu.assertTrue(tip_progress.is_dismissed("mining.ore_box"))
        lu.assertStrContains(fake.logs[1], "couldn't save")
    end

    function suite:test_pending_level_ups_recover_per_field_and_stay_per_character()
        local fake = client.new(root)
        fake.saved.skilling_coach_progress_alice = {
            version = 1,
            pinned = { tip = true },
            pending_level_ups = {
                MINING = { old = 69, new = 70 },
                WOODCUTTING = { old = "bad", new = 30 },
                FAKE = { old = 1, new = 2 },
                FISHING = false,
            },
        }
        local progress = fake.load("src/storage/tip_progress")
        progress.use_character("alice")
        lu.assertTrue(progress.is_pinned("tip"))
        lu.assertEquals(progress.pending_level_up("MINING"), { old = 69, new = 70 })
        lu.assertNil(progress.pending_level_up("WOODCUTTING"))
        lu.assertNil(progress.pending_level_up("FAKE"))
        progress.queue_level_up("MINING", 70, 75)
        progress.queue_level_up("MINING", 0, 99)
        lu.assertEquals(progress.pending_level_up("MINING"), { old = 69, new = 75 })
        local copy = progress.pending_level_up("MINING")
        copy.new = 99
        lu.assertEquals(progress.pending_level_up("MINING").new, 75)
        progress.use_character("bob")
        lu.assertNil(progress.pending_level_up("MINING"))
        progress.use_character("alice")
        lu.assertEquals(progress.pending_level_up("MINING").new, 75)
        progress.clear_level_up("MINING")
        progress.use_character("bob")
        progress.use_character("alice")
        lu.assertNil(progress.pending_level_up("MINING"))
        lu.assertTrue(progress.is_pinned("tip"))
    end

    function suite:test_pending_level_ups_survive_reload_and_old_saves_without_the_field()
        local fake = client.new(root)
        local progress = fake.load("src/storage/tip_progress")
        progress.use_character("alice")
        progress.queue_level_up("MINING", 69, 70)
        local reload = client.new(root)
        reload.saved = fake.saved
        local restored = reload.load("src/storage/tip_progress")
        restored.use_character("alice")
        lu.assertEquals(restored.pending_level_up("MINING"), { old = 69, new = 70 })
        reload.saved.skilling_coach_progress_old = { version = 1, dismissed = { old_tip = true } }
        restored.use_character("old")
        lu.assertNil(restored.pending_level_up("MINING"))
        lu.assertTrue(restored.is_dismissed("old_tip"))
    end

    function suite:test_redisplayed_tip_moves_to_top_without_a_duplicate()
        local fake = client.new(root)
        local progress = fake.load("src/storage/tip_progress")
        progress.use_character("alice")
        for index = 1, 12 do
            progress.mark_shown("tip" .. index)
        end
        progress.mark_shown("tip5")
        local recent = progress.recent_tips()
        lu.assertEquals(#recent, 10)
        lu.assertEquals(recent[1].id, "tip5")
        lu.assertEquals(recent[2].id, "tip12")
        local seen = {}
        for _, entry in ipairs(recent) do
            lu.assertNil(seen[entry.id])
            seen[entry.id] = true
        end
        progress.use_character("bob")
        progress.use_character("alice")
        lu.assertEquals(progress.recent_tips(), recent)
    end

    function suite:test_saved_history_duplicates_collapse_to_the_newest_occurrence()
        local fake = client.new(root)
        fake.saved.skilling_coach_progress_alice = {
            version = 1,
            dismissed = { a = true },
            pinned = { b = true },
            recent_tips = {
                { id = "a", order = 1 },
                { id = "b", order = 2 },
                { id = "a", order = 3 },
            },
        }
        local progress = fake.load("src/storage/tip_progress")
        progress.use_character("alice")
        lu.assertEquals(
            progress.recent_tips(),
            { { id = "a", order = 3 }, { id = "b", order = 2 } }
        )
        lu.assertTrue(progress.is_dismissed("a"))
        lu.assertTrue(progress.is_pinned("b"))
    end

    function suite:test_dismissal_timer_expiry_reload_and_characters()
        local fake = client.new(root)
        local progress = fake.load("src/storage/tip_progress")
        local settings = fake.load("src/storage/settings")
        lu.assertEquals(settings.get("dismiss_hours"), 3)
        lu.assertFalse(settings.set("dismiss_hours", -1))
        lu.assertFalse(settings.set("dismiss_hours", 9))
        lu.assertFalse(settings.set("dismiss_hours", 1.5))
        progress.use_character("alice")
        progress.start()
        fake.fire("Logic", { logicTick = 100 })
        progress.mark_shown("test")
        progress.dismiss("test")
        lu.assertFalse(progress.was_shown("test"))
        fake.fire("Logic", { logicTick = 100 + 2 * 3600 * 50 })
        lu.assertTrue(progress.is_dismissed("test"))
        progress.stop()
        -- simulate reload: offline time never advances the saved elapsed value.
        local reload = client.new(root)
        reload.saved = fake.saved
        local restored = reload.load("src/storage/tip_progress")
        restored.use_character("alice")
        restored.start()
        reload.fire("Logic", { logicTick = 10 })
        restored.use_character("bob")
        lu.assertFalse(restored.is_dismissed("test"))
        reload.fire("Logic", { logicTick = 2000000 })
        restored.use_character("alice")
        lu.assertTrue(restored.is_dismissed("test"))
        reload.fire("Logic", { logicTick = 2000000 })
        reload.fire("Logic", { logicTick = 2000000 + 3600 * 50 - 1 })
        lu.assertTrue(restored.is_dismissed("test"))
        reload.fire("Logic", { logicTick = 2000000 + 3600 * 50 })
        lu.assertFalse(restored.is_dismissed("test"))
        restored.stop()
        lu.assertEquals(reload.total_subscriptions(), 0)
    end

    function suite:test_dismissal_setting_applies_to_active_timers_and_zero()
        local fake = client.new(root)
        local progress = fake.load("src/storage/tip_progress")
        local settings = fake.load("src/storage/settings")
        progress.use_character("alice")
        progress.start()
        fake.fire("Logic", { logicTick = 1 })
        progress.dismiss("test")
        fake.fire("Logic", { logicTick = 1 + 2 * 3600 * 50 })
        settings.set("dismiss_hours", 1)
        lu.assertFalse(progress.is_dismissed("test"))
        settings.set("dismiss_hours", 8)
        lu.assertTrue(progress.is_dismissed("test"))
        settings.set("dismiss_hours", 0)
        progress.mark_shown("test")
        progress.dismiss("test")
        lu.assertFalse(progress.is_dismissed("test"))
        lu.assertFalse(progress.was_shown("test"))
        progress.stop()
    end

    function suite:test_legacy_dismissal_migration_is_saved_once()
        local fake = client.new(root)
        fake.saved.skilling_coach_progress_alice = { version = 1, dismissed = { old = true } }
        local progress = fake.load("src/storage/tip_progress")
        progress.use_character("alice")
        lu.assertTrue(progress.is_dismissed("old"))
        lu.assertEquals(fake.saved.skilling_coach_progress_alice.dismissed.old, 0)
        progress.start()
        fake.fire("Logic", { logicTick = 0 })
        fake.fire("Logic", { logicTick = 3600 * 50 })
        progress.stop()
        local reload = client.new(root)
        reload.saved = fake.saved
        local restored = reload.load("src/storage/tip_progress")
        restored.use_character("alice")
        lu.assertEquals(reload.saved.skilling_coach_progress_alice.dismissed.old, 0)
        lu.assertEquals(reload.saved.skilling_coach_progress_alice.dismiss_elapsed, 3600)
        lu.assertTrue(restored.is_dismissed("old"))
    end

    return suite
end
