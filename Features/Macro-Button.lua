local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor
local HideTooltip = ns.HideTooltip

--[[
	One macro's button on the spellbook page: its icon, name and note, the glow while it isn't on the bars,
	its tooltip, and the click, drag and right-click that place it or open its menu (Features/Macro-Menu.lua).
	Features/Spellbook-Page.lua lays the buttons out.
]]

local ICON_SIZE = 36

local INK_COLOR = ns.INK_COLOR
local FADED_INK_COLOR = ns.FADED_INK_COLOR

--[[
	The native spell item's atlases and layout (Camelot's SpellBookItemTemplate, read in game). The item is
	its cell's width less 8, 217 on that book, with a 40x40 icon button at its left; our button is the item,
	so the native button's anchors become offsets from the 36x36 icon, which sits 2 inside it. Each falls
	back to an old file texture, sized from the icon, if this build lacks the atlas.
]]
local ATLAS_FRAME = "spellbook-item-iconframe"
local ATLAS_FRAME_INACTIVE = "spellbook-item-iconframe-inactive"
local ATLAS_FRAME_HOVER = "spellbook-item-iconframe-hover"
local ATLAS_GLOW = "spellbook-item-unassigned-glow"
local ATLAS_MASK = "spellbook-item-spellicon-mask"

local function HasAtlas(atlas)
	return C_Texture.GetAtlasInfo(atlas) ~= nil
end

-- Stretches texture over the icon, grown by the given insets (left, top, right, bottom).
local function SetAroundIcon(texture, icon, left, top, right, bottom)
	texture:ClearAllPoints()
	texture:SetPoint("TOPLEFT", icon, "TOPLEFT", -left, top)
	texture:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", right, -bottom)
end

-- Returns true when the atlas was used.
local function SetAtlasOr(texture, atlas, file, scale, icon)
	if HasAtlas(atlas) then
		texture:SetAtlas(atlas, false)
		return true
	end
	if file then
		texture:SetTexture(file)
		texture:SetSize(ICON_SIZE * scale, ICON_SIZE * scale)
		texture:SetPoint("CENTER", icon)
	end
	return false
end

--[[
	The spell whose own tooltip heads the macro's: a learned spell by name, so its highest known rank, an
	unlearned one by its ID, or a custom macro's "#showtooltip <spell>" spell. Nil when there's none.
]]
local function TooltipSpellID(macro)
	if macro.equipment then
		return nil
	end
	if macro.unlearned then
		return macro.spellID
	end
	local name = macro.name
	if macro.custom then
		name = macro.body:match("^#showtooltip[ \t]+([^\n]*%S)")
	end
	local info = name and C_Spell.GetSpellInfo(name)
	return info and info.spellID or macro.spellID
end

-- Whether any of the game's menus is open, a macro's options menu included.
local function MenuOpen()
	return Menu ~= nil and Menu.GetManager ~= nil and Menu.GetManager():IsAnyMenuOpen()
end

-- A keybind and what it does, both in the interaction blue, as a pair across the tooltip.
local function AddHint(keybind, action)
	GameTooltip:AddDoubleLine(GetColor("INFO") .. keybind .. "|r", GetColor("INFO") .. action .. "|r")
end

