-- useful items and unlocks first, then level-bracket methods and alternatives.
-- access and relevance evidence is recorded in docs/gathering-coverage.md.

return {
    -- useful items and unlocks

    {
        id = "farming.farmers_outfit",
        icon_item = "TRH13_FARMER_HAT",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Farmer's outfit",
        hook = "The Farmer's outfit adds experience to your Farming activities.",
        why = "Each piece contributes, with an extra bonus for wearing the full set.",
        how = {
            "Sydekix's Shop of Balance sells the pieces for Crux Eqal favour earned from herb farming.",
        },
        requirements = {
            skills = {
                FARMING = 1,
            },
        },
        min_training_level = 20,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FARMING",
            },
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
        icon_item = "POF_REWARDS_TRH_MASTER_HEAD",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Master farmer outfit",
        hook = "The master farmer outfit offers bonuses for crops, animals and farm travel.",
        why = "Combine the animal, crop and tree sets for the full outfit's benefits. It can also use the Farmer's outfit experience bonus if you own that set.",
        how = {
            "Buy the blueprint from Granny Potterington with beans, then craft pieces from master farmer fragments through Invention.",
        },
        requirements = {
            skills = {
                FARMING = 80,
                INVENTION = 20,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FARMING",
            },
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
        icon_item = "NATURE_AMULET",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Amulet of nature",
        hook = "An amulet of nature offers a way to check a patch away from your farm run.",
        why = "Bind it to a supported patch to check its progress and return to it conveniently.",
        how = {
            "Craft and enchant an emerald amulet strung with magic string, then use it on a patch.",
        },
        requirements = {
            skills = {
                CRAFTING = 31,
                FARMING = 1,
                MAGIC = 27,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FARMING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "NATURE_AMULET" },
            },
        },
        priority = 2,
    },

    {
        id = "farming.magic_secateurs",
        icon_item = "FAIRY_ENCHANTED_SECATEURS",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Magic secateurs",
        hook = "Magic secateurs help you get more produce from supported crops.",
        why = "Their harvesting effect works while carried, worn or stored on your tool belt.",
        how = {
            "They're a reward from A Fairy Tale I - Growing Pains. Try them on an herb or allotment run.",
        },
        quest_how = { "Look into A Fairy Tale I - Growing Pains for the magic secateurs reward." },
        requirements = {
            skills = {
                FARMING = 1,
                CRAFTING = 31,
                WOODCUTTING = 36,
            },
            quests = { "FAIRY_TALE_I" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FARMING",
            },
        },
        known_when = {
            {
                items = { "FAIRY_ENCHANTED_SECATEURS" },
                type = "owns_any",
            },
            {
                type = "quest_done",
                quest = "FAIRY_TALE_I",
            },
        },
        priority = 2,
    },

    {
        id = "farming.magic_watering_can",
        icon_item = "FT3_WATERING_CAN",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Magic watering can",
        hook = "The magic watering can saves refills while tending crops.",
        why = "Its unlimited water also works when stored with a tool leprechaun.",
        how = {
            "Claim it after A Fairy Tale III - Battle at Ork's Rift, then replace your regular watering can.",
        },
        quest_how = {
            "Work towards A Fairy Tale III - Battle at Ork's Rift and its farming unlocks.",
        },
        requirements = {
            skills = {
                FARMING = 54,
                CRAFTING = 36,
                THIEVING = 51,
                WOODCUTTING = 36,
                HERBLORE = 57,
            },
            quests = { "FAIRY_TALE_III" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FARMING",
            },
        },
        known_when = {
            {
                items = { "FT3_WATERING_CAN" },
                type = "owns_any",
            },
            {
                type = "quest_done",
                quest = "FAIRY_TALE_III",
            },
        },
        priority = 2,
    },

    {
        id = "farming.catalyst_fragment",
        icon_item = "QUEST_ENDGAME_SHARD_FARMING",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Farmer's Catalyst fragment",
        hook = "The Farmer's Catalyst fragment offers free cures for diseased herb patches.",
        why = "Equip it while curing a supported herb patch to recover the plant and receive shadow-infused herbs.",
        how = {
            "It's a reward from Sliske's Endgame and can be combined with the other Catalyst fragments.",
        },
        quest_how = { "Look into Sliske's Endgame and its lasting skilling rewards." },
        requirements = {
            quests = { "SLISKES_ENDGAME" },
            skills = {
                AGILITY = 80,
                THIEVING = 66,
                DIVINATION = 80,
                MAGIC = 81,
                SLAYER = 80,
                SUMMONING = 75,
                HERBLORE = 80,
                CONSTRUCTION = 75,
                CRAFTING = 80,
                DUNGEONEERING = 75,
                MINING = 75,
                PRAYER = 80,
                RANGED = 75,
                WOODCUTTING = 80,
                COOKING = 35,
                FLETCHING = 70,
                FIREMAKING = 71,
                RUNECRAFTING = 50,
                SMITHING = 70,
                STRENGTH = 79,
                HUNTER = 65,
                FARMING = 25,
                DEFENCE = 72,
                ATTACK = 79,
                FISHING = 36,
                HITPOINTS = 78,
            },
        },
        require_all_levels = true,
        min_training_level = 50,
        triggers = {
            {
                type = "training",
                skill = "FARMING",
            },
        },
        known_when = {
            {
                items = { "QUEST_ENDGAME_SHARD_FARMING", "QUEST_ENDGAME_SHARD_COMBINED" },
                type = "owns_any",
            },
            {
                type = "quest_done",
                quest = "SLISKES_ENDGAME",
            },
        },
        priority = 2,
    },

    {
        id = "farming.leprechaun_notes",
        icon_item_id = 1942,
        kind = "general",
        skills = { "FARMING" },
        members = true,
        title = "Leprechaun noting",
        hook = "A tool leprechaun can save you a bank trip during a harvest.",
        why = "Leprechauns turn supported harvested produce into banknotes and can store your farming tools.",
        how = { "Use your produce on a nearby tool leprechaun to try noting it." },
        requirements = {
            skills = {
                FARMING = 1,
            },
        },
        triggers = {
            {
                type = "training",
                skill = "FARMING",
            },
        },
        priority = 3,
    },

    {
        id = "farming.rapid_growth",
        icon_item_id = 52811,
        kind = "general",
        skills = { "FARMING" },
        members = true,
        title = "Rapid Growth",
        hook = "Rapid Growth can shorten the wait for supported crops.",
        why = "The Seren spell advances a crop by a growth stage, with limits on how often it can affect each patch.",
        how = { "After The Light Within, look for Rapid Growth on the Ancient Magicks spellbook." },
        quest_how = { "Look into The Light Within for access to its Seren spells and prayers." },
        requirements = {
            skills = {
                MAGIC = 88,
                FARMING = 25,
                AGILITY = 80,
                CRAFTING = 80,
                DIVINATION = 80,
                HERBLORE = 80,
                PRAYER = 80,
                SLAYER = 80,
                WOODCUTTING = 80,
                CONSTRUCTION = 75,
                FLETCHING = 70,
                RANGED = 75,
                FIREMAKING = 50,
                THIEVING = 66,
                RUNECRAFTING = 50,
                SMITHING = 65,
                SUMMONING = 75,
                DUNGEONEERING = 75,
                MINING = 75,
                COOKING = 35,
                STRENGTH = 64,
                HUNTER = 51,
            },
            quests = { "SEREN" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FARMING",
            },
        },
        priority = 3,
    },

    {
        id = "farming.gardeners",
        icon_item_id = 1955,
        kind = "general",
        skills = { "FARMING" },
        members = true,
        title = "Pay the gardener",
        hook = "A nearby gardener can watch over many of your planted crops.",
        why = "Paying for protection prevents disease for that crop, so you can return for its health check without tending it.",
        how = {
            "Check the gardener's payment option before leaving a newly planted tree. Noted payments save backpack space.",
        },
        requirements = {
            skills = {
                FARMING = 15,
            },
        },
        triggers = {
            {
                type = "training",
                skill = "FARMING",
            },
        },
        priority = 3,
    },

    {
        id = "farming.scroll_of_life",
        icon_item_id = 18336,
        kind = "general",
        skills = { "FARMING" },
        members = true,
        title = "Scroll of life",
        hook = "The Scroll of life offers a lasting chance to recover seeds during Farming.",
        why = "Reading it unlocks a permanent benefit rather than an item you need to carry on each run.",
        how = {
            "Look for the scroll in the Daemonheim Rewards shop and earn the tokens through Dungeoneering.",
        },
        requirements = {
            skills = {
                DUNGEONEERING = 25,
                FARMING = 25,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FARMING",
            },
        },
        priority = 3,
    },

    {
        id = "farming.pharm_ecology",
        icon_item_id = 49598,
        kind = "general",
        skills = { "FARMING" },
        members = true,
        title = "Pharm Ecology",
        hook = "Pharm Ecology offers disease protection for herb and mushroom patches.",
        why = "While the relic is active, these patches stay healthy without relying on disease checks going your way.",
        how = {
            "After A Fairy Tale III, work towards Queen Mab's Moonstone through the Armadylean I collection and offer it at the monolith.",
        },
        quest_how = {
            "Work towards A Fairy Tale III - Battle at Ork's Rift and its farming unlocks.",
        },
        requirements = {
            skills = {
                FARMING = 59,
                ARCHAEOLOGY = 81,
                CRAFTING = 36,
                THIEVING = 51,
                WOODCUTTING = 36,
                HERBLORE = 57,
            },
            quests = { "FAIRY_TALE_III" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FARMING",
            },
        },
        priority = 3,
    },

    {
        id = "farming.cape",
        icon_item = "SKILLCAPE_FARMING",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Farming cape",
        hook = "The Farming cape can make harvesting quicker and easier on backpack space.",
        why = "Its perk can harvest the rest of a crop at once and notes the produce it collects.",
        how = { "Buy it from Martin the Master Gardener in Draynor Village." },
        requirements = {
            skills = {
                FARMING = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FARMING",
            },
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
        icon_item = "SKILLCAPE_120_FARMING",
        kind = "convenience",
        skills = { "FARMING" },
        members = true,
        title = "Farming master cape",
        hook = "The Farming master cape offers free supercompost and help with your animals.",
        why = "It automatically supercomposts supported patches and has a daily boost for farm animals, alongside the regular cape's harvesting perk.",
        how = { "Buy it from Martin the Master Gardener after reaching 120 Farming." },
        requirements = {
            skills = {
                FARMING = 120,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "FARMING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "SKILLCAPE_120_FARMING" },
            },
        },
        priority = 2,
    },

    -- training methods

    {
        id = "farming.method.oak",
        main_method = true,
        icon_item_id = 5370,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 15, 29 },
        members = true,
        title = "Oak tree runs",
        hook = "Oak tree runs offer Farming experience between other activities.",
        why = "Plant saplings in tree patches, then return once they have grown to check their health. Higher-tier saplings can cost more.",
        how = {
            "Use tree patches such as Lumbridge, Varrock and Falador. Nearby gardeners can protect the trees for a payment.",
        },
        requirements = {
            skills = {
                FARMING = 15,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 15,
            },
        },
        priority = 2,
    },

    {
        id = "farming.method.willow",
        main_method = true,
        icon_item_id = 5371,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 30, 44 },
        members = true,
        title = "Willow tree runs",
        hook = "Willow tree runs offer Farming experience between other activities.",
        why = "Plant saplings in tree patches, then return once they have grown to check their health. Higher-tier saplings can cost more.",
        how = {
            "Use tree patches such as Lumbridge, Varrock and Falador. Nearby gardeners can protect the trees for a payment.",
        },
        requirements = {
            skills = {
                FARMING = 30,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 30,
            },
        },
        priority = 2,
    },

    {
        id = "farming.method.maple",
        main_method = true,
        icon_item_id = 5372,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 45, 59 },
        members = true,
        title = "Maple tree runs",
        hook = "Maple tree runs offer Farming experience between other activities.",
        why = "Plant saplings in tree patches, then return once they have grown to check their health. Higher-tier saplings can cost more.",
        how = {
            "Use tree patches such as Lumbridge, Varrock and Falador. Nearby gardeners can protect the trees for a payment.",
        },
        requirements = {
            skills = {
                FARMING = 45,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 45,
            },
        },
        priority = 2,
    },

    {
        id = "farming.method.yew",
        main_method = true,
        icon_item_id = 5373,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 60, 74 },
        members = true,
        title = "Yew tree runs",
        hook = "Yew tree runs offer Farming experience between other activities.",
        why = "Plant saplings in tree patches, then return once they have grown to check their health. Higher-tier saplings can cost more.",
        how = {
            "Use tree patches such as Lumbridge, Varrock and Falador. Nearby gardeners can protect the trees for a payment.",
        },
        requirements = {
            skills = {
                FARMING = 60,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 60,
            },
        },
        priority = 2,
    },

    {
        id = "farming.method.magic",
        main_method = true,
        icon_item_id = 5374,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 75, 89 },
        members = true,
        title = "Magic tree runs",
        hook = "Magic tree runs offer Farming experience between other activities.",
        why = "Plant saplings in tree patches, then return once they have grown to check their health. Higher-tier saplings can cost more.",
        how = {
            "Use tree patches such as Lumbridge, Varrock and Falador. Nearby gardeners can protect the trees for a payment.",
        },
        requirements = {
            skills = {
                FARMING = 75,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 75,
            },
        },
        priority = 2,
    },

    {
        id = "farming.method.elder",
        main_method = true,
        icon_item_id = 32294,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 90, 120 },
        members = true,
        title = "Elder tree patch",
        hook = "Prifddinas' elder tree patch offers another health-check reward for a farm run.",
        why = "Add it to your regular farm runs for another health-check reward. Elder saplings can be expensive.",
        how = { "After Plague's End, visit the elder tree patch in the Crwys district." },
        quest_how = {
            "Work towards Plague's End to open up Prifddinas and its training facilities.",
        },
        requirements = {
            skills = {
                FARMING = 90,
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
                type = "level_reached",
                skill = "FARMING",
                level = 90,
            },
        },
        priority = 2,
    },

    -- alternative methods

    {
        id = "farming.alt.giant_oyster",
        icon_item_id = 1955,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 1, 120 },
        members = true,
        title = "Giant Oyster",
        hook = "The Giant Oyster offers a monthly reason to revisit a familiar underwater spot.",
        why = "Gather its food for Fishing and Farming experience, then return the following month for treasure rewards.",
        how = {
            "After Beneath Cursed Tides, speak to Wizard Myrtle in front of the Wizards' Tower entrance to return to Tutorial Island.",
        },
        quest_how = {
            "Complete Beneath Cursed Tides, then speak to Wizard Myrtle outside the Wizards' Tower to return.",
        },
        requirements = {
            skills = {
                FARMING = 1,
                ATTACK = 30,
                COOKING = 30,
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
            {
                type = "level_reached",
                skill = "FARMING",
                level = 1,
            },
        },
        priority = 3,
    },

    {
        id = "farming.alt.herb_runs",
        icon_item_id = 199,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 9, 120 },
        members = true,
        title = "Herb runs",
        hook = "Herb patches can provide useful harvests between your other farm runs.",
        why = "Start with herbs you can grow, then compare seed costs and herb values before moving to a new type.",
        how = {
            "Try the herb patches near Catherby and Ardougne, then add more patches as you unlock them.",
        },
        requirements = {
            skills = {
                FARMING = 9,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 9,
            },
        },
        priority = 3,
    },

    {
        id = "farming.alt.beehives",
        icon_item_id = 43945,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 17, 49 },
        members = true,
        title = "Manor Farm beehives",
        hook = "Beehives offer Farming experience between your regular crop and animal visits.",
        why = "Flowers turn into honeycomb over time, and the honeycomb can help your farm animals.",
        how = {
            "Fill the beehives behind the large pen at Manor Farm with flowers you have the level to use, then return later.",
        },
        requirements = {
            skills = {
                FARMING = 17,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 17,
            },
        },
        priority = 3,
    },

    {
        id = "farming.alt.player_owned_farm",
        icon_item_id = 43985,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 17, 120 },
        members = true,
        title = "Player-owned farm",
        hook = "Manor Farm offers animal rearing alongside growing crops.",
        why = "Animals grow between visits and reward Farming experience. Selling them earns beans for farm upgrades.",
        how = { "Speak to Granny Potterington north of Ardougne to begin the farm tutorial." },
        requirements = {
            skills = {
                CONSTRUCTION = 20,
                FARMING = 17,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 17,
            },
        },
        priority = 3,
    },

    {
        id = "farming.alt.fruit_trees",
        icon_item_id = 5283,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 27, 120 },
        members = true,
        title = "Fruit tree runs",
        hook = "Fruit tree runs offer extra patches and fruit harvests alongside other crops.",
        why = "Health checks give experience and fruit can be harvested before replacing a tree. Higher-tier fruit trees unlock as Farming improves.",
        how = {
            "Fruit tree patches include Catherby and the Gnome Stronghold. Choose a tree that suits your level and budget.",
        },
        requirements = {
            skills = {
                FARMING = 27,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 27,
            },
        },
        priority = 3,
    },

    {
        id = "farming.alt.oasis_flowers",
        icon_item_id = 52811,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 30, 120 },
        members = true,
        title = "Het's Oasis flowers",
        hook = "Het's Oasis offers flower gathering between farm runs.",
        why = "Higher-tier flowers open as Farming improves. Flowers can supply whirligig hunting or be sold, with a chance of finding golden roses while gathering.",
        how = {
            "Visit the flower bushes at Het's Oasis, and look for higher-tier flowers as you level.",
        },
        requirements = {
            skills = {
                FARMING = 30,
            },
        },
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 30,
            },
        },
        priority = 3,
    },

    {
        id = "farming.alt.seedicide",
        icon_item = "_6AWE3_SEEDICIDE",
        kind = "method",
        skills = { "FARMING" },
        level_range = { 30, 120 },
        members = true,
        title = "Seedicide",
        hook = "Seedicide offers Farming experience alongside combat training.",
        why = "It destroys selected seed drops for experience. Its settings let you keep seeds you would rather plant or sell.",
        how = {
            "Buy one with beans from the Farmers' Market, then choose which seeds it should handle.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 20,
                FARMING = 17,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 30,
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "_6AWE3_SEEDICIDE" },
            },
        },
        priority = 3,
    },

    {
        id = "farming.alt.dinosaur_farm",
        icon_item_id = 48776,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 42, 120 },
        members = true,
        title = "Ranch Out of Time",
        hook = "The Ranch Out of Time offers another farm to develop on Anachronia.",
        why = "Start with frogs, then work towards larger animals as your Farming and Construction improve.",
        how = {
            "Visit the Anachronia Dinosaur Farm and speak to Prehistoric Potterington about building your first pen.",
        },
        requirements = {
            skills = {
                CONSTRUCTION = 45,
                FARMING = 42,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 42,
            },
        },
        priority = 3,
    },

    {
        id = "farming.alt.rumberries",
        icon_item_id = 38627,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 86, 120 },
        members = true,
        title = "Rumberry bushes",
        hook = "Rumberry bushes offer active Farming without waiting for crop growth.",
        why = "Foraging produces berries and occasional seeds for Arc progress.",
        how = { "After Impressing the Locals, visit the bushes in the south-west of Tuai Leit." },
        quest_how = { "Complete Impressing the Locals to start exploring the Arc." },
        requirements = {
            skills = {
                FARMING = 86,
            },
            quests = { "ELR0" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 86,
            },
        },
        priority = 3,
    },

    {
        id = "farming.alt.mushroom_clusters",
        icon_item_id = 7080,
        kind = "method",
        skills = { "FARMING" },
        level_range = { 94, 120 },
        members = true,
        title = "Arc mushroom clusters",
        hook = "Mushroom clusters offer another way to train Farming on the Uncharted Isles.",
        why = "Forage their daily supply and process the mushrooms for Arc resources.",
        how = {
            "After Impressing the Locals and Flag Fall, look for an island with clusters and claim it so you can return.",
        },
        quest_how = {
            "Complete Impressing the Locals and Flag Fall, then explore the Uncharted Isles for a colony to claim.",
        },
        requirements = {
            skills = {
                FARMING = 94,
            },
            quests = { "ELR0", "ELR_FLAG" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "FARMING",
                level = 94,
            },
        },
        priority = 3,
    },
}
