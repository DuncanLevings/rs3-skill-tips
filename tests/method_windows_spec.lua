-- an old training suggestion must age out, even after reward jumps or exhausting other tips.
local lu = require("luaunit")
local client = require("tests/support/client")

return function(root)
    local suite = {}

    function suite:test_superseded_methods_stop_at_the_recommendation_boundary()
        local fake = client.new(root)
        local catalogue = fake.load("src/tips/catalogue")
        local eligibility = fake.load("src/coach/eligibility")
        local levels = {}
        local state = {
            level = function(skill)
                return levels[skill] or 120
            end,
            quest_done = function()
                return true
            end,
            owns_item = function()
                return false
            end,
        }
        for _, case in ipairs({
            { "hunter.alt.plain_whirligigs", "HUNTER", 29 },
            { "hunter.alt.red_salamanders", "HUNTER", 66 },
            { "divination.alt.lustrous", "DIVINATION", 79 },
            { "divination.alt.luminous", "DIVINATION", 94 },
            { "woodcutting.alt.creeping_ivy", "WOODCUTTING", 67 },
            { "fishing.alt.minnow_shoals", "FISHING", 91 },
            { "farming.alt.beehives", "FARMING", 49 },
            { "divination.method.hall_of_memories", "DIVINATION", 99 },
        }) do
            local tip = catalogue.get(case[1])
            levels[case[2]] = case[3]
            lu.assertTrue(eligibility.allows(tip, case[2], state), case[1])
            levels[case[2]] = case[3] + 1
            lu.assertFalse(eligibility.allows(tip, case[2], state), case[1])
            levels[case[2]] = 120
            lu.assertFalse(eligibility.allows(tip, case[2], state), case[1])
        end
    end

    function suite:test_level_reward_queue_cannot_resurface_a_superseded_method()
        local fake = client.new(root)
        fake.player.levels[10] = 95
        local catalogue = fake.load("src/tips/catalogue")
        local progress = fake.load("src/storage/tip_progress")
        progress.use_character("alice")
        for _, tip in ipairs(catalogue.all()) do
            if tip.id ~= "fishing.alt.minnow_shoals" then
                progress.mark_shown(tip.id)
            end
        end
        local engine = fake.load("src/coach/engine")
        local shown = 0
        engine.start({
            state = fake.load("src/game/player_state"),
            now = function()
                return 1000
            end,
            show_card = function()
                shown = shown + 1
            end,
        })
        engine.on_level_up("FISHING", 67, 95)
        engine.on_training("FISHING")
        lu.assertEquals(shown, 0)
        lu.assertNil(engine.pick_tip("FISHING"))
    end

    return suite
end
