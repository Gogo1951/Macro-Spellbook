local _, ns = ...

-- [classToken] = { mouseoverEnemy, mouseoverFriend, buffs, cursor, channeled, stealth = { spellId }, noToggle = { spellId }, stanceSlots = { stanceSpellId }, stances = { [spellId] = { stanceSpellId } }, petAbilities = { [summonSpellId] = { abilityId, familyId } }, extraSpells = { spellId }, customMacros = { { name or nameKey, icon, body } }, autoShot = spellId }
ns.CLASS_SPELL_LISTS = {
	DEATHKNIGHT = {
		mouseoverEnemy = {
			45477, -- Icy Touch
			47541, -- Death Coil
			49184, -- Howling Blast
			77575, -- Outbreak
			45524, -- Chains of Ice
			49576, -- Death Grip
			56222, -- Dark Command
			47528, -- Mind Freeze
			47476, -- Strangulate
			108194, -- Asphyxiate
			111673, -- Control Undead
			77606, -- Dark Simulacrum
			108196, -- Death Siphon
			123693, -- Plague Leech
			49206, -- Summon Gargoyle
			108199, -- Gorefiend's Grasp
		},
		mouseoverFriend = {
			61999, -- Raise Ally
			49016, -- Unholy Frenzy
			108199, -- Gorefiend's Grasp
		},
		cursor = {
			43265, -- Death and Decay
			51052, -- Anti-Magic Zone
		},
		channeled = {
			42650, -- Army of the Dead
		},
		stealth = {},
	},
	DRUID = {
		mouseoverEnemy = {
			5176, -- Wrath
			2912, -- Starfire
			78674, -- Starsurge
			8921, -- Moonfire
			93402, -- Sunfire
			339, -- Entangling Roots
			770, -- Faerie Fire
			33786, -- Cyclone
			2637, -- Hibernate
			2908, -- Soothe
			102359, -- Mass Entanglement
			6795, -- Growl
			106839, -- Skull Bash
			78675, -- Solar Beam
			5211, -- Mighty Bash
		},
		mouseoverFriend = {
			5185, -- Healing Touch
			8936, -- Regrowth
			774, -- Rejuvenation
			50464, -- Nourish
			33763, -- Lifebloom
			18562, -- Swiftmend
			48438, -- Wild Growth
			102351, -- Cenarion Ward
			102342, -- Ironbark
			88423, -- Nature's Cure
			2782, -- Remove Corruption
			20484, -- Rebirth
			50769, -- Revive
			29166, -- Innervate
			1126, -- Mark of the Wild
			110309, -- Symbiosis
		},
		cursor = {
			16914, -- Hurricane
			102793, -- Ursol's Vortex
		},
		channeled = {
			740, -- Tranquility
			16914, -- Hurricane
			127663, -- Astral Communion
		},
		stealth = {
			5215, -- Prowl
		},
	},
	HUNTER = {
		mouseoverEnemy = {
			3044, -- Arcane Shot
			19434, -- Aimed Shot
			56641, -- Steady Shot
			77767, -- Cobra Shot
			53209, -- Chimera Shot
			53301, -- Explosive Shot
			3674, -- Black Arrow
			53351, -- Kill Shot
			2643, -- Multi-Shot
			1978, -- Serpent Sting
			82654, -- Widow Venom
			5116, -- Concussive Shot
			147362, -- Counter Shot
			34490, -- Silencing Shot
			19503, -- Scatter Shot
			19386, -- Wyvern Sting
			20736, -- Distracting Shot
			19801, -- Tranquilizing Shot
			1130, -- Hunter's Mark
			1513, -- Scare Beast
			1462, -- Beast Lore
			34026, -- Kill Command
			131894, -- A Murder of Crows
			120679, -- Dire Beast
			117050, -- Glaive Toss
			109259, -- Powershot
			120360, -- Barrage
			121818, -- Stampede
		},
		mouseoverFriend = {
			34477, -- Misdirection
			53271, -- Master's Call
		},
		cursor = {
			1543, -- Flare
			109248, -- Binding Shot
		},
		channeled = {
			120360, -- Barrage
			6197, -- Eagle Eye
			1515, -- Tame Beast
		},
		stealth = {},
		noToggle = {
			13165, -- Aspect of the Hawk
			109260, -- Aspect of the Iron Hawk
			5118, -- Aspect of the Cheetah
			13159, -- Aspect of the Pack
		},
	},
	MAGE = {
		mouseoverEnemy = {
			116, -- Frostbolt
			133, -- Fireball
			44614, -- Frostfire Bolt
			30451, -- Arcane Blast
			44425, -- Arcane Barrage
			5143, -- Arcane Missiles
			30455, -- Ice Lance
			2136, -- Fire Blast
			2948, -- Scorch
			11366, -- Pyroblast
			108853, -- Inferno Blast
			44457, -- Living Bomb
			114923, -- Nether Tempest
			112948, -- Frost Bomb
			44572, -- Deep Freeze
			102051, -- Frostjaw
			118, -- Polymorph
			2139, -- Counterspell
			30449, -- Spellsteal
			31589, -- Slow
			11129, -- Combustion
		},
		mouseoverFriend = {
			1459, -- Arcane Brilliance
			475, -- Remove Curse
			130, -- Slow Fall
			111264, -- Ice Ward
		},
		cursor = {
			10, -- Blizzard
			2120, -- Flamestrike
			113724, -- Ring of Frost
			116011, -- Rune of Power
		},
		channeled = {
			5143, -- Arcane Missiles
			10, -- Blizzard
			12051, -- Evocation
		},
		stealth = {},
	},
	MONK = {
		mouseoverEnemy = {
			117952, -- Crackling Jade Lightning
			115546, -- Provoke
			115078, -- Paralysis
			116705, -- Spear Hand Strike
			116095, -- Disable
			117368, -- Grapple Weapon
			115080, -- Touch of Death
			122057, -- Clash
			122470, -- Touch of Karma
			115098, -- Chi Wave
			123904, -- Invoke Xuen, the White Tiger
			137639, -- Storm, Earth, and Fire
		},
		mouseoverFriend = {
			115175, -- Soothing Mist
			116694, -- Surging Mist
			124682, -- Enveloping Mist
			115151, -- Renewing Mist
			116849, -- Life Cocoon
			115450, -- Detox
			115178, -- Resuscitate
			115921, -- Legacy of the Emperor
			116841, -- Tiger's Lust
			124081, -- Zen Sphere
			115098, -- Chi Wave
			116844, -- Ring of Peace
		},
		cursor = {
			115180, -- Dizzying Haze
			115460, -- Healing Sphere
			115315, -- Summon Black Ox Statue
			115313, -- Summon Jade Serpent Statue
		},
		channeled = {
			117952, -- Crackling Jade Lightning
			113656, -- Fists of Fury
			115175, -- Soothing Mist
			101546, -- Spinning Crane Kick
			115294, -- Mana Tea
			115176, -- Zen Meditation
		},
		stealth = {},
	},
	PALADIN = {
		mouseoverEnemy = {
			20271, -- Judgment
			879, -- Exorcism
			24275, -- Hammer of Wrath
			31935, -- Avenger's Shield
			2812, -- Denounce
			853, -- Hammer of Justice
			105593, -- Fist of Justice
			20066, -- Repentance
			10326, -- Turn Evil
			62124, -- Reckoning
			96231, -- Rebuke
			20473, -- Holy Shock
			114157, -- Execution Sentence
			114165, -- Holy Prism
		},
		mouseoverFriend = {
			635, -- Holy Light
			82326, -- Divine Light
			19750, -- Flash of Light
			82327, -- Holy Radiance
			85673, -- Word of Glory
			114163, -- Eternal Flame
			20473, -- Holy Shock
			633, -- Lay on Hands
			53563, -- Beacon of Light
			20925, -- Sacred Shield
			1044, -- Hand of Freedom
			1022, -- Hand of Protection
			6940, -- Hand of Sacrifice
			1038, -- Hand of Salvation
			114039, -- Hand of Purity
			4987, -- Cleanse
			7328, -- Redemption
			114157, -- Execution Sentence
			114165, -- Holy Prism
			20217, -- Blessing of Kings
			19740, -- Blessing of Might
		},
		cursor = {
			114158, -- Light's Hammer
		},
		channeled = {},
		stealth = {},
	},
	PRIEST = {
		mouseoverEnemy = {
			585, -- Smite
			14914, -- Holy Fire
			88625, -- Holy Word: Chastise
			8092, -- Mind Blast
			15407, -- Mind Flay
			73510, -- Mind Spike
			589, -- Shadow Word: Pain
			32379, -- Shadow Word: Death
			34914, -- Vampiric Touch
			2944, -- Devouring Plague
			48045, -- Mind Sear
			47540, -- Penance
			121135, -- Cascade
			528, -- Dispel Magic
			9484, -- Shackle Undead
			605, -- Dominate Mind
			64044, -- Psychic Horror
			15487, -- Silence
			34433, -- Shadowfiend
			123040, -- Mindbender
		},
		mouseoverFriend = {
			2061, -- Flash Heal
			2050, -- Heal
			2060, -- Greater Heal
			32546, -- Binding Heal
			139, -- Renew
			17, -- Power Word: Shield
			33076, -- Prayer of Mending
			596, -- Prayer of Healing
			34861, -- Circle of Healing
			47540, -- Penance
			121135, -- Cascade
			47788, -- Guardian Spirit
			33206, -- Pain Suppression
			108968, -- Void Shift
			73325, -- Leap of Faith
			527, -- Purify
			2006, -- Resurrection
			6346, -- Fear Ward
			1706, -- Levitate
			21562, -- Power Word: Fortitude
			48045, -- Mind Sear
		},
		cursor = {
			32375, -- Mass Dispel
			62618, -- Power Word: Barrier
			126135, -- Lightwell
			121536, -- Angelic Feather
			108921, -- Psyfiend
		},
		channeled = {
			15407, -- Mind Flay
			48045, -- Mind Sear
			47540, -- Penance
			64843, -- Divine Hymn
			64901, -- Hymn of Hope
			605, -- Dominate Mind
			2096, -- Mind Vision
		},
		stealth = {},
	},
	ROGUE = {
		mouseoverEnemy = {
			1766, -- Kick
			1776, -- Gouge
			2094, -- Blind
			6770, -- Sap
			921, -- Pick Pocket
			121733, -- Throw
			26679, -- Deadly Throw
			114014, -- Shuriken Toss
			73981, -- Redirect
			137619, -- Marked for Death
			51722, -- Dismantle
			36554, -- Shadowstep
		},
		mouseoverFriend = {
			57934, -- Tricks of the Trade
			36554, -- Shadowstep
		},
		cursor = {
			1725, -- Distract
		},
		channeled = {},
		stealth = {
			1784, -- Stealth
		},
	},
	SHAMAN = {
		mouseoverEnemy = {
			403, -- Lightning Bolt
			421, -- Chain Lightning
			51505, -- Lava Burst
			117014, -- Elemental Blast
			8042, -- Earth Shock
			8050, -- Flame Shock
			8056, -- Frost Shock
			370, -- Purge
			57994, -- Wind Shear
			51514, -- Hex
			76780, -- Bind Elemental
		},
		mouseoverFriend = {
			8004, -- Healing Surge
			331, -- Healing Wave
			77472, -- Greater Healing Wave
			1064, -- Chain Heal
			61295, -- Riptide
			974, -- Earth Shield
			77130, -- Purify Spirit
			51886, -- Cleanse Spirit
			2008, -- Ancestral Spirit
			546, -- Water Walking
		},
		cursor = {
			61882, -- Earthquake
			73920, -- Healing Rain
			108287, -- Totemic Projection
			6196, -- Far Sight
		},
		channeled = {
			6196, -- Far Sight
		},
		stealth = {},
	},
	WARLOCK = {
		mouseoverEnemy = {
			686, -- Shadow Bolt
			29722, -- Incinerate
			116858, -- Chaos Bolt
			17962, -- Conflagrate
			348, -- Immolate
			17877, -- Shadowburn
			6353, -- Soul Fire
			105174, -- Hand of Gul'dan
			77799, -- Fel Flame
			48181, -- Haunt
			103103, -- Malefic Grasp
			689, -- Drain Life
			1120, -- Drain Soul
			172, -- Corruption
			980, -- Agony
			30108, -- Unstable Affliction
			27243, -- Seed of Corruption
			86121, -- Soul Swap
			109466, -- Curse of Enfeeblement
			1490, -- Curse of the Elements
			18223, -- Curse of Exhaustion
			5782, -- Fear
			710, -- Banish
			6789, -- Mortal Coil
			80240, -- Havoc
			1098, -- Subjugate Demon
			18540, -- Summon Doomguard
		},
		mouseoverFriend = {
			5697, -- Unending Breath
			20707, -- Soulstone
			109773, -- Dark Intent
		},
		cursor = {
			5740, -- Rain of Fire
			30283, -- Shadowfury
			1122, -- Summon Infernal
			111771, -- Demonic Gateway
		},
		channeled = {
			689, -- Drain Life
			1120, -- Drain Soul
			103103, -- Malefic Grasp
			755, -- Health Funnel
			1949, -- Hellfire
			5740, -- Rain of Fire
			126, -- Eye of Kilrogg
			698, -- Ritual of Summoning
		},
		stealth = {},
		petAbilities = {
			[688] = { abilityId = 119899, familyId = 23 }, -- Summon Imp: Cauterize Master
			[697] = { abilityId = 118093, familyId = 16 }, -- Summon Voidwalker: Disarm
			[712] = { abilityId = 6360, familyId = 17 }, -- Summon Succubus: Whiplash
			[713] = { abilityId = 6360, familyId = 302 }, -- Summon Incubus: Whiplash
			[691] = { abilityId = 19647, familyId = 15 }, -- Summon Felhunter: Spell Lock
			[30146] = { abilityId = 89751, familyId = 29 }, -- Summon Felguard: Felstorm
			[112866] = { abilityId = 119899, familyId = 100 }, -- Summon Fel Imp: Cauterize Master
			[112867] = { abilityId = 118093, familyId = 101 }, -- Summon Voidlord: Disarm
			[112868] = { abilityId = 115770, familyId = 102 }, -- Summon Shivarra: Fellash
			[112869] = { abilityId = 115781, familyId = 103 }, -- Summon Observer: Optical Blast
			[112870] = { abilityId = 115831, familyId = 104 }, -- Summon Wrathguard: Wrathstorm
		},
		customMacros = {
			{
				name = "{spell:19505}",
				icon = 136075,
				body = "#showtooltip\n/cast [@mouseover,harm,nodead][] {spell:19505}",
			},
			{
				nameKey = "CUSTOM_PET_ABILITY_MOUSEOVER",
				icon = 618980,
				body = "#showtooltip\n/cast [@mouseover,harm,nodead][] {spell:119898}",
			},
		},
	},
	WARRIOR = {
		mouseoverEnemy = {
			100, -- Charge
			355, -- Taunt
			6552, -- Pummel
			57755, -- Heroic Throw
			107570, -- Storm Bolt
			64382, -- Shattering Throw
			676, -- Disarm
			5246, -- Intimidating Shout
		},
		mouseoverFriend = {
			3411, -- Intervene
			114029, -- Safeguard
			114030, -- Vigilance
		},
		cursor = {
			6544, -- Heroic Leap
			114203, -- Demoralizing Banner
			114192, -- Mocking Banner
		},
		channeled = {},
		stealth = {},
	},
}

