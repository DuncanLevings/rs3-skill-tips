local lu = require("luaunit")
local client = require("tests/support/client")

local function quest()
    return {
        id = "test.quest",
        kind = "quest",
        quest = "TEST_QUEST",
        skills = { "MINING", "SMITHING" },
        title = "Test quest tip",
        hook = "Test unlock benefit",
        why = "Test opportunity",
        how = { "Test direction" },
        members = false,
        priority = 1,
        requirements = { skills = { MINING = 50, SMITHING = 40 }, quests = { "PREREQUISITE" } },
        triggers = { { type = "requirements_met", skill = "ANY" } },
    }
end

local function world(root)
    local fake = client.new(root)
    local tip = quest()
    fake.load("src/tips/skills/mining")[1] = tip
    fake.quests.TEST_QUEST = { hasFinishedQuest = false }
    fake.quests.PREREQUISITE = { hasFinishedQuest = false }
    fake.player.levels[14] = 50
    fake.player.levels[13] = 40
    local engine = fake.load("src/coach/engine")
    local progress = fake.load("src/storage/tip_progress")
    progress.use_character("test_player")
    local shown, now = {}, 100
    engine.start({
        state = fake.load("src/game/player_state"),
        now = function()
            return now
        end,
        show_card = function(tip, handlers)
            shown[#shown + 1] = { tip = tip, handlers = handlers }
            return true
        end,
    })
    return {
        fake = fake,
        tip = tip,
        engine = engine,
        progress = progress,
        shown = shown,
        advance = function(seconds)
            now = now + seconds
        end,
    }
end

return function(root)
    local suite = {}

    function suite:test_quest_schema_requires_config_all_skills_and_readiness_trigger()
        local schema = client.new(root).load("src/tips/schema")
        lu.assertEquals(schema.problems(quest()), {})
        local bad = quest()
        bad.quest = nil
        lu.assertStrContains(table.concat(schema.problems(bad), " "), "quest config")
        bad = quest()
        bad.requirements.skills = {}
        lu.assertStrContains(table.concat(schema.problems(bad), " "), "all skill requirements")
        bad = quest()
        bad.requirements.skills = false
        lu.assertTrue(#schema.problems(bad) > 0)
        bad = quest()
        bad.triggers = { { type = "training", skill = "ANY" } }
        lu.assertStrContains(table.concat(schema.problems(bad), " "), "requirements_met")
        bad = quest()
        bad.level_range = { 50, 60 }
        lu.assertStrContains(table.concat(schema.problems(bad), " "), "method brackets")
    end

    function suite:test_all_skill_requirements_must_be_met()
        local w = world(root)
        w.fake.player.levels[13] = 39
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 0)
        w.fake.player.levels[13] = 40
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 1)
        lu.assertEquals(w.shown[1].tip.id, "test.quest")
    end

    function suite:test_unknown_completion_or_level_defers_and_completed_quest_is_hidden()
        local w = world(root)
        w.fake.quests.TEST_QUEST = nil
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 0)
        w.fake.quests.TEST_QUEST = { hasFinishedQuest = true }
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 0)
        w.fake.quests.TEST_QUEST.hasFinishedQuest = false
        w.fake.player.levels[13] = 1
        w.fake.environment.Player.GetLevelUncapped = function(skill)
            if skill == 14 then
                return 50
            end
        end
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 0)
    end

    function suite:test_returning_players_qualify_above_requirements_without_method_expiry()
        local w = world(root)
        w.fake.player.levels[14] = 99
        w.fake.player.levels[13] = 99
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 1)
        lu.assertFalse(w.fake.quests.PREREQUISITE.hasFinishedQuest)
        lu.assertEquals(w.engine.stage(w.tip), "mid")
    end

    function suite:test_quest_index_is_deduplicated_across_required_and_explicit_skills()
        local w = world(root)
        local catalogue = w.fake.load("src/tips/catalogue")
        lu.assertEquals(#catalogue.for_skill("MINING"), 1)
        lu.assertEquals(#catalogue.for_skill("SMITHING"), 1)
        lu.assertEquals(#catalogue.quest_tips(), 1)
        w.engine.on_quiet()
        w.shown[1].handlers.on_closed()
        w.advance(600)
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 1)
    end

    function suite:test_quest_category_pacing_and_history_are_applied()
        local w = world(root)
        local settings = w.fake.load("src/storage/settings")
        settings.set("show_quests", false)
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 0)
        settings.set("show_quests", true)
        settings.set("muted_skills", { SMITHING = true })
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 0)
        settings.set("muted_skills", {})
        w.engine.on_combat()
        w.advance(59)
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 0)
        w.advance(1)
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 1)
        lu.assertEquals(w.progress.recent_tips()[1].id, "test.quest")
    end

    function suite:test_reward_level_up_queues_then_waits_for_a_quiet_pause()
        local w = world(root)
        w.engine.stop()
        local app = w.fake.load("src/app")
        app.start()
        w.fake.fire(
            "MiniMenuEntrySelected",
            { entry = { verbText = "Rub", componentData = { objConfig = {} } } }
        )
        w.fake.fire(
            "SkillTransmit",
            { skill = 14, oldXP = 100, newXP = 200, oldGameplayLevel = 49, newGameplayLevel = 50 }
        )
        lu.assertTrue(w.progress.queued_quests()["test.quest"])
        lu.assertEquals(#w.fake.windows, 0)
        w.fake.fire("Logic", { logicTick = 1450 })
        lu.assertEquals(#w.fake.windows, 0)
        w.fake.fire("Logic", { logicTick = 2000 })
        w.fake.fire("Logic", { logicTick = 2025 })
        lu.assertEquals(#w.fake.windows, 1)
        lu.assertEquals(w.progress.recent_tips()[1].id, "test.quest")
        app.stop()
    end

    function suite:test_unrelated_woodcutting_does_not_release_a_queued_quest()
        local w = world(root)
        w.engine.stop()
        local app = w.fake.load("src/app")
        app.start()
        w.fake.fire(
            "SkillTransmit",
            { skill = 14, oldXP = 100, newXP = 200, oldGameplayLevel = 49, newGameplayLevel = 50 }
        )
        w.fake.fire("MiniMenuEntrySelected", { entry = { verbText = "Chop down", locData = {} } })
        for index = 1, 3 do
            w.fake.fire("Logic", { logicTick = index * 150 })
            w.fake.fire("SkillTransmit", { skill = 8, oldXP = 200, newXP = 210 })
        end
        w.fake.fire("Logic", { logicTick = 3000 })
        lu.assertEquals(#w.fake.windows, 0)
        w.fake.fire("MiniMenuEntrySelected", { entry = { verbText = "Walk here" } })
        w.fake.fire("Logic", { logicTick = 3500 })
        w.fake.fire("Logic", { logicTick = 3525 })
        lu.assertEquals(#w.fake.windows, 1)
        app.stop()
    end

    function suite:test_existing_card_and_cooldown_retain_the_quest_queue()
        local w = world(root)
        local other = quest()
        other.id, other.kind, other.quest = "other", "general", nil
        other.requirements = nil
        other.triggers = { { type = "training", skill = "MINING" } }
        w.fake.load("src/tips/skills/mining")[2] = other
        w.engine.on_training("MINING")
        lu.assertEquals(w.shown[1].tip.id, "other")
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 1)
        lu.assertTrue(w.progress.queued_quests()["test.quest"])
        w.shown[1].handlers.on_closed()
        w.advance(599)
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 1)
        w.advance(1)
        w.engine.on_quiet()
        lu.assertEquals(#w.shown, 2)
        lu.assertEquals(w.shown[2].tip.id, "test.quest")
        lu.assertNil(w.progress.queued_quests()["test.quest"])
    end

    function suite:test_combat_requirement_crossing_is_queued_without_showing()
        local w = world(root)
        w.tip.requirements.skills.ATTACK = 40
        w.fake.player.levels[0] = 40
        w.engine.stop()
        local app = w.fake.load("src/app")
        app.start()
        w.fake.fire(
            "SkillTransmit",
            { skill = 0, oldXP = 100, newXP = 200, oldGameplayLevel = 39, newGameplayLevel = 40 }
        )
        lu.assertEquals(w.progress.pending_level_up("ATTACK"), { old = 39, new = 40 })
        lu.assertEquals(#w.fake.windows, 0)
        for index = 1, 3 do
            w.fake.fire("Logic", { logicTick = index * 150 })
            w.fake.fire("SkillTransmit", { skill = 10, oldXP = 200, newXP = 210 })
        end
        lu.assertEquals(#w.fake.windows, 0)
        w.fake.fire("MiniMenuEntrySelected", { entry = { verbText = "Walk here" } })
        w.fake.fire("Logic", { logicTick = 3100 })
        w.fake.fire("Logic", { logicTick = 3125 })
        lu.assertEquals(#w.fake.windows, 1)
        app.stop()
    end

    function suite:test_failed_display_does_not_consume_history_or_session_pacing()
        local w = world(root)
        w.engine.start({
            state = w.fake.load("src/game/player_state"),
            now = function()
                return 100
            end,
            show_card = function()
                return false
            end,
        })
        w.engine.on_quiet()
        lu.assertEquals(w.progress.recent_tips(), {})
        lu.assertFalse(w.progress.was_shown("test.quest"))
    end

    function suite:test_queued_quest_survives_reload_but_is_rechecked_before_display()
        local w = world(root)
        w.engine.on_level_up("MINING", 49, 50)
        lu.assertTrue(w.progress.queued_quests()["test.quest"])
        local reload = client.new(root)
        reload.saved = w.fake.saved
        reload.load("src/tips/skills/mining")[1] = quest()
        reload.player.levels[14], reload.player.levels[13] = 50, 40
        reload.quests.TEST_QUEST = { hasFinishedQuest = true }
        local app = reload.load("src/app")
        app.start()
        lu.assertTrue(reload.load("src/storage/tip_progress").queued_quests()["test.quest"])
        reload.load("src/coach/engine").on_quiet()
        lu.assertEquals(#reload.windows, 0)
        app.stop()
    end

    return suite
end
