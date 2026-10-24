local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--[[
	Draws ns.macros (built by Features/Macro-Builder.lua) onto a spellbook page frame. The host files own the
	tab and the page frame itself.
]]

local function HideTooltip(owner)
	if GameTooltip:IsOwned(owner) then
		GameTooltip:Hide()
	end
end

local SetMacro, Refresh

-- "<label> // <macro name>", the heading of the macro's tooltip block and of its menu
local function MacroHeading(label, macro)
	return GetColor("INFO")
		.. label
		.. "|r "
		.. GetColor("SEPARATOR")
		.. "//|r "
		.. GetColor("TEXT")
		.. macro.name
		.. "|r"
end

--[[
	A group's submenu label with what is on in it: "Combat Check: None" for the one option on, "Targeting:
	2 Options" for more, the bare group name for none. entries is the group's { label, isOn } list.
]]
local function GroupLabel(labelKey, entries)
	local on
	local count = 0
	for _, entry in ipairs(entries) do
		if entry[2]() then
			on, count = entry[1], count + 1
		end
	end
	if count == 0 then
		return L[labelKey]
	end
	return L["MENU_GROUP_VALUE"]:format(L[labelKey], count == 1 and on or L["MENU_OPTIONS_COUNT"]:format(count))
end

-- Every spell macro has a menu; custom and equipment macros don't. A focus copy's menu only removes it.
local function ShowMacroMenu(button)
	local macro = button.macro
	if not ns.HasOptions(macro) then
		return
	end
	MenuUtil.CreateContextMenu(button, function(_, rootDescription)
		rootDescription:CreateTitle(MacroHeading(L["TOOLTIP_ACTION_MACRO_OPTIONS"], macro))
		rootDescription:CreateSpacer()
		--[[
			each group of options is a submenu (Combat Check, Ability Rank, Targeting, Attack, Utilities,
			Scripts, then Use Before Casting); a group's submenu appears with its first option, so a group the
			macro offers nothing in leaves no empty entry. Its label shows what is on in it (GroupLabel), set
			again each time the menu redraws, so ticking a box in the submenu updates it.
		]]
		local pendingGroup, menu, entries
		local function group(labelKey)
			pendingGroup = labelKey
		end
		local function placeGroup()
			if pendingGroup then
				local labelKey, groupEntries = pendingGroup, {}
				menu = rootDescription:CreateButton(L[labelKey])
				menu:AddInitializer(function(frame)
					frame.fontString:SetTextToFit(GroupLabel(labelKey, groupEntries))
				end)
				entries, pendingGroup = groupEntries, nil
			end
		end
		-- records an option of the open group for its label
		local function track(label, isOn)
			if entries then
				entries[#entries + 1] = { label, isOn }
			end
		end
		-- a silver line at the bottom of the open submenu
		local function addNote(noteKey)
			menu:CreateDivider()
			menu:CreateTitle(GetColor("HELP") .. L[noteKey] .. "|r")
		end
		-- options that change only this macro's own clauses; the rest also rewrite its focus copy
		local OWN_CLAUSES_ONLY = { mouseover = true, castOnSelf = true, targetTarget = true, cursor = true, pet = true }
		-- a checkbox for the option, when the macro offers it
		local function addOption(label, key)
			if not ns.OffersOption(macro, key) then
				return
			end
			placeGroup()
			local function isOn()
				return ns.IsOptionOn(macro, key)
			end
			track(label, isOn)
			menu:CreateCheckbox(label, isOn, function()
				ns.ToggleOption(macro, key)
				if not OWN_CLAUSES_ONLY[key] then
					Refresh(button:GetParent()) -- adds, removes or rewrites the focus copy
				elseif button.macro == macro then
					SetMacro(button, macro)
				end
			end)
		end
		if macro.focus then
			menu = rootDescription
			addOption(L["MENU_CAST_ON_FOCUS"], "focus")
			return
		end
		-- the combat check is a choice of one, so radio buttons; None (false) is the default
		if ns.OffersOption(macro, "combatOnly") then
			group("MENU_GROUP_COMBAT_CHECK")
			placeGroup()
			local function isChecked(check)
				return (ns.CombatCheck(macro) or false) == check
			end
			local function setCheck(check)
				ns.SetCombatCheck(macro, check or nil)
				Refresh(button:GetParent()) -- also rewrites the focus copy
			end
			for _, choice in ipairs({
				{ "MENU_ONLY_IN_COMBAT", "combatOnly" },
				{ "MENU_NEVER_IN_COMBAT", "noCombat" },
				{ "MENU_COMBAT_CHECK_NONE", false },
			}) do
				local label, check = L[choice[1]], choice[2]
				track(label, function()
					return isChecked(check)
				end)
				menu:CreateRadio(label, isChecked, setCheck, check)
			end
		end
		-- the rank is a choice of one too: each known rank, Max Rank (false, the default) or Dynamic Rank
		if ns.OffersFixedRank(macro) then
			group("MENU_GROUP_ABILITY_RANK")
			placeGroup()
			local function isChecked(choice)
				return (ns.AbilityRank(macro) or false) == choice
			end
			local function setChoice(choice)
				ns.SetAbilityRank(macro, choice or nil)
				Refresh(button:GetParent()) -- also rewrites the focus copy
			end
			local function addChoice(label, choice)
				track(label, function()
					return isChecked(choice)
				end)
				menu:CreateRadio(label, isChecked, setChoice, choice)
			end
			for i = #macro.ranks, 1, -1 do -- ranks are highest first; the menu lists them up from Rank 1
				local text = macro.ranks[i].text
				addChoice(text, text)
			end
			addChoice(L["MENU_MAX_RANK"], false)
			if ns.OffersTargetRank(macro) then
				addChoice(L["MENU_DYNAMIC_RANK"], "targetRank")
				addNote("MENU_DYNAMIC_RANK_NOTE")
			end
		end
		group("MENU_GROUP_TARGETING")
		addOption(L["MENU_CAST_ON_MOUSEOVER"], "mouseover")
		addOption(L["MENU_CAST_ON_SELF"], "castOnSelf")
		addOption(L["MENU_CAST_ON_TARGETS_TARGET"], "targetTarget")
		addOption(L["MENU_CAST_ON_FOCUS"], "focus")
		addOption(L["MENU_CAST_AT_CURSOR"], "cursor")
		addOption(L["MENU_TARGET_NEAREST_ENEMY"], "targetEnemy")
		group("MENU_GROUP_ATTACK")
		addOption(L["MENU_STOP_ATTACK"], "stopAttack")
		addOption(L["MENU_START_AUTO_ATTACK"], "startAttack")
		if ns.AutoShotLabelKey() then
			addOption(L[ns.AutoShotLabelKey()], "autoShot")
		end
		addOption(L["MENU_ENABLE_PET_ATTACK"], "petAttack")
		addOption(L["MENU_STOP_CASTING"], "stopCast")
		if ns.OffersOption(macro, "stopCast") then
			addNote("MENU_STOP_CASTING_NOTE")
		end
		group("MENU_GROUP_UTILITY")
		if macro.petAbility then
			addOption(L["MENU_CAST_IF_SUMMONED"]:format(macro.petAbility), "pet")
		end
		if macro.stances then
			addOption(L["MENU_SWITCH_TO"]:format(macro.stances[1]), "stance")
		end
		addOption(L["MENU_LEAVE_FORM_BEFORE"], "cancelForm")
		if macro.groupSpell then
			addOption(L["MENU_RIGHT_CLICK_FOR"]:format(macro.groupSpell), "groupVersion")
		end
		addOption(L["MENU_SPAMMABLE"], "spam")
		addOption(L["MENU_DOWNRANK_IN_RAIDS"], "raidRank1")
		addOption(L["MENU_ONCE_PER_TARGET"], "oncePerTarget")
		addOption(L["MENU_ONCE_PER_COMBAT"], "oncePerCombat")
		addOption(L["MENU_NEVER_TURN_OFF"], "noToggle")
		if ns.OffersOption(macro, "noToggle") then
			addNote("MENU_NEVER_TURN_OFF_NOTE")
		end
		group("MENU_GROUP_SCRIPTS")
		addOption(L["MENU_HIDE_ERRORS"], "hideErrors")
		addOption(L["MENU_MUTE_ERRORS"], "muteErrors")
		group("MENU_USE_BEFORE_CASTING")
		if ns.OffersUseItems(macro) then
			-- the equipped on-use items, plus any slot already ticked so it can be unticked after a gear swap
			local slots, listed = {}, {}
			for _, usable in ipairs(ns.UsableSlots()) do
				slots[#slots + 1], listed[usable.slot] = usable.slot, true
			end
			for _, slot in ipairs(ns.UseItemSlots(macro)) do
				if not listed[slot] then
					slots[#slots + 1] = slot
				end
			end
			if #slots > 0 then
				placeGroup()
				for _, slot in ipairs(slots) do
					local at = ns.IsUsingSlot(macro, slot)
					local function isOn()
						return ns.IsUsingSlot(macro, slot) ~= nil
					end
					track(ns.SlotLabel(slot), isOn)
					menu:CreateCheckbox(ns.SlotLabel(slot) .. (at and " (" .. at .. ")" or ""), isOn, function()
						ns.ToggleUseSlot(macro, slot)
						Refresh(button:GetParent()) -- rewrites the focus copy too
					end)
				end
			end
		end
	end)
end

--[[
	The page's layout inside its frame. The default is the Retail-engine book (Camelot's
	Blizzard_SpellBookTemplates.xml): each page's spell view is 680 wide, 95 below the book's top, 85 from its
	left (left page) or 50 from its right (right page), and the page frame starts 60 below the book's top. A
	host whose book differs passes its own as page.geometry before the page is built.
]]
local DEFAULT_GEOMETRY = {
	viewWidth = 680,
	viewTop = -35,
	viewLeft = 85,
	viewRight = 50,
	viewBottom = 75,
	columns = 3,
	footerBottom = 46, -- the footer's bottom edge, roughly level with the paging arrows (40 up)
	pagingRight = -75,
	pagingBottom = 40,
	nameFont = "SystemFont_Large",
	subTextFont = "SystemFont_Med1",
}
local CELL_HEIGHT, CATEGORY_GAP = 52, 12
local ICON_SIZE = 36

-- parchment ink, matching the native spell names and subtext
local INK_COLOR = { 0.18, 0.106, 0.059 }
-- faded ink for hints, labels and a spell's options note: the ink at 60% over the parchment, opaque so it also works as a |c code
local FADED_INK_COLOR = { 0.44, 0.37, 0.28 }

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

-- A keybind and what it does, both in the interaction blue, as a pair across the tooltip.
local function AddHint(keybind, action)
	GameTooltip:AddDoubleLine(GetColor("INFO") .. keybind .. "|r", GetColor("INFO") .. action .. "|r")
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
			ShowMacroMenu(self)
		else
			ns.PickupMacro(self.macro)
		end
	end)
	button:SetScript("OnEnter", function(self)
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
		local title = MacroHeading(L["ADDON_SHORT_NAME"], self.macro)
		if GameTooltip:NumLines() > 0 then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(title)
		else
			GameTooltip:SetText(title)
		end
		GameTooltip:AddLine(self.macro.body, 1, 1, 1, true)
		GameTooltip:AddLine(" ")
		if self.macro.unlearned then
			GameTooltip:AddLine(GetColor("OFF") .. L["TOOLTIP_NOT_LEARNED"] .. "|r", nil, nil, nil, true)
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
	The options a spell's note can name, most telling first: the note names the one that is on, or counts
	them when more than one is. stopCast and startAttack count only when ticked, since their default would
	put them on every spell.
]]
local OPTION_SUBTEXTS = {
	{ "pet", "SUBTEXT_PET" },
	{ "cursor", "SUBTEXT_CURSOR" },
	{ "mouseover", "SUBTEXT_MOUSEOVER" },
	{ "castOnSelf", "SUBTEXT_CAST_ON_SELF" },
	{ "targetTarget", "SUBTEXT_TARGETS_TARGET" },
	{ "stance", "SUBTEXT_STANCE" },
	{ "useItems", "SUBTEXT_USE_ITEMS" },
	{ "petAttack", "SUBTEXT_PET_ATTACK" },
	{ "raidRank1", "SUBTEXT_RAID_RANK_1" },
	{ "spam", "SUBTEXT_SPAMMABLE" },
	{ "targetRank", "SUBTEXT_DYNAMIC_RANK" },
	{ "fixedRank" },
	{ "targetEnemy", "SUBTEXT_TARGET_ENEMY" },
	{ "groupVersion", "SUBTEXT_GROUP_VERSION" },
	{ "oncePerCombat", "SUBTEXT_ONCE_PER_COMBAT" },
	{ "oncePerTarget", "SUBTEXT_ONCE_PER_TARGET" },
	{ "combatOnly", "SUBTEXT_COMBAT_ONLY" },
	{ "noCombat", "SUBTEXT_NO_COMBAT" },
	{ "cancelForm", "SUBTEXT_LEAVE_FORM" },
	{ "noToggle", "SUBTEXT_NO_TOGGLE" },
	{ "autoShot" },
	{ "startAttack", "SUBTEXT_START_ATTACK", ticked = true },
	{ "stopAttack", "SUBTEXT_STOP_ATTACK" },
	{ "stopCast", "SUBTEXT_STOP_CASTING", ticked = true },
	{ "hideErrors", "SUBTEXT_HIDE_ERRORS" },
	{ "muteErrors", "SUBTEXT_MUTE_ERRORS" },
}

