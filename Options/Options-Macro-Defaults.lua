local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Macro Defaults Panels
--------------------------------------------------------------------------------

--[[
	The options each kind of macro starts with: the item macros' (ns.ITEM_KIND) on the Macro Defaults panel
	itself, and each spell kind's (ns.MACRO_KINDS) on a sub-panel under it. Each lists a link to the player's
	own spells or items of that kind, then the combat check and how often it casts, then the options under the
	macro menu's group names, leaving out an option none of its macros offers and a group with none left, so it
	lists what that kind's menus do. Each change rewrites the macros that follow it, whether or not a
	page is open.
]]

--[[
	The menu's options a kind can default, in its order, as { label key, { options } }; mirrors
	Features/Macro-Menu.lua. Targeting stands for the checkboxes at the menu's top, and Never Turn Off, also
	there on a form, goes with When's other rules. Who a kind casts on is its target priority, above them.
]]
local MENU_GROUPS = {
	{ "MENU_GROUP_TARGETING", { "cursor" } },
	{ "MENU_GROUP_RANK", { "targetRank" } },
	{ "MENU_GROUP_WHEN", { "stopIfChanneling", "stopIfStealthed", "noToggle" } },
	{ "MENU_GROUP_FIRST", { "stopCast", "stopAttack", "cancelForm", "targetEnemy", "targetFriend" } },
	{ "MENU_GROUP_THEN", { "startAttack", "autoShot", "petAttack" } },
	{ "MENU_GROUP_ERRORS", { "hideErrors", "muteErrors" } },
}

-- Each default option's { menu label, tooltip }. autoShot's label is the class's own (OptionLabel).
local OPTION_STRINGS = {
	cursor = { "MENU_CAST_AT_CURSOR", "OPTIONS_DEFAULT_CURSOR_DESCRIPTION" },
	targetRank = { "MENU_DYNAMIC_RANK", "OPTIONS_DEFAULT_DYNAMIC_RANK_DESCRIPTION" },
	stopAttack = { "MENU_STOP_ATTACK", "OPTIONS_DEFAULT_STOP_ATTACK_DESCRIPTION" },
	stopCast = { "MENU_STOP_CASTING", "OPTIONS_DEFAULT_STOP_CASTING_DESCRIPTION" },
	stopIfChanneling = { "MENU_STOP_IF_CHANNELING", "OPTIONS_DEFAULT_STOP_IF_CHANNELING_DESCRIPTION" },
	stopIfStealthed = { "MENU_STOP_IF_STEALTHED", "OPTIONS_DEFAULT_STOP_IF_STEALTHED_DESCRIPTION" },
	cancelForm = { "MENU_LEAVE_FORM_BEFORE", "OPTIONS_DEFAULT_LEAVE_FORM_DESCRIPTION" },
	targetEnemy = { "MENU_TARGET_NEAREST_ENEMY", "OPTIONS_DEFAULT_TARGET_ENEMY_DESCRIPTION" },
	targetFriend = { "MENU_TARGET_NEAREST_FRIEND", "OPTIONS_DEFAULT_TARGET_FRIEND_DESCRIPTION" },
	startAttack = { "MENU_START_AUTO_ATTACK", "OPTIONS_DEFAULT_START_ATTACK_DESCRIPTION" },
	autoShot = { nil, "OPTIONS_DEFAULT_AUTO_SHOT_DESCRIPTION" },
	petAttack = { "MENU_START_PET_ATTACK", "OPTIONS_DEFAULT_PET_ATTACK_DESCRIPTION" },
	noToggle = { "MENU_NEVER_TURN_OFF", "OPTIONS_DEFAULT_NEVER_TURN_OFF_DESCRIPTION" },
	hideErrors = { "MENU_HIDE_ERRORS", "OPTIONS_DEFAULT_HIDE_ERRORS_DESCRIPTION" },
	muteErrors = { "MENU_MUTE_ERRORS", "OPTIONS_DEFAULT_MUTE_ERRORS_DESCRIPTION" },
}

local EXAMPLES_SHOWN = 6 -- links shown under Your Spells or Your Items before "And N more."

local COMBAT_CHECKS = {
	none = L["MENU_ANY_TIME"],
	combatOnly = L["MENU_IN_COMBAT"],
	noCombat = L["SUBTEXT_NO_COMBAT"],
}

local REPEAT_RULES = {
	none = L["MENU_EVERY_PRESS"],
	oncePerTarget = L["MENU_ONCE_PER_TARGET"],
	oncePerCombat = L["MENU_ONCE_PER_COMBAT"],
}

