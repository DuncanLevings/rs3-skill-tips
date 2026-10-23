local root = arg[0]:match("^(.*)[/\\]tests[/\\][^/\\]+$") or "."
package.path = root .. "/?.lua;" .. package.path

local lu = require("luaunit")
local runner = lu.LuaUnit.new()

runner:runSuiteByInstances({
    { "TestApp", require("tests/app_spec")(root) },
})
os.exit(runner.result.notSuccessCount)
