local _, smb = ...

-- The Shaman page. See Config.lua for what each list does.
smb.classConfigs.SHAMAN = {
    categories = {
        { name = "Custom" },
        { name = "Healing", spells = {
            "Healing Wave",
            "Lesser Healing Wave",
            "Chain Heal",
            "Riptide",
            "Nature's Swiftness",
            "Ancestral Spirit",
            "Reincarnation",
        } },
        { name = "Damage", spells = {
            "Lightning Bolt",
            "Chain Lightning",
            "Lava Burst",
            "Earth Shock",
            "Flame Shock",
            "Frost Shock",
            "Fire Nova",
            "Stormstrike",
            "Elemental Mastery",
            "Rage of the Farseer",
            "Searing Totem",
            "Magma Totem",
        } },
        { name = "Utility", spells = {
            "Purge",
            "Cure Poison",
            "Cure Disease",
            "Ghost Wolf",
            "Water Breathing",
            "Water Walking",
            "Far Sight",
            "Astral Recall",
            "Call of the *",
            "Totemic Recall",
            "Totemic Projection",
            "Earthbind Totem",
            "Tremor Totem",
            "Poison Cleansing Totem",
            "Disease Cleansing Totem",
            "Grounding Totem",
            "Sentry Totem",
        } },
        { name = "Buffs & Defence", spells = {
            "Rockbiter Weapon",
            "Flametongue Weapon",
            "Frostbrand Weapon",
            "Windfury Weapon",
            "Lightning Shield",
            "Water Shield",
            "Stoneclaw Totem",
            "Stoneskin Totem",
            "Strength of Earth Totem",
            "Healing Stream Totem",
            "Mana Spring Totem",
            "Mana Tide Totem",
            "Flametongue Totem",
            "Windfury Totem",
            "Grace of Air Totem",
            "Windwall Totem",
            "Fire Resistance Totem",
            "Frost Resistance Totem",
            "Nature Resistance Totem",
            "Tranquil Air Totem",
        } },
    },

    mouseoverEnemy = {
        "Lightning Bolt",
        "Chain Lightning",
        "Lava Burst",
        "Earth Shock",
        "Flame Shock",
        "Frost Shock",
        "Purge",
    },

    mouseoverFriend = {
        "Healing Wave",
        "Lesser Healing Wave",
        "Chain Heal",
        "Riptide",
        "Ancestral Spirit",
        "Cure Poison",
        "Cure Disease",
        "Water Breathing",
        "Water Walking",
    },

    cursor = {
        "Totemic Projection",
    },

    channeled = {},

    stealth = {},

    extraSpells = {
        8071, -- Stoneskin Totem
        3599, -- Searing Totem
        5394, -- Healing Stream Totem
    },

    custom = {},
}