local AUTO_SHOT_SUBTEXTS = {
	MENU_START_AUTO_SHOT = "SUBTEXT_AUTO_SHOT",
	MENU_START_WAND = "SUBTEXT_WAND",
}

--[[
	A spell macro's note: the name of its one option that is on, "N Options" when several are, or nil when
	none is.
]]
local function OptionSubText(macro)
	local count, first = 0, nil
	for _, entry in ipairs(OPTION_SUBTEXTS) do
		local key = entry[1]
		local on
		if key == "useItems" then
			on = ns.UseItemSlots(macro)[1] ~= nil
		elseif key == "fixedRank" then
			on = ns.FixedRank(macro) ~= nil
		elseif entry.ticked then
			on = ns.IsOptionTicked(macro, key)
		else
			on = ns.IsOptionOn(macro, key)
		end
		if on then
			count = count + 1
			if not first then
				-- a fixed rank's note is the rank's own text ("Rank 3")
				first = key == "fixedRank" and ns.FixedRank(macro)
					or L[entry[2] or AUTO_SHOT_SUBTEXTS[ns.AutoShotLabelKey()]]
			end
		end
	end
	if count > 1 then
		return L["SUBTEXT_OPTIONS_COUNT"]:format(count)
	end
	return first
end

-- bars is a ns.ScanActionBars() result, scanned here when nil.
function SetMacro(button, macro, bars)
	button.macro = macro
	UpdateGlow(button, bars or ns.ScanActionBars())
	button.icon:SetTexture(macro.icon)
	button.icon:SetDesaturated(macro.unlearned == true)
	local frameAtlas = macro.unlearned and ATLAS_FRAME_INACTIVE or ATLAS_FRAME
	if HasAtlas(frameAtlas) then
		button.border:SetAtlas(frameAtlas, false)
	end
	button.name:SetText(macro.name)
	if macro.custom then
		button.subText:SetText(L["SUBTEXT_CUSTOM"])
		button.subText:SetTextColor(unpack(INK_COLOR))
	elseif macro.equipment then
		button.subText:SetText(macro.slotLabel)
		button.subText:SetTextColor(unpack(INK_COLOR))
	elseif macro.focus then
		button.subText:SetText(L["SUBTEXT_FOCUS"])
		button.subText:SetTextColor(unpack(FADED_INK_COLOR))
	else
		local subText = OptionSubText(macro)
		if subText then
			button.subText:SetText(subText)
			button.subText:SetTextColor(unpack(FADED_INK_COLOR))
		else
			button.subText:SetText(ns.HasCastOptions(macro) and L["SUBTEXT_MACRO"] or L["SUBTEXT_SELF"])
			button.subText:SetTextColor(unpack(INK_COLOR))
		end
	end
