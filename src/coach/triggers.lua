-- trigger matching stays separate from whether a tip is useful or allowed by settings.
local triggers = {}

function triggers.matches(tip, context)
    for _, trigger in ipairs(tip.triggers) do
        if trigger.skill == context.skill or trigger.skill == "ANY" then
            if trigger.type == context.kind then
                return true
            elseif context.kind == "training" and trigger.type == "level_reached" then
                local pending = context.pending
                if pending and pending.old < trigger.level and pending.new >= trigger.level then
                    return context.level ~= nil and context.level >= trigger.level
                end
                -- Catch-up only offers methods in the bracket where this session started.
                if tip.kind == "method" and tip.level_range and context.catch_up_level then
                    local level = context.catch_up_level
                    if level >= tip.level_range[1] and level <= tip.level_range[2] then
                        return true
                    end
                end
            end
        end
    end
    return false
end

return triggers
