-- archaeology tips: useful items and unlocks first, then one main training method per level
-- bracket, then alternative methods. src/tips/schema.lua explains every field

return {
    -- useful items and unlocks
    {
        id = "archaeology.archaeologists_outfit",
        kind = "convenience",
        skills = { "ARCHAEOLOGY" },
        members = true,
        title = "Archaeologist's outfit",
        icon_item = "ARCH_SKILLING_HAT",
        hook = "The Archaeologist's outfit adds experience to your Archaeology training.",
        why = "Pieces contribute individually, with an extra bonus for wearing the full set.",
        how = {
            "Earn the Associate qualification, then buy pieces with chronotes at the Archaeology "
                .. "Guild Shop.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 70 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "ARCH_SKILLING_BODY",
                    "ARCH_SKILLING_BOOTS",
                    "ARCH_SKILLING_GLOVES",
                    "ARCH_SKILLING_HAT",
                    "ARCH_SKILLING_LEGS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "archaeology.master_outfit",
        kind = "convenience",
        skills = { "ARCHAEOLOGY" },
        members = true,
        title = "Master archaeologist's outfit",
        icon_item = "ARCH_ELITE_SKILLING_HAT",
        hook = "The master archaeologist's outfit offers excavation bonuses and useful teleports.",
        why = "The full set helps with progress around dig sites and adds convenience while "
            .. "excavating and restoring.",
        how = {
            "Work towards the Guildmaster qualification, then look for the outfit in the "
                .. "Archaeology Guild Shop.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "ARCH_ELITE_SKILLING_BODY",
                    "ARCH_ELITE_SKILLING_BOOTS",
                    "ARCH_ELITE_SKILLING_GLOVES",
                    "ARCH_ELITE_SKILLING_HAT",
                    "ARCH_ELITE_SKILLING_LEGS",
                },
            },
        },
        priority = 2,
    },

    {
        id = "archaeology.soil_box",
        kind = "convenience",
        skills = { "ARCHAEOLOGY" },
        members = true,
        title = "Archaeological soil box",
        icon_item = "ARCH_SOIL_BOX",
        hook = "A soil box leaves more backpack space for your excavation finds.",
        why = "Store gathered soil in it, then take the soil to a screening station when "
            .. "convenient.",
        how = {
            "Pick up a soil box from the Archaeology Guild Shop. Guild qualifications unlock "
                .. "capacity upgrades.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 5 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        known_when = {
            { type = "owns_any", items = { "ARCH_SOIL_BOX" } },
        },
        priority = 2,
    },

    {
        id = "archaeology.dragon_mattock",
        kind = "convenience",
        skills = { "ARCHAEOLOGY" },
        members = true,
        title = "Dragon mattock",
        icon_item = "DRAGON_MATTOCK",
        hook = "A dragon mattock offers an augmentable tool and a path towards later upgrades.",
        why = "It can become a crystal or Imcando mattock, and Invention unlocks useful tool "
            .. "perks.",
        how = {
            "Look for one from Big Game Hunter or ancient caskets, or buy one on the Grand "
                .. "Exchange.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 60 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "CRYSTAL_MATTOCK",
                    "CRYSTAL_MATTOCK_AUGMENTED",
                    "CRYSTAL_MATTOCK_AUGMENTED_UNCHARGED",
                    "DRAGON_MATTOCK",
                    "DRAGON_MATTOCK_AUGMENTED",
                    "DRAGON_MATTOCK_AUGMENTED_UNCHARGED",
                    "HERO_MATTOCK",
                    "HERO_MATTOCK_AUGMENTED",
                    "HERO_MATTOCK_AUGMENTED_UNCHARGED",
                    "IMCANDO_MATTOCK",
                    "IMCANDO_MATTOCK_AUGMENTED",
                    "IMCANDO_MATTOCK_AUGMENTED_UNCHARGED",
                    "TIME_SPACE_MATTOCK",
                    "TIME_SPACE_MATTOCK_AUGMENTED",
                    "TIME_SPACE_MATTOCK_AUGMENTED_UNCHARGED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "archaeology.auto_screener",
        kind = "convenience",
        skills = { "ARCHAEOLOGY" },
        members = true,
        title = "Auto-screener v1.080",
        icon_item = "INVENT_AUTO_SCREENER",
        hook = "The auto-screener turns gathered soil into materials while you excavate.",
        why = "It saves manual screening trips, using energy from your charge pack. Unlike manual "
            .. "screening, it does not find extra artefacts.",
        how = {
            "Earn Associate status and buy its blueprint from the Archaeology Guild Shop, then "
                .. "discover and build it through Invention.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 70, INVENTION = 67 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        known_when = {
            {
                type = "owns_any",
                items = { "INVENT_AUTO_SCREENER", "INVENT_AUTO_SCREENER_INACTIVE" },
            },
        },
        priority = 2,
    },

    {
        id = "archaeology.crystal_mattock",
        kind = "convenience",
        skills = { "ARCHAEOLOGY" },
        members = true,
        title = "Crystal mattock",
        icon_item = "CRYSTAL_MATTOCK",
        hook = "A crystal mattock offers stronger excavation and supports Invention perks.",
        why = "It also becomes a component of the Mattock of Time and Space later on.",
        how = {
            "After Plague's End, take a dragon mattock and harmonic dust to Lady Ithell in "
                .. "Prifddinas.",
        },
        quest_how = {
            "Work towards Plague's End to open up Prifddinas and its training facilities.",
        },
        requirements = {
            skills = {
                AGILITY = 75,
                ARCHAEOLOGY = 70,
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
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "CRYSTAL_MATTOCK",
                    "CRYSTAL_MATTOCK_AUGMENTED",
                    "CRYSTAL_MATTOCK_AUGMENTED_UNCHARGED",
                    "HERO_MATTOCK",
                    "HERO_MATTOCK_AUGMENTED",
                    "HERO_MATTOCK_AUGMENTED_UNCHARGED",
                    "IMCANDO_MATTOCK",
                    "IMCANDO_MATTOCK_AUGMENTED",
                    "IMCANDO_MATTOCK_AUGMENTED_UNCHARGED",
                    "TIME_SPACE_MATTOCK",
                    "TIME_SPACE_MATTOCK_AUGMENTED",
                    "TIME_SPACE_MATTOCK_AUGMENTED_UNCHARGED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "archaeology.sash_brush",
        kind = "convenience",
        skills = { "ARCHAEOLOGY" },
        members = true,
        min_training_level = 80,
        title = "Balarak's sash brush",
        icon_item = "SKILLING_OFFHAND_ARCHAEOLOGY",
        hook = "Balarak's sash brush offers more from each excavation session.",
        why = "This off-hand improves excavation and rewards following the time sprite, with "
            .. "occasional extra materials.",
        how = {
            "Find its pieces while excavating the Daemonheim Depths, or buy a completed brush.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 103, DUNGEONEERING = 95 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        known_when = {
            { type = "owns_any", items = { "SKILLING_OFFHAND_ARCHAEOLOGY" } },
        },
        priority = 2,
    },

    {
        id = "archaeology.imcando_mattock",
        kind = "convenience",
        skills = { "ARCHAEOLOGY" },
        members = true,
        title = "Imcando mattock",
        icon_item = "IMCANDO_MATTOCK",
        hook = "An Imcando mattock offers higher-tier excavation with room for Invention perks.",
        why = "It is stronger than its use level suggests and can later become part of the Mattock "
            .. "of Time and Space.",
        how = {
            "Collect Imcando metal pieces at Warforge and follow its mysteries to reach Thalmund's "
                .. "Forge.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 83 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "HERO_MATTOCK",
                    "HERO_MATTOCK_AUGMENTED",
                    "HERO_MATTOCK_AUGMENTED_UNCHARGED",
                    "IMCANDO_MATTOCK",
                    "IMCANDO_MATTOCK_AUGMENTED",
                    "IMCANDO_MATTOCK_AUGMENTED_UNCHARGED",
                    "TIME_SPACE_MATTOCK",
                    "TIME_SPACE_MATTOCK_AUGMENTED",
                    "TIME_SPACE_MATTOCK_AUGMENTED_UNCHARGED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "archaeology.cosmic_accumulator",
        kind = "convenience",
        skills = { "ARCHAEOLOGY" },
        members = true,
        title = "Cosmic accumulator",
        icon_item = "QUEST_DM_ARCH_REWARD_ENHANCED",
        hook = "The cosmic accumulator helps maintain time-sprite focus during excavation.",
        why = "Carry it in your backpack for a focus floor and a chance of extra focus while "
            .. "following the sprite.",
        how = {
            "Combine the cosmic focus from Desperate Measures with the cosmic pyramid from the "
                .. "Desperate for Artefacts collection.",
        },
        quest_how = {
            "Look into Desperate Measures and its cosmic focus, then the Desperate for Artefacts "
                .. "collection.",
        },
        requirements = {
            skills = {
                AGILITY = 50,
                ARCHAEOLOGY = 90,
                DIVINATION = 50,
                MINING = 50,
                SMITHING = 50,
            },
            quests = { "DM" },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        known_when = {
            { type = "owns_any", items = { "QUEST_DM_ARCH_REWARD_ENHANCED" } },
        },
        priority = 2,
    },

    {
        id = "archaeology.time_space_mattock",
        kind = "convenience",
        skills = { "ARCHAEOLOGY" },
        members = true,
        title = "Mattock of Time and Space",
        icon_item = "TIME_SPACE_MATTOCK",
        hook = "The Mattock of Time and Space offers a long-term upgrade for excavation.",
        why = "It combines the crystal and Imcando upgrade paths into one augmentable tool.",
        how = {
            "Earn Guildmaster status, then look into combining your mattocks with an energised "
                .. "meteorite shard at the monolith.",
        },
        quest_how = {
            "Work towards Plague's End to open up Prifddinas and its training facilities.",
        },
        requirements = {
            skills = {
                AGILITY = 75,
                ARCHAEOLOGY = 99,
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
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "HERO_MATTOCK",
                    "HERO_MATTOCK_AUGMENTED",
                    "HERO_MATTOCK_AUGMENTED_UNCHARGED",
                    "TIME_SPACE_MATTOCK",
                    "TIME_SPACE_MATTOCK_AUGMENTED",
                    "TIME_SPACE_MATTOCK_AUGMENTED_UNCHARGED",
                },
            },
        },
        priority = 2,
    },

    {
        id = "archaeology.material_storage",
        kind = "general",
        skills = { "ARCHAEOLOGY" },
        members = false,
        title = "Material storage",
        icon_item_id = 49460,
        hook = "Archaeology materials have their own storage, separate from your bank.",
        why = "Restoration draws from material storage, so deposited materials stay ready for your "
            .. "next workbench visit.",
        how = {
            "Use a material deposit cart at a dig site or the Guild's material storage.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 5 },
        },
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        priority = 3,
    },

    {
        id = "archaeology.time_sprite",
        kind = "general",
        skills = { "ARCHAEOLOGY" },
        members = false,
        title = "Follow the time sprite",
        icon_item_id = 49429,
        hook = "The time sprite helps you get more from excavation.",
        why = "Working at its highlighted hotspot builds focus for better excavation results.",
        how = {
            "Watch for it moving to a nearby hotspot while you dig.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 5 },
        },
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        priority = 3,
    },

    {
        id = "archaeology.qualifications",
        kind = "general",
        skills = { "ARCHAEOLOGY" },
        members = true,
        title = "Guild qualifications",
        icon_item_id = 49429,
        hook = "Archaeology levels are only part of earning your next Guild qualification.",
        why = "Mysteries, collections, excavations and restorations also count, and promotions "
            .. "unlock useful upgrades.",
        how = {
            "Check your qualification progress in the Archaeology journal before choosing your "
                .. "next excavation.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 40 },
        },
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        priority = 3,
    },

    {
        id = "archaeology.flow_state",
        kind = "general",
        skills = { "ARCHAEOLOGY" },
        members = true,
        title = "Flow State",
        icon_item_id = 50701,
        hook = "Flow State trades gathered soil for more excavation precision.",
        why = "This relic can suit sessions focused on artefacts rather than keeping soil for "
            .. "screening.",
        how = {
            "Work towards the Soma relic through Orthen's mysteries, then offer it at the "
                .. "mysterious monolith.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 102 },
        },
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        priority = 3,
    },

    {
        id = "archaeology.cape",
        kind = "convenience",
        skills = { "ARCHAEOLOGY" },
        members = true,
        title = "Archaeology cape",
        icon_item = "SKILLCAPE_ARCHAEOLOGY",
        hook = "The Archaeology cape offers easier relic changes and a little extra sprite focus.",
        why = "Its perk opens the relic powers interface at banks and improves focus gained while "
            .. "following the time sprite.",
        how = {
            "Buy it from Acting Guildmaster Reiniger at the Archaeology Guild.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 99 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        known_when = {
            {
                type = "owns_any",
                items = {
                    "SKILLCAPE_120_ARCHAEOLOGY",
                    "SKILLCAPE_ARCHAEOLOGY",
                    "SKILLCAPE_ARCHAEOLOGY_HOODED",
                    "SKILLCAPE_ARCHAEOLOGY_RETRO",
                    "SKILLCAPE_ARCHAEOLOGY_TRIMMED",
                    "SKILLCAPE_ARCHAEOLOGY_TRIMMED_HOODED",
                    "SKILLCAPE_ARCHAEOLOGY_TRIMMED_HOODED_RETRO",
                    "SKILLCAPE_ARCHAEOLOGY_TRIMMED_RETRO",
                    "SKILLCAPE_ARCHAEOLOGY_HOODED_RETRO",
                },
            },
        },
        priority = 2,
    },

    {
        id = "archaeology.master_cape",
        kind = "convenience",
        skills = { "ARCHAEOLOGY" },
        members = true,
        title = "Archaeology master cape",
        icon_item = "SKILLCAPE_120_ARCHAEOLOGY",
        hook = "The Archaeology master cape helps discoveries lead into the next artefact.",
        why = "Its perk grants progress towards the next discovery when you uncover an artefact, "
            .. "alongside the regular cape's benefits.",
        how = {
            "Buy it from Acting Guildmaster Reiniger after reaching 120 Archaeology.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 120 },
        },
        require_all_levels = true,
        triggers = {
            { type = "training", skill = "ARCHAEOLOGY" },
        },
        known_when = {
            { type = "owns_any", items = { "SKILLCAPE_120_ARCHAEOLOGY" } },
        },
        priority = 2,
    },

    -- training methods, one main method per level bracket
    {
        id = "archaeology.method.kharid_et",
        kind = "method",
        skills = { "ARCHAEOLOGY" },
        members = false,
        level_range = { 5, 19 },
        main_method = true,
        title = "Kharid-et",
        icon_item_id = 49460,
        hook = "Kharid-et offers collections and mysteries to explore alongside your other dig "
            .. "sites.",
        why = "Early Zarosian artefacts introduce collections, while mysteries open more of the "
            .. "dig site.",
        how = {
            "Speak to Dr Nabanik at Kharid-et and begin with the venator remains. Follow newly "
                .. "available hotspots as you level.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 5 },
        },
        triggers = {
            { type = "level_reached", skill = "ARCHAEOLOGY", level = 5 },
        },
        priority = 2,
    },

    {
        id = "archaeology.method.infernal_source",
        kind = "method",
        skills = { "ARCHAEOLOGY" },
        members = true,
        level_range = { 20, 41 },
        main_method = true,
        title = "Infernal Source",
        icon_item_id = 49498,
        hook = "The Infernal Source offers collections and mysteries to explore alongside your "
            .. "other dig sites.",
        why = "This dig site adds Zamorakian collections and mysteries alongside your Kharid-et "
            .. "progress.",
        how = {
            "Meet Movario at the Infernal Source near the Jolly Boar Inn. Keep returning to "
                .. "earlier sites for missing collection pieces.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 20 },
        },
        triggers = {
            { type = "level_reached", skill = "ARCHAEOLOGY", level = 20 },
        },
        priority = 2,
    },

    {
        id = "archaeology.method.everlight",
        kind = "method",
        skills = { "ARCHAEOLOGY" },
        members = true,
        level_range = { 42, 69 },
        main_method = true,
        title = "Everlight",
        icon_item_id = 49464,
        hook = "Everlight offers collections and mysteries to explore alongside your other dig "
            .. "sites.",
        why = "Saradominist collections and the site's mysteries give your excavation another "
            .. "direction.",
        how = {
            "Meet Vanescula at Everlight in Morytania. Restore finds and check which collectors "
                .. "still need them.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 42 },
        },
        triggers = {
            { type = "level_reached", skill = "ARCHAEOLOGY", level = 42 },
        },
        priority = 2,
    },

    {
        id = "archaeology.method.stormguard",
        kind = "method",
        skills = { "ARCHAEOLOGY" },
        members = true,
        level_range = { 70, 75 },
        main_method = true,
        title = "Stormguard Citadel",
        icon_item_id = 49472,
        hook = "Stormguard Citadel offers collections and mysteries to explore alongside your "
            .. "other dig sites.",
        why = "Exploring the citadel reveals Armadylean artefacts and new ways to move around the "
            .. "site.",
        how = {
            "Start at the Ikovian memorial near the Temple of Ikov, and follow the site's "
                .. "mysteries to progress.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 70 },
        },
        triggers = {
            { type = "level_reached", skill = "ARCHAEOLOGY", level = 70 },
        },
        priority = 2,
    },

    {
        id = "archaeology.method.warforge",
        kind = "method",
        skills = { "ARCHAEOLOGY" },
        members = true,
        level_range = { 76, 89 },
        main_method = true,
        title = "Warforge",
        icon_item_id = 49476,
        hook = "Warforge offers collections and mysteries to explore alongside your other dig "
            .. "sites.",
        why = "Bandosian collections offer repeatable rewards, including collections that award "
            .. "tetracompass pieces.",
        how = {
            "Speak to Zanik at Warforge, south-west of the Feldip Hills. Follow the mysteries to "
                .. "reach more hotspots.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 76 },
        },
        triggers = {
            { type = "level_reached", skill = "ARCHAEOLOGY", level = 76 },
        },
        priority = 2,
    },

    {
        id = "archaeology.method.orthen",
        kind = "method",
        skills = { "ARCHAEOLOGY" },
        members = true,
        level_range = { 90, 120 },
        main_method = true,
        title = "Orthen",
        icon_item_id = 50690,
        hook = "Orthen offers Dragonkin collections and mysteries to work towards on Anachronia.",
        why = "Anachronia's excavation sites add Dragonkin collections and mysteries throughout "
            .. "the higher levels.",
        how = {
            "Earn the Guild's Associate qualification, then speak to Mr Mordaut at Anachronia's "
                .. "base camp to get started.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 90 },
        },
        triggers = {
            { type = "level_reached", skill = "ARCHAEOLOGY", level = 90 },
        },
        priority = 2,
    },

    -- alternative methods, offered alongside the main method for a level
    {
        id = "archaeology.alt.material_caches",
        kind = "method",
        skills = { "ARCHAEOLOGY" },
        members = false,
        level_range = { 5, 120 },
        title = "Material caches",
        icon_item_id = 49460,
        hook = "Missing materials for a restoration? You can gather them from material caches.",
        why = "Caches target a particular material, useful when excavation leaves you short of one "
            .. "ingredient.",
        how = {
            "Check the material you need and look for a cache you have the level to harvest.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 5 },
        },
        triggers = {
            { type = "level_reached", skill = "ARCHAEOLOGY", level = 5 },
        },
        priority = 3,
    },

    {
        id = "archaeology.alt.screening_soil",
        kind = "method",
        skills = { "ARCHAEOLOGY" },
        members = true,
        level_range = { 5, 120 },
        title = "Screening soil",
        icon_item_id = 49460,
        hook = "Saved excavation soil offers another source of materials and occasional artefacts.",
        why = "Screening gives it a use beyond filling backpack space, with results improving as "
            .. "Archaeology rises.",
        how = {
            "Take a soil type you have the level to screen to the station at the Archaeology "
                .. "Guild.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 5 },
        },
        triggers = {
            { type = "level_reached", skill = "ARCHAEOLOGY", level = 5 },
        },
        priority = 3,
    },

    {
        id = "archaeology.alt.repeat_collections",
        kind = "method",
        skills = { "ARCHAEOLOGY" },
        members = true,
        level_range = { 25, 120 },
        title = "Repeat collections",
        icon_item_id = 49430,
        hook = "Finishing a collection does not mean you have to stop collecting its artefacts.",
        why = "Many collectors offer rewards again for another complete set, giving spare finds a "
            .. "purpose.",
        how = {
            "Check collector information in your Archaeology journal and pick a set whose rewards "
                .. "interest you.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 25 },
        },
        triggers = {
            { type = "level_reached", skill = "ARCHAEOLOGY", level = 25 },
        },
        priority = 3,
    },

    {
        id = "archaeology.alt.research_teams",
        kind = "method",
        skills = { "ARCHAEOLOGY" },
        members = true,
        level_range = { 40, 120 },
        title = "Archaeology research",
        icon_item_id = 49430,
        hook = "Research teams offer progress while you spend time on other activities.",
        why = "Fund expeditions with chronotes for materials, finds and experience; special "
            .. "research also develops dig-site stories.",
        how = {
            "Earn the Assistant qualification, then manage your team at the Examination Centre.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 40 },
        },
        triggers = {
            { type = "level_reached", skill = "ARCHAEOLOGY", level = 40 },
        },
        priority = 3,
    },

    {
        id = "archaeology.alt.tetracompass_collections",
        kind = "method",
        skills = { "ARCHAEOLOGY" },
        members = true,
        level_range = { 83, 120 },
        title = "Tetracompass collections",
        icon_item_id = 49430,
        hook = "Some collections offer a repeatable route to tetracompass pieces.",
        why = "Completing another set can reward another piece, turning repeat excavations into a "
            .. "longer-term treasure hunt.",
        how = {
            "Check the rewards of Warforge collections and follow the site's mysteries to reach "
                .. "the required artefacts.",
        },
        requirements = {
            skills = { ARCHAEOLOGY = 83 },
        },
        triggers = {
            { type = "level_reached", skill = "ARCHAEOLOGY", level = 83 },
        },
        priority = 3,
    },
}
