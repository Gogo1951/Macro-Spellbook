local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Macro Defaults Panel
--------------------------------------------------------------------------------

--[[
	The options each kind of spell macro starts with (ns.MACRO_KINDS), a box per kind with the player's own
	spells of that kind named at its top. A kind the class has no spells of is left out, and so is an option
	none of its spells offers, so each box lists what that kind's right-click menus do. Each change rewrites
	the macros that follow it, whether or not a page is open.
]]

-- The default options in the order the macro menu lists them, by their menu labels.
local OPTION_LABELS = {
	mouseover = "MENU_CAST_ON_MOUSEOVER",
	castOnSelf = "MENU_CAST_ON_SELF",
	targetTarget = "MENU_CAST_ON_TARGETS_TARGET",
	cursor = "MENU_CAST_AT_CURSOR",
	targetRank = "MENU_DYNAMIC_RANK",
	stopCast = "MENU_STOP_CASTING",
	stopAttack = "MENU_STOP_ATTACK",
	cancelForm = "MENU_LEAVE_FORM_BEFORE",
	targetEnemy = "MENU_TARGET_NEAREST_ENEMY",
	petAttack = "MENU_ENABLE_PET_ATTACK",
	startAttack = "MENU_START_AUTO_ATTACK",
	spam = "MENU_SPAMMABLE",
	raidRank1 = "MENU_DOWNRANK_IN_RAIDS",
	oncePerTarget = "MENU_ONCE_PER_TARGET",
	oncePerCombat = "MENU_ONCE_PER_COMBAT",
	noToggle = "MENU_NEVER_TURN_OFF",
	hideErrors = "MENU_HIDE_ERRORS",
	muteErrors = "MENU_MUTE_ERRORS",
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
	return L[OPTION_LABELS[key]]
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
			fontSize = "small",
			order = 2,
		},
		spacer = ns.OptionsSpacer(3),
	}
	local position = 10
	for _, option in ipairs(ns.DEFAULTABLE_OPTIONS) do
		if option ~= "combatOnly" and option ~= "noCombat" then
			position = position + 1
			args[option] = {
				type = "toggle",
				name = function()
					return OptionLabel(option)
				end,
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
	-- the combat check is a choice of one, as on the macro menu
	args.combatCheck = {
		type = "select",
		name = L["MENU_GROUP_COMBAT_CHECK"],
		values = COMBAT_CHECKS,
		sorting = { "none", "combatOnly", "noCombat" },
		order = position + 1,
		hidden = function()
			return not KindOffers(key, "combatOnly")
		end,
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
