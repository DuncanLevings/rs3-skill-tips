-- mining tips. convenience items first, then training methods in level order.
--
-- method tips follow the brackets in the wiki's pay-to-play mining training guide, written in
-- our own words. members comes from each ore's wiki item page (runite and below are f2p)

return {
    -- convenience items

    {
        id = "mining.ore_box",
        kind = "convenience",
        skills = { "MINING" },
        members = false,
        title = "Ore box",
        icon_item = "MINING_OREBOX_BRONZE",
        hook = "Backpack full? An ore box lets you keep mining for longer between bank trips.",
        why = "Fill it with ore to free up backpack space. "
            .. "Upgraded boxes can store higher-tier ores.",
        how = {
            "Smith a bronze ore box at an anvil, or buy one on the Grand Exchange.",
        },
        requirements = { skills = { SMITHING = 1 } },
        triggers = { { type = "backpack_full", skill = "MINING" } },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "MINING_OREBOX_BRONZE",
                    "MINING_OREBOX_IRON",
                    "MINING_OREBOX_STEEL",
                    "MINING_OREBOX_MITHRIL",
                    "MINING_OREBOX_ADAMANT",
                    "MINING_OREBOX_RUNE",
                    "MINING_OREBOX_ORIKALKUM",
                    "MINING_OREBOX_NECRONIUM",
                    "MINING_OREBOX_BANE",
                    "MINING_OREBOX_ELDER_RUNE",
                    "MINING_OREBOX_PRIMAL",
                },
            },
            { type = "owns_category", category = 4448 },
        },
        priority = 1,
    },

    {
        id = "mining.golden_mining_suit",
        kind = "convenience",
        skills = { "MINING" },
        members = true,
        title = "Golden mining suit",
        icon_item = "LFM_GOLD_HELMET",
        hook = "Want more experience from every ore? The golden mining suit adds a bonus for each "
            .. "piece you wear.",
        why = "Each piece gives a little extra Mining experience, with a bonus for the full set. "
            .. "The golem outfits keep this bonus later on.",
        how = { "Get it from the Lava Flow Mine in Keldagrim, open after King of the Dwarves." },
        quest_how = {
            "Work towards King of the Dwarves to enter the Lava Flow Mine and earn its outfit.",
        },
        requirements = {
            skills = {
                MINING = 68,
                SMITHING = 70,
                STRENGTH = 77,
                FISHING = 10,
                HERBLORE = 31,
                AGILITY = 15,
                THIEVING = 30,
                COOKING = 22,
                FARMING = 29,
                CRAFTING = 12,
                FIREMAKING = 61,
                MAGIC = 33,
                HUNTER = 61,
                WOODCUTTING = 10,
            },
            quests = { "KING_OF_THE_DWARVES" },
        },
        require_all_levels = true,
        triggers = { { type = "training", skill = "MINING" } },
        known_when = {
            { type = "owns_category", category = 4155 },
            {
                type = "owns_any",
                items = {
                    "LFM_GOLD_HELMET",
                    "LFM_GOLD_TOP",
                    "LFM_GOLD_GLOVES",
                    "LFM_GOLD_LEGS",
                    "LFM_GOLD_BOOTS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "mining.golem_outfit",
        require_all_levels = true,
        kind = "convenience",
        skills = { "MINING" },
        members = true,
        title = "Golem outfits",
        icon_item = "TRH19_BLUE_HEAD",
        hook = "80 Mining: a golem outfit makes critical swings more likely.",
        why = "A full sapphire, emerald or ruby golem outfit raises your critical swing chance and "
            .. "keeps the golden mining suit's experience bonus. All three combine into the magic "
            .. "golem outfit for extra perks.",
        how = {
            "Make the pieces from gemstone golem fragments at an Inventor's workbench, once "
                .. "you've discovered the golem outfit blueprint.",
        },
        requirements = { skills = { MINING = 80, INVENTION = 20 } },
        triggers = { { type = "training", skill = "MINING" } },
        known_when = {
            { type = "owns_category", category = 3226 },
            { type = "owns_category", category = 3227 },
            { type = "owns_category", category = 3228 },
            { type = "owns_category", category = 3229 },
            {
                type = "owns_any",
                items = {
                    "TRH19_BLUE_HEAD",
                    "TRH19_GREEN_HEAD",
                    "TRH19_RED_HEAD",
                    "TRH19_MAGIC_HEAD",
                },
            },
        },
        priority = 2,
    },

    {
        id = "mining.taggas_corehammer",
        kind = "convenience",
        skills = { "MINING" },
        members = true,
        title = "Tagga's corehammer",
        icon_item = "EGWD_BIK_SKILLING_OFFHAND_MINING",
        hook = "80 Mining: Tagga's corehammer powers up your critical swings.",
        why = "Worn in your off-hand, it adds critical swing chance and damage while you mine.",
        how = { "Smith it at level 80 Smithing." },
        requirements = { skills = { MINING = 80, SMITHING = 80 } },
        triggers = { { type = "training", skill = "MINING" } },
        known_when = { { type = "owns_any", items = { "EGWD_BIK_SKILLING_OFFHAND_MINING" } } },
        priority = 2,
    },

    {
        require_all_levels = true,
        requirements = {
            skills = {
                CRAFTING = 8,
                MINING = 10,
                FISHING = 20,
                AGILITY = 13,
            },
        },
        title = "Varrock armour",
        id = "mining.varrock_armour",
        hook = "Varrock armour offers bonuses while mining, smelting and smithing.",
        how = { "Claim it after completing the easy Varrock achievements." },
        members = true,
        known_when = {
            {
                items = {
                    "ATVAR_BODY_EASY",
                    "ATVAR_BODY_MED",
                    "ATVAR_BODY_HARD",
                    "ATVAR_BODY_ELITE",
                },
                type = "owns_any",
            },
        },
        skills = { "MINING", "SMITHING" },
        triggers = {
            {
                type = "training",
                skill = "MINING",
            },
            {
                type = "training",
                skill = "SMITHING",
            },
        },
        why = "It can provide extra ore, bars or smithing progress. Higher achievement tiers improve which metals benefit.",
        icon_item = "ATVAR_BODY_EASY",
        priority = 2,
        kind = "convenience",
    },

    {
        id = "mining.pontifex_ring",
        require_all_levels = true,
        kind = "convenience",
        skills = { "MINING" },
        members = true,
        title = "Pontifex observation ring",
        icon_item = "QUEST_AZZANADRA_RING",
        hook = "More rockertunities means more experience, and this ring makes them turn up more "
            .. "often.",
        why = "The pontifex observation ring increases how often rockertunities appear. It also "
            .. "counts as a luck item and can be upgraded later.",
        how = {
            "Restore it at an archaeologist's workbench with level 58 Archaeology, after "
                .. "Azzanadra's Quest.",
        },
        quest_how = {
            "Look into Azzanadra's Quest, then restore the Pontifex observation ring at an archaeologist's workbench.",
        },
        requirements = {
            skills = {
                ARCHAEOLOGY = 58,
                AGILITY = 58,
                DIVINATION = 70,
                MINING = 50,
                SMITHING = 50,
            },
            quests = { "AZZANADRA" },
        },
        triggers = { { type = "training", skill = "MINING" } },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "QUEST_AZZANADRA_RING",
                    "QUEST_SENNTISTEN_RING",
                    "QUEST_EGW_FINALE_RING",
                },
            },
        },
        priority = 2,
    },

    {
        id = "mining.cape",
        kind = "convenience",
        skills = { "MINING" },
        members = true,
        title = "Mining cape",
        icon_item = "SKILLCAPE_MINING",
        hook = "99 Mining! The Mining cape gives you a chance of double ore from core rocks.",
        why = "Wearing it means some ores come in pairs, on top of everything else you use.",
        how = { "Buy it from Gadrin at the entrance to the Mining Guild." },
        requirements = { skills = { MINING = 99 } },
        triggers = { { type = "training", skill = "MINING" } },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_MINING",
                    "SKILLCAPE_MINING_TRIMMED",
                    "SKILLCAPE_MINING_RETRO",
                    "SKILLCAPE_MINING_TRIMMED_RETRO",
                },
            },
        },
        priority = 2,
    },

    -- training methods

    {
        id = "mining.method.iron",
        main_method = true,
        icon_item_id = 440,
        kind = "method",
        skills = { "MINING" },
        level_range = { 10, 19 },
        members = false,
        title = "Iron",
        hook = "Iron offers quicker experience than copper and tin.",
        why = "From level 15, mining slows down if you leave it completely idle. Clicking the rock now and then keeps it moving.",
        how = { "Look for iron in the mines south-west of Lumbridge and south-west of Varrock." },
        requirements = { skills = { MINING = 10 } },
        triggers = { { type = "level_reached", skill = "MINING", level = 10 } },
        priority = 2,
    },

    {
        id = "mining.method.coal",
        main_method = true,
        icon_item_id = 453,
        kind = "method",
        skills = { "MINING" },
        level_range = { 20, 29 },
        members = false,
        title = "Coal",
        hook = "Coal combines Mining experience with a supply for making steel bars.",
        why = "It gives more experience than copper and tin, with a useful Smithing resource to keep or sell.",
        how = { "There's coal in the mine south-west of Lumbridge and the Falador west mine." },
        requirements = { skills = { MINING = 20 } },
        triggers = { { type = "level_reached", skill = "MINING", level = 20 } },
        priority = 2,
    },

    {
        id = "mining.method.mithril",
        main_method = true,
        icon_item_id = 447,
        kind = "method",
        skills = { "MINING" },
        level_range = { 30, 39 },
        members = false,
        title = "Mithril",
        hook = "Mithril offers another way to train while gathering ore for Smithing.",
        why = "Mithril gives better experience than coal for the next ten levels.",
        how = { "Mine it at the Varrock south-east or south-west mines." },
        requirements = { skills = { MINING = 30 } },
        triggers = { { type = "level_reached", skill = "MINING", level = 30 } },
        priority = 2,
    },

    {
        id = "mining.method.adamantite_luminite",
        main_method = true,
        icon_item_id = 449,
        kind = "method",
        skills = { "MINING" },
        level_range = { 40, 49 },
        members = false,
        title = "Adamantite and luminite",
        hook = "Adamantite and luminite offer similar experience, with different uses for your ore.",
        why = "Both give similar experience, so pick whichever is closer. Luminite is also "
            .. "needed alongside runite to make rune bars later.",
        how = {
            "Rimmington mine has adamantite. For luminite, try the Dwarven luminite mine.",
        },
        requirements = { skills = { MINING = 40 } },
        triggers = { { type = "level_reached", skill = "MINING", level = 40 } },
        priority = 2,
    },

    {
        id = "mining.method.runite",
        main_method = true,
        icon_item_id = 451,
        kind = "method",
        skills = { "MINING" },
        level_range = { 50, 59 },
        members = false,
        title = "Runite",
        hook = "Runite offers an experience boost over adamantite and luminite.",
        why = "Runite is a solid jump in experience from adamantite and luminite.",
        how = {
            "The mine south-east of the Fight Arena is the best spot. The Mining Guild has "
                .. "runite too once you reach level 60.",
        },
        requirements = { skills = { MINING = 50 } },
        triggers = { { type = "level_reached", skill = "MINING", level = 50 } },
        priority = 2,
    },

    {
        id = "mining.method.orichalcite_drakolith",
        main_method = true,
        icon_item_id = 44822,
        kind = "method",
        skills = { "MINING" },
        level_range = { 60, 69 },
        members = true,
        title = "Orichalcite and drakolith",
        hook = "Orichalcite and drakolith offer two options for gathering higher-tier ore.",
        why = "Either one is a clear step up in experience from runite.",
        how = {
            "Orichalcite is in the Mining Guild. Drakolith is at the Tai Bwo Wannai and "
                .. "Heroes' Guild mines.",
        },
        requirements = { skills = { MINING = 60 } },
        triggers = { { type = "level_reached", skill = "MINING", level = 60 } },
        priority = 2,
    },

    {
        id = "mining.method.necrite_phasmatite",
        main_method = true,
        icon_item_id = 44826,
        kind = "method",
        skills = { "MINING" },
        level_range = { 70, 79 },
        members = true,
        title = "Necrite and phasmatite",
        hook = "Necrite and phasmatite offer higher-tier ore for training and Smithing.",
        why = "Both give more experience than orichalcite and drakolith. Necrite is reachable with few quests completed.",
        how = {
            "The hobgoblin mine near the Wilderness lodestone has necrite and a bank nearby. "
                .. "It's in the Wilderness, so only bring what you're happy to lose.",
        },
        requirements = { skills = { MINING = 70 } },
        triggers = { { type = "level_reached", skill = "MINING", level = 70 } },
        priority = 2,
    },

    {
        id = "mining.method.banite",
        main_method = true,
        icon_item_id = 21778,
        kind = "method",
        skills = { "MINING" },
        level_range = { 80, 88 },
        members = true,
        title = "Banite",
        hook = "Banite is another option for training while gathering higher-tier ore.",
        why = "It can bridge the levels before corrupted ore and animica become available at 89 and 90.",
        how = {
            "The Pirates' Hideout mine in the deep Wilderness has no requirements and a forge "
                .. "beside it for depositing ore. Only bring what you're happy to lose.",
        },
        requirements = { skills = { MINING = 80 } },
        triggers = { { type = "level_reached", skill = "MINING", level = 80 } },
        priority = 2,
    },

    {
        id = "mining.method.corrupted_ore",
        main_method = true,
        icon_item_id = 32262,
        kind = "method",
        skills = { "MINING" },
        level_range = { 89, 99 },
        members = true,
        title = "Corrupted ore",
        hook = "Corrupted ore offers relaxed Mining without filling your backpack with separate ores.",
        why = "It gives more experience than banite or animica, stacks in your backpack and "
            .. "doesn't use stamina, which makes it great for relaxed mining.",
        how = {
            "Mine the Seren stones in the Trahaearn district of Prifddinas. You'll need "
                .. "Plague's End done to get into the city.",
        },
        quest_how = {
            "Work towards Plague's End to open up Prifddinas and its training facilities.",
        },
        requirements = {
            skills = {
                MINING = 89,
                AGILITY = 75,
                CONSTRUCTION = 75,
                CRAFTING = 75,
                DUNGEONEERING = 75,
                HERBLORE = 75,
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
        triggers = { { type = "level_reached", skill = "MINING", level = 89 } },
        priority = 2,
    },

    {
        id = "mining.method.animica",
        main_method = true,
        icon_item_id = 44830,
        kind = "method",
        skills = { "MINING" },
        level_range = { 90, 96 },
        members = true,
        title = "Light and dark animica",
        hook = "Light and dark animica offer training that improves as your Mining level rises.",
        why = "Animica's experience gets noticeably better as your level climbs towards 99.",
        how = {
            "Light animica is at the Lletya mine and Anachronia's south-west mine. Dark "
                .. "animica is in the Anachronia swamp mine.",
        },
        requirements = { skills = { MINING = 90 } },
        triggers = { { type = "level_reached", skill = "MINING", level = 90 } },
        priority = 2,
    },

    {
        id = "mining.method.alaea_crablets",
        main_method = true,
        icon_item_id = 37773,
        kind = "method",
        skills = { "MINING" },
        level_range = { 97, 99 },
        members = true,
        title = "Alaea crablets",
        hook = "Alaea crablets offer a rare source of Mining experience on the Uncharted Isles.",
        why = "They're a rare daily resource with excellent experience while they last.",
        how = {
            "Uncharted Isles are reached from the Arc, which needs the Impressing the Locals "
                .. "quest.",
        },
        quest_how = { "Complete Impressing the Locals to start exploring the Arc." },
        requirements = {
            skills = {
                MINING = 97,
            },
            quests = { "ELR0" },
        },
        require_all_levels = true,
        triggers = { { type = "level_reached", skill = "MINING", level = 97 } },
        priority = 2,
    },

    {
        id = "mining.method.primal",
        main_method = true,
        icon_item_id = 57193,
        kind = "method",
        skills = { "MINING" },
        level_range = { 100, 120 },
        members = true,
        title = "Primal rocks",
        hook = "Primal rocks offer a higher-level Mining option in Daemonheim.",
        why = "They're the top tier of ore, and the experience keeps improving as you level "
            .. "past 100.",
        how = {
            "The promethium rocks on the Daemonheim Peninsula island have a deposit box "
                .. "nearby once you've done the medium Daemonheim achievements.",
        },
        requirements = { skills = { MINING = 100 } },
        triggers = { { type = "level_reached", skill = "MINING", level = 100 } },
        priority = 2,
    },

    -- alternative methods
    --
    -- other ways to train that stay useful across many levels, from the guide's "alternative
    -- methods" section. priority 3 so the level's main method shows first, these come up on a
    -- later session.

    {
        id = "mining.alt.shooting_stars",
        icon_item_id = 13727,
        kind = "method",
        skills = { "MINING" },
        level_range = { 10, 120 },
        members = false,
        title = "Shooting stars",
        hook = "Fancy a more relaxed way to train? Shooting stars are a great semi-AFK option.",
        why = "Lots of players can mine a crashed star together. You collect stardust as you "
            .. "go, and the star sprite left at the end gives a reward and a temporary chance "
            .. "of double ore.",
        how = {
            "Each star size needs 10 more Mining, so a size 8 star needs level 80. Smaller "
                .. "stars are always fine to mine.",
        },
        requirements = { skills = { MINING = 10 } },
        triggers = { { type = "level_reached", skill = "MINING", level = 10 } },
        priority = 3,
    },
}
