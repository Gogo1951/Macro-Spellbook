local _, ns = ...
local L = ns.L

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

--[[
	Called from ns:OnPlayerLogin once ns.db exists. AddToBlizOptions returns (frame, categoryID); a category ID
	is what Settings.OpenToCategory needs, since a title lookup fails wherever the ID is a number. The root's is
	kept, and so are those of the panels the page's menus open directly, by ns.OPTIONS_REGISTRY key. Macro
	Defaults' sub-panels, one per spell kind, name it by its category ID: AceConfigDialog maps only a root's
	display name to its ID, while the Settings panel finds a category at any depth by ID.
]]
function ns.RegisterOptionsPanels()
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.General, ns.BuildGeneralOptions())
	local mainPanel, mainCategoryID = AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.General, L["ADDON_TITLE"])
	ns.optionsFrames = { main = mainPanel, categoryID = mainCategoryID, categories = {} }

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.SpellbookPage, ns.BuildSpellbookPageOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.SpellbookPage, L["TAB_SPELLBOOK_PAGE"], L["ADDON_TITLE"])

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.MacroDefaults, ns.BuildMacroDefaultsOptions())
	local _, macroDefaultsID =
		AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.MacroDefaults, L["TAB_MACRO_DEFAULTS"], L["ADDON_TITLE"])
	ns.optionsFrames.categories.MacroDefaults = macroDefaultsID
	for _, kind in ipairs(ns.MACRO_KINDS) do
		local panel = ns.KindPanel(kind.key)
		AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY[panel], ns.BuildKindDefaultsOptions(kind))
		local _, kindID =
			AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY[panel], L[kind.labelKey], macroDefaultsID)
		ns.optionsFrames.categories[panel] = kindID
	end

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.CustomMacros, ns.BuildCustomMacrosOptions)
	local _, customMacrosID =
		AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.CustomMacros, L["TAB_CUSTOM_MACROS"], L["ADDON_TITLE"])
	ns.optionsFrames.categories.CustomMacros = customMacrosID

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

-- Opens the root panel, or the panel named by an ns.OPTIONS_REGISTRY key whose category ID was kept.
function ns:OpenOptionsPanel(panel)
	if InCombatLockdown() then
		ns:PrintMessage(L["CHAT_OPTIONS_IN_COMBAT"])
		return
	end
	if not ns.optionsFrames then
		return
	end
	local categoryID = ns.optionsFrames.categories[panel] or ns.optionsFrames.categoryID
	if Settings and Settings.OpenToCategory and categoryID then
		Settings.OpenToCategory(categoryID)
		return
	end
	AceConfigDialog:Open(ns.OPTIONS_REGISTRY[panel] or ns.OPTIONS_REGISTRY.General)
end

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

SLASH_MACROSPELLBOOK1 = "/msb"
SlashCmdList["MACROSPELLBOOK"] = function()
	ns:OpenOptionsPanel()
end
