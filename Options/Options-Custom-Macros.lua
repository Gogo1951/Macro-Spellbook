local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--------------------------------------------------------------------------------
-- Custom Macros Panel
--------------------------------------------------------------------------------

-- Redraws the panel, then the open page, or rewrites the macros the add-on made when no page is open.
local function Changed()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.CustomMacros)
	ns:RefreshMacros()
end

--[[
	A red line saying why the custom macro at index can't go on the page, or nil when it can. Shown only then,
	so it is a status line, not helper text.
]]
local STATUS_KEYS = {
	needs = "OPTIONS_CUSTOM_STATUS_NEEDS",
	long = "OPTIONS_CUSTOM_STATUS_TOO_LONG",
	taken = "OPTIONS_CUSTOM_STATUS_TAKEN",
}

local function StatusText(index, entry)
	local problem, length = ns.CustomMacroProblem(entry, ns.CustomMacroTakenNames(index))
	if not problem then
		return nil
	end
	return GetColor("OFF") .. L[STATUS_KEYS[problem]]:format(length, ns.MACRO_BODY_MAX_LENGTH) .. "|r"
end

--[[
	Where a custom macro can be listed: under Custom (""), or with the spells of one of the spellbook's tabs,
	in the book's order, plus the entry's own section when it no longer names a tab, so it still shows. The
	tab names are the client's own. Returns the select's values and their order.
]]
local function SectionChoices(entry)
	if #ns.macros == 0 then
		ns.CollectMacros()
	end
	local values, sorting, tabs = { [""] = L["SECTION_CUSTOM"] }, { "" }, {}
	for name, rank in pairs(ns.ClassConfig().categoryRankByName) do
		tabs[#tabs + 1] = { name = name, rank = rank }
	end
	table.sort(tabs, function(a, b)
		return a.rank < b.rank
	end)
	for _, tab in ipairs(tabs) do
		values[tab.name], sorting[#sorting + 1] = tab.name, tab.name
	end
	if entry.category and not values[entry.category] then
		values[entry.category], sorting[#sorting + 1] = entry.category, entry.category
	end
	return values, sorting
end

--[[
	The player's custom macros, one inline group each: its name, the page section it is listed in, its body
	and, when it can't go on the page, why. A builder function, so the rows are the list itself and redraw on every change. Removing
	one loses what the player typed, so it confirms; Restore Defaults puts back the class's starting set.
]]
local function MacroRow(index, entry, order)
	return {
		type = "group",
		name = "",
		inline = true,
		order = order,
		args = {
			nameLabel = ns.OptionsRowLabel(L["OPTIONS_CUSTOM_NAME"], 1),
			name = {
				type = "input",
				name = "",
				desc = L["OPTIONS_CUSTOM_NAME_DESCRIPTION"]:format(ns.MACRO_NAME_MAX_LENGTH),
				width = ns.OPTIONS_CONTROL_WIDTH - ns.OPTIONS_REMOVE_ICON_WIDTH,
				order = 2,
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
				desc = L["OPTIONS_CUSTOM_REMOVE_DESCRIPTION"],
				image = "Interface/Buttons/UI-GroupLoot-Pass-Up",
				imageWidth = 16,
				imageHeight = 16,
				width = ns.OPTIONS_REMOVE_ICON_WIDTH,
				order = 3,
				confirm = true,
				confirmText = L["OPTIONS_CUSTOM_REMOVE_CONFIRM"],
				func = function()
					table.remove(ns.db.profile.customMacros, index)
					Changed()
				end,
			},
			section = {
				type = "group",
				name = "",
				inline = true,
				order = 4,
				args = {
					label = ns.OptionsRowLabel(L["OPTIONS_CUSTOM_SECTION"], 1),
					select = {
						type = "select",
						name = "",
						desc = L["OPTIONS_CUSTOM_SECTION_DESCRIPTION"],
						width = ns.OPTIONS_CONTROL_WIDTH,
						order = 2,
						values = function()
							return (SectionChoices(entry))
						end,
						sorting = function()
							return select(2, SectionChoices(entry))
						end,
						get = function()
							return entry.category or ""
						end,
						set = function(_, value)
							entry.category = value ~= "" and value or nil
							Changed()
						end,
					},
				},
			},
			body = {
				type = "input",
				name = L["MACRO_TEXT"],
				desc = L["OPTIONS_CUSTOM_BODY_DESCRIPTION"],
				multiline = 5,
				width = "full",
				order = 5,
				get = function()
					return entry.body
				end,
				set = function(_, value)
					entry.body = value
					Changed()
				end,
			},
			status = {
				type = "description",
				name = function()
					return StatusText(index, entry) or ""
				end,
				hidden = function()
					return StatusText(index, entry) == nil
				end,
				fontSize = "medium",
				width = "full",
				order = 6,
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
	--[[
		a class whose lists hold no default custom macros has nothing to restore, so Restore Defaults would only
		delete the player's own; it stays while the defaults' names are still loading (nil)
	]]
	local function noDefaults()
		local defaults = ns.DefaultCustomMacros()
		return defaults ~= nil and #defaults == 0
	end
	args.spacerRestore = ns.OptionsSpacer(900, noDefaults)
	args.restore = {
		type = "execute",
		name = L["OPTIONS_CUSTOM_RESTORE"],
		desc = L["OPTIONS_CUSTOM_RESTORE_DESCRIPTION"],
		hidden = noDefaults,
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
