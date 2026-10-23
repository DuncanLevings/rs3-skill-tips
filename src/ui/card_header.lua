-- card-style header over PrettyUI's existing drag handle. no title plaque or boxed pin.
local theme = require("src/ui/theme")
local card_drag = require("src/ui/card_drag")

local card_header = {}
local PADDING = 12
local ICON_SIZE = 28
local GAP = 8
local PIN_SIZE = 24

function card_header.attach(window, tip, on_pin, area)
    for _, name in ipairs({
        "titleLeft",
        "titleRight",
        "titleCentre",
        "titleCentreLeft",
        "titleCentreRight",
        "titleText",
        "closeButton",
    }) do
        if window[name] then
            window[name].hidden = true
        end
    end

    window.titleDrag.hidden = true

    -- Restore the native plain frame and background where the title plaque used to be.
    local top = ui.Sprite.new(window.root)
    top.sprite = id.Sprite.RS3_MODAL_WINDOW_1_BOTTOM_TILE
    top:SetPos(16, 0)
    top:SetSize(-32, 8, 1, 0)
    top.isFlippedVertical = true
    top.isTiling = true
    top.clickthrough = true
    for _, right in ipairs({ false, true }) do
        local corner = ui.Sprite.new(window.root)
        corner.sprite = id.Sprite.RS3_MODAL_WINDOW_1_BOTTOM_CORNER
        corner:SetPos(right and -16 or 0, 0, right and 1 or 0, 0)
        corner:SetSize(16, 16)
        corner.isFlippedVertical = true
        corner.isFlippedHorizontally = right
        corner.clickthrough = true
    end
    local function restore_background()
        window.background:SetPos(8, 8)
        window.background:SetSize(-16, -16, 1, 1)
        window.leftBorder:SetPos(0, 16)
        window.leftBorder:SetSize(8, -32, 0, 1)
        window.rightBorder:SetPos(-8, 16, 1, 0)
        window.rightBorder:SetSize(8, -32, 0, 1)
    end
    restore_background()
    local drag_handle = card_drag.attach(window, area)

    local title_x = PADDING
    local ok, item = pcall(function()
        return tip.icon_item and config.Obj[tip.icon_item]
    end)
    if ok and item then
        local icon = ui.Sprite.new(window.root)
        icon:SetPos(PADDING, PADDING)
        icon:SetSize(ICON_SIZE, ICON_SIZE)
        icon:SetAssociatedObject(item.id)
        icon.clickthrough = true
        title_x = PADDING + ICON_SIZE + GAP
    end

    local title = prettyui.Text.new(window.root, {
        text = tip.title,
        x = title_x,
        y = PADDING,
        width = window.root.width - title_x - PADDING - PIN_SIZE - GAP,
        height = ICON_SIZE,
        colour = theme.TEXT,
    })
    title.clickthrough = true

    local pin = ui.Layer.new(window.root)
    pin:SetPos(-PADDING - PIN_SIZE, PADDING + 4, 1, 0)
    pin:SetSize(PIN_SIZE, PIN_SIZE)
    -- Draw the native sprite normally. Canvas UV overrides sample the client's packed
    -- sprite atlas incorrectly; small background strips cover only the baked-in border.
    local pin_image = ui.Sprite.new(pin)
    pin_image:SetSize(PIN_SIZE, PIN_SIZE)
    pin.enabled = true
    pin_image.enabled = true
    pin_image.clickthrough = false
    local function draw_pin(sprite)
        pin_image.sprite = sprite
    end
    draw_pin(id.Sprite.RS3_ICON_PINNED_24PX_2)
    for _, edge in ipairs({ { 0, 0, 24, 2 }, { 0, 22, 24, 2 }, { 0, 2, 2, 20 }, { 22, 2, 2, 20 } }) do
        local mask = ui.Sprite.new(pin)
        mask.sprite = window.background.spriteID
        mask.isTiling = true
        mask:SetPos(edge[1], edge[2])
        mask:SetSize(edge[3], edge[4])
        mask.clickthrough = true
    end
    local tooltip = prettyui.Tooltip.attach(pin_image, area, {
        parent = area,
        text = "Pin as a goal",
        maxWidth = 180,
    })
    local hovered = false
    local function position_tooltip()
        local target = pin_image.xyGlobal
        local origin = area.xyGlobal
        local popup = tooltip.root
        local x = target.x - origin.x + (pin_image.width - popup.width) / 2
        local y = target.y - origin.y - popup.height - 6
        if y < 8 then
            y = target.y - origin.y + pin_image.height + 6
        end
        x = math.max(8, math.min(x, area.width - popup.width - 8))
        y = math.max(8, math.min(y, area.height - popup.height - 8))
        popup:SetPos(math.floor(x), math.floor(y))
    end
    pin_image:Subscribe(ui.Hook.ONCLICK, "skilling_coach_pin", function()
        hovered = false
        tooltip:Hide()
        on_pin()
        return false
    end)
    pin_image:Subscribe(ui.Hook.ONMOUSEOVER, "skilling_coach_pin", function()
        draw_pin(id.Sprite.RS3_ICON_PINNED_24PX_3)
        hovered = true
        tooltip:Show()
        position_tooltip()
    end)
    pin_image:Subscribe(ui.Hook.ONMOUSELEAVE, "skilling_coach_pin", function()
        draw_pin(id.Sprite.RS3_ICON_PINNED_24PX_2)
        hovered = false
        tooltip:Hide()
    end)

    local header = {}
    local last_width, last_height = window.root.width, window.root.height
    Event.Logic.Subscribe("skilling_coach_card_header", function()
        if hovered then
            position_tooltip()
        end
        if window.root.width ~= last_width or window.root.height ~= last_height then
            last_width, last_height = window.root.width, window.root.height
            restore_background()
            title:SetSize(last_width - title_x - PADDING - PIN_SIZE - GAP, ICON_SIZE)
        end
    end)
    function header:Destroy()
        Event.Logic.Unsubscribe("skilling_coach_card_header")
        tooltip:Destroy()
        drag_handle:Destroy()
        pin:Destroy()
    end
    return header
end

return card_header
