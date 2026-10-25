local L = LibStub("AceLocale-3.0"):NewLocale("MacroSpellbook", "enUS", true)
if not L then
	return
end

-- Add-on Names
L["ADDON_TITLE"] = "Macro Spellbook"
L["ADDON_SHORT_NAME"] = "Macro Spellbook"

-- Page: Sections
L["SECTION_UNLEARNED"] = "Unlearned"
L["SECTION_CUSTOM"] = "Custom"
L["SECTION_EQUIPMENT"] = "Equipment"

-- Page: Default Custom Macros
-- TRANSLATORS: each name becomes a WoW macro name, cut to 16 bytes (about 5 Chinese or Korean characters), so keep it short.
L["CUSTOM_SPAM_WAND"] = "Spam Wand"
L["CUSTOM_PET_ABILITY"] = "Pet Ability"
L["CUSTOM_PET_ABILITY_MOUSEOVER"] = "Pet (Mouseover)"
L["CUSTOM_SWIFT_JUDGE"] = "Swift Judge"

-- Page: Macro Menu
L["MACRO_TEXT"] = "Macro Text"
L["MENU_MACRO_LENGTH"] = "%d / %d"
L["MENU_DYNAMIC_RANK"] = "Dynamic Rank"
L["MENU_DYNAMIC_RANK_NOTE"] = "Dynamic Rank, based on a friendly player's level, only updates out of combat."
L["MENU_CAST_AT_CURSOR"] = "Cast At Cursor"
L["MENU_TARGET_NEAREST_ENEMY"] = "Target Nearest Enemy"
L["MENU_TARGET_NEAREST_FRIEND"] = "Target Nearest Friend"
L["MENU_CAST_IF_SUMMONED"] = "Cast %s If Summoned"
L["MENU_NEVER_TURN_OFF"] = "Never Turn Off"
L["MENU_LEAVE_FORM_BEFORE"] = "Leave Form Before Casting"
L["MENU_RIGHT_CLICK_FOR"] = "Right-Click For %s"
L["MENU_ONCE_PER_COMBAT"] = "Cast Once Per Combat"
L["MENU_ONCE_PER_TARGET"] = "Cast Once Per Target"
L["MENU_HIDE_ERRORS"] = "Hide Error Messages"
L["MENU_MUTE_ERRORS"] = "Mute Error Sounds"
L["MENU_SWITCH_TO"] = "Switch To %s"
L["MENU_START_AUTO_ATTACK"] = "Start Auto Attack"
L["MENU_STOP_ATTACK"] = "Stop Attack"
L["MENU_START_AUTO_SHOT"] = "Start Auto Shot"
L["MENU_START_PET_ATTACK"] = "Start Pet Attack"
L["MENU_START_WAND"] = "Start Wand"
L["MENU_STOP_CASTING"] = "Stop Casting"
L["MENU_STOP_CASTING_NOTE"] = "Use Stop Casting on spells that can't wait, like interrupts and dispels."
L["MENU_STOP_IF_CHANNELING"] = "Stop Macro If Channeling"
L["MENU_STOP_IF_STEALTHED"] = "Stop Macro If Stealthed"
L["MENU_DUPLICATE"] = "Duplicate"
L["MENU_DELETE"] = "Delete"
L["MENU_DELETE_USED_ONE"] = "Delete (Used On 1 Bar)"
L["MENU_DELETE_USED"] = "Delete (Used On %d Bars)"
L["MENU_DELETE_DESCRIPTION"] =
	"Deletes this macro from your macros, which takes it off your action bars, and resets all its options. Click or drag it on the page to make it again."
L["MENU_DELETE_COPY_DESCRIPTION"] =
	"Takes this copy off the page and deletes it from your macros, which takes it off your action bars."
