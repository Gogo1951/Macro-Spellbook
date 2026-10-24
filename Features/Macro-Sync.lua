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
	The WoW macros the add-on created, by name: general ones in ns.db.global, character ones in ns.db.char.
	The page edits only these, so a player's own macro that happens to share a spell's name is never touched.
	Macro indexes run general first, then character, so the index says which list a macro belongs to.
]]
local function OwnedList(index)
	return index > MaxAccountMacros() and ns.db.char.ownedMacros or ns.db.global.ownedMacros
end

local function IsOwned(macro, index)
	if OwnedList(index)[macro.macroName] then
		return true
	end
	--[[
		MIGRATION (remove after 2026-11-23)
		Releases before ownership tracking left their macros unrecorded; adopt one whose body is the page's own.
	]]
	local body = select(3, GetMacroInfo(index))
	if body == macro.body or (not macro.custom and not macro.equipment and body == ns.BareBody(macro.name)) then
		OwnedList(index)[macro.macroName] = true
		return true
	end
	return false
end

--[[
	Rewrites the WoW macro at index if the add-on made it and its body differs from the page's. Index 0 means
	it does not exist.
]]
function ns.SyncMacro(macro, index)
	if index ~= 0 and IsOwned(macro, index) and select(3, GetMacroInfo(index)) ~= macro.body then
		EditMacro(index, nil, nil, macro.body)
	end
end

--[[
	Creates the macro on first use (character specific, or general once those slots are full), then puts
	it on the cursor so it can be dropped on an action bar. Equipment macros are always general: their body
	names only the slot, so every character shares them. A macro of the same name the add-on didn't make is
	left alone.
]]
function ns.PickupMacro(macro)
	if InCombatLockdown() then
		UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, 1, 0.1, 0.1)
		return
	end
	local index = GetMacroIndexByName(macro.macroName)
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
		OwnedList(index)[macro.macroName] = true
	elseif not IsOwned(macro, index) then
		ns:PrintMessage(L["CHAT_MACRO_NAME_TAKEN"]:format(macro.macroName))
		return
	else
		ns.SyncMacro(macro, index)
	end
	PickupMacro(index)
end

-- Rewrites the existing WoW macros whose body no longer matches the page (a setting or config changed).
function ns.SyncAllMacros()
	if InCombatLockdown() then
		return
	end
	for _, macro in ipairs(ns.macros) do
		ns.SyncMacro(macro, GetMacroIndexByName(macro.macroName))
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
