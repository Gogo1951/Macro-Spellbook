local L = LibStub("AceLocale-3.0"):NewLocale("MacroSpellbook", "ruRU")
if not L then
	return
end

-- Add-on Names
L["ADDON_TITLE"] = "Macro Spellbook"
L["ADDON_SHORT_NAME"] = "Macro Spellbook"

-- Page: Sections
L["SECTION_UNLEARNED"] = "Не изучено"
L["SECTION_CUSTOM"] = "Свои"
L["SECTION_EQUIPMENT"] = "Экипировка"

-- Page: Default Custom Macros
L["CUSTOM_SPAM_WAND"] = "Автожезл"
L["CUSTOM_PET_ABILITY"] = "Пет: каст"
L["CUSTOM_PET_ABILITY_MOUSEOVER"] = "Пет: мышь"
L["CUSTOM_SWIFT_JUDGE"] = "Блиц-суд"

-- Page: Macro Menu
L["MENU_GROUP_COMBAT_CHECK"] = "Условие боя"
L["MENU_GROUP_ABILITY_RANK"] = "Уровень заклинания"
L["MENU_GROUP_TARGETING"] = "Выбор цели"
L["MENU_GROUP_BEFORE_CAST"] = "Перед применением"
L["MENU_GROUP_AFTER_CAST"] = "После применения"
L["MENU_GROUP_CASTING_RULES"] = "Правила применения"
L["MENU_GROUP_ERRORS"] = "Сообщения об ошибках"
L["MENU_GROUP_USE_ITEMS_FIRST"] = "Сначала предметы"
L["MENU_MACRO_TEXT"] = "Текст макроса"
L["MENU_MACRO_LENGTH"] = "%d / %d"
L["MENU_GROUP_VALUE"] = "%s: %s"
L["MENU_OPTIONS_COUNT"] = "Параметров: %d"
L["MENU_CAST_ON_MOUSEOVER"] = "Применять при наведении"
L["MENU_CAST_ON_SELF"] = "Применять на себя"
L["MENU_CAST_ON_TARGETS_TARGET"] = "Применять на цель цели"
L["MENU_MAX_RANK"] = "Высший уровень"
L["MENU_DYNAMIC_RANK"] = "Динамический уровень"
L["MENU_DYNAMIC_RANK_NOTE"] =
	"Динамический уровень зависит от уровня дружественного игрока и обновляется только вне боя."
L["MENU_CAST_AT_CURSOR"] = "Применять у курсора"
L["MENU_TARGET_NEAREST_ENEMY"] = "Выбрать ближайшего врага"
L["MENU_CAST_IF_SUMMONED"] = "Применять %s, если питомец призван"
L["MENU_DOWNRANK_IN_RAIDS"] = "Уровень 1 в рейдах"
L["MENU_NEVER_TURN_OFF"] = "Не выключать"
L["MENU_NEVER_TURN_OFF_NOTE"] =
	"Не выключать: повторное нажатие макроса оставляет способность включенной, а не выключает ее."
L["MENU_LEAVE_FORM_BEFORE"] = "Выходить из облика перед применением"
L["MENU_RIGHT_CLICK_FOR"] = "Правый клик: %s"
L["MENU_ONLY_IN_COMBAT"] = "Только в бою"
L["MENU_NEVER_IN_COMBAT"] = "Никогда в бою"
L["MENU_COMBAT_CHECK_NONE"] = "Нет"
L["MENU_ONCE_PER_COMBAT"] = "Применять раз за бой"
L["MENU_ONCE_PER_TARGET"] = "Применять раз на цель"
L["MENU_HIDE_ERRORS"] = "Скрывать сообщения об ошибках"
L["MENU_MUTE_ERRORS"] = "Отключать звуки ошибок"
L["MENU_SPAMMABLE"] = "Для спама"
L["MENU_SWITCH_TO"] = "Переходить в %s"
L["MENU_CAST_ON_FOCUS"] = "Применять на фокус"
L["MENU_ENABLE_PET_ATTACK"] = "Включить атаку питомца"
L["MENU_START_AUTO_ATTACK"] = "Начинать автоатаку"
L["MENU_STOP_ATTACK"] = "Прекращать атаку"
L["MENU_START_AUTO_SHOT"] = "Начинать автоматическую стрельбу"
L["MENU_START_WAND"] = "Начинать стрельбу жезлом"
L["MENU_STOP_CASTING"] = "Прерывать заклинание"
L["MENU_STOP_CASTING_NOTE"] =
	"Используйте Прерывать заклинание для заклинаний, которые не могут ждать, например прерываний и рассеиваний."

