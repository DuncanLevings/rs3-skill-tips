"""Config evidence comes from client probes, never from guessed wiki-to-client names."""

import json
import re
from pathlib import Path

from .wiki import ToolError

GROUPS = ("items", "quests", "varbits", "achievements")


def load_configs(path):
    data = json.loads(Path(path).read_text(encoding="utf-8-sig"))
    if not isinstance(data, dict) or data.get("version") != 1:
        raise ToolError(f"{path}: expected version-1 config evidence")
    for group in GROUPS:
        entries = data.get(group, {})
        if not isinstance(entries, dict):
            raise ToolError(f"{path}: {group} must map config names to records")
        for name, record in entries.items():
            if not isinstance(name, str) or not isinstance(record, dict):
                raise ToolError(f"{path}: invalid {group} record")
    return data


def import_probe(path):
    data = {"version": 1, "source": Path(path).name, **{key: {} for key in GROUPS}}
    text = Path(path).read_text(encoding="utf-8-sig", errors="replace")
    for line in text.splitlines():
        # newer probes add a deprecated column, which settles quests that share a name
        match = re.search(r"\[sc-probe\]\s+quest\s+(\d+)\s*\|\s*([A-Z][A-Z0-9_]*)\s*\|\s*(.*?)\s*\|"
                          r"\s*(?:true|false)\s*\|\s*(?:true|false)(?:\s*\|\s*(true|false))?", line)
        if match:
            number, name, display, deprecated = match.groups()
            data["quests"][name] = {"id": int(number), "name": display}
            if deprecated is not None:
                data["quests"][name]["deprecated"] = deprecated == "true"
        match = re.search(r"\[sc-probe\]\s+item\s+(.+?)\s*\|\s*(\d+)\s*\|\s*([A-Z][A-Z0-9_]*)\s*\|\s*(-?\d+)", line)
        if match:
            display, number, name, category = match.groups()
            data["items"][name] = {"id": int(number), "name": display, "category": int(category)}
        match = re.search(r"\[sc-probe\]\s+!give\s+([A-Z][A-Z0-9_]*)\s+\d+\s+--\s+(.+)$", line)
        if match:
            name, display = match.groups()
            data["items"].setdefault(name, {"name": display})
        match = re.search(r"\bobj=([A-Z][A-Z0-9_]*)\s+category=(-?\d+)", line)
        if match:
            name, category = match.groups()
            data["items"].setdefault(name, {}).setdefault("category", int(category))
        if "isVarBit=true" in line and "FAILED:" not in line:
            match = re.search(r"\bname=([A-Z][A-Z0-9_]*).*?\bid=(-?\d+)", line)
            if match:
                name, number = match.groups()
                data["varbits"][name] = {"id": int(number)}
    if not any(data[key] for key in GROUPS):
        raise ToolError(f"{path}: no recognized probe config records")
    return data


def merge_configs(base, extra):
    for group in GROUPS:
        for name, record in extra.get(group, {}).items():
            base.setdefault(group, {}).setdefault(name, {}).update(record)
    return base


def consumable_guess(name):
    # Hints for manual review, not an attempt to infer all item behavior from its name.
    if re.search(r"\b(potion|flask|incense|urns?|porters?|portents?|protean|food|bombs?|stone spirits?|pouch|scrolls?)\b", name, re.I):
        return True
    if re.search(r"\b(ore box|wood box|pickaxe|hatchet|outfit|amulet|necklace|ring|cape)\b", name, re.I):
        return False
    return None
