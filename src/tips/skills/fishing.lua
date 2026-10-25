-- fishing tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field
--
-- method brackets follow the wiki's pay-to-play fishing training guide, written in our own
-- words. the guide's brackets overlap a lot, these are laid out so each level has one main
-- method. crayfish, trout and salmon are free to play, barbarian fishing and up is members

return {
    -- useful items and unlocks
    {
        id = "fishing.fishing_outfit",
        kind = "convenience",
        skills = { "FISHING" },
        members = true,
        title = "Fishing outfit",
        icon_item = "FISHCOMP_FISHING_OUTFIT_HAT",
        hook = "Get extra Fishing experience from every catch with the fishing outfit.",
        why = "Each piece gives a little extra Fishing experience, with a bonus for the full set. "
            .. "The shark outfits keep this bonus later on.",
        how = {
            "Buy the pieces with tokens from Fish Flingers on Isla Anglerine.",
        },
        triggers = {
            { type = "training", skill = "FISHING" },
        },
        known_when = {
            { type = "owns_category", category = 2677 },
            {
                type = "owns_any",
                items = {
                    "FISHCOMP_FISHING_OUTFIT_HAT",
                    "FISHCOMP_FISHING_OUTFIT_BODY",
                    "FISHCOMP_FISHING_OUTFIT_LEGS",
                    "FISHCOMP_FISHING_OUTFIT_BOOTS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "fishing.shark_outfit",
        kind = "convenience",
        skills = { "FISHING" },
        members = true,
        title = "Shark outfits",
        icon_item = "TRH48_SHARK_HEAD_NORMAL",
        hook = "80 Fishing: a shark outfit helps you catch fish faster.",
        why = "A full shark, burnt shark or tiger shark outfit improves your success chance and "
            .. "can get rid of fish as you catch them, so your backpack never fills. All three "
            .. "combine into the fury shark outfit for more.",
        how = {
            "Make the pieces from shark fragments at an Inventor's workbench, once you've "
                .. "discovered the shark outfit blueprint.",
        },
        requirements = {
            skills = { FISHING = 80, INVENTION = 20 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FISHING" },
        },
        known_when = {
            { type = "owns_category", category = 3497 },
            { type = "owns_category", category = 3498 },
            { type = "owns_category", category = 3499 },
            { type = "owns_category", category = 3500 },
            -- the category checks cover any single piece, the head names are a fallback
            {
                type = "owns_any",
                items = {
                    "TRH48_SHARK_HEAD_NORMAL",
                    "TRH48_SHARK_HEAD_BURNT",
                    "TRH48_SHARK_HEAD_TIGER",
                    "TRH48_SHARK_HEAD_FURY",
                },
            },
        },
        priority = 2,
    },

    {
        id = "fishing.dragon_harpoon",
        kind = "convenience",
        skills = { "FISHING" },
        members = true,
        title = "Dragon harpoon",
        icon_item = "DRAGON_HARPOON",
        hook = "60 Fishing: a dragon harpoon catches harpoon fish more often.",
        why = "Wielding it raises your success chance at any spot that needs a harpoon.",
        how = {
            "It's dropped by Flesh-hatcher Mhekarnahz.",
        },
        requirements = {
            skills = { ATTACK = 60, FISHING = 60 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FISHING" },
        },
        known_when = {
            { type = "owns_any", items = { "DRAGON_HARPOON" } },
        },
        priority = 2,
    },

    {
        id = "fishing.crystal_fishing_rod",
        kind = "convenience",
        skills = { "FISHING" },
        members = true,
        title = "Crystal fishing rod",
        icon_item = "ELFCITY_CRYSTAL_ROD_100",
        hook = "93 Fishing: a crystal fishing rod works at every rod spot and catches more often.",
        why = "It does the job of a fishing rod, fly fishing rod and barbarian rod in one, with a "
            .. "better success chance than all of them.",
        how = {
            "It's one of the crystal tools of Prifddinas.",
        },
        quest_how = {
            "Work towards Plague's End to open up Prifddinas and its training facilities.",
        },
        requirements = {
            skills = {
                AGILITY = 90,
                CONSTRUCTION = 75,
                COOKING = 30,
                CRAFTING = 75,
                DUNGEONEERING = 75,
                FISHING = 93,
                FLETCHING = 70,
                HERBLORE = 75,
                MINING = 75,
                PRAYER = 75,
                RANGED = 90,
                STRENGTH = 90,
                SUMMONING = 75,
                THIEVING = 50,
                WOODCUTTING = 75,
            },
            quests = { "PLAGUES_END" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FISHING" },
        },
        known_when = {
            { type = "owns_any", items = { "ELFCITY_CRYSTAL_ROD_100", "ELFCITY_CRYSTAL_ROD_50" } },
        },
        priority = 2,
    },

    {
        id = "fishing.rod_o_matic",
        kind = "convenience",
        skills = { "FISHING" },
        members = true,
        title = "Fishing rod-o-matic",
        icon_item = "INVENT_FISHING_ROD",
        hook = "The fishing rod-o-matic brings Invention perks to most fishing spots.",
        why = "One tool for most spots, and it can take Invention perks. You still need bait where "
            .. "a spot asks for it.",
        how = {
            "Research it at level 22 Invention, then build it at an Inventor's workbench.",
        },
        requirements = {
            skills = { INVENTION = 22 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FISHING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "INVENT_FISHING_ROD",
                    "INVENT_FISHING_ROD_UNUSED",
                    "INVENT_FISHING_ROD_UNCHARGED",
                    "INVENT_ENHANCED_FISHING_ROD",
                    "INVENT_ENHANCED_FISHING_ROD_UNUSED",
                    "INVENT_ENHANCED_FISHING_ROD_UNCHARGED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "fishing.cape",
        kind = "convenience",
        skills = { "FISHING" },
        members = true,
        title = "Fishing cape",
        icon_item = "SKILLCAPE_FISHING",
        hook = "99 Fishing! The Fishing cape gives you a chance of an extra catch.",
        why = "Wearing it means some catches come with a bonus fish.",
        how = {
            "Buy it from the Master fisher inside the Fishing Guild.",
        },
        requirements = {
            skills = { FISHING = 99 },
        },
        triggers = {
            { type = "training", skill = "FISHING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_FISHING",
                    "SKILLCAPE_FISHING_TRIMMED",
                    "SKILLCAPE_FISHING_RETRO",
                    "SKILLCAPE_FISHING_TRIMMED_RETRO",
                },
            },
        },
        priority = 2,
    },

    -- training methods, one main method per level bracket
    {
        id = "fishing.method.fly_fishing",
        kind = "method",
        skills = { "FISHING" },
        members = false,
        level_range = { 20, 69 },
        main_method = true,
        title = "Fly fishing",
        icon_item_id = 335,
        hook = "Fly fishing offers steady experience with simple supplies.",
        why = "Catch trout from 20 Fishing and salmon from 30 using the same setup.",
        how = {
            "A fly fishing rod and feathers are available from most fishing shops.",
        },
        requirements = {
            skills = { FISHING = 20 },
        },
        triggers = {
            { type = "level_reached", skill = "FISHING", level = 20 },
        },
        priority = 2,
    },

    {
        id = "fishing.method.barbarian_fishing",
        kind = "method",
        skills = { "FISHING" },
        members = true,
        level_range = { 70, 71 },
        main_method = true,
        title = "Barbarian fishing",
        icon_item_id = 11332,
        hook = "Barbarian fishing combines Fishing with a little Strength and Agility experience.",
        why = "You catch leaping trout, salmon and sturgeon, and earn some Strength and Agility "
            .. "experience on top.",
        how = {
            "Ask Otto Godblessed at his grotto west of Baxtorian Falls to teach you.",
        },
        requirements = {
            skills = { FISHING = 70 },
        },
        triggers = {
            { type = "level_reached", skill = "FISHING", level = 70 },
        },
        priority = 2,
    },

    {
        -- the jack of spades only needs to be partly done for menaphos, so its named in the
        -- text rather than checked
        id = "fishing.method.menaphos_port",
        kind = "method",
        skills = { "FISHING" },
        members = true,
        level_range = { 72, 87 },
        main_method = true,
        title = "Menaphos port district",
        icon_item_id = 40291,
        hook = "Fishing in Menaphos offers a nearby bank and reputation alongside your catches.",
        why = "They're right by a bank, and fishing there earns Menaphos reputation too.",
        how = {
            "You need to have started The Jack of Spades to get into Menaphos.",
        },
        requirements = {
            skills = { FISHING = 72 },
        },
        triggers = {
            { type = "level_reached", skill = "FISHING", level = 72 },
        },
        priority = 2,
    },

    {
        id = "fishing.method.croesus_front",
        kind = "method",
        skills = { "FISHING" },
        members = true,
        level_range = { 88, 92 },
        main_method = true,
        title = "Croesus Front",
        icon_item_id = 52321,
        hook = "The Croesus Front offers a relaxed Fishing option with catches you can sell.",
        why = "Fishing the colonised guards here is calm, especially with a shark outfit to get "
            .. "rid of what you catch. All of its spots open at 92.",
        how = {
            "It's part of the Elder God Wars Dungeon, and has no entry requirements.",
        },
        requirements = {
            skills = { FISHING = 88 },
        },
        triggers = {
            { type = "level_reached", skill = "FISHING", level = 88 },
        },
        priority = 2,
    },

    {
        id = "fishing.method.prifddinas_waterfall",
        kind = "method",
        skills = { "FISHING" },
        members = true,
        level_range = { 93, 93 },
        main_method = true,
        title = "Prifddinas waterfall",
        icon_item_id = 35721,
        hook = "The Prifddinas waterfall offers relaxed Fishing experience once you have access.",
        why = "It's a big step up in experience and stays a relaxed choice after 94 too.",
        how = {
            "It's between the Crwys and Meilyr districts. Plague's End gets you into the city, and "
                .. "a grapple shortcut needing 90 Agility, Ranged and Strength gets you up the "
                .. "waterfall.",
        },
        quest_how = {
            "Work towards Plague's End to open up Prifddinas and its training facilities.",
        },
        requirements = {
            skills = {
                AGILITY = 90,
                CONSTRUCTION = 75,
                COOKING = 30,
                CRAFTING = 75,
                DUNGEONEERING = 75,
                FISHING = 93,
                FLETCHING = 70,
                HERBLORE = 75,
                MINING = 75,
                PRAYER = 75,
                RANGED = 90,
                STRENGTH = 90,
                SUMMONING = 75,
                THIEVING = 50,
                WOODCUTTING = 75,
            },
            quests = { "PLAGUES_END" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FISHING", level = 93 },
        },
        priority = 2,
    },

    {
        id = "fishing.method.fishing_frenzy",
        kind = "method",
        skills = { "FISHING" },
        members = true,
        level_range = { 94, 120 },
        main_method = true,
        title = "Fishing Frenzy",
        icon_item_id = 42249,
        hook = "Fishing Frenzy trades a relaxed pace for more active training.",
        why = "Keeping a streak takes frequent clicks. It rewards experience rather than fish to "
            .. "keep.",
        how = {
            "Talk to Goomah at the Fishing Guild to reach the Deep Sea Fishing hub.",
        },
        requirements = {
            skills = { FISHING = 94 },
        },
        triggers = {
            { type = "level_reached", skill = "FISHING", level = 94 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "fishing.alt.ghostly_sole",
        kind = "method",
        skills = { "FISHING" },
        members = true,
        level_range = { 66, 120 },
        title = "Ghostly sole",
        icon_item_id = 55302,
        hook = "Ghostly sole offers a Fishing option that needs very little attention.",
        why = "The spot never moves or disappears, so with signs of the porter or a fury shark "
            .. "outfit you can leave it running for ages.",
        how = {
            "Fish it at the Reflection Pool in the south of the City of Um.",
        },
        quest_how = {
            "Start Necromancy! to explore the City of Um and its Reflection Pool.",
        },
        requirements = {
            skills = { FISHING = 66 },
            quests = { "QUEST_NECROMANCY_TUTORIAL" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FISHING", level = 66 },
        },
        priority = 3,
    },

    {
        id = "fishing.alt.minnow_shoals",
        kind = "method",
        skills = { "FISHING" },
        members = true,
        level_range = { 68, 91 },
        title = "Minnow shoals",
        icon_item_id = 42241,
        hook = "Minnow shoals offer relaxed Fishing without a quest requirement.",
        why = "Minnows stack in your backpack and the shoals don't move often, so you can fish "
            .. "without much attention.",
        how = {
            "Find them at the Deep Sea Fishing hub, reached through Goomah at the Fishing Guild.",
        },
        requirements = {
            skills = { FISHING = 68 },
        },
        triggers = {
            { type = "level_reached", skill = "FISHING", level = 68 },
        },
        priority = 3,
    },

    {
        id = "fishing.alt.fishing_contracts",
        kind = "method",
        skills = { "FISHING" },
        members = true,
        level_range = { 90, 120 },
        title = "Fishing contracts",
        icon_item_id = 37762,
        hook = "Fishing contracts in the Arc reward chimes as well as experience.",
        why = "Each contract asks for a set amount of one fish and pays out chimes, the Arc's "
            .. "currency.",
        how = {
            "Get contracts from the Whaler in the Arc, which needs Impressing the Locals.",
        },
        quest_how = {
            "Complete Impressing the Locals to start exploring the Arc.",
        },
        requirements = {
            skills = { FISHING = 90 },
            quests = { "ELR0" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FISHING", level = 90 },
        },
        priority = 3,
    },

    {
        id = "fishing.alt.wobbegongs",
        kind = "method",
        skills = { "FISHING" },
        members = true,
        level_range = { 96, 120 },
        title = "Wobbegongs",
        icon_item_id = 37768,
        hook = "Wobbegongs offer a Fishing option when exploring the Uncharted Isles.",
        why = "They're a rare catch with excellent experience while they last.",
        how = {
            "Uncharted Isles are reached from the Arc, which needs Impressing the Locals. The Flag "
                .. "Fall miniquest helps you get back to an isle.",
        },
        quest_how = {
            "Complete Impressing the Locals to start exploring the Arc.",
        },
        requirements = {
            skills = { FISHING = 96 },
            quests = { "ELR0" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FISHING", level = 96 },
        },
        priority = 3,
    },
}
