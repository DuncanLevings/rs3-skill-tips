-- decides whether a tip is allowed to show right now. triggers say "this tip fits the
-- signal", eligibility then checks everything else: the player's settings, what happened to
-- the tip before (pinned, dismissed, already known), and whether its useful for this player
-- at their current levels.
--
-- allows() runs the checks below in order and stops at the first one that says no

local conditions = require("src/coach/conditions")
local quest_readiness = require("src/coach/quest_readiness")
local settings = require("src/storage/settings")
local progress = require("src/storage/tip_progress")
local owned_items = require("src/storage/owned_items")

local eligibility = {}

-- which setting turns each kind of tip on or off
local KIND_SETTINGS = {
    convenience = "show_convenience",
    method = "show_methods",
    general = "show_general",
    quest = "show_quests",
}

local STAGE_SETTINGS = { early = "show_early", mid = "show_mid", late = "show_late" }

-- early (below 30), mid (30 to 69) or late (70+) game, for the progression settings. uses the
-- bracket start for methods, otherwise the highest level the tip asks for
function eligibility.stage(tip)
    local level = tip.level_range and tip.level_range[1] or 1
    local requirements = tip.requirements or {}

    if not tip.level_range then
        for _, required in pairs(requirements.skills or {}) do
            level = math.max(level, required)
        end

        for _, required in pairs(requirements.any_skills or {}) do
            level = math.max(level, required)
        end
    end

    level = math.max(level, tip.min_training_level or 1)

    if level < 30 then
        return "early"
    end

    return level < 70 and "mid" or "late"
end

-- a quest tip is ready once the quest isnt done and the levels are there (or close enough,
-- for tips with an aspiration). nil from quest_done means "cant tell yet", which waits
function eligibility.quest_ready(tip, state)
    if state.quest_done(tip.quest) ~= false then
        return false
    end

    return quest_readiness.assess(tip, state).eligible
end

local function allowed_by_settings(tip, skill)
    return settings.get("tips_enabled")
        and not settings.get("muted_skills")[skill]
        and settings.get(KIND_SETTINGS[tip.kind])
        and settings.get(STAGE_SETTINGS[eligibility.stage(tip)])
        and (not tip.members or settings.get("show_members"))
end

-- known from owning the item, dismissed, paused with Later, pinned, or already shown this
-- session
local function already_handled(tip)
    return progress.is_known(tip.id)
        or progress.is_dismissed(tip.id)
        or progress.is_snoozed(tip.id)
        or progress.is_pinned(tip.id)
        or progress.was_shown(tip.id)
end

local function quest_allowed(tip, state)
    local muted = settings.get("muted_skills")

    for required_skill in pairs(tip.requirements.skills) do
        if muted[required_skill] then
            return false
        end
    end

    return eligibility.quest_ready(tip, state)
end

-- a method that needs a quest the player hasnt done yet points them at that quest, so its
-- worth showing even for a bracket they were already in
local function points_to_unfinished_quest(tip, state)
    if not tip.quest_how then
        return false
    end

    for _, quest in ipairs((tip.requirements or {}).quests or {}) do
        if state.quest_done(quest) == false then
            return true
        end
    end

    return false
end

local function method_allowed(tip, skill, state)
    -- main methods start from where the player was when they first used the plugin: brackets
    -- they had already reached by then are skipped, they know those. alternatives always count
    local starting = progress.starting_level(skill)
    if
        tip.main_method
        and starting
        and tip.level_range[1] <= starting
        and not points_to_unfinished_quest(tip, state)
    then
        return false
    end

    local level = state.level(skill)
    return level ~= nil and level >= tip.level_range[1] and level <= tip.level_range[2]
end

local function quests_complete(tip, state)
    for _, quest in ipairs((tip.requirements or {}).quests or {}) do
        if state.quest_done(quest) ~= true then
            return false
        end
    end

    return true
end

-- every listed skill level is met, used by tips like diary rewards that need the whole set
local function all_levels_met(tip, state)
    for required_skill, needed in pairs((tip.requirements or {}).skills or {}) do
        local level = state.level(required_skill)
        if not level or level < needed then
            return false
        end
    end

    return true
end

-- item and qol tips wait until the player has the level they need in the skill theyre
-- training ("99 Mining! the mining cape" at level 15 would be silly). needs in other skills
-- still show on the card as next steps, eg the golem outfit's Invention 20
local function trained_skill_level_met(tip, skill, state)
    local needed = ((tip.requirements or {}).skills or {})[skill]
    if not needed then
        return true
    end

    local level = state.level(skill)
    return level ~= nil and level >= needed
end

-- skill is the skill being trained, nil for quest tips shown in a quiet pause
function eligibility.allows(tip, skill, state)
    if not allowed_by_settings(tip, skill) or already_handled(tip) then
        return false
    end

    if tip.kind == "quest" and not quest_allowed(tip, state) then
        return false
    end

    if tip.kind == "method" and tip.level_range and not method_allowed(tip, skill, state) then
        return false
    end

    -- most tips can point the player towards a quest they still need, these ones only make
    -- sense once its done
    if tip.require_quests_complete and not quests_complete(tip, state) then
        return false
    end

    -- the level where a tip starts being worth mentioning, separate from what it requires
    if tip.min_training_level then
        local level = skill and state.level(skill)
        if not level or level < tip.min_training_level then
            return false
        end
    end

    if tip.require_all_levels and tip.kind ~= "quest" and not all_levels_met(tip, state) then
        return false
    end

    local item_or_qol = tip.kind == "convenience" or tip.kind == "general"
    if skill and item_or_qol and not trained_skill_level_met(tip, skill, state) then
        return false
    end

    -- "does the player own this" is unanswerable until the bank has been seen once
    if conditions.needs_bank(tip.known_when) and not owned_items.bank_seen() then
        return false
    end

    -- the player probably knows it already (owns the item, finished the quest...)
    return not conditions.any(tip.known_when, state)
end

return eligibility
