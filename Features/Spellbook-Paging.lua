local _, ns = ...

--[[
	The "Page 1/2" arrows at the book's bottom right, built here rather than from Blizzard's paging template,
	which reads a format string the Classic engine's clients don't define. A click or wheel step that turns
	the page calls page:OnPageChanged(); SetMaxPages and SetCurrentPage never do.
]]
local PAGE_BUTTON_SIZE = 32
local PAGE_PREV_TEXTURE = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage"
local PAGE_NEXT_TEXTURE = "Interface\\Buttons\\UI-SpellbookIcon-NextPage"

local function CreatePageButton(parent, texture)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(PAGE_BUTTON_SIZE, PAGE_BUTTON_SIZE)
	button:SetNormalTexture(texture .. "-Up")
	button:SetPushedTexture(texture .. "-Down")
	button:SetDisabledTexture(texture .. "-Disabled")
	button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	return button
end

function ns.CreatePagingControls(page)
	local controls = CreateFrame("Frame", nil, page)
	controls:SetSize(2 * PAGE_BUTTON_SIZE, PAGE_BUTTON_SIZE)
	local current, maxPages = 1, 1
	local nextButton = CreatePageButton(controls, PAGE_NEXT_TEXTURE)
	nextButton:SetPoint("RIGHT")
	local prevButton = CreatePageButton(controls, PAGE_PREV_TEXTURE)
	prevButton:SetPoint("RIGHT", nextButton, "LEFT")
	controls.PageText = controls:CreateFontString(nil, "OVERLAY", "SystemFont_Med3")
	controls.PageText:SetTextColor(unpack(ns.INK_COLOR))
	controls.PageText:SetPoint("RIGHT", prevButton, "LEFT", -8, 0)

	local function Update()
		controls.PageText:SetText(PAGE_NUMBER:format(current) .. "/" .. maxPages)
		prevButton:SetEnabled(current > 1)
		nextButton:SetEnabled(current < maxPages)
	end

	local function Turn(step)
		local target = math.max(1, math.min(maxPages, current + step))
		if target ~= current then
			current = target
			Update()
			PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN)
			page:OnPageChanged()
		end
	end

	prevButton:SetScript("OnClick", function()
		Turn(-1)
	end)
	nextButton:SetScript("OnClick", function()
		Turn(1)
	end)

	function controls:SetMaxPages(pages)
		maxPages = math.max(1, pages)
		current = math.min(current, maxPages)
		Update()
	end
	function controls:GetMaxPages()
		return maxPages
	end
	function controls:GetCurrentPage()
		return current
	end
	function controls:SetCurrentPage(pageNumber)
		current = math.max(1, math.min(maxPages, pageNumber))
		Update()
	end
	function controls:OnMouseWheel(delta)
		Turn(delta > 0 and -1 or 1)
	end

	Update()
	return controls
end
