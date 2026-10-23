"""Read pure-data Lua tip files and reuse the plugin's actual Lua 5.4 schema."""

import re
from pathlib import Path

from .wiki import ToolError


class TipReader:
    def __init__(self, root):
        try:
            from lupa.lua54 import LuaRuntime, lua_type
        except ImportError as exc:
            raise ToolError("Install offline dependencies: python -m pip install -r tools/requirements.txt") from exc
        self.root = Path(root).resolve()
        self.lua_type = lua_type
        self.lua = LuaRuntime(unpack_returned_tuples=True, register_eval=False,
                              register_builtins=False, max_memory=32 * 1024 * 1024)
        self.modules = {}
        self.execute = self.lua.eval("""function(source, name, environment)
            local chunk, problem = load(source, name, 't', environment)
            if not chunk then error(problem) end
            return chunk()
        end""")
        self.start_limit = self.lua.eval("""function()
            local ticks = 0
            debug.sethook(function()
                ticks = ticks + 1
                if ticks > 200 then error('offline Lua instruction limit exceeded') end
            end, '', 10000)
        end""")
        self.end_limit = self.lua.eval("function() debug.sethook() end")
        self.schema = self.module("src/tips/schema")

    def module(self, name):
        allowed = {"src/tips/schema", "src/coach/conditions", "src/data/skills"}
        if name not in allowed:
            raise ToolError(f"Offline schema cannot require {name}")
        if name not in self.modules:
            # plain lua helpers only, no io/os/debug. string and table are here so a future
            # schema change using string.format or table.concat doesnt break the checker
            env = self.lua.table()
            for key in ("type", "pairs", "ipairs", "next", "select", "tostring", "tonumber",
                        "error", "assert", "math", "string", "table"):
                env[key] = self.lua.globals()[key]
            env.require = self.module
            source = (self.root / (name + ".lua")).read_text(encoding="utf-8-sig")
            try:
                self.modules[name] = self.execute(source, name, env)
            except ToolError:
                raise
            except Exception as exc:
                raise ToolError(f"Couldn't load {name}.lua offline: {exc}") from exc
        return self.modules[name]

    def data(self, source, name):
        # Tip data has no IO, client globals, Python bridge or require().
        self.start_limit()
        try:
            return self.execute(source, name, self.lua.table())
        except Exception as exc:
            raise ToolError(f"{name}: {exc}") from exc
        finally:
            self.end_limit()

    def plain(self, value, depth=0):
        if depth > 12:
            raise ToolError("Tip data is too deeply nested or cyclic")
        kind = self.lua_type(value)
        if kind == "table":
            keys = list(value.keys())
            if keys and all(type(key) is int for key in keys) and set(keys) == set(range(1, len(keys) + 1)):
                return [self.plain(value[i], depth + 1) for i in range(1, len(keys) + 1)]
            return {key: self.plain(value[key], depth + 1) for key in keys}
        if kind is not None:
            raise ToolError(f"Tip data contains a Lua {kind}; only plain data is allowed")
        return value

    def read(self):
        text = (self.root / "src/tips/catalogue.lua").read_text(encoding="utf-8-sig")
        match = re.search(r"local\s+TIP_FILES\s*=\s*(\{.*?\})", text, re.S)
        if not match:
            raise ToolError("Cannot find catalogue TIP_FILES")
        registered = self.plain(self.data("return " + match[1], "catalogue TIP_FILES"))
        if not isinstance(registered, list) or any(not isinstance(name, str) for name in registered):
            raise ToolError("Catalogue TIP_FILES must be a non-empty list of module paths")
        files = set(registered)
        discovered = {
            path.relative_to(self.root).with_suffix("").as_posix()
            for path in (self.root / "src/tips").rglob("*.lua")
            if path.name not in {"catalogue.lua", "schema.lua"}
        }
        problems = [f"Unregistered tip file: {name}" for name in sorted(discovered - files)]
        if len(files) != len(registered):
            problems.append("Catalogue registers a tip file more than once")
        entries = []
        for name in sorted(files):
            path = (self.root / (name + ".lua")).resolve()
            if not path.is_relative_to(self.root / "src/tips") or not path.is_file():
                problems.append(f"Missing or invalid tip file: {name}")
                continue
            try:
                values = self.data(path.read_text(encoding="utf-8-sig"), name)
                if self.lua_type(values) != "table":
                    raise ToolError("tip file must return a list")
                keys = list(values.keys())
                if set(keys) != set(range(1, len(keys) + 1)):
                    raise ToolError("tip file must return a contiguous list")
                for index in range(1, len(keys) + 1):
                    value = values[index]
                    messages = list(self.schema.problems(value).values())
                    if messages:
                        problems.extend(f"{name}[{index}]: {message}" for message in messages)
                    else:
                        entries.append({"file": name, "tip": self.plain(value)})
            except Exception as exc:
                problems.append(f"{name}: {exc}")
        return entries, problems


def references(tip):
    result = {"items": set(), "quests": set(), "varbits": set(), "achievements": set(), "categories": set()}
    if tip.get("icon_item"):
        result["items"].add(tip["icon_item"])
    if tip.get("quest"):
        result["quests"].add(tip["quest"])
    result["quests"].update(tip.get("requirements", {}).get("quests", []))
    for condition in tip.get("known_when", []):
        kind = condition["type"]
        if kind == "owns_any":
            result["items"].update(condition["items"])
        for condition_type, field, group in (
            ("quest_done", "quest", "quests"), ("varbit_at_least", "varbit", "varbits"),
            ("achievement_done", "achievement", "achievements"), ("owns_category", "category", "categories"),
        ):
            if kind == condition_type:
                result[group].add(condition[field])
    return result
