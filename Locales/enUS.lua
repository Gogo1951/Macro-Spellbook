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
L["CUSTOM_PET_ABILITY_MOUSEOVER"] = "Pet Ability (Mouseover)"
L["CUSTOM_SWIFT_JUDGE"] = "Swift Judge"

-- Page: Macro Menu
L["MENU_GROUP_COMBAT_CHECK"] = "Combat Check"
L["MENU_GROUP_ABILITY_RANK"] = "Ability Rank"
L["MENU_GROUP_TARGETING"] = "Targeting"
L["MENU_GROUP_ATTACK"] = "Attack"
L["MENU_GROUP_UTILITY"] = "Utilities"
L["MENU_GROUP_SCRIPTS"] = "Scripts"
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
L["MENU_NEVER_TURN_OFF_NOTE"] = "Never Turn Off keeps it on when you press it again, instead of turning it off."
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
L["MENU_STOP_CASTING_NOTE"] = "Use Stop Casting on important spells like Decurse or Counterspell."
L["MENU_USE_BEFORE_CASTING"] = "Use Before Casting"

-- Page: Settings Menu
L["SETTINGS_SHOW_UNLEARNED"] = "Show Unlearned Abilities"
L["SETTINGS_COUNT_SPELLS_ON_BARS"] = "Count Abilities on Bars as Placed"
L["SETTINGS_MARK_ALL_PLACED"] = "Mark All Abilities as Placed"
L["SETTINGS_PET_ATTACK_DEFAULT"] = "Enable Pet attacks before spell cast"
L["SETTINGS_START_ATTACK_DEFAULT"] = "Start auto attack"
L["SETTINGS_STOP_CAST_DEFAULT"] = "Stop casting"

-- Page: Macro Buttons
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
L["SUBTEXT_AUTO_SHOT"] = "Auto Shot"
L["SUBTEXT_WAND"] = "Wand"
L["SUBTEXT_START_ATTACK"] = "Auto Attack"
L["SUBTEXT_STOP_ATTACK"] = "Stop Attack"
L["SUBTEXT_STOP_CASTING"] = "Stop Casting"
L["SUBTEXT_HIDE_ERRORS"] = "Hide Errors"
L["SUBTEXT_MUTE_ERRORS"] = "Mute Errors"
L["SUBTEXT_MACRO"] = "Macro"
L["SUBTEXT_SELF"] = "Self"
L["SUBTEXT_OPTIONS_COUNT"] = "%d Options"
L["TOOLTIP_NOT_LEARNED"] = "Not Learned Yet"
L["TOOLTIP_NOT_ON_BARS"] = "Not On Your Action Bars"
L["TOOLTIP_KEY_CLICK_DRAG"] = "Click & Drag"
L["TOOLTIP_ACTION_PLACE_ON_BAR"] = "Place On Your Action Bars"
L["TOOLTIP_KEY_RIGHT_CLICK"] = "Right-Click"
L["TOOLTIP_ACTION_MACRO_OPTIONS"] = "Macro Options"
L["PAGE_EMPTY"] = "No macros found."
L["PAGE_MACRO_SLOTS"] = "Macro Slots"
L["PAGE_MACRO_GENERAL"] = "General"
L["PAGE_MACRO_CHARACTER"] = "Character"
L["PAGE_FOOTER"] = "Click or drag a macro onto your bars. Right-click it for options. The gear sets defaults."

-- Options: General Panel
L["OPTIONS_DESCRIPTION"] =
	"Adds a spellbook tab of one-click macros for your class's spells, with mouseover and cursor options."
L["OPTIONS_ENABLE_WELCOME"] = "Enable Welcome Message"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] = "Prints a one-line welcome with the version in chat each time you log in."
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/msb"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."

-- Options: Spellbook Page Panel
L["TAB_SPELLBOOK_PAGE"] = "Spellbook Page"
L["OPTIONS_SPELLBOOK_PAGE_DESCRIPTION"] =
	"How the Macro Spellbook page in your spellbook lists your spells, and the defaults its macros start from."
L["OPTIONS_SHOW_UNLEARNED_DESCRIPTION"] =
	"Lists the class spells you haven't learned yet in an Unlearned section, so you can place their macros early."
L["OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION"] =
	"A spell placed on your bars as itself stops its macro glowing, even when the macro has options on."
L["OPTIONS_PET_ATTACK_DEFAULT_DESCRIPTION"] =
	"Every enemy spell macro you haven't set yourself sends your pet to attack before the cast."
L["OPTIONS_START_ATTACK_DEFAULT_DESCRIPTION"] = "Every spell macro you haven't set yourself starts your auto attack."
L["OPTIONS_STOP_CAST_DEFAULT_DESCRIPTION"] =
	"Every spell macro you haven't set yourself stops your current cast before casting."

-- Options: Custom Macros Panel
L["TAB_CUSTOM_MACROS"] = "Custom Macros"
L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"] =
	"Your own macros, listed on the page under Custom. Editing one updates its macro the next time the page opens; removing one leaves the macro in /macro for you to delete."
L["OPTIONS_CUSTOM_ADD"] = "Add Macro"
L["OPTIONS_CUSTOM_ADD_DESCRIPTION"] = "Adds a new custom macro to the end of the list."
L["OPTIONS_CUSTOM_NEW_NAME"] = "New Macro"
L["OPTIONS_CUSTOM_NAME"] = "Name"
L["OPTIONS_CUSTOM_NAME_DESCRIPTION"] = "The macro's name, up to %d characters."
L["OPTIONS_CUSTOM_BODY"] = "Macro Text"
L["OPTIONS_CUSTOM_BODY_DESCRIPTION"] =
	"The macro's text, up to 255 characters. A first line of #showtooltip and a spell name shows that spell's icon."
L["OPTIONS_CUSTOM_REMOVE"] = "Remove this macro from the list."
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

-- Messages
L["CHAT_LOADED"] =
	"Version %s. Settings (including the option to disable this message) are under Options > AddOns > Macro Spellbook. Enjoying this add-on? Tell a friend, Favorite it on CurseForge, or Star it on GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "As a safety precaution, the Options Interface cannot be opened during combat."
L["ERROR_NO_FREE_MACRO_SLOTS"] = "No free macro slots."
L["ERROR_NO_FREE_GENERAL_MACRO_SLOTS"] = "No free general macro slots."
L["CHAT_MACRO_NAME_TAKEN"] =
	'You already have a macro named "%s", so it was left alone. Rename or delete it in /macro to use this one.'
L["CHAT_CUSTOM_NEEDS_NAME_BODY"] = "Custom macro #%d needs a name and a body."
L["CHAT_CUSTOM_TOO_LONG"] = 'Custom macro "%s" is %d characters; macros allow %d.'
L["CHAT_CUSTOM_NAME_TAKEN"] = 'Custom macro "%s" has the same name (first %d characters) as another macro on the page.'
