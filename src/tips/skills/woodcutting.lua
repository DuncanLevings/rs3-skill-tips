-- woodcutting tips. convenience items first, then training methods in level order, then
-- alternatives.
--
-- methods follow the brackets in the wiki's pay-to-play woodcutting training guide, written in
-- our own words. members is set by where the tip sends the player: teak and mahogany logs are
-- f2p, but the guide's spots for them (and seers' village for maples) are members areas.

return {
    -- convenience items

    {
        id = "woodcutting.wood_box",
        kind = "convenience",
        skills = { "WOODCUTTING" },
        members = false,
        title = "Wood box",
        icon_item = "WOODCUTTING_WOODBOX_BASIC",
        hook = "Backpack full of logs? A wood box lets you keep chopping for longer between bank "
            .. "trips.",
        why = "Fill it with logs to free up backpack space. Upgraded boxes can store higher-tier "
            .. "logs.",
        how = { "Fletch a wood box from regular logs, or buy one on the Grand Exchange." },
        requirements = { skills = { FLETCHING = 1 } },
        triggers = { { type = "backpack_full", skill = "WOODCUTTING" } },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "WOODCUTTING_WOODBOX_BASIC",
                    "WOODCUTTING_WOODBOX_OAK",
                    "WOODCUTTING_WOODBOX_WILLOW",
                    "WOODCUTTING_WOODBOX_TEAK",
                    "WOODCUTTING_WOODBOX_MAPLE",
                    "WOODCUTTING_WOODBOX_ACADIA",
                    "WOODCUTTING_WOODBOX_MAHOGANY",
                    "WOODCUTTING_WOODBOX_YEW",
                    "WOODCUTTING_WOODBOX_MAGIC",
                    "WOODCUTTING_WOODBOX_ELDER",
                    "WOODCUTTING_WOODBOX_ETERNAL",
                },
            },
            -- every tier shares this category, so a future tier is still caught
            { type = "owns_category", category = 5297 },
        },
        priority = 1,
    },

    {
        id = "woodcutting.lumberjack_outfit",
        require_quests_complete = true,
        kind = "convenience",
        skills = { "WOODCUTTING" },
        members = true,
        title = "Lumberjack outfit",
        icon_item = "RAMBLE_LUMBERJACK_TOP",
        hook = "44 Woodcutting: the lumberjack outfit adds extra experience to every log.",
        why = "Each piece gives a little extra Woodcutting experience, with a bonus for the full "
            .. "set. The sentinel outfits keep this bonus later on.",
        how = { "Undead lumberjacks drop the pieces during Temple Trekking." },
        requirements = { skills = { WOODCUTTING = 44 }, quests = { "IN_AID_OF_THE_MYREQUE" } },
        triggers = { { type = "training", skill = "WOODCUTTING" } },
        known_when = {
            { type = "owns_category", category = 4158 },
            {
                type = "owns_any",
                items = {
                    "RAMBLE_LUMBERJACK_HAT",
                    "RAMBLE_LUMBERJACK_TOP",
                    "RAMBLE_LUMBERJACK_LEGS",
                    "RAMBLE_LUMBERJACK_BOOTS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "woodcutting.sentinel_outfit",
        require_all_levels = true,
        kind = "convenience",
        skills = { "WOODCUTTING" },
        members = true,
        title = "Sentinel outfits",
        icon_item = "TRH113_ELITE_WOODCUTTING_V1_HEAD",
        hook = "80 Woodcutting: a sentinel outfit helps you cut logs faster.",
        why = "A full oaken, willow or maple sentinel outfit improves your success chance, finds "
            .. "more bird's nests and crystal geodes, and gives daily teleports to woodcutting "
            .. "spots. All three combine into the nature's sentinel outfit for more.",
        how = {
            "Make the pieces from sentinel fragments at an Inventor's workbench, once you've "
                .. "discovered the sentinel outfit blueprint.",
        },
        requirements = { skills = { WOODCUTTING = 80, INVENTION = 20 } },
        triggers = { { type = "training", skill = "WOODCUTTING" } },
        known_when = {
            { type = "owns_category", category = 4097 },
            { type = "owns_category", category = 4098 },
            { type = "owns_category", category = 4099 },
            { type = "owns_category", category = 4100 },
            -- explicit helm names remain a fallback; the category checks cover any single piece.
            {
                type = "owns_any",
                items = {
                    "TRH113_ELITE_WOODCUTTING_V1_HEAD",
                    "TRH113_ELITE_WOODCUTTING_V2_HEAD",
                    "TRH113_ELITE_WOODCUTTING_V3_HEAD",
                    "TRH113_ELITE_WOODCUTTING_V4_HEAD",
                },
            },
        },
        priority = 2,
    },

    {
        id = "woodcutting.sanas_fyrtorch",
        kind = "convenience",
        skills = { "WOODCUTTING" },
        members = true,
        title = "Sana's fyrtorch",
        icon_item = "EGWD_BIK_SKILLING_OFFHAND_WOODCUTTING",
        hook = "80 Woodcutting: Sana's fyrtorch speeds up your chopping.",
        why = "Worn in your off-hand, it raises your success chance and sometimes gives you an "
            .. "extra log, experience included.",
        how = { "Craft it at level 80 Fletching." },
        requirements = { skills = { WOODCUTTING = 80, FLETCHING = 80 } },
        triggers = { { type = "training", skill = "WOODCUTTING" } },
        known_when = {
            { type = "owns_any", items = { "EGWD_BIK_SKILLING_OFFHAND_WOODCUTTING" } },
        },
        priority = 2,
    },

    {
        id = "woodcutting.strung_rabbit_foot",
        require_all_levels = true,
        kind = "convenience",
        skills = { "WOODCUTTING" },
        members = true,
        title = "Strung rabbit foot",
        icon_item = "HUNTING_STRUNG_RABBIT_FOOT",
        hook = "A strung rabbit foot helps you find more bird's nests while you chop.",
        why = "Worn in your neck slot, it raises your bird's nest chance and stacks with other "
            .. "nest boosts like the Woodcutting cape.",
        how = { "String a rabbit foot to make one. Wearing it needs level 24 Hunter." },
        requirements = { skills = { HUNTER = 24 } },
        triggers = { { type = "training", skill = "WOODCUTTING" } },
        known_when = { { type = "owns_any", items = { "HUNTING_STRUNG_RABBIT_FOOT" } } },
        priority = 2,
    },

    {
        id = "woodcutting.cape",
        kind = "convenience",
        skills = { "WOODCUTTING" },
        members = true,
        title = "Woodcutting cape",
        icon_item = "SKILLCAPE_WOODCUTTING",
        hook = "99 Woodcutting! The Woodcutting cape helps you find more bird's nests and crystal "
            .. "geodes.",
        why = "Wearing it raises your chance of nests and geodes while you chop.",
        how = { "Buy it from Wilfred, the Woodcutting master." },
        requirements = { skills = { WOODCUTTING = 99 } },
        triggers = { { type = "training", skill = "WOODCUTTING" } },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_WOODCUTTING",
                    "SKILLCAPE_WOODCUTTING_TRIMMED",
                    "SKILLCAPE_WOODCUTTING_RETRO",
                    "SKILLCAPE_WOODCUTTING_TRIMMED_RETRO",
                },
            },
        },
        priority = 2,
    },

    -- training methods

    {
        id = "woodcutting.method.oak",
        main_method = true,
        icon_item_id = 1521,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 10, 19 },
        members = false,
        title = "Oak trees",
        hook = "Oak trees offer more experience per log than regular trees.",
        why = "Oaks give better experience than regular trees.",
        how = {
            "Try the oaks east of the Draynor Village bank or south-west of Varrock's west bank.",
        },
        requirements = { skills = { WOODCUTTING = 10 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 10 } },
        priority = 2,
    },

    {
        id = "woodcutting.method.willow",
        main_method = true,
        icon_item_id = 1519,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 20, 29 },
        members = false,
        title = "Willow trees",
        hook = "Willows offer steady Woodcutting experience close to a bank in Draynor Village.",
        why = "Willows are quicker experience than oaks for the next ten levels.",
        how = {
            "There's a big group of willows on the coast just south-west of the Draynor Village "
                .. "bank.",
        },
        requirements = { skills = { WOODCUTTING = 20 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 20 } },
        priority = 2,
    },

    {
        id = "woodcutting.method.teak",
        main_method = true,
        icon_item_id = 6333,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 30, 39 },
        members = true,
        title = "Teak trees",
        hook = "Teaks offer Woodcutting experience with occasional special logs for Construction.",
        why = "Teaks are a good jump in experience, and sometimes give special teak logs that are "
            .. "handy for Construction.",
        how = {
            "The Hardwood Grove near Tai Bwo Wannai on Karamja is full of them. Entry costs 100 "
                .. "trading sticks.",
        },
        requirements = { skills = { WOODCUTTING = 30 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 30 } },
        priority = 2,
    },

    {
        id = "woodcutting.method.maple",
        main_method = true,
        icon_item_id = 1517,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 40, 55 },
        members = true,
        title = "Maple trees",
        hook = "Maples offer a Woodcutting option close to the bank in Seers' Village.",
        why = "Their experience makes them an option through the mid 50s.",
        how = { "Seers' Village has several maples close to a bank." },
        requirements = { skills = { WOODCUTTING = 40 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 40 } },
        priority = 2,
    },

    {
        -- the guide says starting the fremennik isles is enough, so its only mentioned in the
        -- text (a quest requirement here would mean finishing it)
        id = "woodcutting.method.arctic_pine",
        main_method = true,
        icon_item_id = 10810,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 56, 57 },
        members = true,
        title = "Arctic pines",
        hook = "Arctic pines offer another Woodcutting option for visits to Neitiznot.",
        why = "They give more experience than maples, with eucalyptus becoming another option at 58.",
        how = {
            "They grow on Neitiznot, accessible after starting The Fremennik Isles. Maples are another option without island access.",
        },
        requirements = { skills = { WOODCUTTING = 56 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 56 } },
        priority = 2,
    },

    {
        id = "woodcutting.method.eucalyptus",
        main_method = true,
        icon_item_id = 12581,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 58, 59 },
        members = true,
        title = "Eucalyptus trees",
        hook = "Eucalyptus trees offer a Woodcutting option around Oo'glog.",
        why = "Their experience makes them an option before mahogany becomes available at 60.",
        how = { "Head to Oo'glog, where eucalyptus trees grow around the town." },
        requirements = { skills = { WOODCUTTING = 58 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 58 } },
        priority = 2,
    },

    {
        id = "woodcutting.method.mahogany",
        main_method = true,
        icon_item_id = 6332,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 60, 67 },
        members = true,
        title = "Mahogany",
        hook = "Mahogany offers logs for Construction and can pair with Crystallise for training.",
        why = "Mahogany is a solid upgrade, and stays useful much later if you pair it with "
            .. "Crystallise.",
        how = { "Find mahogany in the tropical south of Karamja and on Ape Atoll." },
        requirements = { skills = { WOODCUTTING = 60 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 60 } },
        priority = 2,
    },

    {
        id = "woodcutting.method.choking_ivy",
        main_method = true,
        icon_item_id = 1511,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 68, 93 },
        members = true,
        title = "Choking ivy",
        hook = "Choking ivy offers relaxed Woodcutting without a backpack full of logs.",
        why = "Ivy needs less attention than most trees. You won't get logs from it, but you "
            .. "can still find bird's nests.",
        how = { "It grows on the walls of Varrock Palace, Falador and Yanille." },
        requirements = { skills = { WOODCUTTING = 68 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 68 } },
        priority = 2,
    },

    {
        id = "woodcutting.method.crystal_trees",
        main_method = true,
        icon_item_id = 32270,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 94, 99 },
        members = true,
        title = "Crystal trees",
        hook = "Crystal trees offer another option for higher-level Woodcutting.",
        why = "They're among the best experience there is before 100.",
        how = {
            "There are several crystal trees around the world, but only one is active at a "
                .. "time. Checking an inactive one tells you which way the active tree is.",
        },
        requirements = { skills = { WOODCUTTING = 94 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 94 } },
        priority = 2,
    },

    {
        id = "woodcutting.method.eternal_magic",
        main_method = true,
        icon_item_id = 58250,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 100, 120 },
        members = true,
        title = "Eternal magic trees",
        hook = "Eternal magic trees offer a high-level Woodcutting option to work towards.",
        why = "They're the highest level trees, and the experience keeps climbing past 100.",
        how = { "Find them in the Piscatoris Hunter area, north of Eagles' Peak." },
        requirements = { skills = { WOODCUTTING = 100 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 100 } },
        priority = 2,
    },

    -- alternative methods
    --
    -- other ways to train that stay useful across many levels. priority 3 so the level's main
    -- method shows first. the jack of spades only needs to be partly done for menaphos, so its
    -- named in the text, not checked

    {
        id = "woodcutting.alt.creeping_ivy",
        icon_item_id = 1511,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 35, 67 },
        members = true,
        title = "Creeping ivy",
        hook = "Want a calmer way to train? Creeping ivy needs much less attention than trees.",
        why = "You won't get logs, but it's steady experience and you can still find bird's "
            .. "nests.",
        how = {
            "Chop it on the east wall of Isaac's house, just north of the Wendlewick lodestone.",
        },
        requirements = { skills = { WOODCUTTING = 35 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 35 } },
        priority = 3,
    },

    {
        id = "woodcutting.alt.acadia",
        icon_item_id = 40285,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 50, 99 },
        members = true,
        title = "Acadia trees",
        hook = "Acadia trees offer a Woodcutting option that stays useful across several levels.",
        why = "Acadia's experience keeps improving all the way to 99. Chopping in Menaphos also "
            .. "earns you Menaphos reputation.",
        how = {
            "Find them west of Het's Oasis, north of Uzer, or in Menaphos once you've started "
                .. "The Jack of Spades.",
        },
        requirements = { skills = { WOODCUTTING = 50 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 50 } },
        priority = 3,
    },

    {
        id = "woodcutting.alt.overgrown_idols",
        icon_item_id = 1511,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 81, 99 },
        members = true,
        title = "Overgrown idols",
        hook = "Overgrown idols offer Woodcutting training that needs little attention.",
        why = "Each vine keeps giving experience for several minutes, so you can relax while you "
            .. "train.",
        how = { "Find the idols on Karamja and Anachronia." },
        requirements = { skills = { WOODCUTTING = 81 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 81 } },
        priority = 3,
    },

    {
        id = "woodcutting.alt.elder_trees",
        icon_item_id = 29556,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 90, 99 },
        members = true,
        title = "Elder trees",
        hook = "Elder trees offer a way to gather logs with very little attention.",
        why = "Each tree gives you five minutes of chopping on your own timer before it runs out.",
        how = {
            "When a tree runs dry, a superior locator can take you to another elder tree.",
        },
        requirements = { skills = { WOODCUTTING = 90 } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 90 } },
        priority = 3,
    },

    {
        id = "woodcutting.alt.golden_bamboo",
        icon_item_id = 37771,
        kind = "method",
        skills = { "WOODCUTTING" },
        level_range = { 96, 120 },
        members = true,
        title = "Golden bamboo",
        hook = "Golden bamboo offers another reason to explore the Uncharted Isles.",
        why = "It's a rare resource with excellent experience when you find it.",
        how = {
            "Uncharted Isles are reached from the Arc, which needs Impressing the Locals. The "
                .. "Flag Fall miniquest helps you get back to an isle.",
        },
        requirements = { skills = { WOODCUTTING = 96 }, quests = { "ELR0" } },
        triggers = { { type = "level_reached", skill = "WOODCUTTING", level = 96 } },
        priority = 3,
    },
}
