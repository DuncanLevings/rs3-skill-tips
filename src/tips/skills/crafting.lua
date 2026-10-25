-- crafting tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field

return {
    -- useful items and unlocks
    {
        id = "crafting.artisan_outfit",
        kind = "convenience",
        skills = { "CRAFTING" },
        members = true,
        min_training_level = 30,
        title = "Artisan's outfit",
        icon_item = "WOF19_SKILL_CRAFTING_HEAD",
        hook = "The Artisan's outfit adds experience to your crafting.",
        why = "Each piece contributes, and the full set adds a further bonus. A modified bandana "
            .. "can also save leather.",
        how = {
            "The pieces are rewards from Stealing Creation or Stanley Limelight Traders.",
        },
        requirements = {
            skills = { CRAFTING = 1 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CRAFTING" },
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
        kind = "general",
        skills = { "CRAFTING" },
        members = true,
        title = "Scroll of dexterity",
        icon_item_id = 1745,
        hook = "The scroll of dexterity can save materials on larger crafting projects.",
        why = "Its permanent effect applies to supported items that use several materials at once.",
        how = {
            "Look in the Dungeoneering rewards shop.",
        },
        requirements = {
            skills = { CRAFTING = 60, DUNGEONEERING = 60 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CRAFTING" },
        },
        priority = 2,
    },

    {
        id = "crafting.cape",
        kind = "convenience",
        skills = { "CRAFTING" },
        members = true,
        title = "Crafting cape",
        icon_item = "SKILLCAPE_CRAFTING",
        hook = "The Crafting cape offers a simpler leatherworking setup.",
        why = "It supplies thread and sometimes cuts a whole inventory of matching gems at once.",
        how = {
            "Buy it from the master crafter in the Crafting Guild.",
        },
        requirements = {
            skills = { CRAFTING = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CRAFTING" },
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

    -- training methods, one main method per level bracket
    {
        id = "crafting.method.gems",
        kind = "method",
        skills = { "CRAFTING" },
        members = false,
        level_range = { 20, 39 },
        main_method = true,
        title = "Cutting gems",
        icon_item_id = 1607,
        hook = "Cutting gems offers quick Crafting experience in short batches.",
        why = "Different gems become available as you level, with different costs per cut.",
        how = {
            "Compare cut and uncut prices before buying a large batch.",
        },
        requirements = {
            skills = { CRAFTING = 20 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "CRAFTING", level = 20 },
        },
        priority = 2,
    },

    {
        id = "crafting.method.dragonhide",
        kind = "method",
        skills = { "CRAFTING" },
        members = true,
        level_range = { 40, 74 },
        main_method = true,
        title = "Dragonhide equipment",
        icon_item_id = 1745,
        hook = "Dragonhide equipment offers a batch-based route through mid-level Crafting.",
        why = "Higher colours unlock as you level. Bodies and shields use several hides per "
            .. "action.",
        how = {
            "Try a small batch of tanned leather and compare the cost with the finished equipment.",
        },
        requirements = {
            skills = { CRAFTING = 40 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "CRAFTING", level = 40 },
        },
        priority = 2,
    },

    {
        id = "crafting.method.undead_hide",
        kind = "method",
        skills = { "CRAFTING" },
        members = true,
        level_range = { 75, 99 },
        main_method = true,
        title = "Undead dragonhide",
        icon_item_id = 2509,
        hook = "Undead dragonhide offers another high-level leatherworking option.",
        why = "Crafting its equipment uses several hides at a time, giving experience in short "
            .. "batches.",
        how = {
            "Compare tanned hide prices with the finished gear before choosing a project.",
        },
        requirements = {
            skills = { CRAFTING = 75 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "CRAFTING", level = 75 },
        },
        priority = 2,
    },

    {
        id = "crafting.method.high_tier",
        kind = "method",
        skills = { "CRAFTING" },
        members = true,
        level_range = { 100, 120 },
        main_method = true,
        title = "Starbloom and apex hide",
        icon_item_id = 2509,
        hook = "Starbloom and apex hide equipment offer longer crafting projects.",
        why = "Equipment can be upgraded, then adorned for extra experience at the cost of "
            .. "consuming it.",
        how = {
            "Inspect the crafting workstations and Tailor's display in the Crafting Guild.",
        },
        requirements = {
            skills = { CRAFTING = 100 },
        },
        require_all_levels = true,
        triggers = {
            { type = "level_reached", skill = "CRAFTING", level = 100 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "crafting.alt.jewellery",
        kind = "method",
        skills = { "CRAFTING" },
        members = false,
        level_range = { 20, 79 },
        title = "Making jewellery",
        icon_item_id = 1607,
        hook = "Jewellery offers a different balance of experience and material cost.",
        why = "Rings, necklaces and bracelets can have very different margins, even when they use "
            .. "the same gem.",
        how = {
            "Check the furnace jewellery menu and compare a small batch of supplies with its "
                .. "output.",
        },
        requirements = {
            skills = { CRAFTING = 20 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CRAFTING" },
        },
        priority = 3,
    },

    {
        id = "crafting.alt.battlestaves",
        kind = "method",
        skills = { "CRAFTING" },
        members = true,
        level_range = { 54, 79 },
        title = "Battlestaves",
        icon_item_id = 1607,
        hook = "Battlestaves turn charged orbs into short crafting batches.",
        why = "Higher orb types unlock as you level. Buying the orbs avoids needing to charge them "
            .. "yourself.",
        how = {
            "Compare charged orb and battlestaff prices before trying a batch.",
        },
        requirements = {
            skills = { CRAFTING = 54 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CRAFTING" },
        },
        priority = 3,
    },

    {
        id = "crafting.alt.harps",
        kind = "method",
        skills = { "CRAFTING" },
        members = true,
        level_range = { 75, 99 },
        title = "Ithell harps",
        icon_item_id = 1615,
        hook = "Ithell harps offer relaxed Crafting experience without buying batch supplies.",
        why = "Playing also gathers harmonic dust for crystal equipment. Retune the harp when it "
            .. "drifts out of tune.",
        how = {
            "Visit the harps in the Ithell district of Prifddinas.",
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
            { type = "training", skill = "CRAFTING" },
        },
        priority = 3,
    },

    {
        id = "crafting.alt.flasks",
        kind = "method",
        skills = { "CRAFTING" },
        members = true,
        level_range = { 89, 120 },
        title = "Potion flasks",
        icon_item_id = 1601,
        hook = "Turning sandstone into flasks adds a small resource run to your crafting.",
        why = "Daily sandstone supplies limit the volume, making this a side activity rather than "
            .. "a full training session.",
        how = {
            "After As a First Resort, look into red sandstone near Oo'glog and its robust glass "
                .. "machine.",
        },
        quest_how = {
            "Complete As a First Resort to unlock Oo'glog's sandstone and robust glass facilities.",
        },
        requirements = {
            skills = { CRAFTING = 89, FIREMAKING = 51, HUNTER = 48, MINING = 81, WOODCUTTING = 58 },
            quests = { "AS_A_FIRST_RESORT" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CRAFTING" },
        },
        priority = 3,
    },

    {
        id = "crafting.alt.exquisite_urns",
        kind = "method",
        skills = { "CRAFTING" },
        members = true,
        level_range = { 102, 120 },
        title = "Making exquisite urns",
        icon_item_id = 1601,
        hook = "Making exquisite urns offers another outlet for high-level Crafting.",
        why = "Different urn types unlock as you level, so you can produce supplies for skilling "
            .. "or trade.",
        how = {
            "Look at the pottery oven options and compare soft clay costs with the finished urns.",
        },
        requirements = {
            skills = { CRAFTING = 102 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CRAFTING" },
        },
        priority = 3,
    },

    {
        id = "crafting.alt.platinum",
        kind = "method",
        skills = { "CRAFTING" },
        members = true,
        level_range = { 104, 120 },
        title = "Platinum jewellery",
        icon_item_id = 1601,
        hook = "Platinum jewellery offers another high-level crafting project.",
        why = "More jewellery types unlock as you level, with different material costs and uses.",
        how = {
            "Inspect the furnace jewellery menu and compare prices before committing to a large "
                .. "batch.",
        },
        requirements = {
            skills = { CRAFTING = 104 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "CRAFTING" },
        },
        priority = 3,
    },
}
