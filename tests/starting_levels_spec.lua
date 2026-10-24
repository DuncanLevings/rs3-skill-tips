-- onboarding skips advice the character already outgrew, without hiding discoveries.
local lu = require("luaunit")
local client = require("tests/support/client")

return function(root)
    local suite = {}

    function suite:test_capture_is_once_per_character_and_survives_reload()
        local fake = client.new(root)
        local progress = fake.load("src/storage/tip_progress")
        local levels = { WOODCUTTING = 17 }
        local state = {
            level = function(skill)
                return levels[skill]
            end,
        }
        progress.capture_starting_levels(state)
        lu.assertNil(progress.starting_level("WOODCUTTING"))
        progress.use_character("alice")
        progress.capture_starting_levels(state)
        lu.assertEquals(progress.starting_level("WOODCUTTING"), 17)
        levels.WOODCUTTING = 20
        progress.capture_starting_levels(state)
        lu.assertEquals(progress.starting_level("WOODCUTTING"), 17)
        progress.use_character("bob")
        progress.capture_starting_levels(state)
        lu.assertEquals(progress.starting_level("WOODCUTTING"), 20)
        progress.use_character("alice")
        lu.assertEquals(progress.starting_level("WOODCUTTING"), 17)
        local reloaded = client.new(root)
        reloaded.saved = fake.saved
        local restored = reloaded.load("src/storage/tip_progress")
        restored.use_character("alice")
        lu.assertEquals(restored.starting_level("WOODCUTTING"), 17)
    end

    function suite:test_invalid_login_levels_retry_without_replacing_valid_baselines()
        local fake = client.new(root)
        fake.saved.skilling_coach_progress_alice = {
            version = 1,
            pinned = { ["mining.ore_box"] = true },
            starting_levels = { MINING = 40, FISHING = -1, WOODCUTTING = "17", FAKE = 20 },
        }
        local progress = fake.load("src/storage/tip_progress")
        progress.use_character("alice")
        local levels = { MINING = 90, FISHING = 0, WOODCUTTING = 0 / 0, HUNTER = 121 }
        local state = {
            level = function(skill)
                return levels[skill]
            end,
        }
        progress.capture_starting_levels(state)
        lu.assertEquals(progress.starting_level("MINING"), 40)
        lu.assertNil(progress.starting_level("WOODCUTTING"))
        lu.assertNil(progress.starting_level("HUNTER"))
        levels.FISHING, levels.WOODCUTTING = 70, 17
        progress.capture_starting_levels(state)
        lu.assertEquals(progress.starting_level("FISHING"), 70)
        lu.assertEquals(progress.starting_level("WOODCUTTING"), 17)
        lu.assertTrue(progress.is_pinned("mining.ore_box"))
    end

    function suite:test_current_bracket_skips_but_next_unlock_and_alternatives_survive()
        local fake = client.new(root)
        local progress = fake.load("src/storage/tip_progress")
        progress.use_character("alice")
        fake.player.levels[8] = 17
        local state = fake.load("src/game/player_state")
        progress.capture_starting_levels(state)
        local eligibility = fake.load("src/coach/eligibility")
        local catalogue = fake.load("src/tips/catalogue")
        lu.assertFalse(
            eligibility.allows(catalogue.get("woodcutting.method.oak"), "WOODCUTTING", state)
        )
        fake.player.levels[8] = 20
        lu.assertTrue(
            eligibility.allows(catalogue.get("woodcutting.method.willow"), "WOODCUTTING", state)
        )
        fake.player.levels[14] = 50
        progress.capture_starting_levels(state)
        lu.assertTrue(
            eligibility.allows(catalogue.get("mining.alt.shooting_stars"), "MINING", state)
        )
        fake.load("src/storage/owned_items").update_from_bank({}, {}, function()
            return 0
        end, function()
            return 0
        end)
        lu.assertTrue(eligibility.allows(catalogue.get("mining.ore_box"), "MINING", state))
    end

    function suite:test_no_unreachable_starter_methods_ship()
        local fake = client.new(root)
        local catalogue = fake.load("src/tips/catalogue")
        for _, id in ipairs({
            "archaeology.method.tutorial",
            "divination.method.pale",
            "farming.method.manure",
            "fishing.method.crayfish",
            "hunter.method.crimson_swifts",
            "mining.method.copper_tin",
            "woodcutting.method.regular_trees",
        }) do
            lu.assertNil(catalogue.get(id), id)
        end
        for _, tip in ipairs(catalogue.all()) do
            if tip.main_method then
                lu.assertTrue(tip.level_range[1] > 1, tip.id)
            end
        end
    end

    function suite:test_app_records_before_training_and_preserves_future_unlock_on_restart()
        local fake = client.new(root)
        fake.player.levels[8] = 17
        local app = fake.load("src/app")
        local engine = fake.load("src/coach/engine")
        local progress = fake.load("src/storage/tip_progress")
        app.start()
        lu.assertEquals(progress.starting_level("WOODCUTTING"), 17)
        local selected = engine.pick_tip("WOODCUTTING")
        lu.assertTrue(selected == nil or selected.id ~= "woodcutting.method.oak")
        app.stop()
        fake.player.levels[8] = 20
        app.start()
        lu.assertEquals(progress.starting_level("WOODCUTTING"), 17)
        lu.assertEquals(engine.pick_tip("WOODCUTTING").id, "woodcutting.method.willow")
        app.stop()
    end

    function suite:test_app_retries_missing_levels_and_captures_character_switch_before_xp()
        local fake = client.new(root)
        fake.player.levels[8] = 0
        local app = fake.load("src/app")
        local progress = fake.load("src/storage/tip_progress")
        app.start()
        lu.assertNil(progress.starting_level("WOODCUTTING"))
        fake.player.levels[8] = 17
        fake.fire("ServerLogic")
        lu.assertEquals(progress.starting_level("WOODCUTTING"), 17)
        fake.player.name, fake.player.levels[8] = "Bob", 50
        fake.fire("SkillTransmit", { skill = 8, oldXP = 100, newXP = 110 })
        lu.assertEquals(progress.starting_level("WOODCUTTING"), 50)
        app.stop()
    end

    function suite:test_development_reset_can_preview_existing_methods_without_unpinning()
        local fake = client.new(root)
        local progress = fake.load("src/storage/tip_progress")
        progress.use_character("alice")
        fake.player.levels[8] = 17
        local state = fake.load("src/game/player_state")
        progress.capture_starting_levels(state)
        progress.pin("mining.ore_box")
        progress.allow_existing_methods()
        lu.assertEquals(progress.starting_level("WOODCUTTING"), 0)
        progress.capture_starting_levels(state)
        lu.assertEquals(progress.starting_level("WOODCUTTING"), 0)
        lu.assertTrue(progress.is_pinned("mining.ore_box"))
        local oak = fake.load("src/tips/catalogue").get("woodcutting.method.oak")
        lu.assertTrue(fake.load("src/coach/eligibility").allows(oak, "WOODCUTTING", state))
    end

    function suite:test_main_method_marker_is_explicit_and_schema_checked()
        local fake = client.new(root)
        local catalogue = fake.load("src/tips/catalogue")
        for _, tip in ipairs(catalogue.all()) do
            if tip.kind == "method" then
                lu.assertEquals(
                    tip.main_method == true,
                    tip.id:find(".method.", 1, true) ~= nil,
                    tip.id
                )
            end
        end
        local schema = fake.load("src/tips/schema")
        local tip = catalogue.get("woodcutting.method.oak")
        tip.main_method = "yes"
        lu.assertTrue(#schema.problems(tip) > 0)
    end

    function suite:test_captured_levels_are_not_reread_or_saved_on_every_event()
        local fake = client.new(root)
        local progress = fake.load("src/storage/tip_progress")
        progress.use_character("alice")
        progress.allow_existing_methods()
        progress.capture_starting_levels({
            level = function()
                error("an existing baseline should never be read again")
            end,
        })
        local original = fake.saved.skilling_coach_progress_alice
        progress.capture_starting_levels({
            level = function()
                return 99
            end,
        })
        lu.assertIs(fake.saved.skilling_coach_progress_alice, original)
    end

    return suite
end
