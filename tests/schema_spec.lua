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
        local fake = client.new(root)
        local bad = valid_tip()
        bad.id = "mining.ore_box"
        -- the catalogue gets this same cached table when it requires the file
        local real = fake.load("src/tips/skills/mining")
        real[#real + 1] = bad

        local catalogue = fake.load("src/tips/catalogue")
        catalogue.load()

        lu.assertEquals(#catalogue.all(), #real - 1)
        lu.assertStrContains(fake.logs[1], "already used")
    end

    function suite:test_relevant_items_collects_what_tips_ask_about()
        local catalogue = client.new(root).load("src/tips/catalogue")

        local items, categories = catalogue.relevant_items()

        lu.assertTrue(items.MINING_OREBOX_BRONZE)
        lu.assertTrue(categories[4448])
    end

    return suite
end
