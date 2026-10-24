-- checks a tip has the right shape before the coach uses it. returns a list of problems
-- instead of throwing, the catalogue logs those and skips the tip so one typo in a tip file
-- cant break the whole plugin.
--
-- the fields are explained in docs/implementation-plan.md (3.2 tip schema)

local skills = require("src/data/skills")
local conditions = require("src/coach/conditions")

local schema = {}

local KINDS = { convenience = true, method = true, general = true, quest = true }
local TRIGGER_TYPES =
    { training = true, level_reached = true, backpack_full = true, requirements_met = true }

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

local function check_text_fields(tip, problems)
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

    for _, field in ipairs({ "id", "title", "hook", "why" }) do
        if not is_text(tip[field]) then
            problems[#problems + 1] = field .. " must be some text"
        end
    end

    if type(tip.how) ~= "table" or #tip.how == 0 then
        problems[#problems + 1] = "how must list at least one step"
    else
        for index, step in ipairs(tip.how) do
            if not is_text(step) then
                problems[#problems + 1] = "how step " .. index .. " must be some text"
            end
        end
    end
end

local function check_skills(tip, problems)
    if type(tip.skills) ~= "table" or #tip.skills == 0 then
        problems[#problems + 1] = "skills must list at least one skill"
        return
    end

    for _, name in ipairs(tip.skills) do
        if name ~= "ANY" and not skills.is_skill(name) then
            problems[#problems + 1] = "unknown skill " .. tostring(name)
        end
    end
end

local function check_level_range(tip, problems)
    local range = tip.level_range

    if range == nil then
        return
    end

    if type(range) ~= "table" or not is_level(range[1]) or not is_level(range[2]) then
        problems[#problems + 1] = "level_range must be { min, max } levels"
    elseif range[1] > range[2] then
        problems[#problems + 1] = "level_range min is above max"
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

    for _, quest in ipairs(requirements.quests or {}) do
        if not is_text(quest) then
            problems[#problems + 1] = "quest requirements must be quest config names"
        end
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

    if not KINDS[tip.kind] then
        problems[#problems + 1] = "kind must be convenience, method, general or quest"
    end

    if type(tip.members) ~= "boolean" then
        problems[#problems + 1] = "members must be true or false"
    end

    if math.type(tip.priority) ~= "integer" or tip.priority < 1 then
        problems[#problems + 1] = "priority must be a whole number from 1"
    end

    if tip.kind == "quest" then
        if tip.level_range then
            problems[#problems + 1] = "quest tips do not use method brackets"
        end

        if not is_text(tip.quest) then
            problems[#problems + 1] = "quest tips need a quest config name"
        end

        local required = (type(tip.requirements) == "table" and tip.requirements.skills) or {}
        if type(required) ~= "table" or next(required) == nil then
            problems[#problems + 1] = "quest tips need all skill requirements"
        end

        local readiness = false
        for _, trigger in ipairs(type(tip.triggers) == "table" and tip.triggers or {}) do
            if type(trigger) == "table" and trigger.type == "requirements_met" then
                readiness = true
            end
        end

        if not readiness then
            problems[#problems + 1] = "quest tips need a requirements_met trigger"
        end
    end

    if tip.min_training_level ~= nil and not is_level(tip.min_training_level) then
        problems[#problems + 1] = "min_training_level must be a level from 1 to 120"
    end

    if tip.require_all_levels ~= nil and type(tip.require_all_levels) ~= "boolean" then
        problems[#problems + 1] = "require_all_levels must be true or false"
    end

    if tip.require_quests_complete ~= nil and type(tip.require_quests_complete) ~= "boolean" then
        problems[#problems + 1] = "require_quests_complete must be true or false"
    elseif tip.require_quests_complete then
        local quests = type(tip.requirements) == "table" and tip.requirements.quests
        if type(quests) ~= "table" or #quests == 0 then
            problems[#problems + 1] = "require_quests_complete needs quest requirements"
        end
    end

    check_text_fields(tip, problems)
    check_skills(tip, problems)
    check_level_range(tip, problems)
    check_requirements(tip, problems)
    check_triggers(tip, problems)
    check_known_when(tip, problems)

    return problems
end

return schema
