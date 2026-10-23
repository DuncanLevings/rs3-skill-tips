local root = arg[0]:match("^(.*)[/\\]tests[/\\][^/\\]+$") or "."
package.path = root .. "/?.lua;" .. package.path

local lu = require("luaunit")
local runner = lu.LuaUnit.new()

runner:runSuiteByInstances({
    { "TestGameAdapters", require("tests/game_adapters_spec")(root) },
    { "TestActivityWatch", require("tests/activity_watch_spec")(root) },
    { "TestApp", require("tests/app_spec")(root) },
    { "TestSchema", require("tests/schema_spec")(root) },
    { "TestConditions", require("tests/conditions_spec")(root) },
    { "TestSkillActivity", require("tests/skill_activity_spec")(root) },
    { "TestBackpackFull", require("tests/backpack_full_spec")(root) },
    { "TestStorage", require("tests/storage_spec")(root) },
    { "TestEngine", require("tests/engine_spec")(root) },
    { "TestCard", require("tests/card_spec")(root) },
})
os.exit(runner.result.notSuccessCount)