L["MENU_DELETE_CONFIRM"] = "Delete %s? It comes off your action bars, and its options reset."
L["MENU_GROUP_RANK"] = "Rank"
L["MENU_GROUP_WHEN"] = "When"
L["MENU_GROUP_FIRST"] = "First"
L["MENU_GROUP_THEN"] = "Then"
L["MENU_GROUP_ERRORS"] = "Error Messages"
L["MENU_GROUP_GROUPED"] = "Grouped Spells"
L["MENU_GROUP_TARGET"] = "Target"
L["MENU_PRIORITY_1"] = "First Priority"
L["MENU_PRIORITY_2"] = "Second Priority"
L["MENU_PRIORITY_3"] = "Third Priority"
L["MENU_PRIORITY_DESCRIPTION"] =
	"Who the macro tries, in turn. Each is skipped when it can't take the spell, and when none can, it casts as the plain spell would."
L["MENU_UNIT_NONE"] = "None"
L["MENU_UNIT_NONE_DESCRIPTION"] = "Ends the list here."
L["MENU_UNIT_TARGET"] = "Target"
L["MENU_UNIT_TARGET_DESCRIPTION"] = "Casts on your target, when it can take the spell."
L["MENU_UNIT_SELF"] = "Self"
L["MENU_UNIT_SELF_DESCRIPTION"] = "Casts on you. You can always take it, so nothing after Self is ever tried."
L["MENU_UNIT_PET"] = "Pet"
L["MENU_UNIT_PET_DESCRIPTION"] = "Casts on your pet, when it's out and can take the spell."
L["MENU_UNIT_FOCUS"] = "Focus"
L["MENU_UNIT_FOCUS_DESCRIPTION"] = "Casts on your focus, when you have one and it can take the spell."
L["MENU_UNIT_TARGETS_TARGET"] = "Target of Target"
L["MENU_UNIT_TARGETS_TARGET_DESCRIPTION"] =
	"Casts on your target's target, like the tank the enemy you're targeting is hitting, when it can take the spell."
L["MENU_UNIT_MOUSEOVER"] = "Mouse Over"
L["MENU_UNIT_MOUSEOVER_DESCRIPTION"] =
	"Casts on whoever is under your cursor, in the world or on a unit frame, when they can take the spell."
L["MENU_GROUP_TARGETING"] = "Targeting"
L["MENU_REPEAT"] = "Repeat"
L["MENU_OPTIONS_COUNT"] = "%d Options"
L["MENU_ENABLED"] = "Enabled"
L["MENU_RANK_LEARN_LEVEL"] = "%s (Level %d)"
L["MENU_HIGHEST"] = "Highest"
L["MENU_HIGHEST_DESCRIPTION"] = "Casts the highest rank you know."
L["MENU_RANK_DYNAMIC"] = "Dynamic"
L["MENU_FIXED_RANK_DESCRIPTION"] = "Always casts %s, at any level."
L["MENU_ANY_TIME"] = "Any Time"
L["MENU_ANY_TIME_DESCRIPTION"] = "Casts in or out of combat."
L["MENU_IN_COMBAT"] = "In Combat"
L["MENU_IN_COMBAT_DESCRIPTION"] = "Casts only in combat. Out of combat the macro does nothing, its items included."
L["MENU_OUT_OF_COMBAT_DESCRIPTION"] = "Casts only out of combat. In combat the macro does nothing, its items included."
L["MENU_EVERY_PRESS"] = "Every Press"
L["MENU_EVERY_PRESS_DESCRIPTION"] = "Casts every time you press it."
L["MENU_GROUP_VERSION_DESCRIPTION"] = "A right-click casts %s. A left-click still casts %s."
L["MENU_GROUPED_SPELL_DESCRIPTION"] =
	"Lets the macro cast %s. Of the spells ticked here, it casts the one you learned last, so it moves up as you train."
L["MENU_GROUPED_SPELL_NOT_LEARNED"] = "Not learned yet. Tick it now and the macro takes it up once you learn it."
L["MENU_PET_DESCRIPTION"] = "While your %s is out, the macro casts %s instead of summoning it again."
L["MENU_STANCE_DESCRIPTION"] = "Switches to %s first, unless you're in it already."
L["MENU_USE_ITEM_DESCRIPTION"] =
	"Uses it before the cast. Items go in the order you tick them, and the number after each shows its place."
