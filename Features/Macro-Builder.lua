local _, ns = ...
local L = ns.L

--[[
	Builds the page's macro list (ns.macros) from the spellbook and the class's spell lists
	(ns.CLASS_SPELL_LISTS, from the flavor's data folder), and works out each macro's body. The lists hold
	spell IDs; every name comes from the client, so the page sorts and builds the same in every locale. No
	frames here: Features/Spellbook-Page.lua draws the page.
]]

local ICON_QUESTION_MARK = 134400 -- Interface\Icons\INV_Misc_QuestionMark

local MAX_MACRO_NAME = 16 -- longer names are truncated by CreateMacro, so GetMacroIndexByName would miss them
local MAX_MACRO_BODY = 255
local FOCUS_SUFFIX = " @F" -- ends a focus copy's WoW macro name, keeping it apart from the spell's own

--[[
	Per-spell settings, on the character's profile, each a table keyed by the spell's name as this client
	gives it: "mouseover" (macro casts on the mouseover unit first), "cursor" (macro casts a ground-targeted
	spell where the cursor points), "focus" (the page also lists a copy of the macro that casts on the focus
	target), "pet" (a summon macro casts the pet's ability while that pet is out), "raidRank1" (the macro casts
	rank 1 in a raid group), "spam" (the macro does nothing while its channelled spell is channelling, or its
	stealth spell is on), "stance" (the macro switches to a stance the spell can be cast in first), "petAttack"
	(the macro also sends the pet to attack), "stopCast" (the macro stops the current cast first),
	"startAttack" (the macro starts melee auto-attack after the cast), "noToggle" (a form or aspect's macro
	casts "!Name", which never cancels it when it is already on), "castOnSelf" (a friendly spell's macro
	casts on the player when the target can't take it), "targetRank" (a ranked friendly spell's macro
	casts the highest rank its target's level can take, rewritten as the target changes), "fixedRank" (a
	ranked spell's macro always casts this rank, by its text, e.g. "Rank 3"), "targetTarget"
	(a friendly spell's macro tries the target's target after the target), "targetEnemy" (an enemy spell's
	macro targets the nearest enemy first when there is no living hostile target), "combatOnly" (the macro
	casts only in combat), "noCombat" (only out of combat; see ns.CombatCheck), "oncePerCombat" (the macro casts once until combat ends or the target changes),
	"oncePerTarget" (the macro casts once until the target changes), "stopAttack" (the macro stops melee
	first), "hideErrors" (the macro clears the error text after), "muteErrors" (the macro mutes error sounds while it runs), "cancelForm" (the macro leaves a form first), "autoShot" (the macro starts Auto Shot,
	or the wand, after the cast) or "groupVersion" (a right-click casts the spell's group version). For
	petAttack, stopCast and startAttack, true or false overrides the setting's default (OptionDefault), nil follows it. "useItems" holds a list of
	equipment slots instead of a flag: the macro uses each slot's item, in that order, before the cast.
]]
local function Settings(key)
	return ns.db.profile[key]
end

-- Whether the page also lists the class spells not learned yet, in an Unlearned section after the rest.
function ns.ShowsUnlearned()
	return ns.db.profile.showUnlearned
end

function ns.SetShowUnlearned(on)
	ns.db.profile.showUnlearned = on
end

--[[
	Whether a plain spell on an action bar counts as its macro being placed even when the macro has options
	on (see ns.IsOnActionBars). Macros with no options on always count it.
]]
function ns.CountsSpellsOnBars()
	return ns.db.profile.countSpellsOnBars
end

function ns.SetCountSpellsOnBars(on)
	ns.db.profile.countSpellsOnBars = on
end

--[[
	Whether the macro was marked placed by Mark All Abilities as Placed, which stops it glowing wherever it is.
	A spell learned after the mark still glows until it is placed.
]]
function ns.IsMarkedPlaced(macro)
	return ns.db.profile.markedPlaced[macro.macroName] == true
end

function ns.MarkAllPlaced()
	for _, macro in ipairs(ns.macros) do
		if not macro.unlearned then
			ns.db.profile.markedPlaced[macro.macroName] = true
		end
	end
end

-- Whether "petAttack" is on for every enemy spell macro that has no setting of its own.
function ns.PetAttacksByDefault()
	return ns.db.profile.petAttackDefault
end

function ns.SetPetAttacksByDefault(on)
	ns.db.profile.petAttackDefault = on
end

-- Whether "stopCast" is on for every spell macro that has no setting of its own.
function ns.StopsCastingByDefault()
	return ns.db.profile.stopCastDefault
end

function ns.SetStopsCastingByDefault(on)
	ns.db.profile.stopCastDefault = on
end

-- Whether "startAttack" is on for every spell macro that has no setting of its own.
function ns.StartsAttackByDefault()
	return ns.db.profile.startAttackDefault
end

function ns.SetStartsAttackByDefault(on)
	ns.db.profile.startAttackDefault = on
end

-- The settings with a default; each spell macro stores one only where it differs from the default.
local DEFAULTED = { petAttack = true, stopCast = true, startAttack = true }

-- The default of a setting that has one ("petAttack", "stopCast" or "startAttack"), or nil.
local function OptionDefault(key)
	if key == "petAttack" then
		return ns.PetAttacksByDefault()
	end
	if key == "stopCast" then
		return ns.StopsCastingByDefault()
	end
	if key == "startAttack" then
		-- only a melee class's page offers this default; a caster sharing its profile doesn't follow it
		return ns.IsMeleeClass() and ns.StartsAttackByDefault()
	end
end

local function ToggleSetting(key, name)
	local set = Settings(key)
	set[name] = not set[name] or nil
end

local UNLISTED = math.huge -- the Unlearned section sorts after everything else
local PET_CLASSES = { HUNTER = true, WARLOCK = true } -- classes with a combat pet; only they get pet settings
-- classes that fight with auto-attack; they get the "startAttack" default and no "stopCast" option
local MELEE_CLASSES = { WARRIOR = true, HUNTER = true, ROGUE = true }
-- classes with a form to leave (Druid forms, Ghost Wolf, Shadowform); they get the "cancelForm" option
local FORM_CLASSES = { DRUID = true, SHAMAN = true, PRIEST = true }
--[[
	The ranged attack the "autoShot" option starts after a cast, by class: Auto Shot, or the wand's Shoot,
	with the label its menu entry takes. Before MoP only; there Auto Shot is automatic and wands are gone.
]]
local AUTO_SHOTS = {
	HUNTER = { id = 75, labelKey = "MENU_START_AUTO_SHOT" },
	MAGE = { id = 5019, labelKey = "MENU_START_WAND" },
	PRIEST = { id = 5019, labelKey = "MENU_START_WAND" },
	WARLOCK = { id = 5019, labelKey = "MENU_START_WAND" },
}

local NO_IDS = {}

local requested = {} -- spell ids asked for once, so an id that never loads can't keep the page redrawing

-- A spell's name, or nil while its data isn't loaded (it is then requested).
local function SpellName(id)
	local name = C_Spell.GetSpellName(id)
	if not name and not requested[id] then
		requested[id] = true
		C_Spell.RequestLoadSpellData(id)
	end
	return name
end

--[[
	The client's names for a list of spells, as name -> position in the list. An entry is a spell ID, or a
	table of every rank's ID where some locales name the ranks differently, so each rank's name matches.
]]
local function NameIndex(entries)
	local index = {}
	for position, entry in ipairs(entries or NO_IDS) do
		for _, id in ipairs(type(entry) == "table" and entry or { entry }) do
			local name = SpellName(id)
			if name and not index[name] then
				index[name] = position
			end
		end
	end
	return index
end

--[[
	The page's sections follow the spellbook's own tabs (General, then the class or each tree or spec), ranked by
	tab. Custom and Equipment sections follow the tabs, and the spells not learned yet come last.
]]
local TAB_SECTION_BASE = 100

local config -- the player's class lists, resolved to this client's names by ns.CollectMacros

-- Resolves the player's class lists to the names this client gives their spells.
local function ResolveClassConfig()
	local class = select(2, UnitClass("player"))
	local lists = ns.CLASS_SPELL_LISTS[class] or {}
	local hasPet = PET_CLASSES[class] == true
	local autoShot = ns.EXPANSION < 5 and AUTO_SHOTS[class] or nil
	config = {
		forms = FORM_CLASSES[class] == true,
		autoShot = autoShot and SpellName(autoShot.id),
		autoShotLabelKey = autoShot and autoShot.labelKey,
		groupSpells = {},
		categoryRankByName = {}, -- each spellbook tab's name -> its section rank, filled by ns.CollectMacros
		extraSpells = lists.extraSpells or NO_IDS,
		petAbilities = {},
		stances = {},
		stanceSlots = {},
		hasStances = lists.stances ~= nil,
		formSpells = {},
		petAttack = hasPet,
		melee = MELEE_CLASSES[class] == true,
		enemySpells = NameIndex(lists.mouseoverEnemy),
		friendSpells = NameIndex(lists.mouseoverFriend),
		cursorSpells = NameIndex(lists.cursor),
		raidRank1Spells = NameIndex(lists.raidRank1),
		channeledSpells = NameIndex(lists.channeled),
		stealthSpells = NameIndex(lists.stealth),
		toggleSpells = NameIndex(lists.noToggle),
	}
	if hasPet then
		for summonId, pet in pairs(lists.petAbilities or NO_IDS) do
			local summon, ability = SpellName(summonId), SpellName(pet.abilityId)
			local family = C_CreatureInfo.GetCreatureFamilyInfo(pet.familyId)
			if summon and ability and family and family.name then
				config.petAbilities[summon] = { ability = ability, family = family.name }
			end
		end
	end
	for spellId, stanceIds in pairs(lists.stances or NO_IDS) do
		local name, stances = SpellName(spellId), {}
		for _, stanceId in ipairs(stanceIds) do
			stances[#stances + 1] = SpellName(stanceId)
		end
		if name and #stances == #stanceIds then
			config.stances[name] = stances
		end
	end
	for slot, stanceId in ipairs(lists.stanceSlots or NO_IDS) do
		local name = SpellName(stanceId)
		if name then
			config.stanceSlots[name] = slot
		end
	end
	for singleId, groupId in pairs(ns.GROUP_VERSIONS or NO_IDS) do
		local single, group = C_Spell.GetSpellName(singleId), C_Spell.GetSpellName(groupId)
		if single and group then
			config.groupSpells[single] = group
		end
	end
	--[[
		the stance bar's forms (stances, auras, Stealth) are placed there already, so their macros never glow.
		They also cancel when cast again (Bear Form, Shadowform, Ghost Wolf), except the Warrior stances, which
		never do, and stealth, which the spam option keeps on
	]]
	for i = 1, GetNumShapeshiftForms() do
		local spellID = select(4, GetShapeshiftFormInfo(i))
		local name = spellID and C_Spell.GetSpellName(spellID)
		if name then
			config.formSpells[name] = true
		end
		if name and not config.stanceSlots[name] and not config.stealthSpells[name] then
			config.toggleSpells[name] = true
		end
	end
	return config
end

local function ClassConfig()
	return config or ResolveClassConfig()
end

ns.SpellName = SpellName

-- The class lists' extraSpells: spells to list until learned that no trainer data covers.
function ns.ClassExtraSpells()
	return ClassConfig().extraSpells
end

--[[
	Whether a spell is cast on an enemy unit: harmful and with a range. Self-centred AoE such as Arcane
	Explosion or Hellfire has no range, so it is left out.
]]
local function TargetsEnemy(id)
	return id ~= nil and C_Spell.IsSpellHarmful(id) == true and C_Spell.SpellHasRange(id) == true
end

--[[
	The macro conditional a spell's mouseover option uses, or nil for spells without one. Enemy spells are
	the mouseoverEnemy list plus every spell TargetsEnemy finds, except cursor spells. A spell that is both
	an enemy and a friend spell casts on any unit.
]]
local function TargetOf(name, id)
	local c = ClassConfig()
	local enemy = c.enemySpells[name] or (not c.cursorSpells[name] and TargetsEnemy(id))
	local friend = c.friendSpells[name]
	if enemy and friend then
		return "exists"
	end
	if enemy then
		return "harm"
	end
	if friend then
		return "help"
	end
end

-- Whether the player's class has a combat pet, which turns on the "petAttack" option.
function ns.ClassOffersPetAttack()
	return ClassConfig().petAttack
end

-- Enemy spell macros offer "petAttack" when the class does. A focus copy shares its spell's setting.
function ns.OffersPetAttack(macro)
	return ns.ClassOffersPetAttack() and macro.target == "harm" and not macro.custom
end

-- Whether the player's class is a melee one: it has the "startAttack" default and no "stopCast" option.
function ns.IsMeleeClass()
	return ClassConfig().melee
end

--[[
	Every spell macro offers "startAttack" except a stealth spell's: attacking would break the stealth. Every
	spell macro offers "stopCast" too, except a melee class's. A focus copy shares its spell's settings.
	Custom and equipment macros offer neither.
]]
function ns.OffersStopCast(macro)
	return not macro.custom and not macro.equipment and not ns.IsMeleeClass()
end

function ns.OffersStartAttack(macro)
	return not macro.custom and not macro.equipment and not macro.stealth
end

-- A form or aspect, which casting again would cancel, offers "noToggle".
function ns.OffersNoToggle(macro)
	return macro.toggles == true
end

-- A spell that can be cast on a friend offers "castOnSelf". The focus copy ignores it.
function ns.OffersCastOnSelf(macro)
	return macro.target == "help" or macro.target == "exists"
end

-- A friendly spell with more than one rank known offers "targetRank". A focus copy shares its setting.
function ns.OffersTargetRank(macro)
	return ns.OffersCastOnSelf(macro) and macro.ranks ~= nil
end

-- A spell with more than one rank known offers a fixed rank (see ns.AbilityRank).
function ns.OffersFixedRank(macro)
	return not macro.custom and not macro.equipment and macro.ranks ~= nil
end

-- Whether a macro is a spell's, not a custom or equipment one.
local function IsSpellMacro(macro)
	return not macro.custom and not macro.equipment
end

-- An enemy spell offers "targetEnemy".
local function TargetsHarm(macro)
	return macro.target == "harm"
end

-- Whether each option is offered on a macro, by key. The ones not listed are offered on spells with a target.
local OFFERED = {
	cursor = function(macro)
		return macro.cursor
	end,
	pet = function(macro)
		return macro.petAbility ~= nil
	end,
	raidRank1 = function(macro)
		return macro.raidRank1
	end,
	spam = function(macro)
		return macro.spam ~= nil
	end,
	stance = function(macro)
		return macro.stances ~= nil
	end,
	petAttack = function(macro)
		return ns.OffersPetAttack(macro)
	end,
	stopCast = function(macro)
		return ns.OffersStopCast(macro)
	end,
	startAttack = function(macro)
		return ns.OffersStartAttack(macro)
	end,
	noToggle = function(macro)
		return ns.OffersNoToggle(macro)
	end,
	castOnSelf = function(macro)
		return ns.OffersCastOnSelf(macro)
	end,
	targetRank = function(macro)
		return ns.OffersTargetRank(macro)
	end,
	-- a heal or buff can go to the target's target: the tank, when the target is the enemy it is fighting
	targetTarget = function(macro)
		return macro.target == "help"
	end,
	targetEnemy = TargetsHarm,
	combatOnly = IsSpellMacro,
	noCombat = IsSpellMacro,
	oncePerCombat = IsSpellMacro,
	oncePerTarget = IsSpellMacro,
	stopAttack = IsSpellMacro,
	hideErrors = IsSpellMacro,
	muteErrors = IsSpellMacro,
	-- leaving a form makes no sense on the form itself, or on stealth, which needs Cat Form
	cancelForm = function(macro)
		return IsSpellMacro(macro) and ClassConfig().forms and not macro.toggles and not macro.stealth
	end,
	-- a ranged enemy spell, but not the ranged attack itself
	autoShot = function(macro)
		local autoShot = ClassConfig().autoShot
		return autoShot ~= nil and macro.target == "harm" and macro.name ~= autoShot
	end,
	-- a single-target spell whose group version (Prayer of Fortitude, Portal: Ironforge) is learned
	groupVersion = function(macro)
		return macro.groupSpell ~= nil
	end,
}

--[[
	Whether a macro offers an option: "mouseover", "cursor", "focus", "pet", "raidRank1", "spam", "stance",
	"petAttack", "stopCast", "startAttack", "noToggle", "castOnSelf", "targetRank", "targetTarget",
	"targetEnemy", "combatOnly", "noCombat", "oncePerCombat", "oncePerTarget", "stopAttack", "hideErrors", "muteErrors",
	"cancelForm", "autoShot" or "groupVersion".
]]
function ns.OffersOption(macro, key)
	local offered = OFFERED[key]
	if offered then
		return offered(macro) and true or false
	end
	return macro.target ~= nil
end

-- The menu label of the "autoShot" option for the player's class (Auto Shot, or the wand), or nil.
function ns.AutoShotLabelKey()
	return ClassConfig().autoShotLabelKey
end

-- Whether a macro offers an option (see ns.OffersOption) and the player turned it on.
function ns.IsOptionOn(macro, key)
	if not ns.OffersOption(macro, key) then
		return false
	end
	local on = Settings(key)[macro.name]
	if DEFAULTED[key] and on == nil then
		return OptionDefault(key)
	end
	return on == true
end

-- Whether the player ticked an option on for this macro, rather than it being on by its setting's default.
function ns.IsOptionTicked(macro, key)
	return ns.OffersOption(macro, key) and Settings(key)[macro.name] == true
end

--[[
	Whether a macro offers a way to cast other than the plain spell's (any option but stopCast, startAttack
	and noToggle; castOnSelf and targetRank come with a target).
]]
function ns.HasCastOptions(macro)
	return macro.target ~= nil
		or macro.cursor
		or macro.petAbility ~= nil
		or macro.raidRank1
		or macro.spam ~= nil
		or macro.stances ~= nil
end

-- Every spell macro offers using equipped items before the cast. A focus copy shares its spell's slots.
function ns.OffersUseItems(macro)
	return not macro.custom and not macro.equipment
end

local NO_SLOTS = {}

-- The equipment slots a macro uses before its cast, in the order the player ticked them. Don't modify it.
function ns.UseItemSlots(macro)
	if not ns.OffersUseItems(macro) then
		return NO_SLOTS
	end
	return Settings("useItems")[macro.name] or NO_SLOTS
end

-- A slot's place in a macro's UseItemSlots, or nil when the macro doesn't use it.
function ns.IsUsingSlot(macro, slot)
	for i, used in ipairs(ns.UseItemSlots(macro)) do
		if used == slot then
			return i
		end
	end
end

-- Whether a macro has an options menu: every spell macro does, for stopCast or startAttack.
function ns.HasOptions(macro)
	return ns.HasCastOptions(macro)
		or ns.OffersStopCast(macro)
		or ns.OffersStartAttack(macro)
		or ns.OffersUseItems(macro)
end

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

-- A focus copy switches back to the previous target after the cast.
local FOCUS_FOOTER = "\n/script TargetLastTarget()"

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
	return ClassConfig().stanceSlots[stance]
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
	local names = {}
	for name in pairs(ClassConfig().stanceSlots) do
		names[#names + 1] = name
	end
	for i = 1, GetNumShapeshiftForms() do
		local spellID = select(4, GetShapeshiftFormInfo(i))
		local name = spellID and C_Spell.GetSpellName(spellID)
		if name and not ClassConfig().stanceSlots[name] then
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
	tooltip says which stances, so the list matches this client's rules; the class lists' stances fill in
	when the tooltip names none, and their order picks the stance to switch to.
]]
local function StancesOf(name, id)
	local c = ClassConfig()
	if not c.hasStances then
		return nil
	end
	local configured = c.stances[name]
	local allowed = id and TooltipStances(id)
	if not allowed then
		return configured
	end
	local target = allowed[1]
	for _, stance in ipairs(configured or {}) do
		if tContains(allowed, stance) then
			target = stance
			break
		end
	end
	local stances = { target }
	for _, stance in ipairs(allowed) do
		if stance ~= target then
			stances[#stances + 1] = stance
		end
	end
	return stances
end

local function CastBody(macro)
	--[[
		the spam option adds [nochanneling:<spell>] (or [nostealth]) to every cast clause, so a press while
		the spell is channelling (or stealth is on) can't restart (or cancel) it; the stopCast option stops
		the current cast first (but, with spam on, not this spell's own channel); the useItems slots are used
		next, in order; the petAttack option sends the pet at the current target before the
		cast; the stance option switches stance before the cast. With items or a stance, #showtooltip names
		the spell so the button doesn't show the item or the stance
	]]
	--[[
		then the stopAttack option stops melee first, the cancelForm option leaves a form, and the
		targetEnemy option picks the nearest enemy when there is no living hostile target. The combat check
		adds [combat] or [nocombat] to every cast clause, as spam does its condition; oncePerCombat makes the cast a
		/castsequence that casts once until combat ends or the target changes, oncePerTarget one that casts
		once until the target changes
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
	if ns.IsOptionOn(macro, "raidRank1") then
		clauses = WithVariant(clauses, "group:raid", macro.name .. "(" .. RANK .. " 1)")
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
	return header .. CastLine(clauses, always, spellFor, reset) .. (macro.focus and FOCUS_FOOTER or "")
end

--[[
	After the cast: the autoShot option starts Auto Shot (or the wand's Shoot) with "!", which never stops
	it; the startAttack option starts melee, never while stealthed (Stealth, Prowl, Shadowmeld), where Pick
	Pocket, Sap or Distract would pull the player out of it; the hideErrors option clears the red error text
	the macro's failed lines leave; the muteErrors option, last, puts back the sounds its first line muted.
]]
local function MacroBody(macro)
	return CastBody(macro)
		.. (ns.IsOptionOn(macro, "autoShot") and "\n/cast !" .. ClassConfig().autoShot or "")
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

--[[
	One macro per learned class spell (and unlearned one, when shown) with its focus copy when that's on, plus
	the player's custom macros and the equipment macros, in page order. Rebuilt each time the page opens.
]]
ns.macros = {}

--[[
	The condition a spell's spam option adds to its casts, or nil for spells without one. Stealth toggles
	off when cast again, so a stealth spell casts only while not stealthed.
]]
local function SpamCondition(name)
	local c = ClassConfig()
	if c.stealthSpells[name] then
		return "nostealth"
	end
	if c.channeledSpells[name] then
		return "nochanneling:" .. name
	end
end

--[[
	section is { rank, name, priority }: the spell's spellbook tab, or the Unlearned section. ranks is the
	spell's ReadSpellbook ranks entry, or nil; groupSpell its learned group version's name, or nil.
]]
local function MakeMacro(name, icon, unlearned, id, section, ranks, groupSpell)
	local pet = ClassConfig().petAbilities[name]
	local macro = {
		name = name,
		spellID = id,
		unlearned = unlearned,
		categoryRank = section[1],
		priority = section[3],
		category = section[2],
		noGlow = ClassConfig().formSpells[name] == true,
		target = TargetOf(name, id),
		cursor = ClassConfig().cursorSpells[name] ~= nil,
		petAbility = pet and pet.ability,
		petFamily = pet and pet.family,
		raidRank1 = ClassConfig().raidRank1Spells[name] ~= nil,
		spam = SpamCondition(name),
		stealth = ClassConfig().stealthSpells[name] ~= nil,
		stances = StancesOf(name, id),
		toggles = ClassConfig().toggleSpells[name] ~= nil,
		ranks = ranks,
		groupSpell = groupSpell,
		macroName = name:sub(1, MAX_MACRO_NAME),
		-- the question mark icon lets #showtooltip show the spell's own icon on the action bar
		macroIcon = ICON_QUESTION_MARK,
		icon = icon or ICON_QUESTION_MARK,
	}
	macro.body = MacroBody(macro)
	return macro
end

--[[
	A copy of a spell macro that casts on the focus target, falling back to the current target. Its menu
	offers only the focus option, which removes it.
]]
local function MakeFocusMacro(macro)
	local copy = {}
	for key, value in pairs(macro) do
		copy[key] = value
	end
	copy.focus = true
	copy.cursor = false
	copy.petAbility = nil
	copy.petFamily = nil
	copy.macroName = macro.name:sub(1, MAX_MACRO_NAME - #FOCUS_SUFFIX) .. FOCUS_SUFFIX
	copy.body = MacroBody(copy)
	return copy
end

-- The icon of the spell named by a leading "#showtooltip <spell>" line, or nil.
local function ShowtooltipIcon(body)
	local spell = body:match("^#showtooltip[ \t]+([^\n]*%S)")
	if spell then
		return C_Spell.GetSpellTexture(spell)
	end
end

-- A custom macro as a page macro. Its body is used as written, and it has no options menu.
local function MakeCustomMacro(entry, index, categoryRank)
	return {
		name = entry.name,
		categoryRank = categoryRank,
		priority = index,
		category = entry.category or L["SECTION_CUSTOM"],
		custom = true,
		cursor = false,
		macroName = entry.name:sub(1, MAX_MACRO_NAME),
		macroIcon = entry.icon or ICON_QUESTION_MARK,
		icon = entry.icon or ShowtooltipIcon(entry.body) or ICON_QUESTION_MARK,
		body = entry.body,
	}
end

local warned = {}

-- Prints a config problem once per session.
local function Warn(message)
	if warned[message] then
		return
	end
	warned[message] = true
	ns:PrintMessage(message)
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
			name = SpellName(tonumber(id))
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
	for _, entry in ipairs((ns.CLASS_SPELL_LISTS[class] or {}).customMacros or NO_IDS) do
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

-- Appends the valid custom entries to ns.macros. taken holds the macro names already in use.
local function AddCustomMacros(taken)
	local c = ClassConfig()
	local categoryRanks = {}
	for i, entry in ipairs(ns.CustomMacroList()) do
		local name, body = type(entry) == "table" and entry.name, type(entry) == "table" and entry.body
		if type(name) ~= "string" or name == "" or type(body) ~= "string" or body == "" then
			Warn(L["CHAT_CUSTOM_NEEDS_NAME_BODY"]:format(i))
		elseif #body > MAX_MACRO_BODY then
			Warn(L["CHAT_CUSTOM_TOO_LONG"]:format(name, #body, MAX_MACRO_BODY))
		elseif taken[name:sub(1, MAX_MACRO_NAME)] then
			Warn(L["CHAT_CUSTOM_NAME_TAKEN"]:format(name, MAX_MACRO_NAME))
		else
			taken[name:sub(1, MAX_MACRO_NAME)] = true
			local category = entry.category or L["SECTION_CUSTOM"]
			-- a category named after a spellbook tab joins it; others follow the tabs in order of first use
			categoryRanks[category] = categoryRanks[category] or c.categoryRankByName[category] or TAB_SECTION_BASE + i
			ns.macros[#ns.macros + 1] = MakeCustomMacro(entry, i, categoryRanks[category])
		end
	end
end

--[[
	Each inventory slot as { the GlobalStrings constant the page shows for it, the WoW macro name its
	equipment macro takes }. The macro names are identifiers players already have on their bars, so they stay
	as they are in every locale.
]]
local SLOTS = {
	[1] = { "HEADSLOT", "Head" },
	[2] = { "NECKSLOT", "Neck" },
	[3] = { "SHOULDERSLOT", "Shoulder" },
	[4] = { "SHIRTSLOT", "Shirt" },
	[5] = { "CHESTSLOT", "Chest" },
	[6] = { "WAISTSLOT", "Waist" },
	[7] = { "LEGSSLOT", "Legs" },
	[8] = { "FEETSLOT", "Feet" },
	[9] = { "WRISTSLOT", "Wrist" },
	[10] = { "HANDSSLOT", "Hands" },
	[11] = { "FINGER0SLOT_UNIQUE", "Ring 1" },
	[12] = { "FINGER1SLOT_UNIQUE", "Ring 2" },
	[13] = { "TRINKET0SLOT_UNIQUE", "Trinket 1" },
	[14] = { "TRINKET1SLOT_UNIQUE", "Trinket 2" },
	[15] = { "BACKSLOT", "Back" },
	[16] = { "MAINHANDSLOT", "Main Hand" },
	[17] = { "SECONDARYHANDSLOT", "Off Hand" },
	[18] = { "RANGEDSLOT", "Ranged" },
	[19] = { "TABARDSLOT", "Tabard" },
}

-- The client's name for an inventory slot.
local function SlotName(slot)
	return _G[SLOTS[slot][1]]
end

--[[
	Whether the item in an equipment slot has a "Use:" effect. The tooltip check catches effects added to the
	item, such as engineering tinkers, which GetItemSpell on the item itself may not see.
]]
local function HasUseEffect(slot, link)
	if C_Item.GetItemSpell(link) then
		return true
	end
	local prefix = ITEM_SPELL_TRIGGER_ONUSE
	for _, text in ipairs(ns.ScanTooltipLines("GetInventoryItem", "SetInventoryItem", "player", slot)) do
		if type(text) == "string" and text:sub(1, #prefix) == prefix then
			return true
		end
	end
	return false
end

--[[
	A macro that uses whatever is in an equipment slot, so it keeps working when the item is swapped. It has
	no options menu.
]]
local function MakeEquipmentMacro(slot, link, categoryRank)
	local label = SlotName(slot)
	return {
		name = link:match("%[(.-)%]") or label,
		equipment = true,
		slot = slot,
		slotLabel = label,
		categoryRank = categoryRank,
		priority = slot,
		category = L["SECTION_EQUIPMENT"],
		cursor = false,
		macroName = ("Use " .. SLOTS[slot][2]):sub(1, MAX_MACRO_NAME),
		macroIcon = ICON_QUESTION_MARK,
		icon = GetInventoryItemTexture("player", slot) or ICON_QUESTION_MARK,
		body = "#showtooltip\n/use " .. slot,
	}
end

--[[
	The equipped items with a "Use:" effect, in slot order, as {slot = 13, link = ...}. Cached until the gear
	worn changes (ns:InvalidateUsableSlots, on PLAYER_EQUIPMENT_CHANGED), and each item's answer is kept by its
	link, so the page and its menus don't rescan nineteen tooltips on every redraw. Don't modify it.
]]
local usableSlots
local useEffectByLink = {}

function ns.UsableSlots()
	if usableSlots then
		return usableSlots
	end
	usableSlots = {}
	for slot = 1, #SLOTS do
		local link = GetInventoryItemLink("player", slot)
		if link then
			if useEffectByLink[link] == nil then
				useEffectByLink[link] = HasUseEffect(slot, link)
			end
			if useEffectByLink[link] then
				usableSlots[#usableSlots + 1] = { slot = slot, link = link }
			end
		end
	end
	return usableSlots
end

function ns:InvalidateUsableSlots()
	usableSlots = nil
end

-- The name a slot shows in menus: its label, plus the equipped item's name when there is one.
function ns.SlotLabel(slot)
	local link = GetInventoryItemLink("player", slot)
	local item = link and link:match("%[(.-)%]")
	return SlotName(slot) .. (item and ": " .. item or "")
end

--[[
	Appends a macro for each equipped item with a "Use:" effect to ns.macros. taken holds the macro names
	already in use. The section follows the custom macros.
]]
local function AddEquipmentMacros(taken)
	local categoryRank = TAB_SECTION_BASE + #ns.CustomMacroList() + 1
	for _, usable in ipairs(ns.UsableSlots()) do
		local macro = MakeEquipmentMacro(usable.slot, usable.link, categoryRank)
		if not taken[macro.macroName] then
			taken[macro.macroName] = true
			ns.macros[#ns.macros + 1] = macro
		end
	end
end

--[[
	Each spell id's learn level: the class's trainer data, then the trainers this character recorded. The
	client's own answer (C_Spell.GetSpellLevelLearned, where it has one) fills the rest.
]]
local function LearnLevels()
	local levels = {}
	for _, row in ipairs(ns.TRAINER_SPELLS and ns.TRAINER_SPELLS[select(2, UnitClass("player"))] or NO_IDS) do
		levels[row.id] = row.level
	end
	for id, level in pairs(ns.db.profile.trainerSpells) do
		levels[id] = levels[id] or level
	end
	return levels
end

--[[
	One pass over the spellbook: the learned ranks of each spell with more than one, as
	name -> { { text = "Rank 4", level = 38 }, ... } highest first (a rank whose learn level isn't known is
	left out), and every learned spell's name, as name -> true. Classic's book lists only each spell's highest
	rank unless Show All Spell Ranks is ticked, so the known trainer ranks are added from their ids as well.
]]
local function ReadSpellbook()
	local levels, byName, learned, listed = LearnLevels(), {}, {}, {}
	local levelLearned = C_Spell.GetSpellLevelLearned
	local function addRank(name, subName, level)
		if name and subName and subName ~= "" and level and level > 0 and not listed[name .. subName] then
			listed[name .. subName] = true
			byName[name] = byName[name] or {}
			table.insert(byName[name], { text = subName, level = level })
		end
	end
	ns.ForEachClassSpell(function(name, _, id, _, _, subName)
		if name then
			learned[name] = true
		end
		addRank(name, subName, id and (levels[id] or (levelLearned and levelLearned(id))))
	end)
	for id, level in pairs(levels) do
		if IsPlayerSpell(id) then
			local name = SpellName(id)
			if learned[name] then
				addRank(name, C_Spell.GetSpellSubtext(id), level)
			end
		end
	end
	local ranks = {}
	for name, list in pairs(byName) do
		if #list > 1 then
			table.sort(list, function(a, b)
				return a.level > b.level
			end)
			ranks[name] = list
		end
	end
	return ranks, learned
end

--[[
	The targetRank macros pick their ranks by the levels of the units they cast on, so a new target or
	mouseover rewrites them, the page's list built first when no page has built it yet. Out of combat only:
	in combat a macro keeps the ranks it last had.
]]
function ns:OnUnitsChanged()
	if not ns.db or InCombatLockdown() or not next(Settings("targetRank")) then
		return
	end
	if #ns.macros == 0 then
		ns.CollectMacros()
	end
	for _, macro in ipairs(ns.macros) do
		if ns.IsOptionOn(macro, "targetRank") then
			macro.body = MacroBody(macro)
			ns.SyncMacro(macro, GetMacroIndexByName(macro.macroName))
		end
	end
end

--[[
	Rebuilds ns.macros: the learned spells (from the spellbook), the player's custom macros and the
	equipped items with a "Use:" effect, plus the spells not learned yet when ns.ShowsUnlearned().
]]
function ns.CollectMacros()
	wipe(ns.macros)
	ResolveClassConfig()
	local taken, seen = {}, {}
	local ranks, learned = ReadSpellbook()
	local function add(name, icon, unlearned, id, section)
		local groupSpell = ClassConfig().groupSpells[name]
		local macro = MakeMacro(
			name,
			icon,
			unlearned,
			id,
			section,
			not unlearned and ranks[name] or nil,
			groupSpell and learned[groupSpell] and groupSpell or nil
		)
		if unlearned and taken[macro.macroName] then
			return
		end -- a custom macro already uses the name
		taken[macro.macroName] = true
		ns.macros[#ns.macros + 1] = macro
		if ns.IsOptionOn(macro, "focus") then
			local copy = MakeFocusMacro(macro)
			taken[copy.macroName] = true
			ns.macros[#ns.macros + 1] = copy
		end
	end
	local position = 0
	local tabRanks = ClassConfig().categoryRankByName
	ns.ForEachClassSpell(function(name, icon, id, lineName, line)
		tabRanks[lineName] = tabRanks[lineName] or line
		if name and not seen[name] then -- older books list each rank separately
			seen[name] = true
			position = position + 1
			add(name, icon, nil, id, { line, lineName, position })
		end
	end)
	AddCustomMacros(taken)
	AddEquipmentMacros(taken)
	if ns.ShowsUnlearned() and ns.ForEachUnlearnedSpell then
		ns.ForEachUnlearnedSpell(function(name, icon, id)
			position = position + 1
			add(name, icon, true, id, { UNLISTED, L["SECTION_UNLEARNED"], position })
		end, seen)
	end
	--[[
		by section; within one, spells before custom macros, then spellbook (or learn level) order, then by
		name, each focus copy right after its spell
	]]
	table.sort(ns.macros, function(a, b)
		if a.categoryRank ~= b.categoryRank then
			return a.categoryRank < b.categoryRank
		end
		if (not a.custom) ~= not b.custom then
			return not a.custom
		end
		if a.priority ~= b.priority then
			return a.priority < b.priority
		end
		if a.name ~= b.name then
			return a.name < b.name
		end
		return not a.focus and b.focus == true
	end)
end

-- Rebuilds the macro's body after a setting changes and rewrites the macro if it already exists.
local function Rewrite(macro)
	macro.body = MacroBody(macro)
	if InCombatLockdown() then
		return
	end
	ns.SyncMacro(macro, GetMacroIndexByName(macro.macroName))
end

--[[
	Flips a setting (any ns.OffersOption key) and rewrites the macro if it already exists. In combat the
	rewrite waits until the next pickup. The focus setting adds or removes a page entry and most others also
	change the focus copy, so the page must be rebuilt after them (see the menu in Spellbook-Page.lua).
]]
function ns.ToggleOption(macro, key)
	if DEFAULTED[key] then
		-- stored only where it differs from the default, so the rest follow a change of default
		local on = not ns.IsOptionOn(macro, key)
		if on == OptionDefault(key) then
			Settings(key)[macro.name] = nil
		else
			Settings(key)[macro.name] = on
		end
	else
		ToggleSetting(key, macro.name)
	end
	Rewrite(macro)
end

--[[
	The macro's combat check, a choice of one: "combatOnly" (it casts only in combat), "noCombat" (only out
	of combat), or nil for neither, the default.
]]
local COMBAT_CHECKS = { "combatOnly", "noCombat" }

function ns.CombatCheck(macro)
	for _, key in ipairs(COMBAT_CHECKS) do
		if ns.IsOptionOn(macro, key) then
			return key
		end
	end
	return nil
end

-- Sets the combat check (see ns.CombatCheck) and rewrites the macro like ns.ToggleOption.
function ns.SetCombatCheck(macro, check)
	for _, key in ipairs(COMBAT_CHECKS) do
		Settings(key)[macro.name] = key == check or nil
	end
	Rewrite(macro)
end

-- The rank text the macro is fixed to, or nil when it isn't, or that rank isn't among its known ranks.
function ns.FixedRank(macro)
	local text = ns.OffersFixedRank(macro) and Settings("fixedRank")[macro.name]
	for _, rank in ipairs(text and macro.ranks or NO_SLOTS) do
		if rank.text == text then
			return text
		end
	end
	return nil
end

--[[
	The macro's ability rank, a choice of one: a known rank's text it always casts (see ns.FixedRank),
	"targetRank" (by the level of who it casts on), or nil for the highest rank, the default.
]]
function ns.AbilityRank(macro)
	return ns.IsOptionOn(macro, "targetRank") and "targetRank" or ns.FixedRank(macro)
end

-- Sets the ability rank (see ns.AbilityRank) and rewrites the macro like ns.ToggleOption.
function ns.SetAbilityRank(macro, choice)
	Settings("targetRank")[macro.name] = choice == "targetRank" or nil
	Settings("fixedRank")[macro.name] = choice ~= "targetRank" and choice or nil
	Rewrite(macro)
end

--[[
	Adds an equipment slot to the end of the macro's useItems list, or removes it, then rewrites the macro
	like ns.ToggleOption. The focus copy changes too, so the page must be rebuilt after.
]]
function ns.ToggleUseSlot(macro, slot)
	local slots = {}
	local at = ns.IsUsingSlot(macro, slot)
	for i, used in ipairs(ns.UseItemSlots(macro)) do
		if i ~= at then
			slots[#slots + 1] = used
		end
	end
	if not at then
		slots[#slots + 1] = slot
	end
	Settings("useItems")[macro.name] = #slots > 0 and slots or nil
	macro.body = MacroBody(macro)
	if InCombatLockdown() then
		return
	end
	ns.SyncMacro(macro, GetMacroIndexByName(macro.macroName))
end
