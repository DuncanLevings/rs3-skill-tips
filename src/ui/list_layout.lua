-- compact native list geometry shared by tips and history, measured before making a window.
local layout = {}
layout.ICON_SIZE = 28
layout.ICON_GAP = 8
layout.ACTION_WIDTH = 24
layout.GAP = 20
layout.INSET = 4
layout.GUTTER = 18
layout.BOTTOM_PADDING = 12
layout.WINDOW_CHROME = 48

local function line_count(text, width)
    local ok, lines = pcall(function()
        return config.Font.MUSEO_SANS_15PT_REGULAR:GetStringLineCount(text, width)
    end)
    if ok and type(lines) == "number" then
        return math.max(1, lines)
    end

    return math.max(1, math.ceil(#text / math.max(1, math.floor(width / 8))))
end

local function text_width(text, cap)
    local low, high = 1, math.max(1, cap)
    while low < high do
        local middle = math.floor((low + high) / 2)
        if line_count(text, middle) <= 1 then
            high = middle
        else
            low = middle + 1
        end
    end

    return math.min(cap, low + 4)
end

function layout.measure(rows, area, options)
    local cap = math.min(options.max_width, area.width)
    local chrome = layout.INSET * 2 + layout.GUTTER
    local icon_column = 0
    for _, row in ipairs(rows) do
        if row.icon_id then
            icon_column = layout.ICON_SIZE + layout.ICON_GAP
        end
    end

    local width = math.min(options.min_width, cap)
    for _, row in ipairs(rows) do
        local action = row.action and layout.ACTION_WIDTH + layout.GAP or 0
        width = math.max(
            width,
            math.min(cap, text_width(row.title, cap) + icon_column + action + chrome)
        )
        if row.body then
            width = math.max(width, math.min(cap, text_width(row.body, cap) + chrome))
        end
    end

    local empty = #rows == 1 and rows[1].empty
    if empty then
        width = math.min(cap, math.max(width, options.empty_width or width))
    end

    local content_width = math.max(1, options.content_width or (width - chrome))
    local longest_title = 0
    for _, row in ipairs(rows) do
        longest_title = math.max(longest_title, text_width(row.title, cap))
    end

    local total, visible = layout.INSET, layout.INSET
    for index, row in ipairs(rows) do
        local action = row.action and layout.ACTION_WIDTH + layout.GAP or 0
        local title_cap = math.max(1, content_width - action - icon_column)
        row.icon_offset = icon_column
        row.title_width = row.action and math.min(title_cap, longest_title)
            or math.min(title_cap, text_width(row.title, title_cap))
        row.title_height = line_count(row.title, row.title_width) * 20
        row.height = math.max(row.icon_id and layout.ICON_SIZE + 8 or 32, row.title_height + 8)
        if row.body then
            row.body_height = line_count(row.body, content_width) * 20 + 4
            row.heading_height = math.max(
                row.title_height,
                row.action and 24 or 0,
                row.icon_id and layout.ICON_SIZE or 0
            )
            row.height = row.heading_height + 4 + row.body_height + 8
        end

        total = total + row.height
        if index <= 8 then
            visible = visible + row.height
        end
    end

    return {
        width = width,
        height = math.max(
            empty and (options.empty_height or 88) or 64,
            visible + layout.BOTTOM_PADDING + layout.WINDOW_CHROME
        ),
        content_height = total + layout.BOTTOM_PADDING,
        content_width = content_width,
    }
end

return layout
