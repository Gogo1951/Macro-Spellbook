local L = LibStub("AceLocale-3.0"):NewLocale("MacroSpellbook", "zhTW")
if not L then
	return
end

-- Add-on Names
L["ADDON_TITLE"] = "Macro Spellbook"
L["ADDON_SHORT_NAME"] = "Macro Spellbook"

-- Page: Sections
L["SECTION_UNLEARNED"] = "未學會"
L["SECTION_CUSTOM"] = "自訂"
L["SECTION_EQUIPMENT"] = "裝備"

-- Page: Default Custom Macros
-- TRANSLATORS: each name becomes a WoW macro name, cut to 16 bytes (about 5 Chinese or Korean characters), so keep it short.
L["CUSTOM_SPAM_WAND"] = "魔杖連發"
L["CUSTOM_PET_ABILITY"] = "寵物技能"
L["CUSTOM_PET_ABILITY_MOUSEOVER"] = "寵物(指向)"
L["CUSTOM_SWIFT_JUDGE"] = "快速審判"

-- Page: Macro Menu
L["MENU_GROUP_COMBAT_CHECK"] = "戰鬥條件"
L["MENU_GROUP_SPELL_RANK"] = "法術等級"
L["MENU_GROUP_TARGETING"] = "選取目標"
L["MENU_GROUP_BEFORE_CAST"] = "施法前"
L["MENU_GROUP_ADD_ATTACK"] = "加入攻擊"
L["MENU_GROUP_CASTING_RULES"] = "施法規則"
L["MENU_GROUP_ERRORS"] = "錯誤訊息"
L["MENU_GROUP_USE_ITEMS_FIRST"] = "先使用物品"
L["MACRO_TEXT"] = "巨集內容"
L["MENU_MACRO_LENGTH"] = "%d / %d"
L["MENU_GROUP_VALUE"] = "%s：%s"
L["MENU_OPTIONS_COUNT"] = "%d 個選項"
L["MENU_CAST_ON_MOUSEOVER"] = "對滑鼠指向目標施放"
L["MENU_CAST_ON_SELF"] = "對自己施放"
L["MENU_CAST_ON_TARGETS_TARGET"] = "對目標的目標施放"
L["MENU_RANK_LEARN_LEVEL"] = "%s (%d級可學)"
L["MENU_MAX_RANK"] = "最高等級"
L["MENU_DYNAMIC_RANK"] = "動態等級"
L["MENU_DYNAMIC_RANK_NOTE"] = "動態等級依友方玩家的等級決定，只在非戰鬥狀態下更新。"
L["MENU_CAST_AT_CURSOR"] = "在游標處施放"
L["MENU_TARGET_NEAREST_ENEMY"] = "選取最近的敵人"
L["MENU_TARGET_NEAREST_FRIEND"] = "選取最近的友方"
L["MENU_CAST_IF_SUMMONED"] = "寵物已召喚時施放%s"
L["MENU_NEVER_TURN_OFF"] = "永不關閉"
L["MENU_LEAVE_FORM_BEFORE"] = "施法前取消形態"
L["MENU_RIGHT_CLICK_FOR"] = "右鍵點擊：%s"
L["MENU_ONLY_IN_COMBAT"] = "僅在戰鬥中"
L["MENU_NEVER_IN_COMBAT"] = "從不在戰鬥中"
L["MENU_COMBAT_CHECK_NONE"] = "無"
L["MENU_ONCE_PER_COMBAT"] = "每場戰鬥施放一次"
L["MENU_ONCE_PER_TARGET"] = "每個目標施放一次"
L["MENU_HIDE_ERRORS"] = "隱藏錯誤訊息"
L["MENU_MUTE_ERRORS"] = "關閉錯誤音效"
L["MENU_SWITCH_TO"] = "切換為%s"
L["MENU_CAST_ON_FOCUS"] = "對專注目標施放"
L["MENU_START_AUTO_ATTACK"] = "開始自動攻擊"
L["MENU_STOP_ATTACK"] = "停止攻擊"
L["MENU_START_AUTO_SHOT"] = "開始自動射擊"
L["MENU_START_PET_ATTACK"] = "開始寵物攻擊"
L["MENU_START_WAND"] = "開始魔杖射擊"
L["MENU_STOP_CASTING"] = "停止施法"
L["MENU_STOP_CASTING_NOTE"] = "對斷法、驅散這類不能等待的法術使用停止施法。"
L["MENU_STOP_IF_CHANNELING"] = "引導時停止巨集"
L["MENU_STOP_IF_STEALTHED"] = "潛行時停止巨集"
L["MENU_SAFE_TO_SPAM_NOTE"] =
	"想讓巨集可以放心連按，引導法術請開啟引導時停止巨集，潛行請開啟潛行時停止巨集。這樣再次按下就不會打斷引導，也不會讓你脫離潛行。"
