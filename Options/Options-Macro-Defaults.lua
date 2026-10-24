local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Macro Defaults Panel
--------------------------------------------------------------------------------

--[[
	The options each kind of spell macro starts with (ns.MACRO_KINDS), a box per kind with the player's own
	spells of that kind named at its top, then the combat check, then the options under the right-click menu's
	group names. A kind the class has no spells of is left out, and so is an option none of its spells offers,
	and a group caption with none left under it, so each box lists what that kind's right-click menus do. Each
	change rewrites the macros that follow it, whether or not a page is open.
]]

-- The menu's groups after its combat check, in its order, as { label key, { options } }; mirrors Features/Macro-Menu.lua.
local MENU_GROUPS = {
	{ "MENU_GROUP_SPELL_RANK", { "targetRank" } },
	{ "MENU_GROUP_TARGETING", { "mouseover", "castOnSelf", "targetTarget", "cursor" } },
	{
		"MENU_GROUP_BEFORE_CAST",
		{
			"stopAttack",
			"stopCast",
			"stopIfChanneling",
			"stopIfStealthed",
			"cancelForm",
			"targetEnemy",
			"targetFriend",
		},
	},
	{ "MENU_GROUP_ADD_ATTACK", { "startAttack", "autoShot", "petAttack" } },
	{ "MENU_GROUP_CASTING_RULES", { "oncePerTarget", "oncePerCombat", "noToggle" } },
	{ "MENU_GROUP_ERRORS", { "hideErrors", "muteErrors" } },
}

-- Each default option's { menu label, tooltip }. autoShot's label is the class's own (OptionLabel).
local OPTION_STRINGS = {
	mouseover = { "MENU_CAST_ON_MOUSEOVER", "OPTIONS_DEFAULT_MOUSEOVER_DESCRIPTION" },
	castOnSelf = { "MENU_CAST_ON_SELF", "OPTIONS_DEFAULT_CAST_ON_SELF_DESCRIPTION" },
	targetTarget = { "MENU_CAST_ON_TARGETS_TARGET", "OPTIONS_DEFAULT_TARGETS_TARGET_DESCRIPTION" },
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
	oncePerTarget = { "MENU_ONCE_PER_TARGET", "OPTIONS_DEFAULT_ONCE_PER_TARGET_DESCRIPTION" },
	oncePerCombat = { "MENU_ONCE_PER_COMBAT", "OPTIONS_DEFAULT_ONCE_PER_COMBAT_DESCRIPTION" },
	noToggle = { "MENU_NEVER_TURN_OFF", "OPTIONS_DEFAULT_NEVER_TURN_OFF_DESCRIPTION" },
	hideErrors = { "MENU_HIDE_ERRORS", "OPTIONS_DEFAULT_HIDE_ERRORS_DESCRIPTION" },
	muteErrors = { "MENU_MUTE_ERRORS", "OPTIONS_DEFAULT_MUTE_ERRORS_DESCRIPTION" },
}

local EXAMPLES_SHOWN = 6 -- spells named at the top of a kind's box before "and N more"

local COMBAT_CHECKS = {
	none = L["MENU_COMBAT_CHECK_NONE"],
	combatOnly = L["MENU_ONLY_IN_COMBAT"],
	noCombat = L["MENU_NEVER_IN_COMBAT"],
}

-- Whether any of the page's spells of a kind offers an option.
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

-- The player's spells of a kind, the first few by name, in page order.
local function KindExamples(kind)
	local macros, names = ns.MacrosOfKind(kind), {}
	for i = 1, math.min(#macros, EXAMPLES_SHOWN) do
		names[i] = macros[i].name
	end
	local text = table.concat(names, ", ")
	if #macros > EXAMPLES_SHOWN then
		text = L["OPTIONS_KIND_EXAMPLES_MORE"]:format(text, #macros - EXAMPLES_SHOWN)
	end
	return L["OPTIONS_KIND_EXAMPLES"]:format(text)
end

local function KindGroup(kind, order)
	local key = kind.key
	local args = {
		desc = ns.OptionsDesc(L[kind.descKey], 1),
		examples = {
			type = "description",
			name = function()
				return ns.GetColor("HELP") .. KindExamples(key) .. "|r"
			end,
			fontSize = "medium",
			order = 2,
		},
		spacer = ns.OptionsSpacer(3),
	}
	local position = 10
	for index, group in ipairs(MENU_GROUPS) do
		local options = group[2]
		position = position + 1
		args["caption" .. index] = {
			type = "description",
			name = ns.GetColor("HELP") .. L[group[1]] .. "|r",
			fontSize = "medium",
			width = "full",
			order = position,
			hidden = function()
				for _, option in ipairs(options) do
					if KindOffers(key, option) then
						return false
					end
				end
				return true
			end,
		}
		for _, option in ipairs(options) do
			position = position + 1
			args[option] = {
				type = "toggle",
				name = function()
					return OptionLabel(option)
				end,
				desc = L[OPTION_STRINGS[option][2]],
				width = 1.5,
				order = position,
				hidden = function()
					return not KindOffers(key, option)
				end,
				get = function()
					return ns.KindDefault(key, option)
				end,
				set = function(_, value)
					ns.SetKindDefault(key, option, value)
					ns:RefreshMacros()
				end,
			}
		end
	end
	-- the combat check is a choice of one, as on the macro menu, and first, as there
	args.combatCheck = {
		type = "group",
		name = "",
		inline = true,
		order = 4,
		hidden = function()
			return not KindOffers(key, "combatOnly")
		end,
		args = {
			label = ns.OptionsRowLabel(L["MENU_GROUP_COMBAT_CHECK"], 1),
			select = {
				type = "select",
				name = "",
				desc = L["OPTIONS_DEFAULT_COMBAT_CHECK_DESCRIPTION"],
				width = ns.OPTIONS_CONTROL_WIDTH,
				order = 2,
				values = COMBAT_CHECKS,
				sorting = { "none", "combatOnly", "noCombat" },
				get = function()
					if ns.KindDefault(key, "combatOnly") then
						return "combatOnly"
					end
					return ns.KindDefault(key, "noCombat") and "noCombat" or "none"
				end,
				set = function(_, value)
					ns.SetKindDefault(key, "combatOnly", value == "combatOnly")
					ns.SetKindDefault(key, "noCombat", value == "noCombat")
					ns:RefreshMacros()
				end,
			},
		},
	}
	return {
		type = "group",
		inline = true,
		name = L[kind.labelKey],
		order = order,
		hidden = function()
			return #ns.MacrosOfKind(key) == 0
		end,
		args = args,
	}
end

function ns.BuildMacroDefaultsOptions()
	local args = {
		descIntro = ns.OptionsDesc(L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"], 1),
		spacerKinds = ns.OptionsSpacer(2),
	}
	for i, kind in ipairs(ns.MACRO_KINDS) do
		args[kind.key] = KindGroup(kind, 10 + i)
	end
	return {
		type = "group",
		name = L["TAB_MACRO_DEFAULTS"],
		args = args,
	}
end
