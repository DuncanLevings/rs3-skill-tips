-- loads every tip file, checks each tip and indexes them by id and skill.
--
-- the client cant list folders, so new tip files get added to TIP_FILES by hand. a tip that
-- fails the schema is logged and skipped, the rest still load

local schema = require("src/tips/schema")

local catalogue = {}

local TIP_FILES = {
    "src/tips/skills/mining",
    "src/tips/skills/woodcutting",
    "src/tips/skills/fishing",
    "src/tips/skills/hunter",
    "src/tips/skills/divination",
    "src/tips/skills/archaeology",
    "src/tips/skills/farming",
    "src/tips/skills/smithing",
    "src/tips/skills/crafting",
    "src/tips/skills/fletching",
    "src/tips/skills/cooking",
    "src/tips/skills/herblore",
    "src/tips/skills/firemaking",
    "src/tips/skills/runecrafting",
    "src/tips/skills/construction",
    "src/tips/skills/invention",
    "src/tips/skills/agility",
    "src/tips/skills/thieving",
    "src/tips/skills/prayer",
    "src/tips/skills/summoning",
    "src/tips/artisan_shared",
    "src/tips/shared",
    "src/tips/quests",
}

local loaded = false
local by_id = {}
local by_skill = {}
local ordered = {}

local function add_to_skill(skill, tip)
    by_skill[skill] = by_skill[skill] or {}
    table.insert(by_skill[skill], tip)
end

local function add_tip(tip, file)
    local problems = schema.problems(tip)

    if #problems == 0 and by_id[tip.id] then
        problems = { "id is already used by another tip" }
    end

    if #problems > 0 then
        local label = type(tip) == "table" and tostring(tip.id) or "?"
        log("Skill Tips: skipped tip " .. label .. " in " .. file .. ": " .. problems[1])
        return
    end

    by_id[tip.id] = tip
    ordered[#ordered + 1] = tip

    local indexed = {}
    local function index(skill)
        if not indexed[skill] then
            indexed[skill] = true
            add_to_skill(skill, tip)
        end
    end

    for _, skill in ipairs(tip.skills) do
        index(skill)
    end

    if tip.kind == "quest" then
        for skill in pairs(tip.requirements.skills) do
            index(skill)
        end
        for skill in pairs(tip.requirements.any_skills or {}) do
            index(skill)
        end
    end
end

function catalogue.load()
    if loaded then
        return
    end

    loaded = true

    for _, file in ipairs(TIP_FILES) do
        local tips = require(file)

        for _, tip in ipairs(tips or {}) do
            add_tip(tip, file)
        end
    end
end

function catalogue.get(tip_id)
    catalogue.load()
    return by_id[tip_id]
end

function catalogue.all()
    catalogue.load()
    return ordered
end

-- tips for one skill plus the ANY ones that fit every skill
function catalogue.for_skill(skill)
    catalogue.load()
    local tips = {}
    local seen = {}

    local function append(tip)
        if not seen[tip.id] then
            tips[#tips + 1] = tip
            seen[tip.id] = true
        end
    end

    for _, tip in ipairs(by_skill[skill] or {}) do
        append(tip)
    end

    for _, tip in ipairs(by_skill.ANY or {}) do
        append(tip)
    end

    return tips
end

-- a quest can become ready from a combat or reward level, so these arent tied to one skill
function catalogue.quest_tips()
    catalogue.load()
    local tips = {}
    for _, tip in ipairs(ordered) do
        if tip.kind == "quest" then
            tips[#tips + 1] = tip
        end
    end

    return tips
end

-- every item config name and category any tip asks about. the bank snapshot only remembers
-- these, not the whole bank
function catalogue.relevant_items()
    catalogue.load()
    local items = {}
    local categories = {}

    for _, tip in ipairs(ordered) do
        for _, condition in ipairs(tip.known_when or {}) do
            if condition.type == "owns_any" then
                for _, item in ipairs(condition.items) do
                    items[item] = true
                end
            elseif condition.type == "owns_category" then
                categories[condition.category] = true
            end
        end
    end

    return items, categories
end

local ownership_index

-- item name -> ids of tips that owning it explains, same for categories. built once so an
-- inventory update only costs a table lookup per item instead of checking every tip
function catalogue.ownership_index()
    catalogue.load()

    if ownership_index then
        return ownership_index
    end

    ownership_index = { items = {}, categories = {} }

    local function add(map, key, tip_id)
        map[key] = map[key] or {}
        table.insert(map[key], tip_id)
    end

    for _, tip in ipairs(ordered) do
        for _, condition in ipairs(tip.known_when or {}) do
            if condition.type == "owns_any" then
                for _, item in ipairs(condition.items) do
                    add(ownership_index.items, item, tip.id)
                end
            elseif condition.type == "owns_category" then
                add(ownership_index.categories, condition.category, tip.id)
            end
        end
    end

    return ownership_index
end

return catalogue
