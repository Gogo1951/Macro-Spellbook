local _, ns = ...

--------------------------------------------------------------------------------
-- MIGRATION (remove after 2026-11-23)
--------------------------------------------------------------------------------

--[[
	Releases before AceDB kept every setting in MacroSpellbookDB's top level (account-wide) and the recorded
	trainer spells in MacroSpellbookCharDB (per character). Before AceDB takes the table over, the old keys move
	under legacySettings; each character's first login then copies them onto its own profile, and its
	MacroSpellbookCharDB, which stops being saved once it is nil.
]]
local LEGACY_KEYS = {
	"showUnlearned",
	"countSpellsOnBars",
	"mouseover",
	"cursor",
	"focus",
	"pet",
	"raidRank1",
	"spam",
	"stance",
	"petAttack",
	"stopCast",
	"startAttack",
	"useItems",
}

-- MIGRATION (remove after 2026-11-23)
function ns:MigrateLegacySavedVariables()
	local sv = MacroSpellbookDB
	if type(sv) ~= "table" or sv.profileKeys or sv.legacySettings then
		return
	end
	local legacy = {}
	for _, key in ipairs(LEGACY_KEYS) do
		legacy[key] = sv[key]
		sv[key] = nil
	end
	sv.legacySettings = legacy
end

-- MIGRATION (remove after 2026-11-23)
function ns:ImportLegacySettings()
	local profile = ns.db.profile
	if profile.legacyImported then
		return
	end
	profile.legacyImported = true
	local legacy = MacroSpellbookDB.legacySettings
	if legacy then
		for _, key in ipairs(LEGACY_KEYS) do
			local value = legacy[key]
			if type(value) == "table" then
				for name, setting in pairs(value) do
					profile[key][name] = setting
				end
			elseif value ~= nil then
				profile[key] = value == true
			end
		end
	end
	if type(MacroSpellbookCharDB) == "table" and type(MacroSpellbookCharDB.trainerSpells) == "table" then
		for id, level in pairs(MacroSpellbookCharDB.trainerSpells) do
			profile.trainerSpells[id] = level
		end
	end
	MacroSpellbookCharDB = nil
end
