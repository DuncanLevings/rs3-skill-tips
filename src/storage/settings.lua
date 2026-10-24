-- player settings, saved in PersistentDB. shared by every character on this computer, same as
-- most game settings feel.
--
-- each setting has its own check and default, and is recovered on its own, so one bad saved
-- value (or a setting added in a newer version) doesnt reset the rest

local skills = require("src/data/skills")
local saved_table = require("src/storage/saved_table")

local settings = {}

local STORAGE_KEY = "skilling_coach_settings"
local VERSION = 1

local function is_boolean(value)
    return type(value) == "boolean"
end

local function whole_number_between(minimum, maximum)
    return function(value)
        return math.type(value) == "integer" and value >= minimum and value <= maximum
    end
end

-- { MINING = true } style set of skill names
local function is_skill_set(value)
    if type(value) ~= "table" then
        return false
    end

    for name, muted in pairs(value) do
        if not skills.is_skill(name) or muted ~= true then
            return false
        end
    end

    return true
end

local function is_binding(value)
    if type(value) ~= "table" or #value > 2 then
        return false
    end

    local seen = {}
    for index, key in pairs(value) do
        if
            math.type(index) ~= "integer"
            or index < 1
            or index > #value
            or math.type(key) ~= "integer"
            or key < 0
            or key > 65535
            or seen[key]
        then
            return false
        end

        seen[key] = true
    end

    return true
end

local DEFINITIONS = {
    tips_enabled = { default = true, valid = is_boolean },
    dismiss_hours = { default = 3, valid = whole_number_between(0, 8) },
    cooldown_minutes = { default = 10, valid = whole_number_between(2, 60) },
    -- 0 means no limit
    session_cap = { default = 6, valid = whole_number_between(0, 50) },
    combat_quiet_seconds = { default = 60, valid = whole_number_between(0, 600) },
    show_convenience = { default = true, valid = is_boolean },
    show_methods = { default = true, valid = is_boolean },
    show_quests = { default = true, valid = is_boolean },
    pinned_keybind = { default = {}, valid = is_binding },
    show_general = { default = true, valid = is_boolean },
    show_early = { default = true, valid = is_boolean },
    show_mid = { default = true, valid = is_boolean },
    show_late = { default = true, valid = is_boolean },
    show_members = { default = true, valid = is_boolean },
    muted_skills = { default = {}, valid = is_skill_set },
    animate_card = { default = true, valid = is_boolean },
}

---@type table<string, any>?
local values

-- tables get copied so nobody can change a setting by editing what get() handed them
local function copy(value)
    if type(value) ~= "table" then
        return value
    end

    local result = {}

    for key, entry in pairs(value) do
        result[key] = entry
    end

    return result
end

local function load()
    if values then
        return values
    end

    local saved = saved_table.load(STORAGE_KEY, VERSION) or {}
    values = { version = VERSION }

    for key, definition in pairs(DEFINITIONS) do
        if definition.valid(saved[key]) then
            values[key] = copy(saved[key])
        else
            values[key] = copy(definition.default)
        end
    end

    return values
end

function settings.get(key)
    assert(DEFINITIONS[key], "unknown setting " .. tostring(key))
    return copy(load()[key])
end

-- false (and nothing saved) when the key or value isnt allowed
function settings.set(key, value)
    local definition = DEFINITIONS[key]

    if not definition or not definition.valid(value) then
        return false
    end

    load()[key] = copy(value)
    saved_table.save(STORAGE_KEY, values)

    return true
end

-- forget what was loaded, the next get reads PersistentDB again (used by tests)
function settings.unload()
    values = nil
end

return settings