end

local function HasTemplate(template)
	return C_XMLUtil.GetTemplateInfo(template) ~= nil
end

--[[
	The same category bar the native page draws over each skill line, on the Retail-engine book. The Classic
	engine's books have no such template, so their header is the name in the book's own font over a faint
	rule, shaped the same (Text and Backplate) so SetHeader serves both.
]]
local function CreateHeader(parent)
	local width = parent.geometry.viewWidth
	if HasTemplate("SpellBookHeaderTemplate") then
		local header = CreateFrame("Frame", nil, parent, "SpellBookHeaderTemplate")
		header:SetWidth(width)
		header.maxBackplateWidth = width + 85
		return header
	end
	local header = CreateFrame("Frame", nil, parent)
	header:SetSize(width, 24)
	-- the spell names' shadowless font; GameFontNormalLarge's drop shadow reads as bold on parchment
	header.Text = header:CreateFontString(nil, "ARTWORK", parent.geometry.nameFont)
	header.Text:SetPoint("LEFT", 8, 0)
	header.Text:SetTextColor(unpack(INK_COLOR))
	header.Backplate = header:CreateTexture(nil, "BACKGROUND")
	header.Backplate:SetColorTexture(INK_COLOR[1], INK_COLOR[2], INK_COLOR[3], 0.25)
	header.Backplate:SetHeight(1)
	header.Backplate:SetPoint("BOTTOMLEFT", 4, 0)
	header.maxBackplateWidth = width - 8
	return header
