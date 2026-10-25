-- construction tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field

return {
    -- useful items and unlocks
    {
        id = "construction.constructor_outfit",
        kind = "convenience",
        skills = { "CONSTRUCTION" },
        members = true,
        title = "Constructor's outfit",
        icon_item = "TT2_CONSTRUCTION_HAT",
        hook = "The constructor's outfit adds experience to your building projects.",
        why = "Each piece contributes, with an extra bonus for wearing the full set.",
        how = {
            "Level your Temple Trekking companions and claim their outfit rewards.",
        },
        quest_how = {
            "Work towards The Darkness of Hallowvale to open the Burgh de Rott Ramble route.",
        },
        requirements = {
            skills = {
                AGILITY = 26,
                CONSTRUCTION = 44,
                CRAFTING = 32,
                MAGIC = 33,
                MINING = 20,
                STRENGTH = 40,
                THIEVING = 22,
            },
            quests = { "DARKNESS_OF_HALLOWVALE" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CONSTRUCTION" },
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
        kind = "convenience",
        skills = { "CONSTRUCTION" },
        members = true,
        title = "Master constructor's outfit",
        icon_item = "CON_ELITE_SKILLING_HAT",
        hook = "The master constructor's outfit helps keep Construction Contracts moving.",
        why = "Its full set speeds repairs and offers teleports to your current contract and "
            .. "estate agents.",
        how = {
            "Spend contract credits in the Estate Agents Shop.",
        },
        requirements = {
            skills = { CONSTRUCTION = 40 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CONSTRUCTION" },
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
        kind = "convenience",
        skills = { "CONSTRUCTION" },
        members = true,
        title = "Plank box",
        icon_item = "CON_TOOLKIT",
        hook = "A plank box carries more building supplies between bank trips.",
        why = "Building uses the stored planks automatically. Capacity upgrades make longer trips "
            .. "possible.",
        how = {
            "Earn contract credits through Construction Contracts, then visit the Estate Agents "
                .. "Shop.",
        },
        requirements = {
            skills = { CONSTRUCTION = 40 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CONSTRUCTION" },
        },
        known_when = {
            { type = "owns_any", items = { "CON_TOOLKIT" } },
        },
        priority = 2,
    },

    {
        id = "construction.crystal_saw",
        kind = "convenience",
        skills = { "CONSTRUCTION" },
        members = true,
        min_training_level = 40,
        title = "Crystal saw",
        icon_item = "EYEGLO_CRYSTAL_SAW",
        hook = "A crystal saw can put some building projects within reach a little sooner.",
        why = "It gives an invisible Construction boost for supported furniture that needs a saw.",
        how = {
            "After The Eyes of Glouphrie, sing the crystal seed at Brimstail's singing bowl.",
        },
        quest_how = {
            "Look into The Eyes of Glouphrie and its crystal seed reward, then visit Brimstail's "
                .. "singing bowl.",
        },
        requirements = {
            skills = { AGILITY = 25, CONSTRUCTION = 5, MAGIC = 46 },
            quests = { "EYES_OF_GLOUPHRIE" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CONSTRUCTION" },
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
        kind = "general",
        skills = { "CONSTRUCTION" },
        members = true,
        title = "Scroll of proficiency",
        icon_item_id = 8780,
        hook = "The scroll of proficiency can save planks on larger furniture projects.",
        why = "Its permanent effect gives a chance to save a plank when building supported "
            .. "furniture.",
        how = {
            "Look in the Dungeoneering rewards shop.",
        },
        requirements = {
            skills = { CONSTRUCTION = 60, DUNGEONEERING = 60 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CONSTRUCTION" },
        },
        priority = 2,
    },

    {
        id = "construction.cape",
        kind = "convenience",
        skills = { "CONSTRUCTION" },
        members = true,
        title = "Construction cape",
        icon_item = "SKILLCAPE_CONSTRUCTION",
        hook = "The Construction cape offers a chance to save planks.",
        why = "Its perk can save a plank while building supported furniture, including during "
            .. "Construction Contracts.",
        how = {
            "Buy it from an estate agent.",
        },
        requirements = {
            skills = { CONSTRUCTION = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CONSTRUCTION" },
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
        kind = "convenience",
        skills = { "CONSTRUCTION" },
        members = true,
        title = "Construction master cape",
        icon_item = "SKILLCAPE_120_CONSTRUCTION",
        hook = "The Construction master cape improves both plank-making and building.",
        why = "It speeds up making planks and improves the chance to save them when building "
            .. "furniture.",
        how = {
            "Buy it from an estate agent after reaching true skill mastery.",
        },
        requirements = {
            skills = { CONSTRUCTION = 120 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CONSTRUCTION" },
        },
        known_when = {
            { type = "owns_any", items = { "SKILLCAPE_120_CONSTRUCTION" } },
        },
        priority = 2,
    },

    -- training methods, one main method per level bracket
    {
        id = "construction.method.wooden_furniture",
        kind = "method",
        skills = { "CONSTRUCTION" },
        members = true,
        level_range = { 6, 32 },
        main_method = true,
        title = "Wooden furniture",
        icon_item_id = 960,
        hook = "Wooden furniture offer a furniture-building project at this stage.",
        why = "The finished furniture can be kept or traded. Material costs can differ "
            .. "substantially between projects.",
        how = {
            "Inspect a furniture workbench and try a small batch before investing in supplies.",
        },
        requirements = {
            skills = { CONSTRUCTION = 6 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "CONSTRUCTION", level = 6 },
        },
        priority = 2,
    },

    {
        id = "construction.method.oak_larders",
        kind = "method",
        skills = { "CONSTRUCTION" },
        members = true,
        level_range = { 33, 55 },
        main_method = true,
        title = "Oak larders",
        icon_item_id = 8778,
        hook = "Oak larders offer a furniture-building project at this stage.",
        why = "The finished furniture can be kept or traded. Material costs can differ "
            .. "substantially between projects.",
        how = {
            "Inspect a furniture workbench and try a small batch before investing in supplies.",
        },
        requirements = {
            skills = { CONSTRUCTION = 33 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "CONSTRUCTION", level = 33 },
        },
        priority = 2,
    },

    {
        id = "construction.method.teak_tables",
        kind = "method",
        skills = { "CONSTRUCTION" },
        members = true,
        level_range = { 56, 71 },
        main_method = true,
        title = "Teak tables",
        icon_item_id = 8780,
        hook = "Teak tables offer a furniture-building project at this stage.",
        why = "The finished furniture can be kept or traded. Material costs can differ "
            .. "substantially between projects.",
        how = {
            "Inspect a furniture workbench and try a small batch before investing in supplies.",
        },
        requirements = {
            skills = { CONSTRUCTION = 56 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "CONSTRUCTION", level = 56 },
        },
        priority = 2,
    },

    {
        id = "construction.method.mahogany_tables",
        kind = "method",
        skills = { "CONSTRUCTION" },
        members = true,
        level_range = { 72, 79 },
        main_method = true,
        title = "Mahogany tables",
        icon_item_id = 8782,
        hook = "Mahogany tables offer a furniture-building project at this stage.",
        why = "The finished furniture can be kept or traded. Material costs can differ "
            .. "substantially between projects.",
        how = {
            "Inspect a furniture workbench and try a small batch before investing in supplies.",
        },
        requirements = {
            skills = { CONSTRUCTION = 72 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "CONSTRUCTION", level = 72 },
        },
        priority = 2,
    },

    {
        id = "construction.method.potion_cauldrons",
        kind = "method",
        skills = { "CONSTRUCTION" },
        members = true,
        level_range = { 80, 105 },
        main_method = true,
        title = "Potion cauldrons",
        icon_item_id = 44842,
        hook = "Potion cauldrons offer a furniture-building project at this stage.",
        why = "The finished furniture can be kept or traded. Material costs can differ "
            .. "substantially between projects.",
        how = {
            "Inspect a furniture workbench and try a small batch before investing in supplies.",
        },
        requirements = {
            skills = { CONSTRUCTION = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "CONSTRUCTION", level = 80 },
        },
        priority = 2,
    },

    {
        id = "construction.method.eternal_furniture",
        kind = "method",
        skills = { "CONSTRUCTION" },
        members = true,
        level_range = { 106, 120 },
        main_method = true,
        title = "Eternal furniture",
        icon_item_id = 63190,
        hook = "Eternal furniture offer a furniture-building project at this stage.",
        why = "The finished furniture can be kept or traded. Material costs can differ "
            .. "substantially between projects.",
        how = {
            "Inspect a furniture workbench and try a small batch before investing in supplies.",
        },
        requirements = {
            skills = { CONSTRUCTION = 106 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "CONSTRUCTION", level = 106 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "construction.alt.statues",
        kind = "method",
        skills = { "CONSTRUCTION" },
        members = true,
        level_range = { 20, 120 },
        title = "God Statues",
        icon_item_id = 960,
        hook = "God Statues offer a monthly Construction break from buying building materials.",
        why = "Help assemble the scaffolding for a statue to earn a level-scaled experience "
            .. "reward.",
        how = {
            "After Let Them Eat Pie, speak to Copernicus Glyph near the Taverley Summoning shop.",
        },
        quest_how = {
            "Complete Let Them Eat Pie, then ask Copernicus Glyph near Taverley about God Statues.",
        },
        requirements = {
            skills = { CONSTRUCTION = 20 },
            quests = { "LET_THEM_EAT_PIE" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CONSTRUCTION" },
        },
        priority = 3,
    },

    {
        id = "construction.alt.contracts",
        kind = "method",
        skills = { "CONSTRUCTION" },
        members = true,
        level_range = { 40, 120 },
        title = "Construction Contracts",
        icon_item_id = 8778,
        hook = "Construction Contracts offer a change of scenery between building projects.",
        why = "Repair furniture around Gielinor for experience and credits towards a plank box or "
            .. "master outfit. Higher planks improve later contracts.",
        how = {
            "Ask any estate agent about a contract.",
        },
        requirements = {
            skills = { CONSTRUCTION = 40 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CONSTRUCTION" },
        },
        priority = 3,
    },

    {
        id = "construction.alt.fort",
        kind = "method",
        skills = { "CONSTRUCTION" },
        members = true,
        level_range = { 40, 119 },
        title = "Fort Forinthry",
        icon_item_id = 8780,
        hook = "Fort Forinthry combines Construction training with an account base you can "
            .. "improve.",
        why = "Buildings and upgrades provide lasting benefits, with more projects opening as you "
            .. "progress.",
        how = {
            "After New Foundations, check the construction plans at the fort.",
        },
        quest_how = {
            "Start building Fort Forinthry through New Foundations, then explore its building "
                .. "plans.",
        },
        requirements = {
            skills = { CONSTRUCTION = 40 },
            quests = { "QUEST_FORT_INTRO" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CONSTRUCTION" },
        },
        priority = 3,
    },
}
