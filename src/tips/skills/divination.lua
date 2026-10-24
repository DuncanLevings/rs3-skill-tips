-- useful items and unlocks first, then level-bracket methods and alternatives.
-- access and relevance evidence is recorded in docs/gathering-coverage.md.

return {
    -- useful items and unlocks

    {
        id = "divination.diviners_outfit",
        icon_item = "WOF55_SKILL_DIVINATION_HEAD",
        kind = "convenience",
        skills = { "DIVINATION" },
        members = true,
        title = "Diviner's outfit",
        hook = "The Diviner's outfit adds experience while gathering and converting memories.",
        why = "Each piece contributes, with an extra bonus for wearing the full set.",
        how = {
            "Complete Guthixian Caches for a chance at pieces. Depositing memories at a non-pale colony opens access to a cache.",
        },
        requirements = {
            skills = {
                DIVINATION = 35,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "DIVINATION",
            },
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
        icon_item = "TRH75_ELDER_HEAD",
        kind = "convenience",
        skills = { "DIVINATION" },
        members = true,
        title = "Divination outfits",
        hook = "Divination outfits offer gathering bonuses and convenient colony teleports.",
        why = "Energy, chronicle and memory pieces form matching sets, which combine into the elder outfit.",
        how = {
            "Collect divination fragments while training, then discover and craft the pieces through Invention.",
        },
        requirements = {
            skills = {
                DIVINATION = 80,
                INVENTION = 20,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "DIVINATION",
            },
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
        icon_item = "ELIDINIS_BOSS_SKILLING_OFFHAND_DIVINATION",
        kind = "convenience",
        skills = { "DIVINATION" },
        members = true,
        title = "Memory dowser",
        hook = "The memory dowser offers fewer interruptions at wisp colonies.",
        why = "Near an energy rift, this off-hand automatically converts gathered memories and improves gathering. It does not help in the Hall of Memories.",
        how = {
            "Earn it from the Gate of Elidinis after Ode of the Devourer, or buy one on the Grand Exchange.",
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
        min_training_level = 80,
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "DIVINATION",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "ELIDINIS_BOSS_SKILLING_OFFHAND_DIVINATION" },
            },
        },
        priority = 2,
    },

    {
        id = "divination.chronicle_attraction",
        icon_item_id = 29293,
        kind = "general",
        skills = { "DIVINATION" },
        members = true,
        title = "Chronicle Attraction",
        hook = "Chronicle Attraction offers fewer interruptions for catching fragments.",
        why = "This skilling prayer automatically catches supported fragments while active, at the cost of Prayer points.",
        how = { "After The Light Within, look for Chronicle Attraction among the Seren prayers." },
        requirements = {
            skills = {
                DIVINATION = 1,
                PRAYER = 87,
            },
            quests = { "SEREN" },
        },
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "DIVINATION",
            },
        },
        priority = 3,
    },

    {
        id = "divination.prism_of_dowsing",
        icon_item_id = 29320,
        kind = "general",
        skills = { "DIVINATION" },
        members = true,
        title = "Prism of Dowsing",
        hook = "Prism of Dowsing can make a wisp colony easier to gather from.",
        why = "The Seren spell attracts nearby wisps and can enrich them while you train.",
        how = {
            "After The Light Within, look for Prism of Dowsing on the Ancient Magicks spellbook.",
        },
        requirements = {
            skills = {
                DIVINATION = 1,
                MAGIC = 86,
            },
            quests = { "SEREN" },
        },
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "DIVINATION",
            },
        },
        priority = 3,
    },

    {
        id = "divination.rift_configuration",
        icon_item_id = 29313,
        kind = "general",
        skills = { "DIVINATION" },
        members = false,
        title = "Choose your rift reward",
        hook = "An energy rift can turn your memories into experience or more energy.",
        why = "The choice changes what you get from a trip. Enhanced experience also spends energy.",
        how = {
            "Check the rift's right-click options and choose the reward that suits your training.",
        },
        requirements = {
            skills = {
                DIVINATION = 1,
            },
        },
        triggers = {
            {
                type = "training",
                skill = "DIVINATION",
            },
        },
        priority = 3,
    },

    {
        id = "divination.empower_rifts",
        icon_item_id = 29293,
        kind = "general",
        skills = { "DIVINATION" },
        members = true,
        title = "Empower the rift",
        hook = "Chronicle fragments can improve the wisps around you.",
        why = "Use them to empower an energy rift; a fully empowered rift provides an enriched spring and a temporary gathering buff.",
        how = {
            "Catch the fragments that appear while harvesting, then check the rift's Empower option.",
        },
        requirements = {
            skills = {
                DIVINATION = 10,
            },
        },
        triggers = {
            {
                type = "training",
                skill = "DIVINATION",
            },
        },
        priority = 3,
    },

    {
        id = "divination.divine_conversion",
        icon_item_id = 49590,
        kind = "general",
        skills = { "DIVINATION" },
        members = true,
        title = "Divine Conversion",
        hook = "Divine Conversion makes each visit to an energy rift quicker.",
        why = "With the relic active, a whole backpack of memories converts in one go. It does not apply in Daemonheim.",
        how = {
            "After The World Wakes, complete Howl's Floating Workshop and work towards restoring a Cres Framework, then offer it at the monolith.",
        },
        requirements = {
            skills = {
                ARCHAEOLOGY = 98,
                DIVINATION = 85,
                INVENTION = 86,
            },
            quests = { "WORLD_WAKES" },
        },
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "DIVINATION",
            },
        },
        priority = 3,
    },

    {
        id = "divination.cape",
        icon_item = "SKILLCAPE_DIVINATION",
        kind = "convenience",
        skills = { "DIVINATION" },
        members = true,
        title = "Divination cape",
        hook = "The Divination cape helps energy springs last longer.",
        why = "Wearing it extends a spring's minimum duration, giving you more time before moving on.",
        how = {
            "Buy it from Orla Fairweather at the Divination Camp south-east of Draynor Village.",
        },
        requirements = {
            skills = {
                DIVINATION = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "DIVINATION",
            },
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

    -- training methods

    {
        id = "divination.method.flickering",
        main_method = true,
        icon_item_id = 29314,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 10, 19 },
        members = true,
        title = "Flickering wisps",
        hook = "Flickering wisps offer a source of memories and divine energy.",
        why = "Gather memories from the springs, then convert them at the nearby energy rift.",
        how = { "Find the colony east of the Falador lodestone." },
        requirements = {
            skills = {
                DIVINATION = 10,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 10,
            },
        },
        priority = 2,
    },

    {
        id = "divination.method.bright",
        main_method = true,
        icon_item_id = 29315,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 20, 29 },
        members = true,
        title = "Bright wisps",
        hook = "Bright wisps offer a source of memories and divine energy.",
        why = "Gather memories from the springs, then convert them at the nearby energy rift.",
        how = { "Find the colony east of Varrock, north-west of the Archaeology Guild." },
        requirements = {
            skills = {
                DIVINATION = 20,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 20,
            },
        },
        priority = 2,
    },

    {
        id = "divination.method.glowing",
        main_method = true,
        icon_item_id = 29316,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 30, 39 },
        members = true,
        title = "Glowing wisps",
        hook = "Glowing wisps offer a source of memories and divine energy.",
        why = "Gather memories from the springs, then convert them at the nearby energy rift.",
        how = { "Find the colony east of the Sorcerer's Tower, south of Seers' Village." },
        requirements = {
            skills = {
                DIVINATION = 30,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 30,
            },
        },
        priority = 2,
    },

    {
        id = "divination.method.sparkling",
        main_method = true,
        icon_item_id = 29317,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 40, 49 },
        members = true,
        title = "Sparkling wisps",
        hook = "Sparkling wisps offer a source of memories and divine energy.",
        why = "Gather memories from the springs, then convert them at the nearby energy rift.",
        how = { "Find the colony south-west of the Fremennik Slayer Dungeon." },
        requirements = {
            skills = {
                DIVINATION = 40,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 40,
            },
        },
        priority = 2,
    },

    {
        id = "divination.method.gleaming",
        main_method = true,
        icon_item_id = 29318,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 50, 59 },
        members = true,
        title = "Gleaming wisps",
        hook = "Gleaming wisps offer a source of memories and divine energy.",
        why = "Gather memories from the springs, then convert them at the nearby energy rift.",
        how = { "Find the colony in Karamja's jungle, north-east of Shilo Village." },
        requirements = {
            skills = {
                DIVINATION = 50,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 50,
            },
        },
        priority = 2,
    },

    {
        id = "divination.method.vibrant",
        main_method = true,
        icon_item_id = 29319,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 60, 64 },
        members = true,
        title = "Vibrant wisps",
        hook = "Vibrant wisps offer a source of memories and divine energy.",
        why = "Gather memories from the springs, then convert them at the nearby energy rift.",
        how = { "Find the colony west of the Oo'glog lodestone." },
        requirements = {
            skills = {
                DIVINATION = 60,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 60,
            },
        },
        priority = 2,
    },

    {
        id = "divination.method.empty_throne_room",
        main_method = true,
        icon_item_id = 39017,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 65, 69 },
        members = true,
        title = "The Empty Throne Room",
        hook = "The Empty Throne Room offers a change from gathering at wisp colonies.",
        why = "Gather and transmute its crystals for experience while working towards the Hall of Memories.",
        how = {
            "Enter the excavation south-east of the Varrock Dig Site and try the Divination activity.",
        },
        requirements = {
            skills = {
                DIVINATION = 65,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 65,
            },
        },
        priority = 2,
    },

    {
        id = "divination.method.hall_of_memories",
        main_method = true,
        icon_item_id = 29320,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 70, 120 },
        members = true,
        title = "Hall of Memories",
        hook = "The Hall of Memories offers experience-focused training instead of energy to sell.",
        why = "Collect memories in jars and offer full jars for experience instead of gathering energy to sell.",
        how = {
            "Enter the pool at the Memorial to Guthix and speak to the Archivist to get started.",
        },
        requirements = {
            skills = {
                DIVINATION = 70,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 70,
            },
        },
        priority = 2,
    },

    -- alternative methods

    {
        id = "divination.alt.guthixian_cache",
        icon_item_id = 29313,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 35, 120 },
        members = true,
        title = "Guthixian Cache",
        hook = "Guthixian Caches offer a change from gathering memories at colonies.",
        why = "The activity rewards Divination experience and a chance at Diviner's outfit pieces.",
        how = {
            "Deposit memories at a non-pale colony to open its cache, then check the rift's entry option.",
        },
        requirements = {
            skills = {
                DIVINATION = 35,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 35,
            },
        },
        priority = 3,
    },

    -- engrams have no level-70 use requirement; this is a relevance gate after strands accumulate.
    {
        id = "divination.alt.charging_engrams",
        icon_item_id = 29293,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 70, 120 },
        members = true,
        title = "Charging engrams",
        hook = "Charging engrams offers experience and passive benefits to work towards.",
        why = "Use accumulated memory strands and divine energy to restore Guthix's memories and unlock passive benefits. The energy can be gathered or bought.",
        how = {
            "Visit Orla Fairweather at the Memorial to Guthix and ask about collecting engrams.",
        },
        requirements = {
            skills = {
                DIVINATION = 1,
            },
        },
        min_training_level = 70,
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 70,
            },
        },
        priority = 3,
    },

    {
        id = "divination.alt.lustrous",
        icon_item_id = 29320,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 70, 120 },
        members = true,
        title = "Lustrous wisps",
        hook = "Lustrous wisps offer divine energy alongside Divination experience.",
        why = "Choose regular wisps when you want divine energy as well as experience.",
        how = { "Look for the colony east of the Slayer Tower." },
        requirements = {
            skills = {
                DIVINATION = 70,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 70,
            },
        },
        priority = 3,
    },

    {
        id = "divination.alt.colossi",
        icon_item_id = 63916,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 77, 120 },
        members = true,
        title = "Colossi Divination",
        hook = "Colossi Divination offers a route through Havenhythe with large memory deliveries.",
        why = "Charge a memory stone at Divine Fall, then discharge it at a colossus mural for experience and remnant energy.",
        how = {
            "Progress Heralds of Crimson to gain access to Divine Fall, then try charging a memory stone.",
        },
        requirements = {
            skills = {
                DIVINATION = 77,
            },
            quests = { "QUEST_WENDLE_HERALDS" },
        },
        require_quests_complete = true,
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 77,
            },
        },
        priority = 3,
    },

    {
        id = "divination.alt.brilliant",
        icon_item_id = 29321,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 80, 120 },
        members = true,
        title = "Brilliant wisps",
        hook = "Brilliant wisps offer divine energy alongside Divination experience.",
        why = "Choose regular wisps when you want divine energy as well as experience.",
        how = { "Look for the colony east of the Mage Training Arena." },
        requirements = {
            skills = {
                DIVINATION = 80,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 80,
            },
        },
        priority = 3,
    },

    {
        id = "divination.alt.radiant",
        icon_item_id = 29322,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 85, 120 },
        members = true,
        title = "Radiant wisps",
        hook = "Radiant wisps offer divine energy alongside Divination experience.",
        why = "Choose regular wisps when you want divine energy as well as experience.",
        how = {
            "Reach Dragontooth Island by speaking to the Ghost captain at Port Phasmatys. The boat is free; bring a ghostspeak amulet unless you have another way to understand ghosts.",
        },
        requirements = {
            skills = {
                DIVINATION = 85,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 85,
            },
        },
        priority = 3,
    },

    {
        id = "divination.alt.luminous",
        icon_item_id = 29323,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 90, 120 },
        members = true,
        title = "Luminous wisps",
        hook = "Luminous wisps offer divine energy alongside Divination experience.",
        why = "Choose regular wisps when you want divine energy as well as experience.",
        how = { "Look for the colony south of Sophanem." },
        requirements = {
            skills = {
                DIVINATION = 90,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 90,
            },
        },
        priority = 3,
    },

    {
        id = "divination.alt.incandescent",
        icon_item_id = 29324,
        kind = "method",
        skills = { "DIVINATION" },
        level_range = { 95, 120 },
        members = true,
        title = "Incandescent wisps",
        hook = "Incandescent wisps offer divine energy alongside Divination experience.",
        why = "Choose regular wisps when you want divine energy as well as experience.",
        how = { "Look for the colony south of the Poison Waste, west of Castle Wars." },
        requirements = {
            skills = {
                DIVINATION = 95,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "DIVINATION",
                level = 95,
            },
        },
        priority = 3,
    },
}
