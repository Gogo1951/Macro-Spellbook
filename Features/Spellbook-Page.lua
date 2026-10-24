local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor
local HideTooltip = ns.HideTooltip
local HasTemplate = ns.HasTemplate

--[[
	Lays ns.macros (built by Features/Macro-Builder.lua) out on a spellbook page frame, with the page's
	settings menu and macro slot counts. The host files own the tab and the page frame itself;
	Features/Macro-Button.lua owns each macro's button, Features/Macro-Menu.lua its right-click menu, and
	Features/Spellbook-Paging.lua the page arrows.
]]

--[[
	The page's layout inside its frame. The default is the Retail-engine book (Camelot's
	Blizzard_SpellBookTemplates.xml): each page's spell view is 680 wide, 95 below the book's top, 85 from its
	left (left page) or 50 from its right (right page), and the page frame starts 60 below the book's top. A
	host whose book differs passes its own as page.geometry before the page is built.
]]
local DEFAULT_GEOMETRY = {
	viewWidth = 680,
	viewTop = -35,
	viewLeft = 85,
	viewRight = 50,
	viewBottom = 75,
	columns = 3,
	footerBottom = 46, -- the footer's bottom edge, roughly level with the paging arrows (40 up)
	pagingRight = -75,
	pagingBottom = 40,
	nameFont = "SystemFont_Large",
	subTextFont = "SystemFont_Med1",
}
local CELL_HEIGHT, CATEGORY_GAP = 52, 12

local INK_COLOR = ns.INK_COLOR
local FADED_INK_COLOR = ns.FADED_INK_COLOR

--[[
	The same category bar the native page draws over each skill line, on the Retail-engine book. The Classic
	engine's books have no such template, so their header is the name in the book's own font over a faint
	rule, shaped the same (Text and Backplate) so SetHeader serves both.
]]
local function CreateHeader(parent)
	local width = parent.geometry.viewWidth
	if HasTemplate("SpellBookHeaderTemplate") then
		local header = CreateFrame("Frame", nil, parent, "SpellBookHeaderTemplate")
		header:SetWidth(width)
		header.maxBackplateWidth = width + 85
		return header
	end
	local header = CreateFrame("Frame", nil, parent)
	header:SetSize(width, 24)
	-- the spell names' shadowless font; GameFontNormalLarge's drop shadow reads as bold on parchment
	header.Text = header:CreateFontString(nil, "ARTWORK", parent.geometry.nameFont)
	header.Text:SetPoint("LEFT", 8, 0)
	header.Text:SetTextColor(unpack(INK_COLOR))
	header.Backplate = header:CreateTexture(nil, "BACKGROUND")
	header.Backplate:SetColorTexture(INK_COLOR[1], INK_COLOR[2], INK_COLOR[3], 0.25)
	header.Backplate:SetHeight(1)
	header.Backplate:SetPoint("BOTTOMLEFT", 4, 0)
	header.maxBackplateWidth = width - 8
	return header
end

local function SetHeader(header, text)
	header.Text:SetText(text)
	header.Backplate:SetWidth(math.min(header.maxBackplateWidth, math.max(416, header.Text:GetStringWidth() * 2.5)))
end

-- Acquire hands out pooled frames in order; ReleaseAll hides the ones from the last layout.
local function FramePool(create)
	local pool = { used = 0 }
	function pool:Acquire()
		self.used = self.used + 1
		local frame = self[self.used] or create()
		self[self.used] = frame
		frame:ClearAllPoints()
		frame:Show()
		return frame
	end
	function pool:ReleaseAll()
		for i = 1, #self do
			self[i]:Hide()
		end
		self.used = 0
	end
	return pool
end

