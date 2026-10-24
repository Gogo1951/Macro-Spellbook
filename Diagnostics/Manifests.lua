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
	hidden scan tooltip's Set methods) pick ns.ScanTooltipLines and ns.GetTrainerServiceSpellId; the macro
	slot limits come from Constants.MacroConsts or the MAX_*_MACROS globals; the spellbook itself is
	Blizzard_PlayerSpells with LibSpellBookTabs on the Retail engine, SpellBookFrame on the Classic engine;
	the page's header, settings cog and paging arrows each fall back without their template.
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
	Method("C_Spell", "GetSpellInfo"),
	Method("C_Spell", "GetSpellTexture"),
	Method("C_Spell", "GetSpellSubtext"),
	Method("C_Spell", "IsSpellHarmful"),
	Method("C_Spell", "SpellHasRange"),
	Method("C_Spell", "IsSpellPassive"),
	Method("C_Spell", "RequestLoadSpellData"),
	Method("C_Spell", "GetSpellLevelLearned", "C_Spell.GetSpellLevelLearned (guarded)"),
	Method("C_Spell", "GetSpellDescription"),
	Method("C_Spell", "IsSpellDataCached"),
	Global("IsPlayerSpell"),
	Method("C_CreatureInfo", "GetCreatureFamilyInfo"),
	Method("C_Item", "GetItemSpell"),
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
	-- The macro slot limits, Retail-engine half then Classic-engine half.
	{
		"Constants.MacroConsts",
		function()
			return type(Constants) == "table" and type(Constants.MacroConsts) == "table"
		end,
	},
	Global("MAX_ACCOUNT_MACROS"),
	Global("MAX_CHARACTER_MACROS"),
	Global("PickupMacro"),
	Global("GetActionInfo"),
	Global("GetActionText"),
	Global("InCombatLockdown"),
	-- The Mute Errors option's sound settings.
	Method("C_CVar", "GetCVar"),
	Method("C_CVar", "SetCVar"),

	-- Recording trainer spells.
	Global("GetNumTrainerServices"),
	Global("GetTrainerServiceLevelReq"),
	Global("IsTradeskillTrainer"),
	Method("C_Trainer", "GetTrainerType"),
	{
		"Enum.TrainerType",
		function()
			return type(Enum) == "table" and type(Enum.TrainerType) == "table"
		end,
	},

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
	Method("C_XMLUtil", "GetTemplateInfo"),
	Method("C_Texture", "GetAtlasInfo"),
	Method("MenuUtil", "CreateContextMenu"),

	Method("Settings", "OpenToCategory"),
	--[[
		The key binding: its toggle opens the Retail-engine book through PlayerSpellsUtil where the client has
		it, and the General panel shows the bound key. Then the three routes ns:OpenKeyBindings tries for the
		Set Key button, in its order; one route passing whole is enough, and the report says which one this
		client has.
	]]
	Method("PlayerSpellsUtil", "OpenToSpellBookTab", "PlayerSpellsUtil.OpenToSpellBookTab (guarded)"),
	Global("GetBindingKey"),
	{
		"GetBindingText (guarded)",
		function()
			return type(GetBindingText) == "function"
		end,
	},
	{
		"Settings.KEYBINDINGS_CATEGORY_ID",
		function()
			return type(Settings) == "table" and Settings.KEYBINDINGS_CATEGORY_ID ~= nil
		end,
	},
	Method("SettingsPanel", "GetCategoryList"),
	{
		"SettingsPanel category list GetAllCategories",
		function()
			if not (type(SettingsPanel) == "table" and type(SettingsPanel.GetCategoryList) == "function") then
				return false
			end
			local ok, list = pcall(SettingsPanel.GetCategoryList, SettingsPanel)
			return ok and type(list) == "table" and type(list.GetAllCategories) == "function"
		end,
	},
	{
		"KeyBindingFrame_LoadUI (legacy)",
		function()
			return type(KeyBindingFrame_LoadUI) == "function" or type(KeyBindingFrame) == "table"
		end,
	},
	Global("ShowUIPanel"),
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
	"useItems",
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

