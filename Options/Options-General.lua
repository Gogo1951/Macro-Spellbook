local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

-- The root panel: the pitch, the Welcome Message switch, then /Commands.
function ns.BuildGeneralOptions()
	return {
		type = "group",
		name = L["ADDON_TITLE"],
		args = {
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

			spaceCommands0 = ns.OptionsSpacer(90),
			headerCommands = ns.OptionsHeader(L["OPTIONS_COMMANDS_HEADER"], 91),
			spaceCommands1 = ns.OptionsSpacer(92),
			descCommands = ns.OptionsDesc(
				GetColor("INFO") .. L["OPTIONS_COMMAND"] .. "|r" .. "  " .. L["OPTIONS_COMMAND_DESCRIPTION"],
				93
			),
		},
	}
end
