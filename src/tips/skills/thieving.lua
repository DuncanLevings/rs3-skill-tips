-- thieving tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field

return {
    -- useful items and unlocks
    {
        id = "thieving.black_ibis",
        kind = "convenience",
        skills = { "THIEVING" },
        members = true,
        min_training_level = 40,
        title = "Black ibis outfit",
        icon_item = "HLR4M_SHADOWWRAP_HEAD",
        hook = "The black ibis outfit adds experience to your thieving.",
        why = "Each piece contributes, with a further bonus from wearing the full set.",
        how = {
            "Pieces are rare rewards from Pyramid Plunder.",
        },
        requirements = {
            skills = { THIEVING = 21 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "HLR4M_SHADOWWRAP_BODY",
                    "HLR4M_SHADOWWRAP_BOOTS",
                    "HLR4M_SHADOWWRAP_HEAD",
                    "HLR4M_SHADOWWRAP_LEGS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "thieving.camouflage",
        kind = "convenience",
        skills = { "THIEVING" },
        members = true,
        title = "Camouflage outfits",
        icon_item = "TRH90_MASTER_HEAD",
        hook = "Camouflage outfits help you keep pickpocketing for longer.",
        why = "Matching sets improve success and stun avoidance. Combining the three sets makes "
            .. "the master outfit.",
        how = {
            "Collect camouflage fragments while thieving, then make pieces at an Invention "
                .. "workbench.",
        },
        requirements = {
            skills = { INVENTION = 20, THIEVING = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH90_DESERT_BODY",
                    "TRH90_DESERT_FEET",
                    "TRH90_DESERT_HANDS",
                    "TRH90_DESERT_HEAD",
                    "TRH90_DESERT_LEGS",
                    "TRH90_KELDAGRIM_BODY",
                    "TRH90_KELDAGRIM_FEET",
                    "TRH90_KELDAGRIM_HANDS",
                    "TRH90_KELDAGRIM_HEAD",
                    "TRH90_KELDAGRIM_LEGS",
                    "TRH90_MASTER_BODY",
                    "TRH90_MASTER_FEET",
                    "TRH90_MASTER_HANDS",
                    "TRH90_MASTER_HEAD",
                    "TRH90_MASTER_LEGS",
                    "TRH90_PRIFDDINAS_BODY",
                    "TRH90_PRIFDDINAS_FEET",
                    "TRH90_PRIFDDINAS_HANDS",
                    "TRH90_PRIFDDINAS_HEAD",
                    "TRH90_PRIFDDINAS_LEGS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "thieving.ardougne_cloak",
        kind = "convenience",
        skills = { "THIEVING" },
        members = true,
        title = "Ardougne cloak",
        icon_item = "ATAR_CLOAK_MED",
        hook = "The Ardougne achievements can make pickpocketing in the city more reliable.",
        why = "The medium reward improves success in Ardougne; higher tiers carry that benefit "
            .. "beyond the city.",
        how = {
            "Look at the Ardougne task list and work towards its medium reward.",
        },
        requirements = {
            skills = {
                AGILITY = 39,
                CONSTRUCTION = 10,
                CRAFTING = 49,
                FARMING = 49,
                FIREMAKING = 50,
                FISHING = 3,
                HERBLORE = 57,
                MAGIC = 51,
                MINING = 46,
                RANGED = 21,
                STRENGTH = 38,
                THIEVING = 38,
                WOODCUTTING = 36,
            },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "ATAR_CLOAK_ELITE", "ATAR_CLOAK_HARD", "ATAR_CLOAK_MED" },
            },
        },
        priority = 2,
    },

    {
        id = "thieving.loot_bag",
        kind = "convenience",
        skills = { "THIEVING" },
        members = true,
        title = "Safecracking loot bag",
        icon_item = "SAFES_LOOTING_BAG_TIER1",
        hook = "A loot bag lets you keep more of the spoils from safecracking.",
        why = "Turn in the contents for rewards and pilfer points. Larger bags allow longer routes "
            .. "before a return trip.",
        how = {
            "After A Guild of Our Own, speak to the safe-cracking trainer in the Thieves' Guild.",
        },
        quest_how = {
            "Work through the Thieves' Guild capers to A Guild of Our Own, then visit its reward "
                .. "shops.",
        },
        requirements = {
            skills = { AGILITY = 40, HERBLORE = 46, THIEVING = 62 },
            quests = { "CAPER_OUROWN" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SAFES_LOOTING_BAG_TIER1",
                    "SAFES_LOOTING_BAG_TIER2",
                    "SAFES_LOOTING_BAG_TIER3",
                    "SAFES_LOOTING_BAG_TIER4",
                },
            },
        },
        priority = 2,
    },

    {
        id = "thieving.master_lockpick",
        kind = "convenience",
        skills = { "THIEVING" },
        members = true,
        title = "Master thief's lockpick",
        icon_item = "SAFES_REWARD_LOCKPICK",
        hook = "The master thief's lockpick offers a lasting upgrade for locks and chests.",
        why = "It cannot break, improves lock success and can be added to your tool belt.",
        how = {
            "Spend pilfer points at Dodgy Derek's Dirty Deals in the Thieves' Guild.",
        },
        quest_how = {
            "Work through the Thieves' Guild capers to A Guild of Our Own, then visit its reward "
                .. "shops.",
        },
        requirements = {
            skills = { AGILITY = 40, HERBLORE = 46, THIEVING = 62 },
            quests = { "CAPER_OUROWN" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        known_when = {
            { type = "owns_any", items = { "SAFES_REWARD_LOCKPICK" } },
        },
        priority = 2,
    },

    {
        id = "thieving.master_stethoscope",
        kind = "convenience",
        skills = { "THIEVING" },
        members = true,
        title = "Master thief's stethoscope",
        icon_item = "SAFES_REWARD_STETHOSCOPE",
        hook = "The master thief's stethoscope frees a slot on safecracking trips.",
        why = "It works like an ordinary stethoscope, but can be kept on your tool belt.",
        how = {
            "Spend pilfer points at Dodgy Derek's Dirty Deals in the Thieves' Guild.",
        },
        quest_how = {
            "Work through the Thieves' Guild capers to A Guild of Our Own, then visit its reward "
                .. "shops.",
        },
        requirements = {
            skills = { AGILITY = 40, HERBLORE = 46, THIEVING = 62 },
            quests = { "CAPER_OUROWN" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        known_when = {
            { type = "owns_any", items = { "SAFES_REWARD_STETHOSCOPE" } },
        },
        priority = 2,
    },

    {
        id = "thieving.pickpocketing_bag",
        kind = "convenience",
        skills = { "THIEVING" },
        members = true,
        title = "Pickpocketing bag",
        icon_item = "INVENT_THIEVING_BAG_UNUSED",
        hook = "A pickpocketing bag brings Invention perks to Thieving.",
        why = "It gains equipment experience as you pick pockets and uses energy from your charge "
            .. "pack.",
        how = {
            "Discover its blueprint and build it at an Invention workbench.",
        },
        requirements = {
            skills = { INVENTION = 22, THIEVING = 71 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "INVENT_THIEVING_BAG",
                    "INVENT_THIEVING_BAG_MUSHROOM",
                    "INVENT_THIEVING_BAG_MUSHROOM_UNCHARGED",
                    "INVENT_THIEVING_BAG_MUSHROOM_UNUSED",
                    "INVENT_THIEVING_BAG_UNCHARGED",
                    "INVENT_THIEVING_BAG_UNUSED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "thieving.mushroomy_bag",
        kind = "convenience",
        skills = { "THIEVING" },
        members = true,
        title = "Mushroomy pickpocketing bag",
        icon_item = "INVENT_THIEVING_BAG_MUSHROOM_UNUSED",
        hook = "A mushroomy pickpocketing bag can speed up automatic pickpocketing.",
        why = "It also carries tool perks. Its speed effect does not stack with Sticky Fingers.",
        how = {
            "Discover the upgrade at an Invention workbench and gather its mushroom ingredients.",
        },
        requirements = {
            skills = { CRAFTING = 80, INVENTION = 82, THIEVING = 81 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "INVENT_THIEVING_BAG_MUSHROOM",
                    "INVENT_THIEVING_BAG_MUSHROOM_UNCHARGED",
                    "INVENT_THIEVING_BAG_MUSHROOM_UNUSED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "thieving.soul_box",
        kind = "convenience",
        skills = { "THIEVING" },
        members = true,
        min_training_level = 70,
        title = "Soul-in-a-box",
        icon_item = "NOMEL_SOUL_DISTRACTOR",
        hook = "A soul-in-a-box offers a small helping hand with pickpocketing.",
        why = "Its distracting soul improves your success chance nearby. The device is reusable "
            .. "and draws from your charge pack.",
        how = {
            "After Nomad's Elegy, discover and build it at an Invention workbench.",
        },
        quest_how = {
            "Work towards Nomad's Elegy to unlock the Invention device.",
        },
        requirements = {
            skills = {
                AGILITY = 46,
                ATTACK = 79,
                CONSTRUCTION = 75,
                CRAFTING = 70,
                DEFENCE = 72,
                FIREMAKING = 71,
                FISHING = 36,
                FLETCHING = 25,
                HERBLORE = 49,
                HITPOINTS = 78,
                HUNTER = 65,
                INVENTION = 24,
                MAGIC = 80,
                MINING = 75,
                PRAYER = 70,
                RUNECRAFTING = 25,
                SLAYER = 69,
                SMITHING = 80,
                STRENGTH = 79,
                SUMMONING = 55,
                THIEVING = 54,
                WOODCUTTING = 75,
            },
            quests = { "NOMADS_ELEGY" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        known_when = {
            { type = "owns_any", items = { "NOMEL_SOUL_DISTRACTOR" } },
        },
        priority = 2,
    },

    {
        id = "thieving.sticky_fingers",
        kind = "general",
        skills = { "THIEVING" },
        members = true,
        min_training_level = 70,
        title = "Sticky Fingers",
        icon_item_id = 1523,
        hook = "Sticky Fingers makes automatic pickpocketing quicker.",
        why = "The relic power speeds up attempts but reduces experience per pickpocket, making it "
            .. "a different rhythm rather than a free experience multiplier.",
        how = {
            "Look into the Andvaranaut relic through Archaeology, then harness it at the "
                .. "mysterious monolith.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 84, THIEVING = 1 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        priority = 2,
    },

    {
        id = "thieving.crystal_totem",
        kind = "convenience",
        skills = { "THIEVING" },
        members = true,
        title = "Totem of Crystal",
        icon_item = "DINO_TOTEM_ELVES",
        hook = "The Totem of Crystal reduces the wait after being caught by Prifddinas workers.",
        why = "Place the completed totem on an Anachronia pedestal to shorten the workers' "
            .. "pickpocketing lockout.",
        how = {
            "Look for its pieces through the Anachronia course, island exploration and Herby Werby "
                .. "rewards.",
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
                THIEVING = 91,
                WOODCUTTING = 75,
            },
            quests = { "PLAGUES_END" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        known_when = {
            { type = "owns_any", items = { "DINO_TOTEM_ELVES" } },
        },
        priority = 2,
    },

    {
        id = "thieving.ring_vitur",
        kind = "convenience",
        skills = { "THIEVING" },
        members = true,
        title = "Ring of Vitur",
        icon_item = "VITUR_RING",
        hook = "The Ring of Vitur offers a high-level upgrade for pickpocketing.",
        why = "Wear it for a better chance of a successful pickpocket.",
        how = {
            "Find one through high-level Darkmeyer thieving, or buy one on the Grand Exchange.",
        },
        quest_how = {
            "Work towards The Branches of Darkmeyer to explore Darkmeyer and this reward source.",
        },
        requirements = {
            skills = {
                AGILITY = 63,
                CONSTRUCTION = 20,
                CRAFTING = 64,
                FARMING = 63,
                FIREMAKING = 40,
                FLETCHING = 70,
                MAGIC = 70,
                MINING = 35,
                SLAYER = 67,
                STRENGTH = 40,
                THIEVING = 117,
                WOODCUTTING = 76,
            },
            quests = { "BRANCHES_OF_DARKMEYER" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        known_when = {
            { type = "owns_any", items = { "VITUR_RING" } },
        },
        priority = 2,
    },

    {
        id = "thieving.cape",
        kind = "convenience",
        skills = { "THIEVING" },
        members = true,
        title = "Thieving cape",
        icon_item = "SKILLCAPE_THIEVING",
        hook = "The Thieving cape makes pickpocketing loot easier to carry.",
        why = "Its perk automatically notes supported loot, leaving more backpack space between "
            .. "bank trips.",
        how = {
            "Buy it from Martin Thwait in the Rogues' Den beneath the Toad and Chicken.",
        },
        requirements = {
            skills = { THIEVING = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_120_THIEVING",
                    "SKILLCAPE_INVERTED_120_THIEVING",
                    "SKILLCAPE_INVERTED_THIEVING_HOODED",
                    "SKILLCAPE_INVERTED_THIEVING_TRIMMED_HOODED",
                    "SKILLCAPE_THIEVING",
                    "SKILLCAPE_THIEVING_HOODED",
                    "SKILLCAPE_THIEVING_HOODED_RETRO",
                    "SKILLCAPE_THIEVING_RETRO",
                    "SKILLCAPE_THIEVING_TRIMMED",
                    "SKILLCAPE_THIEVING_TRIMMED_HOODED",
                    "SKILLCAPE_THIEVING_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_THIEVING_TRIMMED_RETRO",
                },
            },
        },
        priority = 2,
    },

    {
        id = "thieving.master_cape",
        kind = "convenience",
        skills = { "THIEVING" },
        members = true,
        title = "Thieving master cape",
        icon_item = "SKILLCAPE_120_THIEVING",
        hook = "The Thieving master cape makes heist mistakes less costly.",
        why = "Its perk reduces loot-point penalties from getting caught, alongside the regular "
            .. "cape perk.",
        how = {
            "Buy it from Martin Thwait after reaching true Thieving mastery.",
        },
        requirements = {
            skills = { THIEVING = 120 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "SKILLCAPE_120_THIEVING", "SKILLCAPE_INVERTED_120_THIEVING" },
            },
        },
        priority = 2,
    },

    -- training methods, one main method per level bracket
    {
        id = "thieving.method.farmers",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 10, 14 },
        main_method = true,
        title = "Farmers",
        icon_item_id = 1523,
        hook = "Farmers offer pickpocketing practice with seeds among the loot.",
        why = "The seeds can be useful for Farming, though the variety can fill your backpack.",
        how = {
            "Look for a farmer around the fields north of Lumbridge.",
        },
        requirements = {
            skills = { THIEVING = 10 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 10 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.ham_members",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 15, 24 },
        main_method = true,
        title = "H.A.M. members",
        icon_item_id = 1523,
        hook = "H.A.M. members offer Thieving practice with a chance at easy clue scrolls.",
        why = "Repeated failures can get you thrown out of their hideout, so expect occasional "
            .. "interruptions.",
        how = {
            "Look for the H.A.M. hideout beneath the old mine west of Lumbridge.",
        },
        requirements = {
            skills = { THIEVING = 15 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 15 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.warrior_women",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 25, 35 },
        main_method = true,
        title = "Warrior women",
        icon_item_id = 1523,
        hook = "Warrior women offer a coin-focused pickpocketing option in Ardougne.",
        why = "Their coin loot keeps backpack management simple, though failed attempts still "
            .. "interrupt training.",
        how = {
            "Look around East Ardougne or its castle for a warrior woman.",
        },
        requirements = {
            skills = { THIEVING = 25 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 25 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.cave_goblins",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 36, 37 },
        main_method = true,
        title = "Cave goblins",
        icon_item_id = 1523,
        hook = "Dorgesh-Kaan offers an underground change of scenery for pickpocketing.",
        why = "Its cave goblins carry food and other supplies, giving a different mix of loot from "
            .. "surface targets.",
        how = {
            "After Death to the Dorgeshuun, look for pickpocketable citizens around Dorgesh-Kaan.",
        },
        quest_how = {
            "Complete Death to the Dorgeshuun to explore Dorgesh-Kaan.",
        },
        requirements = {
            skills = { AGILITY = 23, MINING = 17, THIEVING = 36 },
            quests = { "DEATH_TO_THE_DORGESHUUN" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 36 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.master_farmers",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 38, 39 },
        main_method = true,
        title = "Master farmers",
        icon_item_id = 1523,
        hook = "Master farmers offer pickpocketing practice while building a seed supply.",
        why = "Their varied seeds can support Farming, but keeping them all means more backpack "
            .. "management.",
        how = {
            "Try a master farmer at Draynor Village or near the Ardougne lodestone.",
        },
        requirements = {
            skills = { THIEVING = 38 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 38 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.guards",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 40, 41 },
        main_method = true,
        title = "Varrock guards",
        icon_item_id = 1523,
        hook = "Varrock guards offer a convenient coin-focused Thieving option.",
        why = "Their loot is simple to carry, with city banks nearby when you need a break.",
        how = {
            "Look for a pickpocketable guard around Varrock.",
        },
        requirements = {
            skills = { THIEVING = 40 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 40 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.druids",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 42, 44 },
        main_method = true,
        title = "Garden of Kharid druids",
        icon_item_id = 1523,
        hook = "The Garden of Kharid offers pickpocketing practice alongside seed gathering.",
        why = "Its druids provide a different target from city guards, with seeds to keep for "
            .. "Farming.",
        how = {
            "Look for the druids in the Garden of Kharid near Al Kharid.",
        },
        requirements = {
            skills = { THIEVING = 42 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 42 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.brigands",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 45, 45 },
        main_method = true,
        title = "Brigands",
        icon_item_id = 1523,
        hook = "Brigands offer another coin-focused pickpocketing option in the desert.",
        why = "They need no quest unlock for ordinary pickpocketing, unlike some nearby training "
            .. "options.",
        how = {
            "Look for brigands in northern Pollnivneach.",
        },
        requirements = {
            skills = { THIEVING = 45 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 45 },
        },
        priority = 2,
    },

    {
        id = "thieving.alt.marketeers",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 46, 49 },
        main_method = true,
        title = "Menaphite marketeers",
        icon_item_id = 1523,
        hook = "Menaphite marketeers offer a simple pickpocketing option in Menaphos.",
        why = "They provide a change of location while you work towards access to safecracking.",
        how = {
            "Look in the Merchant district after opening access to Menaphos.",
        },
        quest_how = {
            "Start The Jack of Spades to open up Menaphos.",
        },
        requirements = {
            skills = { THIEVING = 46 },
            quests = { "OZAN3" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 46 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.trainee_archaeologists",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 50, 52 },
        main_method = true,
        title = "Trainee archaeologists",
        icon_item_id = 1523,
        hook = "Trainee archaeologists offer Thieving practice with Archaeology supplies among the "
            .. "loot.",
        why = "Their soil and materials can support excavation training, though varied loot takes "
            .. "backpack space.",
        how = {
            "Try the trainee north of the Exam Centre at the Archaeology Campus.",
        },
        requirements = {
            skills = { THIEVING = 50 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 50 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.desert_bandits",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 53, 54 },
        main_method = true,
        title = "Desert bandits",
        icon_item_id = 1523,
        hook = "Desert bandits offer a short pickpocketing detour before safecracking.",
        why = "Their coin loot keeps your backpack simple, but the desert makes the trip less "
            .. "convenient than a city spot.",
        how = {
            "Look for the bandits at the Kharidian Desert Bandit Camp; Pollnivneach bandits need a "
                .. "higher level.",
        },
        requirements = {
            skills = { THIEVING = 53 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 53 },
        },
        priority = 2,
    },

    {
        id = "thieving.alt.ardougne_knights",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 55, 61 },
        main_method = true,
        title = "Knights of Ardougne",
        icon_item_id = 1523,
        hook = "Ardougne knights offer a pickpocketing option with convenient city facilities.",
        why = "The Ardougne achievement rewards can improve your success rate here.",
        how = {
            "Look for a knight in Ardougne and compare the rhythm with your usual pickpocketing "
                .. "spot.",
        },
        requirements = {
            skills = { THIEVING = 55 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 55 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.misthalin",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 62, 75 },
        main_method = true,
        title = "Misthalin safes",
        icon_item_id = 1523,
        hook = "Misthalin safes offer a route-based alternative to pickpocketing.",
        why = "A loot bag carries the spoils, while a stethoscope helps with cracking. "
            .. "Higher-level safes let you extend or change your route.",
        how = {
            "Check safes in Misthalin. The Thieves' Guild trainer explains the equipment after A "
                .. "Guild of Our Own.",
        },
        requirements = {
            skills = { THIEVING = 62 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 62 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.asgarnia",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 76, 82 },
        main_method = true,
        title = "Asgarnia safes",
        icon_item_id = 1523,
        hook = "Asgarnia safes offer a route-based alternative to pickpocketing.",
        why = "A loot bag carries the spoils, while a stethoscope helps with cracking. "
            .. "Higher-level safes let you extend or change your route.",
        how = {
            "Check safes in Asgarnia. The Thieves' Guild trainer explains the equipment after A "
                .. "Guild of Our Own.",
        },
        requirements = {
            skills = { THIEVING = 76 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 76 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.kandarin",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 83, 89 },
        main_method = true,
        title = "Kandarin safes",
        icon_item_id = 1523,
        hook = "Kandarin safes offer a route-based alternative to pickpocketing.",
        why = "A loot bag carries the spoils, while a stethoscope helps with cracking. "
            .. "Higher-level safes let you extend or change your route.",
        how = {
            "Check safes in Kandarin. The Thieves' Guild trainer explains the equipment after A "
                .. "Guild of Our Own.",
        },
        requirements = {
            skills = { THIEVING = 83 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 83 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.rogues_castle",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 90, 94 },
        main_method = true,
        title = "Rogues' Castle safes",
        icon_item_id = 1523,
        hook = "The Rogues' Castle offers high-level safes with a Wilderness tradeoff.",
        why = "Its safes can reward a longer trip, but the castle is deep in the Wilderness.",
        how = {
            "Look for the upstairs safes and plan your journey before bringing a bag of loot.",
        },
        requirements = {
            skills = { THIEVING = 90 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 90 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.hereditas",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 95, 107 },
        main_method = true,
        title = "Vault of Hereditas",
        icon_item_id = 1523,
        hook = "The Vault of Hereditas offers a more active Thieving challenge.",
        why = "Build up loot while navigating guards and traps, then leave with your haul. "
            .. "Mistakes reduce what you take home.",
        how = {
            "Complete Breaking the Seal at Kharid-et, then speak to Liara outside the vault.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 12, THIEVING = 95 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 95 },
        },
        priority = 2,
    },

    {
        id = "thieving.method.asuran",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 108, 120 },
        main_method = true,
        title = "Asuran Arsenal",
        icon_item_id = 1523,
        hook = "The Asuran Arsenal offers a demanding high-level heist.",
        why = "Its traps can deal damage as well as reduce loot. Deaths are unsafe, so learning "
            .. "the route carries a real risk.",
        how = {
            "Speak to Liara at the Swamp Fortress on south-east Anachronia.",
        },
        requirements = {
            skills = { THIEVING = 108 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "THIEVING", level = 108 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "thieving.alt.crux_eqal",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 83, 107 },
        title = "Crux Eqal knights",
        icon_item_id = 1523,
        hook = "Crux Eqal knights offer a pickpocketing option with farming supplies among the "
            .. "loot.",
        why = "Success-improving equipment can help you keep a pickpocketing chain going for "
            .. "longer.",
        how = {
            "Look around the Garden of Kharid near Al Kharid.",
        },
        requirements = {
            skills = { THIEVING = 83 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        priority = 3,
    },

    {
        id = "thieving.alt.prifddinas",
        kind = "method",
        skills = { "THIEVING" },
        members = true,
        level_range = { 91, 119 },
        title = "Prifddinas workers",
        icon_item_id = 1523,
        hook = "Prifddinas workers offer clan-themed supplies alongside Thieving experience.",
        why = "More clans become available as you level. Being caught creates a temporary lockout "
            .. "for that clan.",
        how = {
            "Try a worker in a clan you have the level for, then explore what the other clans "
                .. "offer.",
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
                THIEVING = 91,
                WOODCUTTING = 75,
            },
            quests = { "PLAGUES_END" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "THIEVING" },
        },
        priority = 3,
    },
}
