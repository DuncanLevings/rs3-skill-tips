-- useful equipment and unlocks, then main methods and alternatives in level order.
-- access and recommendation-window evidence: docs/support-coverage.md.

return {
    {
        id = "summoning.shaman_outfit",
        icon_item = "WOF51_SKILL_SUMMONING_HEAD",
        kind = "convenience",
        skills = { "SUMMONING" },
        members = true,
        title = "Shaman's outfit",
        hook = "The Shaman's outfit adds experience while infusing pouches.",
        why = "Each piece contributes, and a modified headdress can sometimes save a charm.",
        how = {
            "Earn Blessings of the Wolf at the Shrine of Inanna, then visit Pikkenflix's reward shop.",
        },
        requirements = {
            skills = {
                SUMMONING = 1,
            },
        },
        min_training_level = 20,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH28_SUMMONING_HEAD_ADDON",
                    "TRH28_SUMMONING_HEAD_UPGRADED",
                    "WOF51_SKILL_SUMMONING_BODY",
                    "WOF51_SKILL_SUMMONING_BOOTS",
                    "WOF51_SKILL_SUMMONING_GLOVES",
                    "WOF51_SKILL_SUMMONING_HEAD",
                    "WOF51_SKILL_SUMMONING_LEGS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "summoning.charming_imp",
        icon_item = "RAND_REWARD_CHARMING_IMP",
        kind = "convenience",
        skills = { "SUMMONING" },
        members = true,
        title = "Charming imp",
        hook = "A charming imp keeps charm collection out of your backpack routine.",
        why = "It automatically collects selected charms, or exchanges unwanted ones for Summoning experience.",
        how = { "Look in the Dungeoneering rewards shop and configure which charms to keep." },
        requirements = {
            skills = {
                SUMMONING = 21,
                DUNGEONEERING = 21,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "RAND_REWARD_CHARMING_IMP" },
            },
        },
        priority = 2,
    },

    {
        id = "summoning.spirit_weaver",
        icon_item_id = 12163,
        kind = "general",
        skills = { "SUMMONING" },
        members = true,
        title = "Spirit Weaver",
        hook = "Spirit Weaver offers more experience from your charm supply.",
        why = "It changes normal pouch infusion to slower, individual crafts. It does not affect the Shrine of Inanna.",
        how = {
            "Complete the Dragonkin VI collection for the Pastkeeper's tapestry, then harness its relic power.",
        },
        requirements = {
            skills = {
                SUMMONING = 1,
                ARCHAEOLOGY = 87,
            },
        },
        min_training_level = 70,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        priority = 2,
    },

    {
        id = "summoning.totem",
        icon_item = "DINO_TOTEM_LORE",
        kind = "convenience",
        skills = { "SUMMONING" },
        members = true,
        title = "Totem of Summoning",
        hook = "The Totem of Summoning helps your familiars stay with you longer.",
        why = "Place it on an Anachronia pedestal to extend familiar duration, leaving fewer replacements to summon.",
        how = {
            "Its pieces come from the island's course, Big Game Hunter and high-level Slayer drops.",
        },
        requirements = {
            skills = {
                SUMMONING = 1,
                SLAYER = 90,
                HUNTER = 75,
                AGILITY = 30,
                CRAFTING = 10,
            },
        },
        min_training_level = 80,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "DINO_TOTEM_LORE" },
            },
        },
        priority = 2,
    },

    {
        id = "summoning.shard_exchange",
        icon_item_id = 12183,
        kind = "general",
        skills = { "SUMMONING" },
        members = true,
        title = "Pouch exchanges",
        hook = "Unused familiar pouches can sometimes become more spirit shards.",
        why = "The exchange opens for more pouch types as your Summoning level rises. Its value can differ from selling the pouch.",
        how = {
            "Ask Bogrog near Gu'Tanoth about exchanging pouches and compare the return with the Grand Exchange.",
        },
        requirements = {
            skills = {
                SUMMONING = 1,
            },
        },
        min_training_level = 20,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        priority = 2,
    },

    {
        id = "summoning.spirit_cape",
        icon_item = "RAND_REWARD_SPIRIT_CAPE",
        kind = "convenience",
        skills = { "SUMMONING" },
        members = true,
        title = "Spirit cape",
        hook = "The spirit cape makes non-combat familiar special moves cheaper to use.",
        why = "Buying it grants a permanent reduction in special-move costs. The cape can stay in your bank afterwards.",
        how = { "Look in the Dungeoneering rewards shop." },
        requirements = {
            skills = {
                SUMMONING = 50,
                DUNGEONEERING = 50,
                DEFENCE = 50,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "RAND_REWARD_SPIRIT_CAPE" },
            },
        },
        priority = 2,
    },

    {
        id = "summoning.cape",
        icon_item = "SKILLCAPE_SUMMONING",
        kind = "convenience",
        skills = { "SUMMONING" },
        members = true,
        title = "Summoning cape",
        hook = "The Summoning cape can stretch your charm supply a little further.",
        why = "Wear it for a chance to save a charm when infusing supported pouches.",
        how = { "Buy it from Pikkupstix in Taverley." },
        requirements = {
            skills = {
                SUMMONING = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_INVERTED_SUMMONING_HOODED",
                    "SKILLCAPE_INVERTED_SUMMONING_TRIMMED_HOODED",
                    "SKILLCAPE_SUMMONING",
                    "SKILLCAPE_SUMMONING_HOODED",
                    "SKILLCAPE_SUMMONING_HOODED_RETRO",
                    "SKILLCAPE_SUMMONING_RETRO",
                    "SKILLCAPE_SUMMONING_TRIMMED",
                    "SKILLCAPE_SUMMONING_TRIMMED_HOODED",
                    "SKILLCAPE_SUMMONING_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_SUMMONING_TRIMMED_RETRO",
                },
            },
        },
        priority = 2,
    },

    {
        id = "summoning.method.dreadfowl",
        main_method = true,
        icon_item_id = 12158,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 4, 15 },
        members = true,
        title = "Dreadfowl pouches",
        hook = "Making dreadfowl pouches offers a way to use your early gold charms.",
        why = "Compare the secondary ingredient cost with the finished pouch before choosing a batch.",
        how = { "Inspect the recipe at a Summoning obelisk and plan around the charms you have." },
        requirements = {
            skills = {
                SUMMONING = 4,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SUMMONING",
                level = 4,
            },
        },
        priority = 2,
    },

    {
        id = "summoning.method.granite_crab",
        main_method = true,
        icon_item_id = 12158,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 16, 30 },
        members = true,
        title = "Granite crab pouches",
        hook = "Making granite crab pouches offers a way to use gold charms and a simple ingredient.",
        why = "Compare the secondary ingredient cost with the finished pouch before choosing a batch.",
        how = { "Inspect the recipe at a Summoning obelisk and plan around the charms you have." },
        requirements = {
            skills = {
                SUMMONING = 16,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SUMMONING",
                level = 16,
            },
        },
        priority = 2,
    },

    {
        id = "summoning.method.vampyre_bat",
        main_method = true,
        icon_item_id = 12160,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 31, 45 },
        members = true,
        title = "Vampyre bat pouches",
        hook = "Making vampyre bat pouches offers a way to use a supply of crimson charms.",
        why = "Compare the secondary ingredient cost with the finished pouch before choosing a batch.",
        how = { "Inspect the recipe at a Summoning obelisk and plan around the charms you have." },
        requirements = {
            skills = {
                SUMMONING = 31,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SUMMONING",
                level = 31,
            },
        },
        priority = 2,
    },

    {
        id = "summoning.method.pyrelord",
        main_method = true,
        icon_item_id = 12160,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 46, 48 },
        members = true,
        title = "Pyrelord pouches",
        hook = "Making pyrelord pouches offers a way to use a mid-level crimson charm supply.",
        why = "Compare the secondary ingredient cost with the finished pouch before choosing a batch.",
        how = { "Inspect the recipe at a Summoning obelisk and plan around the charms you have." },
        requirements = {
            skills = {
                SUMMONING = 46,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SUMMONING",
                level = 46,
            },
        },
        priority = 2,
    },

    {
        id = "summoning.method.bloated_leech",
        main_method = true,
        icon_item_id = 12160,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 49, 60 },
        members = true,
        title = "Bloated leech pouches",
        hook = "Making bloated leech pouches offers a way to use more experience from crimson charms.",
        why = "Compare the secondary ingredient cost with the finished pouch before choosing a batch.",
        how = { "Inspect the recipe at a Summoning obelisk and plan around the charms you have." },
        requirements = {
            skills = {
                SUMMONING = 49,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SUMMONING",
                level = 49,
            },
        },
        priority = 2,
    },

    {
        id = "summoning.method.smoke_devil",
        main_method = true,
        icon_item_id = 12160,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 61, 73 },
        members = true,
        title = "Smoke devil pouches",
        hook = "Making smoke devil pouches offers a way to use a higher-level use for crimson charms.",
        why = "Compare the secondary ingredient cost with the finished pouch before choosing a batch.",
        how = { "Inspect the recipe at a Summoning obelisk and plan around the charms you have." },
        requirements = {
            skills = {
                SUMMONING = 61,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SUMMONING",
                level = 61,
            },
        },
        priority = 2,
    },

    {
        id = "summoning.method.granite_lobster",
        main_method = true,
        icon_item_id = 12160,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 74, 82 },
        members = true,
        title = "Granite lobster pouches",
        hook = "Making granite lobster pouches offers a way to use more experience from a crimson charm stockpile.",
        why = "Compare the secondary ingredient cost with the finished pouch before choosing a batch.",
        how = { "Inspect the recipe at a Summoning obelisk and plan around the charms you have." },
        requirements = {
            skills = {
                SUMMONING = 74,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SUMMONING",
                level = 74,
            },
        },
        priority = 2,
    },

    {
        id = "summoning.method.spirit_dagannoth",
        main_method = true,
        icon_item_id = 12160,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 83, 95 },
        members = true,
        title = "Spirit dagannoth pouches",
        hook = "Making spirit dagannoth pouches offers a way to use a high-level crimson charm stockpile.",
        why = "Compare the secondary ingredient cost with the finished pouch before choosing a batch.",
        how = { "Inspect the recipe at a Summoning obelisk and plan around the charms you have." },
        requirements = {
            skills = {
                SUMMONING = 83,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SUMMONING",
                level = 83,
            },
        },
        priority = 2,
    },

    {
        id = "summoning.method.pack_yak",
        main_method = true,
        icon_item_id = 12160,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 96, 98 },
        members = true,
        title = "Pack yak pouches",
        hook = "Making pack yak pouches offers a way to use crimson charms and useful familiar pouches.",
        why = "Compare the secondary ingredient cost with the finished pouch before choosing a batch.",
        how = { "Inspect the recipe at a Summoning obelisk and plan around the charms you have." },
        requirements = {
            skills = {
                SUMMONING = 96,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SUMMONING",
                level = 96,
            },
        },
        priority = 2,
    },

    {
        id = "summoning.method.steel_titan",
        main_method = true,
        icon_item_id = 12160,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 99, 120 },
        members = true,
        title = "Steel titan pouches",
        hook = "Making steel titan pouches offers a way to use a late-game crimson charm supply.",
        why = "Compare the secondary ingredient cost with the finished pouch before choosing a batch.",
        how = { "Inspect the recipe at a Summoning obelisk and plan around the charms you have." },
        requirements = {
            skills = {
                SUMMONING = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "SUMMONING",
                level = 99,
            },
        },
        priority = 2,
    },

    {
        id = "summoning.alt.shrine",
        icon_item_id = 12158,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 20, 120 },
        members = false,
        title = "Shrine of Inanna",
        hook = "The Shrine of Inanna offers a slower way to stretch your charm supply.",
        why = "Infusing pouches at the empowered obelisk builds a bonus that improves experience and can save materials.",
        how = { "Visit the shrine near Wendlewick and look for the currently empowered obelisk." },
        requirements = {
            skills = {
                SUMMONING = 1,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        priority = 3,
    },

    {
        id = "summoning.alt.terrorbird",
        icon_item_id = 12158,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 52, 65 },
        members = true,
        title = "Spirit terrorbird pouches",
        hook = "Spirit terrorbird pouches offer a use for spare gold charms.",
        why = "A different charm type can be worth using even when another recipe gives more experience per pouch.",
        how = {
            "Compare the raw bird meat cost with the finished pouches before choosing a batch.",
        },
        requirements = {
            skills = {
                SUMMONING = 52,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        priority = 3,
    },

    {
        id = "summoning.alt.spirit_jelly",
        icon_item_id = 12163,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 55, 72 },
        members = true,
        title = "Spirit jelly pouches",
        hook = "Spirit jelly pouches offer a mid-level use for blue charms.",
        why = "Blue charms give a different balance of experience and ingredient cost from gold or crimson recipes.",
        how = { "Inspect the jug of water recipe at a Summoning obelisk." },
        requirements = {
            skills = {
                SUMMONING = 55,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        priority = 3,
    },

    {
        id = "summoning.alt.barker_toad",
        icon_item_id = 12158,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 66, 98 },
        members = true,
        title = "Barker toad pouches",
        hook = "Barker toad pouches offer another use for a gold charm stockpile.",
        why = "Their ingredient cost can differ substantially from your crimson or blue charm options.",
        how = {
            "Inspect the swamp toad recipe and compare a small batch before buying more supplies.",
        },
        requirements = {
            skills = {
                SUMMONING = 66,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        priority = 3,
    },

    {
        id = "summoning.alt.obsidian_golem",
        icon_item_id = 12163,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 73, 88 },
        members = true,
        title = "Obsidian golem pouches",
        hook = "Obsidian golem pouches offer another route for blue charms.",
        why = "Their high experience per pouch comes with an ingredient cost worth comparing.",
        how = {
            "If you have obsidian charms, inspect the recipe and compare its spirit-shard cost before choosing a batch.",
        },
        requirements = {
            skills = {
                SUMMONING = 73,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        priority = 3,
    },

    {
        id = "summoning.alt.amlodd",
        icon_item_id = 12163,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 75, 120 },
        members = true,
        title = "Amlodd obelisk",
        hook = "The Amlodd district offers an obelisk and nearby banking in Prifddinas.",
        why = "It is a useful base for pouch batches, with extra experience when its Voice of Seren is active.",
        how = {
            "Try the obelisk in the Amlodd district and compare the journey with your usual route.",
        },
        requirements = {
            skills = {
                SUMMONING = 75,
            },
            quests = { "PLAGUES_END" },
        },
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        priority = 3,
    },

    {
        id = "summoning.alt.geyser_titan",
        icon_item_id = 12163,
        kind = "method",
        skills = { "SUMMONING" },
        level_range = { 89, 120 },
        members = true,
        title = "Geyser titan pouches",
        hook = "Geyser titan pouches offer a high-level use for blue charms.",
        why = "They remain an option when you have blue charms to use alongside crimson recipes.",
        how = { "Compare water talisman costs with the finished pouches before preparing a batch." },
        requirements = {
            skills = {
                SUMMONING = 89,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "SUMMONING",
            },
        },
        priority = 3,
    },
}