-- Page: Settings Menu
L["SETTINGS_SHOW_UNLEARNED"] = "Показывать неизученные заклинания"
L["SETTINGS_COUNT_SPELLS_ON_BARS"] = "Считать заклинания на панелях размещенными"
L["SETTINGS_MARK_ALL_PLACED"] = "Отметить все заклинания как размещенные"
L["SETTINGS_MARK_ALL_PLACED_DESCRIPTION"] =
	"Ни один макрос на этой странице больше не светится, где бы он ни был. Заклинание, изученное позже, светится, пока вы его не разместите."
L["SETTINGS_CLEAR_PLACED"] = "Снять отметки о размещении"
L["SETTINGS_CLEAR_PLACED_DESCRIPTION"] =
	"Снова включает свечение каждого отмеченного макроса, которого нет на ваших панелях."
L["SETTINGS_OPEN_OPTIONS"] = "Открыть настройки"
L["SETTINGS_OPEN_OPTIONS_DESCRIPTION"] =
	"Открывает Macro Spellbook в окне настроек, где находятся ваши собственные макросы."

-- Page: Macro Buttons
-- TRANSLATORS: each note fills the small slot under a macro button, so keep it short.
L["SUBTEXT_CUSTOM"] = "Свой"
L["SUBTEXT_FOCUS"] = "Фокус"
L["SUBTEXT_PET"] = "Питомец"
L["SUBTEXT_CURSOR"] = "Курсор"
L["SUBTEXT_MOUSEOVER"] = "Наведение"
L["SUBTEXT_CAST_ON_SELF"] = "На себя"
L["SUBTEXT_STANCE"] = "Стойка"
L["SUBTEXT_USE_ITEMS"] = "Предметы"
L["SUBTEXT_PET_ATTACK"] = "Атака питомца"
L["SUBTEXT_RAID_RANK_1"] = "Рейд: ур. 1"
L["SUBTEXT_SPAMMABLE"] = "Для спама"
L["SUBTEXT_DYNAMIC_RANK"] = "Дин. уровень"
L["SUBTEXT_TARGETS_TARGET"] = "Цель цели"
L["SUBTEXT_TARGET_ENEMY"] = "Ближ. враг"
L["SUBTEXT_GROUP_VERSION"] = "Для группы"
L["SUBTEXT_ONCE_PER_COMBAT"] = "Раз за бой"
L["SUBTEXT_ONCE_PER_TARGET"] = "Раз на цель"
L["SUBTEXT_COMBAT_ONLY"] = "Только в бою"
L["SUBTEXT_NO_COMBAT"] = "Вне боя"
L["SUBTEXT_LEAVE_FORM"] = "Выход из облика"
L["SUBTEXT_NO_TOGGLE"] = "Не выкл."
L["SUBTEXT_WAND"] = "Жезл"
L["SUBTEXT_START_ATTACK"] = "Автоатака"
L["SUBTEXT_STOP_ATTACK"] = "Стоп атака"
L["SUBTEXT_STOP_CASTING"] = "Стоп каст"
L["SUBTEXT_HIDE_ERRORS"] = "Без ошибок"
L["SUBTEXT_MUTE_ERRORS"] = "Без звука ошибок"
L["SUBTEXT_OPTIONS_COUNT"] = "Параметров: %d"
L["SUBTEXT_TOO_LONG"] = "Не умещается"
L["SUBTEXT_NAME_TAKEN"] = "Имя занято"

