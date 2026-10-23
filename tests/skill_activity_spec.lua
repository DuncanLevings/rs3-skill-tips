local lu = require("luaunit")
local client = require("tests/support/client")

-- the click patterns seen in game (docs/api-findings.md, check 6)
local DIALOGUE_CONFIRM = { action_type = 30, verb = "Confirm: Firemaking", is_item = false }
local RUB_LAMP = { action_type = 57, verb = "Rub", is_item = true }
local MINE_ROCK = { action_type = 2, verb = "Mine", is_item = false }

return function(root)
    local suite = {}
    local tracker

    function suite:setUp()
        tracker = client.new(root).load("src/game/skill_activity").new()
    end

    function suite:test_steady_mining_counts_as_training_on_the_third_drop()
        tracker.click(MINE_ROCK, 0)

        lu.assertFalse(tracker.xp("MINING", 2))
        lu.assertFalse(tracker.xp("MINING", 6))
        lu.assertTrue(tracker.xp("MINING", 10))
        lu.assertTrue(tracker.xp("MINING", 14))
    end

    function suite:test_one_lamp_is_not_training()
        tracker.click(RUB_LAMP, 100)
        tracker.click(DIALOGUE_CONFIRM, 103)

        lu.assertFalse(tracker.xp("FIREMAKING", 103.3))
    end

    function suite:test_five_lamps_in_a_row_are_not_training()
        for lamp = 0, 4 do
            local start = 100 + lamp * 4
            tracker.click(RUB_LAMP, start)
            tracker.click(DIALOGUE_CONFIRM, start + 3)

            lu.assertFalse(tracker.xp("FIREMAKING", start + 3.3))
        end
    end

    function suite:test_quest_reward_xp_in_several_skills_is_not_training()
        tracker.click({ action_type = 30, verb = "Continue", is_item = false }, 50)

        lu.assertFalse(tracker.xp("COOKING", 50.4))
        lu.assertFalse(tracker.xp("COOKING", 50.5))
        lu.assertFalse(tracker.xp("COOKING", 50.6))
    end

    function suite:test_drops_spread_wider_than_the_window_do_not_count()
        lu.assertFalse(tracker.xp("WOODCUTTING", 0))
        lu.assertFalse(tracker.xp("WOODCUTTING", 100))
        lu.assertFalse(tracker.xp("WOODCUTTING", 230))
    end

    function suite:test_a_lamp_mid_session_does_not_count_but_training_carries_on()
        tracker.xp("MINING", 0)
        tracker.xp("MINING", 4)
        tracker.click(RUB_LAMP, 5)
        tracker.click(DIALOGUE_CONFIRM, 7)

        lu.assertFalse(tracker.xp("MINING", 7.2))
        -- still inside the 30s after rubbing, so the next real drop is ignored too
        lu.assertFalse(tracker.xp("MINING", 20))
        lu.assertTrue(tracker.xp("MINING", 40))
    end

    function suite:test_skills_are_counted_separately()
        tracker.xp("MINING", 0)
        tracker.xp("SMITHING", 1)

        lu.assertFalse(tracker.xp("MINING", 2))
    end

    return suite
end
