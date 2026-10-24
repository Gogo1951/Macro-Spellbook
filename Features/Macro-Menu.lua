local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--[[
	A page macro's right-click options menu, opened from its button on the page (Features/Macro-Button.lua).
	The options themselves live in Features/Macro-Options.lua.
]]

-- "<label> // <macro name>", the heading of the macro's tooltip block and of its menu
function ns.MacroHeading(label, macro)
	return GetColor("INFO")
		.. label
		.. "|r "
		.. GetColor("SEPARATOR")
		.. "//|r "
		.. GetColor("TEXT")
		.. (macro.label or macro.name)
		.. "|r"
end

local MacroHeading = ns.MacroHeading

local NOTE_WIDTH = 300 -- the widest a submenu's note runs before it wraps

--[[
	Lays text out in a menu title's font string as a left-aligned block width wide, wrapping as it needs, and
	returns the block's size for the menu to take. The menu gives a title's text a fixed 20 high, which
	would cut it to one line, so the height is freed before the text is measured.
]]
local function TextBlock(fontString, text, width)
	width = math.ceil(width)
	fontString:SetJustifyH("LEFT")
	fontString:SetWordWrap(true)
	if fontString.SetMaxLines then
		fontString:SetMaxLines(0)
	end
	fontString:SetWidth(width)
	fontString:SetHeight(0)
	fontString:SetText(text)
	local height = math.ceil(fontString:GetStringHeight())
	fontString:SetHeight(height)
	return width, height
end