--[[
	The class gates the options read off ns.ClassConfig, which resolves the class lists on first use: a
	form class offers Leave Form Before, a ranged attack named on this client offers its Start option.
]]
local function ClassGateLines(lines)
	local config = ns.ClassConfig()
	lines[#lines + 1] = string.format(
		"Class gates: pet class %s, melee class %s, form class %s, ranged attack for the after-cast option %s",
		YesNo(config.petAttack),
		YesNo(config.melee),
		YesNo(config.forms),
		tostring(config.autoShot or "none")
	)
end

--[[
	Right-Click For Group Version is offered on a spell only when this client names both halves of its
	GROUP_VERSIONS pair and the spellbook holds the group version, both read by name as the page reads them.
]]
local function GroupVersionLines(lines)
	local learned = {}
	pcall(ns.ForEachClassSpell, function(name)
		if name then
			learned[name] = true
		end
	end)
	local pairsTotal, named, offered = 0, 0, {}
	for singleId, groupId in pairs(ns.GROUP_VERSIONS or {}) do
		pairsTotal = pairsTotal + 1
		local single, group = C_Spell.GetSpellName(singleId), C_Spell.GetSpellName(groupId)
		if single and group then
			named = named + 1
			if learned[single] then
				offered[#offered + 1] =
					string.format("%s -> %s (group version learned %s)", single, group, YesNo(learned[group]))
			end
		end
	end
	table.sort(offered)
	lines[#lines + 1] = string.format("Group versions: %d of %d pairs named on this client", named, pairsTotal)
	for _, line in ipairs(offered) do
		lines[#lines + 1] = "  " .. line
	end
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
	local byKind = {}
	for _, kind in ipairs(ns.MACRO_KINDS) do
		local count = 0
		for _, macro in ipairs(ns.macros or {}) do
			if macro.kind == kind.key and not macro.focus then
				count = count + 1
			end
		end
		byKind[#byKind + 1] = kind.key .. "=" .. count
	end
	lines[#lines + 1] = "  by kind: " .. table.concat(byKind, ", ")
end

--[[
	The state most likely to explain a "the tab isn't there", "a spell is missing" or "an option isn't offered"
	report: who the player is and which data folder and spellbook this client gave them, whether the page's tab
	and page exist, how much of the class lists this client could name (an ID it can't name never matches, so
	that spell loses its options), the spells and class gates the options depend on, the group versions on
	offer, what the spellbook holds by skill line, every page setting and which class options apply, the
	unlearned-spells sources, the options panel route, and what the page last listed. Existence/value reads
	only.
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
	ClassGateLines(lines)
	GroupVersionLines(lines)
	SpellbookLines(lines)

	lines[#lines + 1] = ""
	local profile = ns.db and ns.db.profile
	if profile then
		lines[#lines + 1] = "Profile: " .. tostring(ns.db:GetCurrentProfile())
		lines[#lines + 1] = string.format(
			"Page settings: show unlearned %s (unlearned file loaded %s), count spells on bars %s, marked placed %d",
			OnOff(profile.showUnlearned),
			YesNo(ns.ForEachUnlearnedSpell ~= nil),
			OnOff(profile.countSpellsOnBars),
			CountKeys(profile.markedPlaced)
		)
		lines[#lines + 1] = string.format(
			"Class options: pet attack %s, stop casting %s (melee class %s)",
			YesNo(ns.ClassOffersPetAttack()),
			YesNo(not ns.IsMeleeClass()),
			YesNo(ns.IsMeleeClass())
		)
		local kindDefaults = {}
		for _, kind in ipairs(ns.MACRO_KINDS) do
			local on = {}
			for _, key in ipairs(ns.DEFAULTABLE_OPTIONS) do
				if ns.KindDefault(kind.key, key) then
					on[#on + 1] = key
				end
			end
			kindDefaults[#kindDefaults + 1] = kind.key .. "=" .. (#on > 0 and table.concat(on, "+") or "none")
		end
		lines[#lines + 1] = "Kind defaults: " .. table.concat(kindDefaults, ", ")
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
	lines[#lines + 1] = string.format(
		"Key binding: MACROSPELLBOOK_TOGGLE %s",
		tostring(GetBindingKey("MACROSPELLBOOK_TOGGLE") or "not bound")
	)

	lines[#lines + 1] = ""
	PageListLines(lines)
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Macro Context
--------------------------------------------------------------------------------

--[[
	How Features/Macro-Sync.lua's ownership check would answer for a page macro at index, read without its
	writes: "owned" (recorded as this character's), "claim" (a general macro recorded before owners were, which
	the first character to find it claims), "adopt" (unrecorded, but its body is the page's own, so it is
	adopted on the next sync), or "taken" (the player's own macro, which the page never touches).
]]
local function Ownership(macro, index, maxAccount)
	local general = index <= maxAccount
	local list = general and ns.db.global.ownedMacros or ns.db.char.ownedMacros
	local record = list[macro.macroName]
	local spellMacro = not macro.custom and not macro.equipment
	if record == true and general and not macro.equipment then
		return "claim"
	end
	if record ~= nil then
		local expected = (general and not macro.equipment) and ns.db.keys.char or true
		return record == expected and "owned" or "taken"
	end
	local body = select(3, GetMacroInfo(index))
	if body == macro.body or (spellMacro and body == ns.BareBody(macro.name)) then
		return "adopt"
	end
	return "taken"
end

local function CustomMacroLines(lines, profile)
	local maxBody = ns.MACRO_BODY_MAX_LENGTH
	local invalid, seen, duplicates = 0, {}, 0
	for _, entry in ipairs(profile.customMacros) do
		local name, body = entry.name, entry.body
		if type(name) ~= "string" or name == "" or type(body) ~= "string" or body == "" or #body > maxBody then
			invalid = invalid + 1
		elseif seen[ns.TrimMacroName(name)] then
			duplicates = duplicates + 1
		else
			seen[ns.TrimMacroName(name)] = true
		end
	end
	lines[#lines + 1] = string.format(
		"Custom macros: %d (defaults seeded %s); %d with no name, no body or over %d bytes, %d sharing a name",
		#profile.customMacros,
		YesNo(profile.customMacrosSeeded),
		invalid,
		maxBody,
		duplicates
	)
end

-- The sound settings the Mute Errors option turns off around its cast and puts back within a second.
local MUTE_ERRORS_CVARS = { "Sound_EnableSFX", "Sound_EnableErrorSpeech" }

local function MuteErrorsLine(lines)
	local values = {}
	for _, cvar in ipairs(MUTE_ERRORS_CVARS) do
		values[#values + 1] = string.format("%s %s", cvar, tostring(C_CVar.GetCVar(cvar)))
	end
	lines[#lines + 1] = string.format(
		"Mute Errors: %d macros use it; %s; MacroSpellbookMute global present %s",
		CountKeys(ns.db.profile.muteErrors),
		table.concat(values, ", "),
		YesNo(type(MacroSpellbookMute) == "function")
	)
end

--[[
	The state behind "clicking a macro does nothing", "my own macro was left alone" or "the macro didn't
	update": combat, free macro slots (character macros spill into general ones once full), which macros the
	add-on recorded as its own and for whom, each page macro as ns.FindMacroIndex finds it (another
	character's general macro holding the name sends this one to a character slot, or nowhere once those are
	full), page macros too long to write, out of step with their WoW macro or held by the player's own macro,
	what is on the action bars, the equipped items with a Use: effect, the custom macros, the Mute Errors sound
	settings, and the trainer recording. Existence/value reads only.
]]
function ns:BuildMacroContextReport()
	local lines = { ns.GetDiagnosticClientHeader(), "" }
	lines[#lines + 1] = "In combat: " .. YesNo(InCombatLockdown())
	local numAccount, maxAccount, numCharacter, maxCharacter = ns.MacroCounts()
	lines[#lines + 1] = string.format(
		"Macros: %d of %d general, %d of %d character (limits from %s)",
		numAccount or 0,
		maxAccount,
		numCharacter or 0,
		maxCharacter,
		(type(Constants) == "table" and type(Constants.MacroConsts) == "table") and "Constants.MacroConsts"
			or (MAX_ACCOUNT_MACROS and MAX_CHARACTER_MACROS) and "the MAX_*_MACROS globals"
			or "the fallback, Blizzard_MacroUI not loaded yet"
	)
	if not ns.db then
		lines[#lines + 1] = "(database not loaded)"
		return table.concat(lines, "\n")
	end
	local thisCharacter, otherCharacters, shared = 0, 0, 0
	for _, record in pairs(ns.db.global.ownedMacros) do
		if record == ns.db.keys.char then
			thisCharacter = thisCharacter + 1
		elseif type(record) == "string" then
			otherCharacters = otherCharacters + 1
		else
			shared = shared + 1
		end
	end
	lines[#lines + 1] = string.format(
		"Recorded as the add-on's: general %d this character's, %d other characters', %d shared (equipment, or from before owners were recorded); character %d",
		thisCharacter,
		otherCharacters,
		shared,
		CountKeys(ns.db.char.ownedMacros)
	)

	local counts = { owned = 0, claim = 0, adopt = 0, missing = 0, tooLong = 0, outOfStep = 0 }
	local taken, heldByOther = {}, {}
	for _, macro in ipairs(ns.macros or {}) do
		if #macro.body > ns.MACRO_BODY_MAX_LENGTH then
			counts.tooLong = counts.tooLong + 1
		end
		local index, takenByOther = ns.FindMacroIndex(macro)
		if takenByOther then
			heldByOther[#heldByOther + 1] = macro.macroName
		end
		if index == 0 then
			counts.missing = counts.missing + 1
		else
			local ownership = Ownership(macro, index, maxAccount)
			if ownership == "taken" then
				taken[#taken + 1] = macro.macroName
			else
				counts[ownership] = counts[ownership] + 1
				if select(3, GetMacroInfo(index)) ~= macro.body then
					counts.outOfStep = counts.outOfStep + 1
				end
			end
		end
	end
	lines[#lines + 1] = string.format(
		"Page macros (as of the page's last redraw): %d this character's, %d to claim, %d to adopt, %d not created yet; %d of those out of step with the page; %d over %d bytes, never written",
		counts.owned,
		counts.claim,
		counts.adopt,
		counts.missing,
		counts.outOfStep,
		counts.tooLong,
		ns.MACRO_BODY_MAX_LENGTH
	)
	lines[#lines + 1] = "Names held by the player's own macro (never touched): "
		.. (taken[1] and table.concat(taken, ", ") or "none")
	lines[#lines + 1] = "Names held by another character's general macro (made in a character slot instead): "
		.. (heldByOther[1] and table.concat(heldByOther, ", ") or "none")

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
	MuteErrorsLine(lines)
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
	strings it reads or matches, the slot names its Equipment section shows, every spell and creature family
	in the player's class lists, every GROUP_VERSIONS spell, and the ranged attack the after-cast option
	starts, each read as the features read it. The class-list spells are the player's class only, the class
	whose page this character sees. A spell loads late, so its row asks for it.
]]

-- Mirrors AUTO_SHOTS in Features/Macro-Builder.lua: Auto Shot, or the wand's Shoot, before MoP only.
local AUTO_SHOT_SPELL_IDS = { HUNTER = 75, MAGE = 5019, PRIEST = 5019, WARLOCK = 5019 }
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
	UiLabel("SETTINGS"),
	UiLabel("PAGE_NUMBER"),
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
	for singleId, groupId in pairs(ns.GROUP_VERSIONS or {}) do
		AddSpell("GROUP_VERSIONS", singleId)
		AddSpell("GROUP_VERSIONS", groupId)
	end
	local autoShotId = ns.EXPANSION < 5 and AUTO_SHOT_SPELL_IDS[PlayerClass()]
	if autoShotId then
		AddSpell("AUTO_SHOTS", autoShotId)
	end
end

--------------------------------------------------------------------------------
-- Validate Data Sources
--------------------------------------------------------------------------------

--[[
	One entry per data file, and one report row per entry on the Data tab. The class lists and trainer spells
	are keyed by class token, so their collectors walk every class and answer once per spell ID, keeping the
	class and where the ID sits as its DATA_* values; a class list entry with several rank IDs answers once
	per rank. The group versions answer once per half of each pair, naming the other half.
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

-- GROUP_VERSIONS is keyed by the single-target spell; each pair answers once per half.
local function CollectGroupVersionSpells(groupBySingle)
	local entries = {}
	for singleId, groupId in pairs(groupBySingle) do
		entries[#entries + 1] = { id = singleId, row = { half = "single", pair = groupId } }
		entries[#entries + 1] = { id = groupId, row = { half = "group", pair = singleId } }
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
	{
		label = "Group-Versions",
		sources = {
			{
				table = "GROUP_VERSIONS",
				kind = "spell",
				collect = CollectGroupVersionSpells,
				dataColumns = { { "DATA_HALF", RowField("half") }, { "DATA_PAIR", RowField("pair") } },
			},
		},
	},
}
