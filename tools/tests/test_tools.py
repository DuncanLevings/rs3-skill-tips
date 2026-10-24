"""Offline regression checks; no live wiki requests are made by this suite."""

import argparse
import contextlib
import io
import json
import shutil
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch
from urllib.error import HTTPError

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from check_tips import check, coverage, main as check_main
from extract_training_guides import extract
from list_item_ids import lookup, probe_rows
from skilling_tools.configs import import_probe, load_configs
from skilling_tools.html_tables import Document, clean, grid
from skilling_tools.tips import TipReader
from skilling_tools.wiki import ToolError, WikiClient

ROOT = Path(__file__).resolve().parents[2]
TIP = '''{
    id = "mining.example", kind = "convenience", skills = { "MINING" }, members = false,
    title = "Ore box", hook = "A useful benefit.", why = "A basic use.", how = { "A starting point." },
    icon_item = "BOX", requirements = { skills = { SMITHING = 1 } }, priority = 1,
    triggers = { { type = "backpack_full", skill = "MINING" } },
    known_when = { { type = "owns_any", items = { "BOX" } } },
}'''


class ContentTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        for name in ("src/tips/schema.lua", "src/coach/conditions.lua", "src/data/skills.lua"):
            destination = self.root / name
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(ROOT / name, destination)
        self.write("src/tips/catalogue.lua", 'local TIP_FILES = { "src/tips/skills/mining" }')
        self.write("src/tips/skills/mining.lua", "return {" + TIP + "}")
        self.configs = {"version": 1, "items": {"BOX": {"name": "Bronze ore box", "consumable": False}}}
        self.write("tools/verified_configs.json", json.dumps(self.configs))

    def write(self, name, text):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")
        return path

    def test_resource_icons_need_id_evidence(self):
        self.write("src/tips/skills/mining.lua", "return {" + TIP.replace('icon_item = "BOX"', 'icon_item_id = 440') + "}")
        report = check(self.root, self.configs)
        self.assertTrue(any("resource icon evidence" in error for error in report["errors"]))
        self.write("tools/resource_icons.json", json.dumps({"version": 1, "items": {"440": {"name": "Iron ore"}}}))
        self.assertFalse(check(self.root, self.configs)["errors"])

    def test_real_lua_schema_checks_complete_tip(self):
        report = check(self.root, self.configs)
        self.assertEqual(report["errors"], [])
        self.assertEqual(report["verified_references"], {"items": 1})
        self.assertEqual(report["method_level_gaps"], {"MINING": [[1, 120]]})

    def test_missing_required_field_uses_runtime_schema(self):
        self.write("src/tips/skills/mining.lua", "return {" + TIP.replace('hook = "A useful benefit.",', "") + "}")
        self.assertTrue(any("hook must be some text" in problem for problem in check(self.root, self.configs)["errors"]))

    def test_duplicate_ids_and_unregistered_files_fail(self):
        self.write("src/tips/skills/mining.lua", "return {" + TIP + "," + TIP + "}")
        self.write("src/tips/general.lua", "return {}")
        problems = check(self.root, self.configs)["errors"]
        self.assertTrue(any("duplicate tip id" in problem for problem in problems))
        self.assertTrue(any("Unregistered tip file" in problem for problem in problems))

    def test_unknown_configs_never_silently_pass(self):
        self.assertTrue(any("unverified items config BOX" in problem for problem in check(self.root, {"version": 1})["errors"]))

    def test_consumable_subject_is_rejected(self):
        self.configs["items"]["BOX"] = {"name": "Perfect juju mining potion", "consumable": True}
        self.assertTrue(any("consumable" in problem for problem in check(self.root, self.configs)["errors"]))

    def test_name_only_consumable_guess_is_a_warning_not_an_error(self):
        # "pouch" matches runecrafting pouches, which arent consumables
        self.configs["items"]["BOX"] = {"name": "Small pouch"}
        report = check(self.root, self.configs)
        self.assertEqual(report["errors"], [])
        self.assertTrue(any("looks like a consumable" in warning for warning in report["warnings"]))

    def test_broken_schema_is_a_clean_error_not_a_traceback(self):
        self.write("src/tips/schema.lua", "local broken = = 1")
        stderr = io.StringIO()
        with contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(stderr):
            self.assertEqual(check_main(["--root", str(self.root)]), 2)
        self.assertIn("Couldn't load src/tips/schema.lua", stderr.getvalue())

    def test_duplicate_quest_display_names_are_flagged(self):
        tip = TIP.replace('known_when = { { type = "owns_any", items = { "BOX" } } }',
                          'known_when = { { type = "quest_done", quest = "REAL_QUEST" } }')
        self.write("src/tips/skills/mining.lua", "return {" + tip + "}")
        self.configs["quests"] = {"REAL_QUEST": {"name": "A Quest"}, "OLD_QUEST": {"name": "A Quest", "deprecated": True}}
        self.assertTrue(any("duplicate configs" in problem for problem in check(self.root, self.configs)["warnings"]))

    def test_duplicate_quest_names_are_settled_by_the_deprecated_flag(self):
        tip = TIP.replace('known_when = { { type = "owns_any", items = { "BOX" } } }',
                          'known_when = { { type = "quest_done", quest = "REAL_QUEST" } }')
        self.write("src/tips/skills/mining.lua", "return {" + tip + "}")
        path = self.write("probe.txt", """[sc-probe] quest 6 | OLD_QUEST | A Quest | false | false | true
[sc-probe] quest 257 | REAL_QUEST | A Quest | true | true | false
""")
        imported = import_probe(path)
        self.assertEqual(imported["quests"]["OLD_QUEST"]["deprecated"], True)
        self.configs["quests"] = imported["quests"]
        self.assertFalse(any("duplicate configs" in problem for problem in check(self.root, self.configs)["warnings"]))

        # pointing the tip at the dead one is caught outright
        self.write("src/tips/skills/mining.lua", "return {" + tip.replace("REAL_QUEST", "OLD_QUEST") + "}")
        self.assertTrue(any("deprecated" in problem for problem in check(self.root, self.configs)["errors"]))

    def test_missing_varbit_is_checked(self):
        tip = TIP.replace('known_when = { { type = "owns_any", items = { "BOX" } } }',
                          'known_when = { { type = "varbit_at_least", varbit = "UNKNOWN", value = 1 } }')
        self.write("src/tips/skills/mining.lua", "return {" + tip + "}")
        self.assertTrue(any("unverified varbits config UNKNOWN" in problem for problem in check(self.root, self.configs)["errors"]))

    def test_data_cannot_access_io_or_loop_forever(self):
        for source in ('return io.open("anything")', 'while true do end', 'return { function() end }'):
            with self.subTest(source=source):
                self.write("src/tips/skills/mining.lua", source)
                self.assertTrue(check(self.root, self.configs)["errors"])

    def test_schema_only_is_explicit_and_strict_reports_it(self):
        with contextlib.redirect_stdout(io.StringIO()):
            self.assertEqual(check_main(["--root", str(self.root), "--schema-only", "--strict"]), 1)

    def test_probe_parser_keeps_names_not_character_progress(self):
        path = self.write("probe.txt", """Skilling Coach Probe(15): [sc-probe] quest 6 | OLD_QUEST | A Quest | false | false
Skilling Coach Probe(15): [sc-probe] quest 257 | REAL_QUEST | A Quest | true | true
Skilling Coach Probe(15): [sc-probe] item Bronze ore box | 44779 | BOX | 4448
Skilling Coach Probe(15): [sc-probe] var.VarPlayer.X -> name=X domain=VarPlayer id=-201 isVarBit=true value=1
Skilling Coach Probe(15): [sc-probe] !give HATCHET 1 -- Bronze hatchet
""")
        configs = import_probe(path)
        self.assertEqual(configs["items"]["BOX"]["id"], 44779)
        self.assertEqual(configs["items"]["HATCHET"]["name"], "Bronze hatchet")
        self.assertEqual(configs["varbits"]["X"], {"id": -201})
        self.assertNotIn("finished", configs["quests"]["REAL_QUEST"])

    def test_config_format_error_is_actionable(self):
        path = self.write("bad.json", '{"version": 1, "items": []}')
        with self.assertRaises(ToolError):
            load_configs(path)


