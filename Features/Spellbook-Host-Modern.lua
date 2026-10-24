local ADDON_NAME, ns = ...

--[[
	Adds the page as a tab of the Retail-engine spellbook (Blizzard_PlayerSpells). LibSpellBookTabs owns the tab,
	its placement and the parchment page.
]]

local ICON_MACRO = "Interface\\MacroFrame\\MacroFrame-Icon" -- the "M" key shown on Blizzard's macro window

LibStub("LibSpellBookTabs-1.0"):RegisterTab(ADDON_NAME, {
	name = ns.L["ADDON_TITLE"],
	icon = ICON_MACRO,
	onCreate = ns.BuildSpellbookPage,
	onShow = ns.RefreshSpellbookPage,
})