-- Page: Macro Tooltip
L["TOOLTIP_NOT_LEARNED"] = "Еще не изучено"
L["TOOLTIP_NOT_ON_BARS"] = "Нет на ваших панелях команд"
L["TOOLTIP_TOO_LONG"] =
	"Слишком длинный: %d / %d байт. Отключите параметр, чтобы сократить его."
L["TOOLTIP_NAME_TAKEN"] =
	'У вас уже есть макрос "%s". Переименуйте или удалите его в /macro, чтобы использовать этот.'
L["TOOLTIP_KEY_CLICK_DRAG"] = "Клик или перетаскивание"
L["TOOLTIP_ACTION_PLACE_ON_BAR"] = "Разместить на панелях команд"
L["TOOLTIP_KEY_RIGHT_CLICK"] = "Правый клик"
L["TOOLTIP_ACTION_MACRO_OPTIONS"] = "Параметры макроса"

-- Spellbook Tab Tooltip
L["SPELLBOOK_TAB_DESCRIPTION"] =
	"Заклинания вашего класса в виде макросов в один клик."
L["TOOLTIP_KEY_CLICK"] = "Клик"
L["TOOLTIP_ACTION_OPEN_PAGE"] = "Открыть Macro Spellbook"

-- Page: Layout
L["PAGE_EMPTY"] =
	"Макросов пока нет. Посетите учителя своего класса, чтобы изучить первые заклинания, или добавьте свои макросы в разделе Настройки > Модификации > Macro Spellbook > Свои макросы."
L["PAGE_MACRO_SLOTS"] = "Ячейки макросов"
L["PAGE_MACRO_GENERAL"] = "Общие"
L["PAGE_MACRO_CHARACTER"] = "Персонаж"
L["PAGE_FOOTER"] =
	"Нажмите на макрос или перетащите его на панели. Светящийся макрос еще не на ваших панелях. Правый клик по макросу открывает его параметры."

-- Options: General Panel
L["OPTIONS_DESCRIPTION"] =
	"Макросы при наведении, применение у курсора и макросы на себя для каждого заклинания класса, создаются в один клик на новой вкладке книги заклинаний, без синтаксиса макросов. Правым кликом добавьте фокус, уровень заклинания, понижение уровня, прерывание заклинания, автоатаку, атаку питомца или использование аксессуаров."
L["OPTIONS_ENABLE_WELCOME"] = "Включить приветствие"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"При каждом входе в игру выводит в чат однострочное приветствие с номером версии."
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Назначение клавиш"
L["OPTIONS_KEY_SET"] = "Назначить клавишу"
L["OPTIONS_KEY_SET_DESCRIPTION"] =
	"Открывает в игре список назначения клавиш, где у Macro Spellbook есть свой раздел."
L["OPTIONS_KEY_BINDING_TOGGLE_DESCRIPTION"] =
	"Открывает и закрывает Macro Spellbook. У него также есть своя вкладка в вашей книге заклинаний."
L["OPTIONS_COMMANDS_HEADER"] = "/Команды"
L["OPTIONS_COMMAND"] = "/msb"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Открывает окно настроек этой модификации."

-- Options: Spellbook Page Panel
L["TAB_SPELLBOOK_PAGE"] = "Страница книги заклинаний"
L["OPTIONS_SPELLBOOK_PAGE_DESCRIPTION"] =
	"Как страница Macro Spellbook в вашей книге заклинаний показывает ваши заклинания."
L["OPTIONS_SHOW_UNLEARNED_DESCRIPTION"] =
	"Показывает еще не изученные заклинания класса в разделе Не изучено, чтобы вы могли заранее разместить их макросы."
L["OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION"] =
	"Заклинание, размещенное на панелях само по себе, гасит свечение своего макроса, даже если у макроса включены параметры."

