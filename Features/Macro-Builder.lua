local _, ns = ...
local L = ns.L

--[[
	Builds the page's macro list (ns.macros) from the spellbook and the class's spell lists
	(ns.CLASS_SPELL_LISTS, from the flavor's data folder). The lists hold spell IDs; every name comes from the
	client, so the page sorts and builds the same in every locale. No frames here: Features/Spellbook-Page.lua
	draws the page. The options live in Features/Macro-Options.lua, the macro text in Features/Macro-Body.lua,
	and the Custom and Equipment sections in their own files.
]]

local MacroBody = ns.MacroBody
local StancesOf = ns.StancesOf

local FOCUS_SUFFIX = " @F" -- ends a focus copy's WoW macro name, keeping it apart from the spell's own

local UNLISTED = math.huge -- the Unlearned section sorts after everything else
--[[
	The menu label of the ranged attack the "autoShot" option starts after a cast, by class: Auto Shot, or
	the wand's Shoot. The spell is the class lists' autoShot, which a flavor without one leaves out.
]]
local AUTO_SHOT_LABEL_KEYS = {
	HUNTER = "MENU_START_AUTO_SHOT",
	MAGE = "MENU_START_WAND",
	PRIEST = "MENU_START_WAND",
	WARLOCK = "MENU_START_WAND",
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

ns.SpellName = SpellName

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

local config -- the player's class lists, resolved to this client's names by ns.CollectMacros

-- Resolves the player's class lists to the names this client gives their spells.
local function ResolveClassConfig()
	local class = select(2, UnitClass("player"))
	local lists = ns.CLASS_SPELL_LISTS[class] or {}
	config = {
		autoShot = lists.autoShot and SpellName(lists.autoShot),
		autoShotLabelKey = lists.autoShot and AUTO_SHOT_LABEL_KEYS[class],
		groupSpells = {},
		categoryRankByName = {}, -- each spellbook tab's name -> its section rank, filled by ns.CollectMacros
		extraSpells = lists.extraSpells or NO_IDS,
		petAbilities = {},
		stances = {},
		stanceSlots = {},
		hasStances = lists.stances ~= nil,
		formSpells = {},
		enemySpells = NameIndex(lists.mouseoverEnemy),
		friendSpells = NameIndex(lists.mouseoverFriend),
		buffSpells = NameIndex(lists.buffs),
		cursorSpells = NameIndex(lists.cursor),
		stealthSpells = NameIndex(lists.stealth),
		toggleSpells = NameIndex(lists.noToggle),
	}
	for summonId, pet in pairs(lists.petAbilities or NO_IDS) do
		local summon, ability = SpellName(summonId), SpellName(pet.abilityId)
		local family = C_CreatureInfo.GetCreatureFamilyInfo(pet.familyId)
		if summon and ability and family and family.name then
			config.petAbilities[summon] = { ability = ability, family = family.name }
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
		never do, and stealth, which Stop Macro If Stealthed keeps on
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

-- The player's class lists, resolved to this client's names on first use and again by ns.CollectMacros.
local function ClassConfig()
	return config or ResolveClassConfig()
end

ns.ClassConfig = ClassConfig

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

--[[
	One macro per learned class spell (and unlearned one, when shown) with its focus copy when that's on, plus
	the player's custom macros and the equipment macros, in page order. Rebuilt each time the page opens.
]]
ns.macros = {}

--[[
	section is { rank, name, priority }: the spell's spellbook tab, or the Unlearned section. ranks is the
	spell's ReadSpellbook ranks entry, or nil; groupSpell its learned group version's name, or nil.
]]
local function MakeMacro(name, icon, unlearned, id, section, ranks, groupSpell)
	local c = ClassConfig()
	local pet = c.petAbilities[name]
	local macro = {
		name = name,
		spellID = id,
		unlearned = unlearned,
		categoryRank = section[1],
		priority = section[3],
		category = section[2],
		noGlow = c.formSpells[name] == true,
		target = TargetOf(name, id),
		buff = c.buffSpells[name] ~= nil,
		cursor = c.cursorSpells[name] ~= nil,
		petAbility = pet and pet.ability,
		petFamily = pet and pet.family,
		stealth = c.stealthSpells[name] ~= nil,
		stances = StancesOf(name),
		toggles = c.toggleSpells[name] ~= nil,
		ranks = ranks and ranks.known,
		unknownRanks = ranks and ranks.unknown,
		groupSpell = groupSpell,
		macroName = ns.TrimMacroName(name),
		-- the question mark icon lets #showtooltip show the spell's own icon on the action bar
		macroIcon = ns.ICON_QUESTION_MARK,
		icon = icon or ns.ICON_QUESTION_MARK,
	}
	macro.kind = ns.MacroKind(macro)
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
	copy.macroName = ns.TrimMacroName(macro.name, ns.MACRO_NAME_MAX_LENGTH - #FOCUS_SUFFIX) .. FOCUS_SUFFIX
	copy.body = MacroBody(copy)
	return copy
end

--[[
	A copy of a spell macro made with Duplicate (see ns.DuplicateMacro): the same spell, named with its
	number, with settings of its own (ns.SettingsKey) and no focus copy.
]]
local function MakeCopyMacro(macro, number)
	local copy = {}
	for key, value in pairs(macro) do
		copy[key] = value
	end
	local suffix = " " .. number
	copy.copy = number
	copy.label = macro.name .. suffix
	copy.macroName = ns.TrimMacroName(macro.name, ns.MACRO_NAME_MAX_LENGTH - #suffix) .. suffix
	copy.body = MacroBody(copy)
	return copy
end

--[[
	Each spell id's learn level: the class's trainer data (the rows for this character's faction and race),
	then the trainers this character recorded. The client's own answer (C_Spell.GetSpellLevelLearned, where it
	has one) fills the rest.
]]
local function LearnLevels()
	local levels = {}
	local faction, race = UnitFactionGroup("player"), select(3, UnitRace("player"))
	for _, row in ipairs(ns.TRAINER_SPELLS and ns.TRAINER_SPELLS[select(2, UnitClass("player"))] or NO_IDS) do
		if (not row.faction or row.faction == faction) and (not row.race or row.race == race) then
			levels[row.id] = row.level
		end
	end
	for id, level in pairs(ns.db.profile.trainerSpells) do
		levels[id] = levels[id] or level
	end
	return levels
end

--[[
	Trainer rank ids whose names weren't loaded when the spellbook was last read, so their ranks were left out;
	SPELL_DATA_LOAD_RESULT redraws the open page as each arrives (see ns.TakePendingRank).
]]
local pendingRanks = {}

-- Whether id is a rank ReadSpellbook left out for want of its name; clears it, so it redraws the page once.
function ns.TakePendingRank(id)
	local pending = pendingRanks[id] == true
	pendingRanks[id] = nil
	return pending
end

--[[
	One pass over the spellbook: the ranks of each learned spell with more than one, as
	name -> { known = { { text = "Rank 4", level = 38 }, ... }, unknown = { ... } or nil }, each list highest
	first (a rank whose learn level isn't known is left out), and every learned spell's name, as name -> true.
	Classic's book lists only each spell's highest rank unless Show All Spell Ranks is ticked, so the known
	trainer ranks are added from their ids as well, then the trainer ranks not learned yet.
]]
local function ReadSpellbook()
	local levels, byName, learned, listed = LearnLevels(), {}, {}, {}
	local levelLearned = C_Spell.GetSpellLevelLearned
	local function addRank(name, subName, level, unknown)
		if name and subName and subName ~= "" and level and level > 0 and not listed[name .. subName] then
			listed[name .. subName] = true
			byName[name] = byName[name] or {}
			table.insert(byName[name], { text = subName, level = level, unknown = unknown })
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
	-- after the known ranks, so a known rank's text is never taken by an unknown id of the same name
	wipe(pendingRanks)
	for id, level in pairs(levels) do
		if not IsPlayerSpell(id) then
			local name = SpellName(id)
			if not name then
				pendingRanks[id] = true
			elseif learned[name] then
				addRank(name, C_Spell.GetSpellSubtext(id), level, true)
			end
		end
	end
	local ranks = {}
	for name, list in pairs(byName) do
		if #list > 1 then
			table.sort(list, function(a, b)
				return a.level > b.level
			end)
			local known, unknown = {}, {}
			for _, rank in ipairs(list) do
				table.insert(rank.unknown and unknown or known, rank)
			end
			if #known > 0 then
				ranks[name] = { known = known, unknown = #unknown > 0 and unknown or nil }
			end
		end
	end
	return ranks, learned
end

--[[
	The targetRank macros pick their ranks by the levels of the units they cast on, so a new target rewrites
	them all, and a new mouseover only those that also cast on the mouseover. A burst of changes is rewritten
	once, on the next frame, the page's list built first when no page has built it yet. Out of combat only:
	in combat a macro keeps the ranks it last had, so a lower rank is only ever held while the low-level unit
	is still there. The game says when a new unit comes under the cursor but not when the cursor leaves one,
	so while a mouseover is out the rewrite watches for it to go and rewrites back to the highest rank; and
	entering combat rewrites every one at once, the last moment the macros can change, so combat starts on
	the highest rank wherever no low-level unit is targeted or under the cursor.
]]
local pendingRankRewrite -- nil, or "mouseover" or "all" while a rewrite waits for the next frame
local WatchMouseover

--[[
	Whether the WoW macros carry the targetRank bodies ns.macros holds. A rebuilt list's bodies were never
	written, so the next rewrite writes every one; after that only a body that changed is written, so most
	mouseovers don't read the macro list at all.
]]
local rankBodiesSynced = false

local function RanksRewritable()
	return ns.db and not InCombatLockdown() and ns.AnyTargetRank()
end

local function RewriteRankMacros()
	local mouseoverOnly = pendingRankRewrite == "mouseover"
	pendingRankRewrite = nil
	if not RanksRewritable() then
		return
	end
	if #ns.macros == 0 then
		ns.CollectMacros()
	end
	local writeAll = not rankBodiesSynced
	local changed = {}
	for _, macro in ipairs(ns.macros) do
		if
			ns.IsOptionOn(macro, "targetRank")
			and (writeAll or not mouseoverOnly or ns.IsOptionOn(macro, "mouseover"))
		then
			local body = MacroBody(macro)
			if writeAll or body ~= macro.body then
				macro.body = body
				changed[#changed + 1] = macro
			end
		end
	end
	rankBodiesSynced = true
	if #changed > 0 then
		local indexes = ns.ReadMacroIndexes()
		for _, macro in ipairs(changed) do
			ns.SyncMacro(macro, indexes)
		end
	end
	WatchMouseover()
end

local function QueueRankRewrite(scope)
	if not RanksRewritable() then
		return
	end
	if not pendingRankRewrite then
		C_Timer.After(0, RewriteRankMacros)
	end
	if scope == "all" or not pendingRankRewrite then
		pendingRankRewrite = scope
	end
end

local MOUSEOVER_POLL_SECONDS = 0.2
local watchingMouseover = false

-- Checks for the mouseover to have gone until it does, then rewrites the mouseover macros for no unit.
local function PollMouseover()
	if UnitExists("mouseover") and RanksRewritable() then
		C_Timer.After(MOUSEOVER_POLL_SECONDS, PollMouseover)
		return
	end
	watchingMouseover = false
	QueueRankRewrite("mouseover")
end

function WatchMouseover()
	if not watchingMouseover and UnitExists("mouseover") then
		watchingMouseover = true
		C_Timer.After(MOUSEOVER_POLL_SECONDS, PollMouseover)
	end
end

function ns:OnPlayerTargetChanged()
	QueueRankRewrite("all")
end

function ns:OnUpdateMouseoverUnit()
	QueueRankRewrite("mouseover")
end

-- Fires just before combat locks the macros, so the rewrite runs now rather than on the next frame.
function ns:OnPlayerRegenDisabled()
	if RanksRewritable() then
		pendingRankRewrite = "all"
		RewriteRankMacros()
	end
end

--[[
	Rebuilds ns.macros: the learned spells (from the spellbook), the player's custom macros and the
	equipped items with a "Use:" effect, plus the spells not learned yet when ns.ShowsUnlearned().
]]
function ns.CollectMacros()
	wipe(ns.macros)
	rankBodiesSynced = false
	ResolveClassConfig()
	local taken, seen = {}, {}
	local ranks, learned = ReadSpellbook()
	-- learnLevel and learnTalent say when an unlearned spell can be learned, for its note and tooltip
	local function add(name, icon, unlearned, id, section, learnLevel, learnTalent)
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
		macro.learnLevel, macro.learnTalent = learnLevel, learnTalent
		-- a custom macro already uses the name
		if unlearned and taken[macro.macroName] then
			return
		end
		taken[macro.macroName] = true
		ns.macros[#ns.macros + 1] = macro
		if ns.IsOptionOn(macro, "focus") then
			local copy = MakeFocusMacro(macro)
			taken[copy.macroName] = true
			ns.macros[#ns.macros + 1] = copy
		end
		if not unlearned then
			for _, number in ipairs(ns.MacroCopies(name)) do
				local copy = MakeCopyMacro(macro, number)
				taken[copy.macroName] = true
				ns.macros[#ns.macros + 1] = copy
			end
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
	ns.AddCustomMacros(taken)
	ns.AddEquipmentMacros(taken)
	if ns.ShowsUnlearned() and ns.ForEachUnlearnedSpell then
		ns.ForEachUnlearnedSpell(function(name, icon, id, level, talent)
			position = position + 1
			add(name, icon, true, id, { UNLISTED, L["SECTION_UNLEARNED"], position }, level, talent)
		end, seen)
	end
	--[[
		by section; within one, spells before custom macros, then spellbook (or learn level) order, then by
		name, each focus copy right after its spell and each Duplicate copy after those, by number
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
		if (a.copy or 1) ~= (b.copy or 1) then
			return (a.copy or 1) < (b.copy or 1)
		end
		return not a.focus and b.focus == true
	end)
end
