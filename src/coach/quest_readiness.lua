-- compare full skill requirements with nearby aspirations, including either/or paths.
local settings = require("src/storage/settings")
local quest_readiness = {}

function quest_readiness.assess(tip, state)
    local required = (tip.requirements or {}).skills or {}
    local alternatives = (tip.requirements or {}).any_skills
    local muted = settings.get("muted_skills")
    local cached = {}
    local function level(skill)
        if cached[skill] == nil then
            local value = state.level(skill)
            cached[skill] = type(value) == "number"
                    and value == value
                    and value >= 1
                    and value < math.huge
                    and value
                or false
        end
        return cached[skill] or nil
    end

    local function compare(branch)
        local needs = {}
        for skill, needed in pairs(required) do
            needs[skill] = needed
        end
        if branch then
            needs[branch] = math.max(needs[branch] or 0, alternatives[branch])
        end
        local result = { eligible = false, fully_met = false, missing = {}, total_gap = 0 }
        local max_gap = 0
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
                    alternative = branch == skill and (required[skill] or 0) < needed,
                }
                result.total_gap = result.total_gap + gap
                max_gap = math.max(max_gap, gap)
            end
        end
        table.sort(result.missing, function(left, right)
            return left.skill < right.skill
        end)
        result.fully_met = #result.missing == 0
        local policy = tip.kind == "quest" and tip.aspiration
        result.eligible = result.fully_met
            or (
                type(policy) == "table"
                and #result.missing <= policy.max_missing_skills
                and max_gap <= policy.max_level_gap
                and result.total_gap <= policy.max_total_gap
            )
        return result
    end

    if not alternatives then
        return compare()
    end
    local names = {}
    for skill in pairs(alternatives) do
        if not muted[skill] and level(skill) then
            names[#names + 1] = skill
        end
    end
    table.sort(names)
    local best
    for _, skill in ipairs(names) do
        local result = compare(skill)
        result.alternatives = names
        if not result.unknown then
            if
                not best
                or (result.eligible and not best.eligible)
                or (result.eligible == best.eligible and result.total_gap < best.total_gap)
            then
                best = result
            end
        end
    end
    return best or { eligible = false, fully_met = false, missing = {}, unknown = true }
end

return quest_readiness
