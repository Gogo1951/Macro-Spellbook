local _, ns = ...
local L = ns.L

-- Keeps the WoW macros the page creates in step with it, and reads the action bars for the page's glows.

--[[
	The macro slot limits. The Retail engine has them in Constants.MacroConsts; the Classic engine's
	UIParent sets the MAX_ACCOUNT_MACROS and MAX_CHARACTER_MACROS globals. Every flavor is 120 general
	and 30 character today, the fallback if neither is there.
]]
local MACRO_CONSTS = Constants and Constants.MacroConsts or {}

local function MaxCharacterMacros()
	return MACRO_CONSTS.MAX_CHARACTER_MACROS or MAX_CHARACTER_MACROS or 30
end

local function MaxAccountMacros()
	return MACRO_CONSTS.MAX_ACCOUNT_MACROS or MAX_ACCOUNT_MACROS or 120
end

-- The macros in use and the slots there are: general used, general max, character used, character max.
function ns.MacroCounts()
	local numAccount, numCharacter = GetNumMacros()
	return numAccount, MaxAccountMacros(), numCharacter, MaxCharacterMacros()
end

--[[
	The WoW macros the add-on writes carry a tag line (ns.MacroTag), which is how the page finds them. Macros
	from before the tags are found by name instead, and only those the add-on created, by name: character
	ones listed in ns.db.char, general ones in ns.db.global, an equipment macro as true, since its body names
	only a slot and every character shares it, and any other as the key of the character that created it, the
	only character that rewrites it. The next sync tags each one it finds, so a player's own macro that
	happens to share a spell's name is never touched. Macro indexes run general first, then character, so the
	index says which list a macro belongs to. New macros are still recorded, so one whose tag line the player
	deletes is found by name again.
]]
local function IsGeneral(index)
	return index <= MaxAccountMacros()
end

local function OwnedList(index)
	return IsGeneral(index) and ns.db.global.ownedMacros or ns.db.char.ownedMacros
end

-- The record a macro the add-on creates at index takes in its OwnedList.
local function OwnerRecord(macro, index)
	if IsGeneral(index) and not macro.equipment then
		return ns.db.keys.char
	end
	return true
end

