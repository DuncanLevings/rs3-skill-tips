-- game time in seconds, counted from logic ticks (50 a second). good enough for "how long ago
-- was that click" and doesnt depend on the os clock

local clock = {}
local event_owner = require("src/game/event_owner")

local SUBSCRIPTION = "skilling_coach_clock"
local TICKS_PER_SECOND = 50

local current_tick = 0
local previous_client_tick
local owner

function clock.start()
    if owner then
        return
    end

    owner = event_owner.new(SUBSCRIPTION)
    current_tick = 0
    previous_client_tick = nil
    owner.subscribe(Event.Logic, function(event)
        local tick = event.logicTick
        if type(tick) == "number" then
            -- client ticks include all time before plugin load; only count subsequent deltas.
            if previous_client_tick then
                current_tick = current_tick + math.max(0, tick - previous_client_tick)
            end
            previous_client_tick = tick
        else
            current_tick = current_tick + 1
        end
    end)
end

function clock.stop()
    if owner then
        owner.destroy()
        owner = nil
    end
end

function clock.now()
    return current_tick / TICKS_PER_SECOND
end

return clock
