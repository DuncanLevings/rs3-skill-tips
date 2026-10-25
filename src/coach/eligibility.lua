-- one place for settings, progress and account knowledge to filter candidates.
local conditions = require("src/coach/conditions")
local settings = require("src/storage/settings")
local progress = require("src/storage/tip_progress")
local owned_items = require("src/storage/owned_items")
local quest_readiness = require("src/coach/quest_readiness")
local eligibility = {}

local KIND_SETTINGS = {
    convenience = "show_convenience",
    method = "show_methods",
    general = "show_general",
    quest = "show_quests",
}
local STAGE_SETTINGS = { early = "show_early", mid = "show_mid", late = "show_late" }

function eligibility.stage(tip)
    local level = tip.level_range and tip.level_range[1] or 1
    if not tip.level_range then
        for _, required in pairs((tip.requirements or {}).skills or {}) do
            level = math.max(level, required)
        end
        for _, required in pairs((tip.requirements or {}).any_skills or {}) do
            level = math.max(level, required)
        end
    end

    level = math.max(level, tip.min_training_level or 1)

    return level < 30 and "early" or (level < 70 and "mid" or "late")
end

function eligibility.quest_ready(tip, state)
    if state.quest_done(tip.quest) ~= false then
        return false
    end

    return quest_readiness.assess(tip, state).eligible
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
        progress.is_known(tip.id)
        or progress.is_dismissed(tip.id)
        or progress.is_pinned(tip.id)
        or progress.was_shown(tip.id)
    then
        return false
    end

    if tip.kind == "quest" then
        local muted = settings.get("muted_skills")
        for required_skill in pairs(tip.requirements.skills) do
            if muted[required_skill] then
                return false
            end
        end

        if not eligibility.quest_ready(tip, state) then
            return false
        end
    end

    if tip.kind == "method" and tip.level_range then
        -- join at the player's current progress, not with advice for a bracket already unlocked.
        -- starter brackets count too; alternatives are never filtered here.
        local starting = progress.starting_level(skill)
        local quest_discovery = false
        if tip.quest_how then
            for _, quest in ipairs((tip.requirements or {}).quests or {}) do
                if state.quest_done(quest) == false then
                    quest_discovery = true
                end
            end
        end
        -- a known unfinished quest makes this a new opportunity, even in an old bracket.
        if
            tip.main_method
            and starting
            and tip.level_range[1] <= starting
            and not quest_discovery
        then
            return false
        end

        local level = state.level(skill)
        if not level or level < tip.level_range[1] or level > tip.level_range[2] then
            return false
        end
    end

    -- source access is opt-in: methods can still point toward an unfinished quest.
    if tip.require_quests_complete then
        for _, quest in ipairs((tip.requirements or {}).quests or {}) do
            if state.quest_done(quest) ~= true then
                return false
            end
        end
    end

    -- relevance thresholds are separate from actual unlock requirements.
    if tip.min_training_level then
        local level = skill and state.level(skill)
        if not level or level < tip.min_training_level then
            return false
        end
    end

    -- diary rewards need the whole skill set, not just the skill being trained.
    if tip.require_all_levels and tip.kind ~= "quest" then
        for required_skill, needed in pairs((tip.requirements or {}).skills or {}) do
            local level = state.level(required_skill)
            if not level or level < needed then
                return false
            end
        end
    end

    -- item and qol tips wait until the player has the level they need in the skill theyre
    -- training ("99 Mining! the mining cape" at level 15 would be silly). needs in other skills
    -- still show on the card as next steps, eg the golem outfit's Invention 20
    if skill and (tip.kind == "convenience" or tip.kind == "general") then
        local needed = ((tip.requirements or {}).skills or {})[skill]
        local level = needed and state.level(skill)

        if needed and (not level or level < needed) then
            return false
        end
    end

    if conditions.needs_bank(tip.known_when) and not owned_items.bank_seen() then
        return false
    end

    return not conditions.any(tip.known_when, state)
end

return eligibility
