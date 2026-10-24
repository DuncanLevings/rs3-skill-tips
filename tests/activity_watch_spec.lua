local lu = require("luaunit")
local client = require("tests/support/client")

return function(root)
    local suite = {}
    local function world()
        local fake = client.new(root)
        local watch = fake.load("src/game/activity_watch")
        local clock = fake.load("src/game/clock")
        local trained, combat = {}, 0
        local tick = 0
        local handlers = {
            on_training = function(skill)
                trained[#trained + 1] = skill
            end,
            on_combat = function()
                combat = combat + 1
            end,
        }
        clock.start()
        fake.fire("Logic", { logicTick = 0 })
        watch.start(handlers)
        return {
            fake = fake,
            watch = watch,
            handlers = handlers,
            trained = trained,
            combat = function()
                return combat
            end,
            xp = function(skill, old)
                fake.fire("SkillTransmit", { skill = skill or 14, oldXP = old or 100, newXP = 110 })
            end,
            advance = function(seconds)
                tick = tick + seconds * 50
                fake.fire("Logic", { logicTick = tick })
            end,
            click = function(entry)
                fake.fire("MiniMenuEntrySelected", { entry = entry })
            end,
        }
    end

    function suite:test_login_sync_is_ignored_and_real_mining_requires_three_drops()
        local w = world()
        w.xp(14, 0)
        w.xp()
        w.advance(3)
        w.xp()
        lu.assertEquals(w.trained, {})
        w.advance(3)
        w.xp()
        lu.assertEquals(w.trained, { "MINING" })
    end

    function suite:test_quest_reward_and_one_lamp_do_not_report_training()
        local w = world()
        w.click({ actionType = 30, verbText = "Continue" })
        w.xp(14)
        w.xp(8)
        w.xp(13)
        lu.assertEquals(w.trained, {})
        w.advance(3)
        w.click({ verbText = "Rub", componentData = { objConfig = {} } })
        w.xp()
        w.xp()
        w.xp()
        lu.assertEquals(w.trained, {})
    end

    function suite:test_five_lamps_in_a_row_and_book_rewards_are_filtered()
        local w = world()
        for _ = 1, 5 do
            w.click({ verbText = "Rub", componentData = { objConfig = {} } })
            w.advance(1)
            w.click({ actionType = 30, verbText = "Confirm" })
            w.xp()
            w.advance(3)
        end
        w.click({ verbText = "Read", componentData = { objConfig = {} } })
        for _ = 1, 3 do
            w.advance(3)
            w.xp()
        end
        lu.assertEquals(w.trained, {})
    end

    function suite:test_real_training_resumes_after_reward_guard_and_skills_stay_separate()
        local w = world()
        w.click({ verbText = "Rub", componentData = { objConfig = {} } })
        w.xp()
        w.advance(31)
        w.xp()
        w.advance(3)
        w.xp(8)
        w.xp()
        lu.assertEquals(w.trained, {})
        w.advance(3)
        w.xp()
        lu.assertEquals(w.trained, { "MINING" })
    end

    function suite:test_logout_and_reset_clear_training_history()
        local w = world()
        w.xp()
        w.xp()
        w.fake.player = nil
        w.xp()
        w.fake.player = { name = "Bob", levels = {} }
        w.xp()
        lu.assertEquals(w.trained, {})
        w.watch.reset()
        w.xp()
        w.xp()
        lu.assertEquals(w.trained, {})
        w.xp()
        lu.assertEquals(w.trained, { "MINING" })
    end

    function suite:test_combat_is_separate_and_old_activity_callbacks_are_ignored()
        local w = world()
        w.xp(0)
        lu.assertEquals(w.combat(), 1)
        lu.assertEquals(w.trained, {})
        local old = w.fake.handlers.SkillTransmit.skilling_coach_activity
        w.watch.stop()
        w.watch.start(w.handlers)
        old({ skill = 14, oldXP = 100, newXP = 110 })
        old({ skill = 14, oldXP = 100, newXP = 110 })
        w.xp()
        lu.assertEquals(w.trained, {})
        w.watch.start(w.handlers)
        lu.assertEquals(w.fake.subscription_count("SkillTransmit"), 1)
        w.watch.stop()
        old({ skill = 0, oldXP = 100, newXP = 110 })
        lu.assertEquals(w.combat(), 1)
        lu.assertEquals(w.fake.logs, {})
    end

    function suite:test_reward_level_up_is_reported_but_training_remains_guarded()
        local w = world()
        local levels = {}
        w.handlers.on_level_up = function(skill, old, new)
            levels[#levels + 1] = { skill, old, new }
        end
        w.click({ actionType = 30, verbText = "Confirm" })
        w.fake.fire("SkillTransmit", {
            skill = 14,
            oldXP = 100,
            newXP = 200,
            oldGameplayLevel = 19,
            newGameplayLevel = 20,
        })
        lu.assertEquals(levels, { { "MINING", 19, 20 } })
        lu.assertEquals(w.trained, {})
        w.fake.fire("SkillTransmit", {
            skill = 14,
            oldXP = 0,
            newXP = 200,
            oldGameplayLevel = 0,
            newGameplayLevel = 20,
        })
        lu.assertEquals(#levels, 1)
    end

    function suite:test_quiet_pause_fires_at_five_seconds_and_gathering_holds_it()
        local fake = client.new(root)
        local clock = fake.load("src/game/clock")
        local now, quiet = 0, 0
        clock.now = function()
            return now
        end
        local watch = fake.load("src/game/activity_watch")
        watch.start({
            on_training = function() end,
            on_combat = function() end,
            on_quiet = function()
                quiet = quiet + 1
            end,
        })
        now = 4.99
        fake.fire("Logic", { logicTick = 25 })
        lu.assertEquals(quiet, 0)
        now = 5
        fake.fire("Logic", { logicTick = 50 })
        lu.assertEquals(quiet, 1)
        fake.fire("MiniMenuEntrySelected", { entry = { verbText = "Chop down", locData = {} } })
        now = 100
        fake.fire("Logic", { logicTick = 75 })
        lu.assertEquals(quiet, 1)
        fake.fire("MiniMenuEntrySelected", { entry = { verbText = "Walk here" } })
        now = 104.99
        fake.fire("Logic", { logicTick = 100 })
        lu.assertEquals(quiet, 1)
        now = 105
        fake.fire("Logic", { logicTick = 125 })
        lu.assertEquals(quiet, 2)
        watch.stop()
    end

    return suite
end
