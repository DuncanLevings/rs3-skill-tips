-- every prettyui field or method used here that isnt in its public docs lives in this file,
-- so a prettyui update only means checking here. if the card or lists look wrong after an
-- update, look here first.
--
-- each helper is guarded: if a field moved or got renamed it does nothing (or returns nil)
-- instead of throwing, so the worst case is a plainer looking window, not a broken plugin

local internals = {}

-- the pieces of a Window's title plaque, hidden so the card looks like a card
local TITLE_PARTS = {
    "titleLeft",
    "titleRight",
    "titleCentre",
    "titleCentreLeft",
    "titleCentreRight",
    "titleText",
    "closeButton",
    "titleDrag",
}

local function try(fn)
    local ok, result = pcall(fn)
    return ok and result or nil
end

function internals.hide_title_bar(window)
    for _, name in ipairs(TITLE_PARTS) do
        try(function()
            if window[name] then
                window[name].hidden = true
            end
        end)
    end
end

-- with the title plaque gone the background and side borders need to reach the top edge
function internals.restore_plain_frame(window)
    try(function()
        window.background:SetPos(8, 8)
        window.background:SetSize(-16, -16, 1, 1)
        window.leftBorder:SetPos(0, 16)
        window.leftBorder:SetSize(8, -32, 0, 1)
        window.rightBorder:SetPos(-8, 16, 1, 0)
        window.rightBorder:SetSize(8, -32, 0, 1)
    end)
end

-- sprite the window background tiles, used to mask the border baked into the pin icon
function internals.background_sprite(window)
    return try(function()
        return window.background.spriteID
    end)
end

-- the raw layer inside the scrolling area, for placing things at exact positions
function internals.content_layer(window)
    return try(function()
        return window.content
    end)
end

-- how tall the flow layout actually ended up, nil if prettyui doesnt say
function internals.content_height(window)
    local height = try(function()
        return window.contentHeight
    end)

    return type(height) == "number" and height > 0 and height or nil
end

function internals.set_content_height(window, height)
    try(function()
        window:SetContentHeight(height)
    end)
end

function internals.set_window_size(window, width, height)
    try(function()
        window:SetSize(width, height)
    end)
end

function internals.show_window(window)
    try(function()
        window:Show()
    end)
end

function internals.scroll_by(window, delta)
    try(function()
        window:ScrollBy(delta)
    end)
end

-- the popup component of an attached tooltip, for placing it by hand
function internals.tooltip_root(tooltip)
    return try(function()
        return tooltip.root
    end)
end

-- Text has no SetText, the string lives in its content field
function internals.set_text(text_component, value)
    try(function()
        text_component.content = value
    end)
end

return internals
