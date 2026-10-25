-- useful items and unlocks, then main methods and alternatives in level order.
-- source access and recommendation windows: docs/artisan-coverage.md.

return {
    {
        id = "herblore.botanist_outfit",
        icon_item = "WOF19_SKILL_HERBLORE_HEAD",
        kind = "convenience",
        skills = { "HERBLORE" },
        members = true,
        title = "Botanist's outfit",
        hook = "The botanist's outfit adds experience while mixing potions.",
        why = "Each piece contributes, and a modified mask can sometimes produce an extra potion.",
        how = { "Look at the Flash Powder Factory rewards sold by Brian O'Richard." },
        requirements = {
            skills = {
                HERBLORE = 50,
                AGILITY = 75,
                THIEVING = 75,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "HERBLORE",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH58_HERBLORE_HEAD_ADDON",
                    "TRH58_HERBLORE_HEAD_UPGRADED",
                    "WOF19_SKILL_HERBLORE_FEET",
                    "WOF19_SKILL_HERBLORE_HANDS",
                    "WOF19_SKILL_HERBLORE_HEAD",
                    "WOF19_SKILL_HERBLORE_LEGS",
                    "WOF19_SKILL_HERBLORE_TORSO",
                },
            },
        },
        priority = 2,
    },

    {
        id = "herblore.factory_outfit",
        icon_item = "RDEN2_HELM",
        kind = "convenience",
        skills = { "HERBLORE" },
        members = true,
        title = "Factory outfit",
        hook = "The factory outfit can help your ingredients go further.",
        why = "Wearing three pieces gives a chance at an extra dose. The full set also grants experience for unfinished potions.",
        how = { "Look at the Flash Powder Factory rewards sold by Brian O'Richard." },
        requirements = {
            skills = {
                HERBLORE = 50,
                AGILITY = 75,
                THIEVING = 75,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "HERBLORE",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "RDEN2_BODY", "RDEN2_BOOTS", "RDEN2_GLOVES", "RDEN2_HELM", "RDEN2_LEGS" },
            },
        },
        priority = 2,
    },

    {
        id = "herblore.cleansing",
        icon_item_id = 255,
        kind = "general",
        skills = { "HERBLORE" },
        members = true,
        title = "Scroll of cleansing",
        hook = "The scroll of cleansing can save ingredients on potion batches.",
        why = "Learning it permanently adds chances to save a secondary ingredient and mix faster.",
        how = { "Look in the Dungeoneering rewards shop." },
        requirements = {
            skills = {
                HERBLORE = 49,
                DUNGEONEERING = 49,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "HERBLORE",
            },
        },
        priority = 2,
    },

    {
        id = "herblore.cape",
        icon_item = "SKILLCAPE_HERBLORE",
        kind = "convenience",
        skills = { "HERBLORE" },
        members = true,
        title = "Herblore cape",
        hook = "The Herblore cape offers faster herb cleaning.",
        why = "Its Clean option cleans every grimy herb in your backpack at once.",
        how = { "Buy it from Kaqemeex in Taverley." },
        requirements = {
            skills = {
                HERBLORE = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "HERBLORE",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_120_HERBLORE",
                    "SKILLCAPE_HERBLORE",
                    "SKILLCAPE_HERBLORE_HOODED",
                    "SKILLCAPE_HERBLORE_HOODED_RETRO",
                    "SKILLCAPE_HERBLORE_RETRO",
                    "SKILLCAPE_HERBLORE_TRIMMED",
                    "SKILLCAPE_HERBLORE_TRIMMED_HOODED",
                    "SKILLCAPE_HERBLORE_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_HERBLORE_TRIMMED_RETRO",
                    "SKILLCAPE_INVERTED_HERBLORE_HOODED",
                    "SKILLCAPE_INVERTED_HERBLORE_TRIMMED_HOODED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "herblore.master_cape",
        icon_item = "SKILLCAPE_120_HERBLORE",
        kind = "convenience",
        skills = { "HERBLORE" },
        members = true,
        title = "Herblore master cape",
        hook = "The Herblore master cape makes overload batches go further.",
        why = "Its batch recipes save ingredients when making supported overloads, including elder overloads.",
        how = { "Buy it from Kaqemeex in Taverley and look at the batch recipes." },
        requirements = {
            skills = {
                HERBLORE = 120,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "HERBLORE",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "SKILLCAPE_120_HERBLORE" },
            },
        },
        priority = 2,
    },

    {
        id = "herblore.method.strength_potions",
        main_method = true,
        icon_item_id = 253,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 12, 25 },
        members = true,
        title = "Strength potions",
        hook = "Making strength potions combines Herblore training with basic Strength supplies.",
        why = "Keep the output for later or compare its sale value with the ingredients before choosing a batch.",
        how = { "Check the potion recipe and try a small batch before stocking up." },
        requirements = {
            skills = {
                HERBLORE = 12,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HERBLORE",
                level = 12,
            },
        },
        priority = 2,
    },

    {
        id = "herblore.method.energy_potions",
        main_method = true,
        icon_item_id = 255,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 26, 37 },
        members = true,
        title = "Energy potions",
        hook = "Making energy potions combines Herblore training with supplies for restoring run energy.",
        why = "Keep the output for later or compare its sale value with the ingredients before choosing a batch.",
        how = { "Check the potion recipe and try a small batch before stocking up." },
        requirements = {
            skills = {
                HERBLORE = 26,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HERBLORE",
                level = 26,
            },
        },
        priority = 2,
    },

    {
        id = "herblore.method.prayer_potions",
        main_method = true,
        icon_item_id = 257,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 38, 54 },
        members = true,
        title = "Prayer potions",
        hook = "Making prayer potions combines Herblore training with supplies for restoring prayer.",
        why = "Keep the output for later or compare its sale value with the ingredients before choosing a batch.",
        how = { "Check the potion recipe and try a small batch before stocking up." },
        requirements = {
            skills = {
                HERBLORE = 38,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HERBLORE",
                level = 38,
            },
        },
        priority = 2,
    },

    {
        id = "herblore.method.super_strength_potions",
        main_method = true,
        icon_item_id = 263,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 55, 62 },
        members = true,
        title = "Super strength potions",
        hook = "Making super strength potions combines Herblore training with stronger melee supplies.",
        why = "Keep the output for later or compare its sale value with the ingredients before choosing a batch.",
        how = { "Check the potion recipe and try a small batch before stocking up." },
        requirements = {
            skills = {
                HERBLORE = 55,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HERBLORE",
                level = 55,
            },
        },
        priority = 2,
    },

    {
        id = "herblore.method.super_restore_potions",
        main_method = true,
        icon_item_id = 3000,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 63, 71 },
        members = true,
        title = "Super restore potions",
        hook = "Making super restore potions combines Herblore training with supplies for restoring drained stats and prayer.",
        why = "Keep the output for later or compare its sale value with the ingredients before choosing a batch.",
        how = { "Check the potion recipe and try a small batch before stocking up." },
        requirements = {
            skills = {
                HERBLORE = 63,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HERBLORE",
                level = 63,
            },
        },
        priority = 2,
    },

    {
        id = "herblore.method.super_ranging_potions",
        main_method = true,
        icon_item_id = 267,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 72, 80 },
        members = true,
        title = "Super ranging potions",
        hook = "Making super ranging potions combines Herblore training with Ranged supplies or ingredients for later potions.",
        why = "Keep the output for later or compare its sale value with the ingredients before choosing a batch.",
        how = { "Check the potion recipe and try a small batch before stocking up." },
        requirements = {
            skills = {
                HERBLORE = 72,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HERBLORE",
                level = 72,
            },
        },
        priority = 2,
    },

    {
        id = "herblore.method.saradomin_brews",
        main_method = true,
        icon_item_id = 2998,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 81, 87 },
        members = true,
        title = "Saradomin brews",
        hook = "Making saradomin brews combines Herblore training with healing supplies for harder encounters.",
        why = "Keep the output for later or compare its sale value with the ingredients before choosing a batch.",
        how = { "Check the potion recipe and try a small batch before stocking up." },
        requirements = {
            skills = {
                HERBLORE = 81,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HERBLORE",
                level = 81,
            },
        },
        priority = 2,
    },

    {
        id = "herblore.method.extremes",
        main_method = true,
        icon_item_id = 261,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 88, 95 },
        members = true,
        title = "Extreme potions",
        hook = "Extreme potions offer experience while building supplies for later recipes.",
        why = "Different types unlock across these levels, and several become ingredients for overloads.",
        how = { "Inspect the Herblore recipes and compare the materials before choosing a batch." },
        requirements = {
            skills = {
                HERBLORE = 88,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HERBLORE",
                level = 88,
            },
        },
        priority = 2,
    },

    {
        id = "herblore.method.overloads",
        main_method = true,
        icon_item_id = 269,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 96, 98 },
        members = true,
        title = "Making overloads",
        hook = "Making overloads combines Herblore training with a lasting combat supply goal.",
        why = "They use several extreme potions and cannot be traded, so the finished supplies are for your own account.",
        how = {
            "Look at the overload recipe and plan a small batch around supplies you expect to use.",
        },
        requirements = {
            skills = {
                HERBLORE = 96,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HERBLORE",
                level = 96,
            },
        },
        priority = 2,
    },

    {
        id = "herblore.method.poison_bombs",
        main_method = true,
        icon_item_id = 259,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 99, 100 },
        members = true,
        title = "Poison bombs",
        hook = "Poison bombs offer a high-level Herblore project.",
        why = "They give experience in larger batches, but the upfront ingredient cost is worth comparing carefully.",
        how = { "Inspect the recipe and price a small batch before investing in supplies." },
        requirements = {
            skills = {
                HERBLORE = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HERBLORE",
                level = 99,
            },
        },
        priority = 2,
    },

    {
        id = "herblore.method.sticky_bombs",
        main_method = true,
        icon_item_id = 265,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 101, 106 },
        members = true,
        title = "Sticky bombs",
        hook = "Sticky bombs offer a high-level Herblore project.",
        why = "They give experience in larger batches, but the upfront ingredient cost is worth comparing carefully.",
        how = { "Inspect the recipe and price a small batch before investing in supplies." },
        requirements = {
            skills = {
                HERBLORE = 101,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HERBLORE",
                level = 101,
            },
        },
        priority = 2,
    },

    {
        id = "herblore.method.vulnerability_bombs",
        main_method = true,
        icon_item_id = 267,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 107, 117 },
        members = true,
        title = "Vulnerability bombs",
        hook = "Vulnerability bombs offer a high-level Herblore project.",
        why = "They give experience in larger batches, but the upfront ingredient cost is worth comparing carefully.",
        how = { "Inspect the recipe and price a small batch before investing in supplies." },
        requirements = {
            skills = {
                HERBLORE = 107,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HERBLORE",
                level = 107,
            },
        },
        priority = 2,
    },

    {
        id = "herblore.method.powerbursts_of_feats",
        main_method = true,
        icon_item_id = 269,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 118, 120 },
        members = true,
        title = "Powerbursts of feats",
        hook = "Powerbursts of feats offer a high-level Herblore project.",
        why = "They give experience in larger batches, but the upfront ingredient cost is worth comparing carefully.",
        how = { "Inspect the recipe and price a small batch before investing in supplies." },
        requirements = {
            skills = {
                HERBLORE = 118,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "HERBLORE",
                level = 118,
            },
        },
        priority = 2,
    },

    {
        id = "herblore.alt.tar",
        icon_item_id = 255,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 44, 69 },
        members = true,
        title = "Making harralander tar",
        hook = "Harralander tar offers longer batches than many potion recipes.",
        why = "Stackable swamp tar leaves room for more herbs, reducing how often you bank.",
        how = { "Try harralander and swamp tar with a pestle and mortar from your tool belt." },
        requirements = {
            skills = {
                HERBLORE = 44,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "HERBLORE",
            },
        },
        priority = 3,
    },

    {
        id = "herblore.alt.iaia",
        icon_item_id = 2481,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 75, 120 },
        members = true,
        title = "Dream of Iaia",
        hook = "The Dream of Iaia offers relaxed Herblore experience between other activities.",
        why = "Its apothecary uses Anachronia base camp resources. Stored experience limits each visit.",
        how = { "After Extinction, look for the apothecary station in the Dream of Iaia." },
        quest_how = {
            "Work towards Extinction to open up the Dream of Iaia and its associated skilling activities.",
        },
        requirements = {
            skills = {
                HERBLORE = 75,
                AGILITY = 65,
                ARCHAEOLOGY = 74,
                DIVINATION = 70,
                MINING = 50,
                SMITHING = 85,
                MAGIC = 74,
                SLAYER = 75,
                CRAFTING = 85,
                RUNECRAFTING = 85,
                INVENTION = 85,
            },
            quests = { "EGW_FINALE" },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "HERBLORE",
            },
        },
        priority = 3,
    },

    {
        id = "herblore.alt.primal",
        icon_item_id = 48966,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 90, 119 },
        members = true,
        title = "Primal extract",
        hook = "Primal extract offers another way to train Herblore without mixing combat potions.",
        why = "Fruit pulp becomes more extract as your level rises, changing the balance of time and material cost.",
        how = { "Compare primal fruit pulp and extract prices before preparing a batch." },
        requirements = {
            skills = {
                HERBLORE = 90,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "HERBLORE",
            },
        },
        priority = 3,
    },

    {
        id = "herblore.alt.combination",
        icon_item_id = 2481,
        kind = "method",
        skills = { "HERBLORE" },
        level_range = { 91, 119 },
        members = true,
        title = "Combination potions",
        hook = "Combination potions offer another use for potions you already make.",
        why = "They combine effects in a crystal flask. More ingredients mean shorter inventories and more frequent banking.",
        how = {
            "After Plague's End, inspect the Meilyr recipes; some later recipes need separate unlocks.",
        },
        quest_how = {
            "Work towards Plague's End to open up Prifddinas and its training facilities.",
        },
        requirements = {
            skills = {
                HERBLORE = 91,
                AGILITY = 75,
                CONSTRUCTION = 75,
                CRAFTING = 75,
                DUNGEONEERING = 75,
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
                skill = "HERBLORE",
            },
        },
        priority = 3,
    },
}
