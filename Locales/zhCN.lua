local L = LibStub("AceLocale-3.0"):NewLocale("MacroSpellbook", "zhCN")
if not L then
	return
end

-- Add-on Names
L["ADDON_TITLE"] = "Macro Spellbook"
L["ADDON_SHORT_NAME"] = "Macro Spellbook"

-- Page: Sections
L["SECTION_UNLEARNED"] = "未学会"
L["SECTION_CUSTOM"] = "自定义"
L["SECTION_EQUIPMENT"] = "装备"

-- Page: Default Custom Macros
L["CUSTOM_SPAM_WAND"] = "魔杖连发"
L["CUSTOM_PET_ABILITY"] = "宠物技能"
L["CUSTOM_PET_ABILITY_MOUSEOVER"] = "宠物(悬停)"
L["CUSTOM_SWIFT_JUDGE"] = "快速审判"

-- Page: Macro Menu
L["MENU_GROUP_COMBAT_CHECK"] = "战斗条件"
L["MENU_GROUP_ABILITY_RANK"] = "法术等级"
L["MENU_GROUP_TARGETING"] = "目标选择"
L["MENU_GROUP_BEFORE_CAST"] = "施法前"
L["MENU_GROUP_AFTER_CAST"] = "施法后"
L["MENU_GROUP_CASTING_RULES"] = "施法规则"
L["MENU_GROUP_ERRORS"] = "错误信息"
L["MENU_GROUP_USE_ITEMS_FIRST"] = "先使用物品"
L["MENU_MACRO_TEXT"] = "宏文本"
L["MENU_MACRO_LENGTH"] = "%d / %d"
L["MENU_GROUP_VALUE"] = "%s：%s"
L["MENU_OPTIONS_COUNT"] = "%d 个选项"
L["MENU_CAST_ON_MOUSEOVER"] = "对鼠标悬停目标施放"
L["MENU_CAST_ON_SELF"] = "对自己施放"
L["MENU_CAST_ON_TARGETS_TARGET"] = "对目标的目标施放"
L["MENU_MAX_RANK"] = "最高等级"
L["MENU_DYNAMIC_RANK"] = "动态等级"
L["MENU_DYNAMIC_RANK_NOTE"] = "动态等级根据友方玩家的等级决定，只在非战斗状态下更新。"
L["MENU_CAST_AT_CURSOR"] = "在光标处施放"
L["MENU_TARGET_NEAREST_ENEMY"] = "选择最近的敌人"
L["MENU_CAST_IF_SUMMONED"] = "宠物已召唤时施放%s"
L["MENU_DOWNRANK_IN_RAIDS"] = "团队中施放等级 1"
L["MENU_NEVER_TURN_OFF"] = "永不关闭"
L["MENU_NEVER_TURN_OFF_NOTE"] =
	"开启永不关闭后，再次按下宏时技能会保持开启，而不会被关闭。"
L["MENU_LEAVE_FORM_BEFORE"] = "施法前取消形态"
L["MENU_RIGHT_CLICK_FOR"] = "右键点击：%s"
L["MENU_ONLY_IN_COMBAT"] = "仅在战斗中"
L["MENU_NEVER_IN_COMBAT"] = "从不在战斗中"
L["MENU_COMBAT_CHECK_NONE"] = "无"
L["MENU_ONCE_PER_COMBAT"] = "每场战斗施放一次"
L["MENU_ONCE_PER_TARGET"] = "每个目标施放一次"
L["MENU_HIDE_ERRORS"] = "隐藏错误信息"
L["MENU_MUTE_ERRORS"] = "关闭错误音效"
L["MENU_SPAMMABLE"] = "可连按"
L["MENU_SWITCH_TO"] = "切换为%s"
L["MENU_CAST_ON_FOCUS"] = "对焦点施放"
L["MENU_ENABLE_PET_ATTACK"] = "启用宠物攻击"
L["MENU_START_AUTO_ATTACK"] = "开始自动攻击"
L["MENU_STOP_ATTACK"] = "停止攻击"
L["MENU_START_AUTO_SHOT"] = "开始自动射击"
L["MENU_START_WAND"] = "开始魔杖射击"
L["MENU_STOP_CASTING"] = "停止施法"
L["MENU_STOP_CASTING_NOTE"] = "对打断、驱散这类不能等待的法术使用停止施法。"

