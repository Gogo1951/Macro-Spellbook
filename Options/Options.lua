local _, ns = ...
local L = ns.L

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

--[[
	Called from ns:OnPlayerLogin once ns.db exists. AddToBlizOptions returns (frame, categoryID); the root's
	category ID is what Settings.OpenToCategory needs, since a title lookup fails wherever the ID is a number.
]]
function ns.RegisterOptionsPanels()
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.General, ns.BuildGeneralOptions())
	local mainPanel, mainCategoryID = AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.General, L["ADDON_TITLE"])
	ns.optionsFrames = { main = mainPanel, categoryID = mainCategoryID }

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.SpellbookPage, ns.BuildSpellbookPageOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.SpellbookPage, L["TAB_SPELLBOOK_PAGE"], L["ADDON_TITLE"])

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.CustomMacros, ns.BuildCustomMacrosOptions)
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.CustomMacros, L["TAB_CUSTOM_MACROS"], L["ADDON_TITLE"])

	local profilesOptions = ns.BuildProfilesOptions()
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Profiles, profilesOptions)
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Profiles, profilesOptions.name, L["ADDON_TITLE"])

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.FeedbackSupport, ns.BuildFeedbackSupportOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.FeedbackSupport, L["OPTIONS_FEEDBACK"], L["ADDON_TITLE"])

	-- A builder function, so the tabs come and go with the enable toggle (see Diagnostics/Options-Diagnostics.lua).
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Diagnostics, ns.BuildDiagnosticsOptions)
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Diagnostics, ns.DiagnosticsStrings.TAB, L["ADDON_TITLE"])
end

--------------------------------------------------------------------------------
-- Opening the Panel
--------------------------------------------------------------------------------

function ns:OpenOptionsPanel()
	if InCombatLockdown() then
		ns:PrintMessage(L["CHAT_OPTIONS_IN_COMBAT"])
		return
	end
	if not ns.optionsFrames then
		return
	end
	if Settings and Settings.OpenToCategory and ns.optionsFrames.categoryID then
		Settings.OpenToCategory(ns.optionsFrames.categoryID)
		return
	end
	AceConfigDialog:Open(ns.OPTIONS_REGISTRY.General)
end

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

SLASH_MACROSPELLBOOK1 = "/msb"
SlashCmdList["MACROSPELLBOOK"] = function()
	ns:OpenOptionsPanel()
end
