local _, ns = ...
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Shared Options Helpers
--------------------------------------------------------------------------------

function ns.OptionsHeader(text, order, hidden)
	return { type = "header", name = GetColor("TITLE") .. text .. "|r", order = order, hidden = hidden }
end

function ns.OptionsDesc(text, order)
	return { type = "description", name = text, fontSize = "medium", order = order }
end

function ns.OptionsSpacer(order, hidden)
	return { type = "description", name = " ", order = order, hidden = hidden }
end

function ns.OptionsRowLabel(text, order, width)
	return {
		type = "description",
		name = text,
		fontSize = "medium",
		width = width or ns.OPTIONS_LABEL_WIDTH,
		order = order,
	}
end

--------------------------------------------------------------------------------
-- Link Widget
--------------------------------------------------------------------------------

--[[
	A label that draws a spell or an equipped item as its icon and link, and shows its own tooltip on hover,
	used via dialogControl on a read-only input. AceConfig renders a description as a plain Label, which has
	no mouse scripts and so never shows a tooltip. The option's get returns "spell:<id>" or "slot:<slot>",
	the only thing AceConfig hands a dialogControl, and SetText draws it.
]]
local AceGUI = LibStub("AceGUI-3.0")
local LINK_WIDGET_VERSION = 1
local LINK_ICON_SIZE = 16

-- The icon and link a token draws, or nil for one that names nothing.
local function LinkText(kind, id)
	local icon, link
	if kind == "spell" then
		local name = C_Spell.GetSpellName(id)
		if not name then
			return nil
		end
		icon = C_Spell.GetSpellTexture(id)
		link = "|cff" .. ns.SPELL_LINK_COLOR .. "[" .. name .. "]|r"
	elseif kind == "slot" then
		link = GetInventoryItemLink("player", id)
		if not link then
			return nil
		end
		icon = GetInventoryItemTexture("player", id)
	else
		return nil
	end
	return "|T" .. (icon or ns.ICON_QUESTION_MARK) .. ":" .. LINK_ICON_SIZE .. "|t " .. link
end

local function OnLinkEnter(frame)
	local widget = frame.obj
	if not widget.linkKind then
		return
	end
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	if widget.linkKind == "slot" then
		GameTooltip:SetInventoryItem("player", widget.linkId)
	else
		GameTooltip:SetSpellByID(widget.linkId)
		if GameTooltip:NumLines() == 0 then
			GameTooltip:SetHyperlink("spell:" .. widget.linkId)
		end
	end
	GameTooltip:Show()
end

local function OnLinkLeave(frame)
	ns.HideTooltip(frame)
end

local linkMethods = {}

function linkMethods:OnAcquire()
	self.linkKind, self.linkId = nil, nil
	self:SetHeight(20)
end

function linkMethods:OnRelease()
	self.linkKind, self.linkId = nil, nil
end

function linkMethods:SetText(text)
	local kind, id = (text or ""):match("^(%a+):(%d+)$")
	id = tonumber(id)
	local display = id and LinkText(kind, id)
	if display then
		self.linkKind, self.linkId = kind, id
		self.label:SetText(display)
	else
		self.linkKind, self.linkId = nil, nil
		self.label:SetText("")
	end
end

function linkMethods:GetText()
	return self.linkKind and (self.linkKind .. ":" .. self.linkId) or ""
end

-- AceConfigDialog drives every input control through these; a link is read-only.
function linkMethods:SetLabel() end

function linkMethods:SetMaxLetters() end

function linkMethods:SetDisabled() end

local function LinkWidgetConstructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetHeight(20)
	frame:EnableMouse(true)
	frame:SetScript("OnEnter", OnLinkEnter)
	frame:SetScript("OnLeave", OnLinkLeave)

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	label:SetJustifyH("LEFT")
	label:SetWordWrap(false)
	label:SetPoint("TOPLEFT")
	label:SetPoint("BOTTOMRIGHT")

	local widget = {
		label = label,
		frame = frame,
		type = ns.LINK_WIDGET_TYPE,
	}
	for method, func in pairs(linkMethods) do
		widget[method] = func
	end
	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(ns.LINK_WIDGET_TYPE, LinkWidgetConstructor, LINK_WIDGET_VERSION)

-- A cell drawing a spell or equipped item's link, by a function returning "spell:<id>", "slot:<slot>" or "".
function ns.OptionsLink(order, token, hidden)
	return {
		type = "input",
		name = "",
		dialogControl = ns.LINK_WIDGET_TYPE,
		width = ns.OPTIONS_LINK_WIDTH,
		order = order,
		hidden = hidden,
		get = token,
		set = function() end,
	}
end
