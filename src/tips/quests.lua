-- quests worth doing for what they unlock. these show in a quiet pause once the player has
-- every skill level (or is close, for tips with an aspiration). quest is the quest's config
-- name, always the live one (some quests also have a dead duplicate config)

return {
    {
        id = "quest.fishing_contest",
        kind = "quest",
        quest = "FISHING_CONTEST",
        skills = { "ANY" },
        members = true,
        title = "Fishing Contest",
        icon_item_id = 335,
        hook = "You've got the Fishing level for Fishing Contest and its White Wolf Mountain "
            .. "shortcut.",
        why = "Finishing this short quest lets you cross beneath the mountain instead of walking "
            .. "over it.",
        how = {
            "Speak to Austri near Taverley or Vestri near Catherby, by the tunnel entrances.",
        },
        requirements = {
            skills = { FISHING = 10 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.family_crest",
        kind = "quest",
        quest = "FAMILY_CREST",
        skills = { "ANY" },
        members = true,
        title = "Family Crest",
        icon_item_id = 775,
        hook = "You've got the levels for Family Crest, which unlocks useful skilling gauntlets.",
        why = "Its reward can become cooking or goldsmith gauntlets, handy upgrades for your next "
            .. "training session.",
        how = {
            "Find Dimintheis in south-east Varrock. Expect some combat during the quest.",
        },
        requirements = {
            skills = { CRAFTING = 40, MAGIC = 59, MINING = 40, SMITHING = 40 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.world_wakes",
        kind = "quest",
        quest = "WORLD_WAKES",
        skills = { "ANY" },
        members = true,
        title = "Sunshine and Death's Swiftness",
        icon_item_id = 554,
        hook = "The World Wakes unlocks powerful damage-boosting abilities for Magic and Ranged.",
        aspiration_hook = "Sunshine and Death's Swiftness offer powerful combat unlocks to work "
            .. "towards.",
        why = "Both strengthen their respective combat styles during a fight. Each needs level 76 "
            .. "in its respective skill.",
        how = {
            "Speak to Orlando Smith west of the Legends' Guild to begin. Expect several combat "
                .. "encounters.",
        },
        requirements = {
            skills = {},
            any_skills = { MAGIC = 76, RANGED = 76 },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.soul_split",
        kind = "quest",
        quest = "TEMPLE_AT_SENNTISTEN",
        skills = { "ANY" },
        members = true,
        title = "Soul Split",
        icon_item_id = 526,
        hook = "Soul Split can turn damage you deal into healing.",
        aspiration_hook = "Soul Split offers a Prayer target for sustaining longer fights.",
        why = "It belongs to the Ancient Curses unlocked by The Temple at Senntisten, giving "
            .. "Prayer a lasting role in sustaining longer fights.",
        how = {
            "Work towards The Temple at Senntisten through Dr Nabanik at the Dig Site. The quest "
                .. "also needs 125 museum Kudos.",
        },
        requirements = {
            skills = {
                AGILITY = 61,
                CONSTRUCTION = 35,
                COOKING = 35,
                CRAFTING = 40,
                FARMING = 25,
                FIREMAKING = 50,
                FLETCHING = 50,
                HERBLORE = 10,
                HUNTER = 51,
                MAGIC = 59,
                MINING = 64,
                PRAYER = 92,
                RANGED = 64,
                RUNECRAFTING = 50,
                SLAYER = 37,
                SMITHING = 65,
                STRENGTH = 64,
                SUMMONING = 41,
                THIEVING = 66,
                WOODCUTTING = 10,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.ancient_magicks",
        kind = "quest",
        quest = "DESERT_TREASURE",
        skills = { "ANY" },
        members = true,
        title = "Ancient Magicks",
        icon_item_id = 563,
        hook = "Desert Treasure opens up a different set of combat spells and teleports.",
        aspiration_hook = "A few more levels could put Ancient Magicks within reach.",
        why = "The Ancient Magicks spellbook includes area spells and blood spells that can heal "
            .. "you while dealing damage.",
        how = {
            "Speak to the archaeologist at the Bedabin Camp to begin Desert Treasure. Expect "
                .. "several boss fights.",
        },
        requirements = {
            skills = {
                AGILITY = 15,
                FIREMAKING = 50,
                HERBLORE = 10,
                MAGIC = 50,
                SLAYER = 10,
                THIEVING = 53,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.lunar_magic",
        kind = "quest",
        quest = "LUNAR_DIPLOMACY",
        skills = { "ANY" },
        members = true,
        title = "Lunar spellbook",
        icon_item_id = 9075,
        hook = "Lunar Diplomacy opens a spellbook built around utility and skilling.",
        aspiration_hook = "A few more levels could put Lunar spellbook within reach.",
        why = "Its spells offer options such as remote NPC contact and group teleports, with more "
            .. "becoming useful as your Magic level grows.",
        how = {
            "Speak to Lokar Searunner on the western docks of Rellekka to begin Lunar Diplomacy.",
        },
        requirements = {
            skills = {
                CRAFTING = 61,
                DEFENCE = 40,
                FIREMAKING = 49,
                FLETCHING = 25,
                HERBLORE = 5,
                MAGIC = 65,
                MINING = 60,
                WOODCUTTING = 55,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.fairy_rings",
        kind = "quest",
        quest = "FAIRY_TALE_II",
        skills = { "ANY" },
        members = true,
        title = "Fairy rings",
        icon_item_id = 772,
        hook = "Fairy rings open up a travel network across Gielinor.",
        aspiration_hook = "A few more levels could put Fairy rings within reach.",
        why = "Access comes partway through A Fairy Tale II, so you do not need its later Farming "
            .. "and Herblore levels just to use the rings.",
        how = {
            "After A Fairy Tale I, start A Fairy Tale II through Martin in Draynor Village and "
                .. "follow the investigation in Zanaris.",
        },
        requirements = {
            skills = { CRAFTING = 31, WOODCUTTING = 36 },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.prifddinas",
        kind = "quest",
        quest = "PLAGUES_END",
        skills = { "ANY" },
        members = true,
        title = "Prifddinas",
        icon_item_id = 6099,
        hook = "Prifddinas brings a wide range of training facilities and lasting unlocks "
            .. "together.",
        aspiration_hook = "A few more levels could put Prifddinas within reach.",
        why = "The elven city offers crystal tools, clan training spots and the Trahaearn "
            .. "exoskeleton among its rewards.",
        how = {
            "Work through the elf quest line to Plague's End, which begins with Arianwyn in "
                .. "Lletya.",
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
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.dragon_rider",
        kind = "quest",
        quest = "ONE_OF_A_KIND",
        skills = { "ANY" },
        members = true,
        title = "Dragon Rider amulet",
        icon_item_id = 30929,
        hook = "The Dragon Rider amulet offers more Prayer experience from burying dragon bones.",
        why = "It is a reusable reward from One of a Kind, offering an alternative to carrying "
            .. "bones to an altar.",
        how = {
            "Look into One of a Kind through Mr Mordaut in his office under the Varrock Museum "
                .. "stairs. Expect combat during the quest.",
        },
        requirements = {
            skills = {
                ATTACK = 30,
                DIVINATION = 40,
                DUNGEONEERING = 67,
                MAGIC = 81,
                PRAYER = 60,
                SUMMONING = 74,
            },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.daves_spellbook",
        kind = "quest",
        quest = "DAVE",
        skills = { "ANY" },
        members = true,
        title = "More teleport destinations",
        icon_item_id = 563,
        hook = "Evil Dave's spellbook adds some unusual destinations to familiar teleport tablets.",
        why = "Chipping supported tablets lets you redirect them to places their normal versions "
            .. "do not reach.",
        how = {
            "Speak to Evil Dave in his Basement of Doom in Edgeville to begin Evil Dave's Big Day "
                .. "Out.",
        },
        requirements = {
            skills = {
                AGILITY = 30,
                COOKING = 30,
                CRAFTING = 30,
                HERBLORE = 30,
                MAGIC = 30,
                THIEVING = 25,
            },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.avas_recovery",
        kind = "quest",
        quest = "ANIMAL_MAGNETISM",
        skills = { "ANY" },
        members = true,
        title = "Ava's ammunition recovery",
        icon_item_id = 10499,
        hook = "Animal Magnetism unlocks Ava's help with recovering ammunition.",
        aspiration_hook = "Animal Magnetism unlocks Ava's help with recovering ammunition. You're "
            .. "close to the levels.",
        why = "The accumulator adds a permanent ammunition-recovery effect, so you do not have to "
            .. "keep its cape equipped.",
        how = {
            "Speak to Ava in Draynor Manor to begin Animal Magnetism.",
        },
        requirements = {
            skills = { CRAFTING = 19, RANGED = 50, SLAYER = 18, THIEVING = 15, WOODCUTTING = 35 },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.devotion",
        kind = "quest",
        quest = "ONE_PIERCING_NOTE",
        skills = { "ANY" },
        members = false,
        title = "Devotion",
        icon_item_id = 526,
        hook = "Devotion briefly makes protection prayers much more effective.",
        aspiration_hook = "Devotion briefly makes protection prayers much more effective. You're "
            .. "close to the levels.",
        why = "One Piercing Note unlocks this defensive ability, along with Sacrifice and "
            .. "Transfigure. It can be useful across combat styles.",
        how = {
            "Speak to Sister Catherina outside Citharede Abbey, east of Al Kharid.",
        },
        requirements = {
            skills = { PRAYER = 43 },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.salve",
        kind = "quest",
        quest = "HAUNTED_MINE",
        skills = { "ANY" },
        members = true,
        title = "Salve amulet",
        icon_item_id = 4081,
        hook = "The salve amulet strengthens your attacks against undead enemies.",
        why = "Its bonus works across combat styles, giving you a reusable option for encounters "
            .. "with undead.",
        how = {
            "Look into Haunted Mine through the zealot outside the Abandoned Mine in southern "
                .. "Morytania. Expect combat.",
        },
        requirements = {
            skills = { AGILITY = 15, CRAFTING = 35 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.salve_enhanced",
        kind = "quest",
        quest = "LAIR_OF_TARN_RAZORLOR",
        skills = { "ANY" },
        members = true,
        title = "Enhanced salve amulet",
        icon_item_id = 10588,
        hook = "An enhanced salve amulet improves the bonus against undead.",
        why = "Tarn's diary upgrades the amulet, making Haunted Mine's reward useful for stronger "
            .. "encounters too.",
        how = {
            "After Haunted Mine, explore Tarn's lair through the north wall of the Abandoned "
                .. "Mine's ground floor.",
        },
        requirements = {
            skills = { AGILITY = 15, CRAFTING = 35, SLAYER = 40 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.piety",
        kind = "quest",
        quest = "KINGS_RANSOM",
        skills = { "ANY" },
        members = true,
        title = "Piety",
        icon_item_id = 526,
        hook = "Piety gives melee combat a stronger offensive and defensive prayer option.",
        aspiration_hook = "Piety gives melee combat a stronger offensive and defensive prayer "
            .. "option. You're close to the levels.",
        why = "King's Ransom opens the Knight Waves training ground; completing that training "
            .. "unlocks Piety and Chivalry.",
        how = {
            "Speak to Gossip outside Sinclair Mansion for King's Ransom, then investigate Knight "
                .. "Waves training in Camelot.",
        },
        requirements = {
            skills = {
                AGILITY = 36,
                ATTACK = 30,
                CRAFTING = 25,
                DEFENCE = 70,
                HERBLORE = 18,
                PRAYER = 70,
                SMITHING = 30,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.ectophial",
        kind = "quest",
        quest = "GHOSTS_AHOY",
        skills = { "ANY" },
        members = true,
        title = "Ectophial",
        icon_item_id = 4251,
        hook = "The ectophial offers a reusable teleport to the Ectofuntus.",
        why = "It provides a quick way back to eastern Morytania, with Port Phasmatys nearby.",
        how = {
            "Speak to Velorina in Port Phasmatys to begin Ghosts Ahoy.",
        },
        requirements = {
            skills = { AGILITY = 25, COOKING = 20 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.trollheim",
        kind = "quest",
        quest = "EADGARS_RUSE",
        skills = { "ANY" },
        members = true,
        title = "Trollheim teleport",
        icon_item_id = 563,
        hook = "Trollheim Teleport shortens repeat trips into the troll mountains.",
        why = "The spell provides a convenient route towards the Troll Stronghold and its "
            .. "surrounding facilities.",
        how = {
            "Speak to Sanfew in Taverley about Eadgar's Ruse.",
        },
        requirements = {
            skills = { AGILITY = 15, HERBLORE = 31, MAGIC = 61, THIEVING = 30 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.gliders",
        kind = "quest",
        quest = "GRAND_TREE",
        skills = { "ANY" },
        members = true,
        title = "Gnome gliders",
        icon_item_id = 563,
        hook = "Gnome gliders add another way to travel between distant parts of Gielinor.",
        why = "The Grand Tree opens the glider network, with stops that can complement your usual "
            .. "teleports.",
        how = {
            "Speak to King Narnode Shareen in the Grand Tree at the Tree Gnome Stronghold.",
        },
        requirements = {
            skills = { AGILITY = 25 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.spirit_trees",
        kind = "quest",
        quest = "TREE_GNOME_VILLAGE",
        skills = { "ANY" },
        members = true,
        title = "Spirit tree travel",
        icon_item_id = 1511,
        hook = "Spirit trees connect several useful travel hubs without using runes.",
        why = "Tree Gnome Village opens the network, and later quests and Farming unlocks extend "
            .. "what you can reach.",
        how = {
            "Speak to King Bolren at the centre of the Tree Gnome Village maze. Expect combat.",
        },
        requirements = {
            skills = {},
            any_skills = { AGILITY = 20, ATTACK = 30, MAGIC = 30, NECROMANCY = 30, RANGED = 30 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.house_tablets",
        kind = "quest",
        quest = "LOVE_STORY",
        skills = { "ANY" },
        members = true,
        title = "More house-tablet destinations",
        icon_item_id = 563,
        hook = "Love Story lets house teleport tablets reach more places.",
        why = "Chipping the tablets gives destinations based on house portals, making them useful "
            .. "even when your own house is elsewhere.",
        how = {
            "Speak to Mabel at the barn north-east of Draynor Village to begin Love Story.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 68,
                COOKING = 62,
                CRAFTING = 67,
                FIREMAKING = 42,
                FISHING = 62,
                MAGIC = 77,
                SMITHING = 68,
            },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.staff_free_rings",
        kind = "quest",
        quest = "FAIRY_TALE_III",
        skills = { "ANY" },
        members = true,
        title = "Staff-free fairy rings",
        icon_item_id = 772,
        hook = "A Fairy Tale III makes fairy-ring travel simpler.",
        aspiration_hook = "A Fairy Tale III makes fairy-ring travel simpler. You're close to the "
            .. "levels.",
        why = "You can use the rings without a dramen or lunar staff. Its farming rewards also let "
            .. "gardeners keep patches free of weeds.",
        how = {
            "Continue the fairy story through the Fairy Queen in the Fairy Resistance Hideout.",
        },
        requirements = {
            skills = {
                CRAFTING = 36,
                FARMING = 54,
                HERBLORE = 57,
                THIEVING = 51,
                WOODCUTTING = 36,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.kingdom",
        kind = "quest",
        quest = "THRONE_OF_MISCELLANIA",
        skills = { "ANY" },
        members = true,
        title = "Managing Miscellania",
        icon_item_id = 995,
        hook = "Managing Miscellania lets workers gather resources while you are elsewhere.",
        aspiration_hook = "Managing Miscellania lets workers gather resources while you are "
            .. "elsewhere. You're close to the levels.",
        why = "You fund their work and maintain approval in exchange for supplies, so it is an "
            .. "ongoing investment rather than free resources.",
        how = {
            "Take the longboat from Rellekka to Miscellania and speak to King Vargas.",
        },
        requirements = {
            skills = { CRAFTING = 40, FLETCHING = 25, WOODCUTTING = 40 },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.kingdom_expansion",
        kind = "quest",
        quest = "ROYAL_TROUBLE",
        skills = { "ANY" },
        members = true,
        title = "More kingdom workers",
        icon_item_id = 995,
        hook = "Royal Trouble expands what your Miscellania workers can gather.",
        why = "The expanded workforce supports a larger resource operation, with more money needed "
            .. "to fund it.",
        how = {
            "Speak to Advisor Ghrim in Miscellania castle to continue the kingdom story.",
        },
        requirements = {
            skills = { AGILITY = 40, CRAFTING = 40, FLETCHING = 25, SLAYER = 40, WOODCUTTING = 40 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.troll_herb_patch",
        kind = "quest",
        quest = "MY_ARMS_BIG_ADVENTURE",
        skills = { "ANY" },
        members = true,
        title = "Disease-free herb patch",
        icon_item_id = 1511,
        hook = "My Arm offers a herb patch where crops cannot become diseased.",
        why = "Adding it to a herb run gives you a more dependable harvest without needing to "
            .. "watch for disease.",
        how = {
            "Speak to Burntmeat in the Troll Stronghold kitchen about My Arm's Big Adventure.",
        },
        requirements = {
            skills = { AGILITY = 15, FARMING = 29, HERBLORE = 31, THIEVING = 30, WOODCUTTING = 10 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.extra_runes",
        kind = "quest",
        quest = "HEROS_WELCOME",
        skills = { "ANY" },
        members = true,
        title = "More runes from Runecrafting",
        icon_item_id = 563,
        hook = "Hero's Welcome adds a permanent bonus to the number of runes you craft.",
        why = "The extra runes apply during normal Runecrafting without needing to keep a special "
            .. "reward equipped.",
        how = {
            "Speak to Alfrick the Planner or Freya Lune at the Rellekka docks.",
        },
        requirements = {
            skills = {
                CRAFTING = 61,
                DEFENCE = 40,
                DIVINATION = 60,
                FIREMAKING = 49,
                FLETCHING = 25,
                HERBLORE = 5,
                MAGIC = 65,
                MINING = 67,
                RUNECRAFTING = 50,
                SLAYER = 62,
                SMITHING = 67,
                WOODCUTTING = 55,
            },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.sunspear",
        kind = "quest",
        quest = "RIVER_OF_BLOOD",
        skills = { "ANY" },
        members = true,
        title = "Augmentable Sunspear",
        icon_item_id = 37264,
        hook = "The Sunspear offers one weapon that can switch between three combat styles.",
        aspiration_hook = "The Sunspear offers one weapon that can switch between three combat "
            .. "styles. You're close to the levels.",
        why = "River of Blood upgrades it into an augmentable weapon, giving it a useful place in "
            .. "Invention progression too.",
        how = {
            "Work through the Myreque story to River of Blood, which begins with King Roald in "
                .. "Varrock Palace.",
        },
        requirements = {
            skills = {
                AGILITY = 63,
                ATTACK = 78,
                CONSTRUCTION = 79,
                CRAFTING = 64,
                DEFENCE = 75,
                FARMING = 63,
                FIREMAKING = 76,
                FLETCHING = 75,
                HERBLORE = 80,
                HITPOINTS = 80,
                HUNTER = 76,
                MAGIC = 78,
                MINING = 72,
                RANGED = 78,
                RUNECRAFTING = 35,
                SLAYER = 78,
                SMITHING = 54,
                STRENGTH = 75,
                THIEVING = 22,
                WOODCUTTING = 76,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.animate_dead",
        kind = "quest",
        quest = "QUEST_SENNTISTEN",
        skills = { "ANY" },
        members = true,
        title = "Animate Dead and ancient spells",
        icon_item_id = 566,
        hook = "Animate Dead gives Magic tank armour a defensive use.",
        aspiration_hook = "Animate Dead gives Magic tank armour a defensive use. You're close to "
            .. "the levels.",
        why = "City of Senntisten expands Ancient Magicks with this spell and other combat "
            .. "options. Animate Dead needs Magic tank armour to provide its protection.",
        how = {
            "Speak to Ariane outside the Heart of Gielinor to begin City of Senntisten.",
        },
        requirements = {
            skills = {
                AGILITY = 58,
                ARCHAEOLOGY = 74,
                DIVINATION = 70,
                MAGIC = 84,
                MINING = 50,
                SLAYER = 75,
                SMITHING = 50,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.passive_vigour",
        kind = "quest",
        quest = "EGW_FINALE",
        skills = { "ANY" },
        members = true,
        title = "Passive ring of vigour",
        icon_item_id = 19669,
        hook = "Extinction can make the ring of vigour work without keeping it equipped.",
        aspiration_hook = "Extinction can make the ring of vigour work without keeping it "
            .. "equipped. You're close to the levels.",
        why = "Its adrenaline-saving effect becomes a permanent passive, freeing the ring slot for "
            .. "another choice.",
        how = {
            "After Extinction and visiting the Dream of Iaia, ask Vicendithas in the Effigy "
                .. "Incubator about the warped gem for your ring.",
        },
        requirements = {
            skills = {
                AGILITY = 65,
                ARCHAEOLOGY = 74,
                ATTACK = 62,
                CRAFTING = 85,
                DIVINATION = 70,
                DUNGEONEERING = 62,
                INVENTION = 85,
                MAGIC = 74,
                MINING = 50,
                RUNECRAFTING = 85,
                SLAYER = 75,
                SMITHING = 85,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.puzzle_box",
        kind = "quest",
        quest = "QUEST_DAUGHTER2",
        skills = { "ANY" },
        members = true,
        title = "Tool-belt Infernal Puzzle Box",
        icon_item_id = 53443,
        hook = "A fully upgraded Infernal Puzzle Box can preserve adrenaline without occupying "
            .. "backpack space.",
        aspiration_hook = "A fully upgraded Infernal Puzzle Box can preserve adrenaline without "
            .. "occupying backpack space. You're close to the levels.",
        why = "Earlier upgrades prevent adrenaline draining outside combat; Succession opens the "
            .. "final tier so the box can go on your tool belt.",
        how = {
            "Work through the Legacy of Zamorak quests and puzzle-box tasks, then speak to "
                .. "Adrasteia in Falador castle for Succession.",
        },
        requirements = {
            skills = {
                ARCHAEOLOGY = 40,
                DIVINATION = 40,
                FARMING = 50,
                MINING = 60,
                SMITHING = 60,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.ancient_incantations",
        kind = "quest",
        quest = "QUEST_NECROMANCY_WARLOCK",
        skills = { "ANY" },
        members = true,
        title = "Ancient Necromancy incantations",
        icon_item_id = 526,
        hook = "Tomes of the Warlock adds defensive and utility incantations.",
        aspiration_hook = "Tomes of the Warlock adds defensive and utility incantations. You're "
            .. "close to the levels.",
        why = "Greater Bone Shield supports defensive abilities without carrying a shield. Further "
            .. "Necromancy levels bring options such as Darkness.",
        how = {
            "Speak to Death in the City of Um, then explore the new talents at the Well of Souls "
                .. "after the quest.",
        },
        requirements = {
            skills = {
                AGILITY = 25,
                ARCHAEOLOGY = 86,
                COOKING = 20,
                MAGIC = 66,
                NECROMANCY = 75,
                PRAYER = 40,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.bone_shield",
        kind = "quest",
        quest = "QUEST_NECROMANCY_ORIGINS",
        skills = { "ANY" },
        members = true,
        title = "Bone Shield",
        icon_item_id = 526,
        hook = "Bone Shield lets you use supported defensive abilities without holding a shield.",
        aspiration_hook = "Bone Shield lets you use supported defensive abilities without holding "
            .. "a shield. You're close to the levels.",
        why = "The incantation works with any combat style, supporting defensive abilities such as "
            .. "Reflect. Each use spends Necromancy runes.",
        how = {
            "Look into Rune Mythos through Malignius Mortifer in the City of Um, then try Lesser "
                .. "Bone Shield.",
        },
        requirements = {
            skills = { DEFENCE = 37, NECROMANCY = 25 },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.elite_dungeon_defence",
        kind = "quest",
        quest = "ELITEDUNGEONS",
        skills = { "ANY" },
        members = true,
        title = "Elite Dungeon damage reduction",
        icon_item_id = 554,
        hook = "Curse of the Black Stone reduces incoming damage in the first three Elite "
            .. "Dungeons.",
        aspiration_hook = "Curse of the Black Stone reduces incoming damage in the first three "
            .. "Elite Dungeons. You're close to the levels.",
        why = "The permanent benefit applies in the Temple of Aminishi, Dragonkin Laboratory and "
            .. "Shadow Reef. Story mode can help you work through the required dungeon visits.",
        how = {
            "Speak to Bryll Thoksdottir at Daemonheim about Curse of the Black Stone.",
        },
        requirements = {
            skills = { AGILITY = 12, WOODCUTTING = 34 },
            any_skills = { ATTACK = 75, MAGIC = 75, NECROMANCY = 75, RANGED = 75 },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.zaros_shard",
        kind = "quest",
        quest = "FOTG",
        skills = { "ANY" },
        members = true,
        title = "God Wars faction protection",
        icon_item_id = 31075,
        hook = "The Shard of Zaros keeps God Wars Dungeon followers from attacking you.",
        why = "Equipping this reward covers the dungeon factions, leaving more freedom in the rest "
            .. "of your gear.",
        how = {
            "Speak to Azzanadra at the World Gate to look into Fate of the Gods.",
        },
        requirements = {
            skills = { AGILITY = 73, DIVINATION = 75, MAGIC = 79, SLAYER = 76, SUMMONING = 67 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.endgame_skilling",
        kind = "quest",
        quest = "SLISKES_ENDGAME",
        skills = { "ANY" },
        members = true,
        title = "Lasting skilling rewards",
        icon_item_id = 566,
        hook = "Sliske's Endgame brings together several reusable skilling rewards.",
        aspiration_hook = "Sliske's Endgame brings together several reusable skilling rewards. "
            .. "You're close to the levels.",
        why = "Its jewellery and Catalyst fragments offer gathering bonuses and conveniences "
            .. "across different skills, with an extra benefit from wearing the jewellery "
            .. "together.",
        how = {
            "Speak to Relomia in Draynor Village to start working towards the finale.",
        },
        requirements = {
            skills = {
                AGILITY = 80,
                ATTACK = 79,
                CONSTRUCTION = 75,
                COOKING = 35,
                CRAFTING = 80,
                DEFENCE = 72,
                DIVINATION = 80,
                DUNGEONEERING = 75,
                FARMING = 25,
                FIREMAKING = 71,
                FISHING = 36,
                FLETCHING = 70,
                HERBLORE = 80,
                HITPOINTS = 78,
                HUNTER = 65,
                MAGIC = 81,
                MINING = 75,
                PRAYER = 80,
                RANGED = 75,
                RUNECRAFTING = 50,
                SLAYER = 80,
                SMITHING = 70,
                STRENGTH = 79,
                SUMMONING = 75,
                THIEVING = 66,
                WOODCUTTING = 80,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.fort",
        kind = "quest",
        quest = "QUEST_FORT_INTRO",
        skills = { "ANY" },
        members = true,
        title = "Fort Forinthry",
        icon_item_id = 1511,
        hook = "Fort Forinthry gives you a home base with banking and facilities you can improve.",
        why = "Its buildings bring training and useful services together, with later quests "
            .. "opening further upgrades.",
        how = {
            "Use the portal outside the Varrock Palace throne room to begin New Foundations.",
        },
        requirements = {
            skills = { CONSTRUCTION = 15 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.menaphos",
        kind = "quest",
        quest = "OZAN3",
        skills = { "ANY" },
        members = true,
        title = "Menaphos",
        icon_item_id = 563,
        hook = "Menaphos brings several training options into one city hub.",
        aspiration_hook = "Menaphos brings several training options into one city hub. You're "
            .. "close to the levels.",
        why = "Fishing, woodcutting and pickpocketing can build city reputation alongside "
            .. "experience, opening more of what the city offers.",
        how = {
            "Speak to Ali Mirza in the Al Kharid palace about The Jack of Spades.",
        },
        requirements = {
            skills = {},
            any_skills = { FISHING = 52, THIEVING = 46, WOODCUTTING = 47 },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.arc",
        kind = "quest",
        quest = "ELR0",
        skills = { "ANY" },
        members = true,
        title = "The Arc",
        icon_item_id = 563,
        hook = "The Arc opens an island region with high-level skilling and its own rewards.",
        aspiration_hook = "The Arc opens an island region with high-level skilling and its own "
            .. "rewards. You're close to the levels.",
        why = "Chimes and taijitu earned through island activities can buy useful upgrades, with "
            .. "Uncharted Isles offering places to revisit.",
        how = {
            "Speak to Trader Stan in Port Sarim about the Skulls pirate Jed to begin Impressing "
                .. "the Locals.",
        },
        requirements = {
            skills = {},
            any_skills = { FARMING = 86, FISHING = 90, HUNTER = 90, MINING = 90, WOODCUTTING = 90 },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.ungael_rituals",
        kind = "quest",
        quest = "QUEST_VORKATH",
        skills = { "ANY" },
        members = true,
        title = "Ungael ritual site",
        icon_item_id = 526,
        hook = "Ungael offers a more economical alternative for Necromancy rituals.",
        aspiration_hook = "Ungael offers a more economical alternative for Necromancy rituals. "
            .. "You're close to the levels.",
        why = "Ritual components last longer and disturbances give you more time to respond, "
            .. "trading some experience speed for a more relaxed routine.",
        how = {
            "Work towards Requiem for a Dragon through Aster at Fort Forinthry, then speak to "
                .. "Ungael's Archivist while wearing Zorgoth's ring.",
        },
        requirements = {
            skills = {
                AGILITY = 25,
                ARCHAEOLOGY = 86,
                CONSTRUCTION = 54,
                COOKING = 20,
                MAGIC = 66,
                NECROMANCY = 80,
                PRAYER = 40,
                SLAYER = 10,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.menaphos_boons",
        kind = "quest",
        quest = "QUEST_DESERT_FINALE",
        skills = { "ANY" },
        members = true,
        title = "Permanent demigod boons",
        icon_item_id = 566,
        hook = "Eclipse of the Heart unlocks lasting benefits from the Menaphos demigod statues.",
        aspiration_hook = "Eclipse of the Heart unlocks lasting benefits from the Menaphos demigod "
            .. "statues. You're close to the levels.",
        why = "Their boons support combat, gathering and clue scrolls. They need to be switched on "
            .. "at the statues after the quest.",
        how = {
            "Work through the desert finale to Eclipse of the Heart, starting in the Menaphos "
                .. "throne room.",
        },
        requirements = {
            skills = {
                AGILITY = 65,
                ARCHAEOLOGY = 86,
                CONSTRUCTION = 64,
                COOKING = 70,
                CRAFTING = 68,
                FARMING = 25,
                FIREMAKING = 50,
                FISHING = 72,
                HERBLORE = 10,
                HUNTER = 73,
                MAGIC = 70,
                MINING = 37,
                NECROMANCY = 90,
                PRAYER = 40,
                RANGED = 50,
                SLAYER = 87,
                STRENGTH = 60,
                THIEVING = 70,
                WOODCUTTING = 47,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.havenhythe",
        kind = "quest",
        quest = "QUEST_WENDLE_HERALDS",
        skills = { "ANY" },
        members = true,
        title = "Exploring Havenhythe",
        icon_item_id = 563,
        hook = "Heralds of Crimson opens the rest of Havenhythe and more skilling opportunities.",
        aspiration_hook = "Heralds of Crimson opens the rest of Havenhythe and more skilling "
            .. "opportunities. You're close to the levels.",
        why = "Its areas bring new training choices and rewards alongside access to the Ghrazi "
            .. "Blood Knights encounter.",
        how = {
            "Continue the Havenhythe story through Sorrel in Amberfell.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 30,
                CRAFTING = 51,
                HERBLORE = 55,
                HUNTER = 32,
                MINING = 65,
                SLAYER = 28,
                SMITHING = 60,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.asylum_ring",
        kind = "quest",
        quest = "BROKEN_HOME",
        skills = { "ANY" },
        members = true,
        title = "Asylum surgeon's ring",
        icon_item_id = 32525,
        hook = "The Asylum surgeon's ring can save adrenaline while using abilities.",
        why = "It is a challenge reward from Broken Home replays, rather than the ring from your "
            .. "first completion. The challenges include a timed run.",
        how = {
            "Speak to Maria outside the mansion north-east of Varrock to begin Broken Home, then "
                .. "investigate its replay challenges.",
        },
        requirements = {
            skills = { DEFENCE = 85 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.lunar_utilities",
        kind = "quest",
        quest = "DREAM_MENTOR",
        skills = { "ANY" },
        members = true,
        title = "More Lunar utility spells",
        icon_item_id = 9075,
        hook = "Dream Mentor adds more ways to use Lunar magic outside combat.",
        aspiration_hook = "Dream Mentor adds more ways to use Lunar magic outside combat. You're "
            .. "close to the levels.",
        why = "Superglass Make can turn materials into glass without visiting a furnace. Higher "
            .. "Magic levels bring further options such as Spellbook Swap.",
        how = {
            "Look for the fallen man in the small cave inside the Lunar Isle Mine to begin Dream "
                .. "Mentor.",
        },
        requirements = {
            skills = {
                CRAFTING = 61,
                DEFENCE = 40,
                FIREMAKING = 49,
                FLETCHING = 25,
                HERBLORE = 5,
                MAGIC = 77,
                MINING = 60,
                WOODCUTTING = 55,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.holy_wrench",
        kind = "quest",
        quest = "RUM_DEAL",
        skills = { "ANY" },
        members = true,
        title = "Holy wrench",
        icon_item_id = 6714,
        hook = "The holy wrench helps you get more Prayer points from each dose.",
        why = "Carrying it improves the effect of potions that restore Prayer, trading a backpack "
            .. "slot for a longer-lasting supply.",
        how = {
            "Speak to Pirate Pete at the docks north of Port Phasmatys about Rum Deal.",
        },
        requirements = {
            skills = { CRAFTING = 42, FARMING = 40, FISHING = 50, PRAYER = 47, SLAYER = 42 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.tokkul_zo",
        kind = "quest",
        quest = "TZHAAR2",
        skills = { "ANY" },
        members = true,
        title = "TzHaar teleports",
        icon_item_id = 23643,
        hook = "The TokKul-Zo provides reusable teleports around the TzHaar city.",
        why = "Its destinations include useful access to banks and the city's combat activities.",
        how = {
            "Speak to TzHaar-Mej-Jeh at the TzHaar Birthing Pool to begin The Elder Kiln.",
        },
        requirements = {
            skills = { AGILITY = 60, MAGIC = 75, MINING = 40 },
        },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },

    {
        id = "quest.seren_skilling",
        kind = "quest",
        quest = "SEREN",
        skills = { "ANY" },
        members = true,
        title = "Seren skilling spells and prayers",
        icon_item_id = 566,
        hook = "The Light Within opens up new spells and prayers for skilling.",
        aspiration_hook = "The Light Within opens up new spells and prayers for skilling. You're "
            .. "close to the levels.",
        why = "Options such as Superheat Form and Chronicle Attraction can make routine training "
            .. "smoother, with more spells available at higher Magic levels.",
        how = {
            "Speak to Eluned in the Ithell district of Prifddinas to look into The Light Within.",
        },
        requirements = {
            skills = {
                AGILITY = 80,
                CONSTRUCTION = 75,
                COOKING = 35,
                CRAFTING = 80,
                DIVINATION = 80,
                DUNGEONEERING = 75,
                FARMING = 25,
                FIREMAKING = 50,
                FLETCHING = 70,
                HERBLORE = 80,
                HUNTER = 51,
                MAGIC = 79,
                MINING = 75,
                PRAYER = 80,
                RANGED = 75,
                RUNECRAFTING = 50,
                SLAYER = 80,
                SMITHING = 65,
                STRENGTH = 64,
                SUMMONING = 75,
                THIEVING = 66,
                WOODCUTTING = 80,
            },
        },
        aspiration = { max_missing_skills = 4, max_level_gap = 8, max_total_gap = 20 },
        triggers = {
            { type = "requirements_met", skill = "ANY" },
        },
        priority = 1,
    },
}
