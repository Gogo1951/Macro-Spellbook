local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor
local HideTooltip = ns.HideTooltip
local HasTemplate = ns.HasTemplate

--[[
	Hosts the page on the Classic engine (Classic Era, TBC, MoP Classic): a tab under the class's skill line
	tabs down the book's right edge toggles a window of its own holding the page, laid out as a two-page
	spread. Laying the page over the book's spell pages lost to UI skins (ElvUI restyles and
	re-layers the book), so the window stays clear of the book. Both are parented to UIParent and only the
	tab is anchored to the book, so nothing Blizzard owns is written to and the book's own buttons stay
	untainted; native tab clicks are watched with hooksecurefunc.
]]

local ICON_MACRO = ns.ICON_MACRO

--[[
	The window's size and the page layout drawn inside it: two 470 wide, two column pages side by side, with
	even margins since the window has no spine art to clear. A 100% UI is 768 points tall, so this size shows
	unscaled there with the screen margin to spare; smaller UIs still shrink it to fit.
]]
local WINDOW_WIDTH, WINDOW_HEIGHT = 1100, 660
local SCREEN_MARGIN = 40 -- kept clear around the window when it is scaled down to fit
local PAGE_INSETS = { left = 4, top = -24, right = -6, bottom = 6 }
local WINDOW_GEOMETRY = {
	viewWidth = 470,
	viewTop = -35,
	viewLeft = 50,
	viewRight = 50,
	viewBottom = 75,
	columns = 2,
	footerBottom = 46,
	pagingRight = -50,
	pagingBottom = 40,
	nameFont = "SystemFont_Large",
	subTextFont = "SystemFont_Med1",
}

-- Forever's parchment, where this build has it; otherwise a plain parchment colour with a faint spine
local ATLAS_PAGE_LEFT, ATLAS_PAGE_RIGHT = "spellbook-Page-Left-C60", "spellbook-Page-Right-C60"
local PARCHMENT_COLOR = { 0.84, 0.77, 0.62 }
local SPINE_COLOR = { 0.18, 0.106, 0.059, 0.35 }

local TAB_GAP = 17 -- the space the book leaves between its skill line tabs

local book = SpellBookFrame
local tab, window

-- The tab shows only over the book's own spell pages, never the pet book or another tab of it.
local function ShowsSpells()
	return book:IsShown() and (book.bookType == nil or book.bookType == BOOKTYPE_SPELL)
end

local function DrawParchment(page)
	if C_Texture.GetAtlasInfo(ATLAS_PAGE_LEFT) and C_Texture.GetAtlasInfo(ATLAS_PAGE_RIGHT) then
		local left = page:CreateTexture(nil, "BACKGROUND")
		left:SetAtlas(ATLAS_PAGE_LEFT)
		left:SetPoint("TOPLEFT")
		left:SetPoint("BOTTOMRIGHT", page, "BOTTOM")
		local right = page:CreateTexture(nil, "BACKGROUND")
		right:SetAtlas(ATLAS_PAGE_RIGHT)
		right:SetPoint("TOPLEFT", page, "TOP")
		right:SetPoint("BOTTOMRIGHT")
		return
	end
	local base = page:CreateTexture(nil, "BACKGROUND")
	base:SetAllPoints()
	base:SetColorTexture(unpack(PARCHMENT_COLOR))
	local spine = page:CreateTexture(nil, "BACKGROUND", nil, 1)
	spine:SetColorTexture(unpack(SPINE_COLOR))
	spine:SetWidth(2)
	spine:SetPoint("TOP", 0, -12)
	spine:SetPoint("BOTTOM", 0, 12)
end

-- Shrinks the window, never grows it, so the whole spread fits on screen at any resolution or UI scale.
local function FitToScreen()
	local scale = math.min(
		1,
		(UIParent:GetWidth() - 2 * SCREEN_MARGIN) / WINDOW_WIDTH,
		(UIParent:GetHeight() - 2 * SCREEN_MARGIN) / WINDOW_HEIGHT
	)
	window:SetScale(scale)
end

local function SyncTab()
	tab.checked:SetShown(window ~= nil and window:IsShown())
end

