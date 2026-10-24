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
L["CUSTOM_SPAM_WAND"] = "Spam Wand"
L["CUSTOM_PET_ABILITY"] = "Pet Ability"
L["CUSTOM_PET_ABILITY_MOUSEOVER"] = "Pet (Mouseover)"
L["CUSTOM_SWIFT_JUDGE"] = "Swift Judge"

-- Page: Macro Menu
L["MENU_GROUP_COMBAT_CHECK"] = "Combat Check"
L["MENU_GROUP_ABILITY_RANK"] = "Spell Rank"
L["MENU_GROUP_TARGETING"] = "Targeting"
L["MENU_GROUP_BEFORE_CAST"] = "Before Casting"
L["MENU_GROUP_AFTER_CAST"] = "After Casting"
L["MENU_GROUP_CASTING_RULES"] = "Casting Rules"
L["MENU_GROUP_ERRORS"] = "Error Messages"
L["MENU_GROUP_USE_ITEMS_FIRST"] = "Use Items First"
L["MENU_MACRO_TEXT"] = "Macro Text"
L["MENU_MACRO_LENGTH"] = "%d / %d"
L["MENU_GROUP_VALUE"] = "%s: %s"
L["MENU_OPTIONS_COUNT"] = "%d Options"
L["MENU_CAST_ON_MOUSEOVER"] = "Cast On Mouseover"
L["MENU_CAST_ON_SELF"] = "Cast On Self"
L["MENU_CAST_ON_TARGETS_TARGET"] = "Cast On Target's Target"
L["MENU_MAX_RANK"] = "Max Rank"
L["MENU_DYNAMIC_RANK"] = "Dynamic Rank"
L["MENU_DYNAMIC_RANK_NOTE"] = "Dynamic Rank, based on a friendly player's level, only updates out of combat."
L["MENU_CAST_AT_CURSOR"] = "Cast At Cursor"
L["MENU_TARGET_NEAREST_ENEMY"] = "Target Nearest Enemy"
L["MENU_CAST_IF_SUMMONED"] = "Cast %s If Summoned"
L["MENU_DOWNRANK_IN_RAIDS"] = "Downrank In Raids"
L["MENU_NEVER_TURN_OFF"] = "Never Turn Off"
L["MENU_NEVER_TURN_OFF_NOTE"] =
	"Never Turn Off keeps the ability on when you press the macro again, instead of turning it off."
L["MENU_LEAVE_FORM_BEFORE"] = "Leave Form Before Casting"
L["MENU_RIGHT_CLICK_FOR"] = "Right-Click For %s"
L["MENU_ONLY_IN_COMBAT"] = "Only In Combat"
L["MENU_NEVER_IN_COMBAT"] = "Never In Combat"
L["MENU_COMBAT_CHECK_NONE"] = "None"
L["MENU_ONCE_PER_COMBAT"] = "Cast Once Per Combat"
L["MENU_ONCE_PER_TARGET"] = "Cast Once Per Target"
L["MENU_HIDE_ERRORS"] = "Hide Error Messages"
L["MENU_MUTE_ERRORS"] = "Mute Error Sounds"
L["MENU_SPAMMABLE"] = "Spammable"
L["MENU_SWITCH_TO"] = "Switch To %s"
L["MENU_CAST_ON_FOCUS"] = "Cast On Focus"
L["MENU_ENABLE_PET_ATTACK"] = "Enable Pet Attack"
L["MENU_START_AUTO_ATTACK"] = "Start Auto Attack"
L["MENU_STOP_ATTACK"] = "Stop Attack"
L["MENU_START_AUTO_SHOT"] = "Start Auto Shot"
L["MENU_START_WAND"] = "Start Wand"
L["MENU_STOP_CASTING"] = "Stop Casting"
L["MENU_STOP_CASTING_NOTE"] = "Use Stop Casting on spells that can't wait, like interrupts and dispels."

-- Page: Settings Menu
L["SETTINGS_SHOW_UNLEARNED"] = "Show Unlearned Spells"
L["SETTINGS_COUNT_SPELLS_ON_BARS"] = "Count Spells On Bars As Placed"
L["SETTINGS_MARK_ALL_PLACED"] = "Mark All Spells As Placed"
L["SETTINGS_MARK_ALL_PLACED_DESCRIPTION"] =
	"Stops every macro on this page glowing, wherever it is. A spell you learn later still glows until you place it."
