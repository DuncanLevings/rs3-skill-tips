-- checks a tip has the right shape before the coach uses it. returns a list of problems
-- instead of throwing, the catalogue logs those and skips the tip so one typo in a tip file
-- cant break the whole plugin.
--
-- tip fields, in the order tip files list them (tools/format_tips.py keeps that order):
--
--   id                  unique, "skill.thing" for items, "skill.method.x" / "skill.alt.x" for
--                       methods and alternatives, "quest.x" for quests
--   kind                convenience (items), method, general (quality of life) or quest
--   quest               quest tips only: the quest's config name
--   skills              skill names the tip is for, or { "ANY" }
--   members             true when the tip needs membership
--   level_range         methods only: { first level, last level } of the bracket
--   main_method         methods only: true for the bracket's main method, absent for alternatives
--   min_training_level  the tip isnt worth mentioning below this level in the trained skill
--   title               the card heading
--   icon_item           item config name for the card icon, or icon_item_id with a numeric id
--   hook                the first line: what the tip is about
--   aspiration_hook     quest tips with an aspiration: hook to use while still a few levels short
--   why                 why its worth knowing
--   how                 list of steps, how to get or start it
--   quest_how           steps shown instead of how while a required quest isnt done yet
--   requirements        { skills = { SKILL = level }, any_skills = { either/or levels, quest tips
--                       only }, quests = { quest config names } }
--   require_all_levels  every skill level in requirements must be met before it shows
--   require_quests_complete  every quest in requirements must be done before it shows
--   aspiration          quest tips only: { max_missing_skills, max_level_gap, max_total_gap },
--                       how close counts as close enough to show early (see quest_readiness)
--   triggers            list of signals the tip shows on,
--                       eg { type = "training", skill = "MINING" }
--   known_when          list of conditions meaning the player already knows it (see conditions)
--   priority            1 shows first. quests and standout items 1, most items and main methods 2,
--                       alternatives and minor quality of life 3

local skills = require("src/data/skills")
local conditions = require("src/coach/conditions")

local schema = {}

local KINDS = { convenience = true, method = true, general = true, quest = true }

local TRIGGER_TYPES = {
    training = true,
    level_reached = true,
    backpack_full = true,
    requirements_met = true,
}

-- the most each aspiration limit can sensibly be (29 skills, levels up to 120)
local ASPIRATION_LIMITS = {
    max_missing_skills = 29,
    max_level_gap = 120,
    max_total_gap = 3480,
}

-- tips are pure data, a function anywhere in one means logic leaked into a tip file
local function contains_function(value, depth)
    if type(value) == "function" then
        return true
    end

    if type(value) ~= "table" or depth > 6 then
        return false
    end

    for _, child in pairs(value) do
        if contains_function(child, depth + 1) then
            return true
        end
    end

    return false
end

local function is_text(value)
    return type(value) == "string" and value ~= ""
end

local function is_level(value)
    return math.type(value) == "integer" and value >= 1 and value <= 120
end

local function is_optional_boolean(value)
    return value == nil or type(value) == "boolean"
end

local function quest_requirements(tip)
    return type(tip.requirements) == "table" and tip.requirements.quests
end