L["MENU_USE_FOR_KIND"] = "對所有%s使用這些選項"
L["MENU_DUPLICATE"] = "複製"
L["MENU_REMOVE_COPY"] = "移除此複本"
L["MENU_USE_FOR_KIND_DESCRIPTION"] =
	"%s中你沒有親自設定過的每個巨集，都會以這個巨集的選項為初始選項。會開啟巨集預設設定給你查看。"

-- Page: Settings Menu
L["SETTINGS_SHOW_UNLEARNED"] = "顯示未學會的法術"
L["SETTINGS_COUNT_SPELLS_ON_BARS"] = "快捷列上的法術視為已放置"
L["SETTINGS_MARK_ALL_PLACED"] = "將所有法術標記為已放置"
L["SETTINGS_MARK_ALL_PLACED_DESCRIPTION"] =
	"本頁的所有巨集不再發光，無論是否在你的快捷列上。之後學會的法術在放置前仍會發光。"
L["SETTINGS_CLEAR_PLACED"] = "清除放置標記"
L["SETTINGS_CLEAR_PLACED_DESCRIPTION"] = "讓每個不在快捷列上的已標記巨集重新發光。"
L["SETTINGS_OPEN_MACRO_DEFAULTS_DESCRIPTION"] =
	"在選項介面中開啟巨集預設設定，你可以在那裡選擇每種法術巨集的初始選項。"
L["SETTINGS_OPEN_CUSTOM_MACROS_DESCRIPTION"] =
	"在選項介面中開啟自訂巨集，你可以在那裡為本頁撰寫自己的巨集。"

-- Page: Macro Buttons
-- TRANSLATORS: each note fills the small slot under a macro button, so keep it short.
L["SUBTEXT_CUSTOM"] = "自訂"
L["SUBTEXT_FOCUS"] = "專注目標"
L["SUBTEXT_PET"] = "寵物"
L["SUBTEXT_CURSOR"] = "游標"
L["SUBTEXT_MOUSEOVER"] = "滑鼠指向"
L["SUBTEXT_CAST_ON_SELF"] = "自己"
L["SUBTEXT_STANCE"] = "姿態"
L["SUBTEXT_USE_ITEMS"] = "使用物品"
L["SUBTEXT_PET_ATTACK"] = "寵物攻擊"
L["SUBTEXT_DYNAMIC_RANK"] = "動態等級"
L["SUBTEXT_TARGETS_TARGET"] = "目標的目標"
L["SUBTEXT_TARGET_ENEMY"] = "最近敵人"
L["SUBTEXT_TARGET_FRIEND"] = "最近友方"
L["SUBTEXT_GROUP_VERSION"] = "團體版本"
L["SUBTEXT_ONCE_PER_COMBAT"] = "每戰一次"
L["SUBTEXT_ONCE_PER_TARGET"] = "每目標一次"
L["SUBTEXT_COMBAT_ONLY"] = "僅戰鬥中"
L["SUBTEXT_NO_COMBAT"] = "非戰鬥"
L["SUBTEXT_LEAVE_FORM"] = "取消形態"
L["SUBTEXT_NO_TOGGLE"] = "保持開啟"
L["SUBTEXT_WAND"] = "魔杖"
L["SUBTEXT_START_ATTACK"] = "自動攻擊"
L["SUBTEXT_STOP_ATTACK"] = "停止攻擊"
L["SUBTEXT_STOP_CASTING"] = "停止施法"
L["SUBTEXT_STOP_IF_CHANNELING"] = "引導時不施放"
L["SUBTEXT_STOP_IF_STEALTHED"] = "潛行時不施放"
L["SUBTEXT_HIDE_ERRORS"] = "隱藏錯誤"
L["SUBTEXT_MUTE_ERRORS"] = "錯誤靜音"
L["SUBTEXT_OPTIONS_COUNT"] = "%d 個選項"
L["SUBTEXT_TOO_LONG"] = "過長"
L["SUBTEXT_LEARN_LEVEL"] = "%d級"
L["SUBTEXT_TALENT"] = "天賦"

