-- divination tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field

return {
    -- useful items and unlocks
    {
        id = "divination.diviners_outfit",
        kind = "convenience",
        skills = { "DIVINATION" },
        members = true,
        title = "Diviner's outfit",
        icon_item = "WOF55_SKILL_DIVINATION_HEAD",
        hook = "The Diviner's outfit adds experience while gathering and converting memories.",
        why = "Each piece contributes, with an extra bonus for wearing the full set.",
        how = {
            "Complete Guthixian Caches for a chance at pieces. Depositing memories at a non-pale "
                .. "colony opens access to a cache.",
        },
        requirements = {
            skills = { DIVINATION = 35 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "DIVINATION" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH28_DIVINATION_HEAD_UPGRADED",
                    "WOF55_SKILL_DIVINATION_FEET",
                    "WOF55_SKILL_DIVINATION_HANDS",
                    "WOF55_SKILL_DIVINATION_HEAD",
                    "WOF55_SKILL_DIVINATION_LEGS",
                    "WOF55_SKILL_DIVINATION_TORSO",
                },
            },
        },
        priority = 2,
    },

    {
        id = "divination.divination_outfits",
        kind = "convenience",
        skills = { "DIVINATION" },
        members = true,
        title = "Divination outfits",
        icon_item = "TRH75_ELDER_HEAD",
        hook = "Divination outfits offer gathering bonuses and convenient colony teleports.",
        why = "Energy, chronicle and memory pieces form matching sets, which combine into the "
            .. "elder outfit.",
        how = {
            "Collect divination fragments while training, then discover and craft the pieces "
                .. "through Invention.",
        },
        requirements = {
            skills = { DIVINATION = 80, INVENTION = 20 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "DIVINATION" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH75_CHRONICLE_BODY",
                    "TRH75_CHRONICLE_FEET",
                    "TRH75_CHRONICLE_HANDS",
                    "TRH75_CHRONICLE_HEAD",
                    "TRH75_CHRONICLE_LEGS",
                    "TRH75_ELDER_BODY",
                    "TRH75_ELDER_FEET",
                    "TRH75_ELDER_HANDS",
                    "TRH75_ELDER_HEAD",
                    "TRH75_ELDER_LEGS",
                    "TRH75_ENERGY_BODY",
                    "TRH75_ENERGY_FEET",
                    "TRH75_ENERGY_HANDS",
                    "TRH75_ENERGY_HEAD",
                    "TRH75_ENERGY_LEGS",
                    "TRH75_MEMORY_BODY",
                    "TRH75_MEMORY_FEET",
                    "TRH75_MEMORY_HANDS",
                    "TRH75_MEMORY_HEAD",
                    "TRH75_MEMORY_LEGS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "divination.memory_dowser",
        kind = "convenience",
        skills = { "DIVINATION" },
        members = true,
        min_training_level = 80,
        title = "Memory dowser",
        icon_item = "ELIDINIS_BOSS_SKILLING_OFFHAND_DIVINATION",
        hook = "The memory dowser offers fewer interruptions at wisp colonies.",
        why = "Near an energy rift, this off-hand automatically converts gathered memories and "
            .. "improves gathering. It does not help in the Hall of Memories.",
        how = {
            "Earn it from the Gate of Elidinis after Ode of the Devourer, or buy one on the Grand "
                .. "Exchange.",
        },
        quest_how = {
            "Work towards Ode of the Devourer to reach the Gate of Elidinis and its rewards.",
        },
        requirements = {
            skills = {
                AGILITY = 25,
                ARCHAEOLOGY = 86,
                CONSTRUCTION = 54,
                COOKING = 20,
                DIVINATION = 80,
                MAGIC = 66,
                NECROMANCY = 75,
                PRAYER = 40,
                SLAYER = 10,
            },
            quests = { "QUEST_AMASCUT" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "DIVINATION" },
        },
        known_when = {
            { type = "owns_any", items = { "ELIDINIS_BOSS_SKILLING_OFFHAND_DIVINATION" } },
        },
        priority = 2,
    },

    {
        id = "divination.chronicle_attraction",
        kind = "general",
        skills = { "DIVINATION" },
        members = true,
        title = "Chronicle Attraction",
        icon_item_id = 29293,
        hook = "Chronicle Attraction offers fewer interruptions for catching fragments.",
        why = "This skilling prayer automatically catches supported fragments while active, at the "
            .. "cost of Prayer points.",
        how = {
            "After The Light Within, look for Chronicle Attraction among the Seren prayers.",
        },
        quest_how = {
            "Look into The Light Within for access to its Seren spells and prayers.",
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
                PRAYER = 87,
                RANGED = 75,
                RUNECRAFTING = 50,
                SLAYER = 80,
                SMITHING = 65,
                STRENGTH = 64,
                SUMMONING = 75,
                THIEVING = 66,
                WOODCUTTING = 80,
            },
            quests = { "SEREN" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "DIVINATION" },
        },
        priority = 3,
    },

    {
        id = "divination.prism_of_dowsing",
        kind = "general",
        skills = { "DIVINATION" },
        members = true,
        title = "Prism of Dowsing",
        icon_item_id = 29320,
        hook = "Prism of Dowsing can make a wisp colony easier to gather from.",
        why = "The Seren spell attracts nearby wisps and can enrich them while you train.",
        how = {
            "After The Light Within, look for Prism of Dowsing on the Ancient Magicks spellbook.",
        },
        quest_how = {
            "Look into The Light Within for access to its Seren spells and prayers.",
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
                MAGIC = 86,
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
            quests = { "SEREN" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "DIVINATION" },
        },
        priority = 3,
    },

    {
        id = "divination.rift_configuration",
        kind = "general",
        skills = { "DIVINATION" },
        members = false,
        title = "Choose your rift reward",
        icon_item_id = 29313,
        hook = "An energy rift can turn your memories into experience or more energy.",
        why = "The choice changes what you get from a trip. Enhanced experience also spends "
            .. "energy.",
        how = {
            "Check the rift's right-click options and choose the reward that suits your training.",
        },
        requirements = {
            skills = { DIVINATION = 1 },
        },
        triggers = {
            { type = "training", skill = "DIVINATION" },
        },
        priority = 3,
    },

    {
        id = "divination.empower_rifts",
        kind = "general",
        skills = { "DIVINATION" },
        members = true,
        title = "Empower the rift",
        icon_item_id = 29293,
        hook = "Chronicle fragments can improve the wisps around you.",
        why = "Use them to empower an energy rift; a fully empowered rift provides an enriched "
            .. "spring and a temporary gathering buff.",
        how = {
            "Catch the fragments that appear while harvesting, then check the rift's Empower "
                .. "option.",
        },
        requirements = {
            skills = { DIVINATION = 10 },
        },
        triggers = {
            { type = "training", skill = "DIVINATION" },
        },
        priority = 3,
    },

    {
        id = "divination.divine_conversion",
        kind = "general",
        skills = { "DIVINATION" },
        members = true,
        title = "Divine Conversion",
        icon_item_id = 49590,
        hook = "Divine Conversion makes each visit to an energy rift quicker.",
        why = "With the relic active, a whole backpack of memories converts in one go. It does not "
            .. "apply in Daemonheim.",
        how = {
            "After The World Wakes, complete Howl's Floating Workshop and work towards restoring a "
                .. "Cres Framework, then offer it at the monolith.",
        },
        quest_how = {
            "Complete The World Wakes, then work towards Howl's Floating Workshop and a restored "
                .. "Cres Framework.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 98, DIVINATION = 85, INVENTION = 86 },
            quests = { "WORLD_WAKES" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "DIVINATION" },
        },
        priority = 3,
    },

    {
        id = "divination.cape",
        kind = "convenience",
        skills = { "DIVINATION" },
        members = true,
        title = "Divination cape",
        icon_item = "SKILLCAPE_DIVINATION",
        hook = "The Divination cape helps energy springs last longer.",
        why = "Wearing it extends a spring's minimum duration, giving you more time before moving "
            .. "on.",
        how = {
            "Buy it from Orla Fairweather at the Divination Camp south-east of Draynor Village.",
        },
        requirements = {
            skills = { DIVINATION = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "DIVINATION" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_DIVINATION",
                    "SKILLCAPE_DIVINATION_HOODED",
                    "SKILLCAPE_DIVINATION_HOODED_RETRO",
                    "SKILLCAPE_DIVINATION_RETRO",
                    "SKILLCAPE_DIVINATION_TRIMMED",
                    "SKILLCAPE_DIVINATION_TRIMMED_HOODED",
                    "SKILLCAPE_DIVINATION_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_DIVINATION_TRIMMED_RETRO",
                },
            },
        },
        priority = 2,
    },

    -- training methods, one main method per level bracket
    {
        id = "divination.method.flickering",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 10, 19 },
        main_method = true,
        title = "Flickering wisps",
        icon_item_id = 29314,
        hook = "Flickering wisps offer a source of memories and divine energy.",
        why = "Gather memories from the springs, then convert them at the nearby energy rift.",
        how = {
            "Find the colony east of the Falador lodestone.",
        },
        requirements = {
            skills = { DIVINATION = 10 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 10 },
        },
        priority = 2,
    },

    {
        id = "divination.method.bright",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 20, 29 },
        main_method = true,
        title = "Bright wisps",
        icon_item_id = 29315,
        hook = "Bright wisps offer a source of memories and divine energy.",
        why = "Gather memories from the springs, then convert them at the nearby energy rift.",
        how = {
            "Find the colony east of Varrock, north-west of the Archaeology Guild.",
        },
        requirements = {
            skills = { DIVINATION = 20 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 20 },
        },
        priority = 2,
    },

    {
        id = "divination.method.glowing",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 30, 39 },
        main_method = true,
        title = "Glowing wisps",
        icon_item_id = 29316,
        hook = "Glowing wisps offer a source of memories and divine energy.",
        why = "Gather memories from the springs, then convert them at the nearby energy rift.",
        how = {
            "Find the colony east of the Sorcerer's Tower, south of Seers' Village.",
        },
        requirements = {
            skills = { DIVINATION = 30 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 30 },
        },
        priority = 2,
    },

    {
        id = "divination.method.sparkling",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 40, 49 },
        main_method = true,
        title = "Sparkling wisps",
        icon_item_id = 29317,
        hook = "Sparkling wisps offer a source of memories and divine energy.",
        why = "Gather memories from the springs, then convert them at the nearby energy rift.",
        how = {
            "Find the colony south-west of the Fremennik Slayer Dungeon.",
        },
        requirements = {
            skills = { DIVINATION = 40 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 40 },
        },
        priority = 2,
    },

    {
        id = "divination.method.gleaming",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 50, 59 },
        main_method = true,
        title = "Gleaming wisps",
        icon_item_id = 29318,
        hook = "Gleaming wisps offer a source of memories and divine energy.",
        why = "Gather memories from the springs, then convert them at the nearby energy rift.",
        how = {
            "Find the colony in Karamja's jungle, north-east of Shilo Village.",
        },
        requirements = {
            skills = { DIVINATION = 50 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 50 },
        },
        priority = 2,
    },

    {
        id = "divination.method.vibrant",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 60, 64 },
        main_method = true,
        title = "Vibrant wisps",
        icon_item_id = 29319,
        hook = "Vibrant wisps offer a source of memories and divine energy.",
        why = "Gather memories from the springs, then convert them at the nearby energy rift.",
        how = {
            "Find the colony west of the Oo'glog lodestone.",
        },
        requirements = {
            skills = { DIVINATION = 60 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 60 },
        },
        priority = 2,
    },

    {
        id = "divination.method.empty_throne_room",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 65, 69 },
        main_method = true,
        title = "The Empty Throne Room",
        icon_item_id = 39017,
        hook = "The Empty Throne Room offers a change from gathering at wisp colonies.",
        why = "Gather and transmute its crystals for experience while working towards the Hall of "
            .. "Memories.",
        how = {
            "Enter the excavation south-east of the Varrock Dig Site and try the Divination "
                .. "activity.",
        },
        requirements = {
            skills = { DIVINATION = 65 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 65 },
        },
        priority = 2,
    },

    {
        id = "divination.method.hall_of_memories",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 70, 99 },
        main_method = true,
        title = "Hall of Memories",
        icon_item_id = 29320,
        hook = "The Hall of Memories offers experience-focused training instead of energy to sell.",
        why = "Collect memories in jars and offer full jars for experience instead of gathering "
            .. "energy to sell.",
        how = {
            "Enter the pool at the Memorial to Guthix and speak to the Archivist to get started.",
        },
        requirements = {
            skills = { DIVINATION = 70 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 70 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "divination.alt.guthixian_cache",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 35, 120 },
        title = "Guthixian Cache",
        icon_item_id = 29313,
        hook = "Guthixian Caches offer a change from gathering memories at colonies.",
        why = "The activity rewards Divination experience and a chance at Diviner's outfit pieces.",
        how = {
            "Deposit memories at a non-pale colony to open its cache, then check the rift's entry "
                .. "option.",
        },
        requirements = {
            skills = { DIVINATION = 35 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 35 },
        },
        priority = 3,
    },

    -- engrams dont need level 70 to use, 70 is just where enough strands have built up to bother
    {
        id = "divination.alt.charging_engrams",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 70, 120 },
        min_training_level = 70,
        title = "Charging engrams",
        icon_item_id = 29293,
        hook = "Charging engrams offers experience and passive benefits to work towards.",
        why = "Use accumulated memory strands and divine energy to restore Guthix's memories and "
            .. "unlock passive benefits. The energy can be gathered or bought.",
        how = {
            "Visit Orla Fairweather at the Memorial to Guthix and ask about collecting engrams.",
        },
        requirements = {
            skills = { DIVINATION = 1 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 70 },
        },
        priority = 3,
    },

    {
        id = "divination.alt.lustrous",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 70, 79 },
        title = "Lustrous wisps",
        icon_item_id = 29320,
        hook = "Lustrous wisps offer divine energy alongside Divination experience.",
        why = "Choose regular wisps when you want divine energy as well as experience.",
        how = {
            "Look for the colony east of the Slayer Tower.",
        },
        requirements = {
            skills = { DIVINATION = 70 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 70 },
        },
        priority = 3,
    },

    {
        id = "divination.alt.colossi",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 77, 120 },
        title = "Colossi Divination",
        icon_item_id = 63916,
        hook = "Colossi Divination offers a route through Havenhythe with large memory deliveries.",
        why = "Charge a memory stone at Divine Fall, then discharge it at a colossus mural for "
            .. "experience and remnant energy.",
        how = {
            "Progress Heralds of Crimson to gain access to Divine Fall, then try charging a memory "
                .. "stone.",
        },
        quest_how = {
            "Look into Heralds of Crimson to start exploring Havenhythe.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 30,
                CRAFTING = 51,
                DIVINATION = 77,
                HERBLORE = 55,
                HUNTER = 32,
                MINING = 65,
                SLAYER = 28,
                SMITHING = 60,
            },
            quests = { "QUEST_WENDLE_HERALDS" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 77 },
        },
        priority = 3,
    },

    {
        id = "divination.alt.brilliant",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 80, 84 },
        title = "Brilliant wisps",
        icon_item_id = 29321,
        hook = "Brilliant wisps offer divine energy alongside Divination experience.",
        why = "Choose regular wisps when you want divine energy as well as experience.",
        how = {
            "Look for the colony east of the Mage Training Arena.",
        },
        requirements = {
            skills = { DIVINATION = 80 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 80 },
        },
        priority = 3,
    },

    {
        id = "divination.alt.radiant",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 85, 89 },
        title = "Radiant wisps",
        icon_item_id = 29322,
        hook = "Radiant wisps offer divine energy alongside Divination experience.",
        why = "Choose regular wisps when you want divine energy as well as experience.",
        how = {
            "Reach Dragontooth Island by speaking to the Ghost captain at Port Phasmatys. The boat "
                .. "is free; bring a ghostspeak amulet unless you have another way to understand "
                .. "ghosts.",
        },
        requirements = {
            skills = { DIVINATION = 85 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 85 },
        },
        priority = 3,
    },

    {
        id = "divination.alt.luminous",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 90, 94 },
        title = "Luminous wisps",
        icon_item_id = 29323,
        hook = "Luminous wisps offer divine energy alongside Divination experience.",
        why = "Choose regular wisps when you want divine energy as well as experience.",
        how = {
            "Look for the colony south of Sophanem.",
        },
        requirements = {
            skills = { DIVINATION = 90 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 90 },
        },
        priority = 3,
    },

    {
        id = "divination.alt.incandescent",
        kind = "method",
        skills = { "DIVINATION" },
        members = true,
        level_range = { 95, 120 },
        title = "Incandescent wisps",
        icon_item_id = 29324,
        hook = "Incandescent wisps offer divine energy alongside Divination experience.",
        why = "Choose regular wisps when you want divine energy as well as experience.",
        how = {
            "Look for the colony south of the Poison Waste, west of Castle Wars.",
        },
        requirements = {
            skills = { DIVINATION = 95 },
        },
        triggers = {
            { type = "level_reached", skill = "DIVINATION", level = 95 },
        },
        priority = 3,
    },
}
