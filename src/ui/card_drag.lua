-- drag the card from its body as well as its header, leaving footer controls uncovered.
local card_motion = require("src/ui/card_motion")
local card_drag = {}

function card_drag.attach(window, area)
    local handle = ui.Layer.new(window.root)
    local pressed
    local function layout()
        handle:SetPos(8, 8)
        -- The right gutter stays available for the scrollbar; the bottom is for actions.
        handle:SetSize(-30, -60, 1, 1)
    end
    layout()

    handle:Subscribe(ui.Hook.ONCLICK, "skilling_coach_drag", function(_, x, y)
        card_motion.stop()
        pressed = { x = x, y = y }
        return false
    end)
    handle:Subscribe(ui.Hook.ONHOLD, "skilling_coach_drag", function(_, x, y)
        if pressed then
            -- Hook coordinates are local to the moving handle, so apply the remaining
            -- cursor offset to the current position, rather than to the starting position.
            local left =
                math.max(0, math.min(area.width - window.root.width, window.root.x + x - pressed.x))
            local top = math.max(
                0,
                math.min(area.height - window.root.height, window.root.y + y - pressed.y)
            )
            window.root:SetPos(left, top)
        end
        return false
    end)
    handle:Subscribe(ui.Hook.ONRELEASE, "skilling_coach_drag", function()
        pressed = nil
        return false
    end)
    handle:Subscribe(ui.Hook.ONSCROLLWHEEL, "skilling_coach_drag", function(_, delta)
        window:ScrollBy(delta * 32)
        return false
    end)
    return handle
end

return card_drag
