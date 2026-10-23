-- remember the first real training level per skill; raw reward XP never starts catch-up.
local catch_up = {}

function catch_up.new()
    local levels = {}
    return {
        level = function(skill, current_level)
            levels[skill] = levels[skill] or current_level
            return levels[skill]
        end,
    }
end

return catch_up