-- Page: Macro Tooltip
L["TOOLTIP_NOT_LEARNED"] = "尚未學會"
L["TOOLTIP_LEARN_LEVEL"] = "你的職業訓練師在%d級時傳授。"
L["TOOLTIP_LEARN_TALENT"] = "透過天賦學會。"
L["TOOLTIP_NOT_ON_BARS"] = "不在你的快捷列上"
L["TOOLTIP_TOO_LONG"] = "過長：%d / %d 位元組。關閉一個選項來縮短它。"
L["TOOLTIP_OPTIONS_ON"] = "已開啟選項：%s"
L["TOOLTIP_EQUIPMENT_SLOT"] = "使用你%s欄位上穿戴的物品，因此更換裝備後仍然有效。"
L["TOOLTIP_KEY_CLICK_DRAG"] = "點擊或拖曳"
L["TOOLTIP_ACTION_PLACE_ON_BAR"] = "放到你的快捷列上"
L["TOOLTIP_KEY_RIGHT_CLICK"] = "右鍵點擊"
L["TOOLTIP_ACTION_MACRO_OPTIONS"] = "巨集選項"

-- Spellbook Tab Tooltip
L["SPELLBOOK_TAB_DESCRIPTION"] = "把你的職業法術做成一鍵巨集。"
L["TOOLTIP_KEY_CLICK"] = "點擊"
L["TOOLTIP_ACTION_OPEN_PAGE"] = "開啟 Macro Spellbook"

-- Page: Layout
L["PAGE_EMPTY"] =
	"還沒有巨集。去找你的職業訓練師學習第一批法術，或在 選項 > 插件 > Macro Spellbook > 自訂巨集 中加入你自己的巨集。"
L["PAGE_MACRO_SLOTS"] = "巨集欄位"
L["TOOLTIP_MACRO_SLOTS"] =
	"你放置的每個巨集都會佔用一個巨集欄位。角色欄位專屬於這個角色，並優先佔用。一般欄位由你帳號中的所有角色共用。"
L["PAGE_MACRO_GENERAL"] = "一般"
L["PAGE_MACRO_CHARACTER"] = "角色"
L["PAGE_FOOTER"] =
	"點擊巨集或將它拖曳到快捷列上。發光的巨集還不在你的快捷列上。右鍵點擊巨集可開啟它的選項。"

-- Options: General Panel
L["OPTIONS_DESCRIPTION"] =
	"在新的法術書分頁中一鍵把每個職業法術做成滑鼠指向巨集、游標施放巨集和自我施放巨集，不需巨集語法。升級、訓練或切換專精時會自動更新。右鍵即可加入專注目標、停止施法、自動攻擊、寵物攻擊或使用飾品。"
L["OPTIONS_ENABLE_WELCOME"] = "啟用歡迎訊息"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] = "每次登入時在聊天視窗顯示一行附帶版本的歡迎訊息。"
L["OPTIONS_KEY_BINDINGS_HEADER"] = "按鍵設定"
L["OPTIONS_KEY_SET"] = "設定按鍵"
L["OPTIONS_KEY_SET_DESCRIPTION"] = "開啟遊戲的按鍵設定清單，Macro Spellbook 在其中有自己的分類。"
L["OPTIONS_KEY_BINDING_TOGGLE_DESCRIPTION"] =
	"開啟或關閉 Macro Spellbook。它在你的法術書中也有自己的分頁。"