local function CreateWindow()
	local template = HasTemplate("PortraitFrameTemplate") and "PortraitFrameTemplate" or "BasicFrameTemplate"
	window = CreateFrame("Frame", "MacroSpellbookFrame", UIParent, template)
	window:Hide()
	window:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT)
	window:SetPoint("CENTER")
	window:SetFrameStrata("HIGH")
	window:SetToplevel(true)
	window:SetClampedToScreen(true)
	window:SetMovable(true)
	window:EnableMouse(true)
	window:RegisterForDrag("LeftButton")
	window:SetScript("OnDragStart", window.StartMoving)
	window:SetScript("OnDragStop", window.StopMovingOrSizing)
	if window.SetTitle then
		window:SetTitle(L["ADDON_TITLE"])
	else
		window.TitleText:SetText(L["ADDON_TITLE"])
	end
	if window.SetPortraitToAsset then
		window:SetPortraitToAsset(ICON_MACRO)
	end
	-- Escape closes it, like the book
	table.insert(UISpecialFrames, window:GetName())
	window:HookScript("OnShow", function()
		FitToScreen()
		PlaySound(SOUNDKIT.IG_SPELLBOOK_OPEN)
		SyncTab()
	end)
	window:HookScript("OnHide", function()
		PlaySound(SOUNDKIT.IG_SPELLBOOK_CLOSE)
		SyncTab()
	end)

	local page = CreateFrame("Frame", nil, window)
	page:SetPoint("TOPLEFT", PAGE_INSETS.left, PAGE_INSETS.top)
	page:SetPoint("BOTTOMRIGHT", PAGE_INSETS.right, PAGE_INSETS.bottom)
	page:SetClipsChildren(true)
	page:EnableMouse(true)
	DrawParchment(page)
	page.geometry = WINDOW_GEOMETRY
	ns.BuildSpellbookPage(page)
	page:SetScript("OnShow", ns.RefreshSpellbookPage)
end

local function ToggleWindow()
	if not window then
		CreateWindow()
	end
	window:SetShown(not window:IsShown())
end

-- The key binding's toggle (Features/Key-Bindings.lua), the same as a click on the tab.
ns.ToggleSpellbookPage = ToggleWindow

--[[
	Closes the window, so it isn't left covering the Options Interface that the page's menus open (Macro
	Defaults, Custom Macros, Use These Options For All).
]]
function ns.HideSpellbookWindow()
	if window then
		window:Hide()
	end
end

--[[
	The skill line tab the page's tab lines up under: the class's last spell tab, so it sits right under the
	class's own tabs. Other add-ons show tabs of their own in the book's spare slots (WhatsTraining takes the
	second to last), and lining up under the last shown tab put ours below theirs, off the bottom of the book.
	Falls back to the last shown tab when the spell tab count doesn't name a shown tab.
]]
local function AnchorSkillLineTab()
	local classLast = GetNumSpellTabs and _G["SpellBookSkillLineTab" .. GetNumSpellTabs()]
	if classLast and classLast:IsShown() then
		return classLast
	end
	local last
	local i = 1
	while _G["SpellBookSkillLineTab" .. i] do
		local skillLineTab = _G["SpellBookSkillLineTab" .. i]
		if skillLineTab:IsShown() then
			last = skillLineTab
		end
		i = i + 1
	end
	return last
end

local function Sync()
	local shown = ShowsSpells()
	tab:SetShown(shown)
	if shown then
		tab:ClearAllPoints()
		local last = AnchorSkillLineTab()
		if last then
			tab:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -TAB_GAP)
		else
			tab:SetPoint(SpellBookSkillLineTab1:GetPoint(1))
		end
		tab:SetFrameStrata(book:GetFrameStrata())
		tab:SetFrameLevel(book:GetFrameLevel() + 30)
	end
	SyncTab()
end

local function CreateTab()
	tab = CreateFrame("Button", nil, UIParent)
	tab:SetSize(32, 32)
	tab:Hide()
	local background = tab:CreateTexture(nil, "BACKGROUND")
	background:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab")
	background:SetSize(64, 64)
	background:SetPoint("TOPLEFT", -3, 11)
	tab:SetNormalTexture(ICON_MACRO)
	tab:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	tab.checked = tab:CreateTexture(nil, "OVERLAY")
	tab.checked:SetTexture("Interface\\Buttons\\CheckButtonHilight")
	tab.checked:SetBlendMode("ADD")
	tab.checked:SetAllPoints()
	tab.checked:Hide()
	tab:SetScript("OnClick", ToggleWindow)
	tab:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["ADDON_TITLE"])
		GameTooltip:AddLine(L["SPELLBOOK_TAB_DESCRIPTION"], 1, 1, 1, true)
		GameTooltip:AddDoubleLine(
			GetColor("INFO") .. L["TOOLTIP_KEY_CLICK"] .. "|r",
			GetColor("INFO") .. L["TOOLTIP_ACTION_OPEN_PAGE"] .. "|r"
		)
		GameTooltip:Show()
	end)
	tab:SetScript("OnLeave", HideTooltip)
	tab:SetScript("OnHide", HideTooltip)
end

CreateTab()
book:HookScript("OnShow", Sync)
book:HookScript("OnHide", Sync)
-- The book's own update runs on every page or book-type change and whenever the skill line tabs change.
if book.Update then
	hooksecurefunc(book, "Update", Sync)
end
