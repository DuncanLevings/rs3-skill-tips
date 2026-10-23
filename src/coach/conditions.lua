-- the named checks tips can use in known_when, eg "owns any of these items" or "finished this
-- quest". tip files are plain data so all the actual logic lives here.
--
-- every check reads the player through a `state` object (see src/game/player_state.lua) instead
-- of calling the client api itself, which keeps these easy to test. anything the state cant
-- answer yet comes back nil and counts as false

local skills = require("src/data/skills")

local conditions = {}

local function is_non_empty_string(value)
    return type(value) == "string" and value ~= ""
end

local function is_positive_integer(value)
    return math.type(value) == "integer" and value > 0
end

local function is_list_of_strings(value)
    if type(value) ~= "table" or #value == 0 then
        return false
    end

    for _, entry in ipairs(value) do
        if not is_non_empty_string(entry) then
            return false
        end
    end

    return true
end

-- each type has a validate (used by the tip schema at load) and a check (used at runtime).
-- needs_bank marks checks about owned items, those wait until the bank has been seen once
-- so a player with an ore box sitting in their bank doesnt get told about ore boxes
conditions.TYPES = {
    has_level = {
        validate = function(condition)
            return skills.is_skill(condition.skill) and is_positive_integer(condition.level)
        end,
        check = function(condition, state)
            local level = state.level(condition.skill)
            return level ~= nil and level >= condition.level
        end,
    },

    -- items are ObjType config names, eg MINING_OREBOX_BRONZE. list every variant an item
    -- has (new/used, active/inactive), they count as different items
    owns_any = {
        needs_bank = true,
        validate = function(condition)
            return is_list_of_strings(condition.items)
        end,
        check = function(condition, state)
            for _, item in ipairs(condition.items) do
                if state.owns_item(item) then
                    return true
                end
            end

            return false
        end,
    },

    -- item categories group whole families of items (every ore box tier shares one), handy
    -- when listing each variant would be a pain
    owns_category = {
        needs_bank = true,
        validate = function(condition)
            return is_positive_integer(condition.category)
        end,
        check = function(condition, state)
            return state.owns_category(condition.category) == true
        end,
    },

    varbit_at_least = {
        validate = function(condition)
            return is_non_empty_string(condition.varbit) and math.type(condition.value) == "integer"
        end,
        check = function(condition, state)
            local value = state.varbit(condition.varbit)
            return value ~= nil and value >= condition.value
        end,
    },

    -- quest config names, checked against the probe's quest dump. some quests have a dead
    -- duplicate with the same name (COOK_QUEST vs COOKS_ASSISTANT), always use the live one
    quest_done = {
        validate = function(condition)
            return is_non_empty_string(condition.quest)
        end,
        check = function(condition, state)
            return state.quest_done(condition.quest) == true
        end,
    },

    achievement_done = {
        validate = function(condition)
            return is_non_empty_string(condition.achievement)
        end,
        check = function(condition, state)
            return state.achievement_done(condition.achievement) == true
        end,
    },
}

function conditions.is_valid(condition)
    if type(condition) ~= "table" then
        return false
    end

    local condition_type = conditions.TYPES[condition.type]

    return condition_type ~= nil and condition_type.validate(condition)
end

function conditions.check(condition, state)
    return conditions.TYPES[condition.type].check(condition, state)
end

-- true when any condition in the list holds, empty list is false
function conditions.any(list, state)
    for _, condition in ipairs(list or {}) do
        if conditions.check(condition, state) then
            return true
        end
    end

    return false
end

-- does any condition in the list depend on what the player owns
function conditions.needs_bank(list)
    for _, condition in ipairs(list or {}) do
        if conditions.TYPES[condition.type].needs_bank then
            return true
        end
    end

    return false
end

return conditions