L["OPTIONS_COMMANDS_HEADER"] = "/指令"
L["OPTIONS_COMMAND"] = "/msb"
L["OPTIONS_COMMAND_DESCRIPTION"] = "開啟此插件的選項介面。"

-- Options: Spellbook Page Panel
L["TAB_SPELLBOOK_PAGE"] = "法術書頁面"
L["OPTIONS_SPELLBOOK_PAGE_DESCRIPTION"] = "法術書中 Macro Spellbook 頁面如何列出你的法術。"
L["OPTIONS_SHOW_UNLEARNED_DESCRIPTION"] =
	"在未學會分類中列出你尚未學會的職業法術，方便提前放置它們的巨集。"
L["OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION"] =
	"法術已在快捷列上時，它的巨集就不再發光，即使該巨集開啟了選項。"

-- Options: Macro Defaults Panel
L["TAB_MACRO_DEFAULTS"] = "巨集預設設定"
L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"] =
	"每種法術巨集一開始使用的選項。巨集會保留你在其右鍵選單中設定的內容。每種類型只列出其法術提供的選項。"
L["OPTIONS_DEFAULT_MOUSEOVER_DESCRIPTION"] = "先對滑鼠指向的單位施放，其次是你的目標。"
L["OPTIONS_DEFAULT_CAST_ON_SELF_DESCRIPTION"] = "你的目標無法接受該法術時，對你自己施放。"
L["OPTIONS_DEFAULT_TARGETS_TARGET_DESCRIPTION"] =
	"你的目標無法接受該法術時，嘗試對目標的目標施放，例如敵人正在攻擊的坦克。"
L["OPTIONS_DEFAULT_CURSOR_DESCRIPTION"] = "把法術放在游標所指的位置，不出現瞄準圈。"
L["OPTIONS_DEFAULT_DYNAMIC_RANK_DESCRIPTION"] = "施放友方玩家等級所能接受的最高等級。"
L["OPTIONS_DEFAULT_STOP_CASTING_DESCRIPTION"] = "先停止你正在施放的法術，讓這個法術立刻施放。"
L["OPTIONS_DEFAULT_STOP_ATTACK_DESCRIPTION"] = "先停止你的近戰自動攻擊。"
L["OPTIONS_DEFAULT_STOP_IF_CHANNELING_DESCRIPTION"] =
	"你在引導法術時不做任何事，因此按下也絕不會打斷引導。"
L["OPTIONS_DEFAULT_STOP_IF_STEALTHED_DESCRIPTION"] =
	"你在潛行時不做任何事，因此按下也絕不會打破潛行。"
L["OPTIONS_DEFAULT_LEAVE_FORM_DESCRIPTION"] = "先取消你目前的形態，以便施放法術。"
L["OPTIONS_DEFAULT_TARGET_ENEMY_DESCRIPTION"] = "當你沒有選取活著的敵人時，先選取最近的敵人。"
L["OPTIONS_DEFAULT_TARGET_FRIEND_DESCRIPTION"] = "當你沒有選取活著的友方時，先選取最近的友方。"
L["OPTIONS_DEFAULT_PET_ATTACK_DESCRIPTION"] = "同時讓你的寵物攻擊你的目標。"
L["OPTIONS_DEFAULT_START_ATTACK_DESCRIPTION"] = "施法後開始你的近戰自動攻擊。"
L["OPTIONS_DEFAULT_AUTO_SHOT_DESCRIPTION"] = "施法後開始自動射擊或魔杖射擊。"
L["OPTIONS_DEFAULT_ONCE_PER_TARGET_DESCRIPTION"] = "施放一次，直到你的目標改變前不再施放。"
L["OPTIONS_DEFAULT_ONCE_PER_COMBAT_DESCRIPTION"] =
	"施放一次，直到戰鬥結束或你的目標改變前不再施放。"
