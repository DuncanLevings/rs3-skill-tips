"""Rewrite tip files so every tip lists its fields in the same order and layout.

    python tools/format_tips.py            rewrite every tip file in place
    python tools/format_tips.py --check    list files that would change, exit 1 if any

Tip files are plain data (`return { {...}, {...} }`), so this parses them with a small
reader for that subset of Lua, keeps every comment, and writes them back out:

- top level tip fields in FIELD_ORDER, nested tables in their own fixed orders
- skill requirement maps sorted A to Z
- prose (hook, why, how steps...) wrapped with `..` to stay inside 100 columns
- short lists and tables on one line when they fit, prose lists always one step per line

It refuses to write a file containing anything it doesn't recognise (an unknown field,
a function call, a local), so a new kind of tip data needs adding here first.
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TIP_FILES = sorted((ROOT / "src" / "tips" / "skills").glob("*.lua")) + [
    ROOT / "src" / "tips" / name
    for name in ("shared.lua", "quests.lua")
]

WIDTH = 100
INDENT = "    "

# identity, who its for, what the card says, what gates it, when it fires, ranking
FIELD_ORDER = [
    "id",
    "kind",
    "quest",
    "skills",
    "members",
    "level_range",
    "main_method",
    "min_training_level",
    "title",
    "icon_item",
    "icon_item_id",
    "hook",
    "aspiration_hook",
    "why",
    "how",
    "quest_how",
    "requirements",
    "require_all_levels",
    "require_quests_complete",
    "aspiration",
    "triggers",
    "known_when",
    "priority",
]
REQUIREMENT_ORDER = ["skills", "any_skills", "quests"]
ENTRY_ORDER = [
    "type",
    "skill",
    "level",
    "quest",
    "achievement",
    "varbit",
    "value",
    "category",
    "items",
]
ASPIRATION_ORDER = ["max_missing_skills", "max_level_gap", "max_total_gap"]

# lists of player facing steps, always one per line
PROSE_LISTS = {"how", "quest_how"}
# maps of SKILL = level inside requirements, sorted by skill name
SKILL_MAPS = {"skills", "any_skills"}
# skill files go items, then main methods, then alternatives, each under one of these
SECTIONS = ["items", "methods", "alternatives"]
SECTION_MARKERS = {
    "items": "-- useful items and unlocks",
    "methods": "-- training methods, one main method per level bracket",
    "alternatives": "-- alternative methods, offered alongside the main method for a level",
}
OLD_SECTION_MARKERS = set(SECTION_MARKERS.values()) | {
    "-- convenience items",
    "-- useful items and unlocks",
    "-- training methods",
    "-- alternative methods",
}

# top level fields whose tables get their insides put in a fixed order
NESTED_FIELDS = {"requirements", "aspiration", "triggers", "known_when"}


class FormatError(Exception):
    pass


# --- reading ---------------------------------------------------------------------------


@dataclass
class Token:
    kind: str  # name, string, number, symbol, comment, newline
    text: str
    line: int


TOKEN_PATTERN = re.compile(
    r"""
    (?P<comment>--[^\n]*)
  | (?P<string>"[^"\\\n]*")
  | (?P<number>-?\d+(?:\.\d+)?)
  | (?P<name>[A-Za-z_][A-Za-z0-9_]*)
  | (?P<symbol>\.\.|[{}=,])
  | (?P<newline>\n)
  | (?P<space>[ \t\r]+)
    """,
    re.VERBOSE,
)


def tokenize(source: str) -> list[Token]:
    tokens, position, line = [], 0, 1
    while position < len(source):
        match = TOKEN_PATTERN.match(source, position)
        if not match:
            raise FormatError(f"line {line}: can't read {source[position:position + 20]!r}")
        kind = match.lastgroup
        text = match.group()
        if kind != "space":
            tokens.append(Token(kind, text, line))
        if kind == "newline":
            line += 1
        position = match.end()
    return tokens


@dataclass
class Text:
    """A string, possibly written as several "a" .. "b" pieces. Kept as the raw insides."""

    value: str


@dataclass
class Table:
    # each item is (key or None, value, leading comment lines)
    items: list[tuple[str | None, object, list[str]]] = field(default_factory=list)
    # comments after the last item, before the closing brace
    trailing: list[str] = field(default_factory=list)


class Reader:
    def __init__(self, tokens: list[Token]):
        self.tokens = tokens
        self.index = 0

    def peek(self, skip_newlines: bool = True) -> Token | None:
        index = self.index
        while index < len(self.tokens):
            token = self.tokens[index]
            if skip_newlines and token.kind == "newline":
                index += 1
                continue
            return token
        return None

    def take(self) -> Token:
        while self.tokens[self.index].kind == "newline":
            self.index += 1
        token = self.tokens[self.index]
        self.index += 1
        return token

    def expect(self, text: str) -> None:
        token = self.take()
        if token.text != text:
            raise FormatError(f"line {token.line}: expected {text!r}, found {token.text!r}")

    def comments(self) -> list[str]:
        """Comment lines before the next value, with a "" marking each blank line between."""
        found, newlines = [], 0
        while self.index < len(self.tokens):
            token = self.tokens[self.index]
            if token.kind == "newline":
                newlines += 1
            elif token.kind == "comment":
                if newlines > 1 and found:
                    found.append("")
                found.append(token.text)
                newlines = 0
            else:
                break
            self.index += 1
        return found

    def value(self) -> object:
        token = self.take()
        if token.text == "{":
            return self.table()
        if token.kind == "string":
            pieces = [token.text[1:-1]]
            while (following := self.peek()) and following.text == "..":
                self.take()
                piece = self.take()
                if piece.kind != "string":
                    raise FormatError(f"line {piece.line}: can only join strings with ..")
                pieces.append(piece.text[1:-1])
            return Text("".join(pieces))
        if token.kind == "number":
            return int(token.text) if re.fullmatch(r"-?\d+", token.text) else float(token.text)
        if token.text in ("true", "false"):
            return token.text == "true"
        raise FormatError(f"line {token.line}: tips are data only, found {token.text!r}")

    def table(self) -> Table:
        table = Table()
        while True:
            leading = self.comments()
            token = self.peek()
            if token is None:
                raise FormatError("file ended inside a table")
            if token.text == "}":
                self.take()
                table.trailing = leading
                return table

            key = None
            if token.kind == "name" and token.text not in ("true", "false"):
                self.take()
                self.expect("=")
                key = token.text
            table.items.append((key, self.value(), leading))

            following = self.peek()
            if following and following.text == ",":
                self.take()


def read_file(path: Path) -> tuple[list[str], Table]:
    tokens = tokenize(path.read_text(encoding="utf-8"))
    reader = Reader(tokens)
    header = reader.comments()
    token = reader.take()
    if token.text != "return":
        raise FormatError(f"{path.name}: tip files must start with return")
    reader.expect("{")
    tips = reader.table()
    if reader.peek() is not None:
        raise FormatError(f"{path.name}: something after the tip list")
    return header, tips


# --- writing ---------------------------------------------------------------------------


def quote(raw: str) -> str:
    return f'"{raw}"'


def wrap_text(raw: str, first_room: int, room: int) -> list[str]:
    """Split a string into pieces that fit, breaking after spaces like the hand wrapped tips."""
    pieces, rest, limit = [], raw, first_room
    while len(quote(rest)) > limit:
        cut = rest.rfind(" ", 0, limit - 2)
        if cut <= 0:
            break
        pieces.append(rest[: cut + 1])
        rest = rest[cut + 1 :]
        limit = room
    pieces.append(rest)
    return pieces


def write_text(prefix: str, raw: str, suffix: str, indent: str) -> list[str]:
    """prefix "text" suffix, wrapped onto `.. "more"` lines indented one level deeper."""
    continuation = indent + INDENT + ".. "
    pieces = wrap_text(
        raw,
        WIDTH - len(prefix) - (len(suffix) if len(quote(raw)) + len(prefix) <= WIDTH else 0),
        WIDTH - len(continuation) - len(suffix),
    )
    lines = [prefix + quote(pieces[0])]
    for piece in pieces[1:]:
        lines.append(continuation + quote(piece))
    lines[-1] += suffix
    return lines


def ordered_items(table: Table, order: list[str], where: str, sort_keys: bool = False):
    keyed = [item for item in table.items if item[0] is not None]
    if len(keyed) != len(table.items):
        raise FormatError(f"{where}: expected only named fields, found a list entry")
    unknown = [key for key, _, _ in keyed if key not in order and not sort_keys]
    if unknown:
        raise FormatError(f"{where}: unknown field {unknown[0]!r}, add it to format_tips.py")
    if sort_keys:
        return sorted(keyed, key=lambda item: item[0])
    return sorted(keyed, key=lambda item: order.index(item[0]))


def inline(value: object) -> str | None:
    """value on a single line, or None for values that never go on one line."""
    if isinstance(value, Text):
        return quote(value.value)
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, Table):
        if table_has_comments(value):
            return None
        parts = []
        for key, child, _ in value.items:
            text = inline(child)
            if text is None:
                return None
            parts.append(f"{key} = {text}" if key else text)
        return "{ " + ", ".join(parts) + " }" if parts else "{}"
    raise FormatError(f"can't write {value!r}")


def table_has_comments(table: Table) -> bool:
    if table.trailing:
        return True
    for _, child, leading in table.items:
        if leading or (isinstance(child, Table) and table_has_comments(child)):
            return True
    return False


def write_comments(comments: list[str], indent: str) -> list[str]:
    return [indent + line if line else "" for line in comments]


def normalise(key: str | None, value: object, path: str) -> object:
    """Put a nested table's fields in their fixed order before it gets written."""
    if not isinstance(value, Table):
        return value
    if key == "requirements":
        items = ordered_items(value, REQUIREMENT_ORDER, path)
    elif key in SKILL_MAPS:
        items = ordered_items(value, [], path, sort_keys=True)
    elif key == "aspiration":
        items = ordered_items(value, ASPIRATION_ORDER, path)
    elif key in ("triggers", "known_when"):
        items = [(None, normalise("entry", child, path), leading)
                 for _, child, leading in value.items]
        return Table(items, value.trailing)
    elif key == "entry":
        items = ordered_items(value, ENTRY_ORDER, path)
    else:
        # plain lists (skills, how, items, level_range...) keep their order
        return value
    return Table(
        [(child_key, normalise(child_key, child, f"{path}.{child_key}"), leading)
         for child_key, child, leading in items],
        value.trailing,
    )


