local lu = require("luaunit")
local client = require("tests/support/client")

-- a player that can answer every question conditions ask
local function fake_state(answers)
    return {
        level = function(skill)
            return (answers.levels or {})[skill]
        end,
        owns_item = function(item)
            return (answers.items or {})[item] == true
        end,
        owns_category = function(category)
            return (answers.categories or {})[category] == true
        end,
        varbit = function(name)
            return (answers.varbits or {})[name]
        end,
        quest_done = function(quest)
            return (answers.quests or {})[quest] == true
        end,
        achievement_done = function(achievement)
            return (answers.achievements or {})[achievement] == true
        end,
    }
end

return function(root)
    local suite = {}
    local conditions

    local function holds(condition, state)
        return conditions.check(condition, state)
    end

    function suite:setUp()
        conditions = client.new(root).load("src/coach/conditions")
    end

    function suite:test_has_level()
        local state = fake_state({ levels = { MINING = 30 } })

        lu.assertTrue(holds({ type = "has_level", skill = "MINING", level = 30 }, state))
        lu.assertFalse(holds({ type = "has_level", skill = "MINING", level = 31 }, state))
        lu.assertFalse(holds({ type = "has_level", skill = "FISHING", level = 1 }, state))
    end

    function suite:test_owns_any_and_owns_category()
        local state = fake_state({
            items = { MINING_OREBOX_IRON = true },
            categories = { [4448] = true },
        })

        lu.assertTrue(holds({ type = "owns_any", items = { "X", "MINING_OREBOX_IRON" } }, state))
        lu.assertFalse(holds({ type = "owns_any", items = { "X" } }, state))
        lu.assertTrue(holds({ type = "owns_category", category = 4448 }, state))
        lu.assertFalse(holds({ type = "owns_category", category = 1 }, state))
    end

    function suite:test_varbit_quest_and_achievement()
        local state = fake_state({
            varbits = { TOOLBELT_PICKAXE_LEVEL = 5 },
            quests = { COOKS_ASSISTANT = true },
            achievements = { MINING_20 = true },
        })
        local pickaxe = { type = "varbit_at_least", varbit = "TOOLBELT_PICKAXE_LEVEL" }

        pickaxe.value = 5
        lu.assertTrue(holds(pickaxe, state))
        pickaxe.value = 6
        lu.assertFalse(holds(pickaxe, state))
        lu.assertFalse(holds({ type = "varbit_at_least", varbit = "MISSING", value = 0 }, state))
        lu.assertTrue(holds({ type = "quest_done", quest = "COOKS_ASSISTANT" }, state))
        lu.assertFalse(holds({ type = "quest_done", quest = "COOK_QUEST" }, state))
        lu.assertTrue(holds({ type = "achievement_done", achievement = "MINING_20" }, state))
    end

    function suite:test_any_is_false_for_an_empty_list()
        lu.assertFalse(conditions.any({}, fake_state({})))
        lu.assertFalse(conditions.any(nil, fake_state({})))
    end

    function suite:test_only_ownership_checks_need_the_bank()
        lu.assertTrue(conditions.needs_bank({ { type = "owns_category", category = 1 } }))
        lu.assertFalse(conditions.needs_bank({ { type = "quest_done", quest = "X" } }))
    end

    function suite:test_validation_rejects_bad_conditions()
        lu.assertFalse(conditions.is_valid({ type = "owns_any", items = {} }))
        lu.assertFalse(conditions.is_valid({ type = "has_level", skill = "MINING", level = 1.5 }))
        lu.assertFalse(conditions.is_valid({ type = "nope" }))
        lu.assertFalse(conditions.is_valid("owns_any"))
        lu.assertTrue(conditions.is_valid({ type = "owns_category", category = 4448 }))
    end

    return suite
end
