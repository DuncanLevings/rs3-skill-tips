-- the `state` object conditions read the player through. each answer comes straight from the
-- client (or the bank snapshot), and anything that cant be read comes back nil.
--
-- Player functions are static, so theyre called with a dot (Player.IsAvailable()), not a colon

local skills = require("src/data/skills")
local inventories = require("src/game/inventories")
local owned_items = require("src/storage/owned_items")

local player_state = {}

local function read(fn)
    local ok, value = pcall(function()
        if Player.IsAvailable() then
            return fn()
        end
    end)
    if ok then
        return value
    end
end

function player_state.level(skill)
    local number = skills.number(skill)

    return number and read(function()
        return Player.GetLevelUncapped(number)
    end)
end

function player_state.owns_item(item)
    return inventories.carrying_item(item) or owned_items.in_bank(item)
end

function player_state.owns_category(category)
    return inventories.carrying_category(category) or owned_items.category_in_bank(category)
end

-- varbits live under var.VarPlayer, theres no separate var.VarBit
function player_state.varbit(name)
    return read(function()
        return var.VarPlayer[name].value
    end)
end

function player_state.quest_done(quest)
    return read(function()
        return config.Quest[quest].hasFinishedQuest
    end)
end

-- the name players see, for showing requirements
function player_state.quest_name(quest)
    return read(function()
        return config.Quest[quest].name
    end)
end

-- an achievement with progress -2 is complete
function player_state.achievement_done(achievement)
    return read(function()
        return config.Achievement[achievement].progress == -2
    end)
end

return player_state
