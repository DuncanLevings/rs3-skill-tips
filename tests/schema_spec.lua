local lu = require("luaunit")
local client = require("tests/support/client")

local function valid_tip()
    return {
        id = "mining.example",
        kind = "convenience",
        skills = { "MINING" },
        members = false,
        title = "Example",
        hook = "A hook.",
        why = "Because.",
        how = { "Do this." },
        requirements = { skills = { SMITHING = 1 }, quests = { "COOKS_ASSISTANT" } },
        triggers = { { type = "training", skill = "MINING" } },
        known_when = { { type = "owns_any", items = { "MINING_OREBOX_BRONZE" } } },
        priority = 1,
    }
end

return function(root)
    local suite = {}
    local schema

    function suite:setUp()
        schema = client.new(root).load("src/tips/schema")
    end

    function suite:test_a_complete_tip_has_no_problems()
        lu.assertEquals(schema.problems(valid_tip()), {})
    end

    function suite:test_missing_text_fields_are_reported()
        local tip = valid_tip()
        tip.hook = nil
        tip.how = {}

        local problems = schema.problems(tip)

        lu.assertEquals(#problems, 2)
    end

    function suite:test_item_icons_use_config_names()
        local tip = valid_tip()
        tip.icon_item = "MINING_OREBOX_BRONZE"
        lu.assertEquals(schema.problems(tip), {})

        tip.icon_item = 123
        lu.assertStrContains(schema.problems(tip)[1], "icon_item")
    end

    function suite:test_functions_are_not_allowed_in_tips()
        local tip = valid_tip()
        tip.how = {
            function()
                return "sneaky"
            end,
        }

        local problems = table.concat(schema.problems(tip), "; ")

        lu.assertStrContains(problems, "data only")
    end

    function suite:test_unknown_skills_triggers_and_conditions_are_reported()
        local tip = valid_tip()
        tip.skills = { "MINNING" }
        tip.triggers = { { type = "teleported" } }
        tip.known_when = { { type = "owns_any", items = {} } }

        lu.assertEquals(#schema.problems(tip), 3)
    end

    function suite:test_level_range_must_go_low_to_high()
        local tip = valid_tip()
        tip.level_range = { 80, 70 }

        lu.assertStrContains(schema.problems(tip)[1], "min is above max")
    end

    function suite:test_every_shipped_tip_loads_cleanly()
        local fake = client.new(root)
        local catalogue = fake.load("src/tips/catalogue")

        catalogue.load()

        lu.assertTrue(#catalogue.all() > 0)
        lu.assertEquals(fake.logs, {})
    end

    function suite:test_catalogue_skips_bad_and_duplicate_tips()
        local baseline = #client.new(root).load("src/tips/catalogue").all()
        local fake = client.new(root)
        local bad = valid_tip()
        bad.id = "mining.ore_box"
        -- the catalogue gets this same cached table when it requires the file
        local real = fake.load("src/tips/skills/mining")
        real[#real + 1] = bad

        local catalogue = fake.load("src/tips/catalogue")
        catalogue.load()

        -- the duplicate is skipped, everything else still loads
        lu.assertEquals(#catalogue.all(), baseline)
        lu.assertStrContains(fake.logs[1], "already used")
    end

    function suite:test_relevant_items_collects_what_tips_ask_about()
        local catalogue = client.new(root).load("src/tips/catalogue")

        local items, categories = catalogue.relevant_items()

        lu.assertTrue(items.MINING_OREBOX_BRONZE)
        lu.assertTrue(categories[4448])
    end

    function suite:test_progression_gate_fields_are_validated()
        local tip = valid_tip()
        tip.min_training_level = 80
        tip.require_all_levels = true
        lu.assertEquals(schema.problems(tip), {})
        for _, value in ipairs({ 0, 121, 1.5, "80" }) do
            tip.min_training_level = value
            lu.assertStrContains(table.concat(schema.problems(tip)), "min_training_level")
        end
        tip.min_training_level = 80
        tip.require_all_levels = "yes"
        lu.assertStrContains(table.concat(schema.problems(tip)), "require_all_levels")
    end

    function suite:test_source_quest_gate_is_validated()
        local tip = valid_tip()
        tip.require_quests_complete = true
        lu.assertEquals(schema.problems(tip), {})
        tip.require_quests_complete = "yes"
        lu.assertStrContains(table.concat(schema.problems(tip)), "require_quests_complete")
        tip.require_quests_complete = true
        tip.requirements.quests = {}
        lu.assertStrContains(table.concat(schema.problems(tip)), "needs quest requirements")
    end

    function suite:test_resource_icon_ids_are_positive_and_unambiguous()
        local tip = valid_tip()
        tip.icon_item_id = 440
        lu.assertEquals(schema.problems(tip), {})
        for _, value in ipairs({ 0, -1, 1.5, "440" }) do
            tip.icon_item_id = value
            lu.assertStrContains(table.concat(schema.problems(tip)), "icon_item_id")
        end
        tip.icon_item_id = 440
        tip.icon_item = "MINING_OREBOX_BRONZE"
        lu.assertStrContains(table.concat(schema.problems(tip)), "not both")
    end

    function suite:test_every_shipped_tip_has_an_icon()
        for _, tip in ipairs(client.new(root).load("src/tips/catalogue").all()) do
            lu.assertTrue(tip.icon_item ~= nil or tip.icon_item_id ~= nil, tip.id)
        end
    end

    return suite
end
