local _, ns = ...

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

local COLORS = {}
for key, hex in pairs(ns.PALETTE) do
	COLORS[key] = "|cff" .. hex
end

function ns.GetColor(key)
	return COLORS[key] or COLORS.TEXT
end

--------------------------------------------------------------------------------
-- Class Spells
--------------------------------------------------------------------------------

--[[
	Calls fn(name, icon, spellId, skillLineName, skillLineIndex, subName) for every learned, castable spell
	in skill line order, General (Attack, Shoot, Throw, racials) included; subName is the book's text under the name, such as
	"Rank 3", or nil. The Retail engine (Forever, Retail) reads the book through
	C_SpellBook; the Classic engine (Classic Era, TBC, MoP Classic) through the spell tab globals. Resolved once
	at load.
]]
if C_SpellBook.GetNumSpellBookSkillLines then
	function ns.ForEachClassSpell(fn)
		local bank = Enum.SpellBookSpellBank.Player
		for line = 1, C_SpellBook.GetNumSpellBookSkillLines() do
			local info = C_SpellBook.GetSpellBookSkillLineInfo(line)
			if info and not info.shouldHide and not info.offSpecID then
				for slot = info.itemIndexOffset + 1, info.itemIndexOffset + info.numSpellBookItems do
					local item = C_SpellBook.GetSpellBookItemInfo(slot, bank)
					if
						item
						and item.itemType == Enum.SpellBookItemType.Spell
						and not item.isPassive
						and not item.isOffSpec
					then
						fn(item.name, item.iconID, item.spellID or item.actionID, info.name, line, item.subName)
					end
				end
			end
		end
	end
else
	function ns.ForEachClassSpell(fn)
		for line = 1, GetNumSpellTabs() do
			local lineName, _, offset, numSlots = GetSpellTabInfo(line)
			for slot = offset + 1, offset + numSlots do
				local itemType, id = GetSpellBookItemInfo(slot, BOOKTYPE_SPELL)
				if itemType == "SPELL" and not IsPassiveSpell(slot, BOOKTYPE_SPELL) then
					local name, subName = GetSpellBookItemName(slot, BOOKTYPE_SPELL)
					fn(name, GetSpellBookItemTexture(slot, BOOKTYPE_SPELL), id, lineName, line, subName)
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Tooltip Lines
--------------------------------------------------------------------------------

--[[
	The text of a tooltip's lines, left and right. getter is the C_TooltipInfo function and setter the
	GameTooltip method that fill the same tooltip (e.g. "GetSpellByID" and "SetSpellByID"), both called with
	the rest. Forever and Retail ship the C_TooltipInfo getters; the Classic engine reads a hidden tooltip.
]]
local SCAN_TOOLTIP_NAME = "MacroSpellbookScanTooltip"
local TOOLTIP_SIDES = { "Left", "Right" }
local scanTooltip

function ns.ScanTooltipLines(getter, setter, ...)
	local lines = {}
	if C_TooltipInfo and C_TooltipInfo[getter] then
		local data = C_TooltipInfo[getter](...)
		for _, line in ipairs(data and data.lines or {}) do
			lines[#lines + 1] = line.leftText
			lines[#lines + 1] = line.rightText
		end
		return lines
	end
	scanTooltip = scanTooltip or CreateFrame("GameTooltip", SCAN_TOOLTIP_NAME, nil, "GameTooltipTemplate")
	scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	scanTooltip[setter](scanTooltip, ...)
	for i = 1, scanTooltip:NumLines() do
		for _, side in ipairs(TOOLTIP_SIDES) do
			local text = _G[SCAN_TOOLTIP_NAME .. "Text" .. side .. i]
			lines[#lines + 1] = text and text:GetText()
		end
	end
	scanTooltip:Hide()
	return lines
end

--------------------------------------------------------------------------------
-- Trainer Services
--------------------------------------------------------------------------------

--[[
	The spell ID of a trainer window's service. Forever and Retail hand it over through
	C_TooltipInfo.GetTrainerService; the Classic engine shows the service on the hidden scan tooltip and reads
	the spell back with GetSpell. Resolved once at load.
]]
if C_TooltipInfo and C_TooltipInfo.GetTrainerService then
	function ns.GetTrainerServiceSpellId(index)
		local data = C_TooltipInfo.GetTrainerService(index)
		return data and data.id
	end
else
	function ns.GetTrainerServiceSpellId(index)
		scanTooltip = scanTooltip or CreateFrame("GameTooltip", SCAN_TOOLTIP_NAME, nil, "GameTooltipTemplate")
		scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
		scanTooltip:SetTrainerService(index)
		local _, spellId = scanTooltip:GetSpell()
		scanTooltip:Hide()
		return spellId
	end
end
