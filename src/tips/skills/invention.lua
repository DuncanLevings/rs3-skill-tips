-- useful items and unlocks, then main methods and alternatives in level order.
-- source access and recommendation windows: docs/artisan-coverage.md.

return {
    {
        id = "invention.mechanised_siphon",
        icon_item = "INVENT_AUTO_SIPHON",
        kind = "convenience",
        skills = { "INVENTION" },
        members = true,
        title = "Mechanised siphon",
        hook = "A mechanised siphon handles siphoning at the equipment level you choose.",
        why = "Load it with siphons and configure the equipment types it should handle. It keeps the gear and resets its item experience.",
        how = { "Discover and build one at an Invention workbench, then use Configure." },
        requirements = {
            skills = {
                INVENTION = 77,
                CRAFTING = 80,
                SMITHING = 80,
                DIVINATION = 80,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "INVENTION",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "INVENT_AUTO_SIPHON" },
            },
        },
        priority = 2,
    },

    {
        id = "invention.ancient_invention",
        icon_item_id = 7936,
        kind = "general",
        skills = { "INVENTION" },
        members = true,
        title = "Ancient Invention",
        hook = "Ancient Invention opens up stronger perk combinations.",
        why = "Ancient gizmos hold more materials, giving you new ways to perk your equipment.",
        how = {
            "Research an Ancient gizmos blueprint at a workbench. You can buy the blueprint without making it through Archaeology.",
        },
        requirements = {
            skills = {
                INVENTION = 85,
                CRAFTING = 80,
                SMITHING = 80,
                DIVINATION = 80,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "INVENTION",
            },
        },
        priority = 2,
    },

    {
        id = "invention.machines",
        icon_item_id = 7936,
        kind = "general",
        skills = { "INVENTION" },
        members = true,
        title = "Invention machines",
        hook = "Invention machines can handle processing while you spend time elsewhere.",
        why = "Build a machine, supply its inputs and keep the generator fuelled. Later upgrades make more processing options possible.",
        how = { "Look at the machine hotspots in the Invention Guild." },
        requirements = {
            skills = {
                INVENTION = 60,
                CRAFTING = 80,
                SMITHING = 80,
                DIVINATION = 80,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "INVENTION",
            },
        },
        priority = 2,
    },

    {
        id = "invention.cape",
        icon_item = "SKILLCAPE_INVENTION",
        kind = "convenience",
        skills = { "INVENTION" },
        members = true,
        title = "Invention cape",
        hook = "The Invention cape offers longer-lasting charge-pack energy.",
        why = "Its perk reduces the drain rate of charges from your charge pack.",
        how = { "Buy it from Doc at the Invention Guild." },
        requirements = {
            skills = {
                INVENTION = 99,
                CRAFTING = 80,
                SMITHING = 80,
                DIVINATION = 80,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "INVENTION",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_120_INVENTION",
                    "SKILLCAPE_INVENTION",
                    "SKILLCAPE_INVENTION_HOODED",
                    "SKILLCAPE_INVENTION_HOODED_RETRO",
                    "SKILLCAPE_INVENTION_RETRO",
                    "SKILLCAPE_INVENTION_TRIMMED",
                    "SKILLCAPE_INVENTION_TRIMMED_HOODED",
                    "SKILLCAPE_INVENTION_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_INVENTION_TRIMMED_RETRO",
                    "SKILLCAPE_INVERTED_INVENTION_HOODED",
                    "SKILLCAPE_INVERTED_INVENTION_TRIMMED_HOODED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "invention.method.equipment_levels",
        main_method = true,
        icon_item_id = 7936,
        kind = "method",
        skills = { "INVENTION" },
        level_range = { 4, 26 },
        members = true,
        title = "Equipment levels",
        hook = "Researching equipment levels opens a route beyond basic disassembly.",
        why = "Augmented equipment gains item experience as you use it. Disassembly trades the item for Invention experience and materials.",
        how = {
            "Discover the maximum equipment level blueprint at a workbench, and choose equipment you are willing to lose.",
        },
        requirements = {
            skills = {
                INVENTION = 4,
                CRAFTING = 80,
                SMITHING = 80,
                DIVINATION = 80,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "INVENTION",
                level = 4,
            },
        },
        priority = 2,
    },

    {
        id = "invention.method.siphoning",
        main_method = true,
        icon_item_id = 7936,
        kind = "method",
        skills = { "INVENTION" },
        level_range = { 27, 120 },
        members = true,
        title = "Siphoning equipment",
        hook = "Siphoning lets you train Invention while keeping augmented equipment.",
        why = "Equipment gains item experience as you use it. Siphoning resets that experience without destroying the gear.",
        how = { "Research the equipment level upgrades and siphons at an Invention workbench." },
        requirements = {
            skills = {
                INVENTION = 27,
                CRAFTING = 80,
                SMITHING = 80,
                DIVINATION = 80,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "INVENTION",
                level = 27,
            },
        },
        priority = 2,
    },

    {
        id = "invention.alt.discovery",
        icon_item_id = 7936,
        kind = "method",
        skills = { "INVENTION" },
        level_range = { 4, 118 },
        members = true,
        title = "Blueprint discovery",
        hook = "Blueprint discovery offers useful unlocks alongside Invention experience.",
        why = "New discoveries open as you level. Better optimisation gives more experience for each blueprint.",
        how = { "Check the discovery side of an Invention workbench when you have new levels." },
        requirements = {
            skills = {
                INVENTION = 4,
                CRAFTING = 80,
                SMITHING = 80,
                DIVINATION = 80,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "INVENTION",
            },
        },
        priority = 3,
    },

    {
        id = "invention.alt.skilling_tools",
        icon_item_id = 7936,
        kind = "method",
        skills = { "INVENTION" },
        level_range = { 22, 120 },
        members = true,
        title = "Levelling skilling tools",
        hook = "Augmented skilling tools let your usual training build Invention progress too.",
        why = "Supported tools gain item experience while used, ready for later disassembly or siphoning.",
        how = {
            "Start with a tool blueprint such as the hammer-tron or pyro-matic, or inspect augmentation for a tool you already use.",
        },
        requirements = {
            skills = {
                INVENTION = 22,
                CRAFTING = 80,
                SMITHING = 80,
                DIVINATION = 80,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "INVENTION",
            },
        },
        priority = 3,
    },

    {
        id = "invention.alt.gizmos",
        icon_item_id = 7936,
        kind = "method",
        skills = { "INVENTION" },
        level_range = { 103, 120 },
        members = true,
        title = "Making ancient gizmos",
        hook = "Ancient gizmos offer a faster but expensive Invention training option.",
        why = "High-level components give substantial experience when used in a gizmo, but using them only for experience consumes valuable materials.",
        how = {
            "After researching Ancient gizmos, compare component costs before trying a small batch.",
        },
        requirements = {
            skills = {
                INVENTION = 103,
                CRAFTING = 80,
                SMITHING = 80,
                DIVINATION = 80,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "INVENTION",
            },
        },
        priority = 3,
    },
}
