-- separate placement for the pinned side window; height always follows the rows.
local saved_table = require("src/storage/saved_table")
local placement = {}
local KEY = "skilling_coach_goals"

local function ratio(value, fallback)
    if type(value) ~= "number" or value ~= value or math.abs(value) == math.huge then
        return fallback
    end

    return math.max(0, math.min(1, value))
end

function placement.rect(area, content_height, options)
    options = options or {}
    local saved = saved_table.load(options.key or KEY, 1) or {}
    local width = math.min(options.width or 280, area.width)
    local height = math.min(content_height, 420, math.floor(area.height * 0.6))
    if options.remember_size then
        local function dimension(value, fallback, minimum, maximum)
            if type(value) ~= "number" or value ~= value or math.abs(value) == math.huge then
                value = fallback
            end

            return math.max(math.min(minimum, maximum), math.min(value, maximum))
        end

        width = dimension(saved.width, options.width or 360, 260, area.width)
        height = dimension(saved.height, options.height or 400, 180, area.height)
    end

    return {
        width = width,
        height = height,
        x = math.floor(
            math.max(0, area.width - width) * ratio(saved.x_ratio, options.default_x or 1) + 0.5
        ),
        y = math.floor(math.max(0, area.height - height) * ratio(saved.y_ratio, 0.35) + 0.5),
    }
end

function placement.save(root, area, options)
    options = options or {}
    local horizontal = math.max(0, area.width - root.width)
    local vertical = math.max(0, area.height - root.height)
    saved_table.save(options.key or KEY, {
        version = 1,
        width = options.remember_size and root.width or nil,
        height = options.remember_size and root.height or nil,
        x_ratio = horizontal > 0 and ratio(root.x / horizontal, 0) or 0,
        y_ratio = vertical > 0 and ratio(root.y / vertical, 0) or 0,
    })
end

function placement.clamp(root, area)
    local x = math.max(0, math.min(root.x, area.width - root.width))
    local y = math.max(0, math.min(root.y, area.height - root.height))
    if x ~= root.x or y ~= root.y then
        root:SetPos(x, y)
    end
end

return placement