L["MENU_ADD_FOCUS"] = "Add Focus Copy"
L["MENU_REMOVE_FOCUS"] = "Remove Focus Copy"
L["MENU_FOCUS_DESCRIPTION"] = "Adds a second macro to the page that casts on your focus, then your target."
L["MENU_DUPLICATE_DESCRIPTION"] =
	"Adds another copy of this macro to the page, starting with these options, so you can set it up differently."
L["MENU_MAKE_DEFAULT"] = "Make Default For %s"
L["MENU_MAKE_DEFAULT_DESCRIPTION"] =
	"Every macro under %s that you haven't set yourself starts with this macro's options. You can change them under Macro Defaults."
L["MENU_DEFAULT_SET"] =
	"%s now start with these options. Change them under Options > AddOns > Macro Spellbook > Macro Defaults."

-- Page: Settings Menu
L["SETTINGS_SHOW_UNLEARNED"] = "Show Unlearned Spells"
L["SETTINGS_COUNT_SPELLS_ON_BARS"] = "Count Spells On Bars As Placed"
L["SETTINGS_MARK_ALL_PLACED"] = "Mark All Spells As Placed"
L["SETTINGS_MARK_ALL_PLACED_DESCRIPTION"] =
	"Stops every macro on this page glowing, whether or not it's on your bars. A spell you learn later still glows until you place it."
L["SETTINGS_HIGHLIGHT_UNPLACED"] = "Highlight Unplaced Spells"
L["SETTINGS_HIGHLIGHT_UNPLACED_DESCRIPTION"] =
	"Makes every macro that isn't on your bars glow. Turn it off to mark them all placed, like the Mark All Spells As Placed button."
L["SETTINGS_OPEN_MACRO_DEFAULTS_DESCRIPTION"] =
	"Opens the Options Interface at Macro Defaults, where you pick the options each kind of spell macro starts with."
L["SETTINGS_OPEN_CUSTOM_MACROS_DESCRIPTION"] =
	"Opens the Options Interface at Custom Macros, where you write your own macros for this page."

-- Page: Macro Buttons
-- TRANSLATORS: each note fills the small slot under a macro button, so keep it short.
L["SUBTEXT_CUSTOM"] = "Custom"
L["SUBTEXT_FOCUS"] = "Focus"
L["SUBTEXT_PET"] = "Pet"
L["SUBTEXT_CURSOR"] = "Cursor"
L["SUBTEXT_STANCE"] = "Stance"
L["SUBTEXT_USE_ITEMS"] = "Use Items"
L["SUBTEXT_PET_ATTACK"] = "Pet Attack"
L["SUBTEXT_DYNAMIC_RANK"] = "Dynamic Rank"
L["SUBTEXT_TARGET_ENEMY"] = "Nearest Enemy"
L["SUBTEXT_TARGET_FRIEND"] = "Nearest Friend"
L["SUBTEXT_GROUP_VERSION"] = "Group Version"
L["SUBTEXT_TARGET_PRIORITY"] = "Target"
L["SUBTEXT_SOLO_VERSION"] = "Solo Version"
L["SUBTEXT_GROUPED_SPELLS"] = "Grouped"
L["SUBTEXT_ONCE_PER_COMBAT"] = "Once Per Combat"
L["SUBTEXT_ONCE_PER_TARGET"] = "Once Per Target"
L["SUBTEXT_COMBAT_ONLY"] = "Combat Only"
L["SUBTEXT_NO_COMBAT"] = "Out Of Combat"
L["SUBTEXT_LEAVE_FORM"] = "Leave Form"
L["SUBTEXT_NO_TOGGLE"] = "Stays On"
L["SUBTEXT_WAND"] = "Wand"
L["SUBTEXT_START_ATTACK"] = "Auto Attack"
L["SUBTEXT_STOP_ATTACK"] = "Stop Attack"
L["SUBTEXT_STOP_CASTING"] = "Stop Casting"
L["SUBTEXT_STOP_IF_CHANNELING"] = "Not While Channeling"
L["SUBTEXT_STOP_IF_STEALTHED"] = "Not While Stealthed"
L["SUBTEXT_HIDE_ERRORS"] = "Hide Errors"
L["SUBTEXT_MUTE_ERRORS"] = "Mute Errors"
L["SUBTEXT_OPTIONS_COUNT"] = "%d Options"
L["SUBTEXT_TOO_LONG"] = "Too Long"
L["SUBTEXT_LEARN_LEVEL"] = "Level %d"
L["SUBTEXT_TALENT"] = "Talent"

