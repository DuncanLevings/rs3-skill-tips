-- a group of event subscriptions that belong to one running instance of a module.
--
-- destroy() unsubscribes them all, and any callback the client had already queued for them
-- does nothing once the owner is gone. every handler also runs inside pcall, so an error in
-- one handler gets logged instead of breaking the event for everything else
--
-- usage:
--   local owner = event_owner.new("skilling_coach_example")
--   owner.subscribe(Event.Logic, function(event) ... end)
--   owner.destroy()

local event_owner = {}

-- name is the subscription reference, each event can only have one handler per name
function event_owner.new(name)
    local owner = { alive = true, events = {} }

    function owner.subscribe(event, handler)
        owner.events[#owner.events + 1] = event

        event.Subscribe(name, function(payload)
            if not owner.alive then
                return
            end

            local ok, problem = pcall(handler, payload)
            if not ok then
                log("Skill Tips: " .. name .. ": " .. tostring(problem))
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
