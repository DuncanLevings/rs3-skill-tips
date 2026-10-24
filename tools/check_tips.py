"""Validate bundled tips against their Lua schema and explicit client-config evidence."""

import argparse
import json
import sys
from collections import defaultdict
from pathlib import Path

from skilling_tools.configs import consumable_guess, import_probe, load_configs, merge_configs
from skilling_tools.tips import TipReader, references
from skilling_tools.wiki import ToolError, write_json

ROOT = Path(__file__).resolve().parents[1]


def coverage(entries, maximum):
    intervals = defaultdict(list)
    for entry in entries:
        tip = entry["tip"]
        for skill in tip["skills"]:
            if skill != "ANY":
                intervals[skill]
                if tip["kind"] == "method" and tip.get("level_range"):
                    intervals[skill].append(tip["level_range"])
    result = {}
    for skill, ranges in sorted(intervals.items()):
        gaps, next_level = [], 1
        for low, high in sorted(ranges):
            if low > next_level:
                gaps.append([next_level, min(maximum, low - 1)])
            next_level = max(next_level, high + 1)
            if next_level > maximum:
                break
        if next_level <= maximum:
            gaps.append([next_level, maximum])
        result[skill] = gaps
    return result


def check(root, configs, schema_only=False, maximum=120):
    entries, errors = TipReader(root).read()
    warnings, seen = [], set()
    icon_path = Path(root) / "tools/resource_icons.json"
    icon_items = json.loads(icon_path.read_text(encoding="utf-8")).get("items", {}) if icon_path.exists() else {}
    quest_names = defaultdict(list)
    for name, record in configs.get("quests", {}).items():
        if record.get("name"):
            quest_names[record["name"]].append(name)
    categories = {record.get("category") for record in configs.get("items", {}).values()}
    counts = defaultdict(set)
    for entry in entries:
        tip = entry["tip"]
        label = f"{entry['file']}:{tip['id']}"
        if tip.get("icon_item_id") and not schema_only:
            if str(tip["icon_item_id"]) not in icon_items:
                errors.append(f"{label}: icon_item_id has no resource icon evidence")
        if tip["id"] in seen:
            errors.append(f"{label}: duplicate tip id")
        seen.add(tip["id"])
        if "wiki_page" in tip:
            errors.append(f"{label}: wiki_page was removed; keep source evidence in offline drafts")
        if tip["kind"] == "quest":
            for trigger in tip["triggers"]:
                if trigger["type"] == "requirements_met" and trigger["skill"] != "ANY":
                    errors.append(f"{label}: requirements_met must use skill ANY")
        if tip.get("consumable") is True:
            errors.append(f"{label}: consumable tips are excluded")
        primary = configs.get("items", {}).get(tip.get("icon_item"), {})
        subject = primary.get("name") or tip["title"]
        guessed = consumable_guess(subject)
        # only the evidence file marking an item consumable is a hard error. the name guess is
        # just a hint: "pouch" matches runecrafting pouches, which are fine to tip about
        if primary.get("consumable") is True:
            errors.append(f"{label}: {subject} is marked consumable in the config evidence; exclude it")
        elif tip["kind"] == "convenience" and primary.get("consumable") is None:
            if guessed is True:
                warnings.append(f"{label}: {subject} looks like a consumable by its name; check, then record consumable true/false in the evidence")
            elif guessed is None:
                warnings.append(f"{label}: consumable status of {subject} needs manual verification")
        if schema_only:
            continue
        for group, names in references(tip).items():
            for name in sorted(names, key=str):
                if group == "categories":
                    if name not in categories:
                        errors.append(f"{label}: category {name} has no client probe evidence")
                    continue
                record = configs.get(group, {}).get(name)
                if record is None:
                    errors.append(f"{label}: unverified {group} config {name}; supply a current probe log/config snapshot")
                    continue
                counts[group].add(name)
                if record.get("deprecated"):
                    errors.append(f"{label}: {group} config {name} is marked deprecated")
                if group == "quests" and len(quest_names.get(record.get("name"), [])) > 1:
                    # settled when this one is confirmed live and every other same-name config is
                    # confirmed deprecated (the probe's quest dump records that)
                    others = [other for other in quest_names[record["name"]] if other != name]
                    settled = record.get("deprecated") is False and all(
                        configs["quests"][other].get("deprecated") is True for other in others)
                    if not settled:
                        choices = ", ".join(sorted(quest_names[record["name"]]))
                        warnings.append(f"{label}: quest display name {record['name']!r} has duplicate configs ({choices}); run the probe's quest dump to see which is deprecated")
    if schema_only:
        warnings.append("Schema-only run: client config names/categories were not verified")
    return {"version": 1, "checked_tips": len(entries), "errors": errors,
            "warnings": sorted(set(warnings)), "method_level_gaps": coverage(entries, maximum),
            "verified_references": {group: len(names) for group, names in sorted(counts.items())}}


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument("--configs", type=Path, help="Authoritative version-1 config snapshot (replaces the baseline)")
    parser.add_argument("--probe-log", action="append", type=Path, default=[], help="Add observed client configs from a probe log")
    parser.add_argument("--write-configs", type=Path, help="Save the merged evidence for subsequent runs")
    parser.add_argument("--schema-only", action="store_true", help="Explicitly skip client config verification")
    parser.add_argument("--strict", action="store_true", help="Treat review warnings as failures; level gaps stay informational")
    parser.add_argument("--max-level", type=int, choices=range(1, 121), default=120, metavar="1..120")
    parser.add_argument("--report", type=Path, help="Write a machine-readable validation report")
    args = parser.parse_args(argv)
    try:
        baseline = args.configs or args.root / "tools/verified_configs.json"
        configs = {"version": 1}
        if not args.schema_only or args.configs or args.probe_log or args.write_configs:
            configs = load_configs(baseline)
            for path in args.probe_log:
                merge_configs(configs, import_probe(path))
        report = check(args.root, configs, args.schema_only, args.max_level)
        if args.write_configs:
            write_json(args.write_configs, configs)
        if args.report:
            write_json(args.report, report)
        for message in report["errors"]:
            print("ERROR: " + message)
        for message in report["warnings"]:
            print("REVIEW: " + message)
        for skill, gaps in report["method_level_gaps"].items():
            text = ", ".join(str(low) if low == high else f"{low}-{high}" for low, high in gaps) or "none"
            print(f"{skill} method coverage gaps (informational): {text}")
        print(f"Checked {report['checked_tips']} tips: {len(report['errors'])} errors, {len(report['warnings'])} review warnings")
        return 1 if report["errors"] or (args.strict and report["warnings"]) else 0
    except (ToolError, OSError, ValueError, TypeError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
