-- useful items and unlocks, then main methods and alternatives in level order.
-- source access and recommendation windows: docs/artisan-coverage.md.

return {
    {
        id = "smithing.blacksmith_outfit",
        icon_item = "WOF19_SKILL_SMITHING_HEAD",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        title = "Blacksmith's outfit",
        hook = "The blacksmith's outfit adds experience while forging and smelting.",
        why = "Each piece contributes, with an extra bonus for wearing the full set.",
        how = { "Spend respect earned at the Artisans' Workshop on pieces from Egil." },
        requirements = {
            skills = {
                SMITHING = 1,
            },
        },
        min_training_level = 30,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SMITHING",
            },
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
        icon_item = "GAUNTLETS_OF_GOLDSMITHING",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        title = "Smelting gauntlets",
        hook = "Smelting gauntlets make longer smelting batches possible.",
        why = "Bars go straight to the metal bank, leaving less banking between batches.",
        how = {
            "After Family Crest, ask Avan in the Al Kharid mine to change your family gauntlets.",
        },
        requirements = {
            skills = {
                SMITHING = 1,
            },
            quests = { "FAMILY_CREST" },
        },
        min_training_level = 30,
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "SMITHING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "GAUNTLETS_OF_GOLDSMITHING" },
            },
        },
        priority = 2,
    },

    {
        id = "smithing.autoheater",
        icon_item = "SMITHING_COAL_HEAT_CONSUMER",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        title = "Smithing autoheater",
        hook = "An autoheater keeps a smithing project moving when its heat runs out.",
        why = "It uses coal from your metal bank to reheat the item automatically. The advanced version offers a stronger setting.",
        how = {
            "Look in the Dungeoneering rewards shop; the advanced upgrade comes from the Invention Guild.",
        },
        requirements = {
            skills = {
                SMITHING = 35,
                DUNGEONEERING = 35,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SMITHING",
            },
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
        icon_item = "INVENT_HAMMER",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        title = "Hammer-tron",
        hook = "A hammer-tron brings Invention perks to Smithing.",
        why = "It gains equipment experience as you smith and uses energy from your charge pack.",
        how = {
            "Discover it at an Invention workbench. Enhanced and crystal hammers offer later upgrades.",
        },
        requirements = {
            skills = {
                SMITHING = 1,
                INVENTION = 22,
            },
        },
        min_training_level = 50,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SMITHING",
            },
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
        icon_item = "ELFCITY_CRYSTAL_HAMMER_100",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        title = "Crystal hammer",
        hook = "A crystal hammer offers a small chance to make extra smithing progress.",
        why = "Augmenting it also allows tool perks and equipment experience.",
        how = {
            "After Roving Elves, take a crystal tool seed to Ilfeen and ask about singing tools.",
        },
        requirements = {
            skills = {
                SMITHING = 1,
            },
            quests = { "ROVING_ELVES" },
        },
        min_training_level = 60,
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "SMITHING",
            },
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
        icon_item_id = 2353,
        kind = "general",
        skills = { "SMITHING" },
        members = true,
        title = "Scroll of efficiency",
        hook = "The scroll of efficiency can stretch your supply of smithing bars.",
        why = "Learning it permanently gives a chance to save bars while smithing.",
        how = { "Look for it in the Dungeoneering rewards shop." },
        requirements = {
            skills = {
                SMITHING = 55,
                DUNGEONEERING = 55,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SMITHING",
            },
        },
        priority = 2,
    },

    {
        id = "smithing.superheat_form",
        icon_item_id = 554,
        kind = "general",
        skills = { "SMITHING" },
        members = true,
        title = "Superheat Form",
        hook = "Superheat Form makes low-heat smithing less sluggish.",
        why = "The curse also speeds up smelting, at the cost of prayer points.",
        how = { "After The Light Within, look for it among the Seren curses." },
        requirements = {
            skills = {
                SMITHING = 1,
                PRAYER = 91,
            },
            quests = { "SEREN" },
        },
        min_training_level = 80,
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "SMITHING",
            },
        },
        priority = 2,
    },

    {
        id = "smithing.furnace_core",
        icon_item = "SKILLING_OFFHAND_FURNACE",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        title = "Orthen furnace core",
        hook = "The Orthen furnace core offers a longer-term upgrade for your forge.",
        why = "It removes Superheat Form prayer drain and can produce forge phoenixes while you smith.",
        how = { "Look at its recipe in the masterwork section of an anvil." },
        requirements = {
            skills = {
                SMITHING = 99,
                ARCHAEOLOGY = 102,
            },
        },
        min_training_level = 99,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SMITHING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "SKILLING_OFFHAND_FURNACE" },
            },
        },
        priority = 2,
    },

    {
        id = "smithing.cape",
        icon_item = "SKILLCAPE_SMITHING",
        kind = "convenience",
        skills = { "SMITHING" },
        members = true,
        title = "Smithing cape",
        hook = "The Smithing cape offers extra progress after reheating.",
        why = "Wearing it strengthens the first hammer strike after a reheat, including one from an autoheater.",
        how = { "Buy it from Thurgo south of Port Sarim." },
        requirements = {
            skills = {
                SMITHING = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SMITHING",
            },
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

    {
        id = "smithing.method.iron",
        main_method = true,
        icon_item_id = 2351,
        kind = "method",
        skills = { "SMITHING" },
        level_range = { 10, 19 },
        members = false,
        title = "Iron equipment",
        hook = "Iron equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it progress.",
        },
        requirements = {
            skills = {
                SMITHING = 10,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SMITHING",
                level = 10,
            },
        },
        priority = 2,
    },

    {
        id = "smithing.method.steel",
        main_method = true,
        icon_item_id = 2353,
        kind = "method",
        skills = { "SMITHING" },
        level_range = { 20, 29 },
        members = false,
        title = "Steel equipment",
        hook = "Steel equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it progress.",
        },
        requirements = {
            skills = {
                SMITHING = 20,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SMITHING",
                level = 20,
            },
        },
        priority = 2,
    },

    {
        id = "smithing.method.mithril",
        main_method = true,
        icon_item_id = 2359,
        kind = "method",
        skills = { "SMITHING" },
        level_range = { 30, 39 },
        members = false,
        title = "Mithril equipment",
        hook = "Mithril equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it progress.",
        },
        requirements = {
            skills = {
                SMITHING = 30,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SMITHING",
                level = 30,
            },
        },
        priority = 2,
    },

    {
        id = "smithing.method.adamant",
        main_method = true,
        icon_item_id = 2361,
        kind = "method",
        skills = { "SMITHING" },
        level_range = { 40, 49 },
        members = false,
        title = "Adamant equipment",
        hook = "Adamant equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it progress.",
        },
        requirements = {
            skills = {
                SMITHING = 40,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SMITHING",
                level = 40,
            },
        },
        priority = 2,
    },

    {
        id = "smithing.method.rune",
        main_method = true,
        icon_item_id = 2363,
        kind = "method",
        skills = { "SMITHING" },
        level_range = { 50, 59 },
        members = false,
        title = "Rune equipment",
        hook = "Rune equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it progress.",
        },
        requirements = {
            skills = {
                SMITHING = 50,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SMITHING",
                level = 50,
            },
        },
        priority = 2,
    },

    {
        id = "smithing.method.orikalkum",
        main_method = true,
        icon_item_id = 44838,
        kind = "method",
        skills = { "SMITHING" },
        level_range = { 60, 69 },
        members = true,
        title = "Orikalkum equipment",
        hook = "Orikalkum equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it progress.",
        },
        requirements = {
            skills = {
                SMITHING = 60,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SMITHING",
                level = 60,
            },
        },
        priority = 2,
    },

    {
        id = "smithing.method.necronium",
        main_method = true,
        icon_item_id = 44840,
        kind = "method",
        skills = { "SMITHING" },
        level_range = { 70, 79 },
        members = true,
        title = "Necronium equipment",
        hook = "Necronium equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it progress.",
        },
        requirements = {
            skills = {
                SMITHING = 70,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SMITHING",
                level = 70,
            },
        },
        priority = 2,
    },

    {
        id = "smithing.method.bane",
        main_method = true,
        icon_item_id = 44842,
        kind = "method",
        skills = { "SMITHING" },
        level_range = { 80, 89 },
        members = true,
        title = "Bane equipment",
        hook = "Bane equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it progress.",
        },
        requirements = {
            skills = {
                SMITHING = 80,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SMITHING",
                level = 80,
            },
        },
        priority = 2,
    },

    {
        id = "smithing.method.elder_rune",
        main_method = true,
        icon_item_id = 44844,
        kind = "method",
        skills = { "SMITHING" },
        level_range = { 90, 99 },
        members = true,
        title = "Elder rune equipment",
        hook = "Elder rune equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it progress.",
        },
        requirements = {
            skills = {
                SMITHING = 90,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SMITHING",
                level = 90,
            },
        },
        priority = 2,
    },

    {
        id = "smithing.method.primal",
        main_method = true,
        icon_item_id = 57435,
        kind = "method",
        skills = { "SMITHING" },
        level_range = { 100, 120 },
        members = true,
        title = "Primal equipment",
        hook = "Primal equipment offers a steady smithing project.",
        why = "Upgrading existing equipment is another way to earn experience without starting every item from bars.",
        how = {
            "Check the forge for available projects and upgrades. Keeping the item hot helps it progress.",
        },
        requirements = {
            skills = {
                SMITHING = 100,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SMITHING",
                level = 100,
            },
        },
        priority = 2,
    },

    {
        id = "smithing.alt.smelting",
        icon_item_id = 2353,
        kind = "method",
        skills = { "SMITHING" },
        level_range = { 20, 79 },
        members = false,
        title = "Smelting bars",
        hook = "Smelting offers a slower alternative to forging, with bars you can use or sell.",
        why = "Higher metal tiers become available as you level. Returns depend on the cost of their ores.",
        how = { "Compare a small batch of ore and bar prices, then try the furnace." },
        requirements = {
            skills = {
                SMITHING = 20,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SMITHING",
            },
        },
        priority = 3,
    },

    {
        id = "smithing.alt.burial",
        icon_item_id = 2361,
        kind = "method",
        skills = { "SMITHING" },
        level_range = { 40, 120 },
        members = true,
        title = "Burial smithing",
        hook = "Burial smithing trades the finished equipment for extra experience.",
        why = "It consumes the items, so there is nothing left to sell. Higher metal tiers keep this useful as you level.",
        how = { "Look for the burial forge and anvil in the Artisans' Workshop." },
        requirements = {
            skills = {
                SMITHING = 40,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SMITHING",
            },
        },
        priority = 3,
    },

    {
        id = "smithing.alt.corrupted",
        icon_item_id = 44844,
        kind = "method",
        skills = { "SMITHING" },
        level_range = { 89, 99 },
        members = true,
        title = "Corrupted ore",
        hook = "Corrupted ore offers a relaxed way to use what you gather from Seren stones.",
        why = "The ore stacks, so smelting needs little banking. Gathering it is part of the time investment.",
        how = {
            "Use a furnace in Prifddinas, especially when the Trahaearn Voice of Seren is active.",
        },
        requirements = {
            skills = {
                SMITHING = 89,
            },
            quests = { "PLAGUES_END" },
        },
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "SMITHING",
            },
        },
        priority = 3,
    },
}
