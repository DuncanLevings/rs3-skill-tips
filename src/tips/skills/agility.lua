-- agility tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field

return {
    -- useful items and unlocks
    {
        id = "agility.nimble_outfit",
        kind = "convenience",
        skills = { "AGILITY" },
        members = true,
        min_training_level = 20,
        title = "Nimble outfit",
        icon_item = "TRH85_AGILITY_HEAD",
        hook = "The nimble outfit adds experience to your Agility training.",
        why = "Each piece contributes, with a further bonus for wearing the full set.",
        how = {
            "Watch for invitations to The Pit while training on supported courses; completing an "
                .. "activity can award a piece.",
        },
        requirements = {
            skills = { AGILITY = 1 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "AGILITY" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH85_AGILITY_BOOTS",
                    "TRH85_AGILITY_HANDS",
                    "TRH85_AGILITY_HEAD",
                    "TRH85_AGILITY_LEGS",
                    "TRH85_AGILITY_TORSO",
                },
            },
        },
        priority = 2,
    },

    {
        id = "agility.lightness",
        kind = "convenience",
        skills = { "AGILITY" },
        members = true,
        min_training_level = 20,
        title = "Boots of lightness",
        icon_item = "IKOV_BOOTSOFLIGHTNESS",
        hook = "Boots of lightness help keep your load down while travelling.",
        why = "Less weight can make your run energy last longer. Weight-reducing capes offer "
            .. "another way to lighten a heavier outfit.",
        how = {
            "Look into the boots beneath the Temple of Ikov.",
        },
        requirements = {
            skills = { AGILITY = 1 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "AGILITY" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "HUNTING_LIGHTER_CAPE",
                    "HUNTING_LIGHTER_CAPE_WORN",
                    "HUNTING_LIGHT_CAPE",
                    "HUNTING_LIGHT_CAPE_WORN",
                    "IKOV_BOOTSOFLIGHTNESS",
                    "IKOV_BOOTSOFLIGHTNESSWORN",
                },
            },
        },
        priority = 2,
    },

    {
        id = "agility.agile_clothing",
        kind = "convenience",
        skills = { "AGILITY" },
        members = true,
        min_training_level = 85,
        title = "Agile clothing",
        icon_item = "AGILE_AGILITY_LEGS",
        hook = "Agile clothing offers weight-saving rewards to work towards.",
        why = "Flawless laps on the advanced Gnome course earn the legs; the advanced Barbarian "
            .. "course offers a top at a later level.",
        how = {
            "Ask the trainers about rewards when you try the advanced courses.",
        },
        requirements = {
            skills = { AGILITY = 1 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "AGILITY" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "AGILE_AGILITY_LEGS",
                    "AGILE_AGILITY_LEGS_WORN",
                    "AGILE_AGILITY_TOP",
                    "AGILE_AGILITY_TOP_WORN",
                },
            },
        },
        priority = 2,
    },

    {
        id = "agility.cape",
        kind = "convenience",
        skills = { "AGILITY" },
        members = true,
        title = "Agility cape",
        icon_item = "SKILLCAPE_AGILITY",
        hook = "The Agility cape takes most obstacle failures out of your journeys.",
        why = "Its perk prevents failures on nearly all Agility obstacles, making course running "
            .. "and shortcuts more reliable.",
        how = {
            "Buy it from Cap'n Izzy No-Beard at the Brimhaven Agility Arena entrance.",
        },
        requirements = {
            skills = { AGILITY = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "AGILITY" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_AGILITY",
                    "SKILLCAPE_AGILITY_HOODED",
                    "SKILLCAPE_AGILITY_HOODED_RETRO",
                    "SKILLCAPE_AGILITY_RETRO",
                    "SKILLCAPE_AGILITY_TRIMMED",
                    "SKILLCAPE_AGILITY_TRIMMED_HOODED",
                    "SKILLCAPE_AGILITY_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_AGILITY_TRIMMED_RETRO",
                    "SKILLCAPE_INVERTED_AGILITY_HOODED",
                    "SKILLCAPE_INVERTED_AGILITY_TRIMMED_HOODED",
                },
            },
        },
        priority = 2,
    },

    -- training methods, one main method per level bracket
    {
        id = "agility.method.penguin",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 30, 34 },
        main_method = true,
        title = "Penguin course",
        icon_item_id = 47925,
        hook = "The penguin course offers a change of scenery for Agility training.",
        why = "The clockwork suit lets you use the course on the iceberg, with a different rhythm "
            .. "from the mainland courses.",
        how = {
            "After Cold War, take the clockwork suit back to the iceberg course.",
        },
        quest_how = {
            "Look into Cold War and its clockwork suit for access to the iceberg course.",
        },
        requirements = {
            skills = { AGILITY = 30, CONSTRUCTION = 34, CRAFTING = 30, HUNTER = 10, THIEVING = 15 },
            quests = { "COLD_WAR" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "AGILITY", level = 30 },
        },
        priority = 2,
    },

    {
        id = "agility.method.barbarian",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 35, 47 },
        main_method = true,
        title = "Barbarian Outpost course",
        icon_item_id = 47925,
        hook = "The Barbarian Outpost offers a compact Agility course.",
        why = "Its lap bonus rewards completing the whole circuit rather than repeating one "
            .. "obstacle.",
        how = {
            "Complete Alfred Grimhand's barcrawl, then try the course north-east of the outpost.",
        },
        requirements = {
            skills = { AGILITY = 35 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "AGILITY", level = 35 },
        },
        priority = 2,
    },

    {
        id = "agility.method.ape_atoll",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 48, 51 },
        main_method = true,
        title = "Ape Atoll course",
        icon_item_id = 1963,
        hook = "The Ape Atoll course offers another route for Agility experience.",
        why = "A ninja monkey form is needed for the course, so it gives your greegree another "
            .. "use.",
        how = {
            "After Monkey Madness, look into a ninja monkey greegree and the course on Ape Atoll.",
        },
        quest_how = {
            "Work towards Monkey Madness, then look into the ninja monkey form for the course.",
        },
        requirements = {
            skills = { AGILITY = 48 },
            quests = { "MONKEY_MADNESS" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "AGILITY", level = 48 },
        },
        priority = 2,
    },

    {
        id = "agility.method.wilderness",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 52, 59 },
        main_method = true,
        title = "Wilderness course",
        icon_item_id = 47925,
        hook = "The Wilderness course offers steady laps with a greater travel risk.",
        why = "The course is deep in the Wilderness and obstacles can fail, so it is worth "
            .. "planning the trip before bringing valuables.",
        how = {
            "Look for the course in the north-western Wilderness.",
        },
        requirements = {
            skills = { AGILITY = 52 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "AGILITY", level = 52 },
        },
        priority = 2,
    },

    {
        id = "agility.method.bandos",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 60, 64 },
        main_method = true,
        title = "Bandos throne-room course",
        icon_item_id = 47925,
        hook = "Bandos's throne room offers a different style of Agility course.",
        why = "Grappling between its statues also gives some Ranged and Strength experience.",
        how = {
            "After The Chosen Commander, bring a mithril grapple or an enhanced grappling hook to "
                .. "the throne room.",
        },
        quest_how = {
            "Complete The Chosen Commander to open up Bandos's throne room.",
        },
        requirements = {
            skills = {
                AGILITY = 60,
                ATTACK = 15,
                CRAFTING = 12,
                FIREMAKING = 16,
                FISHING = 36,
                HERBLORE = 37,
                MAGIC = 33,
                MINING = 17,
                PRAYER = 30,
                RANGED = 60,
                STRENGTH = 60,
                THIEVING = 46,
            },
            quests = { "CHOSEN_COMMANDER" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "AGILITY", level = 60 },
        },
        priority = 2,
    },

    {
        id = "agility.method.oasis",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 65, 69 },
        main_method = true,
        title = "Het's Oasis course",
        icon_item_id = 47925,
        hook = "Het's Oasis offers a course close to a familiar travel hub.",
        why = "Full laps provide a repeatable training option without a long trip across Gielinor.",
        how = {
            "Visit Het's Oasis near Al Kharid and look for the course starting point.",
        },
        requirements = {
            skills = { AGILITY = 65 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "AGILITY", level = 65 },
        },
        priority = 2,
    },

    {
        id = "agility.method.anachronia_sections",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 70, 76 },
        main_method = true,
        title = "Anachronia course sections",
        icon_item_id = 47925,
        hook = "Anachronia lets you train on a section of its larger course.",
        why = "Partial routes offer experience before you have the levels for the whole island "
            .. "circuit, with a chance at codex pages.",
        how = {
            "Look for the course markings near Anachronia base camp and try an advanced section.",
        },
        requirements = {
            skills = { AGILITY = 70 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "AGILITY", level = 70 },
        },
        priority = 2,
    },

    {
        id = "agility.method.hefin",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 77, 79 },
        main_method = true,
        title = "Hefin course",
        icon_item_id = 47925,
        hook = "The Hefin course offers Agility laps without obstacle failures.",
        why = "Its experience grows with your level, while occasional shortcuts can make a lap "
            .. "quicker.",
        how = {
            "Visit the course in the Hefin district of Prifddinas.",
        },
        quest_how = {
            "Work towards Plague's End to open up Prifddinas and its training facilities.",
        },
        requirements = {
            skills = {
                AGILITY = 77,
                CONSTRUCTION = 75,
                COOKING = 30,
                CRAFTING = 75,
                DUNGEONEERING = 75,
                FLETCHING = 70,
                HERBLORE = 75,
                MINING = 75,
                PRAYER = 75,
                RANGED = 75,
                SUMMONING = 75,
                THIEVING = 50,
                WOODCUTTING = 75,
            },
            quests = { "PLAGUES_END" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "AGILITY", level = 77 },
        },
        priority = 2,
    },

    {
        id = "agility.method.spirit_moths",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 80, 84 },
        main_method = true,
        title = "Spirit moths",
        icon_item_id = 12163,
        hook = "Barehanded spirit moths offer an Agility alternative to running laps.",
        why = "Catching them trades most of their usual charm drops for Agility experience.",
        how = {
            "Search hollow trees in Highweald Forest, then try catching the moths barehanded.",
        },
        quest_how = {
            "Look into Heralds of Crimson to start exploring Havenhythe.",
        },
        requirements = {
            skills = {
                AGILITY = 80,
                CONSTRUCTION = 30,
                CRAFTING = 51,
                HERBLORE = 55,
                HUNTER = 85,
                MINING = 65,
                SLAYER = 28,
                SMITHING = 60,
            },
            quests = { "QUEST_WENDLE_HERALDS" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "AGILITY", level = 80 },
        },
        priority = 2,
    },

    {
        id = "agility.method.anachronia_laps",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 85, 120 },
        main_method = true,
        title = "Full Anachronia laps",
        icon_item_id = 47925,
        hook = "Full Anachronia laps combine Agility experience with codex-page rewards.",
        why = "Completing the whole island circuit adds a substantial lap bonus. The route takes "
            .. "more attention while you learn it.",
        how = {
            "Follow the course markings around the island and back to the starting point.",
        },
        requirements = {
            skills = { AGILITY = 85 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "AGILITY", level = 85 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "agility.alt.early_anachronia",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 30, 64 },
        title = "Exploring the Anachronia course",
        icon_item_id = 47925,
        hook = "Anachronia offers smaller course sections before the full island route is "
            .. "possible.",
        why = "You can learn part of the route and gather codex pages without completing an entire "
            .. "lap.",
        how = {
            "Look for the lower-level section near base camp and follow the white course markings.",
        },
        requirements = {
            skills = { AGILITY = 30 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "AGILITY" },
        },
        priority = 3,
    },

    {
        id = "agility.alt.werewolf",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 60, 84 },
        title = "Werewolf course",
        icon_item_id = 47925,
        hook = "The werewolf course offers a change from standard laps.",
        why = "Fetching and returning the stick is part of earning the full course reward.",
        how = {
            "After Creature of Fenkenstrain, use the ring of charos to enter the course near "
                .. "Canifis.",
        },
        quest_how = {
            "Look into Creature of Fenkenstrain and its ring of charos to enter the course.",
        },
        requirements = {
            skills = { AGILITY = 60, CRAFTING = 20, THIEVING = 25 },
            quests = { "CREATURE_OF_FENKENSTRAIN" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "AGILITY" },
        },
        priority = 3,
    },

    {
        id = "agility.alt.throne_room",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 65, 76 },
        title = "Empty Throne Room",
        icon_item_id = 47925,
        hook = "The Empty Throne Room offers more relaxed Agility training.",
        why = "Its manual cycles provide a limited pool of experience, making it a stepping stone "
            .. "rather than a permanent training spot.",
        how = {
            "Look for the excavation beneath the Varrock Dig Site and try the manual cycles.",
        },
        requirements = {
            skills = { AGILITY = 65 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "AGILITY" },
        },
        priority = 3,
    },

    {
        id = "agility.alt.serenity",
        kind = "method",
        skills = { "AGILITY" },
        members = true,
        level_range = { 75, 94 },
        title = "Serenity posts",
        icon_item_id = 47925,
        hook = "Serenity posts offer a short, relaxed Agility routine.",
        why = "They provide a limited amount of daily experience, with more from following the "
            .. "instructor's poses.",
        how = {
            "Visit the posts in the Hefin district of Prifddinas.",
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
                SUMMONING = 75,
                THIEVING = 50,
                WOODCUTTING = 75,
            },
            quests = { "PLAGUES_END" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "AGILITY" },
        },
        priority = 3,
    },
}
