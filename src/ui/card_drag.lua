-- drag the card from its body as well as its header, leaving footer controls uncovered.
--
-- grabbing the card mid slide jumps the slide to its end first (stopping it outright left
-- floating cards half see-through). while the card is closing, clicks do nothing at all,
-- otherwise grabbing it on its way out cancelled the slide and it never got removed

local card_motion = require("src/ui/card_motion")
local internals = require("src/ui/prettyui_internals")

local card_drag = {}

-- can_drag returns false once the card has started closing
function card_drag.attach(window, area, can_drag)
    local handle = ui.Layer.new(window.root)
    local pressed

    -- the right gutter stays free for the scrollbar, the bottom for the footer buttons
    handle:SetPos(8, 8)
    handle:SetSize(-30, -60, 1, 1)

    handle:Subscribe(ui.Hook.ONCLICK, "skilling_coach_drag", function(_, x, y)
        if not can_drag() then
            return false
        end

        if card_motion.is_sliding() then
            card_motion.finish()
        end

        pressed = { x = x, y = y }

        return false
    end)

    handle:Subscribe(ui.Hook.ONHOLD, "skilling_coach_drag", function(_, x, y)
        if not pressed or not can_drag() then
            return false
        end

        -- hook coords are local to the handle, which moves with the card, so add the leftover
        -- offset to where the card is now rather than where the drag started
        local max_left = area.width - window.root.width
        local max_top = area.height - window.root.height
        local left = math.max(0, math.min(max_left, window.root.x + x - pressed.x))
        local top = math.max(0, math.min(max_top, window.root.y + y - pressed.y))

        window.root:SetPos(left, top)

        return false
    end)

    handle:Subscribe(ui.Hook.ONRELEASE, "skilling_coach_drag", function()
        pressed = nil
        return false
    end)

    handle:Subscribe(ui.Hook.ONSCROLLWHEEL, "skilling_coach_drag", function(_, delta)
        internals.scroll_by(window, delta * 32)
        return false
    end)

    return handle
end

return card_drag
