-- game time in seconds, counted from logic ticks (50 a second). good enough for "how long ago
-- was that click" and doesnt depend on the os clock

local clock = {}

local SUBSCRIPTION = "skilling_coach_clock"
local TICKS_PER_SECOND = 50

local current_tick = 0

function clock.start()
    Event.Logic.Subscribe(SUBSCRIPTION, function(event)
        current_tick = event.logicTick or (current_tick + 1)
    end)
end

function clock.stop()
    Event.Logic.Unsubscribe(SUBSCRIPTION)
end

function clock.now()
    return current_tick / TICKS_PER_SECOND
end

return clock
