-- game time in seconds, counted from logic ticks (50 a second). good enough for "how long ago
-- was that click" and doesnt depend on the os clock

local clock = {}
local event_owner = require("src/game/event_owner")

local SUBSCRIPTION = "skilling_coach_clock"
local TICKS_PER_SECOND = 50

local current_tick = 0
local owner

function clock.start()
    if owner then
        return
    end

    owner = event_owner.new(SUBSCRIPTION)
    current_tick = 0
    owner.subscribe(Event.Logic, function(event)
        current_tick = event.logicTick or (current_tick + 1)
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
