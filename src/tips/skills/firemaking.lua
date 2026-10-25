-- firemaking tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field

return {
    -- useful items and unlocks
    {
        id = "firemaking.fired_up",
        kind = "convenience",
        skills = { "FIREMAKING" },
        members = true,
        title = "Fired up set",
        icon_item = "FIREDUP_RING",
        hook = "The ring of fire and flame gloves reward a longer-term Firemaking challenge.",
        why = "Both boost Firemaking experience when worn; the gloves are a later step beyond the "
            .. "ring.",
        how = {
            "After All Fired Up, look at King Roald's beacon-lighting rewards.",
        },
        quest_how = {
            "Complete All Fired Up, then explore King Roald's beacon-lighting rewards.",
        },
        requirements = {
            skills = { FIREMAKING = 62 },
            quests = { "ALL_FIRED_UP" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FIREMAKING" },
        },
        known_when = {
            { type = "owns_any", items = { "FIREDUP_GLOVES", "FIREDUP_RING" } },
        },
        priority = 2,
    },

    {
        id = "firemaking.pyro_matic",
        kind = "convenience",
        skills = { "FIREMAKING" },
        members = true,
        min_training_level = 50,
        title = "Pyro-matic",
        icon_item = "INVENT_TINDERBOX",
        hook = "A pyro-matic brings Invention perks to Firemaking.",
        why = "It gains equipment experience as you burn logs and uses energy from your charge "
            .. "pack.",
        how = {
            "Discover it at an Invention workbench. Enhanced and crystal tools offer later "
                .. "upgrades.",
        },
        requirements = {
            skills = { FIREMAKING = 1, INVENTION = 22 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FIREMAKING" },
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
        kind = "convenience",
        skills = { "FIREMAKING" },
        members = true,
        min_training_level = 60,
        title = "Crystal tinderbox",
        icon_item = "ELFCITY_CRYSTAL_TINDERBOX_100",
        hook = "A crystal tinderbox adds experience when burning logs.",
        why = "It can also be augmented to carry tool perks and gain equipment experience.",
        how = {
            "After Roving Elves, take a crystal tool seed to Ilfeen and ask about singing tools.",
        },
        quest_how = {
            "Look into Roving Elves, then ask Ilfeen about singing crystal tools.",
        },
        requirements = {
            skills = { AGILITY = 56, FIREMAKING = 1, RANGED = 25 },
            quests = { "ROVING_ELVES" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FIREMAKING" },
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
        kind = "convenience",
        skills = { "FIREMAKING" },
        members = true,
        title = "Pitch can",
        icon_item = "FMC_PITCH_CAN_EMPTY",
        hook = "A pitch can speeds up burning logs.",
        why = "It helps with bonfires and fire lines, and can be refilled rather than replaced.",
        how = {
            "After The Firemaker's Curse, try Char's training cave to earn and refill one.",
        },
        quest_how = {
            "Work towards The Firemaker's Curse, then explore Char's training cave.",
        },
        requirements = {
            skills = { AGILITY = 64, FIREMAKING = 91, HITPOINTS = 76 },
            quests = { "FIREMAKERS_CURSE" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FIREMAKING" },
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
        kind = "convenience",
        skills = { "FIREMAKING" },
        members = true,
        title = "Firemaking cape",
        icon_item = "SKILLCAPE_FIREMAKING",
        hook = "The Firemaking cape offers a glowing reward for mastery.",
        why = "It works as a light source while you explore dark places.",
        how = {
            "Buy it from Ignatius Vulcan in the forest south of Seers' Village.",
        },
        requirements = {
            skills = { FIREMAKING = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FIREMAKING" },
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

    -- training methods, one main method per level bracket
    {
        id = "firemaking.method.oak",
        kind = "method",
        skills = { "FIREMAKING" },
        members = false,
        level_range = { 15, 29 },
        main_method = true,
        title = "Oak bonfires",
        icon_item_id = 1521,
        hook = "Oak logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile "
            .. "tradeoff.",
        how = {
            "Light a log, then add more logs to the fire—or use an existing bonfire near a bank.",
        },
        requirements = {
            skills = { FIREMAKING = 15 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FIREMAKING", level = 15 },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.willow",
        kind = "method",
        skills = { "FIREMAKING" },
        members = false,
        level_range = { 30, 34 },
        main_method = true,
        title = "Willow bonfires",
        icon_item_id = 1519,
        hook = "Willow logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile "
            .. "tradeoff.",
        how = {
            "Light a log, then add more logs to the fire—or use an existing bonfire near a bank.",
        },
        requirements = {
            skills = { FIREMAKING = 30 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FIREMAKING", level = 30 },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.teak",
        kind = "method",
        skills = { "FIREMAKING" },
        members = true,
        level_range = { 35, 44 },
        main_method = true,
        title = "Teak bonfires",
        icon_item_id = 6333,
        hook = "Teak logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile "
            .. "tradeoff.",
        how = {
            "Light a log, then add more logs to the fire—or use an existing bonfire near a bank.",
        },
        requirements = {
            skills = { FIREMAKING = 35 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FIREMAKING", level = 35 },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.maple",
        kind = "method",
        skills = { "FIREMAKING" },
        members = false,
        level_range = { 45, 49 },
        main_method = true,
        title = "Maple bonfires",
        icon_item_id = 1517,
        hook = "Maple logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile "
            .. "tradeoff.",
        how = {
            "Light a log, then add more logs to the fire—or use an existing bonfire near a bank.",
        },
        requirements = {
            skills = { FIREMAKING = 45 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FIREMAKING", level = 45 },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.mahogany",
        kind = "method",
        skills = { "FIREMAKING" },
        members = true,
        level_range = { 50, 57 },
        main_method = true,
        title = "Mahogany bonfires",
        icon_item_id = 6332,
        hook = "Mahogany logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile "
            .. "tradeoff.",
        how = {
            "Light a log, then add more logs to the fire—or use an existing bonfire near a bank.",
        },
        requirements = {
            skills = { FIREMAKING = 50 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FIREMAKING", level = 50 },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.eucalyptus",
        kind = "method",
        skills = { "FIREMAKING" },
        members = true,
        level_range = { 58, 59 },
        main_method = true,
        title = "Eucalyptus bonfires",
        icon_item_id = 12581,
        hook = "Eucalyptus logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile "
            .. "tradeoff.",
        how = {
            "Light a log, then add more logs to the fire—or use an existing bonfire near a bank.",
        },
        requirements = {
            skills = { FIREMAKING = 58 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FIREMAKING", level = 58 },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.yew",
        kind = "method",
        skills = { "FIREMAKING" },
        members = false,
        level_range = { 60, 74 },
        main_method = true,
        title = "Yew bonfires",
        icon_item_id = 1515,
        hook = "Yew logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile "
            .. "tradeoff.",
        how = {
            "Light a log, then add more logs to the fire—or use an existing bonfire near a bank.",
        },
        requirements = {
            skills = { FIREMAKING = 60 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FIREMAKING", level = 60 },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.magic",
        kind = "method",
        skills = { "FIREMAKING" },
        members = false,
        level_range = { 75, 89 },
        main_method = true,
        title = "Magic bonfires",
        icon_item_id = 1513,
        hook = "Magic logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile "
            .. "tradeoff.",
        how = {
            "Light a log, then add more logs to the fire—or use an existing bonfire near a bank.",
        },
        requirements = {
            skills = { FIREMAKING = 75 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FIREMAKING", level = 75 },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.elder",
        kind = "method",
        skills = { "FIREMAKING" },
        members = true,
        level_range = { 90, 99 },
        main_method = true,
        title = "Elder bonfires",
        icon_item_id = 29556,
        hook = "Elder logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile "
            .. "tradeoff.",
        how = {
            "Light a log, then add more logs to the fire—or use an existing bonfire near a bank.",
        },
        requirements = {
            skills = { FIREMAKING = 90 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FIREMAKING", level = 90 },
        },
        priority = 2,
    },

    {
        id = "firemaking.method.eternal_magic",
        kind = "method",
        skills = { "FIREMAKING" },
        members = true,
        level_range = { 100, 120 },
        main_method = true,
        title = "Eternal magic bonfires",
        icon_item_id = 58250,
        hook = "Eternal magic logs offer a bonfire option at this stage.",
        why = "Higher log tiers give more experience, but cheaper logs can be a worthwhile "
            .. "tradeoff.",
        how = {
            "Light a log, then add more logs to the fire—or use an existing bonfire near a bank.",
        },
        requirements = {
            skills = { FIREMAKING = 100 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FIREMAKING", level = 100 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "firemaking.alt.accidental",
        kind = "method",
        skills = { "FIREMAKING" },
        members = true,
        level_range = { 82, 109 },
        title = "Anachronia egg care",
        icon_item_id = 1513,
        hook = "Anachronia egg care offers a more active alternative to burning bought logs.",
        why = "The activity supplies its own materials and awards tradeable resources as you work.",
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
                FIREMAKING = 82,
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
            { type = "training", skill = "FIREMAKING" },
        },
        priority = 3,
    },

    {
        id = "firemaking.alt.curly_roots",
        kind = "method",
        skills = { "FIREMAKING" },
        members = true,
        level_range = { 83, 99 },
        title = "Curly roots",
        icon_item_id = 1513,
        hook = "Curly roots offer Firemaking experience from supplies you gather yourself.",
        why = "Chop the hanging curly roots and burn them in the nearby firepits, with no log "
            .. "purchases needed.",
        how = {
            "Visit the Jadinko Lair and look for curly roots rather than straight ones.",
        },
        requirements = {
            skills = { FIREMAKING = 83, WOODCUTTING = 83 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FIREMAKING" },
        },
        priority = 3,
    },

    {
        id = "firemaking.alt.shells",
        kind = "method",
        skills = { "FIREMAKING" },
        members = true,
        level_range = { 87, 109 },
        title = "Sharp shell shards",
        icon_item_id = 1513,
        hook = "Sharp shell shards offer longer Firemaking batches away from a bonfire.",
        why = "They can be ignited one after another from your backpack, with supply cost as the "
            .. "main tradeoff.",
        how = {
            "Look for sharp shell shards on the Grand Exchange and try their Ignite option.",
        },
        requirements = {
            skills = { FIREMAKING = 87 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FIREMAKING" },
        },
        priority = 3,
    },
}