class ExtractionTests(unittest.TestCase):
    def test_spans_keep_equipment_fields_aligned(self):
        html = '''<h2>Useful equipment</h2><table>
        <tr><th colspan="2">Item</th><th>Effect</th><th>Requirements</th><th>Slot</th></tr>
        <tr><td rowspan="2"><a href="/w/Bronze_ore_box">icon</a></td><td>Ore box</td><td>Stores ore</td><td>1 Smithing</td><td>Backpack</td></tr>
        <tr><td>Upgraded box</td><td>Stores more ore types</td><td>10 Smithing</td><td>Backpack</td></tr></table>
        <h2>Methods</h2><h3>Levels 1–10: copper and tin</h3><p>A method explained in prose.</p>'''
        result = extract({"title": "Mining training", "text": html, "revid": 42}, "mining")
        self.assertEqual(len(result["equipment"]), 2)
        self.assertEqual(result["equipment"][0]["name"], "Ore box")
        self.assertEqual(result["equipment"][1]["effect"], "Stores more ore types")
        self.assertEqual(result["equipment"][1]["requirements"]["skills"], {"SMITHING": 10})
        self.assertEqual(result["method_brackets"][0]["level_range"], [1, 10])
        self.assertEqual(result["source"]["revision"], 42)
        self.assertEqual(result["status"], "draft_for_manual_review")

    def test_empty_guide_does_not_claim_no_equipment_exists(self):
        result = extract({"title": "Guide", "text": "<p>Layout changed</p>"}, "mining")
        self.assertEqual(len(result["notes"]), 2)

    def test_consumables_remain_in_review_drafts_with_flag(self):
        html = '<h2>Equipment</h2><table><tr><th>Item</th><th>Effect</th></tr><tr><td>Mining potion</td><td>Boost</td></tr></table>'
        result = extract({"title": "Guide", "text": html}, "mining")
        self.assertTrue(result["equipment"][0]["consumable_guess"])

    def test_level_gap_merging_handles_overlaps(self):
        entries = [{"tip": {"skills": ["MINING"], "kind": "method", "level_range": bracket}} for bracket in ([1, 10], [8, 20], [30, 40])]
        self.assertEqual(coverage(entries, 50), {"MINING": [[21, 29], [41, 50]]})

    def test_item_variants_and_repeated_ids_are_retained(self):
        client = unittest.mock.Mock()
        client.item_rows.return_value = [
            {"page_name": "An item", "item_name": "An item", "item_id": [3, 2], "version_anchor": "New"},
            {"page_name": "An item", "item_name": "An item", "item_id": [4], "version_anchor": "Used"},
        ]
        result = lookup(client, ["An item"])
        self.assertEqual(result["items"][0]["ids"], [2, 3])
        self.assertEqual(result["items"][1]["variant"], "Used")
        self.assertIn("id = 4", probe_rows(result))
        self.assertNotIn("configName =", probe_rows(result))

    def test_empty_bucket_result_is_missing_not_success(self):
        client = unittest.mock.Mock()
        client.item_rows.return_value = []
        client.resolve_title.return_value = "Removed item"
        missing = lookup(client, ["Removed item"])["missing"]
        self.assertEqual([entry["page"] for entry in missing], ["Removed item"])
        self.assertIn("each item's own page", missing[0]["reason"])

    def test_redirected_page_names_are_followed(self):
        client = unittest.mock.Mock()
        row = {"page_name": "Grace of the elves", "item_name": "Grace of the elves", "item_id": [44548], "version_anchor": "new"}
        client.item_rows.side_effect = lambda page: [row] if page == "Grace of the elves" else []
        client.resolve_title.return_value = "Grace of the elves"
        result = lookup(client, ["Grace of the Elves"])
        self.assertEqual(result["missing"], [])
        self.assertEqual(result["items"][0]["ids"], [44548])
        self.assertEqual(result["items"][0]["requested_page"], "Grace of the Elves")

    def test_default_variant_is_not_shown_as_a_variant(self):
        client = unittest.mock.Mock()
        client.item_rows.return_value = [{"page_name": "Bronze ore box", "item_name": "Bronze ore box", "item_id": [44779], "version_anchor": "DEFAULT"}]
        result = lookup(client, ["Bronze ore box"])
        self.assertIsNone(result["items"][0]["variant"])
        self.assertIn('wiki_name = "Bronze ore box", id = 44779', probe_rows(result))

    def test_probe_rows_are_valid_lua_even_for_odd_names(self):
        from lupa.lua54 import LuaRuntime
        odd = 'Quote " back\\slash\ttab\x01ctrl é'
        result = {"items": [{"name": odd, "variant": None, "ids": [7]}]}
        rows = LuaRuntime().execute(probe_rows(result))
        self.assertEqual(rows[1]["wiki_name"], odd)
        self.assertEqual(rows[1]["id"], 7)

    def test_in_table_priority_groups_are_kept(self):
        html = '''<h2>Useful equipment</h2><table>
        <tr><th>Item</th><th>Effect</th><th>Requirements</th></tr>
        <tr><th colspan="3">High priority</th></tr>
        <tr><td>Ore box</td><td>Stores ore</td><td>None</td></tr>
        <tr><th colspan="3">Additional XP</th></tr>
        <tr><td>Crystallise</td><td>+20% XP</td><td>88 Magic <a href="/w/The_Light_Within">The Light Within</a></td></tr>
        </table>'''
        result = extract({"title": "Guide", "text": html}, "mining")
        first, second = result["equipment"]
        self.assertEqual(first["priority_group"], "High priority")
        self.assertEqual(second["priority_group"], "Additional XP")
        self.assertEqual(second["requirements"]["skills"], {"MAGIC": 88})
        self.assertEqual(second["requirements"]["links"], ["The Light Within"])

    def test_open_ended_level_headings_go_to_the_cap(self):
        html = '<h2>Methods</h2><h3>Level 100+: Primal rocks</h3><p>prose</p>'
        result = extract({"title": "Guide", "text": html}, "mining")
        self.assertEqual(result["method_brackets"][0]["level_range"], [100, 120])


class NetworkTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.cache = Path(self.temporary.name)

    @staticmethod
    def response(value):
        response = unittest.mock.MagicMock()
        response.__enter__.return_value = io.StringIO(json.dumps(value))
        return response

    def test_second_run_uses_cache_and_offline_never_connects(self):
        with patch("skilling_tools.wiki.urlopen", return_value=self.response({"bucket": []})) as request:
            WikiClient(self.cache).request(action="bucket", query="test")
            WikiClient(self.cache, offline=True).request(action="bucket", query="test")
            self.assertEqual(request.call_count, 1)
            self.assertIn("SkillTipsOfflineTools", request.call_args.args[0].get_header("User-agent"))
        with patch("skilling_tools.wiki.urlopen") as request:
            with self.assertRaises(ToolError):
                WikiClient(self.cache, offline=True).request(action="bucket", query="missing")
            request.assert_not_called()

    def test_api_error_is_not_cached(self):
        with patch("skilling_tools.wiki.urlopen", return_value=self.response({"error": "unknown field"})):
            with self.assertRaises(ToolError):
                WikiClient(self.cache).request(action="bucket")
        self.assertEqual(list(self.cache.iterdir()), [])

    def test_rate_limit_retries_are_bounded(self):
        error = HTTPError("https://runescape.wiki/api.php", 429, "rate limited", {}, None)
        with patch("skilling_tools.wiki.urlopen", side_effect=error) as request, patch("skilling_tools.wiki.time.sleep"):
            with self.assertRaises(ToolError):
                WikiClient(self.cache).request(action="bucket")
            self.assertEqual(request.call_count, 3)

    def test_cache_refresh_and_offline_are_exclusive(self):
        with self.assertRaises(ToolError):
            WikiClient(self.cache, offline=True, refresh=True)


if __name__ == "__main__":
    unittest.main()
