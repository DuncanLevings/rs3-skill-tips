-- fletching tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field

return {
    -- useful items and unlocks
    {
        id = "fletching.fletcher_outfit",
        kind = "convenience",
        skills = { "FLETCHING" },
        members = true,
        min_training_level = 30,
        title = "Fletcher's outfit",
        icon_item = "TRH85_FLETCHING_HEAD",
        hook = "The Fletcher's outfit adds experience to your fletching.",
        why = "Each piece contributes, with an extra bonus for wearing the full set.",
        how = {
            "The pieces are rewards from Stealing Creation or Stanley Limelight Traders.",
        },
        requirements = {
            skills = { FLETCHING = 1 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FLETCHING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH85_FLETCHING_BOOTS",
                    "TRH85_FLETCHING_HANDS",
                    "TRH85_FLETCHING_HEAD",
                    "TRH85_FLETCHING_LEGS",
                    "TRH85_FLETCHING_TORSO",
                },
            },
        },
        priority = 2,
    },

    {
        id = "fletching.crystal_knife",
        kind = "convenience",
        skills = { "FLETCHING" },
        members = true,
        min_training_level = 60,
        title = "Crystal knife",
        icon_item = "ELFCITY_CRYSTAL_KNIFE_100",
        hook = "A crystal knife can get more from your logs.",
        why = "It sometimes doubles arrow shafts or produces a strung bow while fletching an "
            .. "unstrung one.",
        how = {
            "After Roving Elves, take a crystal tool seed to Ilfeen and ask about singing tools.",
        },
        quest_how = {
            "Look into Roving Elves, then ask Ilfeen about singing crystal tools.",
        },
        requirements = {
            skills = { AGILITY = 56, FLETCHING = 1, RANGED = 25 },
            quests = { "ROVING_ELVES" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FLETCHING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "ELFCITY_CRYSTAL_KNIFE_100", "ELFCITY_CRYSTAL_KNIFE_50" },
            },
        },
        priority = 2,
    },

    {
        id = "fletching.rangers_workroom",
        kind = "general",
        skills = { "FLETCHING" },
        members = true,
        min_training_level = 50,
        title = "Ranger's Workroom",
        icon_item_id = 1513,
        hook = "The Ranger's Workroom gives your fletching a useful home base.",
        why = "Its upgrades can save materials, produce extra items and improve experience while "
            .. "you work there.",
        how = {
            "After Dead and Buried, inspect the building plans at Fort Forinthry.",
        },
        quest_how = {
            "Work through the Fort Forinthry story to Dead and Buried, then inspect the Ranger's "
                .. "Workroom plans.",
        },
        requirements = {
            skills = { CONSTRUCTION = 50, FLETCHING = 1, SLAYER = 10 },
            quests = { "QUEST_FORT_RAPTOR" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FLETCHING" },
        },
        priority = 2,
    },

    {
        id = "fletching.fenshell_knife",
        kind = "convenience",
        skills = { "FLETCHING" },
        members = true,
        title = "Fenshell knife",
        icon_item = "CERT_FENMOOR_WOODCUTTING_TORCH",
        hook = "A fenshell knife offers a chance to save fletching resources.",
        why = "It also speeds up carving Fenmoor Totems, making it a useful reward to work "
            .. "towards.",
        how = {
            "Look for it in the reward bundles from Mossteeth in Fenmoor.",
        },
        quest_how = {
            "Look into Heralds of Crimson to start exploring Havenhythe.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 30,
                CRAFTING = 51,
                FLETCHING = 65,
                HERBLORE = 55,
                HUNTER = 32,
                MINING = 65,
                SLAYER = 28,
                SMITHING = 60,
                WOODCUTTING = 65,
            },
            quests = { "QUEST_WENDLE_HERALDS" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FLETCHING" },
        },
        known_when = {
            { type = "owns_any", items = { "CERT_FENMOOR_WOODCUTTING_TORCH" } },
        },
        priority = 2,
    },

    {
        id = "fletching.cape",
        kind = "convenience",
        skills = { "FLETCHING" },
        members = true,
        title = "Fletching cape",
        icon_item = "SKILLCAPE_FLETCHING",
        hook = "The Fletching cape offers a chance at extra ammunition.",
        why = "When fletching arrows, bolts or darts, it can produce extra ammunition with "
            .. "experience for the extras.",
        how = {
            "Buy it from Hickton in Catherby.",
        },
        requirements = {
            skills = { FLETCHING = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FLETCHING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_FLETCHING",
                    "SKILLCAPE_FLETCHING_HOODED",
                    "SKILLCAPE_FLETCHING_HOODED_RETRO",
                    "SKILLCAPE_FLETCHING_RETRO",
                    "SKILLCAPE_FLETCHING_TRIMMED",
                    "SKILLCAPE_FLETCHING_TRIMMED_HOODED",
                    "SKILLCAPE_FLETCHING_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_FLETCHING_TRIMMED_RETRO",
                    "SKILLCAPE_INVERTED_FLETCHING_HOODED",
                    "SKILLCAPE_INVERTED_FLETCHING_TRIMMED_HOODED",
                },
            },
        },
        priority = 2,
    },

    -- training methods, one main method per level bracket
    {
        id = "fletching.method.oak",
        kind = "method",
        skills = { "FLETCHING" },
        members = false,
        level_range = { 20, 34 },
        main_method = true,
        title = "Oak bows",
        icon_item_id = 1521,
        hook = "Oak bows offer a straightforward fletching project.",
        why = "Fletching the bow and stringing it are separate ways to earn experience, with "
            .. "different supply costs.",
        how = {
            "Try a small batch of logs or unstrung bows and compare the result before buying more.",
        },
        requirements = {
            skills = { FLETCHING = 20 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FLETCHING", level = 20 },
        },
        priority = 2,
    },

    {
        id = "fletching.method.willow",
        kind = "method",
        skills = { "FLETCHING" },
        members = false,
        level_range = { 35, 49 },
        main_method = true,
        title = "Willow bows",
        icon_item_id = 1519,
        hook = "Willow bows offer a straightforward fletching project.",
        why = "Fletching the bow and stringing it are separate ways to earn experience, with "
            .. "different supply costs.",
        how = {
            "Try a small batch of logs or unstrung bows and compare the result before buying more.",
        },
        requirements = {
            skills = { FLETCHING = 35 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FLETCHING", level = 35 },
        },
        priority = 2,
    },

    {
        id = "fletching.method.maple",
        kind = "method",
        skills = { "FLETCHING" },
        members = false,
        level_range = { 50, 64 },
        main_method = true,
        title = "Maple bows",
        icon_item_id = 1517,
        hook = "Maple bows offer a straightforward fletching project.",
        why = "Fletching the bow and stringing it are separate ways to earn experience, with "
            .. "different supply costs.",
        how = {
            "Try a small batch of logs or unstrung bows and compare the result before buying more.",
        },
        requirements = {
            skills = { FLETCHING = 50 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FLETCHING", level = 50 },
        },
        priority = 2,
    },

    {
        id = "fletching.method.yew",
        kind = "method",
        skills = { "FLETCHING" },
        members = false,
        level_range = { 65, 79 },
        main_method = true,
        title = "Yew bows",
        icon_item_id = 1515,
        hook = "Yew bows offer a straightforward fletching project.",
        why = "Fletching the bow and stringing it are separate ways to earn experience, with "
            .. "different supply costs.",
        how = {
            "Try a small batch of logs or unstrung bows and compare the result before buying more.",
        },
        requirements = {
            skills = { FLETCHING = 65 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FLETCHING", level = 65 },
        },
        priority = 2,
    },

    {
        id = "fletching.method.magic",
        kind = "method",
        skills = { "FLETCHING" },
        members = false,
        level_range = { 80, 89 },
        main_method = true,
        title = "Magic bows",
        icon_item_id = 1513,
        hook = "Magic bows offer a straightforward fletching project.",
        why = "Fletching the bow and stringing it are separate ways to earn experience, with "
            .. "different supply costs.",
        how = {
            "Try a small batch of logs or unstrung bows and compare the result before buying more.",
        },
        requirements = {
            skills = { FLETCHING = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FLETCHING", level = 80 },
        },
        priority = 2,
    },

    {
        id = "fletching.method.elder",
        kind = "method",
        skills = { "FLETCHING" },
        members = true,
        level_range = { 90, 99 },
        main_method = true,
        title = "Elder bows",
        icon_item_id = 29556,
        hook = "Elder bows offer a straightforward fletching project.",
        why = "Fletching the bow and stringing it are separate ways to earn experience, with "
            .. "different supply costs.",
        how = {
            "Try a small batch of logs or unstrung bows and compare the result before buying more.",
        },
        requirements = {
            skills = { FLETCHING = 90 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FLETCHING", level = 90 },
        },
        priority = 2,
    },

    {
        id = "fletching.method.eternal",
        kind = "method",
        skills = { "FLETCHING" },
        members = true,
        level_range = { 100, 120 },
        main_method = true,
        title = "Eternal magic equipment",
        icon_item_id = 58250,
        hook = "Eternal magic equipment offers longer projects at a fletching workbench.",
        why = "Upgrade the equipment through the tiers available to you. Martial versions give "
            .. "more experience but consume the weapon.",
        how = {
            "Inspect the workbench options; a wood box helps carry logs for the larger upgrades.",
        },
        requirements = {
            skills = { FLETCHING = 100 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FLETCHING", level = 100 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "fletching.alt.ammunition",
        kind = "method",
        skills = { "FLETCHING" },
        members = true,
        level_range = { 52, 80 },
        title = "Fletching ammunition",
        icon_item_id = 824,
        hook = "Arrows and bolts offer a faster, more active alternative to bows.",
        why = "Supplies stack, but costs and demand vary between ammunition types.",
        how = {
            "Compare a small batch of supplies with the finished ammunition before scaling up.",
        },
        requirements = {
            skills = { FLETCHING = 52 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FLETCHING" },
        },
        priority = 3,
    },

    {
        id = "fletching.alt.fenmoor",
        kind = "method",
        skills = { "FLETCHING" },
        members = true,
        level_range = { 65, 104 },
        title = "Fenmoor Totems",
        icon_item_id = 1515,
        hook = "Fenmoor Totems combine gathering with longer fletching projects.",
        why = "Chop petrified wood and carve totems for experience and reward bundles. More totem "
            .. "tiers open as you level.",
        how = {
            "Speak to Mossteeth in Fenmoor to get started.",
        },
        quest_how = {
            "Look into Heralds of Crimson to start exploring Havenhythe.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 30,
                CRAFTING = 51,
                FLETCHING = 65,
                HERBLORE = 55,
                HUNTER = 32,
                MINING = 65,
                SLAYER = 28,
                SMITHING = 60,
                WOODCUTTING = 65,
            },
            quests = { "QUEST_WENDLE_HERALDS" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FLETCHING" },
        },
        priority = 3,
    },

    {
        id = "fletching.alt.iaia",
        kind = "method",
        skills = { "FLETCHING" },
        members = true,
        level_range = { 75, 120 },
        title = "Dream of Iaia",
        icon_item_id = 1513,
        hook = "The Dream of Iaia offers relaxed Fletching experience between other activities.",
        why = "The station uses Anachronia base camp resources rather than a backpack of logs. "
            .. "Stored experience limits each visit.",
        how = {
            "After Extinction, look for the fletching station in the Dream of Iaia.",
        },
        quest_how = {
            "Work towards Extinction to open up the Dream of Iaia and its associated skilling "
                .. "activities.",
        },
        requirements = {
            skills = {
                AGILITY = 65,
                ARCHAEOLOGY = 74,
                CRAFTING = 85,
                DIVINATION = 70,
                FLETCHING = 75,
                INVENTION = 85,
                MAGIC = 74,
                MINING = 50,
                RUNECRAFTING = 85,
                SLAYER = 75,
                SMITHING = 85,
            },
            quests = { "EGW_FINALE" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FLETCHING" },
        },
        priority = 3,
    },

    {
        id = "fletching.alt.darts",
        kind = "method",
        skills = { "FLETCHING" },
        members = true,
        level_range = { 81, 99 },
        title = "Fletching darts",
        icon_item_id = 824,
        hook = "Darts offer rapid Fletching experience when you prefer a more active method.",
        why = "Stackable supplies keep banking down, but the cost per batch can rise quickly.",
        how = {
            "Try rune dart tips and feathers, then compare the cost with the finished darts.",
        },
        requirements = {
            skills = { FLETCHING = 81 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FLETCHING" },
        },
        priority = 3,
    },

    {
        id = "fletching.alt.carestyling",
        kind = "method",
        skills = { "FLETCHING" },
        members = true,
        level_range = { 82, 109 },
        title = "Zygomite Carestyling",
        icon_item_id = 1513,
        hook = "Zygomite Carestyling offers a laid-back change from bankstanding.",
        why = "Groom scruffy zygomites for tempered fungal shafts, without buying a batch of logs "
            .. "first.",
        how = {
            "After Extinction, visit Prehistoric Potterington's activity on Anachronia.",
        },
        quest_how = {
            "Work towards Extinction to open up the Dream of Iaia and its associated skilling "
                .. "activities.",
        },
        requirements = {
            skills = {
                AGILITY = 65,
                ARCHAEOLOGY = 74,
                CRAFTING = 85,
                DIVINATION = 70,
                FLETCHING = 82,
                INVENTION = 85,
                MAGIC = 74,
                MINING = 50,
                RUNECRAFTING = 85,
                SLAYER = 75,
                SMITHING = 85,
            },
            quests = { "EGW_FINALE" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FLETCHING" },
        },
        priority = 3,
    },

    {
        id = "fletching.alt.sagaies",
        kind = "method",
        skills = { "FLETCHING" },
        members = true,
        level_range = { 83, 95 },
        title = "Making sagaies",
        icon_item_id = 1513,
        hook = "Making sagaies offers Fletching experience from supplies you gather yourself.",
        why = "The process also involves Woodcutting and Firemaking, trading speed for a break "
            .. "from buying supplies.",
        how = {
            "Look into straight roots and hardened shafts in the Jadinko Lair.",
        },
        requirements = {
            skills = { FIREMAKING = 83, FLETCHING = 83, WOODCUTTING = 83 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FLETCHING" },
        },
        priority = 3,
    },
}
