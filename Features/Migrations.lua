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

--[[
	MIGRATION (remove after 2026-11-23)
	The done flag lives in the char scope, which a profile reset, switch or copy never clears, so none of them
	brings the old settings back.
]]
function ns:ImportLegacySettings()
	local profile = ns.db.profile
	if ns.db.char.legacyImported then
		return
	end
	ns.db.char.legacyImported = true
	local legacy = MacroSpellbookDB.legacySettings
	if legacy then
		for _, key in ipairs(LEGACY_KEYS) do
			local value = legacy[key]
			--[[
				a setting since removed (raidRank1) has no profile table; it is moved out of the top level and
				dropped. spam is carried into profile.spam, which ns:MigrateSpammable moves to its new options
			]]
			if key == "spam" and type(value) == "table" then
				profile.spam = profile.spam or {}
			end
			if type(value) == "table" and profile[key] then
				for name, setting in pairs(value) do
					profile[key][name] = setting
				end
			elseif value ~= nil and type(value) ~= "table" then
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

--[[
	MIGRATION (remove after 2026-11-23)
	Spammable is retired. On Stealth or Prowl it kept the spell from breaking stealth, now Stop Macro If
	Stealthed; on a channeled spell it kept a press from breaking the channel, now Stop Macro If Channeling.
	Each spell's own setting moves to the option that does its job, and a kind's default becomes its Stop
	Macro If Channeling default. Run at login and on every profile change, so each profile moves when it is
	first used; a moved profile has no spam table left, so it runs once.
]]
function ns:MigrateSpammable()
	local profile = ns.db.profile
	if type(profile.spam) == "table" then
		local stealthSpells = ns.ClassConfig().stealthSpells
		for name, value in pairs(profile.spam) do
			local key = stealthSpells[name] and "stopIfStealthed" or "stopIfChanneling"
			if profile[key][name] == nil then
				profile[key][name] = value
			end
		end
	end
	profile.spam = nil
	for _, defaults in pairs(profile.kindDefaults) do
		if defaults.spam then
			defaults.stopIfChanneling = true
		end
		defaults.spam = nil
	end
end

--[[
	MIGRATION (remove after 2026-11-23)
	Buffs were Friendly Spells until they got a kind of their own, so a profile's Friendly defaults carry over
	to Buffs once, where Buffs has no setting of its own yet, and its macros keep the options they had. Run at
	login and on every profile change, after ns:MigrateSpammable, which can add a Friendly default; the
	buffKindCopied flag stops it running twice on one profile.
]]
function ns:MigrateBuffKind()
	local profile = ns.db.profile
	if profile.buffKindCopied then
		return
	end
	local friendly, buff = profile.kindDefaults.friendly, profile.kindDefaults.buff
	for key, on in pairs(friendly) do
		if on == true and rawget(buff, key) == nil then
			buff[key] = true
		end
	end
	profile.buffKindCopied = true
end
