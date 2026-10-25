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
-- TRANSLATORS: each name becomes a WoW macro name, cut to 16 bytes (about 5 Chinese or Korean characters), so keep it short.
L["CUSTOM_SPAM_WAND"] = "Автожезл"
L["CUSTOM_PET_ABILITY"] = "Пет: каст"
L["CUSTOM_PET_ABILITY_MOUSEOVER"] = "Пет: мышь"
L["CUSTOM_SWIFT_JUDGE"] = "Блиц-суд"

-- Page: Macro Menu
L["MENU_GROUP_COMBAT_CHECK"] = "Условие боя"
L["MENU_GROUP_SPELL_RANK"] = "Уровень заклинания"
L["MENU_GROUP_TARGETING"] = "Выбор цели"
L["MENU_GROUP_BEFORE_CAST"] = "Перед применением"
L["MENU_GROUP_ADD_ATTACK"] = "Добавить атаку"
L["MENU_GROUP_CASTING_RULES"] = "Правила применения"
L["MENU_GROUP_ERRORS"] = "Сообщения об ошибках"
L["MENU_GROUP_USE_ITEMS_FIRST"] = "Сначала предметы"
L["MACRO_TEXT"] = "Текст макроса"
L["MENU_MACRO_LENGTH"] = "%d / %d"
L["MENU_OPTIONS_COUNT"] = "Параметров: %d"
L["MENU_RANK_LEARN_LEVEL"] = "%s (с %d ур.)"
L["MENU_MAX_RANK"] = "Высший уровень"
L["MENU_DYNAMIC_RANK"] = "Динамический уровень"
L["MENU_DYNAMIC_RANK_NOTE"] =
	"Динамический уровень зависит от уровня дружественного игрока и обновляется только вне боя."
L["MENU_CAST_AT_CURSOR"] = "Применять у курсора"
L["MENU_TARGET_NEAREST_ENEMY"] = "Выбрать ближайшего врага"
L["MENU_TARGET_NEAREST_FRIEND"] = "Выбрать ближайшего союзника"
L["MENU_CAST_IF_SUMMONED"] = "Применять %s, если питомец призван"
L["MENU_NEVER_TURN_OFF"] = "Не выключать"
L["MENU_LEAVE_FORM_BEFORE"] = "Выходить из облика перед применением"
L["MENU_RIGHT_CLICK_FOR"] = "Правый клик: %s"
L["MENU_ONLY_IN_COMBAT"] = "Только в бою"
L["MENU_NEVER_IN_COMBAT"] = "Никогда в бою"
L["MENU_COMBAT_CHECK_NONE"] = "Нет"
L["MENU_ONCE_PER_COMBAT"] = "Применять раз за бой"
L["MENU_ONCE_PER_TARGET"] = "Применять раз на цель"
L["MENU_HIDE_ERRORS"] = "Скрывать сообщения об ошибках"
L["MENU_MUTE_ERRORS"] = "Отключать звуки ошибок"
L["MENU_SWITCH_TO"] = "Переходить в %s"
L["MENU_CAST_ON_FOCUS"] = "Применять на фокус"
L["MENU_START_AUTO_ATTACK"] = "Начинать автоатаку"
L["MENU_STOP_ATTACK"] = "Прекращать атаку"
L["MENU_START_AUTO_SHOT"] = "Начинать автоматическую стрельбу"
L["MENU_START_PET_ATTACK"] = "Начинать атаку питомца"
L["MENU_START_WAND"] = "Начинать стрельбу жезлом"
L["MENU_STOP_CASTING"] = "Прерывать заклинание"
L["MENU_STOP_CASTING_NOTE"] =
	"Используйте Прерывать заклинание для заклинаний, которые не могут ждать, например прерываний и рассеиваний."
