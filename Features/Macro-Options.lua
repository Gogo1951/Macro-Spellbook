local _, ns = ...

--[[
	The per-spell macro options: which options a page macro offers, which the player turned on, and the
	defaults each kind of macro starts from. Features/Macro-Body.lua turns them into macro text.
]]

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
	or the wand, after the cast) or "groupVersion" (a right-click casts the spell's group version). Each is true
	or false where the player set it, overriding the macro kind's default (see KindDefault), and nil where the
	macro follows that default. "useItems" holds a list of equipment slots instead of a flag: the macro uses
	each slot's item, in that order, before the cast.
]]
local function SpellSettings(key)
	return ns.db.profile[key]
end

ns.SpellSettings = SpellSettings

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
	Whether the macro was marked placed by Mark All Spells As Placed, which stops it glowing wherever it is.
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

-- Undoes Mark All Spells As Placed, so every macro not on the bars glows again.
function ns.ClearPlacedMarks()
	wipe(ns.db.profile.markedPlaced)
end

function ns.HasPlacedMarks()
	return next(ns.db.profile.markedPlaced) ~= nil
end

--[[
	The kinds of spell macro, in the order the options list them. A spell's kind is what decides most of its
	menu: who it can be cast on, or where. Custom and equipment macros have no kind, and no defaults.
]]
ns.MACRO_KINDS = {
	{ key = "enemy", labelKey = "KIND_ENEMY", descKey = "KIND_ENEMY_DESCRIPTION" },
	{ key = "friendly", labelKey = "KIND_FRIENDLY", descKey = "KIND_FRIENDLY_DESCRIPTION" },
	{ key = "anyone", labelKey = "KIND_ANYONE", descKey = "KIND_ANYONE_DESCRIPTION" },
	{ key = "ground", labelKey = "KIND_GROUND", descKey = "KIND_GROUND_DESCRIPTION" },
	{ key = "form", labelKey = "KIND_FORM", descKey = "KIND_FORM_DESCRIPTION" },
	{ key = "self", labelKey = "KIND_SELF", descKey = "KIND_SELF_DESCRIPTION" },
}

local TARGET_KINDS = { harm = "enemy", help = "friendly", exists = "anyone" }

--[[
	A spell macro's kind, from the fields Macro-Builder.lua gives it: a ground-targeted spell, then one cast on
	an enemy, a friend or either, then a form, stance, aura or aspect (the stance bar's forms and the spells
	that cancel when cast again), and every other spell, cast on the player or around them. Nil for custom and
	equipment macros.
]]
function ns.MacroKind(macro)
	if macro.custom or macro.equipment then
		return nil
	end
	if macro.cursor then
		return "ground"
	end
	if macro.target then
		return TARGET_KINDS[macro.target]
	end
	if macro.noGlow or macro.toggles then
		return "form"
	end
	return "self"
end

--[[
	The options a kind can turn on by default. The ones left out belong to one spell rather than a kind: the
	focus copy, the pet's ability, the stance, the group version, a fixed rank and the items used first.
]]
ns.DEFAULTABLE_OPTIONS = {
	"mouseover",
	"castOnSelf",
	"targetTarget",
	"cursor",
	"targetRank",
	"stopCast",
	"stopAttack",
	"cancelForm",
	"targetEnemy",
	"petAttack",
	"startAttack",
	"autoShot",
	"spam",
	"raidRank1",
	"oncePerTarget",
	"oncePerCombat",
	"noToggle",
	"combatOnly",
	"noCombat",
	"hideErrors",
	"muteErrors",
}

local DEFAULTABLE = {}
for _, key in ipairs(ns.DEFAULTABLE_OPTIONS) do
	DEFAULTABLE[key] = true
end

-- Whether a kind ("enemy", "friendly", ...) turns an option on by default.
function ns.KindDefault(kind, key)
	return DEFAULTABLE[key] == true and ns.db.profile.kindDefaults[kind][key] == true
end

function ns.SetKindDefault(kind, key, on)
	ns.db.profile.kindDefaults[kind][key] = on or nil