--[[
	A group's submenu label with what is on in it: "Combat Check: None" for the one option on, "Targeting:
	2 Options" for more, the bare group name for none. With something on, the group name is gray so what is on
	stands out in white. entries is the group's { label, isOn } list.
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
	local value = count == 1 and on or L["MENU_OPTIONS_COUNT"]:format(count)
	-- the gray runs through the format's separator (": ", "：") and ends at the value
	return L["MENU_GROUP_VALUE"]:format(GetColor("SEPARATOR") .. L[labelKey], "|r" .. value)
end

--[[
	The macro text's lines, for the menu's preview, with pipes escaped so the text shows as written. The tag
	line is left out, though the length line counts it.
]]
local function BodyLines(macro)
	local lines = {}
	for line in (ns.UntaggedBody(macro.body) .. "\n"):gmatch("([^\n]*)\n") do
		lines[#lines + 1] = line:gsub("|", "||")
	end
	return lines
end

-- "Macro Text  142 / 255", the count in red once the text is over what a macro holds.
local function MacroLengthLine(macro)
	local length = #macro.body
	return GetColor("HELP")
		.. L["MACRO_TEXT"]
		.. "|r  "
		.. GetColor(length > ns.MACRO_BODY_MAX_LENGTH and "OFF" or "HELP")
		.. L["MENU_MACRO_LENGTH"]:format(length, ns.MACRO_BODY_MAX_LENGTH)
		.. "|r"
end

--[[
	Every spell and equipment macro has a menu; custom macros don't. A focus copy's menu only removes it. The
	menu stays open while options change: the game's checkboxes refresh it by default, and the radio choices
	ask it to, so every label and the preview redraw in place.
]]
function ns.ShowMacroMenu(button)
	local macro = button.macro
	if not ns.HasOptions(macro) then
		return
	end
	MenuUtil.CreateContextMenu(button, function(_, rootDescription)
		rootDescription:CreateTitle(MacroHeading(L["TOOLTIP_ACTION_MACRO_OPTIONS"], macro))
		rootDescription:CreateSpacer()
		--[[
			each group of options is a submenu (Combat Check, Spell Rank, Targeting, Before Casting, Add
			Attack, Casting Rules, Error Messages, then Use Items First); a group's submenu appears with its first
			option, so a group the macro offers nothing in leaves no empty entry. Its label shows what is on in it (GroupLabel), set
			again each time the menu redraws, so ticking a box in the submenu updates it.
		]]
		local pendingGroup, menu, entries
		local pendingSection = false
		local function group(labelKey)
			pendingGroup, pendingSection = labelKey, false
		end
		-- a divider before the open group's next option, only when options sit above it, so none dangles
		local function section()
			pendingSection = true
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
		--[[
			a silver line at the bottom of the open submenu, wrapped at NOTE_WIDTH so a long note doesn't stretch
			the submenu across the screen. Rule: every note gets a divider above it, so each note is set off from
			the options and from the note before it; two notes never run together.
		]]
		local function addNote(noteKey)
			menu:CreateDivider()
			local text = GetColor("HELP") .. L[noteKey] .. "|r"
			menu:CreateTitle(text):AddInitializer(function(frame)
				local fontString = frame.fontString
				fontString:SetText(text)
				return TextBlock(fontString, text, math.min(fontString:GetUnboundedStringWidth(), NOTE_WIDTH))
			end)
		end
		-- options that change only this macro's own clauses; the rest also rewrite its focus copy
		local OWN_CLAUSES_ONLY = { mouseover = true, castOnSelf = true, targetTarget = true, cursor = true, pet = true }
		-- a checkbox for the option, when the macro offers it
		local function addOption(label, key)
			if not ns.OffersOption(macro, key) then
				return
			end
			placeGroup()
			if pendingSection and entries and #entries > 0 then
				menu:CreateDivider()
			end
			pendingSection = false
			local function isOn()
				return ns.IsOptionOn(macro, key)
			end
			track(label, isOn)
			menu:CreateCheckbox(label, isOn, function()
				ns.ToggleOption(macro, key)
				if not OWN_CLAUSES_ONLY[key] then
					ns.RefreshSpellbookPage(button:GetParent()) -- adds, removes or rewrites the focus copy
				elseif button.macro == macro then
					ns.SetMacroButton(button, macro)
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
				ns.RefreshSpellbookPage(button:GetParent()) -- also rewrites the focus copy
				return MenuResponse.Refresh -- a radio closes the menu unless told otherwise
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
		--[[
			the rank is a choice of one too: each known rank, Max Rank (false, the default) or Dynamic Rank. The
			ranks not learned yet are listed among them in red, and can't be chosen.
		]]
		group("MENU_GROUP_SPELL_RANK")
		if ns.OffersFixedRank(macro) then
			placeGroup()
			local function isChecked(choice)
				return (ns.AbilityRank(macro) or false) == choice
			end
			local function setChoice(choice)
				ns.SetAbilityRank(macro, choice or nil)
				ns.RefreshSpellbookPage(button:GetParent()) -- also rewrites the focus copy
				return MenuResponse.Refresh
			end
			local function addChoice(label, choice)
				track(label, function()
					return isChecked(choice)
				end)
				menu:CreateRadio(label, isChecked, setChoice, choice)
			end
			local all = {}
			for _, list in ipairs({ macro.ranks, macro.unknownRanks or {} }) do
				for _, rank in ipairs(list) do
					all[#all + 1] = rank
				end
			end
			table.sort(all, function(a, b) -- the menu lists them up from Rank 1
				return a.level < b.level
			end)
			for _, rank in ipairs(all) do
				if rank.unknown then
					-- a rank not learned yet shows the level it's learned at
					local label = GetColor("OFF") .. L["MENU_RANK_LEARN_LEVEL"]:format(rank.text, rank.level) .. "|r"
					menu:CreateRadio(label, isChecked, setChoice, rank.text):SetEnabled(false)
				else
					addChoice(rank.text, rank.text)
				end
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
		-- in three sections, each set off by a divider: stopping, then holding off or changing form, then targeting
		group("MENU_GROUP_BEFORE_CAST")
		addOption(L["MENU_STOP_ATTACK"], "stopAttack")
		addOption(L["MENU_STOP_CASTING"], "stopCast")
		section()
		addOption(L["MENU_STOP_IF_CHANNELING"], "stopIfChanneling")
		addOption(L["MENU_STOP_IF_STEALTHED"], "stopIfStealthed")
		addOption(L["MENU_LEAVE_FORM_BEFORE"], "cancelForm")
		if macro.stances then
			addOption(L["MENU_SWITCH_TO"]:format(macro.stances[1]), "stance")
		end
		section()
		addOption(L["MENU_TARGET_NEAREST_ENEMY"], "targetEnemy")
		addOption(L["MENU_TARGET_NEAREST_FRIEND"], "targetFriend")
		if ns.OffersOption(macro, "stopCast") then
			addNote("MENU_STOP_CASTING_NOTE")
		end
		if ns.OffersOption(macro, "stopIfChanneling") or ns.OffersOption(macro, "stopIfStealthed") then
			addNote("MENU_SAFE_TO_SPAM_NOTE")
		end
		group("MENU_GROUP_ADD_ATTACK")
		addOption(L["MENU_START_AUTO_ATTACK"], "startAttack")
		if ns.AutoShotLabelKey() then
			addOption(L[ns.AutoShotLabelKey()], "autoShot")
		end
		addOption(L["MENU_START_PET_ATTACK"], "petAttack")
		group("MENU_GROUP_CASTING_RULES")
		if macro.petAbility then
			addOption(L["MENU_CAST_IF_SUMMONED"]:format(macro.petAbility), "pet")
		end
		if macro.groupSpell then
			addOption(L["MENU_RIGHT_CLICK_FOR"]:format(macro.groupSpell), "groupVersion")
		end
		addOption(L["MENU_ONCE_PER_TARGET"], "oncePerTarget")
		addOption(L["MENU_ONCE_PER_COMBAT"], "oncePerCombat")
		addOption(L["MENU_NEVER_TURN_OFF"], "noToggle")
		if ns.OffersOption(macro, "noToggle") then
			addNote("OPTIONS_DEFAULT_NEVER_TURN_OFF_DESCRIPTION")
		end
		group("MENU_GROUP_ERRORS")
		addOption(L["MENU_HIDE_ERRORS"], "hideErrors")
		addOption(L["MENU_MUTE_ERRORS"], "muteErrors")
		group("MENU_GROUP_USE_ITEMS_FIRST")
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
					local function isOn()
						return ns.IsUsingSlot(macro, slot) ~= nil
					end
					track(ns.SlotLabel(slot), isOn)
					-- the label carries the slot's place in the order, set each time the menu redraws
					menu:CreateCheckbox(ns.SlotLabel(slot), isOn, function()
						ns.ToggleUseSlot(macro, slot)
						ns.RefreshSpellbookPage(button:GetParent()) -- rewrites the focus copy too
					end):AddInitializer(function(frame)
						local at = ns.IsUsingSlot(macro, slot)
						frame.fontString:SetTextToFit(ns.SlotLabel(slot) .. (at and " (" .. at .. ")" or ""))
					end)
				end
			end
		end
		-- makes this macro's options its kind's defaults, then shows them on the Macro Defaults panel
		local kindRow
		for _, row in ipairs(ns.MACRO_KINDS) do
			if row.key == macro.kind then
				kindRow = row
			end
		end
		if kindRow then
			rootDescription:CreateDivider()
			local label = L["MENU_USE_FOR_KIND"]:format(L[kindRow.labelKey])
			local element = rootDescription:CreateButton(label, function()
				-- read every value before any default changes, since changing a default moves every option that follows it
				local values = {}
				for _, key in ipairs(ns.DEFAULTABLE_OPTIONS) do
					if ns.OffersOption(macro, key) then
						values[key] = ns.IsOptionOn(macro, key)
					end
				end
				for key, on in pairs(values) do
					ns.SetKindDefault(macro.kind, key, on)
					ns.SpellSettings(key)[ns.SettingsKey(macro)] = nil -- now the same as the default
				end
				ns:RefreshMacros()
				AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.MacroDefaults)
				-- the Classic engine's window sits on the HIGH strata, so it would cover the Options Interface
				if ns.HideSpellbookWindow and not InCombatLockdown() then
					ns.HideSpellbookWindow()
				end
				ns:OpenOptionsPanel("MacroDefaults")
			end)
			if element.SetTooltip then
				element:SetTooltip(function(tooltip)
					tooltip:SetText(label, 1, 0.82, 0, 1, true)
					tooltip:AddLine(L["MENU_USE_FOR_KIND_DESCRIPTION"]:format(L[kindRow.labelKey]), 1, 1, 1, true)
				end)
			end
		end
		--[[
			Duplicate adds another copy of this spell's macro to the page, with this macro's options to start from;
			a copy can also be removed. Either redraws the page and closes the menu.
		]]
		if ns.OffersDuplicate(macro) then
			rootDescription:CreateDivider()
			rootDescription:CreateButton(L["MENU_DUPLICATE"], function()
				ns.DuplicateMacro(macro)
				ns.RefreshSpellbookPage(button:GetParent())
			end)
			if macro.copy then
				rootDescription:CreateButton(L["MENU_REMOVE_COPY"], function()
					ns.RemoveMacroCopy(macro)
					ns.RefreshSpellbookPage(button:GetParent())
				end)
			end
		end
		-- the macro text as it stands, read each time the menu redraws so a ticked option shows at once
		rootDescription:CreateDivider()
		rootDescription:CreateTitle(MacroLengthLine(macro)):AddInitializer(function(frame)
			frame.fontString:SetTextToFit(MacroLengthLine(macro))
		end)
		rootDescription:CreateDivider()
		--[[
			the lines as one block, sized to the widest line and the line count; the menu lays itself out again
			after every change, taking each element's size from its initializer, so the block grows and shrinks
		]]
		rootDescription:CreateTitle(""):AddInitializer(function(frame)
			local fontString, lines, width = frame.fontString, BodyLines(macro), 1
			for _, line in ipairs(lines) do
				fontString:SetText(line)
				width = math.max(width, fontString:GetUnboundedStringWidth())
			end
			return TextBlock(fontString, GetColor("TEXT") .. table.concat(lines, "\n") .. "|r", width)
		end)
	end)
end
