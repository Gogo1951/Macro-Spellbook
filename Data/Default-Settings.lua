local _, ns = ...

--[[
	Per-Character model: the recorded trainer spells differ from character to character, and the macro options
	ride the profile with them, since which spells a page lists is per class. Which macros the add-on made is a
	fact about the account's and the character's macro lists, not a setting, so it lives in global and char,
	where no profile change or reset can lose it.
]]
ns.DATABASE_DEFAULTS = {
	global = {
		showWelcome = true,
		ownedMacros = {}, -- general (account-wide) macros the add-on created, by WoW macro name: true for an equipment macro, else the creating character's key
	},
	profile = {
		showUnlearned = false,
		countSpellsOnBars = true,
		markedPlaced = {}, -- macros marked placed from the page's settings menu, by WoW macro name
		-- the options each kind of spell macro starts with (see ns.MACRO_KINDS), as kind -> option -> true
		kindDefaults = { enemy = {}, friendly = {}, anyone = {}, ground = {}, form = {}, self = {} },
		mouseover = {},
		cursor = {},
		focus = {},
		pet = {},
		raidRank1 = {},
		spam = {},
		stance = {},
		petAttack = {},
		stopCast = {},
		startAttack = {},
		noToggle = {},
		castOnSelf = {},
		targetRank = {},
		fixedRank = {},
		targetTarget = {},
		targetEnemy = {},
		combatOnly = {},
		noCombat = {},
		oncePerCombat = {},
		oncePerTarget = {},
		stopAttack = {},
		hideErrors = {},
		muteErrors = {},
		cancelForm = {},
		autoShot = {},
		groupVersion = {},
		useItems = {},
		customMacros = {},
		customMacrosSeeded = false,
		trainerSpells = {},
	},
	char = {
		ownedMacros = {}, -- character macros the add-on created, by WoW macro name
	},
}
