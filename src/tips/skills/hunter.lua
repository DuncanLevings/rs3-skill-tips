-- useful items and unlocks first, then level-bracket methods and alternatives.
-- access and relevance evidence is recorded in docs/gathering-coverage.md.

return {
    -- useful items and unlocks

    {
        id = "hunter.hunters_outfit",
        icon_item = "ELR2_HUNTER_HEAD",
        kind = "convenience",
        skills = { "HUNTER" },
        members = true,
        title = "Hunter's outfit",
        hook = "The Hunter's outfit adds experience to your catches.",
        why = "Each piece contributes, with an extra bonus for wearing the full set.",
        how = {
            "The Waiko Reward Shop sells the pieces for chimes and taijitu after Impressing the Locals.",
        },
        requirements = {
            skills = {
                HUNTER = 1,
            },
            quests = { "ELR0" },
        },
        min_training_level = 30,
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "HUNTER",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "ELR2_HUNTER_BODY",
                    "ELR2_HUNTER_FEET",
                    "ELR2_HUNTER_HANDS",
                    "ELR2_HUNTER_HEAD",
                    "ELR2_HUNTER_LEGS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "hunter.trapper_outfits",
        icon_item = "TRH127_VOLCANIC_HEAD",
        kind = "convenience",
        skills = { "HUNTER" },
        members = true,
        title = "Trapper outfits",
        hook = "Trapper outfits offer better catch chances and useful hunting teleports.",
        why = "Matching sets provide benefits, and combining the desert, jungle and arctic sets makes the volcanic outfit.",
        how = {
            "Buy the blueprint from the Hunter mark shop, then use trapper fragments at an Invention workbench.",
        },
        requirements = {
            skills = {
                HUNTER = 80,
                INVENTION = 20,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "HUNTER",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH127_ARCTIC_BODY",
                    "TRH127_ARCTIC_FEET",
                    "TRH127_ARCTIC_HANDS",
                    "TRH127_ARCTIC_HEAD",
                    "TRH127_ARCTIC_LEGS",
                    "TRH127_DESERT_BODY",
                    "TRH127_DESERT_FEET",
                    "TRH127_DESERT_HANDS",
                    "TRH127_DESERT_HEAD",
                    "TRH127_DESERT_LEGS",
                    "TRH127_JUNGLE_BODY",
                    "TRH127_JUNGLE_FEET",
                    "TRH127_JUNGLE_HANDS",
                    "TRH127_JUNGLE_HEAD",
                    "TRH127_JUNGLE_LEGS",
                    "TRH127_VOLCANIC_BODY",
                    "TRH127_VOLCANIC_FEET",
                    "TRH127_VOLCANIC_HANDS",
                    "TRH127_VOLCANIC_HEAD",
                    "TRH127_VOLCANIC_LEGS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "hunter.catalyst_fragment",
        icon_item = "QUEST_ENDGAME_SHARD_HUNTER",
        kind = "convenience",
        skills = { "HUNTER" },
        members = true,
        title = "Hunter's Catalyst fragment",
        hook = "The Hunter's Catalyst fragment can save time resetting traps.",
        why = "Its effect resets supported traps when they fail to catch a creature, leaving less to set up again.",
        how = { "It's a reward from Sliske's Endgame." },
        requirements = {
            skills = {
                HUNTER = 1,
            },
            quests = { "SLISKES_ENDGAME" },
        },
        min_training_level = 50,
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "HUNTER",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "QUEST_ENDGAME_SHARD_HUNTER", "QUEST_ENDGAME_SHARD_COMBINED" },
            },
        },
        priority = 2,
    },

    {
        id = "hunter.enhanced_yaktwee",
        icon_item = "HUNTCHARM_STAVE_ENHANCED",
        kind = "convenience",
        skills = { "HUNTER" },
        members = true,
        title = "Enhanced yaktwee stick",
        hook = "The enhanced yaktwee stick adds an experience boost to many Hunter activities.",
        why = "It also helps reveal rarer charm sprites while you hunt them.",
        how = {
            "Catch charm sprites with a yaktwee stick, then ask Yaktwee Swinmari Cianta about upgrading it.",
        },
        requirements = {
            skills = {
                HUNTER = 72,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "HUNTER",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "HUNTCHARM_STAVE_ENHANCED" },
            },
        },
        priority = 2,
    },

    {
        id = "hunter.hypnowand",
        icon_item = "SKILLING_OFFHAND_HUNTER",
        kind = "convenience",
        skills = { "HUNTER" },
        members = true,
        title = "Skeka's hypnowand",
        hook = "Skeka's hypnowand offers bonuses across several hunting styles.",
        why = "The off-hand helps with whirligigs, box traps and Big Game Hunter.",
        how = {
            "Complete On the Threshold of the Mind research and read the aged journal in Daemonheim before hunting for its pieces, or buy the finished wand.",
        },
        requirements = {
            skills = {
                ARCHAEOLOGY = 103,
                DUNGEONEERING = 95,
                HUNTER = 80,
            },
        },
        min_training_level = 80,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "HUNTER",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "SKILLING_OFFHAND_HUNTER" },
            },
        },
        priority = 2,
    },

    {
        id = "hunter.trap_supplies",
        icon_item_id = 10006,
        kind = "general",
        skills = { "HUNTER" },
        members = true,
        title = "Hunter supplies",
        hook = "Different hunting methods use different traps; you do not need to find them as drops.",
        why = "Hunter shops stock the basic equipment for birds, butterflies and box-trap creatures.",
        how = { "Visit a Hunter shop before heading to a new hunting area." },
        requirements = {
            skills = {
                HUNTER = 1,
            },
        },
        triggers = {
            {
                type = "training",
                skill = "HUNTER",
            },
        },
        priority = 3,
    },

    {
        id = "hunter.extra_traps",
        icon_item_id = 10008,
        kind = "general",
        skills = { "HUNTER" },
        members = true,
        title = "More traps",
        hook = "As your Hunter level rises, you can keep more traps working at once.",
        why = "Using your available trap limit reduces time spent waiting for the next catch.",
        how = { "Try adding another trap to your hunting spot when your level allows it." },
        requirements = {
            skills = {
                HUNTER = 20,
            },
        },
        triggers = {
            {
                type = "training",
                skill = "HUNTER",
            },
        },
        priority = 3,
    },

    {
        id = "hunter.cape",
        icon_item = "SKILLCAPE_HUNTING",
        kind = "convenience",
        skills = { "HUNTER" },
        members = true,
        title = "Hunter cape",
        hook = "The Hunter cape can speed up placing and resetting traps.",
        why = "Its activated perk lets your next supported trap go down quickly.",
        how = { "Buy it from the Hunting expert in the Feldip Hills and try its Activate option." },
        requirements = {
            skills = {
                HUNTER = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "HUNTER",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_HUNTING",
                    "SKILLCAPE_HUNTING_HOODED",
                    "SKILLCAPE_HUNTING_HOODED_RETRO",
                    "SKILLCAPE_HUNTING_RETRO",
                    "SKILLCAPE_HUNTING_TRIMMED",
                    "SKILLCAPE_HUNTING_TRIMMED_HOODED",
                    "SKILLCAPE_HUNTING_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_HUNTING_TRIMMED_RETRO",
                },
            },
        },
        priority = 2,
    },

    -- training methods

    {
        id = "hunter.method.cerulean_twitches",
        main_method = true,
        icon_item_id = 10089,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 11, 18 },
        members = true,
        title = "Cerulean twitches",
        hook = "Cerulean twitches offer another bird-snaring option in the Rellekka Hunter area.",
        why = "These blue birds give more experience per catch than crimson swifts.",
        how = {
            "Look along the south-eastern shore of the Rellekka Hunter area with a bird snare.",
        },
        requirements = {
            skills = {
                HUNTER = 11,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 11,
            },
        },
        priority = 2,
    },

    {
        id = "hunter.method.tropical_wagtails",
        main_method = true,
        icon_item_id = 10087,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 19, 29 },
        members = true,
        title = "Tropical wagtails",
        hook = "Tropical wagtails offer clustered catches for keeping several bird snares busy.",
        why = "Their clustered spawns make it easier to keep your snares busy.",
        how = { "Take bird snares to the area north of the Monastery of Ascension." },
        requirements = {
            skills = {
                HUNTER = 19,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 19,
            },
        },
        priority = 2,
    },

    {
        id = "hunter.method.gliding_whirligigs",
        main_method = true,
        icon_item_id = 52796,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 30, 49 },
        members = true,
        title = "Gliding whirligigs",
        hook = "Gliding whirligigs offer Hunter training with your crocodile at Het's Oasis.",
        why = "Your crocodile catches them for you, and Dundee offers upgrades as you build up catches.",
        how = { "Head to Het's Oasis and fill a built flower basket with roses to attract them." },
        requirements = {
            skills = {
                HUNTER = 30,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 30,
            },
        },
        priority = 2,
    },

    {
        id = "hunter.method.swift_whirligigs",
        main_method = true,
        icon_item_id = 52797,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 50, 69 },
        members = true,
        title = "Swift whirligigs",
        hook = "Swift whirligigs offer Hunter training with your crocodile at Het's Oasis.",
        why = "Your crocodile catches them for you, and Dundee offers upgrades as you build up catches.",
        how = { "Head to Het's Oasis and fill a built flower basket with irises to attract them." },
        requirements = {
            skills = {
                HUNTER = 50,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 50,
            },
        },
        priority = 2,
    },

    {
        id = "hunter.method.hasty_whirligigs",
        main_method = true,
        icon_item_id = 52798,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 70, 89 },
        members = true,
        title = "Hasty whirligigs",
        hook = "Hasty whirligigs offer Hunter training with your crocodile at Het's Oasis.",
        why = "Your crocodile catches them for you, and Dundee offers upgrades as you build up catches.",
        how = {
            "Head to Het's Oasis and fill a built flower basket with hydrangeas to attract them.",
        },
        requirements = {
            skills = {
                HUNTER = 70,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 70,
            },
        },
        priority = 2,
    },

    {
        id = "hunter.method.speedy_whirligigs",
        main_method = true,
        icon_item_id = 52799,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 90, 120 },
        members = true,
        title = "Speedy whirligigs",
        hook = "Speedy whirligigs offer Hunter training with your crocodile at Het's Oasis.",
        why = "Your crocodile catches them for you, and Dundee offers upgrades as you build up catches.",
        how = {
            "Head to Het's Oasis and fill a built flower basket with hollyhocks to attract them.",
        },
        requirements = {
            skills = {
                HUNTER = 90,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 90,
            },
        },
        priority = 2,
    },

    -- alternative methods

    {
        id = "hunter.alt.birdhouses",
        icon_item_id = 10006,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 5, 120 },
        members = true,
        title = "Birdhouse runs",
        hook = "Birdhouse runs offer a different rhythm from watching traps.",
        why = "Visit the Havenhythe plots between other activities for catches and nests. Higher-tier birdhouses offer more experience as Hunter improves.",
        how = {
            "Buy suitable birdhouses and bring bait seeds to the Havenhythe plots, or craft your own with the appropriate Crafting and Fletching levels.",
        },
        requirements = {
            skills = {
                HUNTER = 5,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 5,
            },
        },
        priority = 3,
    },

    {
        id = "hunter.alt.plain_whirligigs",
        icon_item_id = 10088,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 16, 29 },
        members = true,
        title = "Plain whirligigs",
        hook = "Plain whirligigs offer an early way to try hunting with a crocodile.",
        why = "The crocodile handles the catches at Het's Oasis while you build up experience and catches for upgrades.",
        how = {
            "Speak to Dundee at Het's Oasis and use a built flower basket with the appropriate bait.",
        },
        requirements = {
            skills = {
                HUNTER = 16,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 16,
            },
        },
        priority = 3,
    },

    {
        id = "hunter.alt.skillchompas",
        icon_item_id = 31595,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 27, 120 },
        members = true,
        title = "Hunting skillchompas",
        hook = "Skillchompas offer box-trap training with catches you can keep or sell.",
        why = "Cobalt skillchompas are the first type; higher Hunter levels open further varieties.",
        how = {
            "Use box traps at a skillchompa colony that suits your Hunter level. Eagles' Peak unlocks box trapping.",
        },
        requirements = {
            skills = {
                HUNTER = 27,
            },
            quests = { "EAGLES_PEAK" },
        },
        require_quests_complete = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 27,
            },
        },
        priority = 3,
    },

    {
        id = "hunter.alt.red_salamanders",
        icon_item_id = 10147,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 59, 66 },
        members = true,
        title = "Red salamanders",
        hook = "Prefer setting traps? Red salamanders are another way to train from 59 Hunter.",
        why = "Net traps offer a change from whirligigs and let you work several catches at once.",
        how = {
            "Bring ropes and small fishing nets to the hunting area outside Ourania, north of Castle Wars.",
        },
        requirements = {
            skills = {
                HUNTER = 59,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 59,
            },
        },
        priority = 3,
    },

    {
        id = "hunter.alt.red_chinchompas",
        icon_item_id = 10034,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 63, 79 },
        members = true,
        title = "Carnivorous chinchompas",
        hook = "Carnivorous chinchompas turn box-trap catches into a tradeable resource.",
        why = "They are an alternative when you want to gather something useful while training.",
        how = {
            "Complete Eagles' Peak to unlock box traps, then hunt them in the Feldip Hunter area.",
        },
        requirements = {
            skills = {
                HUNTER = 63,
            },
            quests = { "EAGLES_PEAK" },
        },
        require_quests_complete = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 63,
            },
        },
        priority = 3,
    },

    {
        id = "hunter.alt.black_salamanders",
        icon_item_id = 10148,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 67, 79 },
        members = true,
        title = "Black salamanders",
        hook = "Black salamanders offer another net-trapping option.",
        why = "They give a change from box traps and whirligigs, but their hunting ground is in the Wilderness.",
        how = {
            "Bring ropes and small fishing nets to the area near the Chaos Temple. Check your Wilderness opt-in status before travelling.",
        },
        requirements = {
            skills = {
                HUNTER = 67,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 67,
            },
        },
        priority = 3,
    },

    {
        id = "hunter.alt.charm_sprites",
        icon_item_id = 12160,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 72, 87 },
        members = true,
        title = "Charm sprites",
        hook = "Charm sprites offer Hunter experience alongside Summoning charms.",
        why = "Following their trails and catching the sprites makes this a more active hunting option.",
        how = {
            "Speak to Yaktwee Swinmari Cianta south-west of the Tree Gnome Stronghold for a yaktwee stick and sprite lure.",
        },
        requirements = {
            skills = {
                HUNTER = 72,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 72,
            },
        },
        priority = 3,
    },

    {
        id = "hunter.alt.big_game_hunter",
        icon_item_id = 47948,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 75, 110 },
        members = true,
        title = "Big Game Hunter",
        hook = "Big Game Hunter offers a more active hunt on Anachronia.",
        why = "This active hunting method trades repeated trap clicks for tracking dinosaurs and preparing an ambush.",
        how = {
            "Speak to the Hunter master on Anachronia to learn how to hunt the first dinosaurs.",
        },
        requirements = {
            skills = {
                HUNTER = 75,
                SLAYER = 55,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 75,
            },
        },
        priority = 3,
    },

    {
        id = "hunter.alt.grenwalls",
        icon_item_id = 10008,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 77, 95 },
        members = true,
        title = "Grenwalls",
        hook = "Grenwalls offer box-trap catches with useful spikes to keep or sell.",
        why = "They are another option in Tirannwn. Later unlocks can remove the bait requirement or add Crystallise training.",
        how = {
            "After Regicide, look for grenwalls in Isafdar and bring box traps with raw pawya meat as bait.",
        },
        requirements = {
            skills = {
                HUNTER = 77,
            },
            quests = { "REGICIDE", "EAGLES_PEAK" },
        },
        require_quests_complete = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 77,
            },
        },
        priority = 3,
    },

    {
        id = "hunter.alt.barehanded_butterflies",
        icon_item_id = 10088,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 80, 99 },
        members = true,
        title = "Barehanded butterflies",
        hook = "Barehanded butterfly catching offers quieter Hunter training with some Agility experience.",
        why = "Your character can keep following a butterfly after releasing it, so catches need less attention than most traps.",
        how = {
            "Try ruby harvest butterflies in the Feldip Hunter area. Other butterflies need higher Hunter and Agility levels.",
        },
        requirements = {
            skills = {
                AGILITY = 75,
                HUNTER = 80,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 80,
            },
        },
        priority = 3,
    },

    {
        id = "hunter.alt.jadinkos",
        icon_item_id = 10008,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 80, 110 },
        members = true,
        title = "Anachronia jadinkos",
        hook = "Jadinkos offer plant-trap hunting on Anachronia.",
        why = "Different jadinkos open up as Hunter improves, giving another route alongside whirligigs and box traps.",
        how = {
            "Bring marasamaw plants to Anachronia's jadinko habitats and start with a type you have the level to catch.",
        },
        requirements = {
            skills = {
                HUNTER = 80,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 80,
            },
        },
        priority = 3,
    },

    {
        id = "hunter.alt.charming_moths",
        icon_item_id = 12160,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 88, 120 },
        members = true,
        title = "Charming moths",
        hook = "Charming moths combine relaxed Hunter training with Summoning charms.",
        why = "Catch them barehanded for Hunter experience and Summoning charms.",
        how = {
            "Find them on the Wilderness coast near Daemonheim. Check your Wilderness opt-in status before travelling.",
        },
        requirements = {
            skills = {
                AGILITY = 83,
                HUNTER = 88,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 88,
            },
        },
        priority = 3,
    },

    {
        id = "hunter.alt.croesus_front",
        icon_item_id = 10088,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 88, 120 },
        members = true,
        title = "Croesus Front spores",
        hook = "Gathering at the Croesus Front offers Hunter experience without setting traps.",
        why = "Decaying guards provide fungal spores, with enriched nodes becoming available at 92 Hunter.",
        how = {
            "Look for decaying guards outside the Croesus boss arena in Senntisten. The resource nodes do not require fighting the boss.",
        },
        requirements = {
            skills = {
                HUNTER = 88,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 88,
            },
        },
        priority = 3,
    },

    {
        id = "hunter.alt.ornate_tortles",
        icon_item_id = 37776,
        kind = "method",
        skills = { "HUNTER" },
        level_range = { 96, 120 },
        members = true,
        title = "Ornate tortles",
        hook = "Ornate tortles offer high-level hunting while exploring the Uncharted Isles.",
        why = "Their shells can be processed into an Arc resource, with colonies available until their daily supply runs out.",
        how = {
            "After Impressing the Locals, take tortle traps on an Uncharted Isles voyage and look for a colony.",
        },
        requirements = {
            skills = {
                HUNTER = 96,
            },
            quests = { "ELR0" },
        },
        require_quests_complete = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HUNTER",
                level = 96,
            },
        },
        priority = 3,
    },
}