-- Options: Macro Defaults Panel
L["TAB_MACRO_DEFAULTS"] = "Умолчания макросов"
L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"] =
	"Параметры, с которыми создается каждый вид макроса заклинания. То, что вы задали для макроса в его меню правого клика, сохраняется. Для каждого вида показаны только параметры, доступные его заклинаниям."
L["OPTIONS_KIND_EXAMPLES"] = "Ваши заклинания: %s"
L["OPTIONS_KIND_EXAMPLES_MORE"] = "%s и еще %d"
L["KIND_ENEMY"] = "Заклинания против врагов"
L["KIND_ENEMY_DESCRIPTION"] = "Заклинания, применяемые к врагу, например атаки и ослабления."
L["KIND_FRIENDLY"] = "Дружественные заклинания"
L["KIND_FRIENDLY_DESCRIPTION"] = "Заклинания, применяемые к союзнику, например исцеление и усиления."
L["KIND_ANYONE"] = "Заклинания для союзника или врага"
L["KIND_ANYONE_DESCRIPTION"] = "Заклинания, которые можно применить и к союзнику, и к врагу."
L["KIND_GROUND"] = "Заклинания по земле"
L["KIND_GROUND_DESCRIPTION"] = "Заклинания, которые вы размещаете на земле."
L["KIND_FORM"] = "Облики, стойки и аспекты"
L["KIND_FORM_DESCRIPTION"] = "Заклинания, которые действуют, пока вы их не отключите или не смените."
L["KIND_SELF"] = "Заклинания на себя и по области"
L["KIND_SELF_DESCRIPTION"] = "Заклинания без цели, применяемые на себя или вокруг себя."

-- Options: Custom Macros Panel
L["TAB_CUSTOM_MACROS"] = "Свои макросы"
L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"] =
	"Ваши собственные макросы, показанные на странице в разделе Свои. Если удалить макрос здесь, он останется в /macro, и его нужно будет удалить вручную."
L["OPTIONS_CUSTOM_ADD"] = "Добавить макрос"
L["OPTIONS_CUSTOM_ADD_DESCRIPTION"] =
	"Добавляет новый собственный макрос в конец списка."
L["OPTIONS_CUSTOM_NEW_NAME"] = "Макрос"
L["OPTIONS_CUSTOM_NAME"] = "Название"
L["OPTIONS_CUSTOM_NAME_DESCRIPTION"] = "Название макроса, не длиннее %d символов."
L["OPTIONS_CUSTOM_SECTION"] = "Раздел"
L["OPTIONS_CUSTOM_SECTION_DESCRIPTION"] =
	"Где макрос показан на странице: в разделе Свои или вместе с заклинаниями одной из вкладок вашей книги заклинаний."
L["OPTIONS_CUSTOM_BODY"] = "Текст макроса"
L["OPTIONS_CUSTOM_BODY_DESCRIPTION"] =
	"Текст макроса, не длиннее 255 байт. Первая строка с #showtooltip и названием заклинания показывает значок этого заклинания."
L["OPTIONS_CUSTOM_STATUS_NEEDS"] =
	"Этому макросу нужны название и текст, прежде чем он появится на странице."
L["OPTIONS_CUSTOM_STATUS_TOO_LONG"] =
	"Слишком длинный: %d / %d байт. Он не появится на странице, пока не уложится в лимит."
L["OPTIONS_CUSTOM_STATUS_TAKEN"] =
	"Другой макрос на странице уже носит это название, поэтому этот не появится."
L["OPTIONS_CUSTOM_REMOVE"] = "Удаляет этот макрос из списка."
L["OPTIONS_CUSTOM_REMOVE_CONFIRM"] = "Удалить этот собственный макрос?"
L["OPTIONS_CUSTOM_RESTORE"] = "Восстановить стандартные"
L["OPTIONS_CUSTOM_RESTORE_DESCRIPTION"] =
	"Заменяет ваши собственные макросы стандартными макросами вашего класса."
