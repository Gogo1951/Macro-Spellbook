local _, ns = ...
local L = ns.L

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--------------------------------------------------------------------------------
-- Custom Macros Panel
--------------------------------------------------------------------------------

local MAX_MACRO_NAME = 16 -- WoW's macro name limit

local function Changed()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.CustomMacros)
	ns:RefreshOpenPages()
end

--[[
	The player's custom macros, one inline group each: its name and its body, shown on the page under the
	Custom section. A builder function, so the rows are the list itself and redraw on every change. Removing
	one takes a click to put back, so it confirms; Restore Defaults puts back the class's starting set.
]]
local function MacroRow(index, entry, order)
	return {
		type = "group",
		name = "",
		inline = true,
		order = order,
		args = {
			name = {
				type = "input",
				name = L["OPTIONS_CUSTOM_NAME"],
				desc = L["OPTIONS_CUSTOM_NAME_DESCRIPTION"]:format(MAX_MACRO_NAME),
				width = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_REMOVE_ICON_WIDTH,
				order = 1,
				get = function()
					return entry.name
				end,
				set = function(_, value)
					entry.name = value
					Changed()
				end,
			},
			remove = {
				type = "execute",
				name = "",
				desc = L["OPTIONS_CUSTOM_REMOVE"],
				image = "Interface/Buttons/UI-GroupLoot-Pass-Up",
				imageWidth = 16,
				imageHeight = 16,
				width = ns.OPTIONS_REMOVE_ICON_WIDTH,
				order = 2,
				confirm = true,
				confirmText = L["OPTIONS_CUSTOM_REMOVE_CONFIRM"],
				func = function()
					table.remove(ns.db.profile.customMacros, index)
					Changed()
				end,
			},
			body = {
				type = "input",
				name = L["OPTIONS_CUSTOM_BODY"],
				desc = L["OPTIONS_CUSTOM_BODY_DESCRIPTION"],
				multiline = 5,
				width = "full",
				order = 3,
				get = function()
					return entry.body
				end,
				set = function(_, value)
					entry.body = value
					Changed()
				end,
			},
		},
	}
end

function ns.BuildCustomMacrosOptions()
	local args = {
		descIntro = ns.OptionsDesc(L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"], 1),
		spacerAdd = ns.OptionsSpacer(2),
		add = {
			type = "execute",
			name = L["OPTIONS_CUSTOM_ADD"],
			desc = L["OPTIONS_CUSTOM_ADD_DESCRIPTION"],
			order = 3,
			func = function()
				local list = ns.CustomMacroList()
				list[#list + 1] = { name = L["OPTIONS_CUSTOM_NEW_NAME"], body = "#showtooltip\n" }
				Changed()
			end,
		},
		spacerList = ns.OptionsSpacer(4),
	}
	for index, entry in ipairs(ns.CustomMacroList()) do
		args["macro" .. index] = MacroRow(index, entry, 10 + index)
	end
	args.spacerRestore = ns.OptionsSpacer(900)
	args.restore = {
		type = "execute",
		name = L["OPTIONS_CUSTOM_RESTORE"],
		desc = L["OPTIONS_CUSTOM_RESTORE_DESCRIPTION"],
		order = 901,
		confirm = true,
		confirmText = L["OPTIONS_CUSTOM_RESTORE_CONFIRM"],
		func = function()
			local profile = ns.db.profile
			wipe(profile.customMacros)
			profile.customMacrosSeeded = false
			ns.CustomMacroList()
			Changed()
		end,
	}
	return {
		type = "group",
		name = L["TAB_CUSTOM_MACROS"],
		args = args,
	}
end
