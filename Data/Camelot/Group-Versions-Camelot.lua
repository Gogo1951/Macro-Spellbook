local _, ns = ...

-- [singleSpellId] = groupSpellId, -- Single Spell -> Group Spell
ns.GROUP_VERSIONS = {
	-- Druid
	[1126] = 21849, -- Mark of the Wild -> Gift of the Wild
	-- Mage
	[1459] = 23028, -- Arcane Intellect -> Arcane Brilliance
	[3561] = 10059, -- Teleport: Stormwind -> Portal: Stormwind
	[3562] = 11416, -- Teleport: Ironforge -> Portal: Ironforge
	[3565] = 11419, -- Teleport: Darnassus -> Portal: Darnassus
	[32271] = 32266, -- Teleport: Exodar -> Portal: Exodar
	[33690] = 33691, -- Teleport: Shattrath (Alliance) -> Portal: Shattrath
	[3567] = 11417, -- Teleport: Orgrimmar -> Portal: Orgrimmar
	[3563] = 11418, -- Teleport: Undercity -> Portal: Undercity
	[3566] = 11420, -- Teleport: Thunder Bluff -> Portal: Thunder Bluff
	[32272] = 32267, -- Teleport: Silvermoon -> Portal: Silvermoon
	[35715] = 35717, -- Teleport: Shattrath (Horde) -> Portal: Shattrath
	-- Paladin
	[19740] = 25782, -- Blessing of Might -> Greater Blessing of Might
	[19742] = 25894, -- Blessing of Wisdom -> Greater Blessing of Wisdom
	[20217] = 25898, -- Blessing of Kings -> Greater Blessing of Kings
	[1038] = 25895, -- Blessing of Salvation -> Greater Blessing of Salvation
	[19977] = 25890, -- Blessing of Light -> Greater Blessing of Light
	[20911] = 25899, -- Blessing of Sanctuary -> Greater Blessing of Sanctuary
	-- Priest
	[1243] = 21562, -- Power Word: Fortitude -> Prayer of Fortitude
	[14752] = 27681, -- Divine Spirit -> Prayer of Spirit
	[976] = 27683, -- Shadow Protection -> Prayer of Shadow Protection
}

--[[
How We Got the Data

Last Validated
	Never.

Notes
	- Each row pairs a single-target spell with its group version, as [singleSpellId] = groupSpellId: Mark of the Wild with Gift of the Wild, Arcane Intellect with Arcane Brilliance, each mage Teleport with its Portal, each paladin Blessing with its Greater Blessing, and the priest buffs with their Prayers.
	- The "Right-Click For Group Version" option reads it (ResolveClassConfig in Features/Macro-Builder.lua): a learned single spell whose group version is also learned can cast the group version on a right-click.
	- Both names come from the client, so a pair whose spells this client does not know drops out at runtime until the Data Review prunes it from this folder.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	None.

QuestieDB
	None.
]]