L["MENU_STOP_IF_CHANNELING"] = "Останавливать макрос при поддержании"
L["MENU_STOP_IF_STEALTHED"] = "Останавливать макрос в незаметности"
L["MENU_SAFE_TO_SPAM_NOTE"] =
	"Чтобы макрос можно было безопасно жать раз за разом, включите Останавливать макрос при поддержании для поддерживаемого заклинания или Останавливать макрос в незаметности для Незаметности или Крадущегося зверя. Тогда повторное нажатие не прервет поддержание и не выведет из незаметности."
L["MENU_USE_FOR_KIND"] = "Применить эти параметры ко всей категории %s"
L["MENU_DUPLICATE"] = "Дублировать"
L["MENU_USE_FOR_KIND_DESCRIPTION"] =
	"Каждый макрос из категории %s, который вы не настраивали сами, получает параметры этого макроса. Открывает Умолчания макросов, чтобы показать это."

-- Page: Settings Menu
L["SETTINGS_SHOW_UNLEARNED"] = "Показывать неизученные заклинания"
L["SETTINGS_COUNT_SPELLS_ON_BARS"] = "Считать заклинания на панелях размещенными"
L["SETTINGS_MARK_ALL_PLACED"] = "Отметить все заклинания как размещенные"
L["SETTINGS_MARK_ALL_PLACED_DESCRIPTION"] =
	"Ни один макрос на этой странице больше не светится, есть он на ваших панелях или нет. Заклинание, изученное позже, светится, пока вы его не разместите."
L["SETTINGS_OPEN_MACRO_DEFAULTS_DESCRIPTION"] =
	"Открывает окно настроек на разделе Умолчания макросов, где вы выбираете, с какими параметрами создается каждый вид макроса заклинания."
L["SETTINGS_OPEN_CUSTOM_MACROS_DESCRIPTION"] =
	"Открывает окно настроек на разделе Свои макросы, где вы пишете собственные макросы для этой страницы."

-- Page: Macro Buttons
-- TRANSLATORS: each note fills the small slot under a macro button, so keep it short.
L["SUBTEXT_CUSTOM"] = "Свой"
L["SUBTEXT_FOCUS"] = "Фокус"
L["SUBTEXT_PET"] = "Питомец"
L["SUBTEXT_CURSOR"] = "Курсор"
L["SUBTEXT_STANCE"] = "Стойка"
L["SUBTEXT_USE_ITEMS"] = "Предметы"
L["SUBTEXT_PET_ATTACK"] = "Атака питомца"
L["SUBTEXT_DYNAMIC_RANK"] = "Дин. уровень"
L["SUBTEXT_TARGET_ENEMY"] = "Ближ. враг"
L["SUBTEXT_TARGET_FRIEND"] = "Ближ. союзник"
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
L["SUBTEXT_STOP_IF_CHANNELING"] = "Не при поддержании"
L["SUBTEXT_STOP_IF_STEALTHED"] = "Не в незаметности"
L["SUBTEXT_HIDE_ERRORS"] = "Без ошибок"
L["SUBTEXT_MUTE_ERRORS"] = "Без звука ошибок"
L["SUBTEXT_OPTIONS_COUNT"] = "Параметров: %d"
L["SUBTEXT_TOO_LONG"] = "Не умещается"
L["SUBTEXT_LEARN_LEVEL"] = "%d ур."
L["SUBTEXT_TALENT"] = "Талант"

-- Page: Macro Tooltip
L["TOOLTIP_NOT_LEARNED"] = "Еще не изучено"
L["TOOLTIP_LEARN_LEVEL"] = "Учитель вашего класса обучает этому на %d уровне."
L["TOOLTIP_LEARN_TALENT"] = "Изучается через таланты."
L["TOOLTIP_NOT_ON_BARS"] = "Нет на ваших панелях команд"
L["TOOLTIP_TOO_LONG"] =
	"Слишком длинный: %d / %d байт. Отключите параметр, чтобы сократить его."
L["TOOLTIP_OPTIONS_ON"] = "Включенные параметры: %s"
L["TOOLTIP_EQUIPMENT_SLOT"] =
	"Использует то, что надето в ячейке %s, поэтому продолжает работать после смены экипировки."
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
L["TOOLTIP_MACRO_SLOTS"] =
	"Каждый размещенный макрос занимает ячейку макроса. Ячейки персонажа принадлежат этому персонажу и заполняются первыми. Общие ячейки делят все персонажи вашей учетной записи."
