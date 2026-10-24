local ADDON_NAME, ns = ...

local CountKeys = ns.CountDiagnosticKeys

--------------------------------------------------------------------------------
-- Framework Helpers
--------------------------------------------------------------------------------

--[[
	Two helpers the shared framework calls that Macro Spellbook's own code has no use for. ns.GetTooltipLines
	is Validate Data's tooltip read, one plain line per tooltip line with a right-hand column after " >> ";
	ns.ScanTooltipLines (Features/Utilities.lua) returns left and right texts unpaired, so it can't serve.
	C_TooltipInfo hands the lines over where the client ships its GetItemByID and GetSpellByID getters
	(Forever, Retail); elsewhere they are read off a hidden tooltip that is never shown.
]]
function ns:FormatCommaNumber(number)
	return (tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

local SCAN_TOOLTIP_NAME = "MacroSpellbookDiagnosticsTooltip"
local TOOLTIP_DATA_GETTERS = C_TooltipInfo
	and C_TooltipInfo.GetItemByID
	and C_TooltipInfo.GetSpellByID
	and { item = C_TooltipInfo.GetItemByID, spell = C_TooltipInfo.GetSpellByID }
local scanTooltip

local function PlainText(text)
	if type(text) ~= "string" then
		return nil
	end
	return (text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|cn[^:]*:", ""):gsub("|r", ""))
end

local function JoinTooltipLine(left, right)
	left = PlainText(left) or ""
	right = PlainText(right)
	if right and right ~= "" then
		return left .. " >> " .. right
	end
	return left
end

local function ReadTooltipData(kind, id)
	local lines = {}
	local data = TOOLTIP_DATA_GETTERS[kind](id)
	for _, line in ipairs(data and data.lines or {}) do
		lines[#lines + 1] = JoinTooltipLine(line.leftText, line.rightText)
	end
	return lines
end

local function ReadScanTooltip(kind, id)
	if not scanTooltip then
		scanTooltip = CreateFrame("GameTooltip", SCAN_TOOLTIP_NAME, nil, "GameTooltipTemplate")
	end
	scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	scanTooltip:ClearLines()
	scanTooltip:SetHyperlink(kind .. ":" .. id)
	local lines = {}
	for index = 1, scanTooltip:NumLines() do
		local left = _G[SCAN_TOOLTIP_NAME .. "TextLeft" .. index]
		local right = _G[SCAN_TOOLTIP_NAME .. "TextRight" .. index]
		lines[#lines + 1] = JoinTooltipLine(left and left:GetText(), right and right:IsShown() and right:GetText())
	end
	scanTooltip:Hide()
	return lines
end

ns.GetTooltipLines = TOOLTIP_DATA_GETTERS and ReadTooltipData or ReadScanTooltip

--------------------------------------------------------------------------------
-- API Endpoints
--------------------------------------------------------------------------------

local function Global(name)
	return {
		name,
		function()
			return _G[name] ~= nil
		end,
	}
end

local function Method(namespace, name, label)
	return {
		label or (namespace .. "." .. name),
		function()
			local owner = _G[namespace]
			return type(owner) == "table" and type(owner[name]) == "function"
		end,
	}
end

local function Template(name)
	return {
		"Template " .. name,
		function()
			return type(C_XMLUtil) == "table" and C_XMLUtil.GetTemplateInfo(name) ~= nil
		end,
	}
end

--[[
	Existence and shape checks only: read-only, no side effects. One row per API Macro Spellbook calls or
	guards. Every pair the add-on picks between at load is listed as both halves, and a FAIL on one half is
	the report working: it says which branch this client took. The spellbook read (C_SpellBook's skill lines,
	or the spell tab globals) picks ns.ForEachClassSpell; the tooltip reads (C_TooltipInfo's getters, or the
	hidden scan tooltip's Set methods) pick ns.ScanTooltipLines and ns.GetTrainerServiceSpellId; the
	spellbook itself is Blizzard_PlayerSpells with LibSpellBookTabs on the Retail engine, SpellBookFrame on
	the Classic engine; the page's header, settings cog and paging arrows each fall back without their
	template.
]]
ns.DIAGNOSTIC_API_CHECKS = {
	-- { label, testFunction }
	Method("C_AddOns", "GetAddOnMetadata"),
	Method("C_AddOns", "GetAddOnInfo"),
	Method("C_AddOns", "GetNumAddOns"),
	Method("C_AddOns", "IsAddOnLoaded"),
	Method("C_Seasons", "GetActiveSeason"),
	{
		"Enum.SeasonID.SeasonOfDiscovery",
		function()
			return type(Enum) == "table" and type(Enum.SeasonID) == "table" and Enum.SeasonID.SeasonOfDiscovery ~= nil
		end,
	},

	-- The spellbook read, Retail-engine half.
	Method("C_SpellBook", "GetNumSpellBookSkillLines"),
	Method("C_SpellBook", "GetSpellBookSkillLineInfo"),
	Method("C_SpellBook", "GetSpellBookItemInfo"),
	{
		"Enum.SpellBookSpellBank.Player and Enum.SpellBookItemType.Spell",
		function()
			return type(Enum) == "table"
				and type(Enum.SpellBookSpellBank) == "table"
				and Enum.SpellBookSpellBank.Player ~= nil
				and type(Enum.SpellBookItemType) == "table"
				and Enum.SpellBookItemType.Spell ~= nil
		end,
	},
	-- The spellbook read, Classic-engine half.
	Global("GetNumSpellTabs"),
	Global("GetSpellTabInfo"),
	Global("GetSpellBookItemInfo"),
	Global("GetSpellBookItemName"),
	Global("GetSpellBookItemTexture"),
	Global("IsPassiveSpell"),
	Global("BOOKTYPE_SPELL"),

	-- Every spell the page names, sorts or builds a macro for.
	Method("C_Spell", "GetSpellName"),
	Method("C_Spell", "GetSpellTexture"),
	Method("C_Spell", "GetSpellSubtext"),
	Method("C_Spell", "IsSpellHarmful"),
	Method("C_Spell", "SpellHasRange"),
	Method("C_Spell", "IsSpellPassive"),
	Method("C_Spell", "RequestLoadSpellData"),
	Method("C_Spell", "GetSpellDescription"),
	Method("C_Spell", "IsSpellDataCached"),
	Method("C_CreatureInfo", "GetCreatureFamilyInfo"),
	Method("C_Item", "GetItemSpell"),
	Method("C_Item", "GetItemInfo"),
	Method("C_Item", "GetItemInfoInstant"),
	Method("C_Item", "RequestLoadItemDataByID"),
	Method("C_Item", "DoesItemExistByID"),
	Global("GetShapeshiftFormInfo"),
	Global("GetNumShapeshiftForms"),
	Global("GetInventoryItemLink"),
	Global("GetInventoryItemTexture"),

	-- The tooltip reads, Retail-engine half.
	Method("C_TooltipInfo", "GetSpellByID"),
	Method("C_TooltipInfo", "GetItemByID"),
	Method("C_TooltipInfo", "GetInventoryItem"),
	Method("C_TooltipInfo", "GetTrainerService"),
	-- The tooltip reads, Classic-engine half: the scan tooltip's methods, probed on GameTooltip, which has them too.
	Method("GameTooltip", "SetSpellByID", "Hidden scan tooltip SetSpellByID (legacy)"),
	Method("GameTooltip", "SetInventoryItem", "Hidden scan tooltip SetInventoryItem (legacy)"),
	Method("GameTooltip", "SetTrainerService", "Hidden scan tooltip SetTrainerService (legacy)"),
	Method("GameTooltip", "GetSpell", "Hidden scan tooltip GetSpell (legacy)"),
	Method("GameTooltip", "SetHyperlink", "Hidden scan tooltip SetHyperlink (legacy)"),

	-- Writing and placing the macros.
	Global("CreateMacro"),
	Global("EditMacro"),
	Global("GetMacroIndexByName"),
	Global("GetMacroInfo"),
	Global("GetNumMacros"),
	Global("PickupMacro"),
	Global("GetActionInfo"),
	Global("GetActionText"),
	Global("InCombatLockdown"),

	-- Recording trainer spells.
	Global("GetNumTrainerServices"),
	Global("GetTrainerServiceLevelReq"),
	Global("IsTradeskillTrainer"),
	Method("C_Trainer", "GetTrainerType"),

	-- The Retail-engine spellbook and LibSpellBookTabs.
	Global("PlayerSpellsFrame"),
	Method("EventUtil", "ContinueOnAddOnLoaded"),
	Method("EventRegistry", "RegisterCallback"),
	Global("RunNextFrame"),
	Template("SpellBookHeaderTemplate"),
	Template("SpellBookSettingsDropdownTemplate"),
	-- The Classic-engine spellbook.
	Global("SpellBookFrame"),
	Global("SpellBookSkillLineTab1"),
	Global("UISpecialFrames"),
	Template("PortraitFrameTemplate"),
	Template("BasicFrameTemplate"),
	{
		"SpellBookFrame.Update",
		function()
			return type(SpellBookFrame) == "table" and type(SpellBookFrame.Update) == "function"
		end,
	},
	Global("hooksecurefunc"),
	-- The page itself, on either book.
	Template("PagingControlsHorizontalTemplate"),
	Method("C_XMLUtil", "GetTemplateInfo"),
	Method("C_Texture", "GetAtlasInfo"),
	Method("MenuUtil", "CreateContextMenu"),

	Method("Settings", "OpenToCategory"),
	Method("C_Timer", "After"),
	Method("C_EventUtils", "IsEventValid"),
	Global("GetCVar"),
	Global("SetCVar"),
}

--------------------------------------------------------------------------------
-- Shared Reads
--------------------------------------------------------------------------------

local function OnOff(value)
	return value and "on" or "off"
end

local function YesNo(value)
	return value and "yes" or "no"
end

local function Shown(text)
	return (tostring(text):gsub("\r?\n", "\\n"):gsub("|", "||"))
end

local function PlayerClass()
	return select(2, UnitClass("player"))
end

local function ClassLists()
	return ns.CLASS_SPELL_LISTS and ns.CLASS_SPELL_LISTS[PlayerClass()]
end

-- An entry of a class list is a spell ID, or a table of every rank's ID.
local function EntryIds(entry)
	return type(entry) == "table" and entry or { entry }
end

-- How many of a list's entries this client names, and the IDs of the ones it doesn't.
local function ResolvedCount(entries)
	local resolved, missing = 0, {}
	for _, entry in ipairs(entries or {}) do
		local named = false
		for _, id in ipairs(EntryIds(entry)) do
			if C_Spell.GetSpellName(id) then
				named = true
			end
		end
		if named then
			resolved = resolved + 1
		else
			missing[#missing + 1] = tostring(EntryIds(entry)[1])
		end
	end
	return resolved, missing
end

local function ListLine(label, entries)
	local resolved, missing = ResolvedCount(entries)
	local line = string.format("  %s: %d of %d named", label, resolved, #(entries or {}))
	if #missing > 0 then
		line = line .. " (no name for " .. table.concat(missing, ", ") .. ")"
	end
	return line
end

local LIST_KEYS =
	{ "mouseoverEnemy", "mouseoverFriend", "cursor", "raidRank1", "channeled", "stealth", "noToggle", "extraSpells" }
local PER_SPELL_OPTIONS = {
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
	"noToggle",
	"castOnSelf",
	"targetRank",
	"fixedRank",
	"targetTarget",
	"targetEnemy",
	"combatOnly",
	"noCombat",
	"oncePerCombat",
	"oncePerTarget",
	"stopAttack",
	"hideErrors",
	"muteErrors",
	"cancelForm",
	"autoShot",
	"groupVersion",
}

--------------------------------------------------------------------------------
-- Spells
--------------------------------------------------------------------------------

--[[
	The spells the page gates options on for the player's class: the Warrior stances a stance option switches
	to, and each summon spell with the pet ability it casts while that pet is out. Built from the flavor's
	class lists, so it follows the data folder this client loaded.
]]
ns.DIAGNOSTIC_SPELLS = {}
do
	local lists = ClassLists()
	for _, id in ipairs(lists and lists.stanceSlots or {}) do
		ns.DIAGNOSTIC_SPELLS[#ns.DIAGNOSTIC_SPELLS + 1] = { label = "stance", id = id }
	end
	for summonId, pet in pairs(lists and lists.petAbilities or {}) do
		ns.DIAGNOSTIC_SPELLS[#ns.DIAGNOSTIC_SPELLS + 1] = { label = "summon", id = summonId }
		ns.DIAGNOSTIC_SPELLS[#ns.DIAGNOSTIC_SPELLS + 1] = { label = "pet ability", id = pet.abilityId }
	end
end

local function SpellLine(spell)
	return string.format(
		"  %s %d: %s, IsPlayerSpell %s, IsSpellKnown %s",
		spell.label,
		spell.id,
		tostring(C_Spell.GetSpellName(spell.id) or "NIL"),
		tostring(IsPlayerSpell(spell.id)),
		tostring(IsSpellKnown(spell.id))
	)
end

--------------------------------------------------------------------------------
-- Page Context
--------------------------------------------------------------------------------

-- The add-on's own example reports, appended to the shared Event Log intro.
ns.DiagnosticsStrings.EVENT_LOG_EXAMPLES =
	"Best for 'the page never fills in', 'a macro doesn't update' or 'the glow is wrong' reports."

local function HostLines(lines)
	local libSpellBookTabs = LibStub.libs["LibSpellBookTabs-1.0"]
	if libSpellBookTabs then
		local tab = libSpellBookTabs.byId and libSpellBookTabs.byId[ADDON_NAME]
		lines[#lines + 1] = string.format(
			"Spellbook: Retail-engine (LibSpellBookTabs minor %s); Blizzard_PlayerSpells loaded %s, attached %s, tab registered %s, page built %s, page open %s",
			tostring(LibStub.minors["LibSpellBookTabs-1.0"]),
			YesNo(C_AddOns.IsAddOnLoaded("Blizzard_PlayerSpells")),
			YesNo(libSpellBookTabs.book ~= nil),
			YesNo(tab ~= nil),
			YesNo(tab and tab.page ~= nil),
			YesNo(libSpellBookTabs.active ~= nil and libSpellBookTabs.active == tab)
		)
	else
		lines[#lines + 1] = string.format(
			"Spellbook: Classic-engine; SpellBookFrame present %s, shown %s, book type %s; page window built %s, shown %s",
			YesNo(SpellBookFrame ~= nil),
			YesNo(SpellBookFrame and SpellBookFrame:IsShown()),
			tostring(SpellBookFrame and SpellBookFrame.bookType),
			YesNo(_G.MacroSpellbookFrame ~= nil),
			YesNo(_G.MacroSpellbookFrame and _G.MacroSpellbookFrame:IsShown())
		)
	end
end

local function ClassListLines(lines)
	local lists = ClassLists()
	if not lists then
		lines[#lines + 1] = "Class lists: none for this class on this flavor"
		return
	end
	lines[#lines + 1] = "Class lists:"
	for _, key in ipairs(LIST_KEYS) do
		lines[#lines + 1] = ListLine(key, lists[key])
	end
	local stances, stancesNamed = 0, 0
	for spellId, stanceIds in pairs(lists.stances or {}) do
		stances = stances + 1
		local named = C_Spell.GetSpellName(spellId) ~= nil
		for _, stanceId in ipairs(stanceIds) do
			named = named and C_Spell.GetSpellName(stanceId) ~= nil
		end
		stancesNamed = stancesNamed + (named and 1 or 0)
	end
	lines[#lines + 1] = string.format("  stances: %d of %d named with all their stances", stancesNamed, stances)
	for summonId, pet in pairs(lists.petAbilities or {}) do
		local family = C_CreatureInfo.GetCreatureFamilyInfo(pet.familyId)
		lines[#lines + 1] = string.format(
			"  pet: %s casts %s while [pet:%s] (family %d)",
			tostring(C_Spell.GetSpellName(summonId) or ("NIL " .. summonId)),
			tostring(C_Spell.GetSpellName(pet.abilityId) or ("NIL " .. pet.abilityId)),
			tostring(family and family.name or "NIL"),
			pet.familyId
		)
	end
	lines[#lines + 1] = string.format("  default custom macros: %d", #(lists.customMacros or {}))
end

local function SpellbookLines(lines)
	local total, byLine, order = 0, {}, {}
	local ok, problem = pcall(ns.ForEachClassSpell, function(_, _, _, lineName, line)
		total = total + 1
		local key = string.format("%s %s", tostring(line), tostring(lineName))
		if not byLine[key] then
			byLine[key] = 0
			order[#order + 1] = key
		end
		byLine[key] = byLine[key] + 1
	end)
	if not ok then
		lines[#lines + 1] = "Spellbook spells: (read failed: " .. Shown(problem) .. ")"
		return
	end
	lines[#lines + 1] = string.format("Spellbook spells (castable, every rank): %d", total)
	for _, key in ipairs(order) do
		lines[#lines + 1] = string.format("  skill line %s: %d", key, byLine[key])
	end
end

local function PageListLines(lines)
	local byCategory, order = {}, {}
	local kinds = { custom = 0, equipment = 0, unlearned = 0, focus = 0 }
	for _, macro in ipairs(ns.macros or {}) do
		local category = tostring(macro.category)
		if not byCategory[category] then
			byCategory[category] = 0
			order[#order + 1] = category
		end
		byCategory[category] = byCategory[category] + 1
		for kind in pairs(kinds) do
			if macro[kind] then
				kinds[kind] = kinds[kind] + 1
			end
		end
	end
	lines[#lines + 1] = string.format(
		"Page list (as of the page's last redraw): %d macros; custom %d, equipment %d, unlearned %d, focus copies %d",
		#(ns.macros or {}),
		kinds.custom,
		kinds.equipment,
		kinds.unlearned,
		kinds.focus
	)
	for _, category in ipairs(order) do
		lines[#lines + 1] = string.format("  %s: %d", category, byCategory[category])
	end
end

--[[
	The state most likely to explain a "the tab isn't there", "a spell is missing" or "an option isn't offered"
	report: who the player is and which data folder and spellbook this client gave them, whether the page's tab
	and page exist, how much of the class lists this client could name (an ID it can't name never matches, so
	that spell loses its options), the spells the options gate on, what the spellbook
	holds by skill line, every page setting and which class options apply, the unlearned-spells sources, the
	options panel route, and what the page last listed. Existence/value reads only.
]]
function ns:BuildPageContextReport()
	local lines = { ns.GetDiagnosticClientHeader(), "" }
	local _, race = UnitRace("player")
	lines[#lines + 1] = string.format(
		"Player: %s %s %s level %d, in combat %s; expansion %s",
		tostring(UnitFactionGroup("player")),
		tostring(race),
		tostring(PlayerClass()),
		UnitLevel("player") or 0,
		YesNo(InCombatLockdown()),
		tostring(ns.EXPANSION)
	)
	HostLines(lines)
	lines[#lines + 1] = ""
	ClassListLines(lines)
	lines[#lines + 1] = "Spells the options gate on:"
	if #ns.DIAGNOSTIC_SPELLS == 0 then
		lines[#lines + 1] = "  (none for this class)"
	end
	for _, spell in ipairs(ns.DIAGNOSTIC_SPELLS) do
		lines[#lines + 1] = SpellLine(spell)
	end
	lines[#lines + 1] = string.format("Stance bar forms: %d", GetNumShapeshiftForms() or 0)
	SpellbookLines(lines)

	lines[#lines + 1] = ""
	local profile = ns.db and ns.db.profile
	if profile then
		lines[#lines + 1] = "Profile: " .. tostring(ns.db:GetCurrentProfile())
		lines[#lines + 1] = string.format(
			"Page settings: show unlearned %s (unlearned file loaded %s), count spells on bars %s",
			OnOff(profile.showUnlearned),
			YesNo(ns.ForEachUnlearnedSpell ~= nil),
			OnOff(profile.countSpellsOnBars)
		)
		lines[#lines + 1] = string.format(
			"Defaults: pet attack %s (class offers %s), start attack %s (melee class %s), stop casting %s (class offers %s)",
			OnOff(profile.petAttackDefault),
			YesNo(ns.ClassOffersPetAttack()),
			OnOff(profile.startAttackDefault),
			YesNo(ns.IsMeleeClass()),
			OnOff(profile.stopCastDefault),
			YesNo(not ns.IsMeleeClass())
		)
		local counts = {}
		for _, key in ipairs(PER_SPELL_OPTIONS) do
			counts[#counts + 1] = key .. "=" .. CountKeys(profile[key])
		end
		lines[#lines + 1] = "Per-spell settings saved: " .. table.concat(counts, ", ")
		lines[#lines + 1] = string.format(
			"Unlearned sources: bundled trainer rows %d, recorded by this character %d",
			#((ns.TRAINER_SPELLS or {})[PlayerClass()] or {}),
			CountKeys(profile.trainerSpells)
		)
	else
		lines[#lines + 1] = "Profile: (database not loaded)"
	end
	local settingsRoute = type(Settings) == "table"
		and Settings.OpenToCategory
		and ns.optionsFrames
		and ns.optionsFrames.categoryID
	lines[#lines + 1] = string.format(
		"Options panel: category id %s, /msb opens it through %s",
		tostring(ns.optionsFrames and ns.optionsFrames.categoryID),
		settingsRoute and "Settings.OpenToCategory" or "AceConfigDialog:Open"
	)

	lines[#lines + 1] = ""
	PageListLines(lines)
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Macro Context
--------------------------------------------------------------------------------

local MAX_MACRO_BODY = 255

local function MaxAccountMacros()
	return MAX_ACCOUNT_MACROS or 120
end

-- The add-on's own owned-macro check, read without the migration's adoption.
local function IsRecordedOwned(macroName, index)
	if not ns.db then
		return false
	end
	local list = index > MaxAccountMacros() and ns.db.char.ownedMacros or ns.db.global.ownedMacros
	return list[macroName] == true
end

local function CustomMacroLines(lines, profile)
	local invalid, seen, duplicates = 0, {}, 0
	for _, entry in ipairs(profile.customMacros) do
		local name, body = entry.name, entry.body
		if type(name) ~= "string" or name == "" or type(body) ~= "string" or body == "" or #body > MAX_MACRO_BODY then
			invalid = invalid + 1
		elseif seen[name:sub(1, 16)] then
			duplicates = duplicates + 1
		else
			seen[name:sub(1, 16)] = true
		end
	end
	lines[#lines + 1] = string.format(
		"Custom macros: %d (defaults seeded %s); %d with no name, no body or over %d bytes, %d sharing a name",
		#profile.customMacros,
		YesNo(profile.customMacrosSeeded),
		invalid,
		MAX_MACRO_BODY,
		duplicates
	)
end

--[[
	The state behind "clicking a macro does nothing", "my own macro was left alone" or "the macro didn't
	update": combat, free macro slots (character macros spill into general ones once full, and the add-on
	reads Blizzard_MacroUI's limits, with fallbacks until that has loaded), which macros the add-on recorded
	as its own, every page macro whose name an unrecorded macro already holds, page macros out of step with
	their WoW macro, what is on the action bars, the equipped items with a Use: effect, the custom macros, and
	the trainer recording. Existence/value reads only.
]]
function ns:BuildMacroContextReport()
	local lines = { ns.GetDiagnosticClientHeader(), "" }
	lines[#lines + 1] = "In combat: " .. YesNo(InCombatLockdown())
	local numAccount, numCharacter = GetNumMacros()
	lines[#lines + 1] = string.format(
		"Macros: %d of %s general, %d of %s character%s",
		numAccount or 0,
		tostring(MAX_ACCOUNT_MACROS or 120),
		numCharacter or 0,
		tostring(MAX_CHARACTER_MACROS or 18),
		(MAX_ACCOUNT_MACROS and MAX_CHARACTER_MACROS) and "" or " (Blizzard_MacroUI not loaded yet: fallback limits)"
	)
	if not ns.db then
		lines[#lines + 1] = "(database not loaded)"
		return table.concat(lines, "\n")
	end
	lines[#lines + 1] = string.format(
		"Recorded as the add-on's: %d general, %d character",
		CountKeys(ns.db.global.ownedMacros),
		CountKeys(ns.db.char.ownedMacros)
	)

	local taken, outOfStep, missing = {}, 0, 0
	for _, macro in ipairs(ns.macros or {}) do
		local index = GetMacroIndexByName(macro.macroName)
		if index == 0 then
			missing = missing + 1
		elseif not IsRecordedOwned(macro.macroName, index) then
			taken[#taken + 1] = macro.macroName
		elseif select(3, GetMacroInfo(index)) ~= macro.body then
			outOfStep = outOfStep + 1
		end
	end
	lines[#lines + 1] = string.format(
		"Page macros (as of the page's last redraw): %d not created yet, %d recorded but not matching the page",
		missing,
		outOfStep
	)
	lines[#lines + 1] = "Names held by a macro the add-on hasn't recorded: "
		.. (taken[1] and table.concat(taken, ", ") or "none")

	local scanOk, bars = pcall(ns.ScanActionBars)
	if scanOk then
		local placed = 0
		for _, macro in ipairs(ns.macros or {}) do
			if ns.IsOnActionBars(macro, bars) then
				placed = placed + 1
			end
		end
		lines[#lines + 1] = string.format(
			"Action bars: %d macros, %d spells; %d page macros count as placed",
			CountKeys(bars.macros),
			CountKeys(bars.spells),
			placed
		)
	else
		lines[#lines + 1] = "Action bars: (read failed: " .. Shown(bars) .. ")"
	end

	local usableOk, usable = pcall(ns.UsableSlots)
	if usableOk then
		local slots = {}
		for _, entry in ipairs(usable) do
			slots[#slots + 1] = string.format("%d %s", entry.slot, Shown(ns.SlotLabel(entry.slot)))
		end
		lines[#lines + 1] = "Equipped items with a Use: effect: " .. (slots[1] and table.concat(slots, "; ") or "none")
	else
		lines[#lines + 1] = "Equipped items with a Use: effect: (read failed: " .. Shown(usable) .. ")"
	end

	CustomMacroLines(lines, ns.db.profile)
	lines[#lines + 1] = string.format(
		"Trainer recording: file loaded %s, %d spells recorded on this character",
		YesNo(ns.OnTrainerShow ~= nil),
		CountKeys(ns.db.profile.trainerSpells)
	)
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Name Lookups
--------------------------------------------------------------------------------

--[[
	Every game record Macro Spellbook names by ID, for the Localization tab's Game Names report: the client
	strings it reads or matches, the slot names its Equipment section shows, and every spell and creature
	family in the player's class lists, each read as the features read it. The spells are the player's class
	only, the class whose page this character sees. A spell loads late, so its row asks for it.
]]
local function UiLabel(constant)
	return {
		constant = constant,
		kind = "uiLabel",
		id = constant,
		lookup = function()
			return _G[constant]
		end,
	}
end

local function SpellRow(constant, id)
	return {
		constant = constant,
		kind = "spell",
		id = id,
		lookup = function()
			return C_Spell.GetSpellName(id)
		end,
		request = function()
			C_Spell.RequestLoadSpellData(id)
		end,
	}
end

ns.DIAGNOSTIC_NAME_LOOKUPS = {
	-- { constant, kind, id, lookup, request }
	UiLabel("SPELL_REQUIRED_FORM"),
	UiLabel("RANK"),
	UiLabel("SETTINGS"),
	UiLabel("ITEM_SPELL_TRIGGER_ONUSE"),
	UiLabel("ERR_NOT_IN_COMBAT"),
	UiLabel("HEADSLOT"),
	UiLabel("NECKSLOT"),
	UiLabel("SHOULDERSLOT"),
	UiLabel("SHIRTSLOT"),
	UiLabel("CHESTSLOT"),
	UiLabel("WAISTSLOT"),
	UiLabel("LEGSSLOT"),
	UiLabel("FEETSLOT"),
	UiLabel("WRISTSLOT"),
	UiLabel("HANDSSLOT"),
	UiLabel("FINGER0SLOT_UNIQUE"),
	UiLabel("FINGER1SLOT_UNIQUE"),
	UiLabel("TRINKET0SLOT_UNIQUE"),
	UiLabel("TRINKET1SLOT_UNIQUE"),
	UiLabel("BACKSLOT"),
	UiLabel("MAINHANDSLOT"),
	UiLabel("SECONDARYHANDSLOT"),
	UiLabel("RANGEDSLOT"),
	UiLabel("TABARDSLOT"),
}

do
	local lists = ClassLists()
	local rows, seen = ns.DIAGNOSTIC_NAME_LOOKUPS, {}
	local function AddSpell(constant, id)
		if not seen[id] then
			seen[id] = true
			rows[#rows + 1] = SpellRow(constant, id)
		end
	end
	local function AddEntries(constant, entries)
		for position, entry in ipairs(entries or {}) do
			for _, id in ipairs(EntryIds(entry)) do
				AddSpell(string.format("%s[%d]", constant, position), id)
			end
		end
	end
	if lists then
		for _, key in ipairs(LIST_KEYS) do
			AddEntries(key, lists[key])
		end
		for _, id in ipairs(lists.stanceSlots or {}) do
			AddSpell("stanceSlots", id)
		end
		for spellId, stanceIds in pairs(lists.stances or {}) do
			AddSpell("stances", spellId)
			for _, stanceId in ipairs(stanceIds) do
				AddSpell("stances", stanceId)
			end
		end
		for summonId, pet in pairs(lists.petAbilities or {}) do
			AddSpell("petAbilities", summonId)
			AddSpell("petAbilities", pet.abilityId)
			rows[#rows + 1] = {
				constant = "petAbilities",
				kind = "creatureFamily",
				id = pet.familyId,
				lookup = function()
					local info = C_CreatureInfo.GetCreatureFamilyInfo(pet.familyId)
					return info and info.name
				end,
			}
		end
		for _, entry in ipairs(lists.customMacros or {}) do
			for id in tostring(entry.name or ""):gmatch("{spell:(%d+)}") do
				AddSpell("customMacros", tonumber(id))
			end
			for id in tostring(entry.body or ""):gmatch("{spell:(%d+)}") do
				AddSpell("customMacros", tonumber(id))
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Validate Data Sources
--------------------------------------------------------------------------------

--[[
	One entry per data file, and one report row per entry on the Data tab. Both tables are keyed by class
	token, so each collector walks every class and answers once per spell ID, keeping the class and where the
	ID sits as its DATA_* values. A class list entry with several rank IDs answers once per rank.
]]
local function KeyValue(key)
	return key
end

local function RowField(field)
	return function(_, row)
		local value = type(row) == "table" and row[field] or nil
		if type(value) == "table" then
			return table.concat(value, ",")
		end
		return value
	end
end

local function CollectClassListSpells(listsByClass)
	local entries = {}
	local function Add(classToken, list, entry)
		for _, id in ipairs(EntryIds(entry)) do
			entries[#entries + 1] = { id = id, key = classToken, row = { list = list } }
		end
	end
	for classToken, lists in pairs(listsByClass) do
		for _, key in ipairs(LIST_KEYS) do
			for _, entry in ipairs(lists[key] or {}) do
				Add(classToken, key, entry)
			end
		end
		for _, id in ipairs(lists.stanceSlots or {}) do
			Add(classToken, "stanceSlots", id)
		end
		for spellId, stanceIds in pairs(lists.stances or {}) do
			Add(classToken, "stances", spellId)
			for _, stanceId in ipairs(stanceIds) do
				Add(classToken, "stances", stanceId)
			end
		end
		for summonId, pet in pairs(lists.petAbilities or {}) do
			Add(classToken, "petAbilities", summonId)
			Add(classToken, "petAbilities", pet.abilityId)
		end
		for _, entry in ipairs(lists.customMacros or {}) do
			for id in tostring(entry.body or ""):gmatch("{spell:(%d+)}") do
				Add(classToken, "customMacros", tonumber(id))
			end
		end
	end
	return entries
end

local function CollectTrainerSpells(spellsByClass)
	local entries = {}
	for classToken, rows in pairs(spellsByClass) do
		for _, row in ipairs(rows) do
			entries[#entries + 1] = { id = row.id, key = classToken, row = row }
		end
	end
	return entries
end

ns.DIAGNOSTIC_DATA_SOURCES = {
	-- { label, sources = { { table, kind, rowId or collect, dataColumns } } }
	{
		label = "Class-Spell-Lists",
		sources = {
			{
				table = "CLASS_SPELL_LISTS",
				kind = "spell",
				collect = CollectClassListSpells,
				dataColumns = { { "DATA_CLASS", KeyValue }, { "DATA_LIST", RowField("list") } },
			},
		},
	},
	{
		label = "Trainer-Spells",
		sources = {
			{
				table = "TRAINER_SPELLS",
				kind = "spell",
				collect = CollectTrainerSpells,
				dataColumns = {
					{ "DATA_CLASS", KeyValue },
					{ "DATA_LEVEL", RowField("level") },
					{ "DATA_REQUIRES", RowField("requires") },
					{ "DATA_FACTION", RowField("faction") },
					{ "DATA_RACE", RowField("race") },
					{ "DATA_TALENT", RowField("talent") },
				},
			},
		},
	},
}
