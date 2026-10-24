-- card style header drawn over prettyui's window: item icon, title and an unboxed pin, with no
-- title plaque. the undocumented window bits it needs go through prettyui_internals

local theme = require("src/ui/theme")
local card_drag = require("src/ui/card_drag")
local internals = require("src/ui/prettyui_internals")

local item_icon = require("src/ui/item_icon")
local card_header = {}

local PADDING = 12
local ICON_SIZE = 28
local GAP = 8
local PIN_SIZE = 24
local LOGIC_SUBSCRIPTION = "skilling_coach_card_header"
-- strips over the pin sprite's baked in border: { x, y, width, height }
local PIN_BORDER_MASKS = { { 0, 0, 24, 2 }, { 0, 22, 24, 2 }, { 0, 2, 2, 20 }, { 22, 2, 2, 20 } }

-- the native frame top edge and corners, where the title plaque used to be
local function draw_plain_top(window)
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
end

-- returns where the title text starts, after the icon if there is one
local function draw_icon(window, tip)
    local item_id = item_icon.id(tip)
    if not item_id then
        return PADDING
    end

    local icon = ui.Sprite.new(window.root)
    icon:SetPos(PADDING, PADDING)
    icon:SetSize(ICON_SIZE, ICON_SIZE)
    icon:SetAssociatedObject(item_id)
    icon.clickthrough = true

    return PADDING + ICON_SIZE + GAP
end

-- keeps the hover label above the pin (or below it near the top edge) and on screen
local function place_tooltip(tooltip, target, area)
    local popup = internals.tooltip_root(tooltip)

    if not popup then
        return
    end

    local origin = area.xyGlobal
    local x = target.xyGlobal.x - origin.x + (target.width - popup.width) / 2
    local y = target.xyGlobal.y - origin.y - popup.height - 6

    if y < 8 then
        y = target.xyGlobal.y - origin.y + target.height + 6
    end

    x = math.max(8, math.min(x, area.width - popup.width - 8))
    y = math.max(8, math.min(y, area.height - popup.height - 8))
    popup:SetPos(math.floor(x), math.floor(y))
end

local function draw_pin(window, area, on_pin)
    local pin = ui.Layer.new(window.root)
    pin:SetPos(-PADDING - PIN_SIZE, PADDING + 4, 1, 0)
    pin:SetSize(PIN_SIZE, PIN_SIZE)
    pin.enabled = true

    -- the native sprite drawn as is. cropping it with canvas uvs read the wrong part of the
    -- client's sprite atlas in game, so its border gets covered with background strips instead
    local image = ui.Sprite.new(pin)
    image:SetSize(PIN_SIZE, PIN_SIZE)
    image.enabled = true
    image.clickthrough = false
    image.sprite = id.Sprite.RS3_ICON_PINNED_24PX_2

    local background = internals.background_sprite(window)

    for _, edge in ipairs(PIN_BORDER_MASKS) do
        local mask = ui.Sprite.new(pin)
        mask.sprite = background
        mask.isTiling = true
        mask:SetPos(edge[1], edge[2])
        mask:SetSize(edge[3], edge[4])
        mask.clickthrough = true
    end

    local tooltip = prettyui.Tooltip.attach(image, area, {
        parent = area,
        text = "Pin tip",
        maxWidth = 180,
    })
    local controls = { layer = pin, image = image, tooltip = tooltip, hovered = false }

    image:Subscribe(ui.Hook.ONCLICK, "skilling_coach_pin", function()
        controls.hovered = false
        tooltip:Hide()
        on_pin()
        return false
    end)

    image:Subscribe(ui.Hook.ONMOUSEOVER, "skilling_coach_pin", function()
        image.sprite = id.Sprite.RS3_ICON_PINNED_24PX_3
        controls.hovered = true
        tooltip:Show()
        place_tooltip(tooltip, image, area)
    end)

    image:Subscribe(ui.Hook.ONMOUSELEAVE, "skilling_coach_pin", function()
        image.sprite = id.Sprite.RS3_ICON_PINNED_24PX_2
        controls.hovered = false
        tooltip:Hide()
    end)

    return controls
end

-- can_drag goes to card_drag, false once the card is closing
function card_header.attach(window, tip, on_pin, area, can_drag)
    internals.hide_title_bar(window)
    draw_plain_top(window)
    internals.restore_plain_frame(window)

    local drag_handle = card_drag.attach(window, area, can_drag)
    local title_x = draw_icon(window, tip)

    local title = prettyui.Text.new(window.root, {
        text = tip.title,
        x = title_x,
        y = PADDING,
        width = window.root.width - title_x - PADDING - PIN_SIZE - GAP,
        height = ICON_SIZE,
        colour = theme.TEXT,
    })
    title.clickthrough = true

    local pin = draw_pin(window, area, on_pin)

    -- the tooltip follows the pin while hovered, and the frame/title follow resizes
    local last_width, last_height = window.root.width, window.root.height

    Event.Logic.Subscribe(LOGIC_SUBSCRIPTION, function()
        if pin.hovered then
            place_tooltip(pin.tooltip, pin.image, area)
        end

        if window.root.width ~= last_width or window.root.height ~= last_height then
            last_width, last_height = window.root.width, window.root.height
            internals.restore_plain_frame(window)
            title:SetSize(last_width - title_x - PADDING - PIN_SIZE - GAP, ICON_SIZE)
        end
    end)

    local header = {}

    function header:Destroy()
        Event.Logic.Unsubscribe(LOGIC_SUBSCRIPTION)
        pin.tooltip:Destroy()
        drag_handle:Destroy()
        pin.layer:Destroy()
    end

    return header
end

return card_header
