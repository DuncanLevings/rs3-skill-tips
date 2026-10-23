"""Extract review drafts from rendered RS3 training-guide tables, never shipped tips."""

import argparse
import re
import sys
import time
from pathlib import Path
from urllib.parse import unquote, urlparse, quote

from skilling_tools.configs import consumable_guess
from skilling_tools.html_tables import clean, headings_and_tables, grid
from skilling_tools.wiki import ToolError, WikiClient, network_arguments, write_json

ROOT = Path(__file__).resolve().parents[1]
SKILLS = (
    "Mining", "Woodcutting", "Fishing", "Hunter", "Divination", "Archaeology", "Farming",
    "Smithing", "Crafting", "Fletching", "Cooking", "Herblore", "Firemaking", "Runecrafting",
    "Construction", "Invention", "Agility", "Thieving", "Prayer", "Summoning", "Dungeoneering", "Slayer",
)
# requirements can be in any skill, combat ones included (eg Crystallise needs 88 Magic), so
# this is the full list, not just the skills that have guides above
REQUIREMENT_SKILLS = SKILLS + (
    "Attack", "Strength", "Defence", "Constitution", "Ranged", "Magic", "Necromancy",
)
LEVELS = re.compile(r"\blevels?\s+(\d{1,3})\s*(?:[-–—]|to)\s*(\d{1,3})\b", re.I)
# "Level 100+: Primal rocks" style headings, open ended up to the level cap
LEVEL_AND_UP = re.compile(r"\blevels?\s+(\d{1,3})\s*\+", re.I)


def page_links(cell):
    links = []
    for node in cell.walk():
        href = node.attrs.get("href", "")
        if node.tag != "a" or not href.startswith("/w/"):
            continue
        page = unquote(urlparse(href).path[3:]).replace("_", " ")
        if ":" in page or page in links:
            continue
        links.append(page)
    return links


def find_column(headers, *names):
    for index, header in enumerate(headers):
        if any(name in header.casefold() for name in names):
            return index
    return None


def cell_text(row, index):
    return clean(row[index].text()) if index is not None and index < len(row) else ""


def level_range(text, bare=False):
    match = LEVELS.search(text)
    if not match and bare:
        match = re.fullmatch(r"\s*(\d{1,3})\s*[-–—]\s*(\d{1,3})\s*", text)
    if match:
        low, high = map(int, match.groups())
        if 1 <= low <= high <= 120:
            return [low, high]
    match = LEVEL_AND_UP.search(text)
    if match and 1 <= int(match[1]) <= 120:
        return [int(match[1]), 120]
    return None


def required_levels(text):
    # "80 Mining 20 Invention" or "Mining 80" -> {"MINING": 80, "INVENTION": 20}
    levels = {}
    for skill in REQUIREMENT_SKILLS:
        match = re.search(rf"\b(\d{{1,3}})\s+{skill}\b|\b{skill}\s+(\d{{1,3}})\b", text, re.I)
        if match:
            levels[skill.upper()] = int(next(group for group in match.groups() if group))
    return levels


def group_label(row, headers):
    # tables split into groups with a full width header row ("High priority", "Additional
    # XP"...), every cell is a th holding the same text
    if any(cell.tag != "th" for cell in row):
        return None
    texts = {clean(cell.text()) for cell in row}
    if len(texts) == 1:
        label = texts.pop()
        if label and label not in headers:
            return label
    return None


