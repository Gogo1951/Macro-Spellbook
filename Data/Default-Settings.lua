local _, ns = ...

--[[
	Per-Character model: the recorded trainer spells differ from character to character, and the macro options
	ride the profile with them, since which spells a page lists is per class. Which macros the add-on made is a
	fact about the account's and the character's macro lists, not a setting, so it lives in global and char,
	where no profile change or reset can lose it. The equipment macros' options live in global too: every
	character shares those macros, so per-character options would have each character rewrite them in turn.
]]
ns.DATABASE_DEFAULTS = {
	global = {
		showWelcome = true,
		ownedMacros = {}, -- general (account-wide) macros the add-on created, by WoW macro name: true for an equipment macro, else the creating character's key
		-- an equipment macro's options, by WoW macro name, as option -> true/false: account-wide like the macro
		equipmentOptions = {},
		-- each WoW macro's tag line ID (see ns.MacroTag), by what the macro is for, and how many were handed out
		macroTags = {},
		macroTagCount = 0,
	},
	profile = {
		showUnlearned = false,
		countSpellsOnBars = true,
		markedPlaced = {}, -- macros marked placed from the page's settings menu, by WoW macro name
		--[[
			the options each kind of macro starts with (see ns.MACRO_KINDS and ns.ITEM_KIND), as kind -> option -> true or
			false. Buffs start on Dynamic Rank: a buff's rank can't land on a player too far below its level.
		]]
		kindDefaults = {
			enemy = {},
			friendly = {},
			buff = { targetRank = true },
			anyone = {},
			ground = {},
			form = {},
			self = {},
			item = {},
		},
		mouseover = {},
		cursor = {},
		focus = {},
		pet = {},
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
		targetFriend = {},
		combatOnly = {},
		noCombat = {},
		oncePerCombat = {},
		oncePerTarget = {},
		stopAttack = {},
		stopIfChanneling = {},
		stopIfStealthed = {},
		hideErrors = {},
		muteErrors = {},
		cancelForm = {},
		autoShot = {},
		groupVersion = {},
		groupedSpells = {},
		targetPriority = {}, -- each spell's own target priority, as a list of units (see ns.TargetPriority)
		useItems = {},
		macroCopies = {}, -- the Duplicate copies of each spell's macro, by spell name, as a list of copy numbers
		customMacros = {},
		customMacrosSeeded = false,
		trainerSpells = {},
	},
	char = {
		ownedMacros = {}, -- character macros the add-on created, by WoW macro name
	},
}