L["OPTIONS_DEFAULT_NEVER_TURN_OFF_DESCRIPTION"] =
	"再次按下巨集時保持形態或守護開啟，而不是將其關閉。"
L["OPTIONS_DEFAULT_HIDE_ERRORS_DESCRIPTION"] = "清除巨集在畫面上留下的紅色錯誤文字。"
L["OPTIONS_DEFAULT_MUTE_ERRORS_DESCRIPTION"] = "巨集執行期間關閉錯誤音效。"
L["OPTIONS_DEFAULT_COMBAT_CHECK_DESCRIPTION"] =
	"讓這些巨集只在戰鬥中、只在非戰鬥中或在任何時候施放。"
L["OPTIONS_KIND_EXAMPLES"] = "你的法術：%s"
L["OPTIONS_KIND_EXAMPLES_MORE"] = "%s 等另外 %d 個"
L["KIND_ENEMY"] = "敵對法術"
L["KIND_ENEMY_DESCRIPTION"] = "對敵人施放的法術，例如攻擊和減益效果。"
L["KIND_FRIENDLY"] = "友方法術"
L["KIND_FRIENDLY_DESCRIPTION"] = "對友方施放的法術，例如治療。"
L["KIND_BUFF"] = "增益法術"
L["KIND_BUFF_DESCRIPTION"] = "為友方施加持久增益效果的法術。"
L["KIND_ANYONE"] = "友方或敵方法術"
L["KIND_ANYONE_DESCRIPTION"] = "既可以對友方也可以對敵人施放的法術。"
L["KIND_GROUND"] = "地面目標法術"
L["KIND_GROUND_DESCRIPTION"] = "放置在地面上的法術。"
L["KIND_FORM"] = "形態、姿態和守護"
L["KIND_FORM_DESCRIPTION"] = "在你關閉或切換之前一直保持的法術。"
L["KIND_SELF"] = "自身和範圍法術"
L["KIND_SELF_DESCRIPTION"] = "沒有目標，對自己或周圍施放的法術。"

-- Options: Custom Macros Panel
L["TAB_CUSTOM_MACROS"] = "自訂巨集"
L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"] =
	"你自己的巨集，列在頁面的自訂分類下。在這裡移除一個巨集後，它仍留在 /macro 中，需要你自己刪除。"
L["OPTIONS_CUSTOM_ADD"] = "新增巨集"
L["OPTIONS_CUSTOM_ADD_DESCRIPTION"] = "在清單末尾新增一個自訂巨集。"
L["OPTIONS_CUSTOM_NEW_NAME"] = "新巨集"
L["OPTIONS_CUSTOM_NAME"] = "名稱"
L["OPTIONS_CUSTOM_NAME_DESCRIPTION"] =
	"巨集的名稱。WoW 只保留前 %d 個位元組，在俄文、中文或韓文等語言中能容納的字數更少。"
L["OPTIONS_CUSTOM_SECTION"] = "分類"
L["OPTIONS_CUSTOM_SECTION_DESCRIPTION"] =
	"巨集在頁面上列出的位置：自訂分類下，或與法術書某個分頁的法術放在一起。"
L["OPTIONS_CUSTOM_BODY_DESCRIPTION"] =
	"巨集的內容，最多 %d 位元組。第一行寫 #showtooltip 加法術名稱，即可顯示該法術的圖示。"
L["OPTIONS_CUSTOM_STATUS_NEEDS"] = "這個巨集需要名稱和巨集內容才能顯示在頁面上。"
L["OPTIONS_CUSTOM_STATUS_TOO_LONG"] = "過長：%d / %d 位元組。長度合適之前不會顯示在頁面上。"
L["OPTIONS_CUSTOM_STATUS_TAKEN"] = "頁面上已有其他巨集使用這個名稱，因此這個巨集不會顯示。"
L["OPTIONS_CUSTOM_REMOVE_DESCRIPTION"] = "從清單中移除這個巨集。"
L["OPTIONS_CUSTOM_REMOVE_CONFIRM"] = "移除這個自訂巨集？"
L["OPTIONS_CUSTOM_RESTORE"] = "恢復預設"
L["OPTIONS_CUSTOM_RESTORE_DESCRIPTION"] = "用你的職業初始內建的巨集取代你的自訂巨集。"
L["OPTIONS_CUSTOM_RESTORE_CONFIRM"] = "用你職業的預設巨集取代所有自訂巨集？"

