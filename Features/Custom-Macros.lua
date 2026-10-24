local _, ns = ...
local L = ns.L

-- The player's custom macros: seeded from the class lists' defaults, then listed on the page as written.

local NO_ENTRIES = {}

-- The icon of the spell named by a leading "#showtooltip <spell>" line, or nil.
local function ShowtooltipIcon(body)
	local spell = body:match("^#showtooltip[ \t]+([^\n]*%S)")
	if spell then
		return C_Spell.GetSpellTexture(spell)
	end
end

-- A custom macro as a page macro. Its body is used as written, then the tag line, and it has no options menu.
local function MakeCustomMacro(entry, index, categoryRank)
	local macro = {
		name = entry.name,
		categoryRank = categoryRank,
		priority = index,
		category = entry.category or L["SECTION_CUSTOM"],
		custom = true,
		cursor = false,
		macroName = ns.TrimMacroName(entry.name),
		macroIcon = entry.icon or ns.ICON_QUESTION_MARK,
		icon = entry.icon or ShowtooltipIcon(entry.body) or ns.ICON_QUESTION_MARK,
	}
	macro.body = ns.TaggedBody(macro, entry.body)
	return macro
end

--[[
	Fills a custom macro template from the class lists: {spell:ID} becomes the client's name for that spell
	and {family:ID} its name for that creature family. Nil while any of them isn't known yet.
]]
function ns.FillMacroTemplate(template)
	local complete = true
	local text = template:gsub("{(%a+):(%d+)}", function(kind, id)
		local name
		if kind == "spell" then
			name = ns.SpellName(tonumber(id))
		elseif kind == "family" then
			local info = C_CreatureInfo.GetCreatureFamilyInfo(tonumber(id))
			name = info and info.name
		end
		complete = complete and name ~= nil
		return name or ""
	end)
	return complete and text or nil
end

-- The class lists' default custom macros, filled in for this client, or nil while a name isn't known yet.
function ns.DefaultCustomMacros()
	local class = select(2, UnitClass("player"))
	local macros = {}
	for _, entry in ipairs((ns.CLASS_SPELL_LISTS[class] or {}).customMacros or NO_ENTRIES) do
		local name = entry.nameKey and L[entry.nameKey] or ns.FillMacroTemplate(entry.name)
		local body = ns.FillMacroTemplate(entry.body)
		if not name or not body then
			return nil
		end
		macros[#macros + 1] = { name = name, body = body, icon = entry.icon }
	end
	return macros
end

-- The player's custom macros, seeded once from the class lists' defaults, as soon as their names are known.
function ns.CustomMacroList()
	local profile = ns.db.profile
	if not profile.customMacrosSeeded then
		local defaults = ns.DefaultCustomMacros()
		if defaults then
			for _, entry in ipairs(defaults) do
				profile.customMacros[#profile.customMacros + 1] = entry
			end
			profile.customMacrosSeeded = true
		end
	end
	return profile.customMacros
end

--[[
	Why a custom entry can't go on the page, or nil when it can: "needs" (no name or no text), "long" with the
	text's length in bytes, the tag line included, or "taken" when taken already holds its trimmed name. The
	page's chat warnings and the Custom Macros panel's status lines both read it.
]]
function ns.CustomMacroProblem(entry, taken)
	local name, body = type(entry) == "table" and entry.name, type(entry) == "table" and entry.body
	if type(name) ~= "string" or name == "" or type(body) ~= "string" or body == "" then
		return "needs"
	end
	local length = #(body:gsub("\n+$", "")) + ns.MACRO_TAG_LENGTH
	if length > ns.MACRO_BODY_MAX_LENGTH then
		return "long", length
	end
	if taken[ns.TrimMacroName(name)] then
		return "taken"
	end
	return nil
end

--[[
	The names the custom entry at index competes with on the page, as ns.AddCustomMacros meets them: the
	learned spells' macros and their focus copies, then the valid custom entries before it.
]]
function ns.CustomMacroTakenNames(index)
	if #ns.macros == 0 then
		ns.CollectMacros()
	end
	local taken = {}
	for _, macro in ipairs(ns.macros) do
		if not macro.custom and not macro.equipment and not macro.unlearned then
			taken[macro.macroName] = true
		end
	end
	local list = ns.CustomMacroList()
	for i = 1, index - 1 do
		if not ns.CustomMacroProblem(list[i], taken) then
			taken[ns.TrimMacroName(list[i].name)] = true
		end
	end
	return taken
end

-- Appends the valid custom entries to ns.macros. taken holds the macro names already in use.
function ns.AddCustomMacros(taken)
	local categoryRanks = {}
	for i, entry in ipairs(ns.CustomMacroList()) do
		local problem, length = ns.CustomMacroProblem(entry, taken)
		if problem == "needs" then
			ns.WarnOnce(L["CHAT_CUSTOM_NEEDS_NAME_BODY"]:format(i))
		elseif problem == "long" then
			ns.WarnOnce(L["CHAT_CUSTOM_TOO_LONG"]:format(entry.name, length, ns.MACRO_BODY_MAX_LENGTH))
		elseif problem == "taken" then
			ns.WarnOnce(L["CHAT_CUSTOM_NAME_TAKEN"]:format(entry.name, ns.MACRO_NAME_MAX_LENGTH))
		else
			taken[ns.TrimMacroName(entry.name)] = true
			local category = entry.category or L["SECTION_CUSTOM"]
			-- a category named after a spellbook tab joins it; others follow the tabs in order of first use
			categoryRanks[category] = categoryRanks[category]
				or ns.ClassConfig().categoryRankByName[category]
				or ns.TAB_SECTION_BASE + i
			ns.macros[#ns.macros + 1] = MakeCustomMacro(entry, i, categoryRanks[category])
		end
	end
end