local function check_how(tip, problems)
    if type(tip.how) ~= "table" or #tip.how == 0 then
        problems[#problems + 1] = "how must list at least one step"
        return
    end

    for index, step in ipairs(tip.how) do
        if not is_text(step) then
            problems[#problems + 1] = "how step " .. index .. " must be some text"
        end
    end
end

local function check_quest_how(tip, problems)
    if type(tip.quest_how) ~= "table" or #tip.quest_how == 0 then
        problems[#problems + 1] = "quest_how must list discovery steps"
    else
        for _, step in ipairs(tip.quest_how) do
            if not is_text(step) then
                problems[#problems + 1] = "quest_how steps must be text"
            end
        end
    end

    local quests = quest_requirements(tip)
    if type(quests) ~= "table" or #quests == 0 then
        problems[#problems + 1] = "quest_how needs quest requirements"
    end
end

local function check_basics(tip, problems)
    if not KINDS[tip.kind] then
        problems[#problems + 1] = "kind must be convenience, method, general or quest"
    end

    if type(tip.members) ~= "boolean" then
        problems[#problems + 1] = "members must be true or false"
    end

    if math.type(tip.priority) ~= "integer" or tip.priority < 1 then
        problems[#problems + 1] = "priority must be a whole number from 1"
    end

    if type(tip.skills) ~= "table" or #tip.skills == 0 then
        problems[#problems + 1] = "skills must list at least one skill"
    else
        for _, name in ipairs(tip.skills) do
            if name ~= "ANY" and not skills.is_skill(name) then
                problems[#problems + 1] = "unknown skill " .. tostring(name)
            end
        end
    end
end

local function check_card_text(tip, problems)
    for _, field in ipairs({ "id", "title", "hook", "why" }) do
        if not is_text(tip[field]) then
            problems[#problems + 1] = field .. " must be some text"
        end
    end

    check_how(tip, problems)

    if tip.quest_how ~= nil then
        check_quest_how(tip, problems)
    end

    if tip.icon_item ~= nil and not is_text(tip.icon_item) then
        problems[#problems + 1] = "icon_item must be an item config name"
    end

    if tip.icon_item_id ~= nil then
        if math.type(tip.icon_item_id) ~= "integer" or tip.icon_item_id <= 0 then
            problems[#problems + 1] = "icon_item_id must be a positive item id"
        end

        if tip.icon_item ~= nil then
            problems[#problems + 1] = "choose icon_item or icon_item_id, not both"
        end
    end
end

local function check_level_fields(tip, problems)
    local range = tip.level_range

    if range ~= nil then
        if type(range) ~= "table" or not is_level(range[1]) or not is_level(range[2]) then
            problems[#problems + 1] = "level_range must be { min, max } levels"
        elseif range[1] > range[2] then
            problems[#problems + 1] = "level_range min is above max"
        end
    end

    if tip.main_method ~= nil and (type(tip.main_method) ~= "boolean" or tip.kind ~= "method") then
        problems[#problems + 1] = "main_method must be a boolean on a method tip"
    end

    if tip.min_training_level ~= nil and not is_level(tip.min_training_level) then
        problems[#problems + 1] = "min_training_level must be a level from 1 to 120"
    end
end

local function check_requirements(tip, problems)
    local requirements = tip.requirements

    if requirements == nil then
        return
    end

    if type(requirements) ~= "table" then
        problems[#problems + 1] = "requirements must be a table"
        return
    end

    if requirements.skills ~= nil and type(requirements.skills) ~= "table" then
        problems[#problems + 1] = "skill requirements must be a table"
        return
    end

    if requirements.quests ~= nil and type(requirements.quests) ~= "table" then
        problems[#problems + 1] = "quest requirements must be a list"
        return
    end

    for name, level in pairs(requirements.skills or {}) do
        if not skills.is_skill(name) or not is_level(level) then
            problems[#problems + 1] = "bad skill requirement " .. tostring(name)
        end
    end

    if requirements.any_skills ~= nil then
        local alternatives = requirements.any_skills

        if tip.kind ~= "quest" or type(alternatives) ~= "table" or next(alternatives) == nil then
            problems[#problems + 1] = "any_skills needs alternatives on a quest tip"
        else
            for name, level in pairs(alternatives) do
                if not skills.is_skill(name) or not is_level(level) then
                    problems[#problems + 1] = "bad alternative skill requirement " .. tostring(name)
                end
            end
        end
    end

    for _, quest in ipairs(requirements.quests or {}) do
        if not is_text(quest) then
            problems[#problems + 1] = "quest requirements must be quest config names"
        end
    end
end

local function check_gates(tip, problems)
    if not is_optional_boolean(tip.require_all_levels) then
        problems[#problems + 1] = "require_all_levels must be true or false"
    end

    if not is_optional_boolean(tip.require_quests_complete) then
        problems[#problems + 1] = "require_quests_complete must be true or false"
    elseif tip.require_quests_complete then
        local quests = quest_requirements(tip)
        if type(quests) ~= "table" or #quests == 0 then
            problems[#problems + 1] = "require_quests_complete needs quest requirements"
        end
    end
end

local function check_aspiration(tip, problems)
    if tip.aspiration == nil then
        if tip.aspiration_hook ~= nil then
            problems[#problems + 1] = "aspiration_hook needs aspiration limits"
        end

        return
    end

    local limits = tip.aspiration
    if tip.kind ~= "quest" or type(limits) ~= "table" then
        problems[#problems + 1] = "aspiration needs limits on a quest tip"
    else
        for field, maximum in pairs(ASPIRATION_LIMITS) do
            local value = limits[field]
            if math.type(value) ~= "integer" or value < 1 or value > maximum then
                problems[#problems + 1] = "invalid aspiration limit " .. field
            end
        end
    end

    if not is_text(tip.aspiration_hook) then
        problems[#problems + 1] = "aspiration needs an aspiration_hook"
    end
end

-- quest tips have no bracket, need the quest name, some skill levels and a requirements_met
-- trigger (thats what puts them in the quiet pause queue)
local function check_quest_tip(tip, problems)
    if tip.level_range then
        problems[#problems + 1] = "quest tips do not use method brackets"
    end

    if not is_text(tip.quest) then
        problems[#problems + 1] = "quest tips need a quest config name"
    end

    local requirements = type(tip.requirements) == "table" and tip.requirements or {}
    local required = requirements.skills or {}
    local alternatives = requirements.any_skills
    local has_alternatives = type(alternatives) == "table" and next(alternatives) ~= nil

    if type(required) ~= "table" or (next(required) == nil and not has_alternatives) then
        problems[#problems + 1] = "quest tips need all skill requirements"
    end

    local has_readiness_trigger = false
    for _, trigger in ipairs(type(tip.triggers) == "table" and tip.triggers or {}) do
        if type(trigger) == "table" and trigger.type == "requirements_met" then
            has_readiness_trigger = true
        end
    end

    if not has_readiness_trigger then
        problems[#problems + 1] = "quest tips need a requirements_met trigger"
    end
end

local function check_triggers(tip, problems)
    if type(tip.triggers) ~= "table" or #tip.triggers == 0 then
        problems[#problems + 1] = "triggers must list at least one trigger"
        return
    end

    for index, trigger in ipairs(tip.triggers) do
        local label = "trigger " .. index

        if type(trigger) ~= "table" or not TRIGGER_TYPES[trigger.type] then
            problems[#problems + 1] = label .. " has an unknown type"
        elseif trigger.skill ~= "ANY" and not skills.is_skill(trigger.skill) then
            problems[#problems + 1] = label .. " needs a skill"
        elseif trigger.type == "level_reached" and not is_level(trigger.level) then
            problems[#problems + 1] = label .. " needs a level"
        end
    end
end

local function check_known_when(tip, problems)
    if tip.known_when == nil then
        return
    end

    if type(tip.known_when) ~= "table" then
        problems[#problems + 1] = "known_when must be a list of conditions"
        return
    end

    for index, condition in ipairs(tip.known_when) do
        if not conditions.is_valid(condition) then
            problems[#problems + 1] = "known_when condition " .. index .. " is not valid"
        end
    end
end

-- list of problems, empty when the tip is fine
---@return string[]
function schema.problems(tip)
    if type(tip) ~= "table" then
        return { "tip must be a table" }
    end

    local problems = {}

    if contains_function(tip, 0) then
        problems[#problems + 1] = "tips are data only, no functions"
    end

    check_basics(tip, problems)

    if tip.kind == "quest" then
        check_quest_tip(tip, problems)
    end

    check_card_text(tip, problems)
    check_level_fields(tip, problems)
    check_requirements(tip, problems)
    check_gates(tip, problems)
    check_aspiration(tip, problems)
    check_triggers(tip, problems)
    check_known_when(tip, problems)

    return problems
end

return schema