-- Page: Macro Tooltip
L["TOOLTIP_NOT_LEARNED"] = "Not Learned Yet"
L["TOOLTIP_LEARN_LEVEL"] = "Your class trainer teaches it at level %d."
L["TOOLTIP_LEARN_TALENT"] = "Learned from your talents."
L["TOOLTIP_NOT_ON_BARS"] = "Not On Your Action Bars"
L["TOOLTIP_TOO_LONG"] = "Too long: %d / %d bytes. Turn an option off to shorten it."
L["TOOLTIP_OPTIONS_ON"] = "Options On: %s"
L["TOOLTIP_EQUIPMENT_SLOT"] = "Uses whatever you wear in your %s slot, so it keeps working when you swap gear."
L["TOOLTIP_KEY_CLICK_DRAG"] = "Click Or Drag"
L["TOOLTIP_ACTION_PLACE_ON_BAR"] = "Place On Your Action Bars"
L["TOOLTIP_KEY_RIGHT_CLICK"] = "Right-Click"
L["TOOLTIP_ACTION_MACRO_OPTIONS"] = "Macro Options"

-- Spellbook Tab Tooltip
L["SPELLBOOK_TAB_DESCRIPTION"] = "Your class's spells as one-click macros."
L["TOOLTIP_KEY_CLICK"] = "Click"
L["TOOLTIP_ACTION_OPEN_PAGE"] = "Open Macro Spellbook"

-- Page: Layout
L["PAGE_EMPTY"] =
	"No macros yet. Visit your class trainer to learn your first spells, or add your own macros under Options > AddOns > Macro Spellbook > Custom Macros."
L["PAGE_MACRO_SLOTS"] = "Macro Slots"
L["TOOLTIP_MACRO_SLOTS"] =
	"Each macro you place takes a macro slot. Character slots belong to this character and fill first. General slots are shared by every character on your account."
L["PAGE_MACRO_GENERAL"] = "General"
L["PAGE_MACRO_CHARACTER"] = "Character"
L["PAGE_FOOTER"] =
	"Click or drag a macro onto your bars. A glowing macro isn't on your bars yet. Right-click a macro for its options."

-- Options: General Panel
L["OPTIONS_DESCRIPTION"] =
	"Mouseover, cursor and self-cast macros for every class spell, built in one click from a new spellbook tab with no macro syntax. They update as you level, train and swap specs. Right-click to add focus, stopcasting, auto attack, pet attack or trinkets."
L["OPTIONS_ENABLE_WELCOME"] = "Enable Welcome Message"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] = "Prints a one-line welcome with the version in chat each time you log in."
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Key Bindings"
L["OPTIONS_KEY_SET"] = "Set Key"
L["OPTIONS_KEY_SET_DESCRIPTION"] = "Opens the game's key binding list, where Macro Spellbook has its own section."
L["OPTIONS_KEY_BINDING_TOGGLE_DESCRIPTION"] =
	"Opens and closes Macro Spellbook. It also has its own tab in your spellbook."
