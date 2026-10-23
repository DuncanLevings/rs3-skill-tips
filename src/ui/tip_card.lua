-- the popup card for one tip.
--
--   [item icon] title         [unboxed pin]
--   hook
--   why
--   discovery pointer
--   Needs: (only the ones not met yet)
--   [Dismiss]               [Later]
--
-- everything shows at once, the card is as tall as the tip needs (capped, it scrolls past
-- that). its a prettyui Window so the player can drag and resize it, card_placement remembers
-- where. it slides in from whichever screen edge its nearest (card_motion).
--
-- a standalone Panel was tried first but it cant be dragged, and it snapped back to the spot
-- it was created at after sliding

local card_motion = require("src/ui/card_motion")
local card_placement = require("src/ui/card_placement")
local theme = require("src/ui/theme")
local requirement_list = require("src/ui/requirement_list")
local card_header = require("src/ui/card_header")
local internals = require("src/ui/prettyui_internals")

local tip_card = {}

local PADDING = 12
local BUTTON_HEIGHT = 24
local ICON_GAP = 8
local SECTION_GAP = 8
local LINE_HEIGHT = 22
-- window border, title strip and the scroll bar the text has to leave room for
local WINDOW_CHROME_HEIGHT = 24
local SCROLLBAR_WIDTH = 18
-- tall tips scroll rather than cover more than this much of the screen
local MAX_HEIGHT_SHARE = 0.6
local MAX_HEIGHT = 480
-- rough fallback if the font cant be measured
local AVERAGE_CHARACTER_WIDTH = 8

local card

local function game_area()
    local ok, area = pcall(function()
        return ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__GAME_AREA)
    end)

    if ok and area and area.width > 0 and area.height > 0 then
        return area
    end

    return nil
end

-- native text wants <br> for new lines
local function display(text)
    return (text:gsub("\n", "<br>"))
end

