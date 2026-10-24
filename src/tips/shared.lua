-- tips that help more than one skill. each one lists every skill it applies to and triggers on
-- training any of them, the catalogue indexes it under each

return {
    {
        why = "This pocket-slot item stores supported urns and improves some skilling rewards. With Invention unlocked, it can also summon divine blessings containing materials.",
        kind = "convenience",
        id = "mining.brooch_of_the_gods",
        hook = "The Brooch of the Gods offers bonuses across several skilling activities.",
        how = {
            "Enchant an alchemical hydrix brooch with Lvl-6 Enchant, or a Lvl-6 enchant tablet.",
        },
        icon_item = "ENCHANTED_ALCHEMICAL_HYDRIX_BROOCH",
        known_when = {
            {
                items = {
                    "ENCHANTED_ALCHEMICAL_HYDRIX_BROOCH",
                    "ENCHANTED_ALCHEMICAL_HYDRIX_BROOCH_USED",
                },
                type = "owns_any",
            },
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
        },
        title = "Brooch of the Gods",
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
        },
        members = true,
        priority = 2,
        min_training_level = 80,
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
        require_quests_complete = true,
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
        requirements = { quests = { "SLISKES_ENDGAME" } },
        triggers = {
            { type = "training", skill = "MINING" },
            { type = "training", skill = "WOODCUTTING" },
            { type = "training", skill = "FISHING" },
            { type = "training", skill = "HUNTER" },
            { type = "training", skill = "DIVINATION" },
            { type = "training", skill = "ARCHAEOLOGY" },
            { type = "training", skill = "FARMING" },
        },
        known_when = { { type = "owns_any", items = { "QUEST_ENDGAME_SHADOW_RING" } } },
        priority = 2,
    },

    {
        require_all_levels = true,
        require_quests_complete = true,
        requirements = {
            skills = {
                MAGIC = 66,
                ARCHAEOLOGY = 86,
                COOKING = 20,
                CONSTRUCTION = 54,
                PRAYER = 40,
                AGILITY = 25,
                SLAYER = 10,
                NECROMANCY = 75,
            },
            quests = { "QUEST_AMASCUT" },
        },
        kind = "convenience",
        how = {
            "Earn it from the Gate of Elidinis after Ode of the Devourer, or buy one on the Grand Exchange.",
        },
        id = "shared.scripture_of_elidinis",
        hook = "The Scripture of Elidinis gives you extra experience while you skill.",
        title = "Scripture of Elidinis",
        members = true,
        known_when = {
            {
                items = {
                    "ELIDINIS_BOSS_ELIDINIS_BOOK",
                    "ELIDINIS_BOSS_ELIDINIS_BOOK_UNLOCK_TOKEN",
                },
                type = "owns_any",
            },
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
        },
        why = "Worn in your pocket slot, it now and then spawns a soul that gives experience when you catch it, on top of your other boosts.",
        icon_item = "ELIDINIS_BOSS_ELIDINIS_BOOK",
        priority = 2,
        min_training_level = 80,
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
        require_quests_complete = true,
        why = "For 30 seconds you gain extra experience from it, but no resources. The Light Form curse doubles that bonus.",
        requirements = {
            skills = {
                PRAYER = 80,
                MAGIC = 88,
            },
            quests = { "SEREN" },
        },
        hook = "Crystallise trades gathered resources for extra experience on supported spots and Hunter traps.",
    },

    {
        require_all_levels = true,
        require_quests_complete = true,
        requirements = {
            skills = {
                INVENTION = 24,
            },
            quests = { "NOMADS_ELEGY" },
        },
        kind = "convenience",
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
        },
        id = "shared.urn_enhancer",
        hook = "An urn enhancer offers more experience from urns you already use.",
        why = "Keep this reusable device in your backpack to improve urn rewards, using energy from your charge pack.",
        members = true,
        known_when = {
            {
                items = { "NOMEL_SOUL_GENERATOR" },
                type = "owns_any",
            },
        },
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
        },
        title = "Urn enhancer",
        icon_item = "NOMEL_SOUL_GENERATOR",
        how = { "After Nomad's Elegy, discover and build it through Invention." },
        priority = 2,
        min_training_level = 30,
    },
}
