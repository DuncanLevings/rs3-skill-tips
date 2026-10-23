-- one place for settings, progress and account knowledge to filter candidates.
local conditions = require("src/coach/conditions")
local settings = require("src/storage/settings")
local progress = require("src/storage/tip_progress")
local owned_items = require("src/storage/owned_items")
local eligibility = {}

local KIND_SETTINGS =
    { convenience = "show_convenience", method = "show_methods", general = "show_general" }
local STAGE_SETTINGS = { early = "show_early", mid = "show_mid", late = "show_late" }

function eligibility.stage(tip)
    local level = tip.level_range and tip.level_range[1] or 1
    if not tip.level_range then
        for _, required in pairs((tip.requirements or {}).skills or {}) do
            level = math.max(level, required)
        end
    end
    return level < 30 and "early" or (level < 70 and "mid" or "late")
end

function eligibility.allows(tip, skill, state)
    if
        not settings.get("tips_enabled")
        or settings.get("muted_skills")[skill]
        or not settings.get(KIND_SETTINGS[tip.kind])
        or not settings.get(STAGE_SETTINGS[eligibility.stage(tip)])
        or (tip.members and not settings.get("show_members"))
    then
        return false
    end
    if
        progress.is_dismissed(tip.id)
        or progress.is_pinned(tip.id)
        or progress.was_shown(tip.id)
    then
        return false
    end
    if tip.kind == "method" and tip.level_range then
        local level = state.level(skill)
        if not level or level < tip.level_range[1] or level > tip.level_range[2] then
            return false
        end
    end
    if conditions.needs_bank(tip.known_when) and not owned_items.bank_seen() then
        return false
    end
    return not conditions.any(tip.known_when, state)
end

return eligibility