-- The panel a kind's defaults are set on, by ns.OPTIONS_REGISTRY key: the item kind's is Macro Defaults itself.
function ns.KindPanel(kind)
	if kind == ns.ITEM_KIND.key then
		return "MacroDefaults"
	end
	return "MacroDefaults_" .. kind
end

-- Whether any of the page's macros of a kind offers an option.
local function KindOffers(kind, key)
	for _, macro in ipairs(ns.MacrosOfKind(kind)) do
		if ns.OffersOption(macro, key) then
			return true
		end
	end
	return false
end

local function OptionLabel(key)
	if key == "autoShot" then
		return L[ns.AutoShotLabelKey() or "MENU_START_AUTO_SHOT"]
	end
	return L[OPTION_STRINGS[key][1]]
end

-- A macro's link token for ns.OptionsLink: its spell, or its equipment slot.
local function LinkToken(macro)
	if macro.equipment then
		return "slot:" .. macro.slot
	end
	return macro.spellID and ("spell:" .. macro.spellID) or ""
end

-- The silver caption over a run of controls.
local function Caption(text, order, hidden)
	return {
		type = "description",
		name = GetColor("HELP") .. text .. "|r",
		fontSize = "medium",
		width = "full",
		order = order,
		hidden = hidden,
	}
end

