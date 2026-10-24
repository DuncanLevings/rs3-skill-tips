-- tips that help more than one skill. each one lists every skill it applies to and triggers on
-- training any of them, the catalogue indexes it under each

return {
    {
        id = "shared.grace_of_the_elves",
        -- gate on whichever gathering skill is active, not all three.
        min_training_level = 80,
        kind = "convenience",
        skills = { "MINING", "WOODCUTTING", "FISHING" },
        members = true,
        title = "Grace of the elves",
        icon_item = "ALCH_ONYX_SKILL_NECKLACE",
        hook = "Tired of banking? Grace of the elves sends what you gather straight to your bank.",
        why = "It holds porter charges, so the ore, logs or fish you gather go to the bank on "
            .. "their own. It can also summon Seren spirits while you skill.",
        how = {
            "Enchant an alchemical onyx necklace with Lvl-6 Enchant, then charge it with signs "
                .. "of the porter.",
        },
        triggers = {
            { type = "training", skill = "MINING" },
            { type = "training", skill = "WOODCUTTING" },
            { type = "training", skill = "FISHING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "ALCH_ONYX_SKILL_NECKLACE", "ALCH_ONYX_SKILL_NECKLACE_USED" },
            },
        },
        priority = 2,
    },

    {
        id = "shared.ring_of_whispers",
        require_quests_complete = true,
        kind = "convenience",
        skills = { "MINING", "WOODCUTTING", "FISHING" },
        members = true,
        title = "Ring of Whispers",
        icon_item = "QUEST_ENDGAME_SHADOW_RING",
        hook = "The Ring of Whispers quietly boosts your gathering skills.",
        why = "While you wear it, you get an invisible +3 to your Mining, Woodcutting and Fishing "
            .. "levels.",
        how = { "It's a reward from Sliske's Endgame." },
        requirements = { quests = { "SLISKES_ENDGAME" } },
        triggers = {
            { type = "training", skill = "MINING" },
            { type = "training", skill = "WOODCUTTING" },
            { type = "training", skill = "FISHING" },
        },
        known_when = { { type = "owns_any", items = { "QUEST_ENDGAME_SHADOW_RING" } } },
        priority = 2,
    },

    {
        id = "shared.scripture_of_elidinis",
        -- source access matters even though the book can be bought.
        min_training_level = 80,
        require_all_levels = true,
        require_quests_complete = true,
        requirements = {
            skills = {
                AGILITY = 25,
                ARCHAEOLOGY = 86,
                COOKING = 20,
                MAGIC = 66,
                NECROMANCY = 75,
                PRAYER = 40,
                CONSTRUCTION = 54,
                SLAYER = 10,
            },
            quests = { "QUEST_AMASCUT" },
        },
        kind = "convenience",
        skills = { "MINING", "WOODCUTTING", "FISHING" },
        members = true,
        title = "Scripture of Elidinis",
        icon_item = "ELIDINIS_BOSS_ELIDINIS_BOOK",
        hook = "The Scripture of Elidinis gives you extra experience while you skill.",
        why = "Worn in your pocket slot, it now and then spawns a soul that gives experience when "
            .. "you catch it, on top of your other boosts.",
        how = {
            "Earn it from the Gate of Elidinis after Ode of the Devourer, or buy one on the "
                .. "Grand Exchange.",
        },
        triggers = {
            { type = "training", skill = "MINING" },
            { type = "training", skill = "WOODCUTTING" },
            { type = "training", skill = "FISHING" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "ELIDINIS_BOSS_ELIDINIS_BOOK",
                    "ELIDINIS_BOSS_ELIDINIS_BOOK_UNLOCK_TOKEN",
                },
            },
        },
        priority = 2,
    },

    {
        id = "shared.crystallise",
        icon_item_id = 566,
        require_all_levels = true,
        require_quests_complete = true,
        kind = "general",
        skills = { "MINING", "WOODCUTTING", "FISHING" },
        members = true,
        title = "Crystallise and Light Form",
        hook = "Crystallise turns a rock, tree or fishing spot into a burst of bonus experience.",
        why = "For 30 seconds you gain extra experience from it, but no resources. The Light "
            .. "Form curse doubles that bonus.",
        how = {
            "Crystallise needs 88 Magic, and Light Form needs 80 Prayer. Both come with The "
                .. "Light Within.",
        },
        requirements = { skills = { MAGIC = 88, PRAYER = 80 }, quests = { "SEREN" } },
        triggers = {
            { type = "training", skill = "MINING" },
            { type = "training", skill = "WOODCUTTING" },
            { type = "training", skill = "FISHING" },
        },
        priority = 3,
    },
}
