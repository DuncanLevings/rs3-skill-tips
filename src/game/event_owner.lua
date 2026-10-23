-- subscriptions belong to one running instance. queued callbacks from an old one do nothing.
local event_owner = {}

function event_owner.new(name)
    local owner = { alive = true, events = {} }

    function owner.subscribe(event, handler)
        owner.events[#owner.events + 1] = event
        event.Subscribe(name, function(payload)
            if not owner.alive then
                return
            end

            local ok, problem = pcall(function()
                handler(payload)
            end)
            if not ok then
                log("Skilling Coach: " .. name .. ": " .. tostring(problem))
            end
        end)
    end

    function owner.destroy()
        owner.alive = false
        for _, event in ipairs(owner.events) do
            event.Unsubscribe(name)
        end

        owner.events = {}
    end

    return owner
end

return event_owner
