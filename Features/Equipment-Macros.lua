local _, ns = ...
local L = ns.L

-- The page's Equipment section: a macro for each equipped item with a "Use:" effect.

--[[
	Each inventory slot as { the GlobalStrings constant the page shows for it, the WoW macro name its
	equipment macro takes }. The macro names are identifiers players already have on their bars, so they stay
	as they are in every locale.
]]
local SLOTS = {
	[1] = { "HEADSLOT", "Head" },
	[2] = { "NECKSLOT", "Neck" },
	[3] = { "SHOULDERSLOT", "Shoulder" },
	[4] = { "SHIRTSLOT", "Shirt" },
	[5] = { "CHESTSLOT", "Chest" },
	[6] = { "WAISTSLOT", "Waist" },
	[7] = { "LEGSSLOT", "Legs" },
	[8] = { "FEETSLOT", "Feet" },
	[9] = { "WRISTSLOT", "Wrist" },
	[10] = { "HANDSSLOT", "Hands" },
	[11] = { "FINGER0SLOT_UNIQUE", "Ring 1" },
	[12] = { "FINGER1SLOT_UNIQUE", "Ring 2" },
	[13] = { "TRINKET0SLOT_UNIQUE", "Trinket 1" },
	[14] = { "TRINKET1SLOT_UNIQUE", "Trinket 2" },
	[15] = { "BACKSLOT", "Back" },
	[16] = { "MAINHANDSLOT", "Main Hand" },
	[17] = { "SECONDARYHANDSLOT", "Off Hand" },
	[18] = { "RANGEDSLOT", "Ranged" },
	[19] = { "TABARDSLOT", "Tabard" },
}

-- The client's name for an inventory slot.
local function SlotName(slot)
	return _G[SLOTS[slot][1]]
end

--[[
	Whether the item in an equipment slot has a "Use:" effect. The tooltip check catches effects added to the
	item, such as engineering tinkers, which GetItemSpell on the item itself may not see.
]]
local function HasUseEffect(slot, link)
	if C_Item.GetItemSpell(link) then
		return true
	end
	local prefix = ITEM_SPELL_TRIGGER_ONUSE
	for _, text in ipairs(ns.ScanTooltipLines("GetInventoryItem", "SetInventoryItem", "player", slot)) do
		if type(text) == "string" and text:sub(1, #prefix) == prefix then
			return true
		end
	end
	return false
end

--[[
	A macro that uses whatever is in an equipment slot, so it keeps working when the item is swapped. Its
	options (a combat check, stop casting, mouseover or self, and the error options) stay with the slot.
]]
local function MakeEquipmentMacro(slot, link, categoryRank)
	local label = SlotName(slot)
	local macro = {
		name = link:match("%[(.-)%]") or label,
		equipment = true,
		slot = slot,
		slotLabel = label,
		categoryRank = categoryRank,
		priority = slot,
		category = L["SECTION_EQUIPMENT"],
		cursor = false,
		macroName = ("Use " .. SLOTS[slot][2]):sub(1, ns.MACRO_NAME_MAX_LENGTH),
		macroIcon = ns.ICON_QUESTION_MARK,
		icon = GetInventoryItemTexture("player", slot) or ns.ICON_QUESTION_MARK,
	}
	macro.body = ns.MacroBody(macro) -- "#showtooltip\n/use 13" with no options on
	return macro
end

--[[
	The equipped items with a "Use:" effect, in slot order, as {slot = 13, link = ...}. Cached until the gear
	worn changes (ns:InvalidateUsableSlots, on PLAYER_EQUIPMENT_CHANGED), and each item's answer is kept by its
	link, so the page and its menus don't rescan nineteen tooltips on every redraw. Don't modify it.
]]
local usableSlots
local useEffectByLink = {}

function ns.UsableSlots()
	if usableSlots then
		return usableSlots
	end
	usableSlots = {}
	for slot = 1, #SLOTS do
		local link = GetInventoryItemLink("player", slot)
		if link then
			if useEffectByLink[link] == nil then
				useEffectByLink[link] = HasUseEffect(slot, link)
			end
			if useEffectByLink[link] then
				usableSlots[#usableSlots + 1] = { slot = slot, link = link }
			end
		end
	end
	return usableSlots
end

function ns:InvalidateUsableSlots()
	usableSlots = nil
end

-- The name a slot shows in menus: its label, plus the equipped item's name when there is one.
function ns.SlotLabel(slot)
	local link = GetInventoryItemLink("player", slot)
	local item = link and link:match("%[(.-)%]")
	return SlotName(slot) .. (item and ": " .. item or "")
end

--[[
	Appends a macro for each equipped item with a "Use:" effect to ns.macros. taken holds the macro names
	already in use. The section follows the custom macros.
]]
function ns.AddEquipmentMacros(taken)
	local categoryRank = ns.TAB_SECTION_BASE + #ns.CustomMacroList() + 1
	for _, usable in ipairs(ns.UsableSlots()) do
		local macro = MakeEquipmentMacro(usable.slot, usable.link, categoryRank)
		if not taken[macro.macroName] then
			taken[macro.macroName] = true
			ns.macros[#ns.macros + 1] = macro
		end
	end
end
