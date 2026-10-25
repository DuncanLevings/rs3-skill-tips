-- useful equipment and unlocks, then main methods and alternatives in level order.
-- access and recommendation-window evidence: docs/support-coverage.md.

return {
    {
        id = "agility.nimble_outfit",
        icon_item = "TRH85_AGILITY_HEAD",
        kind = "convenience",
        skills = { "AGILITY" },
        members = true,
        title = "Nimble outfit",
        hook = "The nimble outfit adds experience to your Agility training.",
        why = "Each piece contributes, with a further bonus for wearing the full set.",
        how = {
            "Watch for invitations to The Pit while training on supported courses; completing an activity can award a piece.",
        },
        requirements = {
            skills = {
                AGILITY = 1,
            },
        },
        min_training_level = 20,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "AGILITY",
            },
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
        icon_item = "IKOV_BOOTSOFLIGHTNESS",
        kind = "convenience",
        skills = { "AGILITY" },
        members = true,
        title = "Boots of lightness",
        hook = "Boots of lightness help keep your load down while travelling.",
        why = "Less weight can make your run energy last longer. Weight-reducing capes offer another way to lighten a heavier outfit.",
        how = { "Look into the boots beneath the Temple of Ikov." },
        requirements = {
            skills = {
                AGILITY = 1,
            },
        },
        min_training_level = 20,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "AGILITY",
            },
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
        icon_item = "AGILE_AGILITY_LEGS",
        kind = "convenience",
        skills = { "AGILITY" },
        members = true,
        title = "Agile clothing",
        hook = "Agile clothing offers weight-saving rewards to work towards.",
        why = "Flawless laps on the advanced Gnome course earn the legs; the advanced Barbarian course offers a top at a later level.",
        how = { "Ask the trainers about rewards when you try the advanced courses." },
        requirements = {
            skills = {
                AGILITY = 1,
            },
        },
        min_training_level = 85,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "AGILITY",
            },
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
        icon_item = "SKILLCAPE_AGILITY",
        kind = "convenience",
        skills = { "AGILITY" },
        members = true,
        title = "Agility cape",
        hook = "The Agility cape takes most obstacle failures out of your journeys.",
        why = "Its perk prevents failures on nearly all Agility obstacles, making course running and shortcuts more reliable.",
        how = { "Buy it from Cap'n Izzy No-Beard at the Brimhaven Agility Arena entrance." },
        requirements = {
            skills = {
                AGILITY = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "AGILITY",
            },
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

    {
        id = "agility.method.penguin",
        main_method = true,
        icon_item_id = 47925,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 30, 34 },
        members = true,
        title = "Penguin course",
        hook = "The penguin course offers a change of scenery for Agility training.",
        why = "The clockwork suit lets you use the course on the iceberg, with a different rhythm from the mainland courses.",
        how = { "After Cold War, take the clockwork suit back to the iceberg course." },
        quest_how = {
            "Look into Cold War and its clockwork suit for access to the iceberg course.",
        },
        requirements = {
            skills = {
                AGILITY = 30,
                CONSTRUCTION = 34,
                CRAFTING = 30,
                HUNTER = 10,
                THIEVING = 15,
            },
            quests = { "COLD_WAR" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "AGILITY",
                level = 30,
            },
        },
        priority = 2,
    },

    {
        id = "agility.method.barbarian",
        main_method = true,
        icon_item_id = 47925,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 35, 47 },
        members = true,
        title = "Barbarian Outpost course",
        hook = "The Barbarian Outpost offers a compact Agility course.",
        why = "Its lap bonus rewards completing the whole circuit rather than repeating one obstacle.",
        how = {
            "Complete Alfred Grimhand's barcrawl, then try the course north-east of the outpost.",
        },
        requirements = {
            skills = {
                AGILITY = 35,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "AGILITY",
                level = 35,
            },
        },
        priority = 2,
    },

    {
        id = "agility.method.ape_atoll",
        main_method = true,
        icon_item_id = 1963,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 48, 51 },
        members = true,
        title = "Ape Atoll course",
        hook = "The Ape Atoll course offers another route for Agility experience.",
        why = "A ninja monkey form is needed for the course, so it gives your greegree another use.",
        how = {
            "After Monkey Madness, look into a ninja monkey greegree and the course on Ape Atoll.",
        },
        quest_how = {
            "Work towards Monkey Madness, then look into the ninja monkey form for the course.",
        },
        requirements = {
            skills = {
                AGILITY = 48,
            },
            quests = { "MONKEY_MADNESS" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "AGILITY",
                level = 48,
            },
        },
        priority = 2,
    },

    {
        id = "agility.method.wilderness",
        main_method = true,
        icon_item_id = 47925,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 52, 59 },
        members = true,
        title = "Wilderness course",
        hook = "The Wilderness course offers steady laps with a greater travel risk.",
        why = "The course is deep in the Wilderness and obstacles can fail, so it is worth planning the trip before bringing valuables.",
        how = { "Look for the course in the north-western Wilderness." },
        requirements = {
            skills = {
                AGILITY = 52,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "AGILITY",
                level = 52,
            },
        },
        priority = 2,
    },

    {
        id = "agility.method.bandos",
        main_method = true,
        icon_item_id = 47925,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 60, 64 },
        members = true,
        title = "Bandos throne-room course",
        hook = "Bandos's throne room offers a different style of Agility course.",
        why = "Grappling between its statues also gives some Ranged and Strength experience.",
        how = {
            "After The Chosen Commander, bring a mithril grapple or an enhanced grappling hook to the throne room.",
        },
        quest_how = { "Complete The Chosen Commander to open up Bandos's throne room." },
        requirements = {
            skills = {
                STRENGTH = 60,
                AGILITY = 60,
                RANGED = 60,
                THIEVING = 46,
                ATTACK = 15,
                PRAYER = 30,
                MINING = 17,
                CRAFTING = 12,
                FIREMAKING = 16,
                MAGIC = 33,
                FISHING = 36,
                HERBLORE = 37,
            },
            quests = { "CHOSEN_COMMANDER" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "AGILITY",
                level = 60,
            },
        },
        priority = 2,
    },

    {
        id = "agility.method.oasis",
        main_method = true,
        icon_item_id = 47925,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 65, 69 },
        members = true,
        title = "Het's Oasis course",
        hook = "Het's Oasis offers a course close to a familiar travel hub.",
        why = "Full laps provide a repeatable training option without a long trip across Gielinor.",
        how = { "Visit Het's Oasis near Al Kharid and look for the course starting point." },
        requirements = {
            skills = {
                AGILITY = 65,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "AGILITY",
                level = 65,
            },
        },
        priority = 2,
    },

    {
        id = "agility.method.anachronia_sections",
        main_method = true,
        icon_item_id = 47925,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 70, 76 },
        members = true,
        title = "Anachronia course sections",
        hook = "Anachronia lets you train on a section of its larger course.",
        why = "Partial routes offer experience before you have the levels for the whole island circuit, with a chance at codex pages.",
        how = {
            "Look for the course markings near Anachronia base camp and try an advanced section.",
        },
        requirements = {
            skills = {
                AGILITY = 70,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "AGILITY",
                level = 70,
            },
        },
        priority = 2,
    },

    {
        id = "agility.method.hefin",
        main_method = true,
        icon_item_id = 47925,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 77, 79 },
        members = true,
        title = "Hefin course",
        hook = "The Hefin course offers Agility laps without obstacle failures.",
        why = "Its experience grows with your level, while occasional shortcuts can make a lap quicker.",
        how = { "Visit the course in the Hefin district of Prifddinas." },
        quest_how = {
            "Work towards Plague's End to open up Prifddinas and its training facilities.",
        },
        requirements = {
            skills = {
                AGILITY = 77,
                CONSTRUCTION = 75,
                CRAFTING = 75,
                DUNGEONEERING = 75,
                HERBLORE = 75,
                MINING = 75,
                PRAYER = 75,
                RANGED = 75,
                SUMMONING = 75,
                WOODCUTTING = 75,
                COOKING = 30,
                FLETCHING = 70,
                THIEVING = 50,
            },
            quests = { "PLAGUES_END" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "AGILITY",
                level = 77,
            },
        },
        priority = 2,
    },

    {
        id = "agility.method.spirit_moths",
        main_method = true,
        icon_item_id = 12163,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 80, 84 },
        members = true,
        title = "Spirit moths",
        hook = "Barehanded spirit moths offer an Agility alternative to running laps.",
        why = "Catching them trades most of their usual charm drops for Agility experience.",
        how = { "Search hollow trees in Highweald Forest, then try catching the moths barehanded." },
        quest_how = { "Look into Heralds of Crimson to start exploring Havenhythe." },
        requirements = {
            skills = {
                AGILITY = 80,
                HUNTER = 85,
                CRAFTING = 51,
                HERBLORE = 55,
                MINING = 65,
                SMITHING = 60,
                CONSTRUCTION = 30,
                SLAYER = 28,
            },
            quests = { "QUEST_WENDLE_HERALDS" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "AGILITY",
                level = 80,
            },
        },
        priority = 2,
    },

    {
        id = "agility.method.anachronia_laps",
        main_method = true,
        icon_item_id = 47925,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 85, 120 },
        members = true,
        title = "Full Anachronia laps",
        hook = "Full Anachronia laps combine Agility experience with codex-page rewards.",
        why = "Completing the whole island circuit adds a substantial lap bonus. The route takes more attention while you learn it.",
        how = { "Follow the course markings around the island and back to the starting point." },
        requirements = {
            skills = {
                AGILITY = 85,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "AGILITY",
                level = 85,
            },
        },
        priority = 2,
    },

    {
        id = "agility.alt.early_anachronia",
        icon_item_id = 47925,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 30, 64 },
        members = true,
        title = "Exploring the Anachronia course",
        hook = "Anachronia offers smaller course sections before the full island route is possible.",
        why = "You can learn part of the route and gather codex pages without completing an entire lap.",
        how = {
            "Look for the lower-level section near base camp and follow the white course markings.",
        },
        requirements = {
            skills = {
                AGILITY = 30,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "AGILITY",
            },
        },
        priority = 3,
    },

    {
        id = "agility.alt.werewolf",
        icon_item_id = 47925,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 60, 84 },
        members = true,
        title = "Werewolf course",
        hook = "The werewolf course offers a change from standard laps.",
        why = "Fetching and returning the stick is part of earning the full course reward.",
        how = {
            "After Creature of Fenkenstrain, use the ring of charos to enter the course near Canifis.",
        },
        quest_how = {
            "Look into Creature of Fenkenstrain and its ring of charos to enter the course.",
        },
        requirements = {
            skills = {
                AGILITY = 60,
                CRAFTING = 20,
                THIEVING = 25,
            },
            quests = { "CREATURE_OF_FENKENSTRAIN" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "AGILITY",
            },
        },
        priority = 3,
    },

    {
        id = "agility.alt.throne_room",
        icon_item_id = 47925,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 65, 76 },
        members = true,
        title = "Empty Throne Room",
        hook = "The Empty Throne Room offers more relaxed Agility training.",
        why = "Its manual cycles provide a limited pool of experience, making it a stepping stone rather than a permanent training spot.",
        how = { "Look for the excavation beneath the Varrock Dig Site and try the manual cycles." },
        requirements = {
            skills = {
                AGILITY = 65,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "AGILITY",
            },
        },
        priority = 3,
    },

    {
        id = "agility.alt.serenity",
        icon_item_id = 47925,
        kind = "method",
        skills = { "AGILITY" },
        level_range = { 75, 94 },
        members = true,
        title = "Serenity posts",
        hook = "Serenity posts offer a short, relaxed Agility routine.",
        why = "They provide a limited amount of daily experience, with more from following the instructor's poses.",
        how = { "Visit the posts in the Hefin district of Prifddinas." },
        quest_how = {
            "Work towards Plague's End to open up Prifddinas and its training facilities.",
        },
        requirements = {
            skills = {
                AGILITY = 75,
                CONSTRUCTION = 75,
                CRAFTING = 75,
                DUNGEONEERING = 75,
                HERBLORE = 75,
                MINING = 75,
                PRAYER = 75,
                RANGED = 75,
                SUMMONING = 75,
                WOODCUTTING = 75,
                COOKING = 30,
                FLETCHING = 70,
                THIEVING = 50,
            },
            quests = { "PLAGUES_END" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "AGILITY",
            },
        },
        priority = 3,
    },
}
