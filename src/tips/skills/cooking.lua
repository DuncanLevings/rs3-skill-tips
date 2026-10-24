-- useful items and unlocks, then main methods and alternatives in level order.
-- source access and recommendation windows: docs/artisan-coverage.md.

return {
    {
        id = "cooking.sous_chef_outfit",
        icon_item = "WOF19_SKILL_COOKING_HEAD",
        kind = "convenience",
        skills = { "COOKING" },
        members = true,
        title = "Sous chef's outfit",
        hook = "The sous chef's outfit adds experience while you cook.",
        why = "Each piece contributes, and a modified toque can sometimes produce an extra portion.",
        how = { "Complete hard Gnome Restaurant deliveries for a chance at pieces." },
        requirements = {
            skills = {
                COOKING = 29,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "COOKING",
            },
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
        icon_item = "GAUNTLETS_OF_COOKING",
        kind = "convenience",
        skills = { "COOKING" },
        members = true,
        title = "Cooking gauntlets",
        hook = "Cooking gauntlets help more of your fish reach the plate.",
        why = "Wear them to reduce burning on supported fish, including sharks and rocktail.",
        how = { "After Family Crest, ask Caleb in Catherby to change your family gauntlets." },
        requirements = {
            skills = {
                COOKING = 1,
            },
            quests = { "FAMILY_CREST" },
        },
        min_training_level = 40,
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "COOKING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "GAUNTLETS_OF_COOKING" },
            },
        },
        priority = 2,
    },

    {
        id = "cooking.cape",
        icon_item = "SKILLCAPE_COOKING",
        kind = "convenience",
        skills = { "COOKING" },
        members = true,
        title = "Cooking cape",
        hook = "The Cooking cape offers burn-free cooking.",
        why = "Wearing it stops food from burning, letting you choose ingredients without allowing for burnt batches.",
        how = { "Buy it from the head chef in the Cooks' Guild." },
        requirements = {
            skills = {
                COOKING = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "COOKING",
            },
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

    {
        id = "cooking.method.trout",
        main_method = true,
        icon_item_id = 333,
        kind = "method",
        skills = { "COOKING" },
        level_range = { 15, 27 },
        members = false,
        title = "Trout",
        hook = "Trout offers inexpensive batches for practising Cooking.",
        why = "It is easy to source, though some will burn while your level is low.",
        how = { "Try a small batch and compare the raw ingredient cost with the cooked food." },
        requirements = {
            skills = {
                COOKING = 15,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "COOKING",
                level = 15,
            },
        },
        priority = 2,
    },

    {
        id = "cooking.method.sweetcorn",
        main_method = true,
        icon_item_id = 5986,
        kind = "method",
        skills = { "COOKING" },
        level_range = { 28, 51 },
        members = true,
        title = "Sweetcorn",
        hook = "Sweetcorn offers a change from cooking fish.",
        why = "Raw sweetcorn can be bought without growing it yourself. It gives useful experience in short batches.",
        how = { "Try a small batch and compare the raw ingredient cost with the cooked food." },
        requirements = {
            skills = {
                COOKING = 28,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "COOKING",
                level = 28,
            },
        },
        priority = 2,
    },

    {
        id = "cooking.method.desert_sole",
        main_method = true,
        icon_item_id = 40293,
        kind = "method",
        skills = { "COOKING" },
        level_range = { 52, 79 },
        members = true,
        title = "Desert sole",
        hook = "Desert sole offers steady Cooking experience from Menaphos fish.",
        why = "Buying the raw fish lets you train here without the Fishing levels or city access needed to catch them.",
        how = { "Try a small batch and compare the raw ingredient cost with the cooked food." },
        requirements = {
            skills = {
                COOKING = 52,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "COOKING",
                level = 52,
            },
        },
        priority = 2,
    },

    {
        id = "cooking.method.beltfish",
        main_method = true,
        icon_item_id = 40297,
        kind = "method",
        skills = { "COOKING" },
        level_range = { 80, 89 },
        members = true,
        title = "Beltfish",
        hook = "Beltfish offers more experience per fish than desert sole.",
        why = "Burning still affects the cost at this stage, so a range and cooking gauntlets are useful to compare.",
        how = { "Try a small batch and compare the raw ingredient cost with the cooked food." },
        requirements = {
            skills = {
                COOKING = 80,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "COOKING",
                level = 80,
            },
        },
        priority = 2,
    },

    {
        id = "cooking.method.sharks",
        main_method = true,
        icon_item_id = 385,
        kind = "method",
        skills = { "COOKING" },
        level_range = { 90, 92 },
        members = false,
        title = "Sharks",
        hook = "Sharks combine Cooking training with food to keep or sell.",
        why = "Cooking gauntlets reduce burning on them, with burn-free cooking from 94 when worn.",
        how = { "Try a small batch and compare the raw ingredient cost with the cooked food." },
        requirements = {
            skills = {
                COOKING = 90,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "COOKING",
                level = 90,
            },
        },
        priority = 2,
    },

    {
        id = "cooking.method.rocktail",
        main_method = true,
        icon_item_id = 15272,
        kind = "method",
        skills = { "COOKING" },
        level_range = { 93, 94 },
        members = true,
        title = "Rocktail",
        hook = "Rocktail combines high-level Cooking experience with useful food.",
        why = "Cooking gauntlets help reduce the cost of burnt batches before your level improves.",
        how = { "Try a small batch and compare the raw ingredient cost with the cooked food." },
        requirements = {
            skills = {
                COOKING = 93,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "COOKING",
                level = 93,
            },
        },
        priority = 2,
    },

    {
        id = "cooking.method.blue_blubber_jellyfish",
        main_method = true,
        icon_item_id = 42271,
        kind = "method",
        skills = { "COOKING" },
        level_range = { 95, 120 },
        members = true,
        title = "Blue blubber jellyfish",
        hook = "Blue blubber jellyfish combines high-level Cooking with a useful food supply.",
        why = "It is valued for healing without draining adrenaline, though the raw ingredients can be expensive.",
        how = { "Try a small batch and compare the raw ingredient cost with the cooked food." },
        requirements = {
            skills = {
                COOKING = 95,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "COOKING",
                level = 95,
            },
        },
        priority = 2,
    },

    {
        id = "cooking.alt.bait_switch",
        icon_item_id = 333,
        kind = "method",
        skills = { "COOKING" },
        level_range = { 1, 120 },
        members = true,
        title = "Bait and Switch",
        hook = "Bait and Switch lets Fishing contribute to Cooking as well.",
        why = "The relic power cooks supported fish as you catch them, at reduced Cooking experience with no burning.",
        how = {
            "Look into Evil Bob's Catspaw through Archaeology, then harness its power at the monolith.",
        },
        requirements = {
            skills = {
                COOKING = 1,
                ARCHAEOLOGY = 99,
            },
            quests = { "ICS_LITTLE_HELPER" },
        },
        min_training_level = 50,
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "COOKING",
            },
        },
        priority = 3,
    },

    {
        id = "cooking.alt.wine",
        icon_item_id = 1987,
        kind = "method",
        skills = { "COOKING" },
        level_range = { 35, 79 },
        members = false,
        title = "Making wine",
        hook = "Making wine offers fast experience in short, active batches.",
        why = "Wine ferments after mixing, including while banked. Ingredient costs can add up quickly.",
        how = { "Try grapes and jugs of water, leaving time for the batch to ferment." },
        requirements = {
            skills = {
                COOKING = 35,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "COOKING",
            },
        },
        priority = 3,
    },

    {
        id = "cooking.alt.curry",
        icon_item_id = 5986,
        kind = "method",
        skills = { "COOKING" },
        level_range = { 74, 89 },
        members = true,
        title = "Cooking curry",
        hook = "Curry offers a change from cooking fish.",
        why = "At this stage it avoids burnt batches, though the ingredients may cost more than familiar fish.",
        how = { "Compare uncooked and cooked curry prices before trying a batch." },
        requirements = {
            skills = {
                COOKING = 74,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "COOKING",
            },
        },
        priority = 3,
    },
}
