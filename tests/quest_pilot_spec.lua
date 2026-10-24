-- shipped quest data through readiness, queueing and the real five-second activity guard.
local lu = require("luaunit")
local client = require("tests/support/client")

local function world(root, id)
    local fake = client.new(root)
    local catalogue = fake.load("src/tips/catalogue")
    local tip = catalogue.get(id)
    local skills = fake.load("src/data/skills")
    for skill, needed in pairs(tip.requirements.skills) do
        fake.player.levels[skills.number(skill)] = needed
    end
    fake.quests[tip.quest] = { hasFinishedQuest = false }
    return fake, tip, skills
end

return function(root)
    local suite = {}

    function suite:test_shipped_quests_wait_for_every_skill_and_known_completion_state()
        for _, id in ipairs({ "quest.fishing_contest", "quest.family_crest" }) do
            local fake, tip, skills = world(root, id)
            local eligibility = fake.load("src/coach/eligibility")
            local state = fake.load("src/game/player_state")
            lu.assertTrue(eligibility.quest_ready(tip, state), id)
            for skill, needed in pairs(tip.requirements.skills) do
                fake.player.levels[skills.number(skill)] = needed - 1
                lu.assertFalse(eligibility.quest_ready(tip, state), id .. ": " .. skill)
                fake.player.levels[skills.number(skill)] = needed
            end
            fake.quests[tip.quest].hasFinishedQuest = true
            lu.assertFalse(eligibility.quest_ready(tip, state), id)
            fake.quests[tip.quest] = nil
            lu.assertFalse(eligibility.quest_ready(tip, state), id)
        end
    end

    function suite:test_fishing_contest_waits_five_seconds_after_level_up()
        local fake, tip = world(root, "quest.fishing_contest")
        local app = fake.load("src/app")
        app.start()
        fake.fire("Logic", { logicTick = 0 })
        local progress = fake.load("src/storage/tip_progress")
        fake.fire("SkillTransmit", {
            skill = 10,
            oldXP = 100,
            newXP = 200,
            oldGameplayLevel = 9,
            newGameplayLevel = 10,
        })
        lu.assertTrue(progress.queued_quests()[tip.id])
        lu.assertEquals(#fake.windows, 0)
        fake.fire("Logic", { logicTick = 225 })
        lu.assertEquals(#fake.windows, 0)
        fake.fire("Logic", { logicTick = 250 })
        lu.assertEquals(#fake.windows, 1)
        lu.assertEquals(progress.recent_tips()[1].id, tip.id)
        app.stop()
    end

    function suite:test_family_crest_combat_level_waits_for_combat_quiet_time()
        local fake, tip = world(root, "quest.family_crest")
        local app = fake.load("src/app")
        app.start()
        fake.fire("Logic", { logicTick = 0 })
        local progress = fake.load("src/storage/tip_progress")
        fake.fire("SkillTransmit", {
            skill = 6,
            oldXP = 100,
            newXP = 200,
            oldGameplayLevel = 58,
            newGameplayLevel = 59,
        })
        lu.assertTrue(progress.queued_quests()[tip.id])
        fake.fire("Logic", { logicTick = 2950 })
        lu.assertEquals(#fake.windows, 0)
        fake.fire("Logic", { logicTick = 3000 })
        lu.assertEquals(#fake.windows, 1)
        lu.assertEquals(progress.recent_tips()[1].id, tip.id)
        app.stop()
    end

    function suite:test_real_quest_waits_behind_an_open_card()
        local fake, tip = world(root, "quest.fishing_contest")
        local engine = fake.load("src/coach/engine")
        local shown, now = {}, 1000
        engine.start({
            state = fake.load("src/game/player_state"),
            now = function()
                return now
            end,
            show_card = function(candidate, handlers)
                shown[#shown + 1] = { tip = candidate, handlers = handlers }
                return true
            end,
        })
        engine.on_training("FISHING")
        lu.assertEquals(#shown, 1)
        lu.assertNotEquals(shown[1].tip.kind, "quest")
        engine.on_quiet()
        lu.assertEquals(#shown, 1)
        shown[1].handlers.on_closed()
        now = now + 600
        engine.on_quiet()
        lu.assertEquals(shown[2].tip.id, tip.id)
    end

    function suite:test_reload_on_an_old_client_still_waits_five_seconds()
        local fake, tip = world(root, "quest.fishing_contest")
        local app = fake.load("src/app")
        local base = 9000000
        for attempt = 1, 2 do
            local before = #fake.windows
            app.start()
            fake.fire("Logic", { logicTick = base })
            lu.assertEquals(#fake.windows, before)
            fake.fire("Logic", { logicTick = base + 225 })
            lu.assertEquals(#fake.windows, before)
            fake.fire("Logic", { logicTick = base + 250 })
            lu.assertEquals(#fake.windows, before + 1)
            lu.assertEquals(fake.load("src/storage/tip_progress").recent_tips()[1].id, tip.id)
            app.stop()
            base = base + 100000
        end
    end

    return suite
end