--[[
How We Got the Data

Last Validated
	2026-10-24, Mists of Pandaria Classic 5.5.4.70579

Notes
	- Each class's lists for the spellbook page: the spells whose macros get the mouseover, cursor and channeled options, stealth, the aspects that offer "!Name" casting, the ability each demon summon's macro can cast, and default custom macros. Features/Macro-Builder.lua reads them.
	- One ID per spell: this client has no spell ranks, and spells are matched by the name this client gives them.
	- Built from this client's game tables after its Validate Data report, which found every table here empty, so the next Validate Data run is the first to check these rows.
	- The class's spells are the ones on its class skill line, its specializations or its talents (SkillLineAbility, SpecializationSpells, Talent), leaving out passive and hidden spells and the effects other spells fire.
	- mouseoverEnemy: spells cast on an enemy unit (SpellEffect target) from range, plus the melee-range interrupts, crowd control and taunts. Melee strikes are left out; any harmful spell with a range gets the mouseover option anyway (TargetsEnemy in Features/Macro-Builder.lua).
	- mouseoverFriend: spells cast on a friendly unit, resurrections, and the raid buffs cast on a target. A spell that heals a friend or hurts an enemy (Holy Shock, Penance, Chi Wave, Cascade, Holy Prism, Execution Sentence, Mind Sear, Gorefiend's Grasp, Shadowstep) is on both lists, so its macro casts on any unit.
	- cursor: spells the player places on the ground (SpellTargetRestrictions asks for a location), leaving out Typhoon and Eagle Eye, which the tables flag but which don't take a location.
	- channeled: spells the tables mark as channeled (SpellMisc attributes).
	- Wild Mushroom is on no list: Balance places it on the ground and Restoration on a friend, under one name.
	- Left out on purpose: Death Coil on the friendly list (it heals only Undead allies), Frostbolt and Provoke on it (their friendly target is the mage's Water Elemental and the monk's statue).
	- Warriors have no stances or stanceSlots: no warrior spell needs a stance on this client (SpellShapeshift), so the stance option never applies. The other forms, stances, presences, seals and Shadowform sit on the stance bar, which the builder reads directly.
	- noToggle is the hunter aspects, which cancel when cast again and aren't on the stance bar.
	- petAbilities: each demon's ability is the one Command Demon names for it in this client's spell description, the Grimoire of Supremacy demons included.
	- customMacros: Devour Magic on the mouseover enemy, and Command Demon on the mouseover enemy as the Pet Ability (Mouseover) macro. The Spam Wand macro other flavors ship is left out, since wands are gone on this client.
	- extraSpells is left out: it lists spells for the Unlearned section, and the Mists TOC doesn't load Features/Unlearned-Spells.lua.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	https://wago.tools/db2/SkillLineAbility?build=5.5.4.70579
	https://wago.tools/db2/SkillLine?build=5.5.4.70579
	https://wago.tools/db2/SpecializationSpells?build=5.5.4.70579
	https://wago.tools/db2/ChrSpecialization?build=5.5.4.70579
	https://wago.tools/db2/Talent?build=5.5.4.70579
	https://wago.tools/db2/SpellName?build=5.5.4.70579
	https://wago.tools/db2/Spell?build=5.5.4.70579
	https://wago.tools/db2/SpellMisc?build=5.5.4.70579
	https://wago.tools/db2/SpellEffect?build=5.5.4.70579
	https://wago.tools/db2/SpellTargetRestrictions?build=5.5.4.70579
	https://wago.tools/db2/SpellShapeshift?build=5.5.4.70579
	https://wago.tools/db2/SpellShapeshiftForm?build=5.5.4.70579
	https://wago.tools/db2/CreatureFamily?build=5.5.4.70579

QuestieDB
	None.
]]
