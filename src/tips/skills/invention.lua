-- invention tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field

return {
    -- useful items and unlocks
    {
        id = "invention.mechanised_siphon",
        kind = "convenience",
        skills = { "INVENTION" },
        members = true,
        title = "Mechanised siphon",
        icon_item = "INVENT_AUTO_SIPHON",
        hook = "A mechanised siphon handles siphoning at the equipment level you choose.",
        why = "Load it with siphons and configure the equipment types it should handle. It keeps "
            .. "the gear and resets its item experience.",
        how = {
            "Discover and build one at an Invention workbench, then use Configure.",
        },
        requirements = {
            skills = { CRAFTING = 80, DIVINATION = 80, INVENTION = 77, SMITHING = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "INVENTION" },
        },
        known_when = {
            { type = "owns_any", items = { "INVENT_AUTO_SIPHON" } },
        },
        priority = 2,
    },

    {
        id = "invention.ancient_invention",
        kind = "general",
        skills = { "INVENTION" },
        members = true,
        title = "Ancient Invention",
        icon_item_id = 7936,
        hook = "Ancient Invention opens up stronger perk combinations.",
        why = "Ancient gizmos hold more materials, giving you new ways to perk your equipment.",
        how = {
            "Research an Ancient gizmos blueprint at a workbench. You can buy the blueprint "
                .. "without making it through Archaeology.",
        },
        requirements = {
            skills = { CRAFTING = 80, DIVINATION = 80, INVENTION = 85, SMITHING = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "INVENTION" },
        },
        priority = 2,
    },

    {
        id = "invention.machines",
        kind = "general",
        skills = { "INVENTION" },
        members = true,
        title = "Invention machines",
        icon_item_id = 7936,
        hook = "Invention machines can handle processing while you spend time elsewhere.",
        why = "Build a machine, supply its inputs and keep the generator fuelled. Later upgrades "
            .. "make more processing options possible.",
        how = {
            "Look at the machine hotspots in the Invention Guild.",
        },
        requirements = {
            skills = { CRAFTING = 80, DIVINATION = 80, INVENTION = 60, SMITHING = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "INVENTION" },
        },
        priority = 2,
    },

    {
        id = "invention.cape",
        kind = "convenience",
        skills = { "INVENTION" },
        members = true,
        title = "Invention cape",
        icon_item = "SKILLCAPE_INVENTION",
        hook = "The Invention cape offers longer-lasting charge-pack energy.",
        why = "Its perk reduces the drain rate of charges from your charge pack.",
        how = {
            "Buy it from Doc at the Invention Guild.",
        },
        requirements = {
            skills = { CRAFTING = 80, DIVINATION = 80, INVENTION = 99, SMITHING = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "INVENTION" },
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

    -- training methods, one main method per level bracket
    {
        id = "invention.method.equipment_levels",
        kind = "method",
        skills = { "INVENTION" },
        members = true,
        level_range = { 4, 26 },
        main_method = true,
        title = "Equipment levels",
        icon_item_id = 7936,
        hook = "Researching equipment levels opens a route beyond basic disassembly.",
        why = "Augmented equipment gains item experience as you use it. Disassembly trades the "
            .. "item for Invention experience and materials.",
        how = {
            "Discover the maximum equipment level blueprint at a workbench, and choose equipment "
                .. "you are willing to lose.",
        },
        requirements = {
            skills = { CRAFTING = 80, DIVINATION = 80, INVENTION = 4, SMITHING = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "INVENTION", level = 4 },
        },
        priority = 2,
    },

    {
        id = "invention.method.siphoning",
        kind = "method",
        skills = { "INVENTION" },
        members = true,
        level_range = { 27, 120 },
        main_method = true,
        title = "Siphoning equipment",
        icon_item_id = 7936,
        hook = "Siphoning lets you train Invention while keeping augmented equipment.",
        why = "Equipment gains item experience as you use it. Siphoning resets that experience "
            .. "without destroying the gear.",
        how = {
            "Research the equipment level upgrades and siphons at an Invention workbench.",
        },
        requirements = {
            skills = { CRAFTING = 80, DIVINATION = 80, INVENTION = 27, SMITHING = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "INVENTION", level = 27 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "invention.alt.discovery",
        kind = "method",
        skills = { "INVENTION" },
        members = true,
        level_range = { 4, 118 },
        title = "Blueprint discovery",
        icon_item_id = 7936,
        hook = "Blueprint discovery offers useful unlocks alongside Invention experience.",
        why = "New discoveries open as you level. Better optimisation gives more experience for "
            .. "each blueprint.",
        how = {
            "Check the discovery side of an Invention workbench when you have new levels.",
        },
        requirements = {
            skills = { CRAFTING = 80, DIVINATION = 80, INVENTION = 4, SMITHING = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "INVENTION" },
        },
        priority = 3,
    },

    {
        id = "invention.alt.skilling_tools",
        kind = "method",
        skills = { "INVENTION" },
        members = true,
        level_range = { 22, 120 },
        title = "Levelling skilling tools",
        icon_item_id = 7936,
        hook = "Augmented skilling tools let your usual training build Invention progress too.",
        why = "Supported tools gain item experience while used, ready for later disassembly or "
            .. "siphoning.",
        how = {
            "Start with a tool blueprint such as the hammer-tron or pyro-matic, or inspect "
                .. "augmentation for a tool you already use.",
        },
        requirements = {
            skills = { CRAFTING = 80, DIVINATION = 80, INVENTION = 22, SMITHING = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "INVENTION" },
        },
        priority = 3,
    },

    {
        id = "invention.alt.gizmos",
        kind = "method",
        skills = { "INVENTION" },
        members = true,
        level_range = { 103, 120 },
        title = "Making ancient gizmos",
        icon_item_id = 7936,
        hook = "Ancient gizmos offer a faster but expensive Invention training option.",
        why = "High-level components give substantial experience when used in a gizmo, but using "
            .. "them only for experience consumes valuable materials.",
        how = {
            "After researching Ancient gizmos, compare component costs before trying a small "
                .. "batch.",
        },
        requirements = {
            skills = { CRAFTING = 80, DIVINATION = 80, INVENTION = 103, SMITHING = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "INVENTION" },
        },
        priority = 3,
    },
}
