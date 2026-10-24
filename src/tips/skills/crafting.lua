-- useful items and unlocks, then main methods and alternatives in level order.
-- source access and recommendation windows: docs/artisan-coverage.md.

return {
    {
        id = "crafting.artisan_outfit",
        icon_item = "WOF19_SKILL_CRAFTING_HEAD",
        kind = "convenience",
        skills = { "CRAFTING" },
        members = true,
        title = "Artisan's outfit",
        hook = "The Artisan's outfit adds experience to your crafting.",
        why = "Each piece contributes, and the full set adds a further bonus. A modified bandana can also save leather.",
        how = { "The pieces are rewards from Stealing Creation or Stanley Limelight Traders." },
        requirements = {
            skills = {
                CRAFTING = 1,
            },
        },
        min_training_level = 30,
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CRAFTING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "TRH28_CRAFTING_HEAD_ADDON",
                    "TRH28_CRAFTING_HEAD_UPGRADED",
                    "WOF19_SKILL_CRAFTING_FEET",
                    "WOF19_SKILL_CRAFTING_HANDS",
                    "WOF19_SKILL_CRAFTING_HEAD",
                    "WOF19_SKILL_CRAFTING_LEGS",
                    "WOF19_SKILL_CRAFTING_TORSO",
                },
            },
        },
        priority = 2,
    },

    {
        id = "crafting.dexterity",
        icon_item_id = 1745,
        kind = "general",
        skills = { "CRAFTING" },
        members = true,
        title = "Scroll of dexterity",
        hook = "The scroll of dexterity can save materials on larger crafting projects.",
        why = "Its permanent effect applies to supported items that use several materials at once.",
        how = { "Look in the Dungeoneering rewards shop." },
        requirements = {
            skills = {
                CRAFTING = 60,
                DUNGEONEERING = 60,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CRAFTING",
            },
        },
        priority = 2,
    },

    {
        id = "crafting.cape",
        icon_item = "SKILLCAPE_CRAFTING",
        kind = "convenience",
        skills = { "CRAFTING" },
        members = true,
        title = "Crafting cape",
        hook = "The Crafting cape offers a simpler leatherworking setup.",
        why = "It supplies thread and sometimes cuts a whole inventory of matching gems at once.",
        how = { "Buy it from the master crafter in the Crafting Guild." },
        requirements = {
            skills = {
                CRAFTING = 99,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CRAFTING",
            },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_CRAFTING",
                    "SKILLCAPE_CRAFTING_HOODED",
                    "SKILLCAPE_CRAFTING_HOODED_RETRO",
                    "SKILLCAPE_CRAFTING_RETRO",
                    "SKILLCAPE_CRAFTING_TRIMMED",
                    "SKILLCAPE_CRAFTING_TRIMMED_HOODED",
                    "SKILLCAPE_CRAFTING_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_CRAFTING_TRIMMED_RETRO",
                    "SKILLCAPE_INVERTED_CRAFTING_HOODED",
                    "SKILLCAPE_INVERTED_CRAFTING_TRIMMED_HOODED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "crafting.method.gems",
        main_method = true,
        icon_item_id = 1607,
        kind = "method",
        skills = { "CRAFTING" },
        level_range = { 20, 39 },
        members = false,
        title = "Cutting gems",
        hook = "Cutting gems offers quick Crafting experience in short batches.",
        why = "Different gems become available as you level, with different costs per cut.",
        how = { "Compare cut and uncut prices before buying a large batch." },
        requirements = {
            skills = {
                CRAFTING = 20,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "CRAFTING",
                level = 20,
            },
        },
        priority = 2,
    },

    {
        id = "crafting.method.dragonhide",
        main_method = true,
        icon_item_id = 1745,
        kind = "method",
        skills = { "CRAFTING" },
        level_range = { 40, 74 },
        members = true,
        title = "Dragonhide equipment",
        hook = "Dragonhide equipment offers a batch-based route through mid-level Crafting.",
        why = "Higher colours unlock as you level. Bodies and shields use several hides per action.",
        how = {
            "Try a small batch of tanned leather and compare the cost with the finished equipment.",
        },
        requirements = {
            skills = {
                CRAFTING = 40,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "CRAFTING",
                level = 40,
            },
        },
        priority = 2,
    },

    {
        id = "crafting.method.undead_hide",
        main_method = true,
        icon_item_id = 2509,
        kind = "method",
        skills = { "CRAFTING" },
        level_range = { 75, 99 },
        members = true,
        title = "Undead dragonhide",
        hook = "Undead dragonhide offers another high-level leatherworking option.",
        why = "Crafting its equipment uses several hides at a time, giving experience in short batches.",
        how = { "Compare tanned hide prices with the finished gear before choosing a project." },
        requirements = {
            skills = {
                CRAFTING = 75,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "CRAFTING",
                level = 75,
            },
        },
        priority = 2,
    },

    {
        id = "crafting.method.high_tier",
        main_method = true,
        icon_item_id = 2509,
        kind = "method",
        skills = { "CRAFTING" },
        level_range = { 100, 120 },
        members = true,
        title = "Starbloom and apex hide",
        hook = "Starbloom and apex hide equipment offer longer crafting projects.",
        why = "Equipment can be upgraded, then adorned for extra experience at the cost of consuming it.",
        how = { "Inspect the crafting workstations and Tailor's display in the Crafting Guild." },
        requirements = {
            skills = {
                CRAFTING = 100,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "level_reached",
                skill = "CRAFTING",
                level = 100,
            },
        },
        priority = 2,
    },

    {
        id = "crafting.alt.jewellery",
        icon_item_id = 1607,
        kind = "method",
        skills = { "CRAFTING" },
        level_range = { 20, 79 },
        members = false,
        title = "Making jewellery",
        hook = "Jewellery offers a different balance of experience and material cost.",
        why = "Rings, necklaces and bracelets can have very different margins, even when they use the same gem.",
        how = {
            "Check the furnace jewellery menu and compare a small batch of supplies with its output.",
        },
        requirements = {
            skills = {
                CRAFTING = 20,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CRAFTING",
            },
        },
        priority = 3,
    },

    {
        id = "crafting.alt.battlestaves",
        icon_item_id = 1607,
        kind = "method",
        skills = { "CRAFTING" },
        level_range = { 54, 79 },
        members = true,
        title = "Battlestaves",
        hook = "Battlestaves turn charged orbs into short crafting batches.",
        why = "Higher orb types unlock as you level. Buying the orbs avoids needing to charge them yourself.",
        how = { "Compare charged orb and battlestaff prices before trying a batch." },
        requirements = {
            skills = {
                CRAFTING = 54,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CRAFTING",
            },
        },
        priority = 3,
    },

    {
        id = "crafting.alt.harps",
        icon_item_id = 1615,
        kind = "method",
        skills = { "CRAFTING" },
        level_range = { 75, 99 },
        members = true,
        title = "Ithell harps",
        hook = "Ithell harps offer relaxed Crafting experience without buying batch supplies.",
        why = "Playing also gathers harmonic dust for crystal equipment. Retune the harp when it drifts out of tune.",
        how = { "Visit the harps in the Ithell district of Prifddinas." },
        requirements = {
            skills = {
                CRAFTING = 75,
            },
            quests = { "PLAGUES_END" },
        },
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "CRAFTING",
            },
        },
        priority = 3,
    },

    {
        id = "crafting.alt.flasks",
        icon_item_id = 1601,
        kind = "method",
        skills = { "CRAFTING" },
        level_range = { 89, 120 },
        members = true,
        title = "Potion flasks",
        hook = "Turning sandstone into flasks adds a small resource run to your crafting.",
        why = "Daily sandstone supplies limit the volume, making this a side activity rather than a full training session.",
        how = {
            "After As a First Resort, look into red sandstone near Oo'glog and its robust glass machine.",
        },
        requirements = {
            skills = {
                CRAFTING = 89,
                MINING = 81,
            },
            quests = { "AS_A_FIRST_RESORT" },
        },
        require_all_levels = true,
        require_quests_complete = true,
        triggers = {
            {
                type = "training",
                skill = "CRAFTING",
            },
        },
        priority = 3,
    },

    {
        id = "crafting.alt.exquisite_urns",
        icon_item_id = 1601,
        kind = "method",
        skills = { "CRAFTING" },
        level_range = { 102, 120 },
        members = true,
        title = "Making exquisite urns",
        hook = "Making exquisite urns offers another outlet for high-level Crafting.",
        why = "Different urn types unlock as you level, so you can produce supplies for skilling or trade.",
        how = {
            "Look at the pottery oven options and compare soft clay costs with the finished urns.",
        },
        requirements = {
            skills = {
                CRAFTING = 102,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CRAFTING",
            },
        },
        priority = 3,
    },

    {
        id = "crafting.alt.platinum",
        icon_item_id = 1601,
        kind = "method",
        skills = { "CRAFTING" },
        level_range = { 104, 120 },
        members = true,
        title = "Platinum jewellery",
        hook = "Platinum jewellery offers another high-level crafting project.",
        why = "More jewellery types unlock as you level, with different material costs and uses.",
        how = {
            "Inspect the furnace jewellery menu and compare prices before committing to a large batch.",
        },
        requirements = {
            skills = {
                CRAFTING = 104,
            },
        },
        require_all_levels = true,
        triggers = {
            {
                type = "training",
                skill = "CRAFTING",
            },
        },
        priority = 3,
    },
}