-- Page: Settings Menu
L["SETTINGS_SHOW_UNLEARNED"] = "显示未学会的法术"
L["SETTINGS_COUNT_SPELLS_ON_BARS"] = "动作条上的法术视为已放置"
L["SETTINGS_MARK_ALL_PLACED"] = "将所有法术标记为已放置"
L["SETTINGS_MARK_ALL_PLACED_DESCRIPTION"] =
	"本页的所有宏不再发光，无论放在哪里。之后学会的法术在放置前仍会发光。"
L["SETTINGS_CLEAR_PLACED"] = "清除放置标记"
L["SETTINGS_CLEAR_PLACED_DESCRIPTION"] = "让每个不在动作条上的已标记宏重新发光。"
L["SETTINGS_OPEN_OPTIONS"] = "打开选项"
L["SETTINGS_OPEN_OPTIONS_DESCRIPTION"] = "在选项界面中打开 Macro Spellbook，你的自定义宏就在那里。"

-- Page: Macro Buttons
-- TRANSLATORS: each note fills the small slot under a macro button, so keep it short.
L["SUBTEXT_CUSTOM"] = "自定义"
L["SUBTEXT_FOCUS"] = "焦点"
L["SUBTEXT_PET"] = "宠物"
L["SUBTEXT_CURSOR"] = "光标"
L["SUBTEXT_MOUSEOVER"] = "鼠标悬停"
L["SUBTEXT_CAST_ON_SELF"] = "自己"
L["SUBTEXT_STANCE"] = "姿态"
L["SUBTEXT_USE_ITEMS"] = "使用物品"
L["SUBTEXT_PET_ATTACK"] = "宠物攻击"
L["SUBTEXT_RAID_RANK_1"] = "团队等级 1"
L["SUBTEXT_SPAMMABLE"] = "可连按"
L["SUBTEXT_DYNAMIC_RANK"] = "动态等级"
L["SUBTEXT_TARGETS_TARGET"] = "目标的目标"
L["SUBTEXT_TARGET_ENEMY"] = "最近敌人"
L["SUBTEXT_GROUP_VERSION"] = "团体版本"
L["SUBTEXT_ONCE_PER_COMBAT"] = "每战一次"
L["SUBTEXT_ONCE_PER_TARGET"] = "每目标一次"
L["SUBTEXT_COMBAT_ONLY"] = "仅战斗中"
L["SUBTEXT_NO_COMBAT"] = "非战斗"
L["SUBTEXT_LEAVE_FORM"] = "取消形态"
L["SUBTEXT_NO_TOGGLE"] = "保持开启"
L["SUBTEXT_WAND"] = "魔杖"
L["SUBTEXT_START_ATTACK"] = "自动攻击"
L["SUBTEXT_STOP_ATTACK"] = "停止攻击"
L["SUBTEXT_STOP_CASTING"] = "停止施法"
L["SUBTEXT_HIDE_ERRORS"] = "隐藏错误"
L["SUBTEXT_MUTE_ERRORS"] = "错误静音"
L["SUBTEXT_OPTIONS_COUNT"] = "%d 个选项"
L["SUBTEXT_TOO_LONG"] = "过长"
L["SUBTEXT_NAME_TAKEN"] = "名称重复"

-- Page: Macro Tooltip
L["TOOLTIP_NOT_LEARNED"] = "尚未学会"
L["TOOLTIP_NOT_ON_BARS"] = "不在你的动作条上"
L["TOOLTIP_TOO_LONG"] = "过长：%d / %d 字节。关闭一个选项来缩短它。"
L["TOOLTIP_NAME_TAKEN"] =
	'你已有一个名为"%s"的宏。在 /macro 中重命名或删除它，才能使用这个宏。'
L["TOOLTIP_KEY_CLICK_DRAG"] = "点击或拖动"
L["TOOLTIP_ACTION_PLACE_ON_BAR"] = "放到你的动作条上"
L["TOOLTIP_KEY_RIGHT_CLICK"] = "右键点击"
L["TOOLTIP_ACTION_MACRO_OPTIONS"] = "宏选项"

-- Spellbook Tab Tooltip
L["SPELLBOOK_TAB_DESCRIPTION"] = "把你的职业法术做成一键宏。"
L["TOOLTIP_KEY_CLICK"] = "点击"
L["TOOLTIP_ACTION_OPEN_PAGE"] = "打开 Macro Spellbook"

-- Page: Layout
L["PAGE_EMPTY"] =
	"还没有宏。去找你的职业训练师学习第一批法术，或在 选项 > 插件 > Macro Spellbook > 自定义宏 中添加你自己的宏。"
L["PAGE_MACRO_SLOTS"] = "宏栏位"
L["PAGE_MACRO_GENERAL"] = "通用"
L["PAGE_MACRO_CHARACTER"] = "角色"
L["PAGE_FOOTER"] =
	"点击宏或将它拖到动作条上。发光的宏还不在你的动作条上。右键点击宏可打开它的选项。"