def extract(page, skill):
    equipment, methods, notes = [], [], []
    source = "https://runescape.wiki/w/" + quote(page["title"].replace(" ", "_"), safe="/")
    for headings, table in headings_and_tables(page["text"]):
        rows = grid(table)
        header_index = next((i for i, row in enumerate(rows) if any(cell.tag == "th" for cell in row)), None)
        if header_index is None:
            continue
        headers = [clean(cell.text()) for cell in rows[header_index]]
        section = " / ".join(headings)
        equipment_table = bool(re.search(r"equipment|outfits?|boosting items", section, re.I))
        level_column = find_column(headers, "level")
        section_range = next((found for heading in reversed(headings) if (found := level_range(heading))), None)
        if not equipment_table and not section_range and level_column is None:
            continue
        name_column = find_column(headers, "item", "equipment", "name")
        if name_column is None:
            name_column = 0
        name_columns = [i for i, header in enumerate(headers) if header == headers[name_column]]
        requirement_column = find_column(headers, "require", "level")
        effect_column = find_column(headers, "effect", "benefit", "description", "notes", "use")
        slot_column = find_column(headers, "slot")
        group = None
        for number, row in enumerate(rows[header_index + 1:], header_index + 2):
            label = group_label(row, headers)
            if label:
                group = label
                continue
            if not any(cell.tag == "td" for cell in row):
                continue
            values = [clean(cell.text()) for cell in row]
            if not any(values) or values == headers:
                continue
            columns = {f"{i + 1}: {header or 'column'}": values[i] if i < len(values) else ""
                       for i, header in enumerate(headers)}
            evidence = {"source_url": source, "section": section, "table_row": number, "columns": columns}
            if equipment_table:
                links = list(dict.fromkeys(link for i in name_columns if i < len(row) for link in page_links(row[i])))
                # Guides often split the Item column into an icon cell and a text cell.
                display_column = name_columns[-1]
                name = cell_text(row, display_column) or (links[0] if links else "")
                if not name:
                    continue
                requirements = cell_text(row, requirement_column)
                requirement_links = []
                if requirement_column is not None and requirement_column < len(row):
                    # usually quests or other items, kept so the author can check them
                    requirement_links = [
                        link for link in page_links(row[requirement_column])
                        if link not in REQUIREMENT_SKILLS
                    ]
                equipment.append({
                    **evidence, "name": name, "wiki_items": links,
                    "effect": cell_text(row, effect_column) or " | ".join(values[1:]),
                    "slot": cell_text(row, slot_column) or None,
                    "requirements": {
                        "text": requirements,
                        "skills": required_levels(requirements),
                        "links": requirement_links,
                    },
                    # the guide's own group inside the table, else the section heading. no
                    # numeric priority is made up, the author picks that
                    "priority_group": group or (headings[-1] if headings else None),
                    "consumable_guess": consumable_guess(name),
                })
            else:
                bracket = level_range(cell_text(row, level_column), bare=True) or section_range
                if bracket:
                    methods.append({**evidence, "level_range": bracket, "description": " | ".join(values)})
    # Some guides describe methods in prose rather than tables. Preserve explicit heading brackets too.
    from skilling_tools.html_tables import Document
    for node in Document(page["text"]).root.walk():
        if re.fullmatch(r"h[2-6]", node.tag):
            title = clean(node.text())
            bracket = level_range(title)
            if bracket and not any(row["section"].endswith(title) for row in methods):
                methods.append({"source_url": source, "section": title, "level_range": bracket,
                                "description": title, "needs_review": "Heading only; read the section before writing a tip"})
    if not equipment:
        notes.append("No equipment rows recognized; inspect the guide layout rather than assuming none exist")
    if not methods:
        notes.append("No explicit method brackets recognized; review the page manually")
    return {
        "version": 1, "skill": skill.upper(), "status": "draft_for_manual_review",
        "source": {"title": page["title"], "url": source, "revision": page.get("revid"),
                   "license": "CC BY-NC-SA 3.0", "fetched_at": int(time.time())},
        "equipment": equipment, "method_brackets": methods, "notes": notes,
    }


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("skills", nargs="+", choices=[skill.lower() for skill in SKILLS])
    parser.add_argument("--page", help="Override the wiki page for one skill")
    parser.add_argument("--output-dir", type=Path, default=ROOT / "work/drafts")
    network_arguments(parser, ROOT)
    args = parser.parse_args(argv)
    try:
        if args.page and len(args.skills) != 1:
            raise ToolError("--page needs exactly one skill")
        client = WikiClient(args.cache, args.offline, args.refresh)
        for skill in dict.fromkeys(args.skills):
            title = args.page or f"Pay-to-play {skill.capitalize()} training"
            draft = extract(client.page(title), skill)
            path = args.output_dir / (skill + ".json")
            write_json(path, draft)
            print(f"{skill}: {len(draft['equipment'])} equipment rows, {len(draft['method_brackets'])} method brackets -> {path}")
            for note in draft["notes"]:
                print(f"  REVIEW: {note}")
        return 0
    except (ToolError, OSError, ValueError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