L["OPTIONS_DELETE_MACROS_HEADER"] = "Delete Macros"
L["OPTIONS_DELETE_MACROS_DESCRIPTION"] =
	"Deletes the macros Macro Spellbook made, which also takes them off your action bars. Your own macros are never touched, and the page makes any of them again when you click or drag it."
L["OPTIONS_DELETE_CHARACTER_MACROS"] = "Delete Character Macros"
L["OPTIONS_DELETE_CHARACTER_MACROS_DESCRIPTION"] =
	"Deletes Macro Spellbook's macros from this character's macro tab. Your other characters keep theirs until you do the same on them."
L["OPTIONS_DELETE_CHARACTER_MACROS_CONFIRM"] =
	"Delete all of Macro Spellbook's macros on this character? They come off your action bars too."
L["OPTIONS_DELETE_GENERAL_MACROS"] = "Delete General Macros"
L["OPTIONS_DELETE_GENERAL_MACROS_DESCRIPTION"] =
	"Deletes Macro Spellbook's macros from the General macro tab, which every character on your account shares, so your other characters lose theirs there too."
L["OPTIONS_DELETE_GENERAL_MACROS_CONFIRM"] =
	"Delete all of Macro Spellbook's General macros? Every character on your account loses them, and they come off your action bars too."
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/msb"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."

-- Options: Spellbook Page Panel
L["TAB_SPELLBOOK_PAGE"] = "Spellbook Page"
L["OPTIONS_SPELLBOOK_PAGE_DESCRIPTION"] = "How the Macro Spellbook page in your spellbook lists your spells."
L["OPTIONS_SHOW_UNLEARNED_DESCRIPTION"] =
	"Lists the class spells you haven't learned yet in an Unlearned section, so you can place their macros early."
L["OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION"] =
	"Stops a macro glowing when its spell is already on your bars, even when the macro has options on."

-- Options: Macro Defaults Panel
L["TAB_MACRO_DEFAULTS"] = "Macro Defaults"
L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"] =
	"The options each kind of macro starts with: your item macros here, and each kind of spell macro on its own page below. Whatever you set on a macro from its right-click menu keeps your choice."
L["OPTIONS_DEFAULT_CURSOR_DESCRIPTION"] = "Places the spell where your cursor points, with no targeting circle."
L["OPTIONS_DEFAULT_DYNAMIC_RANK_DESCRIPTION"] = "Casts the highest rank the friendly player's level can take."
L["OPTIONS_DEFAULT_STOP_CASTING_DESCRIPTION"] = "Stops whatever you're casting first, so this spell goes off at once."
L["OPTIONS_DEFAULT_STOP_ATTACK_DESCRIPTION"] = "Stops your melee auto attack first."
L["OPTIONS_DEFAULT_STOP_IF_CHANNELING_DESCRIPTION"] =
	"Does nothing while you're channeling a spell, so a press never breaks the channel."
L["OPTIONS_DEFAULT_STOP_IF_STEALTHED_DESCRIPTION"] =
	"Does nothing while you're stealthed, so a press never breaks Stealth or Prowl."
L["OPTIONS_DEFAULT_LEAVE_FORM_DESCRIPTION"] = "Leaves your current form first, so the spell can be cast."
L["OPTIONS_DEFAULT_TARGET_ENEMY_DESCRIPTION"] =
	"Targets the nearest enemy first when you have no living enemy targeted."
L["OPTIONS_DEFAULT_TARGET_FRIEND_DESCRIPTION"] =
	"Targets the nearest friend first when you have no living friend targeted."
L["OPTIONS_DEFAULT_PET_ATTACK_DESCRIPTION"] = "Sends your pet to attack your target too."
L["OPTIONS_DEFAULT_START_ATTACK_DESCRIPTION"] = "Starts your melee auto attack after the cast."
L["OPTIONS_DEFAULT_AUTO_SHOT_DESCRIPTION"] = "Starts Auto Shot or your wand after the cast."
L["OPTIONS_DEFAULT_ONCE_PER_TARGET_DESCRIPTION"] = "Casts once, then not again until your target changes."
L["OPTIONS_DEFAULT_ONCE_PER_COMBAT_DESCRIPTION"] =
	"Casts once, then not again until combat ends or your target changes."
