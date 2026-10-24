local ADDON_NAME, ns = ...

--[[
	Adds the page as a tab of the Retail-engine spellbook (Blizzard_PlayerSpells). LibSpellBookTabs owns the tab,
	its placement and the parchment page.
]]

local ICON_MACRO = "Interface\\MacroFrame\\MacroFrame-Icon" -- the "M" key shown on Blizzard's macro window

local libSpellBookTabs = LibStub("LibSpellBookTabs-1.0")

libSpellBookTabs:RegisterTab(ADDON_NAME, {
	name = ns.L["ADDON_TITLE"],
	icon = ICON_MACRO,
	onCreate = ns.BuildSpellbookPage,
	onShow = ns.RefreshSpellbookPage,
})

--[[
	The key binding's toggle (Features/Key-Bindings.lua): closes the book when it shows the page, else opens
	the spellbook, loading it where it isn't yet, and turns to the page.
]]
function ns.ToggleSpellbookPage()
	if libSpellBookTabs:IsOpen(ADDON_NAME) and PlayerSpellsFrame and PlayerSpellsFrame:IsShown() then
		HideUIPanel(PlayerSpellsFrame)
		return
	end
	if PlayerSpellsUtil and PlayerSpellsUtil.OpenToSpellBookTab then
		PlayerSpellsUtil.OpenToSpellBookTab()
	end
	libSpellBookTabs:Open(ADDON_NAME)
end