-- Options: Feedback & Support Panel
L["OPTIONS_LEVEL_UP_TITLE"] = "幫助 Macro Spellbook 升級"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"這個插件由熱愛這款遊戲、希望讓每個人都玩得盡可能開心的玩家打造。我們永遠不會請求捐款。真正的滿足感來自知道我們的努力讓你的遊戲變得更好一點。如果真是如此，我們很想聽你說說！"
L["OPTIONS_LEVEL_UP_WAYS"] = "你可以透過以下幾種方式幫助我們接觸到更多玩家。"
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• 分享意見：發現了錯誤或有新點子？在 Discord 上告訴我們。你的意見能幫助我們改進插件，也隨時歡迎提交 pull request。"
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• 告訴朋友：認識可能會喜歡這個插件的人嗎？告訴他們吧。口耳相傳能幫助更多玩家發現優秀的插件。"
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• 在 CurseForge 收藏：開啟下方的 CurseForge 連結，登入後點擊 Download 按鈕下方的星號。收藏能幫助更多玩家發現這個插件。"
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• 在 GitHub 點 Star：開啟下方的 GitHub 連結，登入後點擊右上角的 Star。Star 能幫助專案取得更多免費的開發者工具。"
L["OPTIONS_LEVEL_UP_THANKS"] = "感謝你選擇 Macro Spellbook！"

L["OPTIONS_FEEDBACK"] = "意見回饋與支援"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "意見回饋與支援連結"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "要複製連結，請點擊它的輸入框，然後按 Ctrl+A 和 Ctrl+C。"
L["OPTIONS_VERSION"] = "版本 %s"

-- Key Bindings
L["BINDING_TOGGLE_PAGE"] = "開啟/關閉 Macro Spellbook"

-- Messages
L["CHAT_LOADED"] =
	"版本 %s。設定（包括關閉此訊息的選項）位於 選項 > 插件 > Macro Spellbook。喜歡這個插件嗎？告訴朋友、在 CurseForge 收藏，或在 GitHub 點 Star。(="
L["CHAT_OPTIONS_IN_COMBAT"] = "基於安全考量，戰鬥中無法開啟選項介面。"
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "基於安全考量，戰鬥中無法開啟按鍵設定清單。"
L["KEY_BINDINGS_LOCATION"] = "開啟遊戲選單，依序進入 %s 和 %s，找到 Macro Spellbook 分類。"
L["ERROR_MACRO_SLOTS_FULL"] = "沒有空的巨集欄位。請在 /macro 中刪除一個巨集來騰出位置。"
L["ERROR_GENERAL_MACRO_SLOTS_FULL"] =
	"沒有空的一般巨集欄位。請在 /macro 中刪除一個一般巨集來騰出位置。"
L["CHAT_MACRO_TOO_LONG"] =
	'"%s"巨集在開啟選項後為 %d 位元組，超過了巨集能容納的 %d 位元組。關閉一個選項來縮短它。'
L["CHAT_CUSTOM_NEEDS_NAME_BODY"] = "自訂巨集 #%d 需要名稱和巨集內容才能顯示在頁面上。"
L["CHAT_CUSTOM_TOO_LONG"] =
	'自訂巨集"%s"為 %d 位元組，超過了巨集能容納的 %d 位元組。縮短它的內容即可將它加入頁面。'
L["CHAT_CUSTOM_NAME_TAKEN"] =
	'自訂巨集"%s"的名稱（前 %d 個位元組）與頁面上的另一個巨集相同。重新命名它即可將它加入頁面。'
