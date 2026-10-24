local ADDON_NAME, ns = ...

--[[
	Adds the page as a tab of the Retail-engine spellbook (Blizzard_PlayerSpells). Features/Spellbook-Tabs.lua
	owns the tab, its placement and the parchment page.
]]

local ICON_MACRO = ns.ICON_MACRO

local SpellbookTabs = ns.SpellbookTabs

SpellbookTabs:RegisterTab(ADDON_NAME, {
	name = ns.L["ADDON_TITLE"],
	description = ns.L["SPELLBOOK_TAB_DESCRIPTION"],
	hint = { ns.L["TOOLTIP_KEY_CLICK"], ns.L["TOOLTIP_ACTION_OPEN_PAGE"] },
	icon = ICON_MACRO,
	onCreate = ns.BuildSpellbookPage,
	onShow = ns.RefreshSpellbookPage,
})

--[[
	The key binding's toggle (Features/Key-Bindings.lua): closes the book when it shows the page, else opens
	the spellbook, loading it where it isn't yet, and turns to the page.
]]
function ns.ToggleSpellbookPage()
	if SpellbookTabs:IsOpen(ADDON_NAME) and PlayerSpellsFrame and PlayerSpellsFrame:IsShown() then
		HideUIPanel(PlayerSpellsFrame)
		return
	end
	if PlayerSpellsUtil and PlayerSpellsUtil.OpenToSpellBookTab then
		PlayerSpellsUtil.OpenToSpellBookTab()
	end
	SpellbookTabs:Open(ADDON_NAME)
end