L["OPTIONS_DEFAULT_NEVER_TURN_OFF_DESCRIPTION"] =
	"Keeps the form or aspect on when you press the macro again, instead of turning it off."
L["OPTIONS_DEFAULT_HIDE_ERRORS_DESCRIPTION"] = "Clears the red error text the macro leaves on screen."
L["OPTIONS_DEFAULT_MUTE_ERRORS_DESCRIPTION"] = "Mutes the error sound while the macro runs."
L["OPTIONS_DEFAULT_COMBAT_CHECK_DESCRIPTION"] = "Lets these macros cast only in combat, only out of combat, or either."
L["OPTIONS_DEFAULT_REPEAT_DESCRIPTION"] = "Lets these macros cast every press, once per target, or once per combat."
L["OPTIONS_KIND_YOUR_SPELLS"] = "Your Spells"
L["OPTIONS_KIND_YOUR_ITEMS"] = "Your Items"
L["OPTIONS_KIND_MORE"] = "And %d more."
L["OPTIONS_KIND_NO_SPELLS"] = "None of your spells are this kind."
L["OPTIONS_KIND_NO_ITEMS"] = "None of your equipped items has a Use effect."
L["KIND_ENEMY"] = "Enemy Spells"
L["KIND_ENEMY_DESCRIPTION"] = "Spells you cast on an enemy, like your attacks and debuffs."
L["KIND_FRIENDLY"] = "Friendly Spells"
L["KIND_FRIENDLY_DESCRIPTION"] = "Spells you cast on a friend, like your heals."
L["KIND_BUFF"] = "Buffs"
L["KIND_BUFF_DESCRIPTION"] = "Spells that give a friend a lasting buff."
L["KIND_ANYONE"] = "Friend Or Foe Spells"
L["KIND_ANYONE_DESCRIPTION"] = "Spells you can cast on a friend or an enemy."
L["KIND_GROUND"] = "Ground-Targeted Spells"
L["KIND_GROUND_DESCRIPTION"] = "Spells you place on the ground."
L["KIND_FORM"] = "Forms, Stances And Aspects"
L["KIND_FORM_DESCRIPTION"] = "Spells that stay on until you turn them off or switch to another."
L["KIND_SELF"] = "Self And Area Spells"
L["KIND_SELF_DESCRIPTION"] = "Spells with no target, cast on yourself or around you."
L["KIND_ITEM"] = "Item Macros"
L["KIND_ITEM_DESCRIPTION"] = "Macros that use your equipped items, like trinkets."

-- Options: Custom Macros Panel
L["TAB_CUSTOM_MACROS"] = "Custom Macros"
L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"] =
	"Your own macros, listed on the page under Custom. Removing one here leaves its macro in /macro for you to delete."
L["OPTIONS_CUSTOM_ADD"] = "Add Macro"
L["OPTIONS_CUSTOM_ADD_DESCRIPTION"] = "Adds a new custom macro to the end of the list."
L["OPTIONS_CUSTOM_NEW_NAME"] = "New Macro"
L["OPTIONS_CUSTOM_NAME"] = "Name"
L["OPTIONS_CUSTOM_NAME_DESCRIPTION"] =
	"The macro's name. WoW keeps its first %d bytes, which is fewer letters in languages like Russian, Chinese or Korean."
L["OPTIONS_CUSTOM_SECTION"] = "Section"
L["OPTIONS_CUSTOM_SECTION_DESCRIPTION"] =
	"Where the macro is listed on the page: under Custom, or with the spells of one of your spellbook's tabs."
L["OPTIONS_CUSTOM_BODY_DESCRIPTION"] =
	"The macro's text, up to %d bytes. A first line of #showtooltip and a spell name shows that spell's icon."