--[[
	The options a macro's note and tooltip can name, most telling first, as { key, note key, menu label key }:
	the note names the one that is on, or counts them when more than one is; the tooltip lists them all by
	their right-click menu labels. A row without keys builds its text from the macro.
]]
local OPTION_SUBTEXTS = {
	{ "pet", "SUBTEXT_PET", "MENU_CAST_IF_SUMMONED" },
	{ "cursor", "SUBTEXT_CURSOR", "MENU_CAST_AT_CURSOR" },
	{ "mouseover", "SUBTEXT_MOUSEOVER", "MENU_CAST_ON_MOUSEOVER" },
	{ "castOnSelf", "SUBTEXT_CAST_ON_SELF", "MENU_CAST_ON_SELF" },
	{ "targetTarget", "SUBTEXT_TARGETS_TARGET", "MENU_CAST_ON_TARGETS_TARGET" },
	{ "stance", "SUBTEXT_STANCE", "MENU_SWITCH_TO" },
	{ "useItems", "SUBTEXT_USE_ITEMS" },
	{ "petAttack", "SUBTEXT_PET_ATTACK", "MENU_START_PET_ATTACK" },
	{ "targetRank", "SUBTEXT_DYNAMIC_RANK", "MENU_DYNAMIC_RANK" },
	{ "fixedRank" },
	{ "targetEnemy", "SUBTEXT_TARGET_ENEMY", "MENU_TARGET_NEAREST_ENEMY" },
	{ "targetFriend", "SUBTEXT_TARGET_FRIEND", "MENU_TARGET_NEAREST_FRIEND" },
	{ "groupVersion", "SUBTEXT_GROUP_VERSION", "MENU_RIGHT_CLICK_FOR" },
	{ "oncePerCombat", "SUBTEXT_ONCE_PER_COMBAT", "MENU_ONCE_PER_COMBAT" },
	{ "oncePerTarget", "SUBTEXT_ONCE_PER_TARGET", "MENU_ONCE_PER_TARGET" },
	{ "combatOnly", "SUBTEXT_COMBAT_ONLY", "MENU_ONLY_IN_COMBAT" },
	{ "noCombat", "SUBTEXT_NO_COMBAT", "MENU_NEVER_IN_COMBAT" },
	{ "cancelForm", "SUBTEXT_LEAVE_FORM", "MENU_LEAVE_FORM_BEFORE" },
	{ "noToggle", "SUBTEXT_NO_TOGGLE", "MENU_NEVER_TURN_OFF" },
	{ "autoShot" },
	{ "startAttack", "SUBTEXT_START_ATTACK", "MENU_START_AUTO_ATTACK" },
	{ "stopAttack", "SUBTEXT_STOP_ATTACK", "MENU_STOP_ATTACK" },
	{ "stopCast", "SUBTEXT_STOP_CASTING", "MENU_STOP_CASTING" },
	{ "stopIfChanneling", "SUBTEXT_STOP_IF_CHANNELING", "MENU_STOP_IF_CHANNELING" },
	{ "stopIfStealthed", "SUBTEXT_STOP_IF_STEALTHED", "MENU_STOP_IF_STEALTHED" },
	{ "hideErrors", "SUBTEXT_HIDE_ERRORS", "MENU_HIDE_ERRORS" },
	{ "muteErrors", "SUBTEXT_MUTE_ERRORS", "MENU_MUTE_ERRORS" },
}

-- Calls fn(entry) for each OPTION_SUBTEXTS row whose option is on for the macro, in order.
local function ForEachOnOption(macro, fn)
	for _, entry in ipairs(OPTION_SUBTEXTS) do
		local key = entry[1]
		local on
		if key == "useItems" then
			on = ns.UseItemSlots(macro)[1] ~= nil
		elseif key == "fixedRank" then
			on = ns.FixedRank(macro) ~= nil
		else
			on = ns.IsOptionOn(macro, key)
		end
		if on then
			fn(entry)
		end
	end
end

-- The autoShot note: Auto Shot's own name from the client, or "Wand" rather than the wand's "Shoot".
local function AutoShotSubText()
	if ns.AutoShotLabelKey() == "MENU_START_WAND" then
		return L["SUBTEXT_WAND"]
	end
	return ns.AutoShotName()
end

--[[
	A spell or equipment macro's note: the name of its one option that is on, "N Options" when several are, or
	nil when none is.
]]
local function OptionSubText(macro)
	local count, first = 0, nil
	ForEachOnOption(macro, function(entry)
		count = count + 1
		if not first then
			-- a fixed rank's note is the rank's own text ("Rank 3")
			if entry[1] == "fixedRank" then
				first = ns.FixedRank(macro)
			elseif entry[1] == "autoShot" then
				first = AutoShotSubText()
			else
				first = L[entry[2]]
			end
		end
	end)
	if count > 1 then
		return L["SUBTEXT_OPTIONS_COUNT"]:format(count)
	end
	return first
