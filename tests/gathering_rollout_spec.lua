-- gathering content through real eligibility, ranking and activity events.
local lu = require("luaunit")
local client = require("tests/support/client")

local function world(root, skill, level)
    local fake = client.new(root)
    local skills = fake.load("src/data/skills")
    fake.player.levels[skills.number(skill)] = level
    fake.quests.PLAGUES_END = { hasFinishedQuest = true }
    local progress = fake.load("src/storage/tip_progress")
    progress.use_character("alice")
    local engine = fake.load("src/coach/engine")
    local shown = {}
    engine.start({
        state = fake.load("src/game/player_state"),
        now = function()
            return 1000
        end,
        show_card = function(tip)
            shown[#shown + 1] = tip.id
        end,
    })
    return fake, engine, shown
end

return function(root)
    local suite = {}

    function suite:test_every_main_bracket_boundary_selects_the_current_method()
        local cases = {
            HUNTER = {
                { 11, 18, "cerulean_twitches" },
                { 19, 29, "tropical_wagtails" },
                { 30, 49, "gliding_whirligigs" },
                { 50, 69, "swift_whirligigs" },
                { 70, 89, "hasty_whirligigs" },
                { 90, 120, "speedy_whirligigs" },
            },
            DIVINATION = {
                { 10, 19, "flickering" },
                { 20, 29, "bright" },
                { 30, 39, "glowing" },
                { 40, 49, "sparkling" },
                { 50, 59, "gleaming" },
                { 60, 64, "vibrant" },
                { 65, 69, "empty_throne_room" },
                { 70, 120, "hall_of_memories" },
            },
            ARCHAEOLOGY = {
                { 5, 19, "kharid_et" },
                { 20, 41, "infernal_source" },
                { 42, 69, "everlight" },
                { 70, 75, "stormguard" },
                { 76, 89, "warforge" },
                { 90, 120, "orthen" },
            },
            FARMING = {
                { 15, 29, "oak" },
                { 30, 44, "willow" },
                { 45, 59, "maple" },
                { 60, 74, "yew" },
                { 75, 89, "magic" },
                { 90, 120, "elder" },
            },
        }
        for skill, brackets in pairs(cases) do
            for _, bracket in ipairs(brackets) do
                for _, level in ipairs({ bracket[1], bracket[2] }) do
                    local _, engine, shown = world(root, skill, level)
                    engine.on_training(skill)
                    lu.assertEquals(
                        shown[1],
                        skill:lower() .. ".method." .. bracket[3],
                        skill .. " at " .. level
                    )
                end
            end
        end
    end

    function suite:test_cross_skill_methods_wait_for_every_requirement()
        for _, case in ipairs({
            { "hunter.alt.big_game_hunter", "HUNTER", "SLAYER", 55 },
            { "hunter.alt.charming_moths", "HUNTER", "AGILITY", 83 },
            { "farming.alt.player_owned_farm", "FARMING", "CONSTRUCTION", 20 },
            { "farming.alt.dinosaur_farm", "FARMING", "CONSTRUCTION", 45 },
        }) do
            local fake = client.new(root)
            local tip = fake.load("src/tips/catalogue").get(case[1])
            local eligibility = fake.load("src/coach/eligibility")
            local skills = fake.load("src/data/skills")
            local state = fake.load("src/game/player_state")
            fake.player.levels[skills.number(case[2])] = tip.level_range[1]
            fake.player.levels[skills.number(case[3])] = case[4] - 1
            lu.assertFalse(eligibility.allows(tip, case[2], state), case[1])
            fake.player.levels[skills.number(case[3])] = case[4]
            lu.assertTrue(eligibility.allows(tip, case[2], state), case[1])
            fake.player.levels[skills.number(case[3])] = nil
            lu.assertFalse(eligibility.allows(tip, case[2], state), case[1])
        end
    end

    function suite:test_quest_locked_methods_defer_unknown_or_unfinished_access()
        for _, case in ipairs({
            { "hunter.alt.red_chinchompas", "HUNTER", "EAGLES_PEAK" },
            { "farming.method.elder", "FARMING", "PLAGUES_END" },
        }) do
            local fake = client.new(root)
            local tip = fake.load("src/tips/catalogue").get(case[1])
            local eligibility = fake.load("src/coach/eligibility")
            local skills = fake.load("src/data/skills")
            local state = fake.load("src/game/player_state")
            fake.player.levels[skills.number(case[2])] = tip.level_range[1]
            lu.assertFalse(eligibility.allows(tip, case[2], state))
            fake.quests[case[3]] = { hasFinishedQuest = false }
            lu.assertFalse(eligibility.allows(tip, case[2], state))
            fake.quests[case[3]].hasFinishedQuest = true
            lu.assertTrue(eligibility.allows(tip, case[2], state))
        end
    end

    function suite:test_new_skills_use_the_existing_real_training_event_path()
        for skill, number in pairs({ HUNTER = 21, DIVINATION = 25, ARCHAEOLOGY = 27, FARMING = 19 }) do
            local fake = client.new(root)
            fake.player.levels[number] = 30
            -- this scenario follows a character who started using the plugin at level one.
            local initial = fake.load("src/storage/tip_progress")
            initial.use_character("test_player")
            initial.allow_existing_methods()
            local app = fake.load("src/app")
            app.start()
            fake.fire("Logic", { logicTick = 0 })
            local progress = fake.load("src/storage/tip_progress")
            for drop = 1, 3 do
                fake.fire("Logic", { logicTick = drop * 250 })
                fake.fire(
                    "SkillTransmit",
                    { skill = number, oldXP = 100 * drop, newXP = 100 * drop + 10 }
                )
                if drop < 3 then
                    lu.assertEquals(#progress.recent_tips(), 0, skill)
                end
            end
            lu.assertEquals(#progress.recent_tips(), 1, skill)
            lu.assertStrContains(progress.recent_tips()[1].id, skill:lower() .. ".method.")
            app.stop()
        end
    end

    function suite:test_shared_items_are_only_indexed_for_supported_skills()
        local fake = client.new(root)
        local catalogue = fake.load("src/tips/catalogue")
        local grace = catalogue.get("shared.grace_of_the_elves")
        lu.assertEquals(grace.skills, { "MINING", "WOODCUTTING", "FISHING", "ARCHAEOLOGY" })
        for _, skill in ipairs({ "HUNTER", "DIVINATION", "ARCHAEOLOGY", "FARMING" }) do
            local indexed = {}
            for _, tip in ipairs(catalogue.for_skill(skill)) do
                indexed[tip.id] = true
            end
            lu.assertTrue(indexed["shared.ring_of_whispers"])
            lu.assertTrue(indexed["shared.scripture_of_elidinis"])
        end
    end

    return suite
end