L["PAGE_MACRO_GENERAL"] = "Общие"
L["PAGE_MACRO_CHARACTER"] = "Персонаж"
L["PAGE_FOOTER"] =
	"Нажмите на макрос или перетащите его на панели. Светящийся макрос еще не на ваших панелях. Правый клик по макросу открывает его параметры."

-- Options: General Panel
L["OPTIONS_DESCRIPTION"] =
	"Макросы при наведении, у курсора и на себя для каждого заклинания класса, создаются в один клик на новой вкладке книги заклинаний, без синтаксиса макросов. Они обновляются, когда вы повышаете уровень, обучаетесь или меняете специализацию. Правым кликом добавьте фокус, прерывание заклинания, автоатаку, атаку питомца или использование аксессуаров."
L["OPTIONS_ENABLE_WELCOME"] = "Включить приветствие"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"При каждом входе в игру выводит в чат однострочное приветствие с номером версии."
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Назначение клавиш"
L["OPTIONS_KEY_SET"] = "Назначить клавишу"
L["OPTIONS_KEY_SET_DESCRIPTION"] =
	"Открывает в игре список назначения клавиш, где у Macro Spellbook есть свой раздел."
L["OPTIONS_KEY_BINDING_TOGGLE_DESCRIPTION"] =
	"Открывает и закрывает Macro Spellbook. У него также есть своя вкладка в вашей книге заклинаний."
L["OPTIONS_DELETE_MACROS_HEADER"] = "Удаление макросов"
L["OPTIONS_DELETE_MACROS_DESCRIPTION"] =
	"Удаляет макросы, созданные Macro Spellbook, и тем самым убирает их с панелей команд. Ваши собственные макросы не затрагиваются, а страница создаст любой из них заново, если щёлкнуть по нему или перетащить его."
L["OPTIONS_DELETE_CHARACTER_MACROS"] = "Удалить макросы персонажа"
L["OPTIONS_DELETE_CHARACTER_MACROS_DESCRIPTION"] =
	"Удаляет макросы Macro Spellbook со вкладки макросов этого персонажа. Другие ваши персонажи сохранят свои, пока вы не сделаете то же самое на них."
L["OPTIONS_DELETE_CHARACTER_MACROS_CONFIRM"] =
	"Удалить все макросы Macro Spellbook этого персонажа? Они также исчезнут с панелей команд."
L["OPTIONS_DELETE_GENERAL_MACROS"] = "Удалить общие макросы"
L["OPTIONS_DELETE_GENERAL_MACROS_DESCRIPTION"] =
	"Удаляет макросы Macro Spellbook со вкладки «Общие макросы», общей для всех персонажей вашей учётной записи, поэтому другие ваши персонажи тоже их там лишатся."
L["OPTIONS_DELETE_GENERAL_MACROS_CONFIRM"] =
	"Удалить все общие макросы Macro Spellbook? Их лишатся все персонажи вашей учётной записи, и они также исчезнут с панелей команд."
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
	"Макрос перестает светиться, если его заклинание уже есть на ваших панелях, даже если у макроса включены параметры."

-- Options: Macro Defaults Panel
L["TAB_MACRO_DEFAULTS"] = "Умолчания макросов"
L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"] =
	"Параметры, с которыми создается каждый вид макроса: макросы предметов здесь, а каждый вид макроса заклинания — на своей странице ниже. То, что вы задали для макроса в его меню правого щелчка, сохраняется."
L["OPTIONS_DEFAULT_CURSOR_DESCRIPTION"] =
	"Размещает заклинание там, куда указывает курсор, без круга выбора цели."
L["OPTIONS_DEFAULT_DYNAMIC_RANK_DESCRIPTION"] =
	"Применяет самый высокий уровень заклинания, доступный для уровня дружественного игрока."
