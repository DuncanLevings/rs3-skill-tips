-- useful items and unlocks, then main methods and alternatives in level order.
-- source access and recommendation windows: docs/artisan-coverage.md.

return {
    {
        id = "runecrafting.master_robes",
        icon_item = "HLR4M_RUNECRAFTER_HAT",
        kind = "convenience",
        skills = { "RUNECRAFTING" },
        members = true,
        title = "Master runecrafter robes",
        hook = "Master runecrafter robes add experience while crafting runes.",
        why = "Each piece contributes, with a further bonus from wearing the full set.",
        how = { "Look at Wizard Rinsit's shop or the Runecrafting Guild rewards." },
        requirements = {
            skills = {
                RUNECRAFTING = 50,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "HLR4M_RUNECRAFTER_BOOTS",
                    "HLR4M_RUNECRAFTER_HAT",
                    "HLR4M_RUNECRAFTER_LEGS",
                    "HLR4M_RUNECRAFTER_ROBE",
                },
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.ethereal_outfits",
        icon_item = "TRH33_ETHEREAL_HEAD_INFINITY",
        kind = "convenience",
        skills = { "RUNECRAFTING" },
        members = true,
        title = "Ethereal outfits",
        hook = "Ethereal outfits make rune-running trips go further.",
        why = "The body stores essence, and matching sets reduce pouch wear. Combining all three sets makes the infinity outfit.",
        how = {
            "Collect ethereal fragments while Runecrafting, then make pieces at an Invention workbench.",
        },
        requirements = {
            skills = {
                RUNECRAFTING = 80,
                INVENTION = 20,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH33_ETHEREAL_BODY_BLOOD",
                    "TRH33_ETHEREAL_BODY_BLOOD_WORN",
                    "TRH33_ETHEREAL_BODY_DEATH",
                    "TRH33_ETHEREAL_BODY_DEATH_WORN",
                    "TRH33_ETHEREAL_BODY_INFINITY",
                    "TRH33_ETHEREAL_BODY_INFINITY_WORN",
                    "TRH33_ETHEREAL_BODY_LAW",
                    "TRH33_ETHEREAL_BODY_LAW_WORN",
                    "TRH33_ETHEREAL_FEET_BLOOD",
                    "TRH33_ETHEREAL_FEET_DEATH",
                    "TRH33_ETHEREAL_FEET_INFINITY",
                    "TRH33_ETHEREAL_FEET_LAW",
                    "TRH33_ETHEREAL_HANDS_BLOOD",
                    "TRH33_ETHEREAL_HANDS_DEATH",
                    "TRH33_ETHEREAL_HANDS_INFINITY",
                    "TRH33_ETHEREAL_HANDS_LAW",
                    "TRH33_ETHEREAL_HEAD_BLOOD",
                    "TRH33_ETHEREAL_HEAD_DEATH",
                    "TRH33_ETHEREAL_HEAD_INFINITY",
                    "TRH33_ETHEREAL_HEAD_LAW",
                    "TRH33_ETHEREAL_LEGS_BLOOD",
                    "TRH33_ETHEREAL_LEGS_BLOOD_WORN",
                    "TRH33_ETHEREAL_LEGS_DEATH",
                    "TRH33_ETHEREAL_LEGS_DEATH_WORN",
                    "TRH33_ETHEREAL_LEGS_INFINITY",
                    "TRH33_ETHEREAL_LEGS_INFINITY_WORN",
                    "TRH33_ETHEREAL_LEGS_LAW",
                    "TRH33_ETHEREAL_LEGS_LAW_WORN",
                },
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.pouches",
        icon_item = "RCU_POUCH_MEDIUM_DEGRADE",
        kind = "convenience",
        skills = { "RUNECRAFTING" },
        members = true,
        title = "Runecrafting pouches",
        hook = "Runecrafting pouches let you carry more essence per trip.",
        why = "Larger pouches unlock as you level. Most worn pouches can be repaired to keep them useful.",
        how = {
            "Look at the Runecrafting Guild shops or the Abyss. Reaching the Abyss takes you through the Wilderness.",
        },
        requirements = {
            skills = {
                RUNECRAFTING = 25,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "RCSIPHONXP_MASSIVE_POUCH_ACTIVE",
                    "RCSIPHONXP_MASSIVE_POUCH_INACTIVE",
                    "RCU_POUCH_EXPANSIVE",
                    "RCU_POUCH_GIANT",
                    "RCU_POUCH_GIANT_DEGRADE",
                    "RCU_POUCH_LARGE",
                    "RCU_POUCH_LARGE_DEGRADE",
                    "RCU_POUCH_MEDIUM",
                    "RCU_POUCH_MEDIUM_DEGRADE",
                },
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.expansive_pouch",
        icon_item = "RCU_POUCH_EXPANSIVE",
        kind = "convenience",
        skills = { "RUNECRAFTING" },
        members = true,
        title = "Expansive pouch",
        hook = "An expansive pouch can replace the usual collection of essence pouches.",
        why = "It holds more essence in one slot and does not degrade, making longer rune-running trips possible.",
        how = { "Look into the hungry hood in Wizard Rinsit's shop to begin its creation." },
        requirements = {
            skills = {
                RUNECRAFTING = 105,
                DIVINATION = 95,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "RCU_POUCH_EXPANSIVE" },
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.catalyst",
        icon_item = "QUEST_ENDGAME_SHARD_RUNECRAFTING",
        kind = "convenience",
        skills = { "RUNECRAFTING" },
        members = true,
        title = "Runecrafter's Catalyst fragment",
        hook = "The Runecrafter's Catalyst fragment slows pouch wear.",
        why = "Keep it with you to reduce repairs between rune-running trips. The combined fragment carries the effect too.",
        how = { "It is a reward from Sliske's Endgame." },
        quest_how = { "Look into Sliske's Endgame and its lasting skilling rewards." },
        requirements = {
            skills = {
                RUNECRAFTING = 50,
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
                SMITHING = 70,
                STRENGTH = 79,
                HUNTER = 65,
                FARMING = 25,
                DEFENCE = 72,
                ATTACK = 79,
                FISHING = 36,
                HITPOINTS = 78,
            },
            quests = { "SLISKES_ENDGAME" },
        },
        min_training_level = 50,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
        },
        known_when = {
            {
                items = {
                    "QUEST_ENDGAME_SHARD_RUNECRAFTING",
                    "QUEST_ENDGAME_SHARD_COMBINED",
                    "RCU_POUCH_EXPANSIVE",
                },
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
        id = "runecrafting.binding_rod",
        icon_item = "INVENT_RUNECRAFTING_ROD",
        kind = "convenience",
        skills = { "RUNECRAFTING" },
        members = true,
        title = "Binding rod",
        hook = "A binding rod brings tool perks to crafting runes.",
        why = "It gains equipment experience at supported altars and uses energy from your charge pack.",
        how = { "Discover its blueprint and build it at an Invention workbench." },
        requirements = {
            skills = {
                RUNECRAFTING = 71,
                INVENTION = 22,
            },
        },
        min_training_level = 71,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "INVENT_RUNECRAFTING_ROD",
                    "INVENT_RUNECRAFTING_ROD_CRYSTAL",
                    "INVENT_RUNECRAFTING_ROD_CRYSTAL_UNCHARGED",
                    "INVENT_RUNECRAFTING_ROD_CRYSTAL_UNUSED",
                    "INVENT_RUNECRAFTING_ROD_UNCHARGED",
                    "INVENT_RUNECRAFTING_ROD_UNUSED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.crystal_binding_rod",
        icon_item = "INVENT_RUNECRAFTING_ROD_CRYSTAL_UNUSED",
        kind = "convenience",
        skills = { "RUNECRAFTING" },
        members = true,
        title = "Crystal binding rod",
        hook = "A crystal binding rod offers more runes from your essence.",
        why = "It carries Invention perks and adds rune yield at supported altars, excluding combination runes.",
        how = {
            "Discover its blueprint at an Invention workbench. Harmonic dust from Prifddinas goes into the upgrade.",
        },
        quest_how = {
            "Work towards Plague's End to open up Prifddinas and its training facilities.",
        },
        requirements = {
            skills = {
                INVENTION = 82,
                RUNECRAFTING = 81,
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
                skill = "RUNECRAFTING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "INVENT_RUNECRAFTING_ROD_CRYSTAL",
                    "INVENT_RUNECRAFTING_ROD_CRYSTAL_UNCHARGED",
                    "INVENT_RUNECRAFTING_ROD_CRYSTAL_UNUSED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.runic_attuner",
        icon_item = "ELIDINIS_BOSS_SKILLING_OFFHAND_RUNECRAFTING",
        kind = "convenience",
        skills = { "RUNECRAFTING" },
        members = true,
        title = "Runic attuner",
        hook = "The runic attuner rewards visiting different rune altars.",
        why = "Follow its current attunement for extra experience and build towards further rune-crafting bonuses.",
        how = {
            "Earn it from the Gate of Elidinis after Ode of the Devourer, or buy one on the Grand Exchange.",
        },
        quest_how = {
            "Work towards Ode of the Devourer to reach the Gate of Elidinis and its rewards.",
        },
        requirements = {
            skills = {
                SLAYER = 10,
                AGILITY = 25,
                CONSTRUCTION = 54,
                NECROMANCY = 75,
                PRAYER = 40,
                MAGIC = 66,
                RUNECRAFTING = 80,
                ARCHAEOLOGY = 86,
                COOKING = 20,
            },
            quests = { "QUEST_AMASCUT" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "ELIDINIS_BOSS_SKILLING_OFFHAND_RUNECRAFTING" },
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.pouch_protector",
        icon_item_id = 7936,
        kind = "general",
        skills = { "RUNECRAFTING" },
        members = true,
        title = "Pouch Protector",
        hook = "Pouch Protector removes repairs from your rune-running routine.",
        why = "Harnessing this relic power stops your Runecrafting pouches from degrading.",
        how = { "Look into the Threads of Fate relic and offer it at the mysterious monolith." },
        requirements = {
            skills = {
                RUNECRAFTING = 1,
                ARCHAEOLOGY = 36,
            },
        },
        min_training_level = 50,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.nexus_mod",
        icon_item_id = 7936,
        kind = "general",
        skills = { "RUNECRAFTING" },
        members = true,
        title = "Nexus Mod",
        hook = "Nexus Mod makes the Abyss route more direct.",
        why = "The relic power places you in the centre ring, skipping the outer obstacles. Getting there still takes you through the Wilderness.",
        how = { "Look into the Abyssal Gatestone relic at the mysterious monolith." },
        requirements = {
            skills = {
                RUNECRAFTING = 1,
                ARCHAEOLOGY = 68,
                DUNGEONEERING = 60,
            },
        },
        min_training_level = 60,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.cape",
        icon_item = "SKILLCAPE_RUNECRAFTING",
        kind = "convenience",
        skills = { "RUNECRAFTING" },
        members = true,
        title = "Runecrafting cape",
        hook = "The Runecrafting cape offers more runes from some altar trips.",
        why = "Its perk can act like an anima stone, producing extra runes when crafting at an altar.",
        how = { "Buy it from Aubury in Varrock." },
        requirements = {
            skills = {
                RUNECRAFTING = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_INVERTED_RUNECRAFTING_HOODED",
                    "SKILLCAPE_INVERTED_RUNECRAFTING_TRIMMED_HOODED",
                    "SKILLCAPE_RUNECRAFTING",
                    "SKILLCAPE_RUNECRAFTING_HOODED",
                    "SKILLCAPE_RUNECRAFTING_HOODED_RETRO",
                    "SKILLCAPE_RUNECRAFTING_RETRO",
                    "SKILLCAPE_RUNECRAFTING_TRIMMED",
                    "SKILLCAPE_RUNECRAFTING_TRIMMED_HOODED",
                    "SKILLCAPE_RUNECRAFTING_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_RUNECRAFTING_TRIMMED_RETRO",
                },
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.method.fire_runes",
        main_method = true,
        icon_item_id = 554,
        kind = "method",
        skills = { "RUNECRAFTING" },
        level_range = { 14, 26 },
        members = false,
        title = "Fire runes",
        hook = "Crafting fire runes combines training with supplies for spells and enchantments.",
        why = "Rune yield improves with your level and equipment. Pouches help make each trip count.",
        how = { "Inspect the altar route and supplies before trying a few trips." },
        requirements = {
            skills = {
                RUNECRAFTING = 14,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "RUNECRAFTING",
                level = 14,
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.method.cosmic_runes",
        main_method = true,
        icon_item_id = 564,
        kind = "method",
        skills = { "RUNECRAFTING" },
        level_range = { 27, 43 },
        members = true,
        title = "Cosmic runes",
        hook = "Crafting cosmic runes combines training with supplies for enchanting jewellery.",
        why = "Rune yield improves with your level and equipment. Pouches help make each trip count.",
        how = {
            "Zanaris offers a route after Lost City. The Abyss route crosses the Wilderness and needs its introductory task first.",
        },
        requirements = {
            skills = {
                RUNECRAFTING = 27,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "RUNECRAFTING",
                level = 27,
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.method.nature_runes",
        main_method = true,
        icon_item_id = 561,
        kind = "method",
        skills = { "RUNECRAFTING" },
        level_range = { 44, 53 },
        members = true,
        title = "Nature runes",
        hook = "Crafting nature runes combines training with supplies for alchemy and other utility spells.",
        why = "Rune yield improves with your level and equipment. Pouches help make each trip count.",
        how = { "Inspect the altar route and supplies before trying a few trips." },
        requirements = {
            skills = {
                RUNECRAFTING = 44,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "RUNECRAFTING",
                level = 44,
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.method.law_runes",
        main_method = true,
        icon_item_id = 563,
        kind = "method",
        skills = { "RUNECRAFTING" },
        level_range = { 54, 64 },
        members = true,
        title = "Law runes",
        hook = "Crafting law runes combines training with supplies for teleport spells.",
        why = "Rune yield improves with your level and equipment. Pouches help make each trip count.",
        how = {
            "The altar is on Entrana, with restrictions on what you can bring. The alternative Abyss route crosses the Wilderness.",
        },
        requirements = {
            skills = {
                RUNECRAFTING = 54,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "RUNECRAFTING",
                level = 54,
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.method.death_runes",
        main_method = true,
        icon_item_id = 560,
        kind = "method",
        skills = { "RUNECRAFTING" },
        level_range = { 65, 76 },
        members = true,
        title = "Death runes",
        hook = "Crafting death runes combines training with higher-level magic supplies.",
        why = "Rune yield improves with your level and equipment. Pouches help make each trip count.",
        how = { "Inspect the altar route and supplies before trying a few trips." },
        quest_how = { "Work towards Mourning's End Part II to gain access to the death altar." },
        requirements = {
            skills = {
                RUNECRAFTING = 65,
                COOKING = 30,
                FLETCHING = 5,
                RANGED = 60,
                THIEVING = 50,
                AGILITY = 56,
            },
            quests = { "MOURNINGS_END_PART_2" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "RUNECRAFTING",
                level = 65,
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.method.blood_runes",
        main_method = true,
        icon_item_id = 565,
        kind = "method",
        skills = { "RUNECRAFTING" },
        level_range = { 77, 89 },
        members = true,
        title = "Blood runes",
        hook = "Crafting blood runes combines training with runes with a range of high-level magic uses.",
        why = "Rune yield improves with your level and equipment. Pouches help make each trip count.",
        how = { "Inspect the altar route and supplies before trying a few trips." },
        quest_how = { "Work towards Legacy of Seergaze for access to the blood altar." },
        requirements = {
            skills = {
                RUNECRAFTING = 77,
                AGILITY = 29,
                CONSTRUCTION = 20,
                CRAFTING = 47,
                FIREMAKING = 40,
                MAGIC = 49,
                MINING = 35,
                SLAYER = 31,
                STRENGTH = 40,
                THIEVING = 22,
            },
            quests = { "LEGACY_OF_SEERGAZE" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "RUNECRAFTING",
                level = 77,
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.method.soul_runes",
        main_method = true,
        icon_item_id = 566,
        kind = "method",
        skills = { "RUNECRAFTING" },
        level_range = { 90, 99 },
        members = true,
        title = "Soul runes",
        hook = "Soul runes offer an altar-crafting option at this stage.",
        why = "Charge the soul altar with essence, then craft runes from its stored charges. The charging step offers a more relaxed rhythm.",
        how = { "Visit the soul altar beneath the fountain in Menaphos' Imperial district." },
        quest_how = {
            "Work through the Menaphos story to 'Phite Club for access to the soul altar.",
        },
        requirements = {
            skills = {
                RUNECRAFTING = 90,
                CRAFTING = 68,
                RANGED = 50,
                SLAYER = 35,
                THIEVING = 70,
                WOODCUTTING = 47,
                AGILITY = 50,
                FISHING = 72,
                HUNTER = 73,
                FIREMAKING = 50,
                STRENGTH = 60,
                FARMING = 25,
                CONSTRUCTION = 64,
                COOKING = 70,
                MAGIC = 70,
                PRAYER = 35,
                MINING = 37,
                HERBLORE = 10,
            },
            quests = { "PHITE_CLUB" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "RUNECRAFTING",
                level = 90,
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.method.time_runes",
        main_method = true,
        icon_item_id = 58450,
        kind = "method",
        skills = { "RUNECRAFTING" },
        level_range = { 100, 120 },
        members = true,
        title = "Time runes",
        hook = "Time runes offer an altar-crafting option at this stage.",
        why = "Rune yield improves with your level and equipment. Pouches help make each trip count.",
        how = {
            "Take the enchanted key from Making History to the time ruins on north-west Anachronia to anchor the altar.",
        },
        quest_how = {
            "Complete Making History, then take its enchanted key to the time ruins on north-west Anachronia.",
        },
        requirements = {
            skills = {
                RUNECRAFTING = 100,
            },
            quests = { "MAKING_HISTORY" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "RUNECRAFTING",
                level = 100,
            },
        },
        priority = 2,
    },

    {
        id = "runecrafting.alt.necrotic",
        icon_item_id = 55667,
        kind = "method",
        skills = { "RUNECRAFTING" },
        level_range = { 20, 99 },
        members = true,
        title = "Necromantic runes",
        hook = "Necromantic runes offer another altar-running route.",
        why = "They use impure essence, with more rune types becoming available as your Runecrafting level rises.",
        how = { "After Rune Mythos, visit the Necromantic Rune Temple in the City of Um." },
        quest_how = { "Complete Rune Mythos to use the Necromantic Rune Temple in the City of Um." },
        requirements = {
            skills = {
                NECROMANCY = 24,
                RUNECRAFTING = 20,
            },
            quests = { "QUEST_NECROMANCY_ORIGINS" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
        },
        priority = 3,
    },

    {
        id = "runecrafting.alt.ourania",
        icon_item_id = 7936,
        kind = "method",
        skills = { "RUNECRAFTING" },
        level_range = { 40, 76 },
        members = true,
        title = "Ourania altar",
        hook = "The Ourania altar offers a change from crafting one rune type per trip.",
        why = "It turns essence into a mixture of runes, with higher-level runes becoming more likely as you level.",
        how = {
            "Visit the cave west of the Battlefield near Ardougne. A longer route avoids the monsters.",
        },
        requirements = {
            skills = {
                RUNECRAFTING = 40,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
        },
        priority = 3,
    },

    {
        id = "runecrafting.alt.ascended",
        icon_item_id = 58450,
        kind = "method",
        skills = { "RUNECRAFTING" },
        level_range = { 100, 120 },
        members = true,
        title = "Ascended equipment",
        hook = "Ascending equipment trades a finished weapon for Runecrafting experience.",
        why = "The Ourania altar consumes the fully upgraded weapon, leaving nothing to sell. This makes cost the main tradeoff.",
        how = { "Look at the Ascend weapons option at the Ourania altar." },
        requirements = {
            skills = {
                RUNECRAFTING = 100,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "RUNECRAFTING",
            },
        },
        priority = 3,
    },
}