-- Options: General Panel
L["OPTIONS_DESCRIPTION"] =
	"在新的法术书标签页中一键把每个职业法术做成鼠标悬停宏、光标施放宏和自我施放宏，无需宏语法。右键即可添加焦点、法术等级、降级施放、停止施法、自动攻击、宠物攻击或使用饰品。"
L["OPTIONS_ENABLE_WELCOME"] = "启用欢迎信息"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] = "每次登录时在聊天框显示一行带版本号的欢迎信息。"
L["OPTIONS_KEY_BINDINGS_HEADER"] = "按键设置"
L["OPTIONS_KEY_SET"] = "设置按键"
L["OPTIONS_KEY_SET_DESCRIPTION"] = "打开游戏的按键设置列表，Macro Spellbook 在其中有自己的分类。"
L["OPTIONS_KEY_BINDING_TOGGLE_DESCRIPTION"] =
	"打开或关闭 Macro Spellbook。它在你的法术书中也有自己的标签页。"
L["OPTIONS_COMMANDS_HEADER"] = "/命令"
L["OPTIONS_COMMAND"] = "/msb"
L["OPTIONS_COMMAND_DESCRIPTION"] = "打开此插件的选项界面。"

-- Options: Spellbook Page Panel
L["TAB_SPELLBOOK_PAGE"] = "法术书页面"
L["OPTIONS_SPELLBOOK_PAGE_DESCRIPTION"] = "法术书中 Macro Spellbook 页面如何列出你的法术。"
L["OPTIONS_SHOW_UNLEARNED_DESCRIPTION"] =
	"在未学会分类中列出你尚未学会的职业法术，方便提前放置它们的宏。"
L["OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION"] =
	"法术本身放在动作条上时，它的宏就不再发光，即使该宏开启了选项。"

-- Options: Macro Defaults Panel
L["TAB_MACRO_DEFAULTS"] = "宏默认设置"
L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"] = "每种法术宏一开始使用的选项。你在宏的右键菜单中自行设置的内容会保留。每种类型只列出其法术提供的选项。"
L["OPTIONS_KIND_EXAMPLES"] = "你的法术：%s"
L["OPTIONS_KIND_EXAMPLES_MORE"] = "%s 等另外 %d 个"
L["KIND_ENEMY"] = "敌对法术"
L["KIND_ENEMY_DESCRIPTION"] = "对敌人施放的法术，例如攻击和减益效果。"
L["KIND_FRIENDLY"] = "友方法术"
L["KIND_FRIENDLY_DESCRIPTION"] = "对友方施放的法术，例如治疗和增益效果。"
L["KIND_ANYONE"] = "友方或敌方法术"
L["KIND_ANYONE_DESCRIPTION"] = "既可以对友方也可以对敌人施放的法术。"
L["KIND_GROUND"] = "地面目标法术"
L["KIND_GROUND_DESCRIPTION"] = "放置在地面上的法术。"
L["KIND_FORM"] = "形态、姿态和守护"
L["KIND_FORM_DESCRIPTION"] = "在你关闭或切换之前一直保持的法术。"
L["KIND_SELF"] = "自身和范围法术"
L["KIND_SELF_DESCRIPTION"] = "没有目标，对自己或周围施放的法术。"

-- Options: Custom Macros Panel
L["TAB_CUSTOM_MACROS"] = "自定义宏"
L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"] =
	"你自己的宏，列在页面的自定义分类下。在这里移除一个宏后，它仍留在 /macro 中，需要你自己删除。"
L["OPTIONS_CUSTOM_ADD"] = "添加宏"
L["OPTIONS_CUSTOM_ADD_DESCRIPTION"] = "在列表末尾添加一个新的自定义宏。"
L["OPTIONS_CUSTOM_NEW_NAME"] = "新宏"
L["OPTIONS_CUSTOM_NAME"] = "名称"
L["OPTIONS_CUSTOM_NAME_DESCRIPTION"] = "宏的名称，最多 %d 个字符。"
L["OPTIONS_CUSTOM_SECTION"] = "分类"
L["OPTIONS_CUSTOM_SECTION_DESCRIPTION"] =
	"宏在页面上列出的位置：自定义分类下，或与法术书某个标签页的法术放在一起。"
L["OPTIONS_CUSTOM_BODY"] = "宏文本"
L["OPTIONS_CUSTOM_BODY_DESCRIPTION"] =
	"宏的文本，最多 255 字节。第一行写 #showtooltip 加法术名称，即可显示该法术的图标。"
