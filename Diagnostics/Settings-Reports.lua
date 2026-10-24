local ADDON_NAME, ns = ...

local GetClientHeader = ns.GetDiagnosticClientHeader

--------------------------------------------------------------------------------
-- Display Context
--------------------------------------------------------------------------------

local function FrameLine(label, frame)
	if not frame then
		return string.format("%s: (none)", label)
	end
	local left, bottom, width, height = frame:GetRect()
	return string.format(
		"%s: shown %s, visible %s, rect %s, scale %s, strata %s, level %s",
		label,
		tostring(frame:IsShown()),
		tostring(frame:IsVisible()),
		left and string.format("%.0f,%.0f %.0fx%.0f", left, bottom, width, height) or "unplaced",
		tostring(frame:GetScale()),
		tostring(frame:GetFrameStrata()),
		tostring(frame:GetFrameLevel())
	)
end

--[[
	The Classic-engine host keeps its tab and page to itself, so they are found by shape among UIParent's
	children: the page carries the geometry and frame pools the page builder gives it, the tab the checked
	overlay the host draws.
]]
local function FindClassicFrames()
	local page, tab
	for _, child in ipairs({ UIParent:GetChildren() }) do
		if not child:IsForbidden() then
			if child.geometry and child.buttons and child.headers then
				page = child
			elseif child.checked and child:IsObjectType("Button") and child:GetNumPoints() > 0 then
				local _, relativeTo = child:GetPoint(1)
				if
					relativeTo
					and relativeTo.GetName
					and tostring(relativeTo:GetName()):find("^SpellBookSkillLineTab")
				then
					tab = child
				end
			end
		end
	end
	return page, tab
end

local function PageLines(lines, page)
	if not page then
		return
	end
	local geometry = page.geometry
	lines[#lines + 1] = string.format(
		"  page geometry: view %s wide, %s columns; %s macro cells and %s headers in use",
		tostring(geometry and geometry.viewWidth),
		tostring(geometry and geometry.columns),
		tostring(page.buttons and page.buttons.used),
		tostring(page.headers and page.headers.used)
	)
	local controls = page.pagingControls
	if controls and controls.GetCurrentPage then
		lines[#lines + 1] = string.format(
			"  paging: page %s of %s, arrows shown %s",
			tostring(controls:GetCurrentPage()),
			tostring(controls.GetMaxPages and controls:GetMaxPages()),
			tostring(controls:IsShown())
		)
	end
end

--[[
	Answers "the tab is missing", "the page is off the book" or "the page is cut off" reports: screen size,
	UI scale, and where the spellbook, the page's tab and the page itself sit. Read-only.
]]
function ns:BuildDisplayContextReport()
	local lines = { GetClientHeader(), "" }

	local width, height = GetPhysicalScreenSize()
	lines[#lines + 1] = string.format("Physical screen size: %s x %s", tostring(width), tostring(height))
	lines[#lines + 1] = string.format("UIParent scale: %s", tostring(UIParent and UIParent:GetScale()))
	lines[#lines + 1] = string.format("uiScale CVar: %s", tostring(GetCVar("uiScale")))
	lines[#lines + 1] = ""

	local libSpellBookTabs = LibStub.libs["LibSpellBookTabs-1.0"]
	if libSpellBookTabs then
		local tab = libSpellBookTabs.byId and libSpellBookTabs.byId[ADDON_NAME]
		lines[#lines + 1] = FrameLine("PlayerSpellsFrame", PlayerSpellsFrame)
		lines[#lines + 1] = FrameLine("Spellbook", libSpellBookTabs.book)
		lines[#lines + 1] = FrameLine("Tab", tab and tab.button)
		lines[#lines + 1] = FrameLine("Page", tab and tab.page)
		PageLines(lines, tab and tab.page)
		lines[#lines + 1] = string.format(
			"Gamepad UI (hides the tab): %s",
			tostring(InputUtil and InputUtil.IsGamepadUIEnabled and InputUtil.IsGamepadUIEnabled() or false)
		)
	else
		local page, tab = FindClassicFrames()
		lines[#lines + 1] = FrameLine("SpellBookFrame", SpellBookFrame)
		local shownTabs, index = 0, 1
		while _G["SpellBookSkillLineTab" .. index] do
			if _G["SpellBookSkillLineTab" .. index]:IsShown() then
				shownTabs = shownTabs + 1
			end
			index = index + 1
		end
		lines[#lines + 1] = string.format("Skill line tabs shown: %d of %d", shownTabs, index - 1)
		lines[#lines + 1] = FrameLine("Tab", tab)
		lines[#lines + 1] = FrameLine("Page", page)
		PageLines(lines, page)
	end

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Other Add-ons
--------------------------------------------------------------------------------

function ns:BuildAddOnReport()
	local lines = { GetClientHeader(), "" }
	local count = C_AddOns.GetNumAddOns()
	for index = 1, count do
		local name, _, _, loadable = C_AddOns.GetAddOnInfo(index)
		local version = C_AddOns.GetAddOnMetadata(index, "Version") or "?"
		lines[#lines + 1] = string.format("%s v%s [%s]", name, version, loadable and "loadable" or "disabled")
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Saved Variables
--------------------------------------------------------------------------------

local function DumpTable(value, indent, depth, lines)
	if depth > 8 then
		lines[#lines + 1] = indent .. "<max depth>"
		return
	end
	local keys = {}
	for key in pairs(value) do
		keys[#keys + 1] = key
	end
	table.sort(keys, function(a, b)
		return tostring(a) < tostring(b)
	end)
	for _, key in ipairs(keys) do
		local entry = value[key]
		if type(entry) == "table" then
			lines[#lines + 1] = indent .. tostring(key) .. " = {"
			DumpTable(entry, indent .. "    ", depth + 1, lines)
			lines[#lines + 1] = indent .. "}"
		else
			lines[#lines + 1] = indent .. tostring(key) .. " = " .. tostring(entry)
		end
	end
end

--[[
    Dumps the single AceDB-managed table (profiles, profileKeys, char, global)
    so a player can paste their exact configuration: every setting in each
    profile, and every Protect List and Erase List row in both scopes.
]]
function ns:BuildSavedVariablesReport()
	local lines = { GetClientHeader(), "", ns.SAVED_VARIABLES_NAME .. " = {" }
	DumpTable(_G[ns.SAVED_VARIABLES_NAME] or {}, "    ", 1, lines)
	lines[#lines + 1] = "}"
	return table.concat(lines, "\n")
end
