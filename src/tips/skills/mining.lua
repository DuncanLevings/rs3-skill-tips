-- mining tips. convenience items first, then training methods in level order.
-- only the ore box so far, the rest of mining comes with the pilot content

return {
    -- convenience items

    {
        -- ore box: holds ore outside the backpack, so each trip to the bank lasts longer
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
            -- owning any tier means they know about ore boxes. all 11 tiers checked in game
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
            -- every tier shares this category too, so a future tier is still caught
            { type = "owns_category", category = 4448 },
        },
        priority = 1,
    },
}
