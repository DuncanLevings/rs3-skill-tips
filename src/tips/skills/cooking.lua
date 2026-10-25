-- cooking tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field

return {
    -- useful items and unlocks
    {
        id = "cooking.sous_chef_outfit",
        kind = "convenience",
        skills = { "COOKING" },
        members = true,
        title = "Sous chef's outfit",
        icon_item = "WOF19_SKILL_COOKING_HEAD",
        hook = "The sous chef's outfit adds experience while you cook.",
        why = "Each piece contributes, and a modified toque can sometimes produce an extra "
            .. "portion.",
        how = {
            "Complete hard Gnome Restaurant deliveries for a chance at pieces.",
        },
        requirements = {
            skills = { COOKING = 29 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "COOKING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH58_COOKING_HEAD_ADDON",
                    "TRH58_COOKING_HEAD_UPGRADED",
                    "WOF19_SKILL_COOKING_FEET",
                    "WOF19_SKILL_COOKING_HANDS",
                    "WOF19_SKILL_COOKING_HEAD",
                    "WOF19_SKILL_COOKING_LEGS",
                    "WOF19_SKILL_COOKING_TORSO",
                },
            },
        },
        priority = 2,
    },

    {
        id = "cooking.cooking_gauntlets",
        kind = "convenience",
        skills = { "COOKING" },
        members = true,
        min_training_level = 40,
        title = "Cooking gauntlets",
        icon_item = "GAUNTLETS_OF_COOKING",
        hook = "Cooking gauntlets help more of your fish reach the plate.",
        why = "Wear them to reduce burning on supported fish, including sharks and rocktail.",
        how = {
            "After Family Crest, ask Caleb in Catherby to change your family gauntlets.",
        },
        quest_how = {
            "Complete Family Crest, then ask about the different gauntlet enchantments.",
        },
        requirements = {
            skills = { COOKING = 1, CRAFTING = 40, MAGIC = 59, MINING = 40, SMITHING = 40 },
            quests = { "FAMILY_CREST" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "COOKING" },
        },
        known_when = {
            { type = "owns_any", items = { "GAUNTLETS_OF_COOKING" } },
        },
        priority = 2,
    },

    {
        id = "cooking.cape",
        kind = "convenience",
        skills = { "COOKING" },
        members = true,
        title = "Cooking cape",
        icon_item = "SKILLCAPE_COOKING",
        hook = "The Cooking cape offers burn-free cooking.",
        why = "Wearing it stops food from burning, letting you choose ingredients without allowing "
            .. "for burnt batches.",
        how = {
            "Buy it from the head chef in the Cooks' Guild.",
        },
        requirements = {
            skills = { COOKING = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "COOKING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_COOKING",
                    "SKILLCAPE_COOKING_HOODED",
                    "SKILLCAPE_COOKING_HOODED_RETRO",
                    "SKILLCAPE_COOKING_RETRO",
                    "SKILLCAPE_COOKING_TRIMMED",
                    "SKILLCAPE_COOKING_TRIMMED_HOODED",
                    "SKILLCAPE_COOKING_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_COOKING_TRIMMED_RETRO",
                    "SKILLCAPE_INVERTED_COOKING_HOODED",
                    "SKILLCAPE_INVERTED_COOKING_TRIMMED_HOODED",
                },
            },
        },
        priority = 2,
    },

    -- training methods, one main method per level bracket
    {
        id = "cooking.method.trout",
        kind = "method",
        skills = { "COOKING" },
        members = false,
        level_range = { 15, 27 },
        main_method = true,
        title = "Trout",
        icon_item_id = 333,
        hook = "Trout offers inexpensive batches for practising Cooking.",
        why = "It is easy to source, though some will burn while your level is low.",
        how = {
            "Try a small batch and compare the raw ingredient cost with the cooked food.",
        },
        requirements = {
            skills = { COOKING = 15 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "COOKING", level = 15 },
        },
        priority = 2,
    },

    {
        id = "cooking.method.sweetcorn",
        kind = "method",
        skills = { "COOKING" },
        members = true,
        level_range = { 28, 51 },
        main_method = true,
        title = "Sweetcorn",
        icon_item_id = 5986,
        hook = "Sweetcorn offers a change from cooking fish.",
        why = "Raw sweetcorn can be bought without growing it yourself. It gives useful experience "
            .. "in short batches.",
        how = {
            "Try a small batch and compare the raw ingredient cost with the cooked food.",
        },
        requirements = {
            skills = { COOKING = 28 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "COOKING", level = 28 },
        },
        priority = 2,
    },

    {
        id = "cooking.method.desert_sole",
        kind = "method",
        skills = { "COOKING" },
        members = true,
        level_range = { 52, 79 },
        main_method = true,
        title = "Desert sole",
        icon_item_id = 40293,
        hook = "Desert sole offers steady Cooking experience from Menaphos fish.",
        why = "Buying the raw fish lets you train here without the Fishing levels or city access "
            .. "needed to catch them.",
        how = {
            "Try a small batch and compare the raw ingredient cost with the cooked food.",
        },
        requirements = {
            skills = { COOKING = 52 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "COOKING", level = 52 },
        },
        priority = 2,
    },

    {
        id = "cooking.method.beltfish",
        kind = "method",
        skills = { "COOKING" },
        members = true,
        level_range = { 80, 89 },
        main_method = true,
        title = "Beltfish",
        icon_item_id = 40297,
        hook = "Beltfish offers more experience per fish than desert sole.",
        why = "Burning still affects the cost at this stage, so a range and cooking gauntlets are "
            .. "useful to compare.",
        how = {
            "Try a small batch and compare the raw ingredient cost with the cooked food.",
        },
        requirements = {
            skills = { COOKING = 80 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "COOKING", level = 80 },
        },
        priority = 2,
    },

    {
        id = "cooking.method.sharks",
        kind = "method",
        skills = { "COOKING" },
        members = false,
        level_range = { 90, 92 },
        main_method = true,
        title = "Sharks",
        icon_item_id = 385,
        hook = "Sharks combine Cooking training with food to keep or sell.",
        why = "Cooking gauntlets reduce burning on them, with burn-free cooking from 94 when worn.",
        how = {
            "Try a small batch and compare the raw ingredient cost with the cooked food.",
        },
        requirements = {
            skills = { COOKING = 90 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "COOKING", level = 90 },
        },
        priority = 2,
    },

    {
        id = "cooking.method.rocktail",
        kind = "method",
        skills = { "COOKING" },
        members = true,
        level_range = { 93, 94 },
        main_method = true,
        title = "Rocktail",
        icon_item_id = 15272,
        hook = "Rocktail combines high-level Cooking experience with useful food.",
        why = "Cooking gauntlets help reduce the cost of burnt batches before your level improves.",
        how = {
            "Try a small batch and compare the raw ingredient cost with the cooked food.",
        },
        requirements = {
            skills = { COOKING = 93 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "COOKING", level = 93 },
        },
        priority = 2,
    },

    {
        id = "cooking.method.blue_blubber_jellyfish",
        kind = "method",
        skills = { "COOKING" },
        members = true,
        level_range = { 95, 120 },
        main_method = true,
        title = "Blue blubber jellyfish",
        icon_item_id = 42271,
        hook = "Blue blubber jellyfish combines high-level Cooking with a useful food supply.",
        why = "It is valued for healing without draining adrenaline, though the raw ingredients "
            .. "can be expensive.",
        how = {
            "Try a small batch and compare the raw ingredient cost with the cooked food.",
        },
        requirements = {
            skills = { COOKING = 95 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "COOKING", level = 95 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "cooking.alt.bait_switch",
        kind = "method",
        skills = { "COOKING" },
        members = true,
        level_range = { 1, 120 },
        min_training_level = 50,
        title = "Bait and Switch",
        icon_item_id = 333,
        hook = "Bait and Switch lets Fishing contribute to Cooking as well.",
        why = "The relic power cooks supported fish as you catch them, at reduced Cooking "
            .. "experience with no burning.",
        how = {
            "Look into Evil Bob's Catspaw through Archaeology, then harness its power at the "
                .. "monolith.",
        },
        quest_how = {
            "Complete Icthlarin's Little Helper, then look into Evil Bob's Catspaw through "
                .. "Archaeology.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 99, COOKING = 1 },
            quests = { "ICS_LITTLE_HELPER" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "COOKING" },
        },
        priority = 3,
    },

    {
        id = "cooking.alt.wine",
        kind = "method",
        skills = { "COOKING" },
        members = false,
        level_range = { 35, 79 },
        title = "Making wine",
        icon_item_id = 1987,
        hook = "Making wine offers fast experience in short, active batches.",
        why = "Wine ferments after mixing, including while banked. Ingredient costs can add up "
            .. "quickly.",
        how = {
            "Try grapes and jugs of water, leaving time for the batch to ferment.",
        },
        requirements = {
            skills = { COOKING = 35 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "COOKING" },
        },
        priority = 3,
    },

    {
        id = "cooking.alt.curry",
        kind = "method",
        skills = { "COOKING" },
        members = true,
        level_range = { 74, 89 },
        title = "Cooking curry",
        icon_item_id = 5986,
        hook = "Curry offers a change from cooking fish.",
        why = "At this stage it avoids burnt batches, though the ingredients may cost more than "
            .. "familiar fish.",
        how = {
            "Compare uncooked and cooked curry prices before trying a batch.",
        },
        requirements = {
            skills = { COOKING = 74 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "COOKING" },
        },
        priority = 3,
    },
}