end

local function SetHeader(header, text)
	header.Text:SetText(text)
	header.Backplate:SetWidth(math.min(header.maxBackplateWidth, math.max(416, header.Text:GetStringWidth() * 2.5)))
end

-- Acquire hands out pooled frames in order; ReleaseAll hides the ones from the last layout.
local function FramePool(create)
	local pool = { used = 0 }
	function pool:Acquire()
		self.used = self.used + 1
		local frame = self[self.used] or create()
		self[self.used] = frame
		frame:ClearAllPoints()
		frame:Show()
		return frame
	end
	function pool:ReleaseAll()
		for i = 1, #self do
			self[i]:Hide()
		end
		self.used = 0
	end
	return pool
end

--[[
	Splits the macros into page halves of {header = text, y} and {macro, column, y} entries. A category
	flows top to bottom and repeats its header when it carries over to the next half.
]]
local function Paginate(height, headerHeight, columns)
	local halves, half, y = {}, nil, 0
	local function newHalf()
		half, y = {}, 0
		halves[#halves + 1] = half
	end
	local function addHeader(text)
		half[#half + 1] = { header = text, y = y }
		y = y + headerHeight
	end
	newHalf()
	local category, column
	for _, macro in ipairs(ns.macros) do
		if macro.category ~= category then
			category, column = macro.category, 0
			if y > 0 then
				y = y + CELL_HEIGHT + CATEGORY_GAP -- close the previous category's last row
				if y + headerHeight + CELL_HEIGHT > height then
					newHalf()
				end
			end
			addHeader(category)
		elseif column == columns then
			column = 0
			y = y + CELL_HEIGHT
			if y + CELL_HEIGHT > height then
				newHalf()
				addHeader(category)
			end
		end
		half[#half + 1] = { macro = macro, column = column, y = y }
		column = column + 1
	end
	return halves
end

-- Draws the current spread: two pages side by side, or one when the book is minimized.
local function Layout(page)
	local geometry = page.geometry
	local viewWidth, viewTop = geometry.viewWidth, geometry.viewTop
	local cellWidth = viewWidth / geometry.columns
	page.headers:ReleaseAll()
	page.buttons:ReleaseAll()
	local controls = page.pagingControls
	local width, height = page:GetWidth(), page:GetHeight()
	local spread = width >= 2 * viewWidth and 2 or 1
	-- a minimized book shows one page, centred; an open one uses the native left and right pages
	local origins = spread == 2 and { geometry.viewLeft, width - geometry.viewRight - viewWidth }
		or { (width - viewWidth) / 2 }
	page.footer:ClearAllPoints()
	page.footer:SetPoint("BOTTOMLEFT", page, "BOTTOMLEFT", origins[1] + 8, geometry.footerBottom)
	page.footer:SetWidth(viewWidth - 16)
	if #ns.macros == 0 then
		local header = page.headers:Acquire()
		header:SetPoint("TOPLEFT", page, "TOPLEFT", origins[1], viewTop)
		SetHeader(header, L["ADDON_TITLE"])
		page.empty:SetText(L["PAGE_EMPTY"])
		page.empty:ClearAllPoints()
		page.empty:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 8, -12)
		page.empty:Show()
		controls:Hide()
		return
	end
	page.empty:Hide()

	local headerHeight = math.max(page.headers:Acquire():GetHeight(), 30) + 8
	page.headers:ReleaseAll()

	local halves = Paginate(height + viewTop - geometry.viewBottom, headerHeight, geometry.columns)
	local maxPages = math.ceil(#halves / spread)
	page.paging = true
	controls:SetMaxPages(maxPages)
	page.paging = false
	controls:SetShown(maxPages > 1)
	local current = math.min(controls:GetCurrentPage(), maxPages)
	local bars = ns.ScanActionBars()
	for side = 1, spread do
		local x = origins[side]
		for _, entry in ipairs(halves[(current - 1) * spread + side] or {}) do
			if entry.header then
				local header = page.headers:Acquire()
				header:SetPoint("TOPLEFT", page, "TOPLEFT", x, viewTop - entry.y)
				SetHeader(header, entry.header)
			else
				local button = page.buttons:Acquire()
				button:SetPoint("TOPLEFT", page, "TOPLEFT", x + entry.column * cellWidth + 8, viewTop - entry.y - 4)
				SetMacro(button, entry.macro, bars)
			end
		end
	end
end

--[[
	The general and character macro slots used, beside the settings menu: "Macro Slots" and the counts in ink,
	the list names faded between them, and a full list's count in the palette's OFF red.
]]

local function Colored(color, text)
	local function byte(channel)
		return math.floor(channel * 255 + 0.5)
	end
	return ("|cff%02x%02x%02x%s|r"):format(byte(color[1]), byte(color[2]), byte(color[3]), text)
end

local function SlotCount(label, used, max)
	local count = used .. "/" .. max
	count = used >= max and GetColor("OFF") .. count .. "|r" or Colored(INK_COLOR, count)
	return Colored(FADED_INK_COLOR, label) .. " " .. count
end

local function UpdateMacroCount(page)
	local numAccount, maxAccount, numCharacter, maxCharacter = ns.MacroCounts()
	page.macroCount:SetText(
		L["PAGE_MACRO_SLOTS"]
			.. "     "
			.. SlotCount(L["PAGE_MACRO_GENERAL"], numAccount, maxAccount)
			.. "   "
			.. SlotCount(L["PAGE_MACRO_CHARACTER"], numCharacter, maxCharacter)
	)
end

-- Rebuilds the list from the spellbook and the class lists, updates changed macros, then redraws.
function Refresh(page)
	ns.CollectMacros()
	ns.SyncAllMacros()
	Layout(page)
	UpdateMacroCount(page)
end

local pages = {} -- every page built, so a settings change can redraw the open one

local function BuildPage(page)
	pages[#pages + 1] = page
	page.geometry = page.geometry or DEFAULT_GEOMETRY
	page.headers = FramePool(function()
		return CreateHeader(page)
	end)
	page.buttons = FramePool(function()
		return CreateMacroButton(page)
	end)

	page.empty = page:CreateFontString(nil, "OVERLAY", "SystemFont_Med3")
	page.empty:SetTextColor(unpack(INK_COLOR))

	-- usage hint along the bottom of the left page, level with the paging arrows; Layout places it
	page.footer = page:CreateFontString(nil, "OVERLAY", "SystemFont_Med1")
	page.footer:SetTextColor(unpack(FADED_INK_COLOR))
	page.footer:SetJustifyH("LEFT")
	page.footer:SetText(L["PAGE_FOOTER"])

	local function SetupSettingsMenu(_, rootDescription)
		rootDescription:CreateTitle(SETTINGS)
		if ns.ForEachUnlearnedSpell then
			rootDescription:CreateCheckbox(L["SETTINGS_SHOW_UNLEARNED"], ns.ShowsUnlearned, function()
				ns.SetShowUnlearned(not ns.ShowsUnlearned())
				if page.pagingControls.SetCurrentPage then
					page.paging = true
					page.pagingControls:SetCurrentPage(1)
					page.paging = false
				end
				Refresh(page)
			end)
		end
		rootDescription:CreateCheckbox(L["SETTINGS_COUNT_SPELLS_ON_BARS"], ns.CountsSpellsOnBars, function()
			ns.SetCountSpellsOnBars(not ns.CountsSpellsOnBars())
			Layout(page)
		end)
		if ns.ClassOffersPetAttack() then
			rootDescription:CreateCheckbox(L["SETTINGS_PET_ATTACK_DEFAULT"], ns.PetAttacksByDefault, function()
				ns.SetPetAttacksByDefault(not ns.PetAttacksByDefault())
				Refresh(page) -- rewrites the macros that follow the default
			end)
		end
		if ns.IsMeleeClass() then
			rootDescription:CreateCheckbox(L["SETTINGS_START_ATTACK_DEFAULT"], ns.StartsAttackByDefault, function()
				ns.SetStartsAttackByDefault(not ns.StartsAttackByDefault())
				Refresh(page) -- rewrites the macros that follow the default
			end)
		end
		rootDescription:CreateDivider()
		rootDescription:CreateButton(L["SETTINGS_MARK_ALL_PLACED"], function()
			ns.MarkAllPlaced()
			ns:OnActionbarSlotChanged() -- redraws the glows
		end)
	end

	--[[
		The page-wide settings menu. On the Retail-engine book it is the native settings cog, laid over the
		native one in the toolbar; the Classic engine's books have no cog, so a gear button at the page's top
		right opens the same menu.
	]]
	if page.header and HasTemplate("SpellBookSettingsDropdownTemplate") then
		local options = CreateFrame("DropdownButton", nil, page.header, "SpellBookSettingsDropdownTemplate")
		page.options = options
		options:ClearAllPoints()
		options:SetPoint("TOPRIGHT", page.header, "TOPRIGHT", -30, -27)
		options:SetupMenu(SetupSettingsMenu)
	else
		local options = CreateFrame("Button", nil, page)
		page.options = options
		options:SetSize(20, 20)
		options:SetPoint("TOPRIGHT", page, "TOPRIGHT", -6, -6)
		options:SetNormalTexture("Interface\\Buttons\\UI-OptionsButton")
		options:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
		options:SetScript("OnClick", function(self)
			MenuUtil.CreateContextMenu(self, SetupSettingsMenu)
		end)
	end

	--[[
		The macro slot counts: left of the gear on the Classic engine's books. On the Retail engine's the native
		search box sits left of the cog, so they go at the page's top right, just under the cog.
	]]
	page.macroCount = page:CreateFontString(nil, "OVERLAY", "SystemFont_Med1")
	page.macroCount:SetJustifyH("RIGHT")
	page.macroCount:SetTextColor(unpack(INK_COLOR)) -- "Macro Slots"; UpdateMacroCount colours the rest
	if page.options:GetParent() == page.header then
		page.macroCount:SetPoint("TOPRIGHT", page, "TOPRIGHT", -30, -8)
	else
		page.macroCount:SetPoint("RIGHT", page.options, "LEFT", -6, 0)
	end

	-- the native page's "Page 1/2" arrows, bottom right of the book. The template reads its "Page 1/2" format
	-- from the global PAGE_NUMBER_WITH_MAX while it loads, and the Classic engine's clients don't define it, so
	-- lend it one for the CreateFrame call
	local lendPageFormat = PAGE_NUMBER_WITH_MAX == nil
	if lendPageFormat then
		PAGE_NUMBER_WITH_MAX = (PAGE_NUMBER or "Page %d") .. "/%d"
	end
	local controls = CreateFrame("Frame", nil, page, "PagingControlsHorizontalTemplate")
	if lendPageFormat then
		PAGE_NUMBER_WITH_MAX = nil
	end
	page.pagingControls = controls
	controls:SetPoint("BOTTOMRIGHT", page, "BOTTOMRIGHT", page.geometry.pagingRight, page.geometry.pagingBottom)
	controls.PageText:SetFontObject("SystemFont_Med3")
	controls.PageText:SetTextColor(unpack(INK_COLOR))
	controls.spacing = 8
	controls.prevPageSound, controls.nextPageSound = SOUNDKIT.IG_ABILITY_PAGE_TURN, SOUNDKIT.IG_ABILITY_PAGE_TURN
	function page:OnPageChanged()
		if not self.paging then
			Layout(self)
		end
	end
	page:EnableMouseWheel(true)
	page:SetScript("OnMouseWheel", function(_, delta)
		if controls:IsShown() then
			controls:OnMouseWheel(delta)
		end
	end)

	page:SetScript("OnSizeChanged", function(self)
		if self:IsVisible() then
			Layout(self)
		end
	end)
end

ns.BuildSpellbookPage = BuildPage
ns.RefreshSpellbookPage = Refresh

--[[
	Redraws whichever page is open, after a change made outside it (the options panel, a profile change).
	Returns whether a page was open.
]]
function ns:RefreshOpenPages()
	local refreshed = false
	for _, page in ipairs(pages) do
		if page:IsVisible() then
			Refresh(page)
			refreshed = true
		end
	end
	return refreshed
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

--[[
	A learned spell or the gear worn changes the page's list; redraw the open page. With no page open, the
	list is dropped, so the targetRank macros rebuild it, new ranks and all, before their next rewrite.
]]
function ns:OnSpellsChanged()
	if not ns:RefreshOpenPages() then
		wipe(ns.macros)
	end
end

function ns:OnPlayerEquipmentChanged()
	ns:InvalidateUsableSlots()
	ns:RefreshOpenPages()
end

--[[
	Unlearned spells whose names weren't loaded were skipped; redraw once a burst of them arrives. It can
	fire before PLAYER_LOGIN creates the database.
]]
local refreshPending = false

function ns:OnSpellDataLoadResult()
	if not ns.db or not ns.ShowsUnlearned() or refreshPending then
		return
	end
	refreshPending = true
	C_Timer.After(0, function()
		refreshPending = false
		ns:RefreshOpenPages()
	end)
end

-- Placing or removing an action only changes the glows; redraw them once per burst.
local glowsPending = false

local function RedrawGlows()
	glowsPending = false
	local bars
	for _, page in ipairs(pages) do
		if page:IsVisible() then
			bars = bars or ns.ScanActionBars()
			for i = 1, page.buttons.used do
				UpdateGlow(page.buttons[i], bars)
			end
		end
	end
end

function ns:OnActionbarSlotChanged()
	if not glowsPending then
		glowsPending = true
		C_Timer.After(0, RedrawGlows)
	end
end

-- A macro made or deleted, here or in the macro window, changes the slot counts as well as the glows.
function ns:OnUpdateMacros()
	ns:OnActionbarSlotChanged()
	for _, page in ipairs(pages) do
		if page:IsVisible() then
			UpdateMacroCount(page)
		end
	end
end
