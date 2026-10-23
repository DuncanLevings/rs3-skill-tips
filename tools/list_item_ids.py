"""List all wiki item variants and IDs for a client-config lookup in the probe."""

import argparse
import json
import sys
from pathlib import Path

from skilling_tools.configs import load_configs, import_probe, merge_configs
from skilling_tools.tips import TipReader, references
from skilling_tools.wiki import ToolError, WikiClient, network_arguments, write_json

ROOT = Path(__file__).resolve().parents[1]


def item_pages(args):
    pages = list(args.items)
    for path in args.from_draft:
        draft = json.loads(path.read_text(encoding="utf-8-sig"))
        for row in draft.get("equipment", []):
            pages.extend(row.get("wiki_items") or [row["name"]])
    if args.from_tips:
        reader = TipReader(args.root)
        entries, problems = reader.read()
        if problems:
            raise ToolError("Cannot read tip references: " + "; ".join(problems))
        configs = load_configs(args.configs)
        for path in args.probe_log:
            merge_configs(configs, import_probe(path))
        for entry in entries:
            for name in sorted(references(entry["tip"])["items"]):
                record = configs.get("items", {}).get(name)
                if not record or not (record.get("wiki_page") or record.get("name")):
                    raise ToolError(f"No wiki page/display name for {name}; supply client evidence or an explicit item page")
                pages.append(record.get("wiki_page") or record["name"])
    if not pages:
        raise ToolError("Supply item page names, --from-draft, or --from-tips")
    if any(not isinstance(page, str) or not page.strip() for page in pages):
        raise ToolError("Item page names must be non-empty text")
    return list(dict.fromkeys(page.strip() for page in pages))


def lua_string(text):
    # a double quoted Lua string. json.dumps isnt quite right: it writes control characters
    # as \uXXXX, which Lua 5.4 doesnt read (it wants \u{XXXX})
    escaped = []
    for character in text:
        code = ord(character)
        if character in '"\\':
            escaped.append("\\" + character)
        elif code < 32 or code == 127:
            escaped.append(f"\\{code:03d}")
        else:
            escaped.append(character)
    return '"' + "".join(escaped) + '"'


def rows_for(client, page):
    # tries the page as given, then wherever it redirects to
    rows = client.item_rows(page)
    if rows:
        return rows, page
    resolved = client.resolve_title(page)
    if resolved != page:
        return client.item_rows(resolved), resolved
    return rows, page


def lookup(client, pages):
    items, missing = [], []
    for page in pages:
        rows, page_name = rows_for(client, page)
        found = False
        for row in rows:
            ids = row.get("item_id")
            if type(ids) is int:
                ids = [ids]
            if not isinstance(ids, list) or any(type(number) is not int or number < 1 for number in ids):
                raise ToolError(f"Invalid item_id data for {page}")
            if not ids:
                continue
            found = True
            # single version items report DEFAULT, thats not a real variant name
            variant = row.get("version_anchor")
            if not variant or variant == "DEFAULT":
                variant = None
            items.append({"requested_page": page, "wiki_page": row.get("page_name", page_name),
                          "name": row.get("item_name", page_name), "variant": variant,
                          "ids": sorted(set(ids))})
        if not found:
            # usually an umbrella page like "Ore boxes" that covers several items with their own
            # pages, those have no single item id
            missing.append({"page": page, "resolved": page_name,
                            "reason": "no item infobox; if this page covers several items, list each item's own page"})
    return {"version": 1, "source": "RuneScape Wiki infobox_item", "items": items, "missing": missing}


def probe_rows(result):
    rows = ["-- wiki IDs only; verify config.Obj.FromID(id).configName and category in game", "return {"]
    seen = set()
    for item in result["items"]:
        for number in item["ids"]:
            if number in seen:
                continue
            seen.add(number)
            name = item["name"] + (f" ({item['variant']})" if item["variant"] else "")
            rows.append(f"    {{ wiki_name = {lua_string(name)}, id = {number} }},")
    rows.append("}")
    return "\n".join(rows) + "\n"


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("items", nargs="*")
    parser.add_argument("--from-draft", action="append", type=Path, default=[])
    parser.add_argument("--from-tips", action="store_true")
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument("--configs", type=Path, default=ROOT / "tools/verified_configs.json")
    parser.add_argument("--probe-log", action="append", type=Path, default=[])
    parser.add_argument("--output", type=Path, default=ROOT / "work/item_ids.json")
    parser.add_argument("--probe-output", type=Path, default=ROOT / "work/item_ids.lua")
    network_arguments(parser, ROOT)
    args = parser.parse_args(argv)
    try:
        pages = item_pages(args)
        result = lookup(WikiClient(args.cache, args.offline, args.refresh), pages)
        write_json(args.output, result)
        args.probe_output.parent.mkdir(parents=True, exist_ok=True)
        args.probe_output.write_text(probe_rows(result), encoding="utf-8", newline="\n")
        for item in result["items"]:
            print(f"{item['name']} [{item['variant'] or 'default'}]: {', '.join(map(str, item['ids']))}")
        for entry in result["missing"]:
            print(f"MISSING: {entry['page']} ({entry['reason']})", file=sys.stderr)
        print(f"Wrote {args.output} and {args.probe_output}; no client config names were inferred")
        return 1 if result["missing"] else 0
    except (ToolError, OSError, ValueError, KeyError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