L["OPTIONS_CUSTOM_RESTORE_CONFIRM"] =
	"Заменить все ваши собственные макросы стандартными макросами вашего класса?"

-- Options: Feedback & Support Panel
L["OPTIONS_LEVEL_UP_TITLE"] = "Помогите Macro Spellbook повысить уровень"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Эту модификацию создали игроки, которые любят эту игру и хотят сделать ее как можно интереснее для всех. Мы никогда не попросим пожертвований. Настоящее удовольствие для нас в том, чтобы знать, что наша работа делает игру для вас немного лучше. Если это так, нам будет очень приятно об этом услышать!"
L["OPTIONS_LEVEL_UP_WAYS"] =
	"Вот несколько способов помочь нам охватить больше игроков."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Поделитесь отзывом: Нашли ошибку или есть идея? Расскажите нам в Discord. Ваши отзывы помогают нам улучшать модификацию, а pull request всегда приветствуются."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Расскажите другу: Знаете кого-то, кому может понравиться эта модификация? Расскажите о ней. Сарафанное радио помогает большему числу игроков находить отличные модификации."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Добавьте в избранное на CurseForge: Откройте ссылку на CurseForge ниже, войдите и нажмите на звезду под кнопкой Download. Избранное помогает большему числу игроков найти модификацию."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Поставьте Star на GitHub: Откройте ссылку на GitHub ниже, войдите и нажмите Star в правом верхнем углу. Stars помогают проекту получить больше бесплатных инструментов для разработчиков."
L["OPTIONS_LEVEL_UP_THANKS"] = "Спасибо, что выбрали Macro Spellbook!"

L["OPTIONS_FEEDBACK"] = "Отзывы и поддержка"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Ссылки для отзывов и поддержки"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] =
	"Чтобы скопировать ссылку, нажмите на ее поле, затем Ctrl+A и Ctrl+C."
L["OPTIONS_VERSION"] = "Версия %s"

-- Key Bindings
L["BINDING_TOGGLE_PAGE"] = "Показать/скрыть Macro Spellbook"

-- Messages
L["CHAT_LOADED"] =
	"Версия %s. Настройки (включая возможность отключить это сообщение) находятся в разделе Настройки > Модификации > Macro Spellbook. Нравится эта модификация? Расскажите другу, добавьте ее в избранное на CurseForge или поставьте Star на GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] =
	"В целях безопасности окно настроек нельзя открыть во время боя."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] =
	"В целях безопасности список назначения клавиш нельзя открыть во время боя."
L["KEY_BINDINGS_LOCATION"] =
	"Откройте меню игры, затем %s, затем %s, и найдите раздел Macro Spellbook."
L["ERROR_NO_FREE_MACRO_SLOTS"] = "Нет свободных ячеек для макросов."
L["ERROR_NO_FREE_GENERAL_MACRO_SLOTS"] = "Нет свободных ячеек для общих макросов."
L["CHAT_MACRO_NAME_TAKEN"] =
	'У вас уже есть макрос "%s", поэтому он не был изменен. Переименуйте или удалите его в /macro, чтобы использовать этот.'
L["CHAT_MACRO_TOO_LONG"] =
	'Макрос "%s" с включенными параметрами занимает %d байт, больше %d, которые вмещает макрос. Отключите параметр, чтобы сократить его.'
L["CHAT_CUSTOM_NEEDS_NAME_BODY"] =
	"Собственному макросу №%d нужны название и текст, прежде чем он появится на странице."
L["CHAT_CUSTOM_TOO_LONG"] =
	'Собственный макрос "%s" занимает %d байт, больше %d, которые вмещает макрос. Сократите его текст, чтобы добавить его на страницу.'
L["CHAT_CUSTOM_NAME_TAKEN"] =
	'Название собственного макроса "%s" совпадает (первые %d символов) с другим макросом на странице. Переименуйте его, чтобы добавить на страницу.'
