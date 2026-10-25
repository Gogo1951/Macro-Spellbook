local _, ns = ...

-- Writes a page macro's text from its spell and the options the player turned on (Features/Macro-Options.lua).

--[[
	A macro conditional joining the given conditions (nil or "" ones are skipped) behind the always-present
	condition (nil or "", the combat check's), e.g. "[combat,@mouseover,harm,nodead]". Returns "" when there
	is nothing to check, so a plain cast stays "/cast Name".
]]
local function Condition(always, ...)
	local parts = {}
	if always and always ~= "" then
		parts[1] = always
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
	joins the always-present condition (nil or "", e.g. the combat check's), and the clause casts its spell,
	or spellFor(unit) without one. Neighbouring clauses that cast the same spell share it
	("[@mouseover,help,nodead][] Name"), and a lone clause with nothing to check drops its brackets, so a plain
	cast stays "/cast Name". With reset ("combat", "target" or both as "combat/target") the line is a
	/castsequence of the spell then nothing, so it casts once until that reset. command is the line's slash
	command otherwise ("/cast ", or an equipment macro's "/use ").
]]
local function CastLine(clauses, always, spellFor, reset, command)
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
	return (reset and "/castsequence " or command) .. table.concat(parts, "; ")
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

--[[
	The body MacroBody gives a spell macro with no options on, which does just what the plain spell does,
	before its tag line (see ns.TaggedBody).
]]
function ns.BareBody(name)
	return "#showtooltip\n/cast " .. name
end

--[[
	The tag line that ends every macro the add-on writes, "#m 4K", kept as short as it can be since it costs
	the player macro text. WoW runs only the "#" lines it knows (#showtooltip, #show), so the line does
	nothing; it names the page macro the WoW macro is for, whatever the macro is called, so the page finds its
	macros by tag rather than by name. The tag is two of the 62 digits
	and letters, handed out in turn from an account-wide register (ns.db.global.macroTags), so no two macros
	ever share one, which a hash this short couldn't promise; past 3,843 tags they run to three. A page macro
	gets its tag only when a WoW macro is written for it (ns.AssignMacroTag); until then its body carries "00",
	which is never handed out, so its length is already right. The register is keyed by what the macro is
	for: an equipment macro's slot, which every character shares like the general macro itself, else this
	character's key with the spell or custom macro's full name, so a character finds only its own.
]]
local TAG_PREFIX = "#m "
local TAG_DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
local TAG_WIDTH = 2
local UNASSIGNED_TAG = "00"

ns.MACRO_TAG_LENGTH = #"\n" + #TAG_PREFIX + TAG_WIDTH -- the bytes the tag line adds to a body

local function MacroIdentity(macro)
	if macro.equipment then
		return "slot:" .. macro.slot
	end
	local kind = macro.custom and "custom" or macro.focus and "focus" or macro.copy and "copy" .. macro.copy or "spell"
	return ns.db.keys.char .. ":" .. kind .. ":" .. macro.name
end

-- The nth tag, n from 1: n in base 62, padded to TAG_WIDTH digits.
local function TagNumber(n)
	local base, digits = #TAG_DIGITS, ""
	repeat
		local digit = n % base
		digits = TAG_DIGITS:sub(digit + 1, digit + 1) .. digits
		n = math.floor(n / base)
	until n == 0
	return string.rep("0", TAG_WIDTH - #digits) .. digits
end

function ns.MacroTag(macro)
	return ns.db.global.macroTags[MacroIdentity(macro)] or UNASSIGNED_TAG
end

-- The tag a WoW macro's body carries, or nil for a macro the add-on didn't tag.
function ns.BodyTag(body)
	local tag = body and ("\n" .. body .. "\n"):match("\n" .. TAG_PREFIX .. "(%w%w%w?)\n")
	return tag ~= UNASSIGNED_TAG and tag or nil
end

-- body, less any trailing blank lines, with the macro's tag line added at its end.
function ns.TaggedBody(macro, body)
	return (body:gsub("\n+$", "")) .. "\n" .. TAG_PREFIX .. ns.MacroTag(macro)
end

-- body without its tag line, as the page shows macro text.
function ns.UntaggedBody(body)
	return (("\n" .. body):gsub("\n" .. TAG_PREFIX .. "%w+", ""):sub(2))
end

--[[
	Hands the page macro the next tag, once, as a WoW macro is about to be written for it, and puts the tag in
	its body. A macro that has one keeps it.
]]
function ns.AssignMacroTag(macro)
	local global = ns.db.global
	local identity = MacroIdentity(macro)
	if global.macroTags[identity] then
		return
	end
	global.macroTagCount = global.macroTagCount + 1
	global.macroTags[identity] = TagNumber(global.macroTagCount)
	macro.body = ns.TaggedBody(macro, ns.UntaggedBody(macro.body))
end

--[[
	A stance's slot on the stance bar (the n of [stance:n]), or nil when unknown. A Warrior stance not learned
	yet takes its slot from the class lists' stanceSlots, the order they are learned in.
]]
local function StanceSlot(stance)
	local c = ns.ClassConfig()
	local stanceId = c.stanceIds[stance]
	for i = 1, GetNumShapeshiftForms() do
		local spellID = select(4, GetShapeshiftFormInfo(i))
		if spellID and spellID == stanceId then
			return i
		end
	end
	return c.stanceSlots[stance]
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

--[[
	The stances a spell can be cast in, the one to switch to first, or nil for a spell that needs none. Only
	the class lists' stances count: a spell's tooltip names the stances' form names, which some locales (esES)
	name differently from the stance spells, so it can't be matched against them.
]]
function ns.StancesOf(name)
	local c = ns.ClassConfig()
	if not c.hasStances then
		return nil
	end
	return c.stances[name]
end

local function CastBody(macro)
	--[[
		The lines, in the order written: one /stopmacro for stopIfChanneling's [channeling] and
		stopIfStealthed's [stealth], so a press can't break a channel or stealth, ahead of the mute so a
		stopped press never leaves the sounds muted; muteErrors' mute; stopAttack's /stopattack; stopCast's
		/stopcasting; cancelForm's /cancelform; targetEnemy's /targetenemy, for when there is no living hostile
		target, and targetFriend's /targetfriend, for when there is no living friendly one; the useItems slots, in the order ticked; the stance switch; then the cast. The combat check adds
		[combat] or [nocombat] to every cast clause. oncePerCombat makes the
		cast a /castsequence that casts once until combat ends or the target changes, oncePerTarget one that
		casts once until the target changes. With items, a stance switch or a cast sequence, #showtooltip
		names the spell so the button shows the spell.
	]]
	local always
	local combatCheck = ns.CombatCheck(macro)
	if combatCheck then
		always = combatCheck == "combatOnly" and "combat" or "nocombat"
	end
	local stops = (ns.IsOptionOn(macro, "stopIfChanneling") and "[channeling]" or "")
		.. (ns.IsOptionOn(macro, "stopIfStealthed") and "[stealth]" or "")
	-- oncePerCombat also resets when the target changes, so a new pull mid-combat can take the cast again
	local perCombat = ns.IsOptionOn(macro, "oncePerCombat")
	local perTarget = perCombat or ns.IsOptionOn(macro, "oncePerTarget")
	local reset = perCombat and "combat/target" or perTarget and "target" or nil
	local stopCast = ns.IsOptionOn(macro, "stopCast") and "/stopcasting\n"
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
		.. (stops ~= "" and "/stopmacro " .. stops .. "\n" or "")
		.. (ns.IsOptionOn(macro, "muteErrors") and "/run MacroSpellbookMute(1)\n" or "")
		.. (ns.IsOptionOn(macro, "stopAttack") and "/stopattack\n" or "")
		.. (stopCast or "")
		.. (ns.IsOptionOn(macro, "cancelForm") and "/cancelform\n" or "")
		.. (ns.IsOptionOn(macro, "targetEnemy") and "/targetenemy [noexists][dead][help]\n" or "")
		.. (ns.IsOptionOn(macro, "targetFriend") and "/targetfriend [noexists][dead][harm]\n" or "")
		.. use
		.. stance
	--[[
		the noToggle option casts "!Name", which refreshes a form or aspect that is on instead of cancelling
		it; the targetRank option names the highest rank each clause's unit can take, by its level now
	]]
	local prefix = ns.IsOptionOn(macro, "noToggle") and "!" or ""
	local targetRank, fixedRank = ns.IsOptionOn(macro, "targetRank"), ns.FixedRank(macro)
	-- an equipment macro uses its slot ("/use 13"), whose item may go on a friend or an enemy
	local name = macro.equipment and tostring(macro.slot) or macro.name
	local target = macro.equipment and "exists" or macro.target
	local function spellFor(unit)
		local rank = fixedRank or (targetRank and RankFor(macro.ranks, unit))
		return prefix .. name .. (rank and "(" .. rank .. ")" or "")
	end
	local spell = spellFor(nil)
	--[[
		who the cast tries, in turn: the focus copy its focus then the target; else the mouseover when that
		option is on, then the target, then (with targetTarget) the target's target, then (with castOnSelf)
		the player, each only when it can take the spell
	]]
	local clauses
	if macro.focus then
		clauses = { { "@focus," .. target .. ",nodead", "focus" }, { "", "target" } }
	else
		clauses = {}
		if ns.IsOptionOn(macro, "mouseover") then
			clauses[1] = { "@mouseover," .. target .. ",nodead", "mouseover" }
		end
		local castOnSelf, targetTarget = ns.IsOptionOn(macro, "castOnSelf"), ns.IsOptionOn(macro, "targetTarget")
		if castOnSelf or targetTarget then
			clauses[#clauses + 1] = { target .. ",nodead", "target" }
		end
		if targetTarget then
			clauses[#clauses + 1] = { "@targettarget," .. target .. ",nodead", "targettarget" }
		end
		clauses[#clauses + 1] = castOnSelf and { "@player", "player" } or { "", "target" }
	end
	if ns.IsOptionOn(macro, "cursor") then
		clauses = { { "@cursor" } }
	end
	-- a right-click's group version goes before every clause
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
	return header .. CastLine(clauses, always, spellFor, reset, macro.equipment and "/use " or "/cast ")
end

--[[
	After the cast: the autoShot option starts Auto Shot (or the wand's Shoot) with "!", which never stops
	it; the startAttack option starts melee, never while stealthed (Stealth, Prowl, Shadowmeld), where Pick
	Pocket, Sap or Distract would pull the player out of it; the petAttack option sends the pet in; the
	hideErrors option clears the red error text the macro's failed lines leave; the muteErrors option, last,
	puts back the sounds its first line muted. The tag line ends it.
]]
function ns.MacroBody(macro)
	return ns.TaggedBody(
		macro,
		CastBody(macro)
			.. (ns.IsOptionOn(macro, "autoShot") and "\n/cast !" .. ns.ClassConfig().autoShot or "")
			.. (ns.IsOptionOn(macro, "startAttack") and "\n/startattack [nostealth]" or "")
			.. (ns.IsOptionOn(macro, "petAttack") and "\n/petattack" or "")
			.. (ns.IsOptionOn(macro, "hideErrors") and "\n/run UIErrorsFrame:Clear()" or "")
			.. (ns.IsOptionOn(macro, "muteErrors") and "\n/run MacroSpellbookMute()" or "")
	)
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
