local lu = require("luaunit")
local client = require("tests/support/client")

local function world(root, setup)
    local fake = client.new(root)
    if setup then
        setup(fake)
    end
    local app = fake.load("src/app")
    app.start()
    return fake, app, fake.load("src/storage/tip_progress")
end

return function(root)
    local suite = {}

    function suite:test_a_body_piece_teaches_its_outfit_even_when_tips_are_disabled()
        local fake, app, progress = world(root)
        fake.load("src/storage/settings").set("tips_enabled", false)
        fake.inventories[93] = { { item = "TRH19_BLUE_BODY", category = 3226 } }
        fake.fire("InventoryUpdated", { inv = { id = 93 } })
        lu.assertTrue(progress.is_known("mining.golem_outfit"))
        app.stop()
    end

    function suite:test_known_tip_survives_removal_empty_bank_and_reload()
        local fake, app, progress = world(root, function(client)
            client.inventories[93] = { { item = "TRH19_BLUE_BODY", category = 3226 } }
        end)
        fake.inventories[93] = {}
        fake.inventories[95] = {}
        fake.fire("InventoryAdded", { inv = { id = 95 } })
        lu.assertTrue(progress.is_known("mining.golem_outfit"))
        app.stop()

        local reload, next_app, loaded = world(root, function(client)
            client.saved = fake.saved
            client.inventories[95] = {}
        end)
        lu.assertTrue(loaded.is_known("mining.golem_outfit"))
        local state = reload.load("src/game/player_state")
        lu.assertFalse(state.owns_category(3226))
        lu.assertFalse(
            reload
                .load("src/coach/eligibility")
                .allows(reload.load("src/tips/catalogue").get("mining.golem_outfit"), "MINING", state)
        )
        next_app.stop()
    end

    function suite:test_all_basic_and_elite_outfits_accept_any_confirmed_category_piece()
        for _, outfit in ipairs({
            { "mining.golden_mining_suit", 4155 },
            { "woodcutting.lumberjack_outfit", 4158 },
            { "fishing.fishing_outfit", 2677 },
            { "mining.golem_outfit", 3226 },
            { "mining.golem_outfit", 3227 },
            { "mining.golem_outfit", 3228 },
            { "mining.golem_outfit", 3229 },
            { "woodcutting.sentinel_outfit", 4097 },
            { "woodcutting.sentinel_outfit", 4098 },
            { "woodcutting.sentinel_outfit", 4099 },
            { "woodcutting.sentinel_outfit", 4100 },
            { "fishing.shark_outfit", 3497 },
            { "fishing.shark_outfit", 3498 },
            { "fishing.shark_outfit", 3499 },
            { "fishing.shark_outfit", 3500 },
        }) do
            local _, app, progress = world(root, function(fake)
                fake.inventories[94] = { { item = "A_SINGLE_BODY_PIECE", category = outfit[2] } }
            end)
            lu.assertTrue(progress.is_known(outfit[1]), outfit[1] .. ": " .. outfit[2])
            app.stop()
        end
    end

    function suite:test_bank_update_is_observed_before_other_inventory_subscribers()
        local fake, app, progress = world(root)
        fake.inventories[95] = { { item = "TRH48_SHARK_BODY_FURY", category = 3500 } }
        fake.handlers.InventoryUpdated.skilling_coach_item_knowledge({ inv = { id = 95 } })
        lu.assertTrue(progress.is_known("fishing.shark_outfit"))
        app.stop()
    end

    function suite:test_saved_bank_evidence_is_remembered_before_empty_bank_replaces_it()
        local _, app, progress = world(root, function(fake)
            fake.saved.skilling_coach_owned_test_player = {
                version = 1,
                bank_seen = true,
                items = { TRH48_SHARK_HEAD_NORMAL = true },
                categories = { ["3497"] = true },
            }
            fake.inventories[95] = {}
        end)
        lu.assertTrue(progress.is_known("fishing.shark_outfit"))
        app.stop()
    end

    function suite:test_inventory_event_before_character_poll_keeps_memory_separate()
        local fake, app, progress = world(root)
        fake.player.name = "Bob"
        fake.inventories[93] = { { item = "TRH19_MAGIC_BODY", category = 3229 } }
        fake.fire("InventoryUpdated", { inv = { id = 93 } })
        lu.assertEquals(progress.character(), "bob")
        lu.assertTrue(progress.is_known("mining.golem_outfit"))
        progress.use_character("test_player")
        lu.assertFalse(progress.is_known("mining.golem_outfit"))
        app.stop()
    end

    function suite:test_repeated_observations_write_only_when_new_knowledge_is_added()
        local fake, app, progress = world(root)
        local writes = 0
        local db = fake.environment.PersistentDB
        fake.environment.PersistentDB = {
            GetStructuredData = function(_, key)
                return db:GetStructuredData(key)
            end,
            SetStructuredData = function(_, key, value)
                if key == "skilling_coach_progress_test_player" then
                    writes = writes + 1
                end
                return db:SetStructuredData(key, value)
            end,
        }
        fake.inventories[93] = { { item = "TRH19_BLUE_BODY", category = 3226 } }
        fake.fire("InventoryUpdated", { inv = { id = 93 } })
        fake.fire("InventoryUpdated", { inv = { id = 93 } })
        lu.assertTrue(progress.is_known("mining.golem_outfit"))
        lu.assertEquals(writes, 1)
        app.stop()
    end

    function suite:test_only_ownership_conditions_become_permanent_knowledge()
        local fake, app, progress = world(root)
        fake.load("src/tips/catalogue").all = function()
            return {
                {
                    id = "live.condition",
                    known_when = { { type = "has_level", skill = "MINING", level = 1 } },
                },
            }
        end
        fake.load("src/coach/item_knowledge").observe(fake.load("src/game/player_state"))
        lu.assertFalse(progress.is_known("live.condition"))
        app.stop()
    end

    function suite:test_corrupt_known_field_does_not_drop_pins_or_dismissals()
        local fake = client.new(root)
        fake.saved.skilling_coach_progress_alice = {
            version = 1,
            known = { valid = true, invalid = 1, [3] = true },
            dismissed = { hidden = true },
            pinned = { keep = true },
        }
        local progress = fake.load("src/storage/tip_progress")
        progress.use_character("alice")
        lu.assertTrue(progress.is_known("valid"))
        lu.assertFalse(progress.is_known("invalid"))
        lu.assertTrue(progress.is_dismissed("hidden"))
        lu.assertTrue(progress.is_pinned("keep"))
    end

    function suite:test_stale_inventory_callback_and_logged_out_events_do_nothing()
        local fake, app, progress = world(root)
        local old = fake.handlers.InventoryUpdated.skilling_coach_item_knowledge
        app.stop()
        fake.inventories[93] = { { item = "TRH19_BLUE_BODY", category = 3226 } }
        old({ inv = { id = 93 } })
        lu.assertNil(progress.character())
        lu.assertEquals(fake.total_subscriptions(), 0)
    end

    return suite
end
