local _, ns = ...

--[[
	The per-spell macro options: which options a page macro offers, which the player turned on, and the
	defaults each kind of macro starts from. Features/Macro-Body.lua turns them into macro text.
]]

--[[
	Per-spell settings, on the character's profile, each a table keyed by the spell's name as this client
	gives it: "mouseover" (macro casts on the mouseover unit first), "cursor" (macro casts a ground-targeted
	spell where the cursor points), "focus" (the page also lists a copy of the macro that casts on the focus
	target), "pet" (a summon macro casts the pet's ability while that pet is out), "stance" (the macro switches to a stance the spell can be cast in first), "petAttack"
	(the macro also sends the pet to attack), "stopCast" (the macro stops the current cast first),
	"startAttack" (the macro starts melee auto-attack after the cast), "noToggle" (a form or aspect's macro
	casts "!Name", which never cancels it when it is already on), "castOnSelf" (a friendly spell's macro
	casts on the player when the target can't take it), "targetRank" (a ranked friendly spell's macro
	casts the highest rank its target's level can take, rewritten as the target changes), "fixedRank" (a
	ranked spell's macro always casts this rank, by its text, e.g. "Rank 3"), "targetTarget"
	(a friendly spell's macro tries the target's target after the target), "targetEnemy" (an enemy spell's
	macro targets the nearest enemy first when there is no living hostile target), "targetFriend" (a
	friendly spell's macro targets the nearest friend first when there is no living friendly target), "combatOnly" (the macro
	casts only in combat), "noCombat" (only out of combat; see ns.CombatCheck), "oncePerCombat" (the macro casts once until combat ends or the target changes),
	"oncePerTarget" (the macro casts once until the target changes), "stopAttack" (the macro stops melee
	first), "stopIfChanneling" (the macro does nothing while any spell is channelling), "stopIfStealthed" (the macro does nothing while the player is stealthed), "hideErrors" (the macro clears the error text after), "muteErrors" (the macro mutes error sounds while it runs), "cancelForm" (the macro leaves a form first), "autoShot" (the macro starts Auto Shot,
	or the wand, after the cast) or "groupVersion" (a right-click casts the spell's group version, or a group
	spell's single version). Each is true
	or false where the player set it, overriding the macro kind's default (see KindDefault), and nil where the
	macro follows that default, except "fixedRank", which holds the rank text, or nil for the highest rank.
	"useItems" holds a list of equipment slots instead of a flag: the macro uses
	each slot's item, in that order, before the cast. "groupedSpells" holds a list of spell names too: the
	spells of the macro's SPELL_GROUPS group ticked in its Grouped Spells submenu (see ns.CastSpellName), and
	"targetPriority" a list of units, who it casts on in turn (see ns.TargetPriority), which took over from
	"mouseover", "castOnSelf" and "targetTarget"; those are still read where no list was set. An equipment macro's settings are account-wide instead,
	in ns.db.global.equipmentOptions, like the general macro every character shares, and keyed by its macro
	name ("Use Trinket 1"), so they stay with the slot when the item in it is swapped.
]]
local function SpellSettings(key)
	return ns.db.profile[key]
end

ns.SpellSettings = SpellSettings

--[[
	The key a macro's own settings sit under: the spell's name, or for a copy made with Duplicate the name and
	its number ("Drain Soul #2"), which no spell is called, so a copy's settings are its own.
]]
local function SettingsKey(macro)
	return macro.copy and (macro.name .. " #" .. macro.copy) or macro.name
end

ns.SettingsKey = SettingsKey

-- A macro's own setting for an option: true, false, or nil where it follows the default.
local function GetSetting(macro, key)
	if macro.equipment then
		local options = ns.db.global.equipmentOptions[macro.macroName]
		return options and options[key]
	end
	return SpellSettings(key)[SettingsKey(macro)]
end

-- Stores a macro's own setting for an option; nil drops it. An equipment macro left with none drops its entry.
local function StoreSetting(macro, key, value)
	if not macro.equipment then
		SpellSettings(key)[SettingsKey(macro)] = value
		return
	end
	local all = ns.db.global.equipmentOptions
	local options = all[macro.macroName] or {}
	options[key] = value
	all[macro.macroName] = next(options) and options or nil
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
	menu: who it can be cast on, or where. Equipment macros are a kind of their own (ns.ITEM_KIND); custom
	macros have no kind, and no defaults.
]]
ns.MACRO_KINDS = {
	{ key = "enemy", labelKey = "KIND_ENEMY", descKey = "KIND_ENEMY_DESCRIPTION" },
	{ key = "friendly", labelKey = "KIND_FRIENDLY", descKey = "KIND_FRIENDLY_DESCRIPTION" },
	{ key = "buff", labelKey = "KIND_BUFF", descKey = "KIND_BUFF_DESCRIPTION" },
	{ key = "anyone", labelKey = "KIND_ANYONE", descKey = "KIND_ANYONE_DESCRIPTION" },
	{ key = "ground", labelKey = "KIND_GROUND", descKey = "KIND_GROUND_DESCRIPTION" },
	{ key = "form", labelKey = "KIND_FORM", descKey = "KIND_FORM_DESCRIPTION" },
	{ key = "self", labelKey = "KIND_SELF", descKey = "KIND_SELF_DESCRIPTION" },
}

-- The equipment macros' kind, whose defaults are set on the Macro Defaults panel itself.
ns.ITEM_KIND = { key = "item", labelKey = "KIND_ITEM", descKey = "KIND_ITEM_DESCRIPTION" }

-- A kind's row, spell or item, by its key.
function ns.KindRow(kind)
	if kind == ns.ITEM_KIND.key then
		return ns.ITEM_KIND
	end
	for _, row in ipairs(ns.MACRO_KINDS) do
		if row.key == kind then
			return row
		end
	end
	return nil
end

local TARGET_KINDS = { harm = "enemy", help = "friendly", exists = "anyone" }

--[[
	A spell macro's kind, from the fields Macro-Builder.lua gives it: a ground-targeted spell, then a buff cast
	on a friend (the class lists' buffs), then one cast on an enemy, a friend or either, then a form, stance,
	aura or aspect (the stance bar's forms and the spells that cancel when cast again), and every other spell,
	cast on the player or around them. "item" for an equipment macro, nil for a custom one.
]]
function ns.MacroKind(macro)
	if macro.equipment then
		return ns.ITEM_KIND.key
	end
	if macro.custom then
		return nil
	end
	if macro.cursor then
		return "ground"
	end
	if macro.buff and macro.target == "help" then
		return "buff"
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
	"stopAttack",
	"stopCast",
	"stopIfChanneling",
	"stopIfStealthed",
	"cancelForm",
	"targetEnemy",
	"targetFriend",
	"startAttack",
	"autoShot",
	"petAttack",
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

-- Whether a kind ("enemy", "friendly", ..., "item") turns an option on by default.
function ns.KindDefault(kind, key)
	return DEFAULTABLE[key] == true and ns.db.profile.kindDefaults[kind][key] == true
end

-- Stored as true or false, never nil, so turning off a default the add-on ships on (buffs' targetRank) sticks.
function ns.SetKindDefault(kind, key, on)
	ns.db.profile.kindDefaults[kind][key] = on == true
end

-- Drops a macro's own setting for an option, so it follows its kind's default.
function ns.ClearOwnSetting(macro, key)
	StoreSetting(macro, key, nil)
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
		StoreSetting(macro, key, nil)
	else
		StoreSetting(macro, key, on)
	end
end

--[[
	The page's spell macros of a kind, focus and Duplicate copies left out, building the page's list first when no page has
	built it yet.
]]
function ns.MacrosOfKind(kind)
	if #ns.macros == 0 then
		ns.CollectMacros()
	end
	local list = {}
	for _, macro in ipairs(ns.macros) do
		if macro.kind == kind and not macro.focus and not macro.copy then
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

--[[
	Enemy spell macros offer "petAttack", whatever the class: any class can have a pet out for a while (a
	Shadowfiend, a mind-controlled enemy). A focus copy shares its spell's setting.
]]
function ns.OffersPetAttack(macro)
	return macro.target == "harm" and not macro.custom
end

--[[
	Every spell macro offers "startAttack" except a stealth spell's: attacking would break the stealth. Every
	spell and equipment macro offers "stopCast" too, whatever the class. A focus copy shares its spell's
	settings. Custom macros offer neither, and equipment macros no "startAttack".
]]
function ns.OffersStopCast(macro)
	return not macro.custom
end

function ns.OffersStartAttack(macro)
	return not macro.custom and not macro.equipment and not macro.stealth
end

-- A form or aspect, which casting again would cancel, offers "noToggle".
function ns.OffersNoToggle(macro)
	return macro.toggles == true
end

--[[
	A spell that can be cast on a friend offers "castOnSelf", and so does an equipment macro, whose item may
	take a target. The focus copy ignores it.
]]
function ns.OffersCastOnSelf(macro)
	return macro.target == "help" or macro.target == "exists" or macro.equipment == true
end

--[[
	A friendly spell with more than one rank known offers "targetRank", and so does one whose right-click
	spell has (Arcane Brilliance, right-clicking for Arcane Intellect), which takes its ranks the same way. A
	focus copy shares its setting.
]]
function ns.OffersTargetRank(macro)
	local function ranked(ranks)
		return ranks ~= nil and #ranks > 1
	end
	return ns.OffersCastOnSelf(macro)
		and (ranked(macro.ranks) or (ns.RightClickSpell(macro) ~= nil and ranked(macro.rightClickRanks)))
end

--[[
	A spell with more than one rank, known or not, offers a fixed rank (see ns.AbilityRank); only its known
	ranks (macro.ranks) can be chosen, the rest (macro.unknownRanks) are listed as not known.
]]
function ns.OffersFixedRank(macro)
	return not macro.custom and not macro.equipment and macro.ranks ~= nil
end

-- Whether a macro is a spell's, not a custom or equipment one.
local function IsSpellMacro(macro)
	return not macro.custom and not macro.equipment
end

-- Whether a macro is a spell's or an equipment slot's, not a custom one.
local function IsSpellOrEquipmentMacro(macro)
	return not macro.custom
end

-- An enemy spell offers "targetEnemy".
local function TargetsHarm(macro)
	return macro.target == "harm"
end

-- A friendly spell offers "targetFriend".
local function TargetsHelp(macro)
	return macro.target == "help"
end

-- Whether each option is offered on a macro, by key; ns.OffersOption offers a key missing here on any spell with a target.
local OFFERED = {
	-- an equipment macro's item may take a target, so it can go to the mouseover
	mouseover = function(macro)
		return macro.target ~= nil or macro.equipment
	end,
	-- the Classic Era client, Season of Discovery included, has no focus target, so no focus copy; nor has a duplicate
	focus = function(macro)
		return macro.target ~= nil and ns.FLAVOR ~= "Vanilla" and not macro.copy
	end,
	cursor = function(macro)
		return macro.cursor
	end,
	pet = function(macro)
		return macro.petAbility ~= nil
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
	--[[
		melee after a heal or buff is almost never wanted, so those kinds leave it out, except where it is on
		already, so it can be turned off
	]]
	startAttack = function(macro)
		if not ns.OffersStartAttack(macro) then
			return false
		end
		if macro.kind ~= "friendly" and macro.kind ~= "buff" then
			return true
		end
		local on = GetSetting(macro, "startAttack")
		if on == nil then
			return MacroDefault(macro, "startAttack")
		end
		return on == true
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
	targetFriend = TargetsHelp,
	combatOnly = IsSpellOrEquipmentMacro,
	noCombat = IsSpellOrEquipmentMacro,
	oncePerCombat = IsSpellMacro,
	oncePerTarget = IsSpellMacro,
	stopAttack = IsSpellMacro,
	stopIfChanneling = IsSpellOrEquipmentMacro,
	stopIfStealthed = IsSpellOrEquipmentMacro,
	hideErrors = IsSpellOrEquipmentMacro,
	muteErrors = IsSpellOrEquipmentMacro,
	--[[
		whatever the class; leaving a form makes no sense on a form itself (a toggle or the stance bar's own), or
		on stealth, which needs Cat Form
	]]
	cancelForm = function(macro)
		return IsSpellMacro(macro) and not macro.toggles and not macro.noGlow and not macro.stealth
	end,
	-- a ranged enemy spell, but not the ranged attack itself
	autoShot = function(macro)
		local autoShot = ns.ClassConfig().autoShot
		return autoShot ~= nil and macro.target == "harm" and macro.name ~= autoShot
	end,
	--[[
		a single-target spell whose group version (Prayer of Fortitude, Portal: Ironforge) is learned, or a group
		spell whose single version is
	]]
	groupVersion = function(macro)
		return ns.RightClickSpell(macro) ~= nil
	end,
}

--[[
	Whether a macro offers an option: "mouseover", "cursor", "focus", "pet", "stance",
	"petAttack", "stopCast", "startAttack", "noToggle", "castOnSelf", "targetRank", "targetTarget",
	"targetEnemy", "targetFriend", "combatOnly", "noCombat", "oncePerCombat", "oncePerTarget", "stopAttack", "stopIfChanneling",
	"stopIfStealthed", "hideErrors",
	"muteErrors", "cancelForm", "autoShot" or "groupVersion".
]]
function ns.OffersOption(macro, key)
	local offered = OFFERED[key]
	if offered then
		return offered(macro) and true or false
	end
	return macro.target ~= nil
end

-- The full label of the "autoShot" option for the player's class (Auto Shot, or the wand), or nil.
function ns.AutoShotLabelKey()
	return ns.ClassConfig().autoShotLabelKey
end

-- The client's name for the ranged attack the "autoShot" option starts (Auto Shot, or the wand's Shoot), or nil.
function ns.AutoShotName()
	return ns.ClassConfig().autoShot
end

-- The spell the "groupVersion" option casts on a right-click: the group version, or a group spell's single version.
function ns.RightClickSpell(macro)
	return macro.groupSpell or macro.soloSpell
end

-- Whether a macro offers an option (see ns.OffersOption) and the player turned it on.
function ns.IsOptionOn(macro, key)
	if not ns.OffersOption(macro, key) then
		return false
	end
	local on = GetSetting(macro, key)
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
	return macro.target ~= nil or macro.cursor or macro.petAbility ~= nil or macro.stances ~= nil
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
	return SpellSettings("useItems")[SettingsKey(macro)] or NO_SLOTS
end

-- A slot's place in a macro's UseItemSlots, or nil when the macro doesn't use it.
function ns.IsUsingSlot(macro, slot)
	for i, used in ipairs(ns.UseItemSlots(macro)) do
		if used == slot then
			return i
		end
	end
end

--[[
	Whether a macro has an options menu: every spell macro does, for stopCast or startAttack, and every
	equipment macro, for its combat check, targeting and error options.
]]
function ns.HasOptions(macro)
	return ns.HasCastOptions(macro)
		or ns.OffersStopCast(macro)
		or ns.OffersStartAttack(macro)
		or ns.OffersUseItems(macro)
		or macro.equipment == true
end

--[[
	The setters below only change the stored settings; ns.ChangeMacro runs one and rewrites the macro.
]]

-- Rebuilds the macro's body after a setting changes and rewrites the macro if it already exists.
local function Rewrite(macro)
	macro.body = ns.MacroBody(macro)
	if InCombatLockdown() then
		ns.QueueMacroSync()
		return
	end
	ns.SyncMacro(macro)
end

--[[
	Runs change (a function that calls the setters below) and rewrites the macro if it already exists. In
	combat the rewrite waits until combat ends. The focus setting adds or removes a page entry and most others
	also change the focus copy, so the page must be rebuilt after (see the menu in Macro-Menu.lua).
]]
function ns.ChangeMacro(macro, change)
	change()
	Rewrite(macro)
end

-- Sets a setting (any ns.OffersOption key) on or off.
function ns.SetOption(macro, key, on)
	SetOption(macro, key, on)
end

function ns.ToggleOption(macro, key)
	SetOption(macro, key, not ns.IsOptionOn(macro, key))
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

function ns.SetCombatCheck(macro, check)
	for _, key in ipairs(COMBAT_CHECKS) do
		SetOption(macro, key, key == check)
	end
end

--[[
	How often the macro casts, a choice of one: "oncePerCombat" (once until combat ends or the target
	changes), "oncePerTarget" (once until the target changes), or nil for every press, the default. Both on,
	as a release before the choice could store, is once per combat, as the macro text reads it.
]]
local REPEAT_RULES = { "oncePerCombat", "oncePerTarget" }

function ns.RepeatRule(macro)
	for _, key in ipairs(REPEAT_RULES) do
		if ns.IsOptionOn(macro, key) then
			return key
		end
	end
	return nil
end

function ns.SetRepeatRule(macro, rule)
	for _, key in ipairs(REPEAT_RULES) do
		SetOption(macro, key, key == rule)
	end
end

-- The rank text the macro is fixed to, or nil when it isn't, or that rank isn't among its known ranks.
function ns.FixedRank(macro)
	local text = ns.OffersFixedRank(macro) and SpellSettings("fixedRank")[SettingsKey(macro)]
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

function ns.SetAbilityRank(macro, choice)
	SetOption(macro, "targetRank", choice == "targetRank")
	SpellSettings("fixedRank")[SettingsKey(macro)] = choice ~= "targetRank" and choice or nil
end

--------------------------------------------------------------------------------
-- Target Priority
--------------------------------------------------------------------------------

--[[
	Who a macro casts on, in turn: a list of up to TARGET_PRIORITY_SLOTS units ("targetPriority"), each tried
	only when it can take the spell, then a plain cast. Each unit is { unit, menu label key }, in the order the
	Target submenu lists them. A macro follows its kind's list (kindDefaults[kind].targetPriority) until it is
	given its own. A list nobody set comes from the checkboxes it replaced, Cast On Mouseover, Cast On Self and
	Cast On Target's Target: the mouseover, the target, the target's target, then the player, so a profile from
	before keeps casting as it did, without a migration.
]]
ns.TARGET_UNITS = {
	{ "target", "MENU_UNIT_TARGET" },
	{ "player", "MENU_UNIT_SELF" },
	{ "pet", "MENU_UNIT_PET" },
	{ "focus", "MENU_UNIT_FOCUS" },
	{ "targettarget", "MENU_UNIT_TARGETS_TARGET" },
	{ "mouseover", "MENU_UNIT_MOUSEOVER" },
}
ns.TARGET_PRIORITY_SLOTS = 3

local DEFAULT_PRIORITY = { "target" }
local LEGACY_TARGETING = { "mouseover", "castOnSelf", "targetTarget" }
-- an enemy spell can't go on the player or the pet
local HARM_UNITS = { player = false, pet = false }

--[[
	Whether a kind's macros cast on someone, so take a target priority: a spell cast on an enemy, a friend or
	either, and an equipment macro. Ground spells, forms and the rest have no one to pick.
]]
local PRIORITY_KINDS = { enemy = true, friendly = true, buff = true, anyone = true, item = true }

function ns.KindOffersTargetPriority(kind)
	return PRIORITY_KINDS[kind] == true
end

-- Whether a unit can be picked for a kind: not the player or the pet for an enemy spell, nor the focus without one.
function ns.KindOffersUnit(kind, unit)
	if unit == "focus" and ns.FLAVOR == "Vanilla" then
		return false
	end
	return kind ~= "enemy" or HARM_UNITS[unit] ~= false
end

-- A macro's own list, a focus copy keeping its own focus-then-target cast.
function ns.OffersTargetPriority(macro)
	return not macro.focus and ns.KindOffersTargetPriority(macro.kind)
end

-- The list the old checkboxes give, from whether each is on.
local function LegacyPriority(isOn)
	local list = {}
	if isOn("mouseover") then
		list[#list + 1] = "mouseover"
	end
	list[#list + 1] = "target"
	if isOn("targetTarget") then
		list[#list + 1] = "targettarget"
	end
	if isOn("castOnSelf") then
		list[#list + 1] = "player"
	end
	return list
end

-- A list with the units a kind can't pick, and any unit a second time, left out; the target alone when that leaves none.
local function Usable(list, kind)
	local usable, seen = {}, {}
	for _, unit in ipairs(list) do
		if not seen[unit] and ns.KindOffersUnit(kind, unit) then
			seen[unit] = true
			usable[#usable + 1] = unit
		end
	end
	return #usable > 0 and usable or DEFAULT_PRIORITY
end

-- A kind's list: the one set on its Macro Defaults panel, or the one its old checkbox defaults give.
function ns.KindTargetPriority(kind)
	local list = ns.db.profile.kindDefaults[kind].targetPriority
	if type(list) ~= "table" then
		list = LegacyPriority(function(key)
			return ns.KindDefault(kind, key)
		end)
	end
	return Usable(list, kind)
end

-- Sets a kind's list, which replaces its old checkbox defaults.
function ns.SetKindTargetPriority(kind, list)
	local defaults = ns.db.profile.kindDefaults[kind]
	defaults.targetPriority = list
	for _, key in ipairs(LEGACY_TARGETING) do
		defaults[key] = false
	end
end

-- Whether the macro has an old checkbox setting of its own, which it then keeps following until given a list.
local function HasLegacyTargeting(macro)
	for _, key in ipairs(LEGACY_TARGETING) do
		if GetSetting(macro, key) ~= nil then
			return true
		end
	end
	return false
end

-- The macro's list, in order. Don't modify it.
function ns.TargetPriority(macro)
	if not ns.OffersTargetPriority(macro) then
		return NO_SLOTS
	end
	local own = GetSetting(macro, "targetPriority")
	if type(own) == "table" then
		return Usable(own, macro.kind)
	end
	if HasLegacyTargeting(macro) then
		return Usable(
			LegacyPriority(function(key)
				return ns.IsOptionOn(macro, key)
			end),
			macro.kind
		)
	end
	return ns.KindTargetPriority(macro.kind)
end

-- Whether the macro tries a unit, such as the mouseover, which rewrites its Dynamic Rank as that unit changes.
function ns.TriesUnit(macro, unit)
	for _, tried in ipairs(ns.TargetPriority(macro)) do
		if tried == unit then
			return true
		end
	end
	return false
end

-- Whether the macro's list is anything but the target alone, which is just the plain cast.
function ns.HasTargetPriority(macro)
	local list = ns.TargetPriority(macro)
	return #list > 1 or (list[1] ~= nil and list[1] ~= "target")
end

-- Whether two lists hold the same units in the same order.
local function SameList(a, b)
	if #a ~= #b then
		return false
	end
	for i = 1, #a do
		if a[i] ~= b[i] then
			return false
		end
	end
	return true
end

--[[
	A list with unit picked at a place in it, from 1: a unit taken lower down moves up to this place, the one
	it replaces and those after it move down a place (the last drops off past three), and nil (None, never
	for the first) ends the list here.
]]
local function PlaceUnit(current, place, unit)
	local list = {}
	for i, tried in ipairs(current) do
		if i < place and tried ~= unit then
			list[#list + 1] = tried
		end
	end
	if unit then
		list[#list + 1] = unit
		for i, tried in ipairs(current) do
			if i >= place and tried ~= unit and #list < ns.TARGET_PRIORITY_SLOTS then
				list[#list + 1] = tried
			end
		end
	end
	return list
end

-- Picks the unit at a place in a kind's list (see PlaceUnit), as its Macro Defaults panel does.
function ns.SetKindTargetPriorityUnit(kind, place, unit)
	ns.SetKindTargetPriority(kind, PlaceUnit(ns.KindTargetPriority(kind), place, unit))
end

--[[
	Picks the unit at a place in the macro's list (see PlaceUnit). Stored only where it differs from the kind's
	list, and the old checkbox settings go, since the list replaces them.
]]
function ns.SetTargetPriorityUnit(macro, place, unit)
	local list = PlaceUnit(ns.TargetPriority(macro), place, unit)
	for _, key in ipairs(LEGACY_TARGETING) do
		StoreSetting(macro, key, nil)
	end
	StoreSetting(macro, "targetPriority", not SameList(list, ns.KindTargetPriority(macro.kind)) and list or nil)
end

-- Makes the macro's list its kind's, and has the macro follow it.
function ns.MakeTargetPriorityDefault(macro)
	local list = {}
	for i, unit in ipairs(ns.TargetPriority(macro)) do
		list[i] = unit
	end
	ns.SetKindTargetPriority(macro.kind, list)
	StoreSetting(macro, "targetPriority", nil)
	for _, key in ipairs(LEGACY_TARGETING) do
		StoreSetting(macro, key, nil)
	end
end

-- Adds an equipment slot to the end of the macro's useItems list, or removes it.
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
	SpellSettings("useItems")[SettingsKey(macro)] = #slots > 0 and slots or nil
end

--[[
	A spell in a SPELL_GROUPS group (Demon Skin, Demon Armor) offers the group's spells, a focus copy sharing its
	spell's. Ticked, a spell is one the macro may cast; the macro casts the last one learned of those ticked, so
	it moves up as the player trains. Only the spell itself is ticked to start with.
]]
function ns.OffersGroupedSpells(macro)
	return IsSpellMacro(macro) and macro.groupMembers ~= nil
end

-- The names ticked in the macro's group, in the group's order. Don't modify it.
function ns.GroupedSpells(macro)
	if not ns.OffersGroupedSpells(macro) then
		return NO_SLOTS
	end
	return SpellSettings("groupedSpells")[SettingsKey(macro)] or { macro.name }
end

function ns.IsGroupedSpellOn(macro, name)
	for _, ticked in ipairs(ns.GroupedSpells(macro)) do
		if ticked == name then
			return true
		end
	end
	return false
end

-- Whether the macro's group has any spell ticked but its own, which is when the group changes the macro.
function ns.IsGrouped(macro)
	for _, ticked in ipairs(ns.GroupedSpells(macro)) do
		if ticked ~= macro.name then
			return true
		end
	end
	return false
end

--[[
	Ticks or unticks a spell of the macro's group. Unticking the last one ticks the macro's own spell again,
	and only that ticked is stored as nil, the default.
]]
function ns.ToggleGroupedSpell(macro, name)
	local on = not ns.IsGroupedSpellOn(macro, name)
	local list = {}
	for _, member in ipairs(macro.groupMembers) do
		local ticked = on
		if member.name ~= name then
			ticked = ns.IsGroupedSpellOn(macro, member.name)
		end
		if ticked then
			list[#list + 1] = member.name
		end
	end
	local own = #list == 0 or (#list == 1 and list[1] == macro.name)
	SpellSettings("groupedSpells")[SettingsKey(macro)] = not own and list or nil
end

--[[
	The spell the macro casts: of its group's ticked spells, the last one learned, or its own spell when its
	group has none of them learned, or it has no group.
]]
function ns.CastSpellName(macro)
	local cast
	for _, member in ipairs(ns.OffersGroupedSpells(macro) and macro.groupMembers or NO_SLOTS) do
		if member.learned and ns.IsGroupedSpellOn(macro, member.name) then
			cast = member.name
		end
	end
	return cast or macro.name
end