-- how tall a block of text is at a width, measured with the font prettyui draws body text
-- with so the wrapping matches
local function text_height(text, width)
    local ok, lines = pcall(function()
        return config.Font.MUSEO_SANS_15PT_REGULAR:GetStringLineCount(display(text), width)
    end)

    if not ok or type(lines) ~= "number" then
        local per_line = math.max(1, math.floor(width / AVERAGE_CHARACTER_WIDTH))
        lines = 0

        for line in (text .. "\n"):gmatch("(.-)\n") do
            lines = lines + math.max(1, math.ceil(#line / per_line))
        end
    end

    return math.max(1, lines) * LINE_HEIGHT + 4
end

-- the text blocks on the card, top to bottom
local function sections(tip, state)
    local steps = {}

    for _, step in ipairs(tip.how) do
        steps[#steps + 1] = step
    end

    local list = {
        { text = tip.hook, colour = theme.TEXT },
        { text = tip.why, colour = theme.TEXT_SOFT },
        { text = table.concat(steps, "\n"), colour = theme.TEXT_SOFT },
    }

    local missing = requirement_list.missing(tip, state)

    if #missing > 0 then
        list[#list + 1] = {
            text = "Needs:\n" .. table.concat(missing, "\n"),
            colour = theme.TEXT_WARNING,
        }
    end

    return list
end

-- full height the card would need to show everything without scrolling
local function content_height(blocks)
    local height = PADDING + SECTION_GAP

    for _, block in ipairs(blocks) do
        height = height + block.height + SECTION_GAP
    end

    return height + BUTTON_HEIGHT + PADDING + WINDOW_CHROME_HEIGHT
end

local function measure(blocks, card_width)
    local text_width = card_width - PADDING * 2 - SCROLLBAR_WIDTH

    for _, block in ipairs(blocks) do
        block.height = text_height(block.text, text_width)
    end

    return text_width
end

local function destroy_window()
    if card and card.window then
        local window = card.window
        card.window = nil
        -- destroying it ourselves isnt the player closing it
        card.destroying = true
        if card.pin then
            local pin = card.pin
            card.pin = nil
            pcall(function()
                pin:Destroy()
            end)
        end

        pcall(function()
            window:Destroy()
        end)
    end
end

local function close(action)
    if not card or card.closing then
        return
    end

    card.closing = true
    card_placement.stop()
    action()

    local closing = card

    -- slide out from where the card really is. the saved rect only catches up about a second
    -- after a drag, so dragging then pressing Later straight away used to snap it back first
    pcall(function()
        closing.rect.x = closing.window.root.x
        closing.rect.y = closing.window.root.y
    end)

    local function finished()
        destroy_window()
        card = nil
        closing.handlers.on_closed()
    end

    local root = closing.window.root
    card_motion.slide_out(root, closing.rect, closing.area, closing.animate, finished)
end

-- the window's own close button counts as Later
local function on_window_closed()
    if not card or card.destroying or card.closing then
        return
    end

    local closed = card
    if closed.pin then
        pcall(function()
            closed.pin:Destroy()
        end)
    end

    card_placement.stop()
    card_motion.stop()
    card = nil
    closed.handlers.on_later()
    closed.handlers.on_closed()
end

local function fill(window, blocks, text_width)
    for _, block in ipairs(blocks) do
        window:AddText({
            text = display(block.text),
            colour = block.colour,
            width = text_width,
            height = block.height,
            marginTop = SECTION_GAP,
        })
    end

    -- prettyui's divider is 60px tall, a small margin above the footer looks far better
    local action_width = math.floor((text_width - ICON_GAP) / 2)
    window:AddSimpleButton("Dismiss", function()
        close(card.handlers.on_dismiss)
    end, {
        width = action_width,
        marginTop = SECTION_GAP,
        columnGap = ICON_GAP,
        height = 28,
        colour = theme.TEXT,
        tooltip = "Don't show this tip again",
    })
    window:AddSimpleButton("Later", function()
        close(card.handlers.on_later)
    end, {
        inline = true,
        width = action_width,
        height = 28,
        colour = theme.TEXT,
        tooltip = "Close for now",
    })
end

local function build(tip, handlers, options, area)
    local blocks = sections(tip, options.state)
    local height_limit = math.min(MAX_HEIGHT, math.floor(area.height * MAX_HEIGHT_SHARE))
    local initial_rect = card_placement.rect_for(area, card_placement.MIN_HEIGHT, height_limit)
    local text_width = measure(blocks, initial_rect.width)
    local rect = card_placement.rect_for(area, content_height(blocks), height_limit)

    card = {
        tip = tip,
        handlers = handlers,
        animate = options.animate,
        area = area,
        rect = rect,
    }

    -- created at its resting spot so prettyui never has a different idea of where it lives
    card.window = prettyui.Window.new(area, {
        title = " ",
        x = rect.x,
        y = rect.y,
        width = rect.width,
        height = rect.height,
        minWidth = math.min(card_placement.MIN_WIDTH, area.width),
        minHeight = math.min(card_placement.MIN_HEIGHT, height_limit),
        maxWidth = math.min(card_placement.MAX_WIDTH, area.width),
        maxHeight = height_limit,
        resizable = true,
        scrollable = true,
        destroyOnClose = true,
        onClose = on_window_closed,
    })

    fill(card.window, blocks, text_width)

    -- the flow layout's real height beats the font estimate when prettyui tells us it, plus
    -- room for the frame and footer padding. long tips scroll at the cap
    local laid_out_height = internals.content_height(card.window)

    if laid_out_height then
        rect = card_placement.rect_for(
            area,
            laid_out_height + WINDOW_CHROME_HEIGHT + PADDING * 2,
            height_limit
        )
        card.rect = rect
        internals.set_window_size(card.window, rect.width, rect.height)
        card.window.root:SetPos(rect.x, rect.y)
    end

    local this_card = card

    card.pin = card_header.attach(card.window, tip, function()
        close(this_card.handlers.on_pin)
    end, area, function()
        return card == this_card and not this_card.closing
    end)

    card_motion.slide_in(card.window.root, rect, area, card.animate)
    card_placement.watch(card.window.root, rect, area, card_motion.is_sliding)
end

-- handlers = { on_pin, on_dismiss, on_later, on_closed }, options = { state, animate }
-- returns false when no card could be shown, the caller then knows no card is open
function tip_card.show(tip, handlers, options)
    local area = game_area()

    if not area then
        return false
    end

    tip_card.destroy()

    local ok, problem = pcall(build, tip, handlers, options, area)

    if not ok then
        -- whatever got half built goes away, a broken card must not hang around on screen
        log("Skilling Coach: couldn't show a tip card: " .. tostring(problem))
        tip_card.destroy()
        return false
    end

    return true
end

-- straight away, no slide, used on shutdown
function tip_card.destroy()
    card_placement.stop()
    card_motion.stop()
    destroy_window()
    card = nil
end

function tip_card.set_animation(value)
    if card then
        card.animate = value
        if not value then
            card_motion.finish()
        end
    end
end

function tip_card.is_open()
    return card ~= nil
end

return tip_card
