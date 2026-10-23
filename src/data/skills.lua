-- skill names in the client's SkillType order (0 = ATTACK). SkillTransmit gives the number,
-- tips use the name, this converts between the two

local skills = {}

skills.NAMES = {
    [0] = "ATTACK",
    "DEFENCE",
    "STRENGTH",
    "HITPOINTS",
    "RANGED",
    "PRAYER",
    "MAGIC",
    "COOKING",
    "WOODCUTTING",
    "FLETCHING",
    "FISHING",
    "FIREMAKING",
    "CRAFTING",
    "SMITHING",
    "MINING",
    "HERBLORE",
    "AGILITY",
    "THIEVING",
    "SLAYER",
    "FARMING",
    "RUNECRAFTING",
    "HUNTER",
    "CONSTRUCTION",
    "SUMMONING",
    "DUNGEONEERING",
    "DIVINATION",
    "INVENTION",
    "ARCHAEOLOGY",
    "NECROMANCY",
}

-- combat xp starts the quiet period instead of counting as training
skills.COMBAT = {
    ATTACK = true,
    DEFENCE = true,
    STRENGTH = true,
    HITPOINTS = true,
    RANGED = true,
    MAGIC = true,
    NECROMANCY = true,
}

local numbers = {}

for number = 0, #skills.NAMES do
    numbers[skills.NAMES[number]] = number
end

function skills.name(number)
    return skills.NAMES[tonumber(number)]
end

function skills.number(name)
    return numbers[name]
end

function skills.is_skill(name)
    return numbers[name] ~= nil
end

return skills
