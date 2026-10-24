"""Small, cached MediaWiki client shared by the offline commands."""

import hashlib
import json
import time
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen

API = "https://runescape.wiki/api.php"
USER_AGENT = (
    "SkillTipsOfflineTools/0.1 "
    "(https://github.com/DuncanLevings/rs3-skilling-coach; offline content preparation)"
)


class ToolError(Exception):
    """An actionable command error, printed without a Python traceback."""


def write_json(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    temporary.replace(path)


class WikiClient:
    def __init__(self, cache, offline=False, refresh=False, interval=1.0):
        if offline and refresh:
            raise ToolError("--offline and --refresh cannot be combined")
        self.cache = Path(cache)
        self.offline = offline
        self.refresh = refresh
        self.interval = max(1.0, interval)
        self.last_request = 0.0

    def request(self, **parameters):
        parameters = {**parameters, "format": "json", "formatversion": 2, "maxlag": 5}
        key = hashlib.sha256(json.dumps(parameters, sort_keys=True).encode()).hexdigest()
        path = self.cache / (key + ".json")
        if path.exists() and not self.refresh:
            try:
                cached = json.loads(path.read_text(encoding="utf-8"))
                if cached["parameters"] == parameters:
                    self._check(cached["response"])
                    return cached["response"]
            except (ValueError, KeyError, TypeError, ToolError) as exc:
                raise ToolError(f"Invalid cache {path}; remove it or use --refresh: {exc}") from exc
        if self.offline:
            raise ToolError(f"No cached response for {parameters}; run once without --offline")
        for attempt in range(3):
            time.sleep(max(0, self.interval - (time.monotonic() - self.last_request)))
            self.last_request = time.monotonic()
            try:
                request = Request(API + "?" + urlencode(parameters), headers={"User-Agent": USER_AGENT})
                with urlopen(request, timeout=25) as response:
                    data = json.load(response)
                error = data.get("error") if isinstance(data, dict) else None
                if isinstance(error, dict) and error.get("code") in {"maxlag", "ratelimited"}:
                    if attempt < 2:
                        time.sleep(2 ** (attempt + 1))
                        continue
                self._check(data)
                write_json(path, {"parameters": parameters, "fetched_at": int(time.time()), "response": data})
                return data
            except HTTPError as exc:
                if exc.code in {429, 502, 503, 504} and attempt < 2:
                    try:
                        delay = float(exc.headers.get("Retry-After", 2 ** (attempt + 1)))
                    except ValueError:
                        delay = 2 ** (attempt + 1)
                    time.sleep(min(30, max(1, delay)))
                    continue
                raise ToolError(f"Wiki HTTP {exc.code}: {exc.reason}") from exc
            except (URLError, TimeoutError, ValueError) as exc:
                raise ToolError(f"Wiki request failed: {exc}") from exc
        raise ToolError("Wiki request did not succeed after three attempts")

    @staticmethod
    def _check(data):
        if not isinstance(data, dict):
            raise ToolError("Wiki returned something other than a JSON object")
        if data.get("error"):
            raise ToolError(f"Wiki API error: {data['error']}")

    def page(self, title):
        data = self.request(action="parse", page=title, prop="text|revid", redirects=1)
        page = data.get("parse", {})
        if not isinstance(page.get("text"), str):
            raise ToolError(f"No rendered HTML returned for {title}")
        return page

    def resolve_title(self, title):
        # follows redirects (eg "Grace of the Elves" -> "Grace of the elves"), the bucket only
        # knows the real page name. returns the title unchanged when the page doesnt exist
        data = self.request(action="query", titles=title, redirects=1)
        pages = data.get("query", {}).get("pages", [])
        if isinstance(pages, list) and pages and isinstance(pages[0], dict):
            if not pages[0].get("missing") and isinstance(pages[0].get("title"), str):
                return pages[0]["title"]
        return title

    def item_rows(self, title):
        # item_id is a repeated field; id/name are not the bucket's field names.
        literal = json.dumps(title, ensure_ascii=False)
        query = (
            "bucket('infobox_item').select('page_name','item_name','item_id','version_anchor')"
            f".where('page_name',{literal}).orderBy('version_anchor','asc').limit(500).run()"
        )
        data = self.request(action="bucket", query=query)
        rows = data.get("bucket")
        if not isinstance(rows, list) or any(not isinstance(row, dict) for row in rows):
            raise ToolError(f"Unexpected infobox_item response for {title}")
        if len(rows) >= 500:
            raise ToolError(f"Too many item variants for {title}; refine the requested page")
        return rows


def network_arguments(parser, root):
    parser.add_argument("--cache", type=Path, default=root / "work/wiki-cache")
    parser.add_argument("--offline", action="store_true", help="Use cached API responses only")
    parser.add_argument("--refresh", action="store_true", help="Replace cached API responses")
