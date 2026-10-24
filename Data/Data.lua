local ADDON_NAME, ns = ...
ns.L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

--------------------------------------------------------------------------------
-- Identity
--------------------------------------------------------------------------------

ns.ADDON_TITLE = ns.L["ADDON_TITLE"]
ns.SAVED_VARIABLES_NAME = "MacroSpellbookDB"

--------------------------------------------------------------------------------
-- Links
--------------------------------------------------------------------------------

-- TODO: CurseForge, Wago and the Gogo1951 GitHub link once the master list has this add-on's row.
ns.LINKS = {
	CURSEFORGE = "TBD",
	GITHUB = "https://github.com/notstraws/MacroSpellbook",
	DISCORD = "https://discord.gg/eh8hKq992Q",
	WAGO = "TBD",
}

--------------------------------------------------------------------------------
-- Options Registry
--------------------------------------------------------------------------------

ns.OPTIONS_REGISTRY = {
	General = ADDON_NAME,
	SpellbookPage = ADDON_NAME .. "_SpellbookPage",
	CustomMacros = ADDON_NAME .. "_CustomMacros",
	Profiles = ADDON_NAME .. "_Profiles",
	FeedbackSupport = ADDON_NAME .. "_FeedbackSupport",
	Diagnostics = ADDON_NAME .. "_Diagnostics",
}

--------------------------------------------------------------------------------
-- Options Layout Grid
--------------------------------------------------------------------------------

ns.OPTIONS_ROW_WIDTH = 3.4
ns.OPTIONS_LABEL_WIDTH = 2.1
ns.OPTIONS_CONTROL_WIDTH = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_LABEL_WIDTH
ns.OPTIONS_REMOVE_ICON_WIDTH = 0.25 -- the item lists' remove column, sized to its icon
ns.OPTIONS_SUB_INDENT_WIDTH = 0.115 -- the blank cell a sub-option row leads with

--------------------------------------------------------------------------------
-- Color Palette
--------------------------------------------------------------------------------

ns.PALETTE = {
	TITLE = "FFD100", -- Gold: Titles, Headers, Section Names, Field Titles
	INFO = "00BBFF", -- Blue: Interactions, Toggles, Links, Keybinds, Slash Commands
	BODY = "FFFFFF", -- White: Descriptions, Options Body Text
	HELP = "CCCCCC", -- Silver: Pro Tips, Helper Text
	TEXT = "FFFFFF", -- White: Messages, Values, Spell Names
	ON = "33CC33", -- Green: On
	OFF = "CC3333", -- Red: Off
	SEPARATOR = "AAAAAA", -- Gray: Separators, Dividers
	MUTED = "808080", -- Dark Gray: Meta-data, Version Numbers
}
