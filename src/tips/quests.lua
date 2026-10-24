-- useful quest unlocks: full skill sets qualify, the quiet-pause queue handles delivery.
-- quest configs are probe-verified; current requirements and rewards are in docs/quest-pilot.md.
return {
    {
        id = "quest.fishing_contest",
        kind = "quest",
        quest = "FISHING_CONTEST",
        skills = { "ANY" },
        members = true,
        icon_item_id = 335,
        title = "Fishing Contest",
        hook = "You've got the Fishing level for Fishing Contest and its White Wolf Mountain "
            .. "shortcut.",
        why = "Finishing this short quest lets you cross beneath the mountain instead of "
            .. "walking over it.",
        how = { "Speak to Austri near Taverley or Vestri near Catherby, by the tunnel entrances." },
        requirements = { skills = { FISHING = 10 } },
        triggers = { { type = "requirements_met", skill = "ANY" } },
        priority = 1,
    },
    {
        id = "quest.family_crest",
        kind = "quest",
        quest = "FAMILY_CREST",
        skills = { "ANY" },
        members = true,
        icon_item_id = 775,
        title = "Family Crest",
        hook = "You've got the levels for Family Crest, which unlocks useful skilling gauntlets.",
        why = "Its reward can become cooking or goldsmith gauntlets, handy upgrades for your "
            .. "next training session.",
        how = { "Find Dimintheis in south-east Varrock. Expect some combat during the quest." },
        requirements = { skills = { CRAFTING = 40, MINING = 40, SMITHING = 40, MAGIC = 59 } },
        triggers = { { type = "requirements_met", skill = "ANY" } },
        priority = 1,
    },
}
