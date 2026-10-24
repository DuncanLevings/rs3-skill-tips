-- the real mining tips going through the real engine: each level gets its own bracket and
-- never a passed one

local lu = require("luaunit")
local client = require("tests/support/client")

local MINING = 14

local function setup(root, mining_level)
    local fake = client.new(root)
    local shown = {}

    fake.player.levels[MINING] = mining_level

    local owned_items = fake.load("src/storage/owned_items")
    local tip_progress = fake.load("src/storage/tip_progress")
    local engine = fake.load("src/coach/engine")

    owned_items.use_character("alice")
    tip_progress.use_character("alice")

    engine.start({
        state = fake.load("src/game/player_state"),
        now = function()
            return 1000
        end,
        show_card = function(tip, handlers)
            shown[#shown + 1] = { tip = tip, handlers = handlers }
        end,
    })

    return fake, engine, shown
end

return function(root)
    local suite = {}

    function suite:test_each_level_gets_its_own_bracket()
        local cases = {
            { 15, "mining.method.iron" },
            { 55, "mining.method.runite" },
            { 75, "mining.method.necrite_phasmatite" },
            { 92, "mining.method.animica" },
            { 104, "mining.method.primal" },
        }

        for _, case in ipairs(cases) do
            local _, engine, shown = setup(root, case[1])
            engine.on_training("MINING")

            lu.assertEquals(shown[1] and shown[1].tip.id, case[2], "level " .. case[1])
        end
    end

    function suite:test_members_ores_stay_hidden_with_members_tips_off()
        local fake, engine, shown = setup(root, 75)
        fake.load("src/storage/settings").set("show_members", false)

        engine.on_training("MINING")

        -- no members ore, but a free alternative like shooting stars is still fair game
        lu.assertEquals(#shown, 1)
        lu.assertFalse(shown[1].tip.members)
        lu.assertEquals(shown[1].tip.id, "mining.alt.shooting_stars")
    end

    function suite:test_alternatives_come_after_the_levels_main_method()
        local _, engine, shown = setup(root, 75)

        engine.on_training("MINING")
        lu.assertEquals(shown[1].tip.id, "mining.method.necrite_phasmatite")

        -- Later on the main method, cooldown over, still mining: now the remaining curated
        -- alternative
        shown[1].handlers.on_later()
        shown[1].handlers.on_closed()
        engine.reset_pacing()
        engine.on_training("MINING")

        lu.assertEquals(shown[2].tip.id, "mining.alt.shooting_stars")
    end

    function suite:test_item_tips_wait_for_their_level_in_the_trained_skill()
        local eligibility_world = client.new(root)
        local eligibility = eligibility_world.load("src/coach/eligibility")
        local catalogue = eligibility_world.load("src/tips/catalogue")
        local state = eligibility_world.load("src/game/player_state")
        local cape = catalogue.get("mining.cape")
        local golem = catalogue.get("mining.golem_outfit")
        eligibility_world.load("src/storage/owned_items").update_from_bank({}, {}, function()
            return 0
        end, function()
            return 0
        end)

        eligibility_world.player.levels[MINING] = 15
        lu.assertFalse(eligibility.allows(cape, "MINING", state))
        lu.assertFalse(eligibility.allows(golem, "MINING", state))

        -- the suggested fragment-crafting route also needs Invention 20
        eligibility_world.player.levels[MINING] = 85
        lu.assertFalse(eligibility.allows(golem, "MINING", state))
        eligibility_world.player.levels[26] = 20
        lu.assertTrue(eligibility.allows(golem, "MINING", state))
        lu.assertFalse(eligibility.allows(cape, "MINING", state))
    end

    function suite:test_corrupted_ore_waits_for_plagues_end()
        local fake, engine, shown = setup(root, 89)
        fake.quests.PLAGUES_END = { hasFinishedQuest = false, name = "Plague's End" }

        engine.on_training("MINING")

        lu.assertEquals(shown[1].tip.id, "mining.method.corrupted_ore")
        -- not done yet, but the tip still shows it as the goal to work towards
        local requirement_list = fake.load("src/ui/requirement_list")
        local missing = requirement_list.missing(shown[1].tip, fake.load("src/game/player_state"))
        lu.assertEquals(missing, { "- Plague's End" })
    end

    return suite
end
