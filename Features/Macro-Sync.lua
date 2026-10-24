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
	The WoW macros the add-on created, by name. Character ones are listed in ns.db.char. General ones are
	listed in ns.db.global: an equipment macro as true, since its body names only a slot and every character
	shares it, and any other as the key of the character that created it, the only character that rewrites
	it. The page edits only these, so a player's own macro that happens to share a spell's name is never
	touched. Macro indexes run general first, then character, so the index says which list a macro belongs to.
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

local function IsOwned(macro, index)
	local list = OwnedList(index)
	local record = list[macro.macroName]
	if record == true and IsGeneral(index) and not macro.equipment then
		--[[
			MIGRATION (remove after 2026-11-23)
			Releases before owners were recorded marked every general macro true; the first character to find a
			spell or custom one claims it.
		]]
		list[macro.macroName] = ns.db.keys.char
		return true
	end
	if record ~= nil then
		return record == OwnerRecord(macro, index)
	end
	--[[
		MIGRATION (remove after 2026-11-23)
		Releases before ownership tracking left their macros unrecorded; adopt one whose body is the page's own.
	]]
	local body = select(3, GetMacroInfo(index))
	if body == macro.body or (not macro.custom and not macro.equipment and body == ns.BareBody(macro.name)) then
		list[macro.macroName] = OwnerRecord(macro, index)
		return true
	end
	return false
end

-- This character's macros, as name -> index.
local function CharacterMacroIndexes()
	local indexes = {}
	local first = MaxAccountMacros()
	local _, numCharacter = GetNumMacros()
	for index = first + 1, first + numCharacter do
		local name = GetMacroInfo(index)
		if name and not indexes[name] then
			indexes[name] = index
		end
	end
	return indexes
end

ns.CharacterMacroIndexes = CharacterMacroIndexes

--[[
	The WoW macro a page macro is this character's: its character macro of that name, else the general one of
	that name unless another character created it. Returns the index (0 for none) and whether another
	character's general macro holds the name. characterIndexes is a CharacterMacroIndexes result, read here
	when nil.
]]
function ns.FindMacroIndex(macro, characterIndexes)
	local index = (characterIndexes or CharacterMacroIndexes())[macro.macroName]
	if index then
		return index, false
	end
	index = GetMacroIndexByName(macro.macroName)
	if index == 0 or not IsGeneral(index) then
		return 0, false
	end
	local record = ns.db.global.ownedMacros[macro.macroName]
	if type(record) == "string" and record ~= ns.db.keys.char then
		return 0, true
	end
	return index, false
end

--[[
	Whether the macro's body fits the game's limit, measured in bytes, which a translated name reaches sooner.
	A longer body would be cut off, so it is never written, and the player is told once.
]]
local function Fits(macro)
	if #macro.body <= ns.MACRO_BODY_MAX_LENGTH then
		return true
	end
	ns.WarnOnce(L["CHAT_MACRO_TOO_LONG"]:format(macro.name, #macro.body, ns.MACRO_BODY_MAX_LENGTH))
	return false
end

--[[
	Why the page can't place a macro, or nil when it can: "long", with the body's length in bytes, when the
	body is over what a macro holds, or "taken" when a macro of its name is the player's own, or another
	character's general one while no character slot is free. ns.PickupMacro asks the same questions through
	it, so the page's warnings and a click never disagree. characterIndexes is a CharacterMacroIndexes result,
	read here when nil.
]]
function ns.MacroBlockReason(macro, characterIndexes)
	if #macro.body > ns.MACRO_BODY_MAX_LENGTH then
		return "long", #macro.body
	end
	local index, takenByOther = ns.FindMacroIndex(macro, characterIndexes)
	if index ~= 0 then
		return not IsOwned(macro, index) and "taken" or nil
	end
	if takenByOther and (macro.equipment or select(2, GetNumMacros()) >= MaxCharacterMacros()) then
		return "taken"
	end
	return nil
end

-- Rewrites the WoW macro at index if the add-on made it and its body differs from the page's and fits.
local function SyncAt(macro, index)
	if index ~= 0 and IsOwned(macro, index) and select(3, GetMacroInfo(index)) ~= macro.body and Fits(macro) then
		EditMacro(index, nil, nil, macro.body)
	end
end

-- Rewrites this character's WoW macro for a page macro if the add-on made it and its body has changed.
function ns.SyncMacro(macro, characterIndexes)
	SyncAt(macro, (ns.FindMacroIndex(macro, characterIndexes)))
end

--[[
	Creates the macro on first use (character specific, or general once those slots are full), then puts
	it on the cursor so it can be dropped on an action bar. Equipment macros are always general: their body
	names only the slot, so every character shares them. A macro of the same name the add-on didn't make is
	left alone, and so is another character's general one: this character makes its own in a character slot,
	since a second general macro of the same name couldn't be told apart from it.
]]
function ns.PickupMacro(macro)
	if InCombatLockdown() then
		UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, 1, 0.1, 0.1)
		return
	end
	local reason = ns.MacroBlockReason(macro)
	if reason == "long" then
		Fits(macro) -- tells the player, once
		return
	end
	if reason == "taken" then
		ns:PrintMessage(L["CHAT_MACRO_NAME_TAKEN"]:format(macro.macroName))
		return
	end
	local index = ns.FindMacroIndex(macro)
	if index == 0 then
		local numAccount, numCharacter = GetNumMacros()
		local perCharacter = not macro.equipment and numCharacter < MaxCharacterMacros()
		if not perCharacter and numAccount >= MaxAccountMacros() then
			local message = macro.equipment and L["ERROR_NO_FREE_GENERAL_MACRO_SLOTS"] or L["ERROR_NO_FREE_MACRO_SLOTS"]
			UIErrorsFrame:AddMessage(L["ADDON_SHORT_NAME"] .. " // " .. message, 1, 0.1, 0.1)
			return
		end
		index = CreateMacro(macro.macroName, macro.macroIcon, macro.body, perCharacter)
		if not index or index == 0 then
			return
		end
		OwnedList(index)[macro.macroName] = OwnerRecord(macro, index)
	else
		SyncAt(macro, index)
	end
	PickupMacro(index)
end

-- Rewrites the existing WoW macros whose body no longer matches the page (a setting or config changed).
function ns.SyncAllMacros()
	if InCombatLockdown() then
		return
	end
	local characterIndexes = CharacterMacroIndexes()
	for _, macro in ipairs(ns.macros) do
		ns.SyncMacro(macro, characterIndexes)
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
	if macro.custom or macro.equipment or macro.focus or not bars.spells[macro.name] then
		return false
	end
	return ns.CountsSpellsOnBars() or macro.body == ns.BareBody(macro.name)
end
