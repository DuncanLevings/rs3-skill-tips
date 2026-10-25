-- picks the best of several eligible tips. in order of importance:
--   1. tips written for the skill being trained, before ones shared with other skills
--   2. lower priority number first. tips use 1 for quests and standout items, 2 for most items
--      and main methods, 3 for alternative methods and minor quality of life
--   3. the tip whose level target is closest to the player's level
--   4. tip id, so ties always come out the same way

local ranking = {}

local function written_for(tip, skill)
    for _, name in ipairs(tip.skills) do
        if name == skill then
            return true
        end
    end

    return false
end

-- how far the player's level is from the tip's bracket start (or its level requirement)
local function level_distance(tip, skill, level)
    local target = tip.level_range and tip.level_range[1]
        or ((tip.requirements or {}).skills or {})[skill]

    return target and level and math.abs(target - level) or math.huge
end

-- sorts candidates in place and returns the best one, nil for an empty list
function ranking.best(candidates, skill, level)
    table.sort(candidates, function(left, right)
        local left_written, right_written = written_for(left, skill), written_for(right, skill)
        if left_written ~= right_written then
            return left_written
        end

        if left.priority ~= right.priority then
            return left.priority < right.priority
        end

        local left_distance = level_distance(left, skill, level)
        local right_distance = level_distance(right, skill, level)
        if left_distance ~= right_distance then
            return left_distance < right_distance
        end

        return left.id < right.id
    end)

    return candidates[1]
end

return ranking