L["SETTINGS_CLEAR_PLACED"] = "Clear Placed Marks"
L["SETTINGS_CLEAR_PLACED_DESCRIPTION"] = "Puts the glow back on every marked macro that isn't on your bars."
L["SETTINGS_OPEN_OPTIONS"] = "Open Options"
L["SETTINGS_OPEN_OPTIONS_DESCRIPTION"] =
	"Opens Macro Spellbook in the Options Interface, where your custom macros live."

-- Page: Macro Buttons
-- TRANSLATORS: each note fills the small slot under a macro button, so keep it short.
L["SUBTEXT_CUSTOM"] = "Custom"
L["SUBTEXT_FOCUS"] = "Focus"
L["SUBTEXT_PET"] = "Pet"
L["SUBTEXT_CURSOR"] = "Cursor"
L["SUBTEXT_MOUSEOVER"] = "Mouseover"
L["SUBTEXT_CAST_ON_SELF"] = "On Self"
L["SUBTEXT_STANCE"] = "Stance"
L["SUBTEXT_USE_ITEMS"] = "Use Items"
L["SUBTEXT_PET_ATTACK"] = "Pet Attack"
L["SUBTEXT_RAID_RANK_1"] = "Raid R1"
L["SUBTEXT_SPAMMABLE"] = "Spammable"
L["SUBTEXT_DYNAMIC_RANK"] = "Dynamic Rank"
L["SUBTEXT_TARGETS_TARGET"] = "Target's Target"
L["SUBTEXT_TARGET_ENEMY"] = "Nearest Enemy"
L["SUBTEXT_GROUP_VERSION"] = "Group Version"
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
L["SUBTEXT_HIDE_ERRORS"] = "Hide Errors"
L["SUBTEXT_MUTE_ERRORS"] = "Mute Errors"
L["SUBTEXT_OPTIONS_COUNT"] = "%d Options"
L["SUBTEXT_TOO_LONG"] = "Too Long"
L["SUBTEXT_NAME_TAKEN"] = "Name Taken"

-- Page: Macro Tooltip
L["TOOLTIP_NOT_LEARNED"] = "Not Learned Yet"
L["TOOLTIP_NOT_ON_BARS"] = "Not On Your Action Bars"
L["TOOLTIP_TOO_LONG"] = "Too long: %d / %d bytes. Turn an option off to shorten it."
L["TOOLTIP_NAME_TAKEN"] = 'You already have a macro named "%s". Rename or delete it in /macro to use this one.'
L["TOOLTIP_KEY_CLICK_DRAG"] = "Click or Drag"
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
L["PAGE_MACRO_GENERAL"] = "General"
L["PAGE_MACRO_CHARACTER"] = "Character"
L["PAGE_FOOTER"] =
	"Click or drag a macro onto your bars. A glowing macro isn't on your bars yet. Right-click a macro for its options."

-- Options: General Panel
L["OPTIONS_DESCRIPTION"] =
	"Mouseover macros, cursor casting and self-cast macros for every class spell, built in one click from a new spellbook tab with no macro syntax. Right-click to add focus, spell rank, downrank, stopcasting, auto attack, pet attack or trinket use."
L["OPTIONS_ENABLE_WELCOME"] = "Enable Welcome Message"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] = "Prints a one-line welcome with the version in chat each time you log in."
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Key Bindings"
L["OPTIONS_KEY_SET"] = "Set Key"
L["OPTIONS_KEY_SET_DESCRIPTION"] = "Opens the game's key binding list, where Macro Spellbook has its own section."
L["OPTIONS_KEY_BINDING_TOGGLE_DESCRIPTION"] =
	"Opens and closes Macro Spellbook. It also has its own tab in your spellbook."
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/msb"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."

-- Options: Spellbook Page Panel
L["TAB_SPELLBOOK_PAGE"] = "Spellbook Page"
L["OPTIONS_SPELLBOOK_PAGE_DESCRIPTION"] = "How the Macro Spellbook page in your spellbook lists your spells."
L["OPTIONS_SHOW_UNLEARNED_DESCRIPTION"] =
	"Lists the class spells you haven't learned yet in an Unlearned section, so you can place their macros early."
