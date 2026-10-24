local _, ns = ...

-- Writes a page macro's text from its spell and the options the player turned on (Features/Macro-Options.lua).

--[[
	A macro conditional joining the given conditions (nil or "" ones are skipped) behind the always-present
	spam condition (nil or ""), e.g. "[nochanneling:Drain Life,@mouseover,harm,nodead]". Returns "" when
	there is nothing to check, so a plain cast stays "/cast Name".
]]
local function Condition(spam, ...)
	local parts = {}
	if spam and spam ~= "" then
		parts[1] = spam
	end
	for i = 1, select("#", ...) do
		local c = select(i, ...)
		if c and c ~= "" then
			parts[#parts + 1] = c
		end
	end
	return #parts > 0 and "[" .. table.concat(parts, ",") .. "]" or ""
end

--[[
	A /cast trying each clause in turn. A clause is { condition, unit, spell }: the condition ("" for none)
	joins the always-present condition (nil or "", e.g. the spam option's), and the clause casts its spell,
	or spellFor(unit) without one. Neighbouring clauses that cast the same spell share it
	("[@mouseover,help,nodead][] Name"), and a lone clause with nothing to check drops its brackets, so a plain
	cast stays "/cast Name". With reset ("combat", "target" or both as "combat/target") the line is a
	/castsequence of the spell then nothing, so it casts once until that reset.
]]
local function CastLine(clauses, always, spellFor, reset)
	local groups = {}
	for _, clause in ipairs(clauses) do
		local condition = Condition(always, clause[1])
		local spell = clause[3] or spellFor(clause[2])
		local last = groups[#groups]
		if last and last.spell == spell then
			last.condition = last.condition .. (condition ~= "" and condition or "[]")
		else
			groups[#groups + 1] = { condition = condition, spell = spell }
		end
	end
	local parts = {}
	for i, g in ipairs(groups) do
		parts[i] = (g.condition ~= "" and g.condition .. " " or "")
			.. (reset and "reset=" .. reset .. " " or "")
			.. g.spell
			.. (reset and ", NULL" or "")
	end
	return (reset and "/castsequence " or "/cast ") .. table.concat(parts, "; ")
end

-- The clauses with each one preceded by a copy that also checks extra and casts spell instead.
local function WithVariant(clauses, extra, spell)
	local out = {}
	for _, clause in ipairs(clauses) do
		out[#out + 1] = { clause[1] ~= "" and clause[1] .. "," .. extra or extra, clause[2], spell }
		out[#out + 1] = clause
	end
	return out
end

--[[
	A rank can go on a player at most this many levels below the level it is learned at; lower than that,
	the cast fails with "Target is too low level".
]]
local RANK_LEVEL_GAP = 10

--[[
	The rank text ("Rank 4") the targetRank option casts on unit: the highest known rank its level can
	take, or nil for the highest rank, which a plain cast already picks. A unit that isn't there, or that
	can't be helped, means the cast lands on the player; an unknown level (UnitLevel's -1, a target too far
	above to show) takes the highest rank too.
]]
local function RankFor(ranks, unit)
	if not unit or unit == "player" or not UnitExists(unit) or not UnitCanAssist("player", unit) then
		return nil
	end
	local level = UnitLevel(unit)
	if not level or level <= 0 then
		return nil
	end
	for i, rank in ipairs(ranks) do
		if level >= rank.level - RANK_LEVEL_GAP then
			return i > 1 and rank.text or nil
		end
	end
	return ranks[#ranks].text -- too low for any rank; the lowest fails with the game's own message
end

-- The body MacroBody gives a spell macro with no options on, which does just what the plain spell does.
function ns.BareBody(name)
	return "#showtooltip\n/cast " .. name
end

--[[
	A stance's slot on the stance bar (the n of [stance:n]), or nil when unknown. A Warrior stance not learned
	yet takes its slot from the class lists' stanceSlots, the order they are learned in.
]]
local function StanceSlot(stance)
	for i = 1, GetNumShapeshiftForms() do
		local spellID = select(4, GetShapeshiftFormInfo(i))
		if spellID and C_Spell.GetSpellName(spellID) == stance then
			return i
		end
	end
	return ns.ClassConfig().stanceSlots[stance]
end

--[[
	A line switching to the first of a spell's stances unless already in one of them, e.g.
	"/cast [nostance:1/3] Battle Stance\n", or "" when the first stance's slot is unknown.
]]
local function StanceLine(stances)
	if not StanceSlot(stances[1]) then
		return ""
	end
	local slots = {}
	for _, stance in ipairs(stances) do
		slots[#slots + 1] = StanceSlot(stance)
	end
	return "/cast [nostance:" .. table.concat(slots, "/") .. "] " .. stances[1] .. "\n"
end

-- The stances a stance-using class can be in: the Warrior stances and whatever is on the stance bar.
local function KnownStances()
	local stanceSlots = ns.ClassConfig().stanceSlots
	local names = {}
	for name in pairs(stanceSlots) do
		names[#names + 1] = name
	end
	for i = 1, GetNumShapeshiftForms() do
		local spellID = select(4, GetShapeshiftFormInfo(i))
		local name = spellID and C_Spell.GetSpellName(spellID)
		if name and not stanceSlots[name] then
			names[#names + 1] = name
		end
	end
	return names
end

--[[
	The client's "Requires %s" tooltip line (SPELL_REQUIRED_FORM) as a pattern capturing what it requires, so
	the stance check reads the same line in every locale.
]]
local REQUIRED_FORM_PATTERN = "^"
	.. (SPELL_REQUIRED_FORM:gsub("[%^%$%(%)%.%[%]%*%+%-%?]", "%%%0"):gsub("%%s", "(.+)"))
	.. "$"

-- The text of a spell's tooltip lines, left and right.
local function TooltipLines(id)
	return ns.ScanTooltipLines("GetSpellByID", "SetSpellByID", id)
end

--[[
	The stances a spell's tooltip says it requires ("Requires Battle Stance, Defensive Stance"), in the
	tooltip's order, or nil when it names none or isn't loaded.
]]
local function TooltipStances(id)
	for _, text in ipairs(TooltipLines(id)) do
		local required = type(text) == "string" and text:match(REQUIRED_FORM_PATTERN)
		if required then
			local found = {}
			for _, stance in ipairs(KnownStances()) do
				local at = required:find(stance, 1, true)
				if at then
					found[#found + 1] = { stance = stance, at = at }
				end
			end
			if #found > 0 then
				table.sort(found, function(a, b)
					return a.at < b.at
				end)
				local stances = {}
				for i, f in ipairs(found) do
					stances[i] = f.stance
				end
				return stances
			end
		end
	end
end

--[[
	The stances a spell can be cast in, the one to switch to first, or nil for a spell that needs none. The
	class lists' stances come first; the tooltip only covers a spell they leave out, since it prints the
	stances' form names, which esES names differently from the stance spells on Classic Era and Forever.
]]
function ns.StancesOf(name, id)
	local c = ns.ClassConfig()
	if not c.hasStances then
		return nil
	end
	return c.stances[name] or (id and TooltipStances(id))
end

local function CastBody(macro)
	--[[
		The lines, in the order written: muteErrors' mute; stopCast's /stopcasting (held off during this
		spell's own channel when spam is on); stopAttack's /stopattack; cancelForm's /cancelform;
		targetEnemy's /targetenemy, for when there is no living hostile target; the useItems slots, in the
		order ticked; petAttack's /petattack; the stance switch; then the cast. Spam adds
		[nochanneling:<spell>] (or [nostealth]) to every cast clause, so a press can't restart a channel or
		cancel stealth, and the combat check adds [combat] or [nocombat] the same way. oncePerCombat makes the
		cast a /castsequence that casts once until combat ends or the target changes, oncePerTarget one that
		casts once until the target changes. With items, a stance switch or a cast sequence, #showtooltip
		names the spell so the button shows the spell.
	]]
	local spam = ns.IsOptionOn(macro, "spam") and macro.spam or nil
	local always = spam
	local combatCheck = ns.CombatCheck(macro)
	if combatCheck then
		always = (spam and spam .. "," or "") .. (combatCheck == "combatOnly" and "combat" or "nocombat")
	end
	-- oncePerCombat also resets when the target changes, so a new pull mid-combat can take the cast again
	local perCombat = ns.IsOptionOn(macro, "oncePerCombat")
	local perTarget = perCombat or ns.IsOptionOn(macro, "oncePerTarget")
	local reset = perCombat and "combat/target" or perTarget and "target" or nil
	local stopCast = ns.IsOptionOn(macro, "stopCast") and "/stopcasting" .. (spam and " [" .. spam .. "]" or "") .. "\n"
	local useLines = {}
	for i, slot in ipairs(ns.UseItemSlots(macro)) do
		useLines[i] = "/use " .. slot .. "\n"
	end
	local use = table.concat(useLines)
	local stance = ns.IsOptionOn(macro, "stance") and StanceLine(macro.stances) or ""
	-- a /castsequence's button would show the step after the cast, so it names the spell too
	local namesSpell = stance ~= "" or use ~= "" or reset ~= nil
	local header = "#showtooltip"
		.. (namesSpell and " " .. macro.name or "")
		.. "\n"
		.. (ns.IsOptionOn(macro, "muteErrors") and "/run MacroSpellbookMute(1)\n" or "")
		.. (stopCast or "")
		.. (ns.IsOptionOn(macro, "stopAttack") and "/stopattack\n" or "")
		.. (ns.IsOptionOn(macro, "cancelForm") and "/cancelform\n" or "")
		.. (ns.IsOptionOn(macro, "targetEnemy") and "/targetenemy [noexists][dead][help]\n" or "")
		.. use
		.. (ns.IsOptionOn(macro, "petAttack") and "/petattack\n" or "")
		.. stance
	--[[
		the noToggle option casts "!Name", which refreshes a form or aspect that is on instead of cancelling
		it; the targetRank option names the highest rank each clause's unit can take, by its level now
	]]
	local prefix = ns.IsOptionOn(macro, "noToggle") and "!" or ""
	local targetRank, fixedRank = ns.IsOptionOn(macro, "targetRank"), ns.FixedRank(macro)
	local function spellFor(unit)
		local rank = fixedRank or (targetRank and RankFor(macro.ranks, unit))
		return prefix .. macro.name .. (rank and "(" .. rank .. ")" or "")
	end
	local spell = spellFor(nil)
	--[[
		who the cast tries, in turn: the focus copy its focus then the target; else the mouseover when that
		option is on, then the target, then (with targetTarget) the target's target, then (with castOnSelf)
		the player, each only when it can take the spell
	]]
	local clauses
	if macro.focus then
		clauses = { { "@focus," .. macro.target .. ",nodead", "focus" }, { "", "target" } }
	else
		clauses = {}
		if ns.IsOptionOn(macro, "mouseover") then
			clauses[1] = { "@mouseover," .. macro.target .. ",nodead", "mouseover" }
		end
		local castOnSelf, targetTarget = ns.IsOptionOn(macro, "castOnSelf"), ns.IsOptionOn(macro, "targetTarget")
		if castOnSelf or targetTarget then
			clauses[#clauses + 1] = { macro.target .. ",nodead", "target" }
		end
		if targetTarget then
			clauses[#clauses + 1] = { "@targettarget," .. macro.target .. ",nodead", "targettarget" }
		end
		clauses[#clauses + 1] = castOnSelf and { "@player", "player" } or { "", "target" }
	end
	if ns.IsOptionOn(macro, "cursor") then
		clauses = { { "@cursor" } }
	end
	-- a rank 1 cast in a raid group goes before each clause; a right-click's group version before them all
	if ns.IsOptionOn(macro, "raidRank1") and macro.raidRank1Text then
		clauses = WithVariant(clauses, "group:raid", macro.name .. "(" .. macro.raidRank1Text .. ")")
	end
	if ns.IsOptionOn(macro, "groupVersion") then
		table.insert(clauses, 1, { "btn:2", nil, macro.groupSpell })
	end
	if ns.IsOptionOn(macro, "pet") then
		-- [pet:X] matches the pet's creature family, so another demon being out still summons this one
		return header
			.. "/cast "
			.. Condition(always, "pet:" .. macro.petFamily)
			.. " "
			.. macro.petAbility
			.. "; "
			.. (always and Condition(always) .. " " or "")
			.. spell
	end
	return header .. CastLine(clauses, always, spellFor, reset)
end

--[[
	After the cast: the autoShot option starts Auto Shot (or the wand's Shoot) with "!", which never stops
	it; the startAttack option starts melee, never while stealthed (Stealth, Prowl, Shadowmeld), where Pick
	Pocket, Sap or Distract would pull the player out of it; the hideErrors option clears the red error text
	the macro's failed lines leave; the muteErrors option, last, puts back the sounds its first line muted.
]]
function ns.MacroBody(macro)
	return CastBody(macro)
		.. (ns.IsOptionOn(macro, "autoShot") and "\n/cast !" .. ns.ClassConfig().autoShot or "")
		.. (ns.IsOptionOn(macro, "startAttack") and "\n/startattack [nostealth]" or "")
		.. (ns.IsOptionOn(macro, "hideErrors") and "\n/run UIErrorsFrame:Clear()" or "")
		.. (ns.IsOptionOn(macro, "muteErrors") and "\n/run MacroSpellbookMute()" or "")
end

--[[
	The muteErrors option's macro lines: MacroSpellbookMute(1) first and MacroSpellbookMute() last, the one
	global a macro body reaches through /run. The game plays an error's sound (the "woosh", or the voice when
	error speech is on) as it shows the error, which for a spell pressed while not ready, short of power or out
	of range is while the macro's /cast line runs; muting sound effects and error speech around that line
	silences it, and the spell's own sound still plays, since the cast starts after the macro ends. Each
	setting is read first, written only when on, and put back to exactly what was read; a timer puts it back
	within a second should the macro's last line never run.
]]
local MUTED_CVARS = { "Sound_EnableSFX", "Sound_EnableErrorSpeech" }
local mutedValues -- cvar -> the value read before muting, while muted

local function RestoreSounds()
	if not mutedValues then
		return
	end
	for cvar, value in pairs(mutedValues) do
		C_CVar.SetCVar(cvar, value)
	end
	mutedValues = nil
end

function MacroSpellbookMute(on)
	if not on then
		RestoreSounds()
		return
	end
	if mutedValues then
		return
	end
	mutedValues = {}
	for _, cvar in ipairs(MUTED_CVARS) do
		local value = C_CVar.GetCVar(cvar)
		if value and value ~= "0" then
			mutedValues[cvar] = value
			C_CVar.SetCVar(cvar, "0")
		end
	end
	C_Timer.After(1, RestoreSounds)
end
