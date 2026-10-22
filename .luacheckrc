std = "lua51"
max_line_length = false
exclude_files = { ".release/", "libs/LibStub/" }

ignore = {
	"212/self", -- unused self argument
	"432/self", -- script handlers shadowing self
}

globals = {
	"MacroSpellbookDB",
	"MacroSpellbookCharDB",
}

read_globals = {
	-- Lua / WoW utility
	"tContains", "wipe",

	-- Namespaces
	"C_Spell", "C_SpellBook", "C_Texture", "C_Timer",
	"C_TooltipInfo", "C_Trainer", "Enum", "EventRegistry", "EventUtil", "InputUtil", "MenuUtil",

	-- Functions
	"CreateFrame", "CreateMacro", "EditMacro", "GetActionInfo", "GetActionText",
	"GetMacroIndexByName", "GetMacroInfo", "GetNumMacros", "GetNumShapeshiftForms",
	"GetNumSpellTabs", "GetNumTrainerServices", "GetShapeshiftFormInfo", "GetSpellBookItemInfo",
	"GetSpellBookItemName", "GetSpellBookItemTexture", "GetSpellTabInfo", "GetSpellTexture",
	"GetTrainerServiceLevelReq", "InCombatLockdown",
	"IsPassiveSpell", "IsTradeskillTrainer", "LibStub", "PickupMacro", "PlaySound", "RunNextFrame",
	"UnitClass", "UnitFactionGroup", "UnitRace",

	-- Frames / objects / constants
	"GameTooltip", "PlayerSpellsFrame", "UIErrorsFrame", "UIParent", "WorldFrame",
	"BOOKTYPE_SPELL", "ERR_NOT_IN_COMBAT", "MAX_ACCOUNT_MACROS", "MAX_CHARACTER_MACROS", "SOUNDKIT",
}