end

-- An option's label as its right-click menu shows it.
local function OptionLabel(macro, entry)
	local key = entry[1]
	if key == "useItems" then
		local slots = {}
		for i, slot in ipairs(ns.UseItemSlots(macro)) do
			slots[i] = ns.SlotLabel(slot)
		end
		return table.concat(slots, ", ")
	elseif key == "fixedRank" then
		return ns.FixedRank(macro)
	elseif key == "autoShot" then
		return L[ns.AutoShotLabelKey() or "MENU_START_AUTO_SHOT"]
	elseif key == "pet" then
		return L[entry[3]]:format(macro.petAbility)
	elseif key == "stance" then
		return L[entry[3]]:format(macro.stances[1])
	elseif key == "groupVersion" then
		return L[entry[3]]:format(macro.groupSpell)
	end
	return L[entry[3]]
end

-- "Options On: Cast On Mouseover, Stop Casting", every option that is on by its menu label, or nil for none.
local function OptionsOnLine(macro)
	local labels = {}
	ForEachOnOption(macro, function(entry)
		labels[#labels + 1] = OptionLabel(macro, entry)
	end)
	if #labels == 0 then
		return nil
	end
	return GetColor("TITLE")
		.. L["TOOLTIP_OPTIONS_ON"]:format(GetColor("TEXT") .. table.concat(labels, ", ") .. "|r")
		.. "|r"
end

-- Cells are reused across refreshes; SetMacro points one at a macro.
local function CreateMacroButton(parent)
	local geometry = parent.geometry
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(geometry.viewWidth / geometry.columns - 8, ICON_SIZE + 4)
	button.icon = button:CreateTexture(nil, "ARTWORK", nil, -1)
	button.icon:SetSize(ICON_SIZE, ICON_SIZE)
	button.icon:SetPoint("LEFT", 2, 0)
	if HasAtlas(ATLAS_MASK) then
		local mask = button:CreateMaskTexture()
		mask:SetAtlas(ATLAS_MASK, false)
		mask:SetAllPoints(button.icon)
		button.icon:AddMaskTexture(mask)
	end
	-- the frame's curl hangs off the icon's bottom left
	button.border = button:CreateTexture(nil, "OVERLAY", nil, 1)
	if SetAtlasOr(button.border, ATLAS_FRAME, "Interface\\Buttons\\UI-Quickslot2", 1.6, button.icon) then
		SetAroundIcon(button.border, button.icon, 13, 3, 3, 9)
	end
	-- glow on a macro that isn't on the action bars yet, like the native page's unassigned spells
	button.glow = button:CreateTexture(nil, "OVERLAY", nil, 5)
	if SetAtlasOr(button.glow, ATLAS_GLOW, "Interface\\Buttons\\UI-ActionButton-Border", 1.8, button.icon) then
		SetAroundIcon(button.glow, button.icon, 6, 5, 5, 5)
	else
		button.glow:SetBlendMode("ADD")
		button.glow:SetVertexColor(1, 0.82, 0) -- the texture is white; Blizzard tints it per use
	end
	button.glow:Hide()
	-- fades in and out like the spellbook's glow on new spells; UpdateGlow starts it
	button.pulse = button.glow:CreateAnimationGroup()
	button.pulse:SetLooping("BOUNCE")
	local fade = button.pulse:CreateAnimation("Alpha")
	fade:SetFromAlpha(1)
	fade:SetToAlpha(0.2)
	fade:SetDuration(0.5)
	fade:SetSmoothing("IN_OUT")
	local highlight = button:CreateTexture(nil, "HIGHLIGHT")
	if HasAtlas(ATLAS_FRAME_HOVER) then
		highlight:SetAtlas(ATLAS_FRAME_HOVER, false)
	else
		highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
		highlight:SetBlendMode("ADD")
	end
	SetAroundIcon(highlight, button.icon, 2, 2, 2, 2)

	local text = CreateFrame("Frame", nil, button)
	text:SetHeight(29.5)
	text:SetPoint("LEFT", 50, -1)
	text:SetPoint("RIGHT", 0, -1)
	button.name = text:CreateFontString(nil, "ARTWORK", geometry.nameFont)
	button.name:SetPoint("TOPLEFT")
	button.name:SetPoint("TOPRIGHT")
	button.name:SetJustifyH("LEFT")
	button.name:SetWordWrap(false)
	button.name:SetTextColor(unpack(INK_COLOR))
	button.subText = text:CreateFontString(nil, "ARTWORK", geometry.subTextFont)
	button.subText:SetPoint("TOPLEFT", button.name, "BOTTOMLEFT", 0, -2)
	button.subText:SetPoint("TOPRIGHT", button.name, "BOTTOMRIGHT", 0, -2)
	button.subText:SetJustifyH("LEFT")
	button.subText:SetWordWrap(false)

	button:RegisterForDrag("LeftButton")
	button:SetScript("OnDragStart", function(self)
		ns.PickupMacro(self.macro)
	end)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetScript("OnClick", function(self, mouseButton)
		if mouseButton == "RightButton" then
			HideTooltip(self)
			ns.ShowMacroMenu(self)
		else
			ns.PickupMacro(self.macro)
		end
	end)
	button:SetScript("OnEnter", function(self)
		-- an open menu stands alone: no macro's tooltip shows over or beside it
		if MenuOpen() then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		-- the item's or spell's own tooltip comes first, then the macro as a block of our own
		local spellID = TooltipSpellID(self.macro)
		if self.macro.equipment then
			GameTooltip:SetInventoryItem("player", self.macro.slot)
		elseif spellID then
			GameTooltip:SetSpellByID(spellID)
			if GameTooltip:NumLines() == 0 then
				GameTooltip:SetHyperlink("spell:" .. spellID)
			end
		end
		local title = ns.MacroHeading(L["ADDON_SHORT_NAME"], self.macro)
		if GameTooltip:NumLines() > 0 then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(title)
		else
			GameTooltip:SetText(title)
		end
		-- what the macro does beyond its text, set off by a blank line above
		local notes = {}
		if self.macro.equipment then
			notes[1] = GetColor("HELP") .. L["TOOLTIP_EQUIPMENT_SLOT"]:format(self.macro.slotLabel) .. "|r"
		end
		if not self.macro.custom then
			notes[#notes + 1] = OptionsOnLine(self.macro)
		end
		if #notes > 0 then
			GameTooltip:AddLine(" ")
			for _, note in ipairs(notes) do
				GameTooltip:AddLine(note, nil, nil, nil, true)
			end
		end
		-- the macro text always has a blank line above it, notes or none
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(ns.UntaggedBody(self.macro.body), 1, 1, 1, true)
		GameTooltip:AddLine(" ")
		if self.blockReason == "long" then
			local line = L["TOOLTIP_TOO_LONG"]:format(self.blockLength, ns.MACRO_BODY_MAX_LENGTH)
			GameTooltip:AddLine(GetColor("OFF") .. line .. "|r", nil, nil, nil, true)
			GameTooltip:AddLine(" ")
		elseif self.macro.unlearned then
			GameTooltip:AddLine(GetColor("OFF") .. L["TOOLTIP_NOT_LEARNED"] .. "|r", nil, nil, nil, true)
			local when = self.macro.learnTalent and L["TOOLTIP_LEARN_TALENT"]
				or self.macro.learnLevel and L["TOOLTIP_LEARN_LEVEL"]:format(self.macro.learnLevel)
			if when then
				GameTooltip:AddLine(GetColor("HELP") .. when .. "|r", nil, nil, nil, true)
			end
			GameTooltip:AddLine(" ")
		elseif self.glow:IsShown() then
			GameTooltip:AddLine(GetColor("HELP") .. L["TOOLTIP_NOT_ON_BARS"] .. "|r", nil, nil, nil, true)
			GameTooltip:AddLine(" ")
		end
		AddHint(L["TOOLTIP_KEY_CLICK_DRAG"], L["TOOLTIP_ACTION_PLACE_ON_BAR"])
		if ns.HasOptions(self.macro) then
			AddHint(L["TOOLTIP_KEY_RIGHT_CLICK"], L["TOOLTIP_ACTION_MACRO_OPTIONS"])
		end
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", HideTooltip)
	button:SetScript("OnHide", HideTooltip)
	return button
end

--[[
	Shows the glow when the button's macro is learned but not on the bars (from ns.ScanActionBars).
	Custom macros, the stance bar's forms (noGlow) and macros marked placed never glow.
]]
local function UpdateGlow(button, bars)
	local macro = button.macro
	local shown = not macro.custom
		and not macro.noGlow
		and not macro.unlearned
		and not ns.IsMarkedPlaced(macro)
		and not ns.IsOnActionBars(macro, bars)
	button.glow:SetShown(shown)
	if not shown then
		button.pulse:Stop()
	elseif not button.pulse:IsPlaying() then
		button.pulse:Play()
	end
end

--[[
	bars is a ns.ScanActionBars() result, read here when nil. A macro the page can't place
	(ns.MacroBlockReason) says why in red in place of its note.
]]
local function SetMacro(button, macro, bars)
	button.macro = macro
	button.blockReason, button.blockLength = ns.MacroBlockReason(macro)
	UpdateGlow(button, bars or ns.ScanActionBars())
	button.icon:SetTexture(macro.icon)
	button.icon:SetDesaturated(macro.unlearned == true)
	local frameAtlas = macro.unlearned and ATLAS_FRAME_INACTIVE or ATLAS_FRAME
	if HasAtlas(frameAtlas) then
		button.border:SetAtlas(frameAtlas, false)
	end
	button.name:SetText(macro.label or macro.name) -- a Duplicate copy shows its number
	if button.blockReason then
		button.subText:SetText(GetColor("OFF") .. L["SUBTEXT_TOO_LONG"] .. "|r")
	elseif macro.custom then
		button.subText:SetText(L["SUBTEXT_CUSTOM"])
		button.subText:SetTextColor(unpack(INK_COLOR))
	elseif macro.equipment then
		-- like a spell's: the option that is on, else the slot ("Trinket 1") in place of a rank
		button.subText:SetText(OptionSubText(macro) or macro.slotLabel)
		button.subText:SetTextColor(unpack(FADED_INK_COLOR))
	elseif macro.focus then
		button.subText:SetText(L["SUBTEXT_FOCUS"])
		button.subText:SetTextColor(unpack(FADED_INK_COLOR))
	else
		local subText = OptionSubText(macro)
		if subText then
			button.subText:SetText(subText)
			button.subText:SetTextColor(unpack(FADED_INK_COLOR))
		elseif macro.unlearned and (macro.learnTalent or macro.learnLevel) then
			-- when it can be learned, in place of its "Rank 1"
			local when = macro.learnTalent and L["SUBTEXT_TALENT"] or L["SUBTEXT_LEARN_LEVEL"]:format(macro.learnLevel)
			button.subText:SetText(when)
			button.subText:SetTextColor(unpack(FADED_INK_COLOR))
		else
			-- with no option on, the spell's own subtext, as the game's spellbook shows it ("Rank 4", "Racial")
			local spellID = TooltipSpellID(macro)
			button.subText:SetText(spellID and C_Spell.GetSpellSubtext(spellID) or "")
			button.subText:SetTextColor(unpack(FADED_INK_COLOR))
		end
	end
end

ns.CreateMacroButton = CreateMacroButton
ns.UpdateMacroGlow = UpdateGlow
ns.SetMacroButton = SetMacro
