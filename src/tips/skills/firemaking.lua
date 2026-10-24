-- useful items and unlocks, then main methods and alternatives in level order.
-- source access and recommendation windows: docs/artisan-coverage.md.

return {
    {
        id = "firemaking.fired_up",
        icon_item = "FIREDUP_RING",
        kind = "convenience",
        skills = { "FIREMAKING" },
        members = true,
        title = "Fired up set",
        hook = "The ring of fire and flame gloves reward a longer-term Firemaking challenge.",
        why = "Both boost Firemaking experience when worn; the gloves are a later step beyond the ring.",
        how = { "After All Fired Up, look at King Roald's beacon-lighting rewards." },
        requirements = {
            skills = {
                FIREMAKING = 62,
            },
            quests = { "ALL_FIRED_UP" },
        },
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "FIREMAKING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "FIREDUP_GLOVES", "FIREDUP_RING" },
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.pyro_matic",
        icon_item = "INVENT_TINDERBOX",
        kind = "convenience",
        skills = { "FIREMAKING" },
        members = true,
        title = "Pyro-matic",
        hook = "A pyro-matic brings Invention perks to Firemaking.",
        why = "It gains equipment experience as you burn logs and uses energy from your charge pack.",
        how = {
            "Discover it at an Invention workbench. Enhanced and crystal tools offer later upgrades.",
        },
        requirements = {
            skills = {
                FIREMAKING = 1,
                INVENTION = 22,
            },
        },
        min_training_level = 50,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FIREMAKING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "ELFCITY_CRYSTAL_TINDERBOX_100",
                    "ELFCITY_CRYSTAL_TINDERBOX_50",
                    "ELFCITY_CRYSTAL_TINDERBOX_AUGMENTED",
                    "ELFCITY_CRYSTAL_TINDERBOX_AUGMENTED_UNCHARGED",
                    "INVENT_ENHANCED_TINDERBOX",
                    "INVENT_ENHANCED_TINDERBOX_UNCHARGED",
                    "INVENT_ENHANCED_TINDERBOX_UNUSED",
                    "INVENT_TINDERBOX",
                    "INVENT_TINDERBOX_UNCHARGED",
                    "INVENT_TINDERBOX_UNUSED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.crystal_tinderbox",
        icon_item = "ELFCITY_CRYSTAL_TINDERBOX_100",
        kind = "convenience",
        skills = { "FIREMAKING" },
        members = true,
        title = "Crystal tinderbox",
        hook = "A crystal tinderbox adds experience when burning logs.",
        why = "It can also be augmented to carry tool perks and gain equipment experience.",
        how = {
            "After Roving Elves, take a crystal tool seed to Ilfeen and ask about singing tools.",
        },
        requirements = {
            skills = {
                FIREMAKING = 1,
            },
            quests = { "ROVING_ELVES" },
        },
        min_training_level = 60,
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "FIREMAKING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "ELFCITY_CRYSTAL_TINDERBOX_100",
                    "ELFCITY_CRYSTAL_TINDERBOX_50",
                    "ELFCITY_CRYSTAL_TINDERBOX_AUGMENTED",
                    "ELFCITY_CRYSTAL_TINDERBOX_AUGMENTED_UNCHARGED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.pitch_can",
        icon_item = "FMC_PITCH_CAN_EMPTY",
        kind = "convenience",
        skills = { "FIREMAKING" },
        members = true,
        title = "Pitch can",
        hook = "A pitch can speeds up burning logs.",
        why = "It helps with bonfires and fire lines, and can be refilled rather than replaced.",
        how = { "After The Firemaker's Curse, try Char's training cave to earn and refill one." },
        requirements = {
            skills = {
                FIREMAKING = 91,
            },
            quests = { "FIREMAKERS_CURSE" },
        },
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "FIREMAKING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "FMC_PITCH_CAN_EMPTY", "FMC_PITCH_CAN_FULL", "FMC_PITCH_CAN_USED" },
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.cape",
        icon_item = "SKILLCAPE_FIREMAKING",
        kind = "convenience",
        skills = { "FIREMAKING" },
        members = true,
        title = "Firemaking cape",
        hook = "The Firemaking cape offers a glowing reward for mastery.",
        why = "It works as a light source while you explore dark places.",
        how = { "Buy it from Ignatius Vulcan in the forest south of Seers' Village." },
        requirements = {
            skills = {
                FIREMAKING = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FIREMAKING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_FIREMAKING",
                    "SKILLCAPE_FIREMAKING_HOODED",
                    "SKILLCAPE_FIREMAKING_HOODED_RETRO",
                    "SKILLCAPE_FIREMAKING_RETRO",
                    "SKILLCAPE_FIREMAKING_TRIMMED",
                    "SKILLCAPE_FIREMAKING_TRIMMED_HOODED",
                    "SKILLCAPE_FIREMAKING_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_FIREMAKING_TRIMMED_RETRO",
                    "SKILLCAPE_INVERTED_FIREMAKING_HOODED",
                    "SKILLCAPE_INVERTED_FIREMAKING_TRIMMED_HOODED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.oak",
        main_method = true,
        icon_item_id = 1521,
        kind = "method",
        skills = { "FIREMAKING" },
        level_range = { 15, 29 },
        members = false,
        title = "Oak bonfires",
        hook = "Oak logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile tradeoff.",
        how = {
            "Add a small batch to an ordinary bonfire near a bank before buying a larger supply.",
        },
        requirements = {
            skills = {
                FIREMAKING = 15,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FIREMAKING",
                level = 15,
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.willow",
        main_method = true,
        icon_item_id = 1519,
        kind = "method",
        skills = { "FIREMAKING" },
        level_range = { 30, 34 },
        members = false,
        title = "Willow bonfires",
        hook = "Willow logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile tradeoff.",
        how = {
            "Add a small batch to an ordinary bonfire near a bank before buying a larger supply.",
        },
        requirements = {
            skills = {
                FIREMAKING = 30,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FIREMAKING",
                level = 30,
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.teak",
        main_method = true,
        icon_item_id = 6333,
        kind = "method",
        skills = { "FIREMAKING" },
        level_range = { 35, 44 },
        members = true,
        title = "Teak bonfires",
        hook = "Teak logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile tradeoff.",
        how = {
            "Add a small batch to an ordinary bonfire near a bank before buying a larger supply.",
        },
        requirements = {
            skills = {
                FIREMAKING = 35,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FIREMAKING",
                level = 35,
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.maple",
        main_method = true,
        icon_item_id = 1517,
        kind = "method",
        skills = { "FIREMAKING" },
        level_range = { 45, 49 },
        members = false,
        title = "Maple bonfires",
        hook = "Maple logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile tradeoff.",
        how = {
            "Add a small batch to an ordinary bonfire near a bank before buying a larger supply.",
        },
        requirements = {
            skills = {
                FIREMAKING = 45,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FIREMAKING",
                level = 45,
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.mahogany",
        main_method = true,
        icon_item_id = 6332,
        kind = "method",
        skills = { "FIREMAKING" },
        level_range = { 50, 57 },
        members = true,
        title = "Mahogany bonfires",
        hook = "Mahogany logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile tradeoff.",
        how = {
            "Add a small batch to an ordinary bonfire near a bank before buying a larger supply.",
        },
        requirements = {
            skills = {
                FIREMAKING = 50,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FIREMAKING",
                level = 50,
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.eucalyptus",
        main_method = true,
        icon_item_id = 12581,
        kind = "method",
        skills = { "FIREMAKING" },
        level_range = { 58, 59 },
        members = true,
        title = "Eucalyptus bonfires",
        hook = "Eucalyptus logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile tradeoff.",
        how = {
            "Add a small batch to an ordinary bonfire near a bank before buying a larger supply.",
        },
        requirements = {
            skills = {
                FIREMAKING = 58,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FIREMAKING",
                level = 58,
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.yew",
        main_method = true,
        icon_item_id = 1515,
        kind = "method",
        skills = { "FIREMAKING" },
        level_range = { 60, 74 },
        members = false,
        title = "Yew bonfires",
        hook = "Yew logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile tradeoff.",
        how = {
            "Add a small batch to an ordinary bonfire near a bank before buying a larger supply.",
        },
        requirements = {
            skills = {
                FIREMAKING = 60,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FIREMAKING",
                level = 60,
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.magic",
        main_method = true,
        icon_item_id = 1513,
        kind = "method",
        skills = { "FIREMAKING" },
        level_range = { 75, 89 },
        members = false,
        title = "Magic bonfires",
        hook = "Magic logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile tradeoff.",
        how = {
            "Add a small batch to an ordinary bonfire near a bank before buying a larger supply.",
        },
        requirements = {
            skills = {
                FIREMAKING = 75,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FIREMAKING",
                level = 75,
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.elder",
        main_method = true,
        icon_item_id = 29556,
        kind = "method",
        skills = { "FIREMAKING" },
        level_range = { 90, 99 },
        members = true,
        title = "Elder bonfires",
        hook = "Elder logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile tradeoff.",
        how = {
            "Add a small batch to an ordinary bonfire near a bank before buying a larger supply.",
        },
        requirements = {
            skills = {
                FIREMAKING = 90,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FIREMAKING",
                level = 90,
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.eternal_magic",
        main_method = true,
        icon_item_id = 58250,
        kind = "method",
        skills = { "FIREMAKING" },
        level_range = { 100, 120 },
        members = true,
        title = "Eternal magic bonfires",
        hook = "Eternal magic logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile tradeoff.",
        how = {
            "Add a small batch to an ordinary bonfire near a bank before buying a larger supply.",
        },
        requirements = {
            skills = {
                FIREMAKING = 100,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FIREMAKING",
                level = 100,
            },
        },
        priority = 2,
    },

    {
        id = "firemaking.alt.accidental",
        icon_item_id = 1513,
        kind = "method",
        skills = { "FIREMAKING" },
        level_range = { 82, 109 },
        members = true,
        title = "Anachronia egg care",
        hook = "Anachronia egg care offers a more active alternative to burning bought logs.",
        why = "The activity supplies its own materials and awards tradeable resources as you work.",
        how = { "After Extinction, visit Prehistoric Potterington's activity on Anachronia." },
        requirements = {
            skills = {
                FIREMAKING = 82,
            },
            quests = { "EGW_FINALE" },
        },
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "FIREMAKING",
            },
        },
        priority = 3,
    },

    {
        id = "firemaking.alt.curly_roots",
        icon_item_id = 1513,
        kind = "method",
        skills = { "FIREMAKING" },
        level_range = { 83, 99 },
        members = true,
        title = "Curly roots",
        hook = "Curly roots offer Firemaking experience from supplies you gather yourself.",
        why = "Chop the hanging curly roots and burn them in the nearby firepits, with no log purchases needed.",
        how = { "Visit the Jadinko Lair and look for curly roots rather than straight ones." },
        requirements = {
            skills = {
                FIREMAKING = 83,
                WOODCUTTING = 83,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FIREMAKING",
            },
        },
        priority = 3,
    },

    {
        id = "firemaking.alt.shells",
        icon_item_id = 1513,
        kind = "method",
        skills = { "FIREMAKING" },
        level_range = { 87, 109 },
        members = true,
        title = "Sharp shell shards",
        hook = "Sharp shell shards offer longer Firemaking batches away from a bonfire.",
        why = "They can be ignited one after another from your backpack, with supply cost as the main tradeoff.",
        how = { "Look for sharp shell shards on the Grand Exchange and try their Ignite option." },
        requirements = {
            skills = {
                FIREMAKING = 87,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FIREMAKING",
            },
        },
        priority = 3,
    },
}
