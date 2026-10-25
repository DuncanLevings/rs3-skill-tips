-- remembers where the player put the tip card and how big they made it.
--
-- position is saved as a fraction of the free space, so a card parked on the right stays on
-- the right when the game window changes size.
--
-- the drag and resize hooks dont fire for prettyui windows, so watch() looks at the card's
-- position and size twice a second and saves once its stopped changing. width and placement
-- are remembered, height always fits the current tip

local saved_table = require("src/storage/saved_table")

local card_placement = {}

local STORAGE_KEY = "skilling_coach_card"
local VERSION = 1
local WATCH_SUBSCRIPTION = "skilling_coach_card_placement"
local CHECK_EVERY_TICKS = 25

card_placement.DEFAULT_WIDTH = 360
card_placement.MIN_WIDTH = 260
card_placement.MIN_HEIGHT = 160
card_placement.MAX_WIDTH = 520
-- left edge, a bit above the middle: out of the way of the action bar and minimap
local DEFAULT_X_RATIO = 0
local DEFAULT_Y_RATIO = 0.4

local watching

local function is_number(value)
    return type(value) == "number" and value == value and math.abs(value) < math.huge
end

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(value, maximum))
end

local function load_saved()
    local saved = saved_table.load(STORAGE_KEY, VERSION) or {}

    return {
        width = is_number(saved.width) and saved.width or nil,
        x_ratio = is_number(saved.x_ratio) and clamp(saved.x_ratio, 0, 1) or DEFAULT_X_RATIO,
        y_ratio = is_number(saved.y_ratio) and clamp(saved.y_ratio, 0, 1) or DEFAULT_Y_RATIO,
    }
end

-- where the next card goes. content_height is how tall the tip wants to be, max_height caps
-- it (the card scrolls past that)
function card_placement.rect_for(area, content_height, max_height)
    local saved = load_saved()
    local width = saved.width or card_placement.DEFAULT_WIDTH
    width = clamp(
        width,
        math.min(card_placement.MIN_WIDTH, area.width),
        math.min(card_placement.MAX_WIDTH, area.width)
    )
    -- height follows the tip, including when an older version saved a much taller card
    max_height = math.min(max_height, area.height)
    local height =
        clamp(content_height, math.min(card_placement.MIN_HEIGHT, max_height), max_height)

    return {
        x = math.floor((area.width - width) * saved.x_ratio + 0.5),
        y = math.floor((area.height - height) * saved.y_ratio + 0.5),
        width = width,
        height = height,
    }
end

local function save(rect, area)
    local saved = load_saved()
    local x_space = math.max(0, area.width - rect.width)
    local y_space = math.max(0, area.height - rect.height)

    saved_table.save(STORAGE_KEY, {
        version = VERSION,
        width = rect.width,
        x_ratio = x_space > 0 and clamp(rect.x / x_space, 0, 1) or 0,
        y_ratio = y_space > 0 and clamp(rect.y / y_space, 0, 1) or 0,
    })
end

local function read_geometry(root)
    local ok, geometry = pcall(function()
        return { x = root.x, y = root.y, width = root.width, height = root.height }
    end)

    return ok and geometry or nil
end

local function same(left, right)
    return left.x == right.x
        and left.y == right.y
        and left.width == right.width
        and left.height == right.height
end

local function check(event)
    local card = watching

    if not card or (event.logicTick or 0) % CHECK_EVERY_TICKS ~= 0 or card.is_busy() then
        return
    end

    local geometry = read_geometry(card.root)

    if not geometry or same(geometry, card.rect) then
        card.pending = nil
        return
    end

    -- moved since last check, wait for one quiet check so a drag isnt saved halfway through
    if not card.pending or not same(geometry, card.pending) then
        card.pending = geometry
        return
    end

    for key, value in pairs(geometry) do
        card.rect[key] = value
    end

    card.pending = nil
    save(card.rect, card.area)
end

-- starts watching an open card. rect is updated in place so the slide out uses where the card
-- really is. is_busy says when its sliding, those moves arent the player's
function card_placement.watch(root, rect, area, is_busy)
    watching = { root = root, rect = rect, area = area, is_busy = is_busy }
    Event.Logic.Subscribe(WATCH_SUBSCRIPTION, check)
end

function card_placement.reset()
    local saved = load_saved()
    saved_table.save(STORAGE_KEY, { version = VERSION, width = saved.width })
    if watching then
        local card = watching
        local x = math.floor(math.max(0, card.area.width - card.root.width) * DEFAULT_X_RATIO)
        local y = math.floor(math.max(0, card.area.height - card.root.height) * DEFAULT_Y_RATIO)
        card.root:SetPos(x, y)
        card.rect.x, card.rect.y = x, y
        card.pending = nil
    end
end

function card_placement.stop()
    watching = nil
    Event.Logic.Unsubscribe(WATCH_SUBSCRIPTION)
end

return card_placement
