-- herblore tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field

return {
    -- useful items and unlocks
    {
        id = "herblore.botanist_outfit",
        kind = "convenience",
        skills = { "HERBLORE" },
        members = true,
        title = "Botanist's outfit",
        icon_item = "WOF19_SKILL_HERBLORE_HEAD",
        hook = "The botanist's outfit adds experience while mixing potions.",
        why = "Each piece contributes, and a modified mask can sometimes produce an extra potion.",
        how = {
            "Look at the Flash Powder Factory rewards sold by Brian O'Richard.",
        },
        requirements = {
            skills = { AGILITY = 75, HERBLORE = 50, THIEVING = 75 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "HERBLORE" },
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
        kind = "convenience",
        skills = { "HERBLORE" },
        members = true,
        title = "Factory outfit",
        icon_item = "RDEN2_HELM",
        hook = "The factory outfit can help your ingredients go further.",
        why = "Wearing three pieces gives a chance at an extra dose. The full set also grants "
            .. "experience for unfinished potions.",
        how = {
            "Look at the Flash Powder Factory rewards sold by Brian O'Richard.",
        },
        requirements = {
            skills = { AGILITY = 75, HERBLORE = 50, THIEVING = 75 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "HERBLORE" },
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
        kind = "general",
        skills = { "HERBLORE" },
        members = true,
        title = "Scroll of cleansing",
        icon_item_id = 255,
        hook = "The scroll of cleansing can save ingredients on potion batches.",
        why = "Learning it permanently adds chances to save a secondary ingredient and mix faster.",
        how = {
            "Look in the Dungeoneering rewards shop.",
        },
        requirements = {
            skills = { DUNGEONEERING = 49, HERBLORE = 49 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "HERBLORE" },
        },
        priority = 2,
    },

    {
        id = "herblore.cape",
        kind = "convenience",
        skills = { "HERBLORE" },
        members = true,
        title = "Herblore cape",
        icon_item = "SKILLCAPE_HERBLORE",
        hook = "The Herblore cape offers faster herb cleaning.",
        why = "Its Clean option cleans every grimy herb in your backpack at once.",
        how = {
            "Buy it from Kaqemeex in Taverley.",
        },
        requirements = {
            skills = { HERBLORE = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "HERBLORE" },
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
        kind = "convenience",
        skills = { "HERBLORE" },
        members = true,
        title = "Herblore master cape",
        icon_item = "SKILLCAPE_120_HERBLORE",
        hook = "The Herblore master cape makes overload batches go further.",
        why = "Its batch recipes save ingredients when making supported overloads, including elder "
            .. "overloads.",
        how = {
            "Buy it from Kaqemeex in Taverley and look at the batch recipes.",
        },
        requirements = {
            skills = { HERBLORE = 120 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "HERBLORE" },
        },
        known_when = {
            { type = "owns_any", items = { "SKILLCAPE_120_HERBLORE" } },
        },
        priority = 2,
    },

    -- training methods, one main method per level bracket
    {
        id = "herblore.method.strength_potions",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 12, 25 },
        main_method = true,
        title = "Strength potions",
        icon_item_id = 253,
        hook = "Making strength potions combines Herblore training with basic Strength supplies.",
        why = "Keep the output for later or compare its sale value with the ingredients before "
            .. "choosing a batch.",
        how = {
            "Check the potion recipe and try a small batch before stocking up.",
        },
        requirements = {
            skills = { HERBLORE = 12 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "HERBLORE", level = 12 },
        },
        priority = 2,
    },

    {
        id = "herblore.method.energy_potions",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 26, 37 },
        main_method = true,
        title = "Energy potions",
        icon_item_id = 255,
        hook = "Making energy potions combines Herblore training with supplies for restoring run "
            .. "energy.",
        why = "Keep the output for later or compare its sale value with the ingredients before "
            .. "choosing a batch.",
        how = {
            "Check the potion recipe and try a small batch before stocking up.",
        },
        requirements = {
            skills = { HERBLORE = 26 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "HERBLORE", level = 26 },
        },
        priority = 2,
    },

    {
        id = "herblore.method.prayer_potions",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 38, 54 },
        main_method = true,
        title = "Prayer potions",
        icon_item_id = 257,
        hook = "Making prayer potions combines Herblore training with supplies for restoring "
            .. "prayer.",
        why = "Keep the output for later or compare its sale value with the ingredients before "
            .. "choosing a batch.",
        how = {
            "Check the potion recipe and try a small batch before stocking up.",
        },
        requirements = {
            skills = { HERBLORE = 38 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "HERBLORE", level = 38 },
        },
        priority = 2,
    },

    {
        id = "herblore.method.super_strength_potions",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 55, 62 },
        main_method = true,
        title = "Super strength potions",
        icon_item_id = 263,
        hook = "Making super strength potions combines Herblore training with stronger melee "
            .. "supplies.",
        why = "Keep the output for later or compare its sale value with the ingredients before "
            .. "choosing a batch.",
        how = {
            "Check the potion recipe and try a small batch before stocking up.",
        },
        requirements = {
            skills = { HERBLORE = 55 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "HERBLORE", level = 55 },
        },
        priority = 2,
    },

    {
        id = "herblore.method.super_restore_potions",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 63, 71 },
        main_method = true,
        title = "Super restore potions",
        icon_item_id = 3000,
        hook = "Making super restore potions combines Herblore training with supplies for "
            .. "restoring drained stats and prayer.",
        why = "Keep the output for later or compare its sale value with the ingredients before "
            .. "choosing a batch.",
        how = {
            "Check the potion recipe and try a small batch before stocking up.",
        },
        requirements = {
            skills = { HERBLORE = 63 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "HERBLORE", level = 63 },
        },
        priority = 2,
    },

    {
        id = "herblore.method.super_ranging_potions",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 72, 80 },
        main_method = true,
        title = "Super ranging potions",
        icon_item_id = 267,
        hook = "Making super ranging potions combines Herblore training with Ranged supplies or "
            .. "ingredients for later potions.",
        why = "Keep the output for later or compare its sale value with the ingredients before "
            .. "choosing a batch.",
        how = {
            "Check the potion recipe and try a small batch before stocking up.",
        },
        requirements = {
            skills = { HERBLORE = 72 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "HERBLORE", level = 72 },
        },
        priority = 2,
    },

    {
        id = "herblore.method.saradomin_brews",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 81, 87 },
        main_method = true,
        title = "Saradomin brews",
        icon_item_id = 2998,
        hook = "Making saradomin brews combines Herblore training with healing supplies for harder "
            .. "encounters.",
        why = "Keep the output for later or compare its sale value with the ingredients before "
            .. "choosing a batch.",
        how = {
            "Check the potion recipe and try a small batch before stocking up.",
        },
        requirements = {
            skills = { HERBLORE = 81 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "HERBLORE", level = 81 },
        },
        priority = 2,
    },

    {
        id = "herblore.method.extremes",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 88, 95 },
        main_method = true,
        title = "Extreme potions",
        icon_item_id = 261,
        hook = "Extreme potions offer experience while building supplies for later recipes.",
        why = "Different types unlock across these levels, and several become ingredients for "
            .. "overloads.",
        how = {
            "Inspect the Herblore recipes and compare the materials before choosing a batch.",
        },
        requirements = {
            skills = { HERBLORE = 88 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "HERBLORE", level = 88 },
        },
        priority = 2,
    },

    {
        id = "herblore.method.overloads",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 96, 98 },
        main_method = true,
        title = "Making overloads",
        icon_item_id = 269,
        hook = "Making overloads combines Herblore training with a lasting combat supply goal.",
        why = "They use several extreme potions and cannot be traded, so the finished supplies are "
            .. "for your own account.",
        how = {
            "Look at the overload recipe and plan a small batch around supplies you expect to use.",
        },
        requirements = {
            skills = { HERBLORE = 96 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "HERBLORE", level = 96 },
        },
        priority = 2,
    },

    {
        id = "herblore.method.poison_bombs",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 99, 100 },
        main_method = true,
        title = "Poison bombs",
        icon_item_id = 259,
        hook = "Poison bombs offer a high-level Herblore project.",
        why = "They give experience in larger batches, but the upfront ingredient cost is worth "
            .. "comparing carefully.",
        how = {
            "Inspect the recipe and price a small batch before investing in supplies.",
        },
        requirements = {
            skills = { HERBLORE = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "HERBLORE", level = 99 },
        },
        priority = 2,
    },

    {
        id = "herblore.method.sticky_bombs",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 101, 106 },
        main_method = true,
        title = "Sticky bombs",
        icon_item_id = 265,
        hook = "Sticky bombs offer a high-level Herblore project.",
        why = "They give experience in larger batches, but the upfront ingredient cost is worth "
            .. "comparing carefully.",
        how = {
            "Inspect the recipe and price a small batch before investing in supplies.",
        },
        requirements = {
            skills = { HERBLORE = 101 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "HERBLORE", level = 101 },
        },
        priority = 2,
    },

    {
        id = "herblore.method.vulnerability_bombs",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 107, 117 },
        main_method = true,
        title = "Vulnerability bombs",
        icon_item_id = 267,
        hook = "Vulnerability bombs offer a high-level Herblore project.",
        why = "They give experience in larger batches, but the upfront ingredient cost is worth "
            .. "comparing carefully.",
        how = {
            "Inspect the recipe and price a small batch before investing in supplies.",
        },
        requirements = {
            skills = { HERBLORE = 107 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "HERBLORE", level = 107 },
        },
        priority = 2,
    },

    {
        id = "herblore.method.powerbursts_of_feats",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 118, 120 },
        main_method = true,
        title = "Powerbursts of feats",
        icon_item_id = 269,
        hook = "Powerbursts of feats offer a high-level Herblore project.",
        why = "They give experience in larger batches, but the upfront ingredient cost is worth "
            .. "comparing carefully.",
        how = {
            "Inspect the recipe and price a small batch before investing in supplies.",
        },
        requirements = {
            skills = { HERBLORE = 118 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "HERBLORE", level = 118 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "herblore.alt.tar",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 44, 69 },
        title = "Making harralander tar",
        icon_item_id = 255,
        hook = "Harralander tar offers longer batches than many potion recipes.",
        why = "Stackable swamp tar leaves room for more herbs, reducing how often you bank.",
        how = {
            "Try harralander and swamp tar with a pestle and mortar from your tool belt.",
        },
        requirements = {
            skills = { HERBLORE = 44 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "HERBLORE" },
        },
        priority = 3,
    },

    {
        id = "herblore.alt.iaia",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 75, 120 },
        title = "Dream of Iaia",
        icon_item_id = 2481,
        hook = "The Dream of Iaia offers relaxed Herblore experience between other activities.",
        why = "Its apothecary uses Anachronia base camp resources. Stored experience limits each "
            .. "visit.",
        how = {
            "After Extinction, look for the apothecary station in the Dream of Iaia.",
        },
        quest_how = {
            "Work towards Extinction to open up the Dream of Iaia and its associated skilling "
                .. "activities.",
        },
        requirements = {
            skills = {
                AGILITY = 65,
                ARCHAEOLOGY = 74,
                CRAFTING = 85,
                DIVINATION = 70,
                HERBLORE = 75,
                INVENTION = 85,
                MAGIC = 74,
                MINING = 50,
                RUNECRAFTING = 85,
                SLAYER = 75,
                SMITHING = 85,
            },
            quests = { "EGW_FINALE" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "HERBLORE" },
        },
        priority = 3,
    },

    {
        id = "herblore.alt.primal",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 90, 119 },
        title = "Primal extract",
        icon_item_id = 48966,
        hook = "Primal extract offers another way to train Herblore without mixing combat potions.",
        why = "Fruit pulp becomes more extract as your level rises, changing the balance of time "
            .. "and material cost.",
        how = {
            "Compare primal fruit pulp and extract prices before preparing a batch.",
        },
        requirements = {
            skills = { HERBLORE = 90 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "HERBLORE" },
        },
        priority = 3,
    },

    {
        id = "herblore.alt.combination",
        kind = "method",
        skills = { "HERBLORE" },
        members = true,
        level_range = { 91, 119 },
        title = "Combination potions",
        icon_item_id = 2481,
        hook = "Combination potions offer another use for potions you already make.",
        why = "They combine effects in a crystal flask. More ingredients mean shorter inventories "
            .. "and more frequent banking.",
        how = {
            "After Plague's End, inspect the Meilyr recipes; some later recipes need separate "
                .. "unlocks.",
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
                HERBLORE = 91,
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
            { type = "training", skill = "HERBLORE" },
        },
        priority = 3,
    },
}
