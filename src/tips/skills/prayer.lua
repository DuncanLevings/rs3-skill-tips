-- useful equipment and unlocks, then main methods and alternatives in level order.
-- access and recommendation-window evidence: docs/support-coverage.md.

return {
    {
        id = "prayer.first_age",
        icon_item = "WOF36_SKILL_PRAYER_TIARA",
        kind = "convenience",
        skills = { "PRAYER" },
        members = true,
        title = "First age outfit",
        hook = "The First age outfit adds experience to many Prayer training methods.",
        why = "Each piece contributes. It does not boost the Ectofuntus itself, urns or God Statue rewards; a modified tiara can also save offerings.",
        how = { "Spend ecto-tokens with the shady ghost at the Ectofuntus." },
        requirements = {
            skills = {
                PRAYER = 1,
            },
        },
        min_training_level = 30,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "PRAYER",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH58_PRAYER_HEAD_ADDON",
                    "TRH58_PRAYER_HEAD_UPGRADED",
                    "WOF36_SKILL_PRAYER_AMULET",
                    "WOF36_SKILL_PRAYER_BRACELET",
                    "WOF36_SKILL_PRAYER_CAPE",
                    "WOF36_SKILL_PRAYER_RING",
                    "WOF36_SKILL_PRAYER_TIARA",
                },
            },
        },
        priority = 2,
    },

    {
        id = "prayer.bonecrusher",
        icon_item = "RAND_REWARD_BONECRUSHER",
        kind = "convenience",
        skills = { "PRAYER" },
        members = true,
        title = "Bonecrusher",
        hook = "A bonecrusher can turn ordinary bone drops into passive Prayer experience.",
        why = "Carry it to bury supported bones automatically, choosing which bone types it should handle.",
        how = { "Look in the Dungeoneering rewards shop." },
        requirements = {
            skills = {
                PRAYER = 21,
                DUNGEONEERING = 21,
            },
        },
        min_training_level = 40,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "PRAYER",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "RAND_REWARD_BONECRUSHER" },
            },
        },
        priority = 2,
    },

    {
        id = "prayer.ectoplasmator",
        icon_item = "HW2012_ECTOPLASMATOR",
        kind = "convenience",
        skills = { "PRAYER" },
        members = true,
        title = "Ectoplasmator",
        hook = "An ectoplasmator offers Prayer experience from encounters with ghosts.",
        why = "The attuned upgrade can also scatter dropped ashes automatically, using ghostly essence for charges.",
        how = {
            "Look for the device among ghost drops, then inspect the attuned upgrade when you want to develop it further.",
        },
        requirements = {
            skills = {
                PRAYER = 1,
            },
        },
        min_training_level = 50,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "PRAYER",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "HW2012_ECTOPLASMATOR",
                    "HW2012_ECTOPLASMATOR_UPGRADED",
                    "HW2012_ECTOPLASMATOR_UPGRADED_EMPTY",
                },
            },
        },
        priority = 2,
    },

    {
        id = "prayer.cape",
        icon_item = "SKILLCAPE_PRAYER",
        kind = "convenience",
        skills = { "PRAYER" },
        members = true,
        title = "Prayer cape",
        hook = "The Prayer cape simplifies training at player-owned house altars.",
        why = "It supplies the effect of two lit incense burners there, without needing to light them yourself.",
        how = { "Buy it from Brother Jered at the Edgeville Monastery." },
        requirements = {
            skills = {
                PRAYER = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "PRAYER",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_INVERTED_PRAYER_HOODED",
                    "SKILLCAPE_INVERTED_PRAYER_TRIMMED_HOODED",
                    "SKILLCAPE_PRAYER",
                    "SKILLCAPE_PRAYER_HOODED",
                    "SKILLCAPE_PRAYER_HOODED_RETRO",
                    "SKILLCAPE_PRAYER_RETRO",
                    "SKILLCAPE_PRAYER_TRIMMED",
                    "SKILLCAPE_PRAYER_TRIMMED_HOODED",
                    "SKILLCAPE_PRAYER_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_PRAYER_TRIMMED_RETRO",
                },
            },
        },
        priority = 2,
    },

    {
        id = "prayer.method.altars",
        main_method = true,
        icon_item_id = 536,
        kind = "method",
        skills = { "PRAYER" },
        level_range = { 30, 74 },
        members = true,
        title = "Offering bones at altars",
        hook = "A suitable altar can give more experience from the same bones.",
        why = "Using a gilded altar in another player's house avoids needing to build one yourself.",
        how = { "Look for a hosted gilded altar with lit burners and try a small batch of bones." },
        requirements = {
            skills = {
                PRAYER = 1,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "PRAYER",
                level = 30,
            },
        },
        priority = 2,
    },

    {
        id = "prayer.method.cleansing",
        main_method = true,
        icon_item_id = 32615,
        kind = "method",
        skills = { "PRAYER" },
        level_range = { 75, 99 },
        members = true,
        title = "Cleansing crystals",
        hook = "Cleansing crystals offer Prayer training with little banking.",
        why = "The ritual takes longer than an active bone-offering route, but lets you train in place with a more relaxed rhythm.",
        how = { "Speak to a Hefin monk inside the Prifddinas cathedral." },
        quest_how = {
            "Work towards Plague's End to open up Prifddinas and its training facilities.",
        },
        requirements = {
            skills = {
                PRAYER = 75,
                AGILITY = 75,
                CONSTRUCTION = 75,
                CRAFTING = 75,
                DUNGEONEERING = 75,
                HERBLORE = 75,
                MINING = 75,
                RANGED = 75,
                SUMMONING = 75,
                WOODCUTTING = 75,
                COOKING = 30,
                FLETCHING = 70,
                THIEVING = 50,
            },
            quests = { "PLAGUES_END" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "PRAYER",
                level = 75,
            },
        },
        priority = 2,
    },

    {
        id = "prayer.alt.sand",
        icon_item_id = 48674,
        kind = "method",
        skills = { "PRAYER" },
        level_range = { 20, 49 },
        members = true,
        title = "Blessing sand",
        hook = "Blessing sand offers low-intensity Prayer training without using bones.",
        why = "The materials stack, so little banking is needed. Experience is much slower than bone-offering methods.",
        how = { "Try blessing extra fine sand at a Saradominist altar, such as Lumbridge church." },
        requirements = {
            skills = {
                PRAYER = 20,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "PRAYER",
            },
        },
        priority = 3,
    },

    {
        id = "prayer.alt.ectofuntus",
        icon_item_id = 526,
        kind = "method",
        skills = { "PRAYER" },
        level_range = { 20, 40 },
        members = true,
        title = "Ectofuntus",
        hook = "The Ectofuntus trades more preparation for extra experience from your offerings.",
        why = "Worship also earns ecto-tokens, which can go towards the First age outfit.",
        how = {
            "Look into slime and bonemeal at the Ectofuntus north of Port Phasmatys. A ghostspeak amulet helps with its ghosts.",
        },
        requirements = {
            skills = {
                PRAYER = 1,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "PRAYER",
            },
        },
        priority = 3,
    },

    {
        id = "prayer.alt.fort_chapel",
        icon_item_id = 536,
        kind = "method",
        skills = { "PRAYER" },
        level_range = { 30, 99 },
        members = true,
        title = "Fort Forinthry chapel",
        hook = "The Fort chapel offers an altar with a bank nearby.",
        why = "Offering bones or ashes there gives extra experience, and upgrading the chapel improves its benefits.",
        how = {
            "After New Foundations, inspect the chapel and its building plans at Fort Forinthry.",
        },
        quest_how = {
            "Start building Fort Forinthry through New Foundations, then explore its building plans.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 15,
                PRAYER = 1,
            },
            quests = { "QUEST_FORT_INTRO" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "PRAYER",
            },
        },
        priority = 3,
    },

    {
        id = "prayer.alt.statues",
        icon_item_id = 526,
        kind = "method",
        skills = { "PRAYER" },
        level_range = { 30, 99 },
        members = true,
        title = "God Statues",
        hook = "God Statues offer a monthly Prayer side activity.",
        why = "Building a statue favoured by the local people can provide a Prayer reward alongside Construction experience.",
        how = {
            "After Let Them Eat Pie, speak to Copernicus Glyph near the Taverley Summoning shop.",
        },
        quest_how = {
            "Complete Let Them Eat Pie, then ask Copernicus Glyph near Taverley about God Statues.",
        },
        requirements = {
            skills = {
                PRAYER = 1,
            },
            quests = { "LET_THEM_EAT_PIE" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "PRAYER",
            },
        },
        priority = 3,
    },

    {
        id = "prayer.alt.nemi",
        icon_item_id = 526,
        kind = "method",
        skills = { "PRAYER" },
        level_range = { 30, 79 },
        members = true,
        title = "Nemi Forest",
        hook = "Nemi Forest offers a free daily side trip for Prayer experience.",
        why = "Its gathering nodes give several kinds of experience, including Prayer. The forest changes, so finding the nodes is part of the activity.",
        how = { "Look for the forest entrances near the Mazcab guides." },
        requirements = {
            skills = {
                PRAYER = 1,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "PRAYER",
            },
        },
        priority = 3,
    },
}
