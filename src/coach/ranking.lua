-- favour the skill being trained, then author priority, then the nearest level target.
local ranking = {}

local function specific(tip, skill)
    for _, name in ipairs(tip.skills) do
        if name == skill then
            return true
        end
    end
    return false
end

local function distance(tip, skill, level)
    local target = tip.level_range and tip.level_range[1]
        or ((tip.requirements or {}).skills or {})[skill]
    return target and level and math.abs(target - level) or math.huge
end

function ranking.best(candidates, skill, level)
    table.sort(candidates, function(left, right)
        local left_specific, right_specific = specific(left, skill), specific(right, skill)
        if left_specific ~= right_specific then
            return left_specific
        end
        if left.priority ~= right.priority then
            return left.priority < right.priority
        end
        local left_distance, right_distance =
            distance(left, skill, level), distance(right, skill, level)
        if left_distance ~= right_distance then
            return left_distance < right_distance
        end
        return left.id < right.id
    end)
    return candidates[1]
end

return ranking
