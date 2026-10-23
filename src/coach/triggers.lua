-- does this signal fit one of the tip's triggers. whether the tip is useful or allowed by
-- settings is eligibility's job, not this file's

local triggers = {}

-- a level_reached trigger during training: either a level up crossed it (possibly from a
-- lamp earlier, saved as pending), or catch-up says this session started in its bracket
local function level_trigger_matches(tip, trigger, context)
    local pending = context.pending

    if
        pending
        and pending.old < trigger.level
        and pending.new >= trigger.level
        and context.level ~= nil
        and context.level >= trigger.level
    then
        return true
    end

    -- catch-up only offers methods in the bracket the player was in when this session's
    -- training started
    local level = context.catch_up_level

    return tip.kind == "method"
        and tip.level_range ~= nil
        and level ~= nil
        and level >= tip.level_range[1]
        and level <= tip.level_range[2]
end

local function trigger_matches(tip, trigger, context)
    if trigger.type == "requirements_met" then
        return context.kind == "quest_ready" and tip.kind == "quest"
    end

    if trigger.skill ~= context.skill and trigger.skill ~= "ANY" then
        return false
    end

    if trigger.type == context.kind then
        return true
    end

    return context.kind == "training"
        and trigger.type == "level_reached"
        and level_trigger_matches(tip, trigger, context)
end

-- true when any of the tip's triggers fits. every trigger gets checked, one that doesnt fit
-- no longer stops the ones after it from being looked at
function triggers.matches(tip, context)
    for _, trigger in ipairs(tip.triggers) do
        if trigger_matches(tip, trigger, context) then
            return true
        end
    end

    return false
end

return triggers