--[[
	Adds a kind's controls to args from order on: a link to each of the player's macros of that kind, the first
	few in page order, then how many more, or a line saying there are none; then the combat check and how often
	it casts, each beside its label; then each menu group's caption over its options, one to a line. A spacer
	closes each run.
]]
local function AddKindControls(args, order, kind, captionKey, noneKey)
	local function count()
		return #ns.MacrosOfKind(kind)
	end
	local function hiddenUnless(key)
		return function()
			return not KindOffers(kind, key)
		end
	end

	args.captionExamples = Caption(L[captionKey], order)
	order = order + 1
	for i = 1, EXAMPLES_SHOWN do
		args["example" .. i] = ns.OptionsLink(order, function()
			local macro = ns.MacrosOfKind(kind)[i]
			return macro and LinkToken(macro) or ""
		end, function()
			return count() < i
		end)
		order = order + 1
	end
	args.examplesMore = Caption("", order, function()
		return count() <= EXAMPLES_SHOWN
	end)
	args.examplesMore.name = function()
		return GetColor("HELP") .. L["OPTIONS_KIND_MORE"]:format(count() - EXAMPLES_SHOWN) .. "|r"
	end
	args.examplesNone = Caption(L[noneKey], order + 1, function()
		return count() > 0
	end)
	args.spacerExamples = ns.OptionsSpacer(order + 2)
	order = order + 3

	-- the combat check and how often it casts are choices of one, as on the macro menu
	local combatHidden = hiddenUnless("combatOnly")
	args.combatLabel = ns.OptionsRowLabel(L["MENU_GROUP_WHEN"], order)
	args.combatLabel.hidden = combatHidden
	args.combat = {
		type = "select",
		name = "",
		desc = L["OPTIONS_DEFAULT_COMBAT_CHECK_DESCRIPTION"],
		width = ns.OPTIONS_CONTROL_WIDTH,
		order = order + 1,
		hidden = combatHidden,
		values = COMBAT_CHECKS,
		sorting = { "none", "combatOnly", "noCombat" },
		get = function()
			if ns.KindDefault(kind, "combatOnly") then
				return "combatOnly"
			end
			return ns.KindDefault(kind, "noCombat") and "noCombat" or "none"
		end,
		set = function(_, value)
			ns.SetKindDefault(kind, "combatOnly", value == "combatOnly")
			ns.SetKindDefault(kind, "noCombat", value == "noCombat")
			ns:RefreshMacros()
		end,
	}
	args.spacerCombat = ns.OptionsSpacer(order + 2, combatHidden)
	order = order + 3

	local repeatHidden = hiddenUnless("oncePerTarget")
	args.repeatLabel = ns.OptionsRowLabel(L["MENU_REPEAT"], order)
	args.repeatLabel.hidden = repeatHidden
	args.repeatRule = {
		type = "select",
		name = "",
		desc = L["OPTIONS_DEFAULT_REPEAT_DESCRIPTION"],
		width = ns.OPTIONS_CONTROL_WIDTH,
		order = order + 1,
		hidden = repeatHidden,
		values = REPEAT_RULES,
		sorting = { "none", "oncePerTarget", "oncePerCombat" },
		get = function()
			if ns.KindDefault(kind, "oncePerCombat") then
				return "oncePerCombat"
			end
			return ns.KindDefault(kind, "oncePerTarget") and "oncePerTarget" or "none"
		end,
		set = function(_, value)
			ns.SetKindDefault(kind, "oncePerCombat", value == "oncePerCombat")
			ns.SetKindDefault(kind, "oncePerTarget", value == "oncePerTarget")
			ns:RefreshMacros()
		end,
	}
	args.spacerRepeat = ns.OptionsSpacer(order + 2, repeatHidden)
	order = order + 3

	--[[
		the target priority, as on the macro menu's Target submenu: each priority lists the units the ones above
		it haven't taken, Second and Third offer None, and a priority waits for the one above it, or never comes
		after Self, since nothing after the player is ever tried
	]]
	if ns.KindOffersTargetPriority(kind) then
		args.captionTarget = Caption(L["MENU_GROUP_TARGET"], order)
		order = order + 1
		for place = 1, ns.TARGET_PRIORITY_SLOTS do
			local function hidden()
				local above = ns.KindTargetPriority(kind)[place - 1]
				return place > 1 and (above == nil or above == "player")
			end
			local function choices()
				local values, sorting, taken = {}, {}, {}
				for i = 1, place - 1 do
					taken[ns.KindTargetPriority(kind)[i] or ""] = true
				end
				if place > 1 then
					values.none, sorting[1] = L["MENU_UNIT_NONE"], "none"
				end
				for _, row in ipairs(ns.TARGET_UNITS) do
					if not taken[row[1]] and ns.KindOffersUnit(kind, row[1]) then
						values[row[1]] = L[row[2]]
						sorting[#sorting + 1] = row[1]
					end
				end
				return values, sorting
			end
			args["priorityLabel" .. place] = ns.OptionsRowLabel(L["MENU_PRIORITY_" .. place], order)
			args["priorityLabel" .. place].hidden = hidden
			args["priority" .. place] = {
				type = "select",
				name = "",
				desc = L["MENU_PRIORITY_DESCRIPTION"],
				width = ns.OPTIONS_CONTROL_WIDTH,
				order = order + 1,
				hidden = hidden,
				values = function()
					return (choices())
				end,
				sorting = function()
					return select(2, choices())
				end,
				get = function()
					return ns.KindTargetPriority(kind)[place] or "none"
				end,
				set = function(_, value)
					ns.SetKindTargetPriorityUnit(kind, place, value ~= "none" and value or nil)
					ns:RefreshMacros()
				end,
			}
			args["prioritySpacer" .. place] = ns.OptionsSpacer(order + 2, hidden)
			order = order + 3
		end
	end

	for index, group in ipairs(MENU_GROUPS) do
		local options = group[2]
		local function groupHidden()
			for _, option in ipairs(options) do
				if KindOffers(kind, option) then
					return false
				end
			end
			return true
		end
		args["caption" .. index] = Caption(L[group[1]], order, groupHidden)
		order = order + 1
		for _, option in ipairs(options) do
			args[option] = {
				type = "toggle",
				name = function()
					return OptionLabel(option)
				end,
				desc = L[OPTION_STRINGS[option][2]],
				width = "full",
				order = order,
				hidden = hiddenUnless(option),
				get = function()
					return ns.KindDefault(kind, option)
				end,
				set = function(_, value)
					ns.SetKindDefault(kind, option, value)
					ns:RefreshMacros()
				end,
			}
			order = order + 1
		end
		args["spacer" .. index] = ns.OptionsSpacer(order, groupHidden)
		order = order + 1
	end
end

-- The Macro Defaults panel itself, holding the item macros' defaults.
function ns.BuildMacroDefaultsOptions()
	local args = {
		descIntro = ns.OptionsDesc(L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"], 1),
		spacerIntro = ns.OptionsSpacer(2),
		headerItems = ns.OptionsHeader(L[ns.ITEM_KIND.labelKey], 3),
		spacerHeaderItems = ns.OptionsSpacer(4),
		descItems = ns.OptionsDesc(L[ns.ITEM_KIND.descKey], 5),
		spacerDescItems = ns.OptionsSpacer(6),
	}
	AddKindControls(args, 10, ns.ITEM_KIND.key, "OPTIONS_KIND_YOUR_ITEMS", "OPTIONS_KIND_NO_ITEMS")
	return {
		type = "group",
		name = L["TAB_MACRO_DEFAULTS"],
		args = args,
	}
end

-- A spell kind's sub-panel (one of ns.MACRO_KINDS).
function ns.BuildKindDefaultsOptions(kind)
	local args = {
		descIntro = ns.OptionsDesc(L[kind.descKey], 1),
		spacerIntro = ns.OptionsSpacer(2),
	}
	AddKindControls(args, 10, kind.key, "OPTIONS_KIND_YOUR_SPELLS", "OPTIONS_KIND_NO_SPELLS")
	return {
		type = "group",
		name = L[kind.labelKey],
		args = args,
	}
end