L["OPTIONS_CUSTOM_STATUS_NEEDS"] = "This macro needs a name and macro text before it shows on the page."
L["OPTIONS_CUSTOM_STATUS_TOO_LONG"] = "Too long: %d / %d bytes. It won't show on the page until it fits."
L["OPTIONS_CUSTOM_STATUS_TAKEN"] = "Another macro on the page already has this name, so this one won't show."
L["OPTIONS_CUSTOM_REMOVE_DESCRIPTION"] = "Removes this macro from the list."
L["OPTIONS_CUSTOM_REMOVE_CONFIRM"] = "Remove this custom macro?"
L["OPTIONS_CUSTOM_RESTORE"] = "Restore Defaults"
L["OPTIONS_CUSTOM_RESTORE_DESCRIPTION"] = "Replaces your custom macros with the ones your class starts with."
L["OPTIONS_CUSTOM_RESTORE_CONFIRM"] = "Replace all your custom macros with your class's defaults?"

-- Options: Feedback & Support Panel
L["OPTIONS_LEVEL_UP_TITLE"] = "Help Macro Spellbook Level Up"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"This add-on was built by players who love this game and want to make it as fun as possible for everyone. We'll never ask for donations. The real satisfaction comes from knowing our work makes the game a little better for you. If it does, we'd love to hear about it!"
L["OPTIONS_LEVEL_UP_WAYS"] = "Here are a few ways you can help us reach more players."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Share Feedback: Found a bug or have an idea? Let us know on Discord. Your feedback helps us improve the add-on, and pull requests are always welcome."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Tell a Friend: Know someone who might enjoy this add-on? Tell them about it. Word of mouth helps more players discover great add-ons."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Favorite on CurseForge: Open the CurseForge link below, sign in, and click the star beneath the Download button. Favorites help more players discover the add-on."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Star on GitHub: Open the GitHub link below, sign in, and click Star in the top right. Stars help the project qualify for more free developer tools."
L["OPTIONS_LEVEL_UP_THANKS"] = "Thanks for choosing Macro Spellbook!"

L["OPTIONS_FEEDBACK"] = "Feedback & Support"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Feedback & Support Links"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "To copy a link, click its box, then press Ctrl+A and Ctrl+C."
L["OPTIONS_VERSION"] = "Version %s"

-- Key Bindings
L["BINDING_TOGGLE_PAGE"] = "Toggle Macro Spellbook"

-- Messages
L["CHAT_LOADED"] =
	"Version %s. Settings (including the option to disable this message) are under Options > AddOns > Macro Spellbook. Enjoying this add-on? Tell a friend, Favorite it on CurseForge, or Star it on GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "As a safety precaution, the Options Interface cannot be opened during combat."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "As a safety precaution, the key binding list cannot be opened during combat."
L["KEY_BINDINGS_LOCATION"] = "Open the game menu, then %s, then %s, and find the Macro Spellbook section."
L["ERROR_MACRO_SLOTS_FULL"] = "No free macro slots. Delete a macro in /macro to make room."
L["ERROR_GENERAL_MACRO_SLOTS_FULL"] = "No free general macro slots. Delete a general macro in /macro to make room."
L["CHAT_MACROS_DELETED"] = "Macros deleted: %d"
L["CHAT_MACRO_TOO_LONG"] =
	'The "%s" macro is %d bytes with its options on, over the %d a macro holds. Turn an option off to shorten it.'
L["CHAT_CUSTOM_NEEDS_NAME_BODY"] = "Custom macro #%d needs a name and macro text before it shows on the page."
L["CHAT_CUSTOM_TOO_LONG"] =
	'Custom macro "%s" is %d bytes, over the %d a macro holds. Shorten its text to add it to the page.'
L["CHAT_CUSTOM_NAME_TAKEN"] =
	'Custom macro "%s" shares its name (first %d bytes) with another macro on the page. Rename it to add it to the page.'
