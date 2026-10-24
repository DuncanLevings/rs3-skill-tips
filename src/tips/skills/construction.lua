-- useful items and unlocks, then main methods and alternatives in level order.
-- source access and recommendation windows: docs/artisan-coverage.md.

return {
    {
        id = "construction.constructor_outfit",
        icon_item = "TT2_CONSTRUCTION_HAT",
        kind = "convenience",
        skills = { "CONSTRUCTION" },
        members = true,
        title = "Constructor's outfit",
        hook = "The constructor's outfit adds experience to your building projects.",
        why = "Each piece contributes, with an extra bonus for wearing the full set.",
        how = { "Level your Temple Trekking companions and claim their outfit rewards." },
        requirements = {
            skills = {
                CONSTRUCTION = 44,
            },
            quests = { "DARKNESS_OF_HALLOWVALE" },
        },
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "CONSTRUCTION",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TT2_CONSTRUCTION_BODY",
                    "TT2_CONSTRUCTION_BOOTS",
                    "TT2_CONSTRUCTION_GLOVES",
                    "TT2_CONSTRUCTION_HAT",
                    "TT2_CONSTRUCTION_LEGS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "construction.master_outfit",
        icon_item = "CON_ELITE_SKILLING_HAT",
        kind = "convenience",
        skills = { "CONSTRUCTION" },
        members = true,
        title = "Master constructor's outfit",
        hook = "The master constructor's outfit helps keep Construction Contracts moving.",
        why = "Its full set speeds repairs and offers teleports to your current contract and estate agents.",
        how = { "Spend contract credits in the Estate Agents Shop." },
        requirements = {
            skills = {
                CONSTRUCTION = 40,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CONSTRUCTION",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "CON_ELITE_SKILLING_BODY",
                    "CON_ELITE_SKILLING_BOOTS",
                    "CON_ELITE_SKILLING_GLOVES",
                    "CON_ELITE_SKILLING_HAT",
                    "CON_ELITE_SKILLING_LEGS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "construction.plank_box",
        icon_item = "CON_TOOLKIT",
        kind = "convenience",
        skills = { "CONSTRUCTION" },
        members = true,
        title = "Plank box",
        hook = "A plank box carries more building supplies between bank trips.",
        why = "Building uses the stored planks automatically. Capacity upgrades make longer trips possible.",
        how = {
            "Earn contract credits through Construction Contracts, then visit the Estate Agents Shop.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 40,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CONSTRUCTION",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "CON_TOOLKIT" },
            },
        },
        priority = 2,
    },

    {
        id = "construction.crystal_saw",
        icon_item = "EYEGLO_CRYSTAL_SAW",
        kind = "convenience",
        skills = { "CONSTRUCTION" },
        members = true,
        title = "Crystal saw",
        hook = "A crystal saw can put some building projects within reach a little sooner.",
        why = "It gives an invisible Construction boost for supported furniture that needs a saw.",
        how = { "After The Eyes of Glouphrie, sing the crystal seed at Brimstail's singing bowl." },
        requirements = {
            skills = {
                CONSTRUCTION = 1,
            },
            quests = { "EYES_OF_GLOUPHRIE" },
        },
        min_training_level = 40,
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "CONSTRUCTION",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "ELFCITY_CRYSTAL_SAW_100",
                    "ELFCITY_CRYSTAL_SAW_50",
                    "EYEGLO_CRYSTAL_SAW",
                },
            },
        },
        priority = 2,
    },

    {
        id = "construction.proficiency",
        icon_item_id = 8780,
        kind = "general",
        skills = { "CONSTRUCTION" },
        members = true,
        title = "Scroll of proficiency",
        hook = "The scroll of proficiency can save planks on larger furniture projects.",
        why = "Its permanent effect gives a chance to save a plank when building supported furniture.",
        how = { "Look in the Dungeoneering rewards shop." },
        requirements = {
            skills = {
                CONSTRUCTION = 60,
                DUNGEONEERING = 60,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CONSTRUCTION",
            },
        },
        priority = 2,
    },

    {
        id = "construction.cape",
        icon_item = "SKILLCAPE_CONSTRUCTION",
        kind = "convenience",
        skills = { "CONSTRUCTION" },
        members = true,
        title = "Construction cape",
        hook = "The Construction cape offers a chance to save planks.",
        why = "Its perk can save a plank while building supported furniture, including during Construction Contracts.",
        how = { "Buy it from an estate agent." },
        requirements = {
            skills = {
                CONSTRUCTION = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CONSTRUCTION",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_120_CONSTRUCTION",
                    "SKILLCAPE_CONSTRUCTION",
                    "SKILLCAPE_CONSTRUCTION_HOODED",
                    "SKILLCAPE_CONSTRUCTION_HOODED_RETRO",
                    "SKILLCAPE_CONSTRUCTION_RETRO",
                    "SKILLCAPE_CONSTRUCTION_TRIMMED",
                    "SKILLCAPE_CONSTRUCTION_TRIMMED_HOODED",
                    "SKILLCAPE_CONSTRUCTION_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_CONSTRUCTION_TRIMMED_RETRO",
                    "SKILLCAPE_INVERTED_CONSTRUCTION_HOODED",
                    "SKILLCAPE_INVERTED_CONSTRUCTION_TRIMMED_HOODED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "construction.master_cape",
        icon_item = "SKILLCAPE_120_CONSTRUCTION",
        kind = "convenience",
        skills = { "CONSTRUCTION" },
        members = true,
        title = "Construction master cape",
        hook = "The Construction master cape improves both plank-making and building.",
        why = "It speeds up making planks and improves the chance to save them when building furniture.",
        how = { "Buy it from an estate agent after reaching true skill mastery." },
        requirements = {
            skills = {
                CONSTRUCTION = 120,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CONSTRUCTION",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "SKILLCAPE_120_CONSTRUCTION" },
            },
        },
        priority = 2,
    },

    {
        id = "construction.method.wooden_furniture",
        main_method = true,
        icon_item_id = 960,
        kind = "method",
        skills = { "CONSTRUCTION" },
        level_range = { 6, 32 },
        members = true,
        title = "Wooden furniture",
        hook = "Wooden furniture offer a furniture-building project at this stage.",
        why = "The finished furniture can be kept or traded. Material costs can differ substantially between projects.",
        how = {
            "Inspect a furniture workbench and try a small batch before investing in supplies.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 6,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "CONSTRUCTION",
                level = 6,
            },
        },
        priority = 2,
    },

    {
        id = "construction.method.oak_larders",
        main_method = true,
        icon_item_id = 8778,
        kind = "method",
        skills = { "CONSTRUCTION" },
        level_range = { 33, 55 },
        members = true,
        title = "Oak larders",
        hook = "Oak larders offer a furniture-building project at this stage.",
        why = "The finished furniture can be kept or traded. Material costs can differ substantially between projects.",
        how = {
            "Inspect a furniture workbench and try a small batch before investing in supplies.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 33,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "CONSTRUCTION",
                level = 33,
            },
        },
        priority = 2,
    },

    {
        id = "construction.method.teak_tables",
        main_method = true,
        icon_item_id = 8780,
        kind = "method",
        skills = { "CONSTRUCTION" },
        level_range = { 56, 71 },
        members = true,
        title = "Teak tables",
        hook = "Teak tables offer a furniture-building project at this stage.",
        why = "The finished furniture can be kept or traded. Material costs can differ substantially between projects.",
        how = {
            "Inspect a furniture workbench and try a small batch before investing in supplies.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 56,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "CONSTRUCTION",
                level = 56,
            },
        },
        priority = 2,
    },

    {
        id = "construction.method.mahogany_tables",
        main_method = true,
        icon_item_id = 8782,
        kind = "method",
        skills = { "CONSTRUCTION" },
        level_range = { 72, 79 },
        members = true,
        title = "Mahogany tables",
        hook = "Mahogany tables offer a furniture-building project at this stage.",
        why = "The finished furniture can be kept or traded. Material costs can differ substantially between projects.",
        how = {
            "Inspect a furniture workbench and try a small batch before investing in supplies.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 72,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "CONSTRUCTION",
                level = 72,
            },
        },
        priority = 2,
    },

    {
        id = "construction.method.potion_cauldrons",
        main_method = true,
        icon_item_id = 44842,
        kind = "method",
        skills = { "CONSTRUCTION" },
        level_range = { 80, 105 },
        members = true,
        title = "Potion cauldrons",
        hook = "Potion cauldrons offer a furniture-building project at this stage.",
        why = "The finished furniture can be kept or traded. Material costs can differ substantially between projects.",
        how = {
            "Inspect a furniture workbench and try a small batch before investing in supplies.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 80,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "CONSTRUCTION",
                level = 80,
            },
        },
        priority = 2,
    },

    {
        id = "construction.method.eternal_furniture",
        main_method = true,
        icon_item_id = 63190,
        kind = "method",
        skills = { "CONSTRUCTION" },
        level_range = { 106, 120 },
        members = true,
        title = "Eternal furniture",
        hook = "Eternal furniture offer a furniture-building project at this stage.",
        why = "The finished furniture can be kept or traded. Material costs can differ substantially between projects.",
        how = {
            "Inspect a furniture workbench and try a small batch before investing in supplies.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 106,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "CONSTRUCTION",
                level = 106,
            },
        },
        priority = 2,
    },

    {
        id = "construction.alt.statues",
        icon_item_id = 960,
        kind = "method",
        skills = { "CONSTRUCTION" },
        level_range = { 20, 120 },
        members = true,
        title = "God Statues",
        hook = "God Statues offer a monthly Construction break from buying building materials.",
        why = "Help assemble the scaffolding for a statue to earn a level-scaled experience reward.",
        how = {
            "After Let Them Eat Pie, speak to Copernicus Glyph near the Taverley Summoning shop.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 20,
            },
            quests = { "LET_THEM_EAT_PIE" },
        },
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "CONSTRUCTION",
            },
        },
        priority = 3,
    },

    {
        id = "construction.alt.contracts",
        icon_item_id = 8778,
        kind = "method",
        skills = { "CONSTRUCTION" },
        level_range = { 40, 120 },
        members = true,
        title = "Construction Contracts",
        hook = "Construction Contracts offer a change of scenery between building projects.",
        why = "Repair furniture around Gielinor for experience and credits towards a plank box or master outfit. Higher planks improve later contracts.",
        how = { "Ask any estate agent about a contract." },
        requirements = {
            skills = {
                CONSTRUCTION = 40,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CONSTRUCTION",
            },
        },
        priority = 3,
    },

    {
        id = "construction.alt.fort",
        icon_item_id = 8780,
        kind = "method",
        skills = { "CONSTRUCTION" },
        level_range = { 40, 119 },
        members = true,
        title = "Fort Forinthry",
        hook = "Fort Forinthry combines Construction training with an account base you can improve.",
        why = "Buildings and upgrades provide lasting benefits, with more projects opening as you progress.",
        how = { "After New Foundations, check the construction plans at the fort." },
        requirements = {
            skills = {
                CONSTRUCTION = 40,
            },
            quests = { "QUEST_FORT_INTRO" },
        },
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "CONSTRUCTION",
            },
        },
        priority = 3,
    },
}
