local root = arg[0]:match("^(.*)[/\\]tests[/\\][^/\\]+$") or "."
package.path = root .. "/?.lua;" .. package.path

local lu = require("luaunit")
local runner = lu.LuaUnit.new()

runner:runSuiteByInstances({
    { "TestSupportRollout", require("tests/support_rollout_spec")(root) },
    { "TestArtisan", require("tests/artisan_spec")(root) },
    { "TestMethodWindows", require("tests/method_windows_spec")(root) },
    { "TestGatheringEquipment", require("tests/gathering_equipment_spec")(root) },
    { "TestStartingLevels", require("tests/starting_levels_spec")(root) },
    { "TestGatheringRollout", require("tests/gathering_rollout_spec")(root) },
    { "TestItemKnowledge", require("tests/item_knowledge_spec")(root) },
    { "TestGameAdapters", require("tests/game_adapters_spec")(root) },
    { "TestActivityWatch", require("tests/activity_watch_spec")(root) },
    { "TestPhase5UI", require("tests/phase5_ui_spec")(root) },
    { "TestQuestPilot", require("tests/quest_pilot_spec")(root) },
    { "TestQuestDiscovery", require("tests/quest_discovery_spec")(root) },
    { "TestQuestAspirations", require("tests/quest_aspirations_spec")(root) },
    { "TestQuestTips", require("tests/quest_tips_spec")(root) },
    { "TestApp", require("tests/app_spec")(root) },
    { "TestSchema", require("tests/schema_spec")(root) },
    { "TestConditions", require("tests/conditions_spec")(root) },
    { "TestSkillActivity", require("tests/skill_activity_spec")(root) },
    { "TestBackpackFull", require("tests/backpack_full_spec")(root) },
    { "TestStorage", require("tests/storage_spec")(root) },
    { "TestPhase4", require("tests/coach_phase4_spec")(root) },
    { "TestEngine", require("tests/engine_spec")(root) },
    { "TestCard", require("tests/card_spec")(root) },
    { "TestReviewFixes", require("tests/review_fixes_spec")(root) },
    { "TestMiningTips", require("tests/mining_tips_spec")(root) },
    { "TestPilotTips", require("tests/pilot_tips_spec")(root) },
})
os.exit(runner.result.notSuccessCount)
