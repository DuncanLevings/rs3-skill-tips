-- farming tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field

return {
    -- useful items and unlocks
    {
        id = "farming.farmers_outfit",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        min_training_level = 20,
        title = "Farmer's outfit",
        icon_item = "TRH13_FARMER_HAT",
        hook = "The Farmer's outfit adds experience to your Farming activities.",
        why = "Each piece contributes, with an extra bonus for wearing the full set.",
        how = {
            "Sydekix's Shop of Balance sells the pieces for Crux Eqal favour earned from herb "
                .. "farming.",
        },
        requirements = {
            skills = { FARMING = 1 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FARMING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH13_FARMER_BOOTS",
                    "TRH13_FARMER_HAT",
                    "TRH13_FARMER_LEGS",
                    "TRH13_FARMER_TORSO",
                    "TRH58_FARMING_HEAD_UPGRADED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "farming.master_outfit",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Master farmer outfit",
        icon_item = "POF_REWARDS_TRH_MASTER_HEAD",
        hook = "The master farmer outfit offers bonuses for crops, animals and farm travel.",
        why = "Combine the animal, crop and tree sets for the full outfit's benefits. It can also "
            .. "use the Farmer's outfit experience bonus if you own that set.",
        how = {
            "Buy the blueprint from Granny Potterington with beans, then craft pieces from master "
                .. "farmer fragments through Invention.",
        },
        requirements = {
            skills = { FARMING = 80, INVENTION = 20 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FARMING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "POF_REWARDS_TRH_ANIMALS_BODY",
                    "POF_REWARDS_TRH_ANIMALS_FEET",
                    "POF_REWARDS_TRH_ANIMALS_HANDS",
                    "POF_REWARDS_TRH_ANIMALS_HEAD",
                    "POF_REWARDS_TRH_ANIMALS_LEGS",
                    "POF_REWARDS_TRH_CROPS_BODY",
                    "POF_REWARDS_TRH_CROPS_FEET",
                    "POF_REWARDS_TRH_CROPS_HANDS",
                    "POF_REWARDS_TRH_CROPS_HEAD",
                    "POF_REWARDS_TRH_CROPS_LEGS",
                    "POF_REWARDS_TRH_MASTER_BODY",
                    "POF_REWARDS_TRH_MASTER_FEET",
                    "POF_REWARDS_TRH_MASTER_HANDS",
                    "POF_REWARDS_TRH_MASTER_HEAD",
                    "POF_REWARDS_TRH_MASTER_LEGS",
                    "POF_REWARDS_TRH_TREES_BODY",
                    "POF_REWARDS_TRH_TREES_FEET",
                    "POF_REWARDS_TRH_TREES_HANDS",
                    "POF_REWARDS_TRH_TREES_HEAD",
                    "POF_REWARDS_TRH_TREES_LEGS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "farming.amulet_of_nature",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Amulet of nature",
        icon_item = "NATURE_AMULET",
        hook = "An amulet of nature offers a way to check a patch away from your farm run.",
        why = "Bind it to a supported patch to check its progress and return to it conveniently.",
        how = {
            "Craft and enchant an emerald amulet strung with magic string, then use it on a patch.",
        },
        requirements = {
            skills = { CRAFTING = 31, FARMING = 1, MAGIC = 27 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FARMING" },
        },
        known_when = {
            { type = "owns_any", items = { "NATURE_AMULET" } },
        },
        priority = 2,
    },

    {
        id = "farming.magic_secateurs",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Magic secateurs",
        icon_item = "FAIRY_ENCHANTED_SECATEURS",
        hook = "Magic secateurs help you get more produce from supported crops.",
        why = "Their harvesting effect works while carried, worn or stored on your tool belt.",
        how = {
            "They're a reward from A Fairy Tale I - Growing Pains. Try them on an herb or "
                .. "allotment run.",
        },
        quest_how = {
            "Look into A Fairy Tale I - Growing Pains for the magic secateurs reward.",
        },
        requirements = {
            skills = { CRAFTING = 31, FARMING = 1, WOODCUTTING = 36 },
            quests = { "FAIRY_TALE_I" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FARMING" },
        },
        known_when = {
            { type = "owns_any", items = { "FAIRY_ENCHANTED_SECATEURS" } },
            { type = "quest_done", quest = "FAIRY_TALE_I" },
        },
        priority = 2,
    },

    {
        id = "farming.magic_watering_can",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Magic watering can",
        icon_item = "FT3_WATERING_CAN",
        hook = "The magic watering can saves refills while tending crops.",
        why = "Its unlimited water also works when stored with a tool leprechaun.",
        how = {
            "Claim it after A Fairy Tale III - Battle at Ork's Rift, then replace your regular "
                .. "watering can.",
        },
        quest_how = {
            "Work towards A Fairy Tale III - Battle at Ork's Rift and its farming unlocks.",
        },
        requirements = {
            skills = {
                CRAFTING = 36,
                FARMING = 54,
                HERBLORE = 57,
                THIEVING = 51,
                WOODCUTTING = 36,
            },
            quests = { "FAIRY_TALE_III" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FARMING" },
        },
        known_when = {
            { type = "owns_any", items = { "FT3_WATERING_CAN" } },
            { type = "quest_done", quest = "FAIRY_TALE_III" },
        },
        priority = 2,
    },

    {
        id = "farming.catalyst_fragment",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        min_training_level = 50,
        title = "Farmer's Catalyst fragment",
        icon_item = "QUEST_ENDGAME_SHARD_FARMING",
        hook = "The Farmer's Catalyst fragment offers free cures for diseased herb patches.",
        why = "Equip it while curing a supported herb patch to recover the plant and receive "
            .. "shadow-infused herbs.",
        how = {
            "It's a reward from Sliske's Endgame and can be combined with the other Catalyst "
                .. "fragments.",
        },
        quest_how = {
            "Look into Sliske's Endgame and its lasting skilling rewards.",
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
            quests = { "SLISKES_ENDGAME" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FARMING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "QUEST_ENDGAME_SHARD_FARMING", "QUEST_ENDGAME_SHARD_COMBINED" },
            },
            { type = "quest_done", quest = "SLISKES_ENDGAME" },
        },
        priority = 2,
    },

    {
        id = "farming.leprechaun_notes",
        kind = "general",
        skills = { "FARMING" },
        members = true,
        title = "Leprechaun noting",
        icon_item_id = 1942,
        hook = "A tool leprechaun can save you a bank trip during a harvest.",
        why = "Leprechauns turn supported harvested produce into banknotes and can store your "
            .. "farming tools.",
        how = {
            "Use your produce on a nearby tool leprechaun to try noting it.",
        },
        requirements = {
            skills = { FARMING = 1 },
        },
        triggers = {
            { type = "training", skill = "FARMING" },
        },
        priority = 3,
    },

    {
        id = "farming.rapid_growth",
        kind = "general",
        skills = { "FARMING" },
        members = true,
        title = "Rapid Growth",
        icon_item_id = 52811,
        hook = "Rapid Growth can shorten the wait for supported crops.",
        why = "The Seren spell advances a crop by a growth stage, with limits on how often it can "
            .. "affect each patch.",
        how = {
            "After The Light Within, look for Rapid Growth on the Ancient Magicks spellbook.",
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
                MAGIC = 88,
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
            { type = "training", skill = "FARMING" },
        },
        priority = 3,
    },

    {
        id = "farming.gardeners",
        kind = "general",
        skills = { "FARMING" },
        members = true,
        title = "Pay the gardener",
        icon_item_id = 1955,
        hook = "A nearby gardener can watch over many of your planted crops.",
        why = "Paying for protection prevents disease for that crop, so you can return for its "
            .. "health check without tending it.",
        how = {
            "Check the gardener's payment option before leaving a newly planted tree. Noted "
                .. "payments save backpack space.",
        },
        requirements = {
            skills = { FARMING = 15 },
        },
        triggers = {
            { type = "training", skill = "FARMING" },
        },
        priority = 3,
    },

    {
        id = "farming.scroll_of_life",
        kind = "general",
        skills = { "FARMING" },
        members = true,
        title = "Scroll of life",
        icon_item_id = 18336,
        hook = "The Scroll of life offers a lasting chance to recover seeds during Farming.",
        why = "Reading it unlocks a permanent benefit rather than an item you need to carry on "
            .. "each run.",
        how = {
            "Look for the scroll in the Daemonheim Rewards shop and earn the tokens through "
                .. "Dungeoneering.",
        },
        requirements = {
            skills = { DUNGEONEERING = 25, FARMING = 25 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FARMING" },
        },
        priority = 3,
    },

    {
        id = "farming.pharm_ecology",
        kind = "general",
        skills = { "FARMING" },
        members = true,
        title = "Pharm Ecology",
        icon_item_id = 49598,
        hook = "Pharm Ecology offers disease protection for herb and mushroom patches.",
        why = "While the relic is active, these patches stay healthy without relying on disease "
            .. "checks going your way.",
        how = {
            "After A Fairy Tale III, work towards Queen Mab's Moonstone through the Armadylean I "
                .. "collection and offer it at the monolith.",
        },
        quest_how = {
            "Work towards A Fairy Tale III - Battle at Ork's Rift and its farming unlocks.",
        },
        requirements = {
            skills = {
                ARCHAEOLOGY = 81,
                CRAFTING = 36,
                FARMING = 59,
                HERBLORE = 57,
                THIEVING = 51,
                WOODCUTTING = 36,
            },
            quests = { "FAIRY_TALE_III" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FARMING" },
        },
        priority = 3,
    },

    {
        id = "farming.cape",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Farming cape",
        icon_item = "SKILLCAPE_FARMING",
        hook = "The Farming cape can make harvesting quicker and easier on backpack space.",
        why = "Its perk can harvest the rest of a crop at once and notes the produce it collects.",
        how = {
            "Buy it from Martin the Master Gardener in Draynor Village.",
        },
        requirements = {
            skills = { FARMING = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FARMING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_120_FARMING",
                    "SKILLCAPE_FARMING",
                    "SKILLCAPE_FARMING_HOODED",
                    "SKILLCAPE_FARMING_HOODED_RETRO",
                    "SKILLCAPE_FARMING_RETRO",
                    "SKILLCAPE_FARMING_TRIMMED",
                    "SKILLCAPE_FARMING_TRIMMED_HOODED",
                    "SKILLCAPE_FARMING_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_FARMING_TRIMMED_RETRO",
                },
            },
        },
        priority = 2,
    },

    {
        id = "farming.master_cape",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Farming master cape",
        icon_item = "SKILLCAPE_120_FARMING",
        hook = "The Farming master cape offers free supercompost and help with your animals.",
        why = "It automatically supercomposts supported patches and has a daily boost for farm "
            .. "animals, alongside the regular cape's harvesting perk.",
        how = {
            "Buy it from Martin the Master Gardener after reaching 120 Farming.",
        },
        requirements = {
            skills = { FARMING = 120 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "FARMING" },
        },
        known_when = {
            { type = "owns_any", items = { "SKILLCAPE_120_FARMING" } },
        },
        priority = 2,
    },

    -- training methods, one main method per level bracket
    {
        id = "farming.method.oak",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 15, 29 },
        main_method = true,
        title = "Oak tree runs",
        icon_item_id = 5370,
        hook = "Oak tree runs offer Farming experience between other activities.",
        why = "Plant saplings in tree patches, then return once they have grown to check their "
            .. "health. Higher-tier saplings can cost more.",
        how = {
            "Use tree patches such as Lumbridge, Varrock and Falador. Nearby gardeners can protect "
                .. "the trees for a payment.",
        },
        requirements = {
            skills = { FARMING = 15 },
        },
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 15 },
        },
        priority = 2,
    },

    {
        id = "farming.method.willow",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 30, 44 },
        main_method = true,
        title = "Willow tree runs",
        icon_item_id = 5371,
        hook = "Willow tree runs offer Farming experience between other activities.",
        why = "Plant saplings in tree patches, then return once they have grown to check their "
            .. "health. Higher-tier saplings can cost more.",
        how = {
            "Use tree patches such as Lumbridge, Varrock and Falador. Nearby gardeners can protect "
                .. "the trees for a payment.",
        },
        requirements = {
            skills = { FARMING = 30 },
        },
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 30 },
        },
        priority = 2,
    },

    {
        id = "farming.method.maple",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 45, 59 },
        main_method = true,
        title = "Maple tree runs",
        icon_item_id = 5372,
        hook = "Maple tree runs offer Farming experience between other activities.",
        why = "Plant saplings in tree patches, then return once they have grown to check their "
            .. "health. Higher-tier saplings can cost more.",
        how = {
            "Use tree patches such as Lumbridge, Varrock and Falador. Nearby gardeners can protect "
                .. "the trees for a payment.",
        },
        requirements = {
            skills = { FARMING = 45 },
        },
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 45 },
        },
        priority = 2,
    },

    {
        id = "farming.method.yew",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 60, 74 },
        main_method = true,
        title = "Yew tree runs",
        icon_item_id = 5373,
        hook = "Yew tree runs offer Farming experience between other activities.",
        why = "Plant saplings in tree patches, then return once they have grown to check their "
            .. "health. Higher-tier saplings can cost more.",
        how = {
            "Use tree patches such as Lumbridge, Varrock and Falador. Nearby gardeners can protect "
                .. "the trees for a payment.",
        },
        requirements = {
            skills = { FARMING = 60 },
        },
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 60 },
        },
        priority = 2,
    },

    {
        id = "farming.method.magic",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 75, 89 },
        main_method = true,
        title = "Magic tree runs",
        icon_item_id = 5374,
        hook = "Magic tree runs offer Farming experience between other activities.",
        why = "Plant saplings in tree patches, then return once they have grown to check their "
            .. "health. Higher-tier saplings can cost more.",
        how = {
            "Use tree patches such as Lumbridge, Varrock and Falador. Nearby gardeners can protect "
                .. "the trees for a payment.",
        },
        requirements = {
            skills = { FARMING = 75 },
        },
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 75 },
        },
        priority = 2,
    },

    {
        id = "farming.method.elder",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 90, 120 },
        main_method = true,
        title = "Elder tree patch",
        icon_item_id = 32294,
        hook = "Prifddinas' elder tree patch offers another health-check reward for a farm run.",
        why = "Add it to your regular farm runs for another health-check reward. Elder saplings "
            .. "can be expensive.",
        how = {
            "After Plague's End, visit the elder tree patch in the Crwys district.",
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
                FARMING = 90,
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
            { type = "level_reached", skill = "FARMING", level = 90 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "farming.alt.giant_oyster",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 1, 120 },
        title = "Giant Oyster",
        icon_item_id = 1955,
        hook = "The Giant Oyster offers a monthly reason to revisit a familiar underwater spot.",
        why = "Gather its food for Fishing and Farming experience, then return the following month "
            .. "for treasure rewards.",
        how = {
            "After Beneath Cursed Tides, speak to Wizard Myrtle in front of the Wizards' Tower "
                .. "entrance to return to Tutorial Island.",
        },
        quest_how = {
            "Complete Beneath Cursed Tides, then speak to Wizard Myrtle outside the Wizards' Tower "
                .. "to return.",
        },
        requirements = {
            skills = {
                ATTACK = 30,
                COOKING = 30,
                FARMING = 1,
                FIREMAKING = 30,
                MAGIC = 30,
                MINING = 30,
                SMITHING = 30,
                STRENGTH = 30,
                WOODCUTTING = 30,
            },
            quests = { "BENEATH_CURSED_TIDES" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 1 },
        },
        priority = 3,
    },

    {
        id = "farming.alt.herb_runs",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 9, 120 },
        title = "Herb runs",
        icon_item_id = 199,
        hook = "Herb patches can provide useful harvests between your other farm runs.",
        why = "Start with herbs you can grow, then compare seed costs and herb values before "
            .. "moving to a new type.",
        how = {
            "Try the herb patches near Catherby and Ardougne, then add more patches as you unlock "
                .. "them.",
        },
        requirements = {
            skills = { FARMING = 9 },
        },
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 9 },
        },
        priority = 3,
    },

    {
        id = "farming.alt.beehives",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 17, 49 },
        title = "Manor Farm beehives",
        icon_item_id = 43945,
        hook = "Beehives offer Farming experience between your regular crop and animal visits.",
        why = "Flowers turn into honeycomb over time, and the honeycomb can help your farm "
            .. "animals.",
        how = {
            "Fill the beehives behind the large pen at Manor Farm with flowers you have the level "
                .. "to use, then return later.",
        },
        requirements = {
            skills = { FARMING = 17 },
        },
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 17 },
        },
        priority = 3,
    },

    {
        id = "farming.alt.player_owned_farm",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 17, 120 },
        title = "Player-owned farm",
        icon_item_id = 43985,
        hook = "Manor Farm offers animal rearing alongside growing crops.",
        why = "Animals grow between visits and reward Farming experience. Selling them earns beans "
            .. "for farm upgrades.",
        how = {
            "Speak to Granny Potterington north of Ardougne to begin the farm tutorial.",
        },
        requirements = {
            skills = { CONSTRUCTION = 20, FARMING = 17 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 17 },
        },
        priority = 3,
    },

    {
        id = "farming.alt.fruit_trees",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 27, 120 },
        title = "Fruit tree runs",
        icon_item_id = 5283,
        hook = "Fruit tree runs offer extra patches and fruit harvests alongside other crops.",
        why = "Health checks give experience and fruit can be harvested before replacing a tree. "
            .. "Higher-tier fruit trees unlock as Farming improves.",
        how = {
            "Fruit tree patches include Catherby and the Gnome Stronghold. Choose a tree that "
                .. "suits your level and budget.",
        },
        requirements = {
            skills = { FARMING = 27 },
        },
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 27 },
        },
        priority = 3,
    },

    {
        id = "farming.alt.oasis_flowers",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 30, 120 },
        title = "Het's Oasis flowers",
        icon_item_id = 52811,
        hook = "Het's Oasis offers flower gathering between farm runs.",
        why = "Higher-tier flowers open as Farming improves. Flowers can supply whirligig hunting "
            .. "or be sold, with a chance of finding golden roses while gathering.",
        how = {
            "Visit the flower bushes at Het's Oasis, and look for higher-tier flowers as you "
                .. "level.",
        },
        requirements = {
            skills = { FARMING = 30 },
        },
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 30 },
        },
        priority = 3,
    },

    {
        id = "farming.alt.seedicide",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 30, 120 },
        title = "Seedicide",
        icon_item = "_6AWE3_SEEDICIDE",
        hook = "Seedicide offers Farming experience alongside combat training.",
        why = "It destroys selected seed drops for experience. Its settings let you keep seeds you "
            .. "would rather plant or sell.",
        how = {
            "Buy one with beans from the Farmers' Market, then choose which seeds it should "
                .. "handle.",
        },
        requirements = {
            skills = { CONSTRUCTION = 20, FARMING = 17 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 30 },
        },
        known_when = {
            { type = "owns_any", items = { "_6AWE3_SEEDICIDE" } },
        },
        priority = 3,
    },

    {
        id = "farming.alt.dinosaur_farm",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 42, 120 },
        title = "Ranch Out of Time",
        icon_item_id = 48776,
        hook = "The Ranch Out of Time offers another farm to develop on Anachronia.",
        why = "Start with frogs, then work towards larger animals as your Farming and Construction "
            .. "improve.",
        how = {
            "Visit the Anachronia Dinosaur Farm and speak to Prehistoric Potterington about "
                .. "building your first pen.",
        },
        requirements = {
            skills = { CONSTRUCTION = 45, FARMING = 42 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 42 },
        },
        priority = 3,
    },

    {
        id = "farming.alt.rumberries",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 86, 120 },
        title = "Rumberry bushes",
        icon_item_id = 38627,
        hook = "Rumberry bushes offer active Farming without waiting for crop growth.",
        why = "Foraging produces berries and occasional seeds for Arc progress.",
        how = {
            "After Impressing the Locals, visit the bushes in the south-west of Tuai Leit.",
        },
        quest_how = {
            "Complete Impressing the Locals to start exploring the Arc.",
        },
        requirements = {
            skills = { FARMING = 86 },
            quests = { "ELR0" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 86 },
        },
        priority = 3,
    },

    {
        id = "farming.alt.mushroom_clusters",
        kind = "method",
        skills = { "FARMING" },
        members = true,
        level_range = { 94, 120 },
        title = "Arc mushroom clusters",
        icon_item_id = 7080,
        hook = "Mushroom clusters offer another way to train Farming on the Uncharted Isles.",
        why = "Forage their daily supply and process the mushrooms for Arc resources.",
        how = {
            "After Impressing the Locals and Flag Fall, look for an island with clusters and claim "
                .. "it so you can return.",
        },
        quest_how = {
            "Complete Impressing the Locals and Flag Fall, then explore the Uncharted Isles for a "
                .. "colony to claim.",
        },
        requirements = {
            skills = { FARMING = 94 },
            quests = { "ELR0", "ELR_FLAG" },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "FARMING", level = 94 },
        },
        priority = 3,
    },
}
