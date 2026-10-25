-- how close the player is to a quest tip's skill requirements.
--
-- requirements.skills must all be met. requirements.any_skills is an either/or list, eg
-- The World Wakes wants Magic 76 OR Ranged 76, so each option is compared on its own and the
-- closest one wins.
--
-- a tip with an aspiration can also show a little early, while the player is only a few
-- levels short. its limits say how short is close enough:
--   max_missing_skills  how many skills can still be below the requirement
--   max_level_gap       how far below any one skill can be
--   max_total_gap       how many levels short in total
--
-- assess() returns:
--   fully_met     every requirement is met
--   eligible      fully met, or close enough for the aspiration
--   missing       { skill, needed, current, alternative } for each unmet level, A to Z
--   total_gap     levels still needed in total
--   alternatives  the either/or skills that were compared, A to Z
--   unknown       a level couldnt be read yet, so nothing can be decided

local settings = require("src/storage/settings")

local quest_readiness = {}

-- a level that can be compared, or nil
local function valid_level(value)
    if type(value) == "number" and value == value and value >= 1 and value < math.huge then
        return value
    end

    return nil
end

-- compares the player against the required skills, plus one either/or option when there is
-- one. option is a skill name from any_skills, nil when the tip has none
local function compare(tip, level, option)
    local requirements = tip.requirements or {}
    local required = requirements.skills or {}
    local needs = {}

    for skill, needed in pairs(required) do
        needs[skill] = needed
    end

    if option then
        needs[option] = math.max(needs[option] or 0, requirements.any_skills[option])
    end

    local result = { eligible = false, fully_met = false, missing = {}, total_gap = 0 }
    local largest_gap = 0

    for skill, needed in pairs(needs) do
        local current = level(skill)

        if not current then
            result.unknown = true
            return result
        end

        if current < needed then
            local gap = needed - current
            result.missing[#result.missing + 1] = {
                skill = skill,
                needed = needed,
                current = current,
                -- the shortfall comes from the either/or option, not the required list
                alternative = option == skill and (required[skill] or 0) < needed,
            }
            result.total_gap = result.total_gap + gap
            largest_gap = math.max(largest_gap, gap)
        end
    end

    table.sort(result.missing, function(left, right)
        return left.skill < right.skill
    end)

    result.fully_met = #result.missing == 0

    local limits = tip.kind == "quest" and tip.aspiration
    local close_enough = type(limits) == "table"
        and #result.missing <= limits.max_missing_skills
        and largest_gap <= limits.max_level_gap
        and result.total_gap <= limits.max_total_gap

    result.eligible = result.fully_met or close_enough == true

    return result
end

-- is this option a better pick than the best so far: eligible beats not, then fewer levels
local function better(result, best)
    if not best then
        return true
    end

    if result.eligible ~= best.eligible then
        return result.eligible
    end

    return result.total_gap < best.total_gap
end

function quest_readiness.assess(tip, state)
    -- each level is only read from the client once per assessment
    local cached = {}
    local function level(skill)
        if cached[skill] == nil then
            cached[skill] = valid_level(state.level(skill)) or false
        end

        return cached[skill] or nil
    end

    local alternatives = (tip.requirements or {}).any_skills
    if not alternatives then
        return compare(tip, level)
    end

    -- a muted skill isnt one the player wants to train, so it isnt offered as an option
    local muted = settings.get("muted_skills")
    local options = {}

    for skill in pairs(alternatives) do
        if not muted[skill] and level(skill) then
            options[#options + 1] = skill
        end
    end

    table.sort(options)

    local best
    for _, option in ipairs(options) do
        local result = compare(tip, level, option)
        result.alternatives = options

        if not result.unknown and better(result, best) then
            best = result
        end
    end

    return best or { eligible = false, fully_met = false, missing = {}, unknown = true }
end

return quest_readiness
