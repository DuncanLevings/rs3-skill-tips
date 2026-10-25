Skill Tips offline tools
============================

Developer tools for writing and checking tips. None of this ships to players:
tools/package.ps1 only packs main.lua, plugin.json, src/ and the player docs.


Setup
-----

Python 3.12 or newer.

    python -m pip install -r tools/requirements.txt

The only dependency is Lupa, which runs the plugin's real Lua 5.4 tip schema
from Python, so the checker can't drift from what the plugin accepts.
Everything else is the standard library.

On Windows, add -X utf8 to every python command. Run everything from the
plugin root.


The tools
---------

extract_training_guides.py

    python tools/extract_training_guides.py mining woodcutting fishing

Reads each skill's "Pay-to-play <Skill> training" wiki guide and writes a
review draft to work/drafts/<skill>.json. Each draft has:

  - equipment rows, with
      - name, and the wiki item pages linked in the row
      - effect and slot
      - requirements: text, parsed skill levels, linked quests/items
      - priority group: the guide's own grouping, eg "High priority",
        "Additional XP"
      - a consumable guess: true, false or null (null = unknown)
  - method brackets: level ranges from tables and "Levels X-Y" / "Level N+"
    headings. Heading-only entries are marked needs_review.
  - source URL, revision, licence and fetch time.

Drafts are reading material for a person writing tips. Nothing is written
into src/tips. Wiki text is CC BY-NC-SA, so tips are written in your own
words (see docs/writing-tips.md).

  --page "Some page"   use a different page (one skill at a time)
  --output-dir DIR     where drafts go (default work/drafts)


list_item_ids.py

    python tools/list_item_ids.py "Bronze ore box" "Grace of the elves"
    python tools/list_item_ids.py --from-draft work/drafts/mining.json
    python tools/list_item_ids.py --from-tips

Looks up wiki item IDs for item pages, including every variant (new/used,
active/inactive). Redirects are followed. It writes:

  - work/item_ids.json
  - work/item_ids.lua, a list ready to paste into the probe

Client config names (eg MINING_OREBOX_BRONZE) are not on the wiki and this
tool never guesses them. The probe reads them in game with
config.Obj.FromID(id).

A page reported MISSING is usually an umbrella page ("Ore boxes", "Sign of
the porter") covering several items. List each item's own page instead.

  --from-draft FILE  every item linked in a draft's equipment rows
  --from-tips        items the shipped tips mention (needs config evidence
                     with a wiki page or display name for each)


check_tips.py

    python tools/check_tips.py --strict

Loads every tip file through the plugin's real schema (src/tips/schema.lua)
and checks:

  - schema problems, duplicate ids, tip files missing from the catalogue
  - every item, quest, varbit, achievement and category a tip names exists
    in the config evidence (see below). Unknown names are errors.
  - quest names that share a display name with another quest config (the
    COOK_QUEST vs COOKS_ASSISTANT trap)
  - consumables:
      - an item the evidence marks consumable is an error
      - a name that only looks consumable (potion, urn, pouch...) is a review
        warning, because "pouch" also matches runecrafting pouches
  - quest tips use a requirements_met trigger with skill = "ANY"
  - no leftover wiki_page fields
  - method level gaps per skill (information only)

  --strict              review warnings fail the run too
  --configs FILE        use this evidence instead of tools/verified_configs.json
  --probe-log FILE      add configs seen in a probe console log (repeatable)
  --write-configs FILE  save the merged evidence for later runs
  --schema-only         skip config checks (says so in the output)
  --max-level N         level cap for the gap report (default 120)
  --report FILE         write the results as JSON


format_tips.py

    python tools/format_tips.py
    python tools/format_tips.py --check

Rewrites the tip files so every tip lists its fields in the same order (the
order documented at the top of src/tips/schema.lua), with the same layout and
wrapping inside 100 columns. Skill files also get the same three section
markers: useful items, training methods, alternative methods. Comments are
kept. Run it after adding or editing tips; --check only lists files that
would change and exits 1 if any would.

No dependencies beyond the standard library.


Config evidence
---------------

tools/verified_configs.json holds config names confirmed in game, version 1:

    { "version": 1,
      "items":   { "CONFIG_NAME": { "id": 44779, "name": "Bronze ore box",
                                    "wiki_page": "Bronze ore box",
                                    "category": 4448, "consumable": false } },
      "quests":  { "COOKS_ASSISTANT": { "id": 257, "name": "Cook's Assistant" } },
      "varbits": { "TOOLBELT_PICKAXE_LEVEL": { "id": -18522 } },
      "achievements": {} }

Right now it only has the 11 ore boxes. It is not a full client dump:
every new item, quest or varbit a tip uses has to be confirmed in game
first. The probe's console output can be fed straight in with --probe-log.
It understands these lines:

  - "quest <id> | <CONFIG> | <name> | ..."   from Dump quests
  - "item <name> | <id> | <CONFIG> | <cat>"  from the item lookup
  - "!give <CONFIG> <n> -- <name>"
  - "obj=<CONFIG> category=<n>"              from clicks
  - varbit access lines

Set "consumable" by hand once you know. Leaving it out means "unknown", and
that shows as a review warning.


Wiki requests
-------------

All network tools share one client:

  - a descriptive User-Agent
  - at least 1 second between requests
  - retries on rate limits and server errors, with backoff
  - every response cached in work/wiki-cache (error responses aren't cached)

Don't run two network tools at the same time, or the request spacing stops
working.

  --offline   only use the cache, fail if something isn't cached
  --refresh   fetch again and replace the cache
  --cache DIR another cache folder


Exit codes
----------

  0  everything fine
  1  the check found problems (errors, or warnings with --strict), or
     item pages were missing
  2  the tool itself couldn't run: bad arguments, unreadable files, network
     failure, broken Lua


Writing a skill's tips (phase 7 workflow)
-----------------------------------------

1.  Extract the guide:
        python tools/extract_training_guides.py <skill>
2.  Read work/drafts/<skill>.json alongside the wiki guide. Pick the
    convenience items worth a tip (no consumables) and the method brackets.
3.  Get IDs for the chosen items:
        python tools/list_item_ids.py "<item page>" ...
4.  Paste work/item_ids.lua into the probe's item lookup, run it in game
    and save the console output.
5.  Add the confirmed names to the evidence:
        python tools/check_tips.py --probe-log <log> --write-configs tools/verified_configs.json
    Then fill in "consumable" for each item by hand.
6.  Write the tips in src/tips/skills/<skill>.lua (register new files in
    src/tips/catalogue.lua). Follow docs/writing-tips.md.
7.  Check:
        python tools/check_tips.py --strict
    and run the Lua specs.
8.  Test the tips in game.


Tests
-----

    python -m unittest discover -s tools/tests

These are offline. Network behaviour is tested with fakes.
