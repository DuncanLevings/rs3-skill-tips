-- tips that help more than one skill. each one lists every skill it applies to and triggers on
-- training any of them, the catalogue indexes it under each

return {
    {
        skills = {
            "MINING",
            "WOODCUTTING",
            "FISHING",
            "HUNTER",
            "DIVINATION",
            "ARCHAEOLOGY",
            "FARMING",
            "SMITHING",
            "CRAFTING",
            "FLETCHING",
            "COOKING",
            "HERBLORE",
            "FIREMAKING",
            "RUNECRAFTING",
            "CONSTRUCTION",
            "AGILITY",
            "THIEVING",
            "PRAYER",
            "SUMMONING",
        },
        priority = 2,
        title = "Brooch of the Gods",
        known_when = {
            {
                items = {
                    "ENCHANTED_ALCHEMICAL_HYDRIX_BROOCH",
                    "ENCHANTED_ALCHEMICAL_HYDRIX_BROOCH_USED",
                },
                type = "owns_any",
            },
        },
        how = {
            "Enchant an alchemical hydrix brooch with Lvl-6 Enchant, or a Lvl-6 enchant tablet.",
        },
        triggers = {
            {
                type = "training",
                skill = "MINING",
            },
            {
                type = "training",
                skill = "WOODCUTTING",
            },
            {
                type = "training",
                skill = "FISHING",
            },
            {
                type = "training",
                skill = "HUNTER",
            },
            {
                type = "training",
                skill = "DIVINATION",
            },
            {
                type = "training",
                skill = "ARCHAEOLOGY",
            },
            {
                type = "training",
                skill = "FARMING",
            },
            {
                type = "training",
                skill = "SMITHING",
            },
            {
                type = "training",
                skill = "CRAFTING",
            },
            {
                type = "training",
                skill = "FLETCHING",
            },
            {
                type = "training",
                skill = "COOKING",
            },
            {
                type = "training",
                skill = "HERBLORE",
            },
            {
                type = "training",
                skill = "FIREMAKING",
            },
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
            {
                type = "training",
                skill = "CONSTRUCTION",
            },
            {
                type = "training",
                skill = "AGILITY",
            },
            {
                type = "training",
                skill = "THIEVING",
            },
            {
                type = "training",
                skill = "PRAYER",
            },
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        icon_item = "ENCHANTED_ALCHEMICAL_HYDRIX_BROOCH",
        members = true,
        id = "mining.brooch_of_the_gods",
        min_training_level = 80,
        hook = "The Brooch of the Gods offers bonuses across several skilling activities.",
        kind = "convenience",
        why = "This pocket-slot item stores supported urns and improves some skilling rewards. With Invention unlocked, it can also summon divine blessings containing materials.",
    },

    {
        id = "shared.grace_of_the_elves",
        -- gate on whichever gathering skill is active, rather than every gathering skill.
        min_training_level = 80,
        kind = "convenience",
        skills = { "MINING", "WOODCUTTING", "FISHING", "ARCHAEOLOGY" },
        members = true,
        title = "Grace of the elves",
        icon_item = "ALCH_ONYX_SKILL_NECKLACE",
        hook = "Tired of banking? Grace of the elves sends what you gather straight to your bank.",
        why = "It holds porter charges, so gathered resources can go straight to your bank. It can also summon Seren spirits while you skill.",
        how = {
            "Enchant an alchemical onyx necklace with Lvl-6 Enchant, then charge it with signs "
                .. "of the porter.",
        },
        triggers = {
            { type = "training", skill = "MINING" },
            { type = "training", skill = "WOODCUTTING" },
            { type = "training", skill = "FISHING" },
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "ALCH_ONYX_SKILL_NECKLACE", "ALCH_ONYX_SKILL_NECKLACE_USED" },
            },
        },
        priority = 2,
    },

    {
        id = "shared.ring_of_whispers",
        kind = "convenience",
        skills = {
            "MINING",
            "WOODCUTTING",
            "FISHING",
            "HUNTER",
            "DIVINATION",
            "ARCHAEOLOGY",
            "FARMING",
        },
        members = true,
        title = "Ring of Whispers",
        icon_item = "QUEST_ENDGAME_SHADOW_RING",
        hook = "The Ring of Whispers quietly boosts your gathering skills.",
        why = "Wear it for an invisible boost to Fishing, Hunter, Divination, Farming and Archaeology. "
            .. "It also improves Mining damage and Woodcutting success.",
        how = { "It's a reward from Sliske's Endgame." },
        quest_how = { "Look into Sliske's Endgame and its lasting skilling rewards." },
        requirements = {
            quests = { "SLISKES_ENDGAME" },
            skills = {
                AGILITY = 80,
                THIEVING = 66,
                DIVINATION = 80,
                MAGIC = 81,
                SLAYER = 80,
                SUMMONING = 75,
                HERBLORE = 80,
                CONSTRUCTION = 75,
                CRAFTING = 80,
                DUNGEONEERING = 75,
                MINING = 75,
                PRAYER = 80,
                RANGED = 75,
                WOODCUTTING = 80,
                COOKING = 35,
                FLETCHING = 70,
                FIREMAKING = 71,
                RUNECRAFTING = 50,
                SMITHING = 70,
                STRENGTH = 79,
                HUNTER = 65,
                FARMING = 25,
                DEFENCE = 72,
                ATTACK = 79,
                FISHING = 36,
                HITPOINTS = 78,
            },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "MINING" },
            { type = "training", skill = "WOODCUTTING" },
            { type = "training", skill = "FISHING" },
            { type = "training", skill = "HUNTER" },
            { type = "training", skill = "DIVINATION" },
            { type = "training", skill = "ARCHAEOLOGY" },
            { type = "training", skill = "FARMING" },
        },
        known_when = {
            {
                items = { "QUEST_ENDGAME_SHADOW_RING" },
                type = "owns_any",
            },
            {
                type = "quest_done",
                quest = "SLISKES_ENDGAME",
            },
        },
        priority = 2,
    },

    {
        how = {
            "Earn it from the Gate of Elidinis after Ode of the Devourer, or buy one on the Grand Exchange.",
        },
        skills = {
            "MINING",
            "WOODCUTTING",
            "FISHING",
            "HUNTER",
            "DIVINATION",
            "ARCHAEOLOGY",
            "FARMING",
            "SMITHING",
            "CRAFTING",
            "FLETCHING",
            "COOKING",
            "HERBLORE",
            "FIREMAKING",
            "RUNECRAFTING",
            "CONSTRUCTION",
            "AGILITY",
            "THIEVING",
            "PRAYER",
            "SUMMONING",
        },
        priority = 2,
        hook = "The Scripture of Elidinis gives you extra experience while you skill.",
        title = "Scripture of Elidinis",
        quest_how = {
            "Work towards Ode of the Devourer to reach the Gate of Elidinis and its rewards.",
        },
        requirements = {
            skills = {
                MAGIC = 66,
                COOKING = 20,
                AGILITY = 25,
                ARCHAEOLOGY = 86,
                CONSTRUCTION = 54,
                SLAYER = 10,
                NECROMANCY = 75,
                PRAYER = 40,
            },
            quests = { "QUEST_AMASCUT" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "MINING",
            },
            {
                type = "training",
                skill = "WOODCUTTING",
            },
            {
                type = "training",
                skill = "FISHING",
            },
            {
                type = "training",
                skill = "HUNTER",
            },
            {
                type = "training",
                skill = "DIVINATION",
            },
            {
                type = "training",
                skill = "ARCHAEOLOGY",
            },
            {
                type = "training",
                skill = "FARMING",
            },
            {
                type = "training",
                skill = "SMITHING",
            },
            {
                type = "training",
                skill = "CRAFTING",
            },
            {
                type = "training",
                skill = "FLETCHING",
            },
            {
                type = "training",
                skill = "COOKING",
            },
            {
                type = "training",
                skill = "HERBLORE",
            },
            {
                type = "training",
                skill = "FIREMAKING",
            },
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
            {
                type = "training",
                skill = "CONSTRUCTION",
            },
            {
                type = "training",
                skill = "AGILITY",
            },
            {
                type = "training",
                skill = "THIEVING",
            },
            {
                type = "training",
                skill = "PRAYER",
            },
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        icon_item = "ELIDINIS_BOSS_ELIDINIS_BOOK",
        known_when = {
            {
                items = {
                    "ELIDINIS_BOSS_ELIDINIS_BOOK",
                    "ELIDINIS_BOSS_ELIDINIS_BOOK_UNLOCK_TOKEN",
                },
                type = "owns_any",
            },
        },
        id = "shared.scripture_of_elidinis",
        min_training_level = 80,
        members = true,
        kind = "convenience",
        why = "Worn in your pocket slot, it now and then spawns a soul that gives experience when you catch it, on top of your other boosts.",
    },

    {
        kind = "general",
        require_all_levels = true,
        priority = 3,
        members = true,
        skills = { "MINING", "WOODCUTTING", "FISHING", "HUNTER" },
        title = "Crystallise and Light Form",
        triggers = {
            {
                type = "training",
                skill = "MINING",
            },
            {
                type = "training",
                skill = "WOODCUTTING",
            },
            {
                type = "training",
                skill = "FISHING",
            },
            {
                type = "training",
                skill = "HUNTER",
            },
        },
        icon_item_id = 566,
        id = "shared.crystallise",
        how = {
            "Crystallise needs 88 Magic, and Light Form needs 80 Prayer. Both come with The Light Within.",
        },
        why = "For 30 seconds you gain extra experience from it, but no resources. The Light Form curse doubles that bonus.",
        quest_how = { "Look into The Light Within for access to its Seren spells and prayers." },
        requirements = {
            skills = {
                MAGIC = 88,
                PRAYER = 80,
                AGILITY = 80,
                CRAFTING = 80,
                DIVINATION = 80,
                HERBLORE = 80,
                SLAYER = 80,
                WOODCUTTING = 80,
                CONSTRUCTION = 75,
                FLETCHING = 70,
                RANGED = 75,
                FIREMAKING = 50,
                THIEVING = 66,
                RUNECRAFTING = 50,
                SMITHING = 65,
                SUMMONING = 75,
                DUNGEONEERING = 75,
                MINING = 75,
                COOKING = 35,
                STRENGTH = 64,
                HUNTER = 51,
                FARMING = 25,
            },
            quests = { "SEREN" },
        },
        hook = "Crystallise trades gathered resources for extra experience on supported spots and Hunter traps.",
    },

    {
        id = "shared.urn_enhancer",
        skills = {
            "MINING",
            "WOODCUTTING",
            "FISHING",
            "HUNTER",
            "DIVINATION",
            "FARMING",
            "SMITHING",
            "FIREMAKING",
            "COOKING",
            "RUNECRAFTING",
            "PRAYER",
        },
        priority = 2,
        hook = "An urn enhancer offers more experience from urns you already use.",
        title = "Urn enhancer",
        quest_how = { "Work towards Nomad's Elegy to unlock the Invention device." },
        requirements = {
            skills = {
                INVENTION = 24,
                CONSTRUCTION = 75,
                MINING = 75,
                WOODCUTTING = 75,
                HERBLORE = 49,
                HUNTER = 65,
                SUMMONING = 55,
                THIEVING = 54,
                RUNECRAFTING = 25,
                ATTACK = 79,
                STRENGTH = 79,
                PRAYER = 70,
                AGILITY = 46,
                CRAFTING = 70,
                FIREMAKING = 71,
                MAGIC = 80,
                FISHING = 36,
                SMITHING = 70,
                FLETCHING = 25,
                HITPOINTS = 78,
                DEFENCE = 72,
                SLAYER = 69,
            },
            quests = { "NOMADS_ELEGY" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "MINING",
            },
            {
                type = "training",
                skill = "WOODCUTTING",
            },
            {
                type = "training",
                skill = "FISHING",
            },
            {
                type = "training",
                skill = "HUNTER",
            },
            {
                type = "training",
                skill = "DIVINATION",
            },
            {
                type = "training",
                skill = "FARMING",
            },
            {
                type = "training",
                skill = "SMITHING",
            },
            {
                type = "training",
                skill = "FIREMAKING",
            },
            {
                type = "training",
                skill = "COOKING",
            },
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
            {
                type = "training",
                skill = "PRAYER",
            },
        },
        icon_item = "NOMEL_SOUL_GENERATOR",
        members = true,
        how = { "After Nomad's Elegy, discover and build it through Invention." },
        min_training_level = 30,
        known_when = {
            {
                items = { "NOMEL_SOUL_GENERATOR" },
                type = "owns_any",
            },
        },
        kind = "convenience",
        why = "Keep this reusable device in your backpack to improve urn rewards, using energy from your charge pack.",
    },
}