--[[
	How a page macro stands to the untagged WoW macro of its name at index: "owned" (recorded as the add-on's,
	for this character), "claim" (MIGRATION, remove after 2026-11-23: a general macro recorded true before
	owners were, which the first character to find it claims), "adopt" (MIGRATION, remove after 2026-11-23:
	unrecorded, from before ownership tracking, but its text is the page's own), or nil (the player's own, or
	another character's). Reads only; ns.SyncMacro records a claim or adoption.
]]
function ns.LegacyOwnership(macro, index)
	local record = OwnedList(index)[macro.macroName]
	if record == true and IsGeneral(index) and not macro.equipment then
		return "claim"
	end
	if record ~= nil then
		return record == OwnerRecord(macro, index) and "owned" or nil
	end
	local body = select(3, GetMacroInfo(index))
	if
		body
		and (
			ns.TaggedBody(macro, body) == macro.body
			or (not macro.custom and not macro.equipment and body == ns.BareBody(macro.name))
		)
	then
		return "adopt"
	end
	return nil
end

local NO_INDEXES = {}

--[[
	Where the WoW macros are, read in one pass over them: tags maps each tag to the first macro carrying it,
	and names each name to the untagged macros of that name, character ones first, as the page's lookups by
	name have always preferred them.
]]
local function ReadMacroIndexes()
	local indexes = { tags = {}, names = {} }
	local numAccount, numCharacter = GetNumMacros()
	local function read(index)
		local name, _, body = GetMacroInfo(index)
		local tag = ns.BodyTag(body)
		if tag then
			indexes.tags[tag] = indexes.tags[tag] or index
		elseif name then
			indexes.names[name] = indexes.names[name] or {}
			table.insert(indexes.names[name], index)
		end
	end
	local first = MaxAccountMacros()
	for index = first + 1, first + numCharacter do
		read(index)
	end
	for index = 1, numAccount do
		read(index)
	end
	return indexes
end

ns.ReadMacroIndexes = ReadMacroIndexes

--[[
	The WoW macro that is a page macro's: the one carrying its tag, else an untagged one of its name the
	add-on created (see ns.LegacyOwnership). Returns the index, 0 for none, and how it was found: "tag", or
	the ownership answer. Reads only. indexes is a ReadMacroIndexes result, read here when nil.
]]
function ns.FindMacroIndex(macro, indexes)
	indexes = indexes or ReadMacroIndexes()
	local index = indexes.tags[ns.MacroTag(macro)]
	if index then
		return index, "tag"
	end
	for _, named in ipairs(indexes.names[macro.macroName] or NO_INDEXES) do
		local ownership = ns.LegacyOwnership(macro, named)
		if ownership then
			return named, ownership
		end
	end
	return 0, nil
end

--[[
	Whether the macro's body fits the game's limit, measured in bytes, which a translated name reaches sooner.
	A longer body would be cut off, so it is never written, and the player is told once.
]]
local function Fits(macro)
	if #macro.body <= ns.MACRO_BODY_MAX_LENGTH then
		return true
	end
	ns.WarnOnce(L["CHAT_MACRO_TOO_LONG"]:format(macro.label or macro.name, #macro.body, ns.MACRO_BODY_MAX_LENGTH))
	return false
end

--[[
	Why the page can't place a macro, or nil when it can: "long", with the body's length in bytes, when the
	body is over what a macro holds. ns.PickupMacro asks the same, so the page's warnings and a click never
	disagree. A macro of the same name never blocks one: the page's macros are told apart by their tags.
]]
function ns.MacroBlockReason(macro)
	if #macro.body > ns.MACRO_BODY_MAX_LENGTH then
		return "long", #macro.body
	end
	return nil
end

-- Rewrites the WoW macro at index if its body differs from the page's and fits.
local function SyncAt(macro, index)
	if index ~= 0 and select(3, GetMacroInfo(index)) ~= macro.body and Fits(macro) then
		EditMacro(index, nil, nil, macro.body)
	end
end

--[[
	Rewrites this character's WoW macro for a page macro if its body has changed. One found by name gets its
	tag line here, and is recorded as the add-on's; indexes, when given, then lists it under its tag, so a
	second page macro of the same name in the same pass doesn't take it too.
]]
function ns.SyncMacro(macro, indexes)
	local index, found = ns.FindMacroIndex(macro, indexes)
	if index ~= 0 and found ~= "tag" then
		OwnedList(index)[macro.macroName] = OwnerRecord(macro, index)
		ns.AssignMacroTag(macro)
		if indexes then
			indexes.tags[ns.MacroTag(macro)] = index
			local named = indexes.names[macro.macroName]
			for i = #named, 1, -1 do
				if named[i] == index then
					table.remove(named, i)
				end
			end
		end
	end
	SyncAt(macro, index)
end

--[[
	Creates the macro on first use (character specific, or general once those slots are full), then puts
	it on the cursor so it can be dropped on an action bar. Equipment macros are always general: their body
	names only the slot, so every character shares them. A macro of the same name the add-on didn't make is
	left alone, and the new one sits beside it under the same name.
]]
function ns.PickupMacro(macro)
	if InCombatLockdown() then
		UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, 1, 0.1, 0.1)
		return
	end
	if ns.MacroBlockReason(macro) then
		Fits(macro) -- tells the player, once
		return
	end
	local index = ns.FindMacroIndex(macro)
	if index == 0 then
		local numAccount, numCharacter = GetNumMacros()
		local perCharacter = not macro.equipment and numCharacter < MaxCharacterMacros()
		if not perCharacter and numAccount >= MaxAccountMacros() then
			local message = macro.equipment and L["ERROR_GENERAL_MACRO_SLOTS_FULL"] or L["ERROR_MACRO_SLOTS_FULL"]
			UIErrorsFrame:AddMessage(L["ADDON_SHORT_NAME"] .. " // " .. message, 1, 0.1, 0.1)
			return
		end
		ns.AssignMacroTag(macro)
		index = CreateMacro(macro.macroName, macro.macroIcon, macro.body, perCharacter)
		if not index or index == 0 then
			return
		end
		OwnedList(index)[macro.macroName] = OwnerRecord(macro, index)
	else
		ns.SyncMacro(macro)
	end
	PickupMacro(index)
end

-- Macros can't be edited in combat, so a rewrite asked for then waits for combat to end.
local syncPending = false

function ns.QueueMacroSync()
	syncPending = true
end

function ns:OnPlayerRegenEnabled()
	if syncPending then
		syncPending = false
		ns:RefreshMacros()
	end
end

-- Rewrites the existing WoW macros whose body no longer matches the page (a setting or config changed).
function ns.SyncAllMacros()
	if InCombatLockdown() then
		ns.QueueMacroSync()
		return
	end
	local indexes = ReadMacroIndexes()
	for _, macro in ipairs(ns.macros) do
		ns.SyncMacro(macro, indexes)
	end
end

local MAX_ACTION_SLOTS = 180 -- Classic has 120; empty or missing slots return nil

--[[
	What is on the action bars: {macros = {[macro name] = true}, spells = {[spell name] = true}}. For a
	macro that shows a spell, GetActionInfo gives the spell's id (subtype "spell") rather than the macro's
	index, so macros are matched by the name GetActionText gives.
]]
function ns.ScanActionBars()
	local bars = { macros = {}, spells = {} }
	for slot = 1, MAX_ACTION_SLOTS do
		local actionType, id, subType = GetActionInfo(slot)
		if actionType == "macro" then
			local name = GetActionText(slot) or (subType ~= "spell" and GetMacroInfo(id))
			if name then
				bars.macros[name] = true
			end
		elseif actionType == "spell" and id then
			-- by name, not ID: the bar can hold any rank of a spell, and every rank has its own ID
			local name = C_Spell.GetSpellName(id)
			if name then
				bars.spells[name] = true
			end
		end
	end
	return bars
end

--[[
	Whether a page macro is on the action bars, scanned by ns.ScanActionBars. A spell macro with no
	options on also counts when its plain spell is on a bar, and with ns.CountsSpellsOnBars() any spell
	macro does.
]]
function ns.IsOnActionBars(macro, bars)
	if bars.macros[macro.macroName] then
		return true
	end
	if macro.custom or macro.equipment or macro.focus or macro.copy or not bars.spells[macro.name] then
		return false
	end
	return ns.CountsSpellsOnBars() or macro.body == ns.TaggedBody(macro, ns.BareBody(macro.name))
end