--[[
	Splits the macros into page halves of {header = text, y} and {macro, column, y} entries. A category
	flows top to bottom and repeats its header when it carries over to the next half.
]]
local function Paginate(height, headerHeight, columns)
	local halves, half, y = {}, nil, 0
	local function newHalf()
		half, y = {}, 0
		halves[#halves + 1] = half
	end
	local function addHeader(text)
		half[#half + 1] = { header = text, y = y }
		y = y + headerHeight
	end
	newHalf()
	local category, column
	for _, macro in ipairs(ns.macros) do
		if macro.category ~= category then
			category, column = macro.category, 0
			if y > 0 then
				y = y + CELL_HEIGHT + CATEGORY_GAP -- close the previous category's last row
				if y + headerHeight + CELL_HEIGHT > height then
					newHalf()
				end
			end
			addHeader(category)
		elseif column == columns then
			column = 0
			y = y + CELL_HEIGHT
			if y + CELL_HEIGHT > height then
				newHalf()
				addHeader(category)
			end
		end
		half[#half + 1] = { macro = macro, column = column, y = y }
		column = column + 1
	end
	return halves
end

-- Draws the current spread: two pages side by side, or one when the book is minimized.
local function Layout(page)
	local geometry = page.geometry
	local viewWidth, viewTop = geometry.viewWidth, geometry.viewTop
	local cellWidth = viewWidth / geometry.columns
	page.headers:ReleaseAll()
	page.buttons:ReleaseAll()
	local controls = page.pagingControls
	local width, height = page:GetWidth(), page:GetHeight()
	local spread = width >= 2 * viewWidth and 2 or 1
	-- a minimized book shows one page, centred; an open one uses the native left and right pages
	local origins = spread == 2 and { geometry.viewLeft, width - geometry.viewRight - viewWidth }
		or { (width - viewWidth) / 2 }
	page.footer:ClearAllPoints()
	page.footer:SetPoint("BOTTOMLEFT", page, "BOTTOMLEFT", origins[1] + 8, geometry.footerBottom)
	page.footer:SetWidth(viewWidth - 16)
	if #ns.macros == 0 then
		local header = page.headers:Acquire()
		header:SetPoint("TOPLEFT", page, "TOPLEFT", origins[1], viewTop)
		SetHeader(header, L["ADDON_TITLE"])
		page.empty:SetText(L["PAGE_EMPTY"])
		page.empty:ClearAllPoints()
		page.empty:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 8, -12)
		page.empty:SetWidth(viewWidth - 16)
		page.empty:Show()
		controls:Hide()
		return
	end
	page.empty:Hide()

	local headerHeight = math.max(page.headers:Acquire():GetHeight(), 30) + 8
	page.headers:ReleaseAll()

	local halves = Paginate(height + viewTop - geometry.viewBottom, headerHeight, geometry.columns)
	local maxPages = math.ceil(#halves / spread)
	controls:SetMaxPages(maxPages)
	controls:SetShown(maxPages > 1)
	local current = math.min(controls:GetCurrentPage(), maxPages)
	local bars = ns.ScanActionBars()
	for side = 1, spread do
		local x = origins[side]
		for _, entry in ipairs(halves[(current - 1) * spread + side] or {}) do
			if entry.header then
				local header = page.headers:Acquire()
				header:SetPoint("TOPLEFT", page, "TOPLEFT", x, viewTop - entry.y)
				SetHeader(header, entry.header)
			else
				local button = page.buttons:Acquire()
				button:SetPoint("TOPLEFT", page, "TOPLEFT", x + entry.column * cellWidth + 8, viewTop - entry.y - 4)
				ns.SetMacroButton(button, entry.macro, bars)
			end
		end
	end
end

local function Colored(color, text)
	local function byte(channel)
		return math.floor(channel * 255 + 0.5)
	end
	return ("|cff%02x%02x%02x%s|r"):format(byte(color[1]), byte(color[2]), byte(color[3]), text)
end

local function SlotCount(label, used, max)
	local count = used .. "/" .. max
	count = used >= max and GetColor("OFF") .. count .. "|r" or Colored(INK_COLOR, count)
	return Colored(FADED_INK_COLOR, label) .. " " .. count
end

--[[
	The general and character macro slots used, beside the settings menu: "Macro Slots" and the counts in ink,
	the list names faded between them, and a full list's count in the palette's OFF red.
]]
local function UpdateMacroCount(page)
	local numAccount, maxAccount, numCharacter, maxCharacter = ns.MacroCounts()
	page.macroCount:SetText(
		L["PAGE_MACRO_SLOTS"]
			.. "     "
			.. SlotCount(L["PAGE_MACRO_GENERAL"], numAccount, maxAccount)
			.. "   "
			.. SlotCount(L["PAGE_MACRO_CHARACTER"], numCharacter, maxCharacter)
	)
end

-- Rebuilds the list from the spellbook and the class lists, updates changed macros, then redraws.
local function Refresh(page)
	ns.CollectMacros()
	ns.SyncAllMacros()
	Layout(page)
	UpdateMacroCount(page)
end

local pages = {} -- every page built, so a settings change can redraw the open one

--[[
	Gives a settings menu entry the explanation its Options Interface control shows, as AceConfig shows it: the
	label as a gold title, then a white line. Builds whose menus can't take a tooltip show the entry bare.
]]
local function AddMenuTooltip(element, labelKey, descKey)
	if not element.SetTooltip then
		return
	end
	element:SetTooltip(function(tooltip)
		tooltip:SetText(L[labelKey], 1, 0.82, 0, 1, true)
		tooltip:AddLine(L[descKey], 1, 1, 1, true)
	end)
end

local function BuildPage(page)
	pages[#pages + 1] = page
	page.geometry = page.geometry or DEFAULT_GEOMETRY
	page.headers = FramePool(function()
		return CreateHeader(page)
	end)
	page.buttons = FramePool(function()
		return ns.CreateMacroButton(page)
	end)

	page.empty = page:CreateFontString(nil, "OVERLAY", "SystemFont_Med3")
	page.empty:SetTextColor(unpack(INK_COLOR))
	page.empty:SetJustifyH("LEFT")
	page.empty:SetWordWrap(true)

	-- usage hint along the bottom of the left page, level with the paging arrows; Layout places it
	page.footer = page:CreateFontString(nil, "OVERLAY", "SystemFont_Med1")
	page.footer:SetTextColor(unpack(FADED_INK_COLOR))
	page.footer:SetJustifyH("LEFT")
	page.footer:SetText(L["PAGE_FOOTER"])

	local function SetupSettingsMenu(_, rootDescription)
		rootDescription:CreateTitle(SETTINGS)
		if ns.ForEachUnlearnedSpell then
			AddMenuTooltip(
				rootDescription:CreateCheckbox(L["SETTINGS_SHOW_UNLEARNED"], ns.ShowsUnlearned, function()
					ns.SetShowUnlearned(not ns.ShowsUnlearned())
					page.pagingControls:SetCurrentPage(1)
					Refresh(page)
				end),
				"SETTINGS_SHOW_UNLEARNED",
				"OPTIONS_SHOW_UNLEARNED_DESCRIPTION"
			)
		end
		AddMenuTooltip(
			rootDescription:CreateCheckbox(L["SETTINGS_COUNT_SPELLS_ON_BARS"], ns.CountsSpellsOnBars, function()
				ns.SetCountSpellsOnBars(not ns.CountsSpellsOnBars())
				Layout(page)
			end),
			"SETTINGS_COUNT_SPELLS_ON_BARS",
			"OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION"
		)
		rootDescription:CreateDivider()
		AddMenuTooltip(
			rootDescription:CreateButton(L["SETTINGS_MARK_ALL_PLACED"], function()
				ns.MarkAllPlaced()
				ns:OnActionbarSlotChanged() -- redraws the glows
			end),
			"SETTINGS_MARK_ALL_PLACED",
			"SETTINGS_MARK_ALL_PLACED_DESCRIPTION"
		)
		if ns.HasPlacedMarks() then
			AddMenuTooltip(
				rootDescription:CreateButton(L["SETTINGS_CLEAR_PLACED"], function()
					ns.ClearPlacedMarks()
					ns:OnActionbarSlotChanged() -- redraws the glows
				end),
				"SETTINGS_CLEAR_PLACED",
				"SETTINGS_CLEAR_PLACED_DESCRIPTION"
			)
		end
		rootDescription:CreateDivider()
		-- the panels the page leads to, each opened directly: { ns.OPTIONS_REGISTRY key, label key, desc key }
		for _, panel in ipairs({
			{ "MacroDefaults", "TAB_MACRO_DEFAULTS", "SETTINGS_OPEN_MACRO_DEFAULTS_DESCRIPTION" },
			{ "CustomMacros", "TAB_CUSTOM_MACROS", "SETTINGS_OPEN_CUSTOM_MACROS_DESCRIPTION" },
		}) do
			AddMenuTooltip(
				rootDescription:CreateButton(L[panel[2]], function()
					-- the Classic engine's window sits on the HIGH strata, so it would cover the Options Interface
					if ns.HideSpellbookWindow and not InCombatLockdown() then
						ns.HideSpellbookWindow()
					end
					ns:OpenOptionsPanel(panel[1])
				end),
				panel[2],
				panel[3]
			)
		end
	end

	--[[
		The page-wide settings menu. On the Retail-engine book it is the native settings cog, laid over the
		native one in the toolbar; the Classic engine's books have no cog, so a gear button at the page's top
		right opens the same menu.
	]]
	if page.header and HasTemplate("SpellBookSettingsDropdownTemplate") then
		local options = CreateFrame("DropdownButton", nil, page.header, "SpellBookSettingsDropdownTemplate")
		page.options = options
		options:ClearAllPoints()
		options:SetPoint("TOPRIGHT", page.header, "TOPRIGHT", -30, -27)
		options:SetupMenu(SetupSettingsMenu)
	else
		local options = CreateFrame("Button", nil, page)
		page.options = options
		options:SetSize(20, 20)
		options:SetPoint("TOPRIGHT", page, "TOPRIGHT", -6, -6)
		options:SetNormalTexture("Interface\\Buttons\\UI-OptionsButton")
		options:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
		options:SetScript("OnClick", function(self)
			MenuUtil.CreateContextMenu(self, SetupSettingsMenu)
		end)
	end

	--[[
		The macro slot counts: left of the gear on the Classic engine's books. On the Retail engine's the native
		search box sits left of the cog, so they go at the page's top right, just under the cog.
	]]
	page.macroCount = page:CreateFontString(nil, "OVERLAY", "SystemFont_Med1")
	page.macroCount:SetJustifyH("RIGHT")
	page.macroCount:SetTextColor(unpack(INK_COLOR)) -- "Macro Slots"; UpdateMacroCount colours the rest
	if page.options:GetParent() == page.header then
		page.macroCount:SetPoint("TOPRIGHT", page, "TOPRIGHT", -30, -8)
	else
		page.macroCount:SetPoint("RIGHT", page.options, "LEFT", -6, 0)
	end
	-- a font string takes no hover, so a frame over the counts carries its tooltip, above the macro buttons
	local slotsHover = CreateFrame("Frame", nil, page)
	slotsHover:SetAllPoints(page.macroCount)
	slotsHover:SetFrameLevel(page:GetFrameLevel() + 10)
	slotsHover:EnableMouse(true)
	slotsHover:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
		GameTooltip:SetText(L["PAGE_MACRO_SLOTS"], 1, 0.82, 0, 1, true)
		GameTooltip:AddLine(L["TOOLTIP_MACRO_SLOTS"], 1, 1, 1, true)
		GameTooltip:Show()
	end)
	slotsHover:SetScript("OnLeave", HideTooltip)
	slotsHover:SetScript("OnHide", HideTooltip)

	local controls = ns.CreatePagingControls(page)
	page.pagingControls = controls
	controls:SetPoint("BOTTOMRIGHT", page, "BOTTOMRIGHT", page.geometry.pagingRight, page.geometry.pagingBottom)
	function page:OnPageChanged()
		Layout(self)
	end
	page:EnableMouseWheel(true)
	page:SetScript("OnMouseWheel", function(_, delta)
		if controls:IsShown() then
			controls:OnMouseWheel(delta)
		end
	end)

	page:SetScript("OnSizeChanged", function(self)
		if self:IsVisible() then
			Layout(self)
		end
	end)
end

ns.BuildSpellbookPage = BuildPage
ns.RefreshSpellbookPage = Refresh

--[[
	Redraws whichever page is open, after a change made outside it (the options panel, a profile change).
	Returns whether a page was open.
]]
function ns:RefreshOpenPages()
	local refreshed = false
	for _, page in ipairs(pages) do
		if page:IsVisible() then
			Refresh(page)
			refreshed = true
		end
	end
	return refreshed
end

--[[
	Brings the macros the add-on made in step with a change made outside the page, whether or not a page is
	open. In combat the rewrite waits for combat to end (ns.SyncAllMacros).
]]
function ns:RefreshMacros()
	if ns:RefreshOpenPages() then
		return
	end
	ns.CollectMacros()
	ns.SyncAllMacros()
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

--[[
	A learned spell or the gear worn changes the page's list; redraw the open page, once per burst, since
	SPELLS_CHANGED fires several times in a row. With no page open, the list is dropped, so the targetRank
	macros rebuild it, new ranks and all, before their next rewrite.
]]
local spellsPending = false

local function RefreshForSpells()
	spellsPending = false
	if not ns:RefreshOpenPages() then
		wipe(ns.macros)
	end
end

function ns:OnSpellsChanged()
	if not spellsPending then
		spellsPending = true
		C_Timer.After(0, RefreshForSpells)
	end
end

function ns:OnPlayerEquipmentChanged()
	ns:InvalidateUsableSlots()
	ns:RefreshOpenPages()
end

--[[
	Unlearned spells and unlearned ranks whose names weren't loaded were skipped; redraw once a burst of them
	arrives. It can fire before PLAYER_LOGIN creates the database.
]]
local refreshPending = false

function ns:OnSpellDataLoadResult(spellID)
	local pendingRank = ns.TakePendingRank(spellID)
	if not ns.db or not (pendingRank or ns.ShowsUnlearned()) or refreshPending then
		return
	end
	refreshPending = true
	C_Timer.After(0, function()
		refreshPending = false
		ns:RefreshOpenPages()
	end)
end

-- Placing or removing an action only changes the glows; redraw them once per burst.
local glowsPending = false

local function RedrawGlows()
	glowsPending = false
	local bars
	for _, page in ipairs(pages) do
		if page:IsVisible() then
			bars = bars or ns.ScanActionBars()
			for i = 1, page.buttons.used do
				ns.UpdateMacroGlow(page.buttons[i], bars)
			end
		end
	end
end

function ns:OnActionbarSlotChanged()
	if not glowsPending then
		glowsPending = true
		C_Timer.After(0, RedrawGlows)
	end
end

--[[
	A macro made, renamed or deleted, here or in the macro window, changes the slot counts and the glows;
	redraw the open page's buttons once per burst, since syncing fires one per macro.
]]
local macrosPending = false

local function RedrawButtons()
	macrosPending = false
	for _, page in ipairs(pages) do
		if page:IsVisible() then
			local bars = ns.ScanActionBars()
			for i = 1, page.buttons.used do
				ns.SetMacroButton(page.buttons[i], page.buttons[i].macro, bars)
			end
			UpdateMacroCount(page)
		end
	end
end

function ns:OnUpdateMacros()
	if not macrosPending then
		macrosPending = true
		C_Timer.After(0, RedrawButtons)
	end
end
