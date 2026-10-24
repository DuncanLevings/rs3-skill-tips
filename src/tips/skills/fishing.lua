-- fishing tips. convenience items first, then training methods in level order, then
-- alternatives.
--
-- methods follow the wiki's pay-to-play fishing training guide, written in our own words. the
-- guide's brackets overlap a lot, these are laid out so each level has one main method.
-- crayfish, trout and salmon are f2p, everything from barbarian fishing up is members.

return {
    -- convenience items

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
        how = { "Buy the pieces with tokens from Fish Flingers on Isla Anglerine." },
        triggers = { { type = "training", skill = "FISHING" } },
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
        require_all_levels = true,
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
        requirements = { skills = { FISHING = 80, INVENTION = 20 } },
        triggers = { { type = "training", skill = "FISHING" } },
        known_when = {
            { type = "owns_category", category = 3497 },
            { type = "owns_category", category = 3498 },
            { type = "owns_category", category = 3499 },
            { type = "owns_category", category = 3500 },
            -- explicit head names remain a fallback; the category checks cover any single piece.
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
        require_all_levels = true,
        kind = "convenience",
        skills = { "FISHING" },
        members = true,
        title = "Dragon harpoon",
        icon_item = "DRAGON_HARPOON",
        hook = "60 Fishing: a dragon harpoon catches harpoon fish more often.",
        why = "Wielding it raises your success chance at any spot that needs a harpoon.",
        how = { "It's dropped by Flesh-hatcher Mhekarnahz." },
        requirements = { skills = { FISHING = 60, ATTACK = 60 } },
        triggers = { { type = "training", skill = "FISHING" } },
        known_when = { { type = "owns_any", items = { "DRAGON_HARPOON" } } },
        priority = 2,
    },

    {
        id = "fishing.crystal_fishing_rod",
        require_all_levels = true,
        require_quests_complete = true,
        kind = "convenience",
        skills = { "FISHING" },
        members = true,
        title = "Crystal fishing rod",
        icon_item = "ELFCITY_CRYSTAL_ROD_100",
        hook = "93 Fishing: a crystal fishing rod works at every rod spot and catches more often.",
        why = "It does the job of a fishing rod, fly fishing rod and barbarian rod in one, with a "
            .. "better success chance than all of them.",
        how = { "It's one of the crystal tools of Prifddinas." },
        requirements = {
            skills = { FISHING = 93, AGILITY = 90, RANGED = 90, STRENGTH = 90 },
            quests = { "PLAGUES_END" },
        },
        triggers = { { type = "training", skill = "FISHING" } },
        known_when = {
            { type = "owns_any", items = { "ELFCITY_CRYSTAL_ROD_100", "ELFCITY_CRYSTAL_ROD_50" } },
        },
        priority = 2,
    },

    {
        id = "fishing.rod_o_matic",
        require_all_levels = true,
        kind = "convenience",
        skills = { "FISHING" },
        members = true,
        title = "Fishing rod-o-matic",
        icon_item = "INVENT_FISHING_ROD",
        hook = "The fishing rod-o-matic brings Invention perks to most fishing spots.",
        why = "One tool for most spots, and it can take Invention perks. You still need bait "
            .. "where a spot asks for it.",
        how = { "Research it at level 22 Invention, then build it at an Inventor's workbench." },
        requirements = { skills = { INVENTION = 22 } },
        triggers = { { type = "training", skill = "FISHING" } },
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
        how = { "Buy it from the Master fisher inside the Fishing Guild." },
        requirements = { skills = { FISHING = 99 } },
        triggers = { { type = "training", skill = "FISHING" } },
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

    -- training methods

    {
        id = "fishing.method.crayfish",
        icon_item_id = 13435,
        kind = "method",
        skills = { "FISHING" },
        level_range = { 1, 19 },
        members = false,
        title = "Crayfish",
        hook = "New to Fishing? Start with crayfish.",
        why = "They need no bait, so you can start straight away with just a crayfish cage.",
        how = {
            "Fish them east of Lumbridge church or on the north shore of the lake in Taverley.",
        },
        requirements = { skills = { FISHING = 1 } },
        triggers = { { type = "level_reached", skill = "FISHING", level = 1 } },
        priority = 2,
    },

    {
        id = "fishing.method.fly_fishing",
        icon_item_id = 335,
        kind = "method",
        skills = { "FISHING" },
        level_range = { 20, 69 },
        members = false,
        title = "Fly fishing",
        hook = "20 Fishing: fly fishing for trout, and later salmon, is your next step.",
        why = "It carries you a long way. At 30 you start catching salmon too, which boosts your "
            .. "experience.",
        how = { "You'll need a fly fishing rod and feathers, which most fishing shops sell." },
        requirements = { skills = { FISHING = 20 } },
        triggers = { { type = "level_reached", skill = "FISHING", level = 20 } },
        priority = 2,
    },

    {
        id = "fishing.method.barbarian_fishing",
        icon_item_id = 11332,
        kind = "method",
        skills = { "FISHING" },
        level_range = { 70, 71 },
        members = true,
        title = "Barbarian fishing",
        hook = "70 Fishing: try barbarian fishing for leaping fish.",
        why = "You catch leaping trout, salmon and sturgeon, and earn some Strength and Agility "
            .. "experience on top.",
        how = { "Ask Otto Godblessed at his grotto west of Baxtorian Falls to teach you." },
        requirements = { skills = { FISHING = 70 } },
        triggers = { { type = "level_reached", skill = "FISHING", level = 70 } },
        priority = 2,
    },

    {
        -- the jack of spades only needs to be partly done for menaphos, so its named in the
        -- text rather than checked
        id = "fishing.method.menaphos_port",
        icon_item_id = 40291,
        kind = "method",
        skills = { "FISHING" },
        level_range = { 72, 87 },
        members = true,
        title = "Menaphos port district",
        hook = "72 Fishing: the fishing spots in Menaphos' port district are worth a look.",
        why = "They're right by a bank, and fishing there earns Menaphos reputation too.",
        how = { "You need to have started The Jack of Spades to get into Menaphos." },
        requirements = { skills = { FISHING = 72 } },
        triggers = { { type = "level_reached", skill = "FISHING", level = 72 } },
        priority = 2,
    },

    {
        id = "fishing.method.croesus_front",
        icon_item_id = 52321,
        kind = "method",
        skills = { "FISHING" },
        level_range = { 88, 92 },
        members = true,
        title = "Croesus Front",
        hook = "88 Fishing: the Croesus Front in Senntisten is a relaxed, profitable spot.",
        why = "Fishing the colonised guards here is calm, especially with a shark outfit to get "
            .. "rid of what you catch. All of its spots open at 92.",
        how = { "It's part of the Elder God Wars Dungeon, and has no entry requirements." },
        requirements = { skills = { FISHING = 88 } },
        triggers = { { type = "level_reached", skill = "FISHING", level = 88 } },
        priority = 2,
    },

    {
        id = "fishing.method.prifddinas_waterfall",
        icon_item_id = 35721,
        kind = "method",
        skills = { "FISHING" },
        level_range = { 93, 93 },
        members = true,
        title = "Prifddinas waterfall",
        hook = "93 Fishing: the waterfall in Prifddinas opens up.",
        why = "It's a big step up in experience and stays a relaxed choice after 94 too.",
        how = {
            "It's between the Crwys and Meilyr districts. Plague's End gets you into the city, "
                .. "and a grapple shortcut needing 90 Agility, Ranged and Strength gets you up "
                .. "the waterfall.",
        },
        requirements = {
            skills = { FISHING = 93, AGILITY = 90, RANGED = 90, STRENGTH = 90 },
            quests = { "PLAGUES_END" },
        },
        triggers = { { type = "level_reached", skill = "FISHING", level = 93 } },
        priority = 2,
    },

    {
        id = "fishing.method.fishing_frenzy",
        icon_item_id = 42249,
        kind = "method",
        skills = { "FISHING" },
        level_range = { 94, 120 },
        members = true,
        title = "Fishing Frenzy",
        hook = "94 Fishing: Fishing Frenzy gives huge experience if you don't mind clicking.",
        why = "It gives no fish and needs constant clicking to keep your streak going, but the "
            .. "experience is huge.",
        how = { "Talk to Goomah at the Fishing Guild to reach the Deep Sea Fishing hub." },
        requirements = { skills = { FISHING = 94 } },
        triggers = { { type = "level_reached", skill = "FISHING", level = 94 } },
        priority = 2,
    },

    -- alternative methods
    --
    -- other ways to train that stay useful across many levels. priority 3 so the level's main
    -- method shows first

    {
        id = "fishing.alt.ghostly_sole",
        icon_item_id = 55302,
        kind = "method",
        skills = { "FISHING" },
        level_range = { 66, 120 },
        members = true,
        title = "Ghostly sole",
        hook = "66 Fishing: ghostly sole is about as AFK as Fishing gets.",
        why = "The spot never moves or disappears, so with signs of the porter or a fury shark "
            .. "outfit you can leave it running for ages.",
        how = { "Fish it at the Reflection Pool in the south of the City of Um." },
        requirements = { skills = { FISHING = 66 }, quests = { "QUEST_NECROMANCY_TUTORIAL" } },
        triggers = { { type = "level_reached", skill = "FISHING", level = 66 } },
        priority = 3,
    },

    {
        id = "fishing.alt.minnow_shoals",
        icon_item_id = 42241,
        kind = "method",
        skills = { "FISHING" },
        level_range = { 68, 120 },
        members = true,
        title = "Minnow shoals",
        hook = "68 Fishing: minnow shoals are a relaxed option with no quests needed.",
        why = "Minnows stack in your backpack and the shoals don't move often, so you can fish "
            .. "without much attention.",
        how = {
            "Find them at the Deep Sea Fishing hub, reached through Goomah at the Fishing Guild.",
        },
        requirements = { skills = { FISHING = 68 } },
        triggers = { { type = "level_reached", skill = "FISHING", level = 68 } },
        priority = 3,
    },

    {
        id = "fishing.alt.fishing_contracts",
        icon_item_id = 37762,
        kind = "method",
        skills = { "FISHING" },
        level_range = { 90, 120 },
        members = true,
        title = "Fishing contracts",
        hook = "90 Fishing: contracts in the Arc reward chimes as well as experience.",
        why = "Each contract asks for a set amount of one fish and pays out chimes, the Arc's "
            .. "currency.",
        how = {
            "Get contracts from the Whaler in the Arc, which needs Impressing the Locals.",
        },
        requirements = { skills = { FISHING = 90 }, quests = { "ELR0" } },
        triggers = { { type = "level_reached", skill = "FISHING", level = 90 } },
        priority = 3,
    },

    {
        id = "fishing.alt.wobbegongs",
        icon_item_id = 37768,
        kind = "method",
        skills = { "FISHING" },
        level_range = { 96, 120 },
        members = true,
        title = "Wobbegongs",
        hook = "96 Fishing: look out for wobbegongs on the Uncharted Isles.",
        why = "They're a rare catch with excellent experience while they last.",
        how = {
            "Uncharted Isles are reached from the Arc, which needs Impressing the Locals. The "
                .. "Flag Fall miniquest helps you get back to an isle.",
        },
        requirements = { skills = { FISHING = 96 }, quests = { "ELR0" } },
        triggers = { { type = "level_reached", skill = "FISHING", level = 96 } },
        priority = 3,
    },
}