L["OPTIONS_CUSTOM_STATUS_NEEDS"] = "这个宏需要名称和宏文本才能显示在页面上。"
L["OPTIONS_CUSTOM_STATUS_TOO_LONG"] = "过长：%d / %d 字节。长度合适之前不会显示在页面上。"
L["OPTIONS_CUSTOM_STATUS_TAKEN"] = "页面上已有其他宏使用这个名称，因此这个宏不会显示。"
L["OPTIONS_CUSTOM_REMOVE"] = "从列表中移除这个宏。"
L["OPTIONS_CUSTOM_REMOVE_CONFIRM"] = "移除这个自定义宏？"
L["OPTIONS_CUSTOM_RESTORE"] = "恢复默认"
L["OPTIONS_CUSTOM_RESTORE_DESCRIPTION"] = "用你的职业初始自带的宏替换你的自定义宏。"
L["OPTIONS_CUSTOM_RESTORE_CONFIRM"] = "用你职业的默认宏替换所有自定义宏？"

-- Options: Feedback & Support Panel
L["OPTIONS_LEVEL_UP_TITLE"] = "帮助 Macro Spellbook 升级"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"这个插件由热爱这款游戏、希望让每个人都玩得尽可能开心的玩家打造。我们永远不会请求捐赠。真正的满足感来自知道我们的工作让你的游戏变得更好一点。如果确实如此，我们很想听你说说！"
L["OPTIONS_LEVEL_UP_WAYS"] = "你可以通过以下几种方式帮助我们接触到更多玩家。"
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• 分享反馈：发现了错误或有新想法？在 Discord 上告诉我们。你的反馈能帮助我们改进插件，也随时欢迎提交 pull request。"
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• 告诉朋友：认识可能会喜欢这个插件的人吗？告诉他们吧。口口相传能帮助更多玩家发现优秀的插件。"
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• 在 CurseForge 收藏：打开下方的 CurseForge 链接，登录后点击 Download 按钮下方的星标。收藏能帮助更多玩家发现这个插件。"
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• 在 GitHub 点 Star：打开下方的 GitHub 链接，登录后点击右上角的 Star。Star 能帮助项目获得更多免费的开发者工具。"
L["OPTIONS_LEVEL_UP_THANKS"] = "感谢你选择 Macro Spellbook！"

L["OPTIONS_FEEDBACK"] = "反馈与支持"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "反馈与支持链接"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "要复制链接，请点击它的输入框，然后按 Ctrl+A 和 Ctrl+C。"
L["OPTIONS_VERSION"] = "版本 %s"

-- Key Bindings
L["BINDING_TOGGLE_PAGE"] = "打开/关闭 Macro Spellbook"

-- Messages
L["CHAT_LOADED"] =
	"版本 %s。设置（包括关闭此信息的选项）位于 选项 > 插件 > Macro Spellbook。喜欢这个插件吗？告诉朋友，在 CurseForge 收藏，或在 GitHub 点 Star。(="
L["CHAT_OPTIONS_IN_COMBAT"] = "出于安全考虑，战斗中无法打开选项界面。"
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "出于安全考虑，战斗中无法打开按键设置列表。"
L["KEY_BINDINGS_LOCATION"] = "打开游戏菜单，依次进入 %s 和 %s，找到 Macro Spellbook 分类。"
L["ERROR_NO_FREE_MACRO_SLOTS"] = "没有空余的宏栏位。"
L["ERROR_NO_FREE_GENERAL_MACRO_SLOTS"] = "没有空余的通用宏栏位。"
L["CHAT_MACRO_NAME_TAKEN"] =
	'你已有一个名为"%s"的宏，因此没有改动它。在 /macro 中重命名或删除它，才能使用这个宏。'
L["CHAT_MACRO_TOO_LONG"] =
	'"%s"宏在开启选项后为 %d 字节，超过了宏能容纳的 %d 字节。关闭一个选项来缩短它。'
L["CHAT_CUSTOM_NEEDS_NAME_BODY"] = "自定义宏 #%d 需要名称和宏文本才能显示在页面上。"
L["CHAT_CUSTOM_TOO_LONG"] =
	'自定义宏"%s"为 %d 字节，超过了宏能容纳的 %d 字节。缩短它的文本即可将它加入页面。'
L["CHAT_CUSTOM_NAME_TAKEN"] =
	'自定义宏"%s"的名称（前 %d 个字符）与页面上的另一个宏相同。重命名它即可将它加入页面。'
