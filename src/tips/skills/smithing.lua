-- smithing tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field

return {
    -- useful items and unlocks
    {
        id = "smithing.blacksmith_outfit",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        min_training_level = 30,
        title = "Blacksmith's outfit",
        icon_item = "WOF19_SKILL_SMITHING_HEAD",
        hook = "The blacksmith's outfit adds experience while forging and smelting.",
        why = "Each piece contributes, with an extra bonus for wearing the full set.",
        how = {
            "Spend respect earned at the Artisans' Workshop on pieces from Egil.",
        },
        requirements = {
            skills = { SMITHING = 1 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "SMITHING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH28_SMITHING_HEAD_ADDON",
                    "TRH28_SMITHING_HEAD_UPGRADED",
                    "WOF19_SKILL_SMITHING_FEET",
                    "WOF19_SKILL_SMITHING_HANDS",
                    "WOF19_SKILL_SMITHING_HEAD",
                    "WOF19_SKILL_SMITHING_LEGS",
                    "WOF19_SKILL_SMITHING_TORSO",
                },
            },
        },
        priority = 2,
    },

    {
        id = "smithing.smelting_gauntlets",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        min_training_level = 30,
        title = "Smelting gauntlets",
        icon_item = "GAUNTLETS_OF_GOLDSMITHING",
        hook = "Smelting gauntlets make longer smelting batches possible.",
        why = "Bars go straight to the metal bank, leaving less banking between batches.",
        how = {
            "After Family Crest, ask Avan in the Al Kharid mine to change your family gauntlets.",
        },
        quest_how = {
            "Complete Family Crest, then ask about the different gauntlet enchantments.",
        },
        requirements = {
            skills = { CRAFTING = 40, MAGIC = 59, MINING = 40, SMITHING = 40 },
            quests = { "FAMILY_CREST" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "SMITHING" },
        },
        known_when = {
            { type = "owns_any", items = { "GAUNTLETS_OF_GOLDSMITHING" } },
        },
        priority = 2,
    },

    {
        id = "smithing.autoheater",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        title = "Smithing autoheater",
        icon_item = "SMITHING_COAL_HEAT_CONSUMER",
        hook = "An autoheater keeps a smithing project moving when its heat runs out.",
        why = "It uses coal from your metal bank to reheat the item automatically. The advanced "
            .. "version offers a stronger setting.",
        how = {
            "Look in the Dungeoneering rewards shop; the advanced upgrade comes from the Invention "
                .. "Guild.",
        },
        requirements = {
            skills = { DUNGEONEERING = 35, SMITHING = 35 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "SMITHING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "SMITHING_COAL_HEAT_CONSUMER", "SMITHING_COAL_HEAT_CONSUMER_UPGRADED" },
            },
        },
        priority = 2,
    },

    {
        id = "smithing.hammer_tron",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        min_training_level = 50,
        title = "Hammer-tron",
        icon_item = "INVENT_HAMMER",
        hook = "A hammer-tron brings Invention perks to Smithing.",
        why = "It gains equipment experience as you smith and uses energy from your charge pack.",
        how = {
            "Discover it at an Invention workbench. Enhanced and crystal hammers offer later "
                .. "upgrades.",
        },
        requirements = {
            skills = { INVENTION = 22, SMITHING = 1 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "SMITHING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "ELFCITY_CRYSTAL_HAMMER_100",
                    "ELFCITY_CRYSTAL_HAMMER_50",
                    "ELFCITY_CRYSTAL_HAMMER_AUGMENTED",
                    "ELFCITY_CRYSTAL_HAMMER_AUGMENTED_UNCHARGED",
                    "INVENT_ENHANCED_HAMMER",
                    "INVENT_ENHANCED_HAMMER_UNCHARGED",
                    "INVENT_ENHANCED_HAMMER_UNUSED",
                    "INVENT_HAMMER",
                    "INVENT_HAMMER_UNCHARGED",
                    "INVENT_HAMMER_UNUSED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "smithing.crystal_hammer",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        min_training_level = 60,
        title = "Crystal hammer",
        icon_item = "ELFCITY_CRYSTAL_HAMMER_100",
        hook = "A crystal hammer offers a small chance to make extra smithing progress.",
        why = "Augmenting it also allows tool perks and equipment experience.",
        how = {
            "After Roving Elves, take a crystal tool seed to Ilfeen and ask about singing tools.",
        },
        quest_how = {
            "Look into Roving Elves, then ask Ilfeen about singing crystal tools.",
        },
        requirements = {
            skills = { AGILITY = 56, RANGED = 25, SMITHING = 1 },
            quests = { "ROVING_ELVES" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "SMITHING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "ELFCITY_CRYSTAL_HAMMER_100",
                    "ELFCITY_CRYSTAL_HAMMER_50",
                    "ELFCITY_CRYSTAL_HAMMER_AUGMENTED",
                    "ELFCITY_CRYSTAL_HAMMER_AUGMENTED_UNCHARGED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "smithing.efficiency",
        kind = "general",
        skills = { "SMITHING" },
        members = true,
        title = "Scroll of efficiency",
        icon_item_id = 2353,
        hook = "The scroll of efficiency can stretch your supply of smithing bars.",
        why = "Learning it permanently gives a chance to save bars while smithing.",
        how = {
            "Look for it in the Dungeoneering rewards shop.",
        },
        requirements = {
            skills = { DUNGEONEERING = 55, SMITHING = 55 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "SMITHING" },
        },
        priority = 2,
    },

    {
        id = "smithing.superheat_form",
        kind = "general",
        skills = { "SMITHING" },
        members = true,
        min_training_level = 80,
        title = "Superheat Form",
        icon_item_id = 554,
        hook = "Superheat Form makes low-heat smithing less sluggish.",
        why = "The curse also speeds up smelting, at the cost of prayer points.",
        how = {
            "After The Light Within, look for it among the Seren curses.",
        },
        quest_how = {
            "Look into The Light Within for access to its Seren spells and prayers.",
        },
        requirements = {
            skills = {
                AGILITY = 80,
                CONSTRUCTION = 75,
                COOKING = 35,
                CRAFTING = 80,
                DIVINATION = 80,
                DUNGEONEERING = 75,
                FARMING = 25,
                FIREMAKING = 50,
                FLETCHING = 70,
                HERBLORE = 80,
                HUNTER = 51,
                MAGIC = 79,
                MINING = 75,
                PRAYER = 91,
                RANGED = 75,
                RUNECRAFTING = 50,
                SLAYER = 80,
                SMITHING = 65,
                STRENGTH = 64,
                SUMMONING = 75,
                THIEVING = 66,
                WOODCUTTING = 80,
            },
            quests = { "SEREN" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "SMITHING" },
        },
        priority = 2,
    },

    {
        id = "smithing.furnace_core",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        min_training_level = 99,
        title = "Orthen furnace core",
        icon_item = "SKILLING_OFFHAND_FURNACE",
        hook = "The Orthen furnace core offers a longer-term upgrade for your forge.",
        why = "It removes Superheat Form prayer drain and can produce forge phoenixes while you "
            .. "smith.",
        how = {
            "Look at its recipe in the masterwork section of an anvil.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 102, SMITHING = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "SMITHING" },
        },
        known_when = {
            { type = "owns_any", items = { "SKILLING_OFFHAND_FURNACE" } },
        },
        priority = 2,
    },

    {
        id = "smithing.cape",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        title = "Smithing cape",
        icon_item = "SKILLCAPE_SMITHING",
        hook = "The Smithing cape offers extra progress after reheating.",
        why = "Wearing it strengthens the first hammer strike after a reheat, including one from "
            .. "an autoheater.",
        how = {
            "Buy it from Thurgo south of Port Sarim.",
        },
        requirements = {
            skills = { SMITHING = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "SMITHING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_INVERTED_SMITHING_HOODED",
                    "SKILLCAPE_INVERTED_SMITHING_TRIMMED_HOODED",
                    "SKILLCAPE_SMITHING",
                    "SKILLCAPE_SMITHING_HOODED",
                    "SKILLCAPE_SMITHING_HOODED_RETRO",
                    "SKILLCAPE_SMITHING_RETRO",
                    "SKILLCAPE_SMITHING_TRIMMED",
                    "SKILLCAPE_SMITHING_TRIMMED_HOODED",
                    "SKILLCAPE_SMITHING_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_SMITHING_TRIMMED_RETRO",
                },
            },
        },
        priority = 2,
    },

    -- training methods, one main method per level bracket
    {
        id = "smithing.method.iron",
        kind = "method",
        skills = { "SMITHING" },
        members = false,
        level_range = { 10, 19 },
        main_method = true,
        title = "Iron equipment",
        icon_item_id = 2351,
        hook = "Iron equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting "
            .. "every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it "
                .. "progress.",
        },
        requirements = {
            skills = { SMITHING = 10 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "SMITHING", level = 10 },
        },
        priority = 2,
    },

    {
        id = "smithing.method.steel",
        kind = "method",
        skills = { "SMITHING" },
        members = false,
        level_range = { 20, 29 },
        main_method = true,
        title = "Steel equipment",
        icon_item_id = 2353,
        hook = "Steel equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting "
            .. "every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it "
                .. "progress.",
        },
        requirements = {
            skills = { SMITHING = 20 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "SMITHING", level = 20 },
        },
        priority = 2,
    },

    {
        id = "smithing.method.mithril",
        kind = "method",
        skills = { "SMITHING" },
        members = false,
        level_range = { 30, 39 },
        main_method = true,
        title = "Mithril equipment",
        icon_item_id = 2359,
        hook = "Mithril equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting "
            .. "every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it "
                .. "progress.",
        },
        requirements = {
            skills = { SMITHING = 30 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "SMITHING", level = 30 },
        },
        priority = 2,
    },

    {
        id = "smithing.method.adamant",
        kind = "method",
        skills = { "SMITHING" },
        members = false,
        level_range = { 40, 49 },
        main_method = true,
        title = "Adamant equipment",
        icon_item_id = 2361,
        hook = "Adamant equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting "
            .. "every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it "
                .. "progress.",
        },
        requirements = {
            skills = { SMITHING = 40 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "SMITHING", level = 40 },
        },
        priority = 2,
    },

    {
        id = "smithing.method.rune",
        kind = "method",
        skills = { "SMITHING" },
        members = false,
        level_range = { 50, 59 },
        main_method = true,
        title = "Rune equipment",
        icon_item_id = 2363,
        hook = "Rune equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting "
            .. "every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it "
                .. "progress.",
        },
        requirements = {
            skills = { SMITHING = 50 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "SMITHING", level = 50 },
        },
        priority = 2,
    },

    {
        id = "smithing.method.orikalkum",
        kind = "method",
        skills = { "SMITHING" },
        members = true,
        level_range = { 60, 69 },
        main_method = true,
        title = "Orikalkum equipment",
        icon_item_id = 44838,
        hook = "Orikalkum equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting "
            .. "every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it "
                .. "progress.",
        },
        requirements = {
            skills = { SMITHING = 60 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "SMITHING", level = 60 },
        },
        priority = 2,
    },

    {
        id = "smithing.method.necronium",
        kind = "method",
        skills = { "SMITHING" },
        members = true,
        level_range = { 70, 79 },
        main_method = true,
        title = "Necronium equipment",
        icon_item_id = 44840,
        hook = "Necronium equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting "
            .. "every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it "
                .. "progress.",
        },
        requirements = {
            skills = { SMITHING = 70 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "SMITHING", level = 70 },
        },
        priority = 2,
    },

    {
        id = "smithing.method.bane",
        kind = "method",
        skills = { "SMITHING" },
        members = true,
        level_range = { 80, 89 },
        main_method = true,
        title = "Bane equipment",
        icon_item_id = 44842,
        hook = "Bane equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting "
            .. "every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it "
                .. "progress.",
        },
        requirements = {
            skills = { SMITHING = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "SMITHING", level = 80 },
        },
        priority = 2,
    },

    {
        id = "smithing.method.elder_rune",
        kind = "method",
        skills = { "SMITHING" },
        members = true,
        level_range = { 90, 99 },
        main_method = true,
        title = "Elder rune equipment",
        icon_item_id = 44844,
        hook = "Elder rune equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting "
            .. "every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it "
                .. "progress.",
        },
        requirements = {
            skills = { SMITHING = 90 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "SMITHING", level = 90 },
        },
        priority = 2,
    },

    {
        id = "smithing.method.primal",
        kind = "method",
        skills = { "SMITHING" },
        members = true,
        level_range = { 100, 120 },
        main_method = true,
        title = "Primal equipment",
        icon_item_id = 57435,
        hook = "Primal equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting "
            .. "every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it "
                .. "progress.",
        },
        requirements = {
            skills = { SMITHING = 100 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "SMITHING", level = 100 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "smithing.alt.smelting",
        kind = "method",
        skills = { "SMITHING" },
        members = false,
        level_range = { 20, 79 },
        title = "Smelting bars",
        icon_item_id = 2353,
        hook = "Smelting offers a slower alternative to forging, with bars you can use or sell.",
        why = "Higher metal tiers become available as you level. Returns depend on the cost of "
            .. "their ores.",
        how = {
            "Compare a small batch of ore and bar prices, then try the furnace.",
        },
        requirements = {
            skills = { SMITHING = 20 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "SMITHING" },
        },
        priority = 3,
    },

    {
        id = "smithing.alt.burial",
        kind = "method",
        skills = { "SMITHING" },
        members = true,
        level_range = { 40, 120 },
        title = "Burial smithing",
        icon_item_id = 2361,
        hook = "Burial smithing trades the finished equipment for extra experience.",
        why = "It consumes the items, so there is nothing left to sell. Higher metal tiers keep "
            .. "this useful as you level.",
        how = {
            "Look for the burial forge and anvil in the Artisans' Workshop.",
        },
        requirements = {
            skills = { SMITHING = 40 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "SMITHING" },
        },
        priority = 3,
    },

    {
        id = "smithing.alt.corrupted",
        kind = "method",
        skills = { "SMITHING" },
        members = true,
        level_range = { 89, 99 },
        title = "Corrupted ore",
        icon_item_id = 44844,
        hook = "Corrupted ore offers a relaxed way to use what you gather from Seren stones.",
        why = "The ore stacks, so smelting needs little banking. Gathering it is part of the time "
            .. "investment.",
        how = {
            "Use a furnace in Prifddinas, especially when the Trahaearn Voice of Seren is active.",
        },
        quest_how = {
            "Work towards Plague's End to open up Prifddinas and its training facilities.",
        },
        requirements = {
            skills = {
                AGILITY = 75,
                CONSTRUCTION = 75,
                COOKING = 30,
                CRAFTING = 75,
                DUNGEONEERING = 75,
                FLETCHING = 70,
                HERBLORE = 75,
                MINING = 75,
                PRAYER = 75,
                RANGED = 75,
                SMITHING = 89,
                SUMMONING = 75,
                THIEVING = 50,
                WOODCUTTING = 75,
            },
            quests = { "PLAGUES_END" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "SMITHING" },
        },
        priority = 3,
    },
}