def write_value(key: str | None, value: object, indent: str) -> list[str]:
    """One field (or list entry) and its trailing comma, as lines."""
    prefix = indent + (f"{key} = " if key else "")

    if isinstance(value, Text):
        return write_text(prefix, value.value, ",", indent)

    one_line = inline(value)
    always_open = key in PROSE_LISTS or key in ("requirements", "triggers", "known_when")
    if one_line is not None and not always_open and len(prefix + one_line + ",") <= WIDTH:
        return [prefix + one_line + ","]

    if not isinstance(value, Table):
        return [prefix + str(one_line) + ","]

    lines = [prefix + "{"]
    for child_key, child, leading in value.items:
        lines += write_comments(leading, indent + INDENT)
        lines += write_value(child_key, child, indent + INDENT)
    lines += write_comments(value.trailing, indent + INDENT)
    lines.append(indent + "},")
    return lines


def write_tip(tip: Table, where: str) -> list[str]:
    indent = INDENT * 2
    lines = [INDENT + "{"]
    for key, value, leading in ordered_items(tip, FIELD_ORDER, where):
        # only these hold nested tables with their own order. the top level skills field is
        # a plain list, not a requirements map, so it keeps its order
        if key in NESTED_FIELDS:
            value = normalise(key, value, f"{where}.{key}")
        lines += write_comments(leading, indent)
        lines += write_value(key, value, indent)
    lines += write_comments(tip.trailing, indent)
    lines.append(INDENT + "},")
    return lines


