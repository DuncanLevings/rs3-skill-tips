-- loads every tip file, checks each tip against the schema and builds the lookups the rest of
-- the plugin uses (by id, by skill, quest tips, and which items each tip cares about).
--
-- the client cant list folders, so new tip files get added to TIP_FILES by hand. a tip that
-- fails the schema is logged and skipped, the rest still load. everything is built once at
-- load and never changes afterwards, so the lookups below are just table reads

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
    "src/tips/shared",
    "src/tips/quests",
}

local loaded = false

-- every valid tip in file order
local ordered = {}

-- tip id -> tip
local by_id = {}

-- skill name (or "ANY") -> tips listed under it
local by_skill = {}

-- skill name -> that skill's tips followed by the ANY tips, built the first time it's asked for
local for_skill_cache = {}

local quest_tips = {}

-- item name / category -> ids of tips that owning it explains
local ownership_index = { items = {}, categories = {} }

-- sets of every item name and category any tip asks about
local relevant_items = {}
local relevant_categories = {}

local function add_to_skill(skill, tip)
    by_skill[skill] = by_skill[skill] or {}

    -- a tip can name the same skill twice (in skills and in its quest requirements)
    for _, existing in ipairs(by_skill[skill]) do
        if existing == tip then
            return
        end
    end

    table.insert(by_skill[skill], tip)
end

local function add_to_ownership_index(tip)
    local function add(map, key)
        map[key] = map[key] or {}
        table.insert(map[key], tip.id)
    end

    for _, condition in ipairs(tip.known_when or {}) do
        if condition.type == "owns_any" then
            for _, item in ipairs(condition.items) do
                add(ownership_index.items, item)
                relevant_items[item] = true
            end
        elseif condition.type == "owns_category" then
            add(ownership_index.categories, condition.category)
            relevant_categories[condition.category] = true
        end
    end
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

    for _, skill in ipairs(tip.skills) do
        add_to_skill(skill, tip)
    end

    -- a quest tip also belongs to every skill it needs, so training any of them can find it
    if tip.kind == "quest" then
        quest_tips[#quest_tips + 1] = tip

        for skill in pairs(tip.requirements.skills) do
            add_to_skill(skill, tip)
        end

        for skill in pairs(tip.requirements.any_skills or {}) do
            add_to_skill(skill, tip)
        end
    end

    add_to_ownership_index(tip)
end

function catalogue.load()
    if loaded then
        return
    end

    loaded = true

    for _, file in ipairs(TIP_FILES) do
        for _, tip in ipairs(require(file) or {}) do
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

-- tips for one skill plus the ANY ones that fit every skill. treat the list as read only, its
-- shared between callers
function catalogue.for_skill(skill)
    catalogue.load()

    if for_skill_cache[skill] then
        return for_skill_cache[skill]
    end

    local tips, seen = {}, {}
    for _, list in ipairs({ by_skill[skill] or {}, by_skill.ANY or {} }) do
        for _, tip in ipairs(list) do
            if not seen[tip] then
                seen[tip] = true
                tips[#tips + 1] = tip
            end
        end
    end

    for_skill_cache[skill] = tips

    return tips
end

-- a quest can become ready from a combat or reward level, so these arent tied to one skill
function catalogue.quest_tips()
    catalogue.load()
    return quest_tips
end

-- every item config name and category any tip asks about, as two sets. the bank snapshot
-- only remembers these, never the whole bank
function catalogue.relevant_items()
    catalogue.load()
    return relevant_items, relevant_categories
end

-- { items = { NAME = { tip ids } }, categories = { [number] = { tip ids } } }. lets an
-- inventory update turn each item it sees into tip ids with one table lookup
function catalogue.ownership_index()
    catalogue.load()
    return ownership_index
end

return catalogue
