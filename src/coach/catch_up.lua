-- remembers the level each skill was at when its training first started this session.
--
-- a level_reached trigger normally needs a level up to cross it. catch-up lets the method tip
-- for the bracket the player started the session in show too, so someone who levelled while
-- the plugin was off still gets it. only real training sets the level, never reward xp

local catch_up = {}

function catch_up.new()
    local levels = {}

    return {
        -- the saved level for this skill, saving current_level first if theres none yet
        level = function(skill, current_level)
            levels[skill] = levels[skill] or current_level
            return levels[skill]
        end,
    }
end

return catch_up
