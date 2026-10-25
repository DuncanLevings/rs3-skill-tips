-- useful items and unlocks, then main methods and alternatives in level order.
-- source access and recommendation windows: docs/artisan-coverage.md.

return {
    {
        id = "shared.amulet_of_offerings",
        icon_item = "ELIDINIS_BOSS_OFFERINGS_AMULET",
        kind = "convenience",
        skills = { "CRAFTING", "FLETCHING" },
        members = true,
        title = "Amulet of Offerings",
        hook = "The Amulet of Offerings adds experience to Crafting and Fletching.",
        why = "Its later upgrades trade crafted output for more experience, so you can choose between keeping items and training faster.",
        how = {
            "It is a reward from Ode of the Devourer. Look at its Crafting and Fletching upgrades when you want to develop it further.",
        },
        quest_how = {
            "Work towards Ode of the Devourer to reach the Gate of Elidinis and its rewards.",
        },
        requirements = {
            skills = {
                SLAYER = 10,
                AGILITY = 25,
                CONSTRUCTION = 54,
                NECROMANCY = 75,
                PRAYER = 40,
                MAGIC = 66,
                CRAFTING = 1,
                ARCHAEOLOGY = 86,
                COOKING = 20,
            },
            quests = { "QUEST_AMASCUT" },
        },
        min_training_level = 80,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CRAFTING",
            },
            {
                type = "training",
                skill = "FLETCHING",
            },
        },
        known_when = {
            {
                items = {
                    "ELIDINIS_BOSS_OFFERINGS_AMULET",
                    "ELIDINIS_BOSS_OFFERINGS_AMULET_UPGRADED_CRAFTING",
                    "ELIDINIS_BOSS_OFFERINGS_AMULET_UPGRADED_FLETCHING",
                },
                type = "owns_any",
            },
            {
                type = "quest_done",
                quest = "QUEST_AMASCUT",
            },
        },
        priority = 2,
    },

    {
        id = "shared.artificers_measure",
        icon_item = "SKILLING_OFFHAND_MEASURE",
        kind = "convenience",
        skills = { "CRAFTING", "CONSTRUCTION" },
        members = true,
        title = "Artificer's measure",
        hook = "The Artificer's measure offers a longer-term upgrade for crafting and building.",
        why = "This off-hand can improve material-saving effects and provide extra crafting or building experience.",
        how = { "Inspect its recipe and the Archaeology artefacts it brings together." },
        quest_how = {
            "Work towards Legacy of Seergaze and Plague's End, then inspect the Artificer's measure recipe.",
        },
        requirements = {
            skills = {
                DUNGEONEERING = 75,
                CRAFTING = 99,
                ARCHAEOLOGY = 102,
                AGILITY = 75,
                CONSTRUCTION = 75,
                FIREMAKING = 40,
                MAGIC = 49,
                MINING = 75,
                SLAYER = 31,
                STRENGTH = 40,
                THIEVING = 50,
                HERBLORE = 75,
                PRAYER = 75,
                RANGED = 75,
                SUMMONING = 75,
                WOODCUTTING = 75,
                COOKING = 30,
                FLETCHING = 70,
            },
            quests = { "LEGACY_OF_SEERGAZE", "PLAGUES_END" },
        },
        min_training_level = 80,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CRAFTING",
            },
            {
                type = "training",
                skill = "CONSTRUCTION",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "SKILLING_OFFHAND_MEASURE" },
            },
        },
        priority = 2,
    },
}
