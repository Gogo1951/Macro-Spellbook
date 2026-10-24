local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

--[[
	A binding cannot be set from an AceConfig panel, so the row shows the key the player bound, or a muted Not
	Bound, and a Set Key button that opens the game's Key Bindings list through ns:OpenKeyBindings
	(Features/Key-Bindings.lua). The binding name comes from Bindings.xml's name attribute; the caption is the
	same BINDING_* string the Key Bindings list prints. ns:OnUpdateBindings repaints this panel when the
	player changes a key.
]]
local KEY_BINDINGS = {
	-- { bindingName, captionKey, descKey }
	{ "MACROSPELLBOOK_TOGGLE", "BINDING_TOGGLE_PAGE", "OPTIONS_KEY_BINDING_TOGGLE_DESCRIPTION" },
}

local KEY_LABEL_WIDTH = 1.9
local KEY_STATUS_WIDTH = 0.85
local KEY_BUTTON_WIDTH = 0.55

local function GetBindingStatus(bindingName)
	local key = GetBindingKey(bindingName)
	if not key then
		return GetColor("MUTED") .. NOT_BOUND .. "|r"
	end
	local text = (GetBindingText and GetBindingText(key)) or key
	return GetColor("TEXT") .. text .. "|r"
end

-- Each binding is its row (caption, key, Set Key), then its description under it.
local function AddKeyBindingRows(args, startOrder)
	local order = startOrder

	for index, entry in ipairs(KEY_BINDINGS) do
		local bindingName, captionKey, descKey = entry[1], entry[2], entry[3]

		if index > 1 then
			args["spacerKeyBinding" .. index] = ns.OptionsSpacer(order)
			order = order + 1
		end

		args["rowKeyBinding" .. index] = {
			type = "group",
			name = "",
			inline = true,
			order = order,
			args = {
				caption = ns.OptionsRowLabel(GetColor("INFO") .. L[captionKey] .. "|r", 1, KEY_LABEL_WIDTH),
				status = {
					type = "description",
					name = function()
						return GetBindingStatus(bindingName)
					end,
					fontSize = "medium",
					width = KEY_STATUS_WIDTH,
					order = 2,
				},
				setKey = {
					type = "execute",
					name = L["OPTIONS_KEY_SET"],
					desc = L["OPTIONS_KEY_SET_DESCRIPTION"],
					width = KEY_BUTTON_WIDTH,
					order = 3,
					func = function()
						ns:OpenKeyBindings()
					end,
				},
			},
		}
		order = order + 1

		args["descKeyBinding" .. index] = ns.OptionsDesc(GetColor("HELP") .. L[descKey] .. "|r", order)
		order = order + 1
	end
end

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

-- The root panel: the pitch, the Welcome Message switch, Key Bindings, then /Commands.
function ns.BuildGeneralOptions()
	local args = {
		descIntro = ns.OptionsDesc(L["OPTIONS_DESCRIPTION"], 1),

		spacerWelcome0 = ns.OptionsSpacer(5),
		toggleWelcome = {
			type = "toggle",
			name = L["OPTIONS_ENABLE_WELCOME"],
			desc = L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"],
			width = "full",
			order = 6,
			get = function()
				return ns.db.global.showWelcome
			end,
			set = function(_, value)
				ns.db.global.showWelcome = value
			end,
		},

		spacerKeyBindings0 = ns.OptionsSpacer(30),
		headerKeyBindings = ns.OptionsHeader(L["OPTIONS_KEY_BINDINGS_HEADER"], 31),
		spacerKeyBindings1 = ns.OptionsSpacer(32),

		spaceCommands0 = ns.OptionsSpacer(90),
		headerCommands = ns.OptionsHeader(L["OPTIONS_COMMANDS_HEADER"], 91),
		spaceCommands1 = ns.OptionsSpacer(92),
		descCommands = ns.OptionsDesc(
			GetColor("INFO") .. L["OPTIONS_COMMAND"] .. "|r" .. "  " .. L["OPTIONS_COMMAND_DESCRIPTION"],
			93
		),
	}

	AddKeyBindingRows(args, 33)

	return {
		type = "group",
		name = L["ADDON_TITLE"],
		args = args,
	}
end