def tip_id(tip: Table) -> str:
    for key, value, _ in tip.items:
        if key == "id" and isinstance(value, Text):
            return value.value
    return "?"


def field_value(tip: Table, name: str) -> object:
    for key, value, _ in tip.items:
        if key == name:
            return value.value if isinstance(value, Text) else value
    return None


def section(tip: Table) -> str:
    """Which part of a skill file a tip belongs in."""
    if field_value(tip, "kind") == "method":
        return "methods" if field_value(tip, "main_method") else "alternatives"
    return "items"


def format_file(path: Path) -> str:
    header, tips = read_file(path)
    lines = write_comments(header, "")
    if lines and lines[-1] != "":
        lines.append("")
    lines.append("return {")

    # skill files get the same three section markers, written fresh every time
    marked = path.parent.name == "skills"
    current_section = None

    for number, (_, tip, leading) in enumerate(tips.items):
        if not isinstance(tip, Table):
            raise FormatError(f"{path.name}: entry {number + 1} isn't a tip table")
        if number > 0:
            lines.append("")

        comments = [line for line in leading if line != ""]
        if marked:
            comments = [line for line in comments if line not in OLD_SECTION_MARKERS]
            tip_section = section(tip)
            if tip_section != current_section:
                if SECTIONS.index(tip_section) < SECTIONS.index(current_section or "items"):
                    raise FormatError(f"{path.name} {tip_id(tip)}: out of section order")
                lines.append(INDENT + SECTION_MARKERS[tip_section])
                current_section = tip_section

        lines += write_comments(comments, INDENT)
        lines += write_tip(tip, f"{path.name} {tip_id(tip)}")

    if tips.trailing:
        lines += write_comments(tips.trailing, INDENT)
    lines.append("}")
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--check", action="store_true", help="only report files that differ")
    arguments = parser.parse_args()

    changed = []
    for path in TIP_FILES:
        try:
            formatted = format_file(path)
        except FormatError as problem:
            print(f"{path.relative_to(ROOT)}: {problem}", file=sys.stderr)
            return 2

        if formatted != path.read_text(encoding="utf-8"):
            changed.append(path)
            if not arguments.check:
                path.write_text(formatted, encoding="utf-8", newline="\n")

    for path in changed:
        print(("would change " if arguments.check else "formatted ") + str(path.relative_to(ROOT)))

    return 1 if arguments.check and changed else 0


if __name__ == "__main__":
    sys.exit(main())
