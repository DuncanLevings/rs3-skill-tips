-- optional shortcut that opens and closes the pinned tips window. unbound by default,
-- PrettyUI's keybind field handles picking the keys and ignores presses while typing

local settings = require("src/storage/settings")
local event_owner = require("src/game/event_owner")

local keybind = {}

local owner

-- toggle runs once per key press, not on every tick the keys are held
function keybind.start(toggle)
    keybind.stop()
    owner = event_owner.new("skilling_coach_keybind")

    local was_down = false
    owner.subscribe(Event.Logic, function()
        local binding = settings.get("pinned_keybind")
        local down = prettyui.KeybindField.IsDown(binding)
        local pressed = down and not was_down

        -- count the press before opening, so a ui error cant make it fire again every held tick
        was_down = down

        if pressed and Player.IsAvailable() then
            toggle()
        end
    end)
end

function keybind.stop()
    if owner then
        owner.destroy()
        owner = nil
    end
end

return keybind