L["OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION"] =
	"A spell placed on your bars as itself stops its macro glowing, even when the macro has options on."

-- Options: Macro Defaults Panel
L["TAB_MACRO_DEFAULTS"] = "Macro Defaults"
L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"] =
	"The options each kind of spell macro starts with. Whatever you set on a macro from its right-click menu keeps your choice. Each kind lists only the options its spells offer."
L["OPTIONS_KIND_EXAMPLES"] = "Your spells: %s"
L["OPTIONS_KIND_EXAMPLES_MORE"] = "%s and %d more"
L["KIND_ENEMY"] = "Enemy Spells"
L["KIND_ENEMY_DESCRIPTION"] = "Spells you cast on an enemy, like your attacks and debuffs."
L["KIND_FRIENDLY"] = "Friendly Spells"
L["KIND_FRIENDLY_DESCRIPTION"] = "Spells you cast on a friend, like your heals and buffs."
L["KIND_ANYONE"] = "Friend Or Foe Spells"
L["KIND_ANYONE_DESCRIPTION"] = "Spells you can cast on a friend or an enemy."
L["KIND_GROUND"] = "Ground-Targeted Spells"
L["KIND_GROUND_DESCRIPTION"] = "Spells you place on the ground."
L["KIND_FORM"] = "Forms, Stances And Aspects"
L["KIND_FORM_DESCRIPTION"] = "Spells that stay on until you turn them off or switch to another."
L["KIND_SELF"] = "Self And Area Spells"
L["KIND_SELF_DESCRIPTION"] = "Spells with no target, cast on yourself or around you."

-- Options: Custom Macros Panel
L["TAB_CUSTOM_MACROS"] = "Custom Macros"
L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"] =
	"Your own macros, listed on the page under Custom. Removing one here leaves its macro in /macro for you to delete."
L["OPTIONS_CUSTOM_ADD"] = "Add Macro"
L["OPTIONS_CUSTOM_ADD_DESCRIPTION"] = "Adds a new custom macro to the end of the list."
L["OPTIONS_CUSTOM_NEW_NAME"] = "New Macro"
L["OPTIONS_CUSTOM_NAME"] = "Name"
L["OPTIONS_CUSTOM_NAME_DESCRIPTION"] = "The macro's name, up to %d characters."
L["OPTIONS_CUSTOM_SECTION"] = "Section"
L["OPTIONS_CUSTOM_SECTION_DESCRIPTION"] =
	"Where the macro is listed on the page: under Custom, or with the spells of one of your spellbook's tabs."
L["OPTIONS_CUSTOM_BODY"] = "Macro Text"
L["OPTIONS_CUSTOM_BODY_DESCRIPTION"] =
	"The macro's text, up to 255 bytes. A first line of #showtooltip and a spell name shows that spell's icon."
L["OPTIONS_CUSTOM_STATUS_NEEDS"] = "This macro needs a name and macro text before it shows on the page."
L["OPTIONS_CUSTOM_STATUS_TOO_LONG"] = "Too long: %d / %d bytes. It won't show on the page until it fits."
L["OPTIONS_CUSTOM_STATUS_TAKEN"] = "Another macro on the page already has this name, so this one won't show."
L["OPTIONS_CUSTOM_REMOVE"] = "Removes this macro from the list."
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
L["ERROR_NO_FREE_MACRO_SLOTS"] = "No free macro slots."
L["ERROR_NO_FREE_GENERAL_MACRO_SLOTS"] = "No free general macro slots."
L["CHAT_MACRO_NAME_TAKEN"] =
	'You already have a macro named "%s", so it was left alone. Rename or delete it in /macro to use this one.'
L["CHAT_MACRO_TOO_LONG"] =
	'The "%s" macro is %d bytes with its options on, over the %d a macro holds. Turn an option off to shorten it.'
L["CHAT_CUSTOM_NEEDS_NAME_BODY"] = "Custom macro #%d needs a name and macro text before it shows on the page."
L["CHAT_CUSTOM_TOO_LONG"] =
	'Custom macro "%s" is %d bytes, over the %d a macro holds. Shorten its text to add it to the page.'
L["CHAT_CUSTOM_NAME_TAKEN"] =
	'Custom macro "%s" shares its name (first %d characters) with another macro on the page. Rename it to add it to the page.'