L["OPTIONS_DEFAULT_STOP_CASTING_DESCRIPTION"] =
	"Сначала прерывает то, что вы применяете, чтобы это заклинание сработало сразу."
L["OPTIONS_DEFAULT_STOP_ATTACK_DESCRIPTION"] =
	"Сначала прекращает вашу автоатаку в ближнем бою."
L["OPTIONS_DEFAULT_STOP_IF_CHANNELING_DESCRIPTION"] =
	"Ничего не делает, пока вы поддерживаете заклинание, поэтому нажатие никогда не прервет поддержание."
L["OPTIONS_DEFAULT_STOP_IF_STEALTHED_DESCRIPTION"] =
	"Ничего не делает, пока вы в незаметности, поэтому нажатие никогда не прервет Незаметность или Крадущегося зверя."
L["OPTIONS_DEFAULT_LEAVE_FORM_DESCRIPTION"] =
	"Сначала выводит из текущего облика, чтобы заклинание можно было применить."
L["OPTIONS_DEFAULT_TARGET_ENEMY_DESCRIPTION"] =
	"Сначала выбирает ближайшего врага, если у вас в цели нет живого врага."
L["OPTIONS_DEFAULT_TARGET_FRIEND_DESCRIPTION"] =
	"Сначала выбирает ближайшего союзника, если у вас в цели нет живого союзника."
L["OPTIONS_DEFAULT_PET_ATTACK_DESCRIPTION"] =
	"Также отправляет питомца атаковать вашу цель."
L["OPTIONS_DEFAULT_START_ATTACK_DESCRIPTION"] =
	"Начинает автоатаку в ближнем бою после применения."
L["OPTIONS_DEFAULT_AUTO_SHOT_DESCRIPTION"] =
	"Начинает Автоматическую стрельбу или стрельбу жезлом после применения."
L["OPTIONS_DEFAULT_ONCE_PER_TARGET_DESCRIPTION"] =
	"Применяется один раз и больше не применяется, пока не сменится цель."
L["OPTIONS_DEFAULT_ONCE_PER_COMBAT_DESCRIPTION"] =
	"Применяется один раз и больше не применяется, пока не закончится бой или не сменится цель."
L["OPTIONS_DEFAULT_NEVER_TURN_OFF_DESCRIPTION"] =
	"Оставляет облик или аспект включенным при повторном нажатии макроса, а не выключает его."
L["OPTIONS_DEFAULT_HIDE_ERRORS_DESCRIPTION"] =
	"Убирает красный текст ошибки, который макрос оставляет на экране."
L["OPTIONS_DEFAULT_MUTE_ERRORS_DESCRIPTION"] =
	"Отключает звук ошибки, пока выполняется макрос."
L["OPTIONS_DEFAULT_COMBAT_CHECK_DESCRIPTION"] =
	"Позволяет этим макросам срабатывать только в бою, только вне боя или в любом случае."
L["OPTIONS_KIND_YOUR_SPELLS"] = "Ваши заклинания"
L["OPTIONS_KIND_YOUR_ITEMS"] = "Ваши предметы"
L["OPTIONS_KIND_MORE"] = "И еще %d."
L["OPTIONS_KIND_NO_SPELLS"] =
	"Ни одно из ваших заклинаний не относится к этому виду."
L["OPTIONS_KIND_NO_ITEMS"] =
	"Ни у одного надетого предмета нет эффекта «Использование»."
L["KIND_ENEMY"] = "Заклинания против врагов"
L["KIND_ENEMY_DESCRIPTION"] =
	"Заклинания, применяемые к врагу, например атаки и ослабления."
L["KIND_FRIENDLY"] = "Дружественные заклинания"
L["KIND_FRIENDLY_DESCRIPTION"] =
	"Заклинания, применяемые к союзнику, например исцеление."
L["KIND_BUFF"] = "Усиления"
L["KIND_BUFF_DESCRIPTION"] =
	"Заклинания, дающие союзнику длительное усиление."