end

-- The default a macro follows for an option it has no setting of its own for.
local function MacroDefault(macro, key)
	return macro.kind ~= nil and ns.KindDefault(macro.kind, key)
end

--[[
	Sets an option on a macro, stored only where it differs from the macro kind's default, so the rest follow
	a change of default.
]]
local function SetOption(macro, key, on)
	if on == MacroDefault(macro, key) then
		SpellSettings(key)[macro.name] = nil
	else
		SpellSettings(key)[macro.name] = on
	end
end

--[[
	The page's spell macros of a kind, focus copies left out, building the page's list first when no page has
	built it yet.
]]
function ns.MacrosOfKind(kind)
	if #ns.macros == 0 then
		ns.CollectMacros()
	end
	local list = {}
	for _, macro in ipairs(ns.macros) do
		if macro.kind == kind and not macro.focus then
			list[#list + 1] = macro
		end
	end
	return list
end

-- Whether any macro turns "targetRank" on, by its own setting or its kind's default.
function ns.AnyTargetRank()
	for _, on in pairs(SpellSettings("targetRank")) do
		if on then
			return true
		end
	end
	for _, kind in ipairs(ns.MACRO_KINDS) do
		if ns.KindDefault(kind.key, "targetRank") then
			return true
		end
	end
	return false
end

-- Whether the player's class has a combat pet, which turns on the "petAttack" option.
function ns.ClassOffersPetAttack()
	return ns.ClassConfig().petAttack
end

-- Enemy spell macros offer "petAttack" when the class does. A focus copy shares its spell's setting.
function ns.OffersPetAttack(macro)
	return ns.ClassOffersPetAttack() and macro.target == "harm" and not macro.custom
end

-- Whether the player's class is a melee one: it has no "stopCast" option.
function ns.IsMeleeClass()
	return ns.ClassConfig().melee
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
		return IsSpellMacro(macro) and ns.ClassConfig().forms and not macro.toggles and not macro.stealth
	end,
	-- a ranged enemy spell, but not the ranged attack itself
	autoShot = function(macro)
		local autoShot = ns.ClassConfig().autoShot
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
	return ns.ClassConfig().autoShotLabelKey
end

-- The client's name for the ranged attack the "autoShot" option starts (Auto Shot, or the wand's Shoot), or nil.
function ns.AutoShotName()
	return ns.ClassConfig().autoShot
end

-- Whether a macro offers an option (see ns.OffersOption) and the player turned it on.
function ns.IsOptionOn(macro, key)
	if not ns.OffersOption(macro, key) then
		return false
	end
	local on = SpellSettings(key)[macro.name]
	if on == nil then
		return MacroDefault(macro, key)
	end
	return on == true
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
	return SpellSettings("useItems")[macro.name] or NO_SLOTS
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

-- Rebuilds the macro's body after a setting changes and rewrites the macro if it already exists.
local function Rewrite(macro)
	macro.body = ns.MacroBody(macro)
	if InCombatLockdown() then
		return
	end
	ns.SyncMacro(macro)
end

--[[
	Flips a setting (any ns.OffersOption key) and rewrites the macro if it already exists. In combat the
	rewrite waits until the next pickup. The focus setting adds or removes a page entry and most others also
	change the focus copy, so the page must be rebuilt after them (see the menu in Spellbook-Page.lua).
]]
function ns.ToggleOption(macro, key)
	SetOption(macro, key, not ns.IsOptionOn(macro, key))
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
		SetOption(macro, key, key == check)
	end
	Rewrite(macro)
end

-- The rank text the macro is fixed to, or nil when it isn't, or that rank isn't among its known ranks.
function ns.FixedRank(macro)
	local text = ns.OffersFixedRank(macro) and SpellSettings("fixedRank")[macro.name]
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
	SetOption(macro, "targetRank", choice == "targetRank")
	SpellSettings("fixedRank")[macro.name] = choice ~= "targetRank" and choice or nil
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
	SpellSettings("useItems")[macro.name] = #slots > 0 and slots or nil
	Rewrite(macro)
end
