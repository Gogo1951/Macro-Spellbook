local _, ns = ...

if ns.IS_DISCOVERY then
	return
end

-- [classToken] = { mouseoverEnemy, mouseoverFriend, cursor, raidRank1, channeled, stealth = { spellId }, noToggle = { spellId }, stanceSlots = { stanceSpellId }, stances = { [spellId] = { stanceSpellId } }, petAbilities = { [summonSpellId] = { abilityId, familyId } }, extraSpells = { spellId }, customMacros = { { name or nameKey, icon, body } } }
ns.CLASS_SPELL_LISTS = {
	DRUID = {
		mouseoverEnemy = {
			{ 5177, 5176, 5178, 5179, 5180, 6780, 8905, 9912 }, -- Wrath
			{ 2912, 8949, 8950, 8951, 9875, 9876, 25298 }, -- Starfire
			{ 8921, 8924, 8925, 8926, 8927, 8928, 8929, 9833, 9834, 9835 }, -- Moonfire
			{ 5570, 24974, 24975, 24976, 24977 }, -- Insect Swarm
			{ 339, 1062, 5195, 5196, 9852, 9853 }, -- Entangling Roots
			{ 770, 778, 9749, 9907 }, -- Faerie Fire
			{ 16857, 17390, 17391, 17392 }, -- Faerie Fire (Feral)
			{ 2637, 18657, 18658 }, -- Hibernate
			{ 2908, 8955, 9901 }, -- Soothe Animal
		},
		mouseoverFriend = {
			{ 5186, 5185, 5187, 5188, 5189, 6778, 8903, 9758, 9888, 9889, 25297 }, -- Healing Touch
			{ 8936, 8938, 8939, 8940, 8941, 9750, 9856, 9857, 9858 }, -- Regrowth
			{ 774, 1058, 1430, 2090, 2091, 3627, 8910, 9839, 9840, 9841, 25299 }, -- Rejuvenation
			18562, -- Swiftmend
			{ 20484, 20739, 20742, 20747, 20748 }, -- Rebirth
			2782, -- Remove Curse
			2893, -- Abolish Poison
			8946, -- Cure Poison
			29166, -- Innervate
			{ 1126, 5232, 5234, 6756, 8907, 9884, 9885 }, -- Mark of the Wild
			{ 21849, 21850 }, -- Gift of the Wild
			{ 467, 782, 1075, 8914, 9756, 9910 }, -- Thorns
		},
		cursor = {
			{ 16914, 17401, 17402 }, -- Hurricane
		},
		raidRank1 = {},
		channeled = {
			{ 740, 8918, 9862, 9863 }, -- Tranquility
			{ 16914, 17401, 17402 }, -- Hurricane
		},
		stealth = {
			{ 6783, 5215, 9913 }, -- Prowl
		},
		extraSpells = {
			5487, -- Bear Form
			768, -- Cat Form
			1066, -- Aquatic Form
			8946, -- Cure Poison
			18960, -- Teleport: Moonglade
		},
	},
	HUNTER = {
		mouseoverEnemy = {
			{ 3044, 14281, 14282, 14283, 14284, 14285, 14286, 14287 }, -- Arcane Shot
			{ 19434, 20900, 20901, 20902, 20903, 20904 }, -- Aimed Shot
			{ 2643, 14288, 14289, 14290, 25294 }, -- Multi-Shot
			1985, -- Sniper Shot
			5116, -- Concussive Shot
			{ 20736, 14274, 15629, 15630, 15631, 15632 }, -- Distracting Shot
			19503, -- Scatter Shot
			{ 1978, 13549, 13550, 13551, 13552, 13553, 13554, 13555, 25295 }, -- Serpent Sting
			{ 3043, 14275, 14276, 14277 }, -- Scorpid Sting
			{ 3034, 14279, 14280 }, -- Viper Sting
			{ 19386, 24131, 24132, 24133, 24134, 24135 }, -- Wyvern Sting
			{ 1130, 14323, 14324, 14325 }, -- Hunter's Mark
			{ 1513, 14326, 14327 }, -- Scare Beast
			1462, -- Beast Lore
		},
		mouseoverFriend = {},
		cursor = {
			{ 1510, 14294, 14295 }, -- Volley
			1543, -- Flare
		},
		raidRank1 = {},
		channeled = {
			{ 1510, 14294, 14295 }, -- Volley
			1002, -- Eyes of the Beast
			6197, -- Eagle Eye
			{ 136, 3111, 3661, 3662, 13542, 13543, 13544 }, -- Mend Pet
		},
		stealth = {},
		noToggle = {
			13161, -- Aspect of the Beast
			5118, -- Aspect of the Cheetah
			{ 13165, 14318, 14319, 14320, 14321, 14322, 25296 }, -- Aspect of the Hawk
			13163, -- Aspect of the Monkey
			13159, -- Aspect of the Pack
			{ 20043, 20190 }, -- Aspect of the Wild
		},
		extraSpells = {
			{ 1515, 13481, 13535 }, -- Tame Beast
			5149, -- Beast Training
			883, -- Call Pet
			2641, -- Dismiss Pet
			6991, -- Feed Pet
			982, -- Revive Pet
		},
	},
	MAGE = {
		mouseoverEnemy = {
			{ 116, 205, 837, 7322, 8406, 8407, 8408, 10179, 10180, 10181, 25304 }, -- Frostbolt
			{ 143, 133, 145, 3140, 8400, 8401, 8402, 10148, 10149, 10150, 10151, 25306 }, -- Fireball
			{ 2136, 2137, 2138, 8412, 8413, 10197, 10199 }, -- Fire Blast
			{ 2948, 8444, 8445, 8446, 10205, 10206, 10207 }, -- Scorch
			{ 11366, 12505, 12522, 12523, 12524, 12525, 12526, 18809 }, -- Pyroblast
			{ 5143, 5144, 5145, 8416, 8417, 10211, 10212, 25345 }, -- Arcane Missiles
			{ 118, 12824, 12825, 12826, 28271, 28272 }, -- Polymorph
			28270, -- Polymorph: Cow
			2139, -- Counterspell
		},
		mouseoverFriend = {
			{ 1459, 1460, 1461, 10156, 10157 }, -- Arcane Intellect
			{ 1008, 8455, 10169, 10170 }, -- Amplify Magic
			{ 604, 8450, 8451, 10173, 10174 }, -- Dampen Magic
			475, -- Remove Lesser Curse
			130, -- Slow Fall
		},
		cursor = {
			{ 2120, 2121, 8422, 8423, 10215, 10216 }, -- Flamestrike
			{ 10, 6141, 8427, 10185, 10186, 10187 }, -- Blizzard
		},
		raidRank1 = {},
		channeled = {
			{ 5143, 5144, 5145, 8416, 8417, 10211, 10212, 25345 }, -- Arcane Missiles
			{ 10, 6141, 8427, 10185, 10186, 10187 }, -- Blizzard
			12051, -- Evocation
		},
		stealth = {},
		extraSpells = {
			28272, -- Polymorph
		},
	},
	PALADIN = {
		mouseoverEnemy = {
			20271, -- Judgement
			{ 879, 5614, 5615, 10312, 10313, 10314 }, -- Exorcism
			{ 24275, 24239, 24274 }, -- Hammer of Wrath
			{ 853, 5588, 5589, 10308 }, -- Hammer of Justice
			20066, -- Repentance
			{ 2878, 5627, 10326 }, -- Turn Undead
		},
		mouseoverFriend = {
			{ 639, 635, 647, 1026, 1042, 3472, 10328, 10329, 19968, 19980, 19981, 19982, 25292 }, -- Holy Light
			{ 19750, 19939, 19940, 19941, 19942, 19943, 19993 }, -- Flash of Light
			{ 20473, 20929, 20930, 25902, 25903, 25911, 25912, 25913, 25914 }, -- Holy Shock
			{ 633, 2800, 10310 }, -- Lay on Hands
			1044, -- Blessing of Freedom
			20217, -- Blessing of Kings
			{ 19977, 19978, 19979 }, -- Blessing of Light
			{ 19740, 19834, 19835, 19836, 19837, 19838, 25291 }, -- Blessing of Might
			{ 1022, 5599, 10278 }, -- Blessing of Protection
			{ 6940, 20729 }, -- Blessing of Sacrifice
			1038, -- Blessing of Salvation
			{ 20911, 20912, 20913, 20914 }, -- Blessing of Sanctuary
			{ 19742, 19850, 19852, 19853, 19854, 25290 }, -- Blessing of Wisdom
			25898, -- Greater Blessing of Kings
			25890, -- Greater Blessing of Light
			{ 25782, 25916 }, -- Greater Blessing of Might
			25895, -- Greater Blessing of Salvation
			25899, -- Greater Blessing of Sanctuary
			{ 25894, 25918 }, -- Greater Blessing of Wisdom
			1152, -- Purify
			4987, -- Cleanse
			{ 10322, 7328, 10324, 20772, 20773 }, -- Redemption
			19752, -- Divine Intervention
		},
		cursor = {},
		raidRank1 = {},
		channeled = {},
		stealth = {},
		extraSpells = {
			7328, -- Redemption
			5502, -- Sense Undead
			13819, -- Summon Warhorse
			23214, -- Summon Charger
		},
	},
	PRIEST = {
		mouseoverEnemy = {
			{ 591, 585, 598, 984, 1004, 6060, 10933, 10934 }, -- Smite
			{ 14914, 15261, 15262, 15263, 15264, 15265, 15266, 15267 }, -- Holy Fire
			{ 8092, 8102, 8103, 8104, 8105, 8106, 10945, 10946, 10947 }, -- Mind Blast
			{ 589, 594, 970, 992, 2767, 10892, 10893, 10894 }, -- Shadow Word: Pain
			{ 15407, 17311, 17312, 17313, 17314, 18807 }, -- Mind Flay
			{ 2944, 19276, 19277, 19278, 19279, 19280 }, -- Devouring Plague
			{ 19296, 10797, 19299, 19302, 19303, 19304, 19305 }, -- Starshards
			{ 19281, 9035, 19282, 19283, 19284, 19285 }, -- Hex of Weakness
			{ 8129, 8131, 10874, 10875, 10876 }, -- Mana Burn
			15286, -- Vampiric Embrace
			{ 9484, 9485, 10955 }, -- Shackle Undead
			{ 605, 10911, 10912 }, -- Mind Control
			{ 453, 8192, 10953 }, -- Mind Soothe
			15487, -- Silence
		},
		mouseoverFriend = {
			{ 2052, 2050, 2053 }, -- Lesser Heal
			{ 2054, 2055, 6063, 6064 }, -- Heal
			{ 2060, 10963, 10964, 10965, 25314 }, -- Greater Heal
			{ 2061, 9472, 9473, 9474, 10915, 10916, 10917 }, -- Flash Heal
			{ 139, 6074, 6075, 6076, 6077, 6078, 10927, 10928, 10929, 25315 }, -- Renew
			{ 17, 592, 600, 3747, 6065, 6066, 10898, 10899, 10900, 10901 }, -- Power Word: Shield
			{ 527, 988 }, -- Dispel Magic
			528, -- Cure Disease
			552, -- Abolish Disease
			{ 2006, 2010, 10880, 10881, 20770 }, -- Resurrection
			1706, -- Levitate
			{ 1243, 1244, 1245, 2791, 10937, 10938 }, -- Power Word: Fortitude
			{ 21562, 21564 }, -- Prayer of Fortitude
			{ 14752, 14818, 14819, 27841 }, -- Divine Spirit
			27681, -- Prayer of Spirit
			{ 976, 10957, 10958 }, -- Shadow Protection
			27683, -- Prayer of Shadow Protection
			6346, -- Fear Ward
			10060, -- Power Infusion
		},
		cursor = {},
		raidRank1 = {},
		channeled = {
			{ 15407, 17311, 17312, 17313, 17314, 18807 }, -- Mind Flay
			{ 605, 10911, 10912 }, -- Mind Control
		},
		stealth = {},
	},
	ROGUE = {
		mouseoverEnemy = {
			{ 1766, 1767, 1768, 1769 }, -- Kick
			{ 1776, 1777, 8629, 11285, 11286 }, -- Gouge
			2094, -- Blind
			{ 6770, 2070, 11297 }, -- Sap
			921, -- Pick Pocket
		},
		mouseoverFriend = {},
		cursor = {
			1725, -- Distract
		},
		raidRank1 = {},
		channeled = {},
		stealth = {
			{ 1784, 1785, 1786, 1787 }, -- Stealth
		},
		extraSpells = {
			14278, -- Ghostly Strike
			14183, -- Premeditation
			{ 16511, 17347, 17348 }, -- Hemorrhage
			14185, -- Preparation
			14251, -- Riposte
			13877, -- Blade Flurry
			13750, -- Adrenaline Rush
			{ 14166, 14165, 14167 }, -- Improved Slice and Dice
		},
	},
	SHAMAN = {
		mouseoverEnemy = {
			{ 529, 403, 548, 915, 943, 6041, 10391, 10392, 15207, 15208 }, -- Lightning Bolt
			{ 421, 930, 2860, 10605 }, -- Chain Lightning
			{ 8042, 8044, 8045, 8046, 10412, 10413, 10414 }, -- Earth Shock
			{ 8050, 8052, 8053, 10447, 10448, 29228 }, -- Flame Shock
			{ 8056, 8058, 10472, 10473 }, -- Frost Shock
			{ 370, 8012 }, -- Purge
		},
		mouseoverFriend = {
			{ 332, 331, 547, 913, 939, 959, 8005, 10395, 10396, 25357 }, -- Healing Wave
			{ 8004, 8008, 8010, 10466, 10467, 10468 }, -- Lesser Healing Wave
			{ 1064, 10622, 10623 }, -- Chain Heal
			{ 2008, 20609, 20610, 20776, 20777 }, -- Ancestral Spirit
			526, -- Cure Poison
			2870, -- Cure Disease
			131, -- Water Breathing
			546, -- Water Walking
		},
		cursor = {},
		raidRank1 = {},
		channeled = {},
		stealth = {},
		extraSpells = {
			8071, -- Stoneskin Totem
			3599, -- Searing Totem
			5394, -- Healing Stream Totem
		},
	},
	WARLOCK = {
		mouseoverEnemy = {
			{ 695, 686, 705, 1088, 1106, 7641, 11659, 11660, 11661, 25307 }, -- Shadow Bolt
			{ 348, 707, 1094, 2941, 11665, 11667, 11668, 25309 }, -- Immolate
			{ 172, 6222, 6223, 7648, 11671, 11672, 25311 }, -- Corruption
			{ 980, 1014, 6217, 11711, 11712, 11713 }, -- Curse of Agony
			603, -- Curse of Doom
			18223, -- Curse of Exhaustion
			1010, -- Curse of Idiocy
			{ 704, 7658, 7659, 11717 }, -- Curse of Recklessness
			{ 17862, 17937 }, -- Curse of Shadow
			{ 1714, 11719 }, -- Curse of Tongues
			{ 702, 1108, 6205, 7646, 11707, 11708 }, -- Curse of Weakness
			{ 1490, 11721, 11722 }, -- Curse of the Elements
			{ 689, 699, 709, 7651, 11699, 11700 }, -- Drain Life
			{ 1120, 8288, 8289, 11675 }, -- Drain Soul
			{ 5138, 6226, 11703, 11704, 18394 }, -- Drain Mana
			{ 5782, 6213, 6215 }, -- Fear
			{ 5676, 17919, 17920, 17921, 17922, 17923 }, -- Searing Pain
			{ 17877, 18867, 18868, 18869, 18870, 18871 }, -- Shadowburn
			{ 17962, 18930, 18931, 18932 }, -- Conflagrate
			{ 18265, 18879, 18880, 18881 }, -- Siphon Life
			{ 6789, 17925, 17926 }, -- Death Coil
			{ 6353, 17924 }, -- Soul Fire
			{ 710, 18647 }, -- Banish
			{ 1098, 11725, 11726 }, -- Subjugate Demon
		},
		mouseoverFriend = {
			5697, -- Unending Breath
			2970, -- Detect Invisibility
		},
		cursor = {
			{ 5740, 6219, 11677, 11678 }, -- Rain of Fire
			1122, -- Inferno
		},
		raidRank1 = {
			{ 980, 1014, 6217, 11711, 11712, 11713 }, -- Curse of Agony
			603, -- Curse of Doom
			18223, -- Curse of Exhaustion
			1010, -- Curse of Idiocy
			{ 704, 7658, 7659, 11717 }, -- Curse of Recklessness
			{ 17862, 17937 }, -- Curse of Shadow
			{ 1714, 11719 }, -- Curse of Tongues
			{ 702, 1108, 6205, 7646, 11707, 11708 }, -- Curse of Weakness
			{ 1490, 11721, 11722 }, -- Curse of the Elements
		},
		channeled = {
			{ 689, 699, 709, 7651, 11699, 11700 }, -- Drain Life
			{ 5138, 6226, 11703, 11704, 18394 }, -- Drain Mana
			{ 1120, 8288, 8289, 11675 }, -- Drain Soul
			{ 755, 3698, 3699, 3700, 11693, 11694, 11695 }, -- Health Funnel
			{ 1949, 11683, 11684 }, -- Hellfire
			{ 5740, 6219, 11677, 11678 }, -- Rain of Fire
		},
		stealth = {},
		petAbilities = {
			[712] = { abilityId = 6358, familyId = 17 }, -- Summon Succubus: Seduction
			[688] = { abilityId = 2947, familyId = 23 }, -- Summon Imp: Fire Shield
			[691] = { abilityId = 19244, familyId = 15 }, -- Summon Felhunter: Spell Lock
			[713] = { abilityId = 6358, familyId = 302 }, -- Summon Incubus: Seduction
			[697] = { abilityId = 7812, familyId = 16 }, -- Summon Voidwalker: Sacrifice
		},
		extraSpells = {
			18288, -- Amplify Curse
			18223, -- Curse of Exhaustion
			18788, -- Demonic Sacrifice
			18708, -- Fel Domination
			19028, -- Soul Link
			697, -- Summon Voidwalker
			712, -- Summon Succubus
			713, -- Summon Incubus
			691, -- Summon Felhunter
			1122, -- Inferno
			18540, -- Ritual of Doom
		},
		customMacros = {
			{ nameKey = "CUSTOM_SPAM_WAND", icon = 132317, body = "/castsequence !{spell:5019},!{spell:5019}" },
			{
				name = "{spell:19505}",
				icon = 136075,
				body = "#showtooltip\n/cast [@mouseover,exists] [@target,help] [@player] {spell:19505}",
			},
			{
				nameKey = "CUSTOM_PET_ABILITY",
				icon = 618980,
				body = "#showtooltip\n/cast {spell:2947}\n/cast {spell:7812}\n/cast {spell:19244}\n/cast {spell:6358}",
			},
			{
				nameKey = "CUSTOM_PET_ABILITY_MOUSEOVER",
				icon = 618980,
				body = "#showtooltip\n/cast [pet:{family:16}] {spell:7812}; [pet:{family:23}] {spell:2947}; [pet:{family:17},@mouseover,exists,nodead][pet:{family:17},@target] {spell:6358}; [pet:{family:15},@mouseover,exists,nodead][pet:{family:15},@target] {spell:19505};",
			},
		},
	},
	WARRIOR = {
		mouseoverEnemy = {
			{ 100, 6178, 11578 }, -- Charge
			{ 20616, 20252, 20617 }, -- Intercept
			355, -- Taunt
			{ 694, 7400, 7402, 20559, 20560 }, -- Mocking Blow
			{ 72, 1671, 1672 }, -- Shield Bash
			{ 6552, 6554 }, -- Pummel
		},
		mouseoverFriend = {},
		cursor = {},
		raidRank1 = {},
		channeled = {},
		stealth = {},
		stanceSlots = { 2457, 71, 2458 }, -- Battle, Defensive, Berserker Stance
		stances = {
			[355] = { 71 }, -- Taunt: Defensive Stance
			[100] = { 2457 }, -- Charge: Battle Stance
			[5308] = { 2457, 2458 }, -- Execute: Battle Stance, Berserker Stance
			[772] = { 2457, 71 }, -- Rend: Battle Stance, Defensive Stance
			[12292] = { 2457 }, -- Sweeping Strikes: Battle Stance
			[6343] = { 2457 }, -- Thunder Clap: Battle Stance
			[2565] = { 71 }, -- Shield Block: Defensive Stance
			[7384] = { 2457 }, -- Overpower: Battle Stance
			[694] = { 2457 }, -- Mocking Blow: Battle Stance
			[1719] = { 2458 }, -- Recklessness: Berserker Stance
			[1715] = { 2457, 2458 }, -- Hamstring: Battle Stance, Berserker Stance
			[72] = { 71, 2457 }, -- Shield Bash: Defensive Stance, Battle Stance
			[20616] = { 2458 }, -- Intercept: Berserker Stance
			[18499] = { 2458 }, -- Berserker Rage: Berserker Stance
			[6572] = { 71 }, -- Revenge: Defensive Stance
			[20230] = { 2457 }, -- Retaliation: Battle Stance
			[6552] = { 2458 }, -- Pummel: Berserker Stance
			[1680] = { 2458 }, -- Whirlwind: Berserker Stance
			[871] = { 71 }, -- Shield Wall: Defensive Stance
			[676] = { 71 }, -- Disarm: Defensive Stance
		},
		extraSpells = {
			71, -- Defensive Stance
			355, -- Taunt
			7386, -- Sunder Armor
			2458, -- Berserker Stance
			20252, -- Intercept
			{ 12975, 12976 }, -- Last Stand
			12809, -- Concussion Blow
			{ 23922, 23923, 23924, 23925 }, -- Shield Slam
			12323, -- Piercing Howl
			12328, -- Death Wish
			{ 23881, 23880, 23885, 23886, 23887, 23888, 23889, 23890, 23891, 23892, 23893, 23894 }, -- Bloodthirst
			{ 12292, 12723 }, -- Sweeping Strikes
			{ 12294, 21551, 21552, 21553 }, -- Mortal Strike
		},
	},
}

--[[
How We Got the Data

Last Validated
	2026-10-24, Classic Era 1.15.9.70003

Notes
	- Each class's lists for the spellbook page: the spells whose macros get the mouseover, cursor, raid rank 1, channeled and stealth options; the stance bar order and the stances each spell needs; the ability each demon or pet summon's macro can cast; the spells listed until learned that no trainer row covers (extraSpells: quest-learned spells and talents without trainer ranks); and default custom macros. Features/Macro-Builder.lua reads them.
	- An entry is a spell ID, or a list of every rank's ID where some locales name the ranks differently. Spells are matched by the name this client gives them, so one ID per spell is enough otherwise.
	- Hand-picked: the game tables can't say which option a spell belongs to, so there's no family test. Every ID was checked against this client's spell table.
	- Copied from Data/Camelot/ and pruned of the IDs this client doesn't have.
	- Season of Discovery's spells are left out, though this client knows them: they live in Data/Discovery/. These are the IDs in SoD's range (300000 and up) that the TBC Anniversary client doesn't have. The paladin's Swift Judgement default macro went with them.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	https://wago.tools/db2/SpellName?build=1.15.9.70003
	https://wago.tools/db2/SpellName?build=2.5.6.70006

QuestieDB
	None.
]]