L["KIND_ANYONE"] = "Заклинания для союзника или врага"
L["KIND_ANYONE_DESCRIPTION"] =
	"Заклинания, которые можно применить и к союзнику, и к врагу."
L["KIND_GROUND"] = "Заклинания по земле"
L["KIND_GROUND_DESCRIPTION"] = "Заклинания, которые вы размещаете на земле."
L["KIND_FORM"] = "Облики, стойки и аспекты"
L["KIND_FORM_DESCRIPTION"] =
	"Заклинания, которые действуют, пока вы их не отключите или не смените."
L["KIND_SELF"] = "Заклинания на себя и по области"
L["KIND_SELF_DESCRIPTION"] =
	"Заклинания без цели, применяемые на себя или вокруг себя."
L["KIND_ITEM"] = "Макросы предметов"
L["KIND_ITEM_DESCRIPTION"] =
	"Макросы, которые используют надетые предметы, например аксессуары."

-- Options: Custom Macros Panel
L["TAB_CUSTOM_MACROS"] = "Свои макросы"
L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"] =
	"Ваши собственные макросы, показанные на странице в разделе Свои. Если удалить макрос здесь, он останется в /macro, и его нужно будет удалить вручную."
L["OPTIONS_CUSTOM_ADD"] = "Добавить макрос"
L["OPTIONS_CUSTOM_ADD_DESCRIPTION"] =
	"Добавляет новый собственный макрос в конец списка."
L["OPTIONS_CUSTOM_NEW_NAME"] = "Макрос"
L["OPTIONS_CUSTOM_NAME"] = "Название"
L["OPTIONS_CUSTOM_NAME_DESCRIPTION"] =
	"Название макроса. WoW сохраняет первые %d байт, а это меньше букв в таких языках, как русский, китайский или корейский."
L["OPTIONS_CUSTOM_SECTION"] = "Раздел"
L["OPTIONS_CUSTOM_SECTION_DESCRIPTION"] =
	"Где макрос показан на странице: в разделе Свои или вместе с заклинаниями одной из вкладок вашей книги заклинаний."
L["OPTIONS_CUSTOM_BODY_DESCRIPTION"] =
	"Текст макроса, не длиннее %d байт. Первая строка с #showtooltip и названием заклинания показывает значок этого заклинания."
L["OPTIONS_CUSTOM_STATUS_NEEDS"] =
	"Этому макросу нужны название и текст, прежде чем он появится на странице."
L["OPTIONS_CUSTOM_STATUS_TOO_LONG"] =
	"Слишком длинный: %d / %d байт. Он не появится на странице, пока не уложится в лимит."
L["OPTIONS_CUSTOM_STATUS_TAKEN"] =
	"Другой макрос на странице уже носит это название, поэтому этот не появится."
L["OPTIONS_CUSTOM_REMOVE_DESCRIPTION"] = "Удаляет этот макрос из списка."
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
L["ERROR_MACRO_SLOTS_FULL"] =
	"Нет свободных ячеек для макросов. Удалите макрос в /macro, чтобы освободить место."
L["ERROR_GENERAL_MACRO_SLOTS_FULL"] =
	"Нет свободных общих ячеек для макросов. Удалите общий макрос в /macro, чтобы освободить место."
L["CHAT_MACROS_DELETED"] = "Удалено макросов: %d"
L["CHAT_MACRO_TOO_LONG"] =
	'Макрос "%s" с включенными параметрами занимает %d байт, больше %d, которые вмещает макрос. Отключите параметр, чтобы сократить его.'
L["CHAT_CUSTOM_NEEDS_NAME_BODY"] =
	"Собственному макросу №%d нужны название и текст, прежде чем он появится на странице."
L["CHAT_CUSTOM_TOO_LONG"] =
	'Собственный макрос "%s" занимает %d байт, больше %d, которые вмещает макрос. Сократите его текст, чтобы добавить его на страницу.'
L["CHAT_CUSTOM_NAME_TAKEN"] =
	'Название собственного макроса "%s" совпадает (первые %d байт) с другим макросом на странице. Переименуйте его, чтобы добавить на страницу.'
