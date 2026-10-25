local L = LibStub("AceLocale-3.0"):NewLocale("MacroSpellbook", "deDE")
if not L then
	return
end

-- Add-on Names
L["ADDON_TITLE"] = "Macro Spellbook"
L["ADDON_SHORT_NAME"] = "Macro Spellbook"

-- Page: Sections
L["SECTION_UNLEARNED"] = "Nicht erlernt"
L["SECTION_CUSTOM"] = "Eigene"
L["SECTION_EQUIPMENT"] = "Ausrüstung"

-- Page: Default Custom Macros
-- TRANSLATORS: each name becomes a WoW macro name, cut to 16 bytes (about 5 Chinese or Korean characters), so keep it short.
L["CUSTOM_SPAM_WAND"] = "Zauberstab-Spam"
L["CUSTOM_PET_ABILITY"] = "Pet-Fähigkeit"
L["CUSTOM_PET_ABILITY_MOUSEOVER"] = "Pet-Mouseover"
L["CUSTOM_SWIFT_JUDGE"] = "Schnellurteil"

-- Page: Macro Menu
L["MENU_GROUP_COMBAT_CHECK"] = "Kampfbedingung"
L["MENU_GROUP_SPELL_RANK"] = "Zauberrang"
L["MENU_GROUP_TARGETING"] = "Zielauswahl"
L["MENU_GROUP_BEFORE_CAST"] = "Vor dem Wirken"
L["MENU_GROUP_ADD_ATTACK"] = "Angriff hinzufügen"
L["MENU_GROUP_CASTING_RULES"] = "Wirkregeln"
L["MENU_GROUP_ERRORS"] = "Fehlermeldungen"
L["MENU_GROUP_USE_ITEMS_FIRST"] = "Erst Gegenstände benutzen"
L["MACRO_TEXT"] = "Makrotext"
L["MENU_MACRO_LENGTH"] = "%d / %d"
L["MENU_GROUP_VALUE"] = "%s: %s"
L["MENU_OPTIONS_COUNT"] = "%d Optionen"
L["MENU_CAST_ON_MOUSEOVER"] = "Per Mouseover wirken"
L["MENU_CAST_ON_SELF"] = "Auf dich selbst wirken"
L["MENU_CAST_ON_TARGETS_TARGET"] = "Auf das Ziel des Ziels wirken"
L["MENU_RANK_LEARN_LEVEL"] = "%s (Stufe %d)"
L["MENU_MAX_RANK"] = "Höchster Rang"
L["MENU_DYNAMIC_RANK"] = "Dynamischer Rang"
L["MENU_DYNAMIC_RANK_NOTE"] =
	"Der dynamische Rang richtet sich nach der Stufe eines freundlichen Spielers und wird nur außerhalb des Kampfes aktualisiert."
L["MENU_CAST_AT_CURSOR"] = "Am Cursor wirken"
L["MENU_TARGET_NEAREST_ENEMY"] = "Nächsten Feind anvisieren"
L["MENU_TARGET_NEAREST_FRIEND"] = "Nächsten Verbündeten anvisieren"
L["MENU_CAST_IF_SUMMONED"] = "%s wirken, wenn beschworen"
L["MENU_NEVER_TURN_OFF"] = "Nie ausschalten"
L["MENU_LEAVE_FORM_BEFORE"] = "Vor dem Wirken Gestalt verlassen"
L["MENU_RIGHT_CLICK_FOR"] = "Rechtsklick für %s"
L["MENU_ONLY_IN_COMBAT"] = "Nur im Kampf"
L["MENU_NEVER_IN_COMBAT"] = "Nie im Kampf"
L["MENU_COMBAT_CHECK_NONE"] = "Keine"
L["MENU_ONCE_PER_COMBAT"] = "Einmal pro Kampf wirken"
L["MENU_ONCE_PER_TARGET"] = "Einmal pro Ziel wirken"
L["MENU_HIDE_ERRORS"] = "Fehlermeldungen ausblenden"
L["MENU_MUTE_ERRORS"] = "Fehlergeräusche stummschalten"
L["MENU_SWITCH_TO"] = "Zu %s wechseln"
L["MENU_CAST_ON_FOCUS"] = "Auf den Fokus wirken"
L["MENU_START_AUTO_ATTACK"] = "Automatischen Angriff starten"
L["MENU_STOP_ATTACK"] = "Angriff beenden"
L["MENU_START_AUTO_SHOT"] = "Automatischen Schuss starten"
L["MENU_START_PET_ATTACK"] = "Begleiterangriff starten"
L["MENU_START_WAND"] = "Zauberstab starten"
L["MENU_STOP_CASTING"] = "Zaubern abbrechen"
L["MENU_STOP_CASTING_NOTE"] =
	"Nutze Zaubern abbrechen für Zauber, die nicht warten können, etwa Unterbrechungen und Bannzauber."
L["MENU_STOP_IF_CHANNELING"] = "Makro beim Kanalisieren stoppen"
L["MENU_STOP_IF_STEALTHED"] = "Makro in Verstohlenheit stoppen"
L["MENU_SAFE_TO_SPAM_NOTE"] =
	"Damit du ein Makro gefahrlos spammen kannst, schalte bei einem kanalisierten Zauber Makro beim Kanalisieren stoppen ein, bei Verstohlenheit oder Schleichen Makro in Verstohlenheit stoppen. Erneutes Drücken unterbricht dann weder das Kanalisieren noch deine Verstohlenheit."
L["MENU_USE_FOR_KIND"] = "Diese Optionen für die Kategorie %s verwenden"
L["MENU_DUPLICATE"] = "Duplizieren"
L["MENU_REMOVE_COPY"] = "Diese Kopie entfernen"
L["MENU_USE_FOR_KIND_DESCRIPTION"] =
	"Jedes Makro in der Kategorie %s, das du nicht selbst eingestellt hast, beginnt mit den Optionen dieses Makros. Öffnet Makro-Standards, um es dir zu zeigen."

-- Page: Settings Menu
L["SETTINGS_SHOW_UNLEARNED"] = "Nicht erlernte Zauber anzeigen"
L["SETTINGS_COUNT_SPELLS_ON_BARS"] = "Zauber auf Leisten als platziert zählen"
L["SETTINGS_MARK_ALL_PLACED"] = "Alle Zauber als platziert markieren"
L["SETTINGS_MARK_ALL_PLACED_DESCRIPTION"] =
	"Kein Makro auf dieser Seite leuchtet mehr, ob es auf deinen Leisten liegt oder nicht. Ein Zauber, den du später erlernst, leuchtet weiter, bis du ihn platzierst."
L["SETTINGS_CLEAR_PLACED"] = "Platziert-Markierungen löschen"
L["SETTINGS_CLEAR_PLACED_DESCRIPTION"] =
	"Lässt jedes markierte Makro, das nicht auf deinen Leisten liegt, wieder leuchten."
L["SETTINGS_OPEN_MACRO_DEFAULTS_DESCRIPTION"] =
	"Öffnet die Optionen bei Makro-Standards, wo du festlegst, mit welchen Optionen jede Art von Zaubermakro beginnt."
L["SETTINGS_OPEN_CUSTOM_MACROS_DESCRIPTION"] =
	"Öffnet die Optionen bei Eigene Makros, wo du deine eigenen Makros für diese Seite schreibst."

-- Page: Macro Buttons
-- TRANSLATORS: each note fills the small slot under a macro button, so keep it short.
L["SUBTEXT_CUSTOM"] = "Eigenes"
L["SUBTEXT_FOCUS"] = "Fokus"
L["SUBTEXT_PET"] = "Begleiter"
L["SUBTEXT_CURSOR"] = "Am Cursor"
L["SUBTEXT_MOUSEOVER"] = "Maus"
L["SUBTEXT_CAST_ON_SELF"] = "Auf dich"
L["SUBTEXT_STANCE"] = "Haltung"
L["SUBTEXT_USE_ITEMS"] = "Gegenstände"
L["SUBTEXT_PET_ATTACK"] = "Begleiterangriff"
L["SUBTEXT_DYNAMIC_RANK"] = "Dyn. Rang"
L["SUBTEXT_TARGETS_TARGET"] = "Ziel des Ziels"
L["SUBTEXT_TARGET_ENEMY"] = "Nächster Feind"
L["SUBTEXT_TARGET_FRIEND"] = "Nächster Verbündeter"
L["SUBTEXT_GROUP_VERSION"] = "Gruppenversion"
L["SUBTEXT_ONCE_PER_COMBAT"] = "1x pro Kampf"
L["SUBTEXT_ONCE_PER_TARGET"] = "1x pro Ziel"
L["SUBTEXT_COMBAT_ONLY"] = "Nur im Kampf"
L["SUBTEXT_NO_COMBAT"] = "Außer Kampf"
L["SUBTEXT_LEAVE_FORM"] = "Gestalt verlassen"
L["SUBTEXT_NO_TOGGLE"] = "Bleibt an"
L["SUBTEXT_WAND"] = "Zauberstab"
L["SUBTEXT_START_ATTACK"] = "Auto-Angriff"
L["SUBTEXT_STOP_ATTACK"] = "Angriff aus"
L["SUBTEXT_STOP_CASTING"] = "Zauber abbr."
L["SUBTEXT_STOP_IF_CHANNELING"] = "Nicht beim Kanalisieren"
L["SUBTEXT_STOP_IF_STEALTHED"] = "Nicht in Verstohlenheit"
L["SUBTEXT_HIDE_ERRORS"] = "Fehler aus"
L["SUBTEXT_MUTE_ERRORS"] = "Fehler stumm"
L["SUBTEXT_OPTIONS_COUNT"] = "%d Optionen"
L["SUBTEXT_TOO_LONG"] = "Zu lang"
L["SUBTEXT_LEARN_LEVEL"] = "Stufe %d"
L["SUBTEXT_TALENT"] = "Talent"

-- Page: Macro Tooltip
L["TOOLTIP_NOT_LEARNED"] = "Noch nicht erlernt"
L["TOOLTIP_LEARN_LEVEL"] = "Dein Klassenlehrer bringt ihn dir auf Stufe %d bei."
L["TOOLTIP_LEARN_TALENT"] = "Wird über deine Talente erlernt."
L["TOOLTIP_NOT_ON_BARS"] = "Nicht auf deinen Aktionsleisten"
L["TOOLTIP_TOO_LONG"] = "Zu lang: %d / %d Bytes. Schalte eine Option ab, um es zu kürzen."
L["TOOLTIP_OPTIONS_ON"] = "Aktive Optionen: %s"
L["TOOLTIP_EQUIPMENT_SLOT"] =
	"Benutzt, was du im Platz %s trägst, und funktioniert daher auch nach einem Ausrüstungswechsel weiter."
L["TOOLTIP_KEY_CLICK_DRAG"] = "Klicken oder ziehen"
L["TOOLTIP_ACTION_PLACE_ON_BAR"] = "Auf deine Aktionsleisten legen"
L["TOOLTIP_KEY_RIGHT_CLICK"] = "Rechtsklick"
L["TOOLTIP_ACTION_MACRO_OPTIONS"] = "Makrooptionen"

-- Spellbook Tab Tooltip
L["SPELLBOOK_TAB_DESCRIPTION"] = "Die Zauber deiner Klasse als Ein-Klick-Makros."
L["TOOLTIP_KEY_CLICK"] = "Klicken"
L["TOOLTIP_ACTION_OPEN_PAGE"] = "Macro Spellbook öffnen"

-- Page: Layout
L["PAGE_EMPTY"] =
	"Noch keine Makros. Besuche deinen Klassenlehrer, um deine ersten Zauber zu erlernen, oder füge eigene Makros unter Optionen > AddOns > Macro Spellbook > Eigene Makros hinzu."
L["PAGE_MACRO_SLOTS"] = "Makroplätze"
L["TOOLTIP_MACRO_SLOTS"] =
	"Jedes Makro, das du platzierst, belegt einen Makroplatz. Charakterplätze gehören diesem Charakter und werden zuerst belegt. Allgemeine Plätze teilen sich alle Charaktere deines Accounts."
L["PAGE_MACRO_GENERAL"] = "Allgemein"
L["PAGE_MACRO_CHARACTER"] = "Charakter"
L["PAGE_FOOTER"] =
	"Klicke oder ziehe ein Makro auf deine Leisten. Ein leuchtendes Makro liegt noch nicht auf deinen Leisten. Rechtsklicke ein Makro für seine Optionen."

-- Options: General Panel
L["OPTIONS_DESCRIPTION"] =
	"Mouseover-, Cursor- und Selbstzauber-Makros für jeden Klassenzauber, mit einem Klick in einem neuen Zauberbuch-Reiter erstellt, ganz ohne Makrosyntax. Sie bleiben aktuell, wenn du aufsteigst, trainierst oder die Spezialisierung wechselst. Per Rechtsklick kommen Fokus, Zaubern abbrechen, automatischer Angriff, Begleiterangriff oder Schmuckstücke dazu."
L["OPTIONS_ENABLE_WELCOME"] = "Willkommensnachricht aktivieren"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Zeigt bei jedem Einloggen eine einzeilige Begrüßung mit der Version im Chat."
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Tastenbelegung"
L["OPTIONS_KEY_SET"] = "Taste festlegen"
L["OPTIONS_KEY_SET_DESCRIPTION"] =
	"Öffnet die Tastenbelegung des Spiels, in der Macro Spellbook einen eigenen Abschnitt hat."
L["OPTIONS_KEY_BINDING_TOGGLE_DESCRIPTION"] =
	"Öffnet und schließt Macro Spellbook. Es hat außerdem einen eigenen Reiter in deinem Zauberbuch."
L["OPTIONS_COMMANDS_HEADER"] = "/Befehle"
L["OPTIONS_COMMAND"] = "/msb"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Öffnet die Optionen dieses Add-ons."

-- Options: Spellbook Page Panel
L["TAB_SPELLBOOK_PAGE"] = "Zauberbuchseite"
L["OPTIONS_SPELLBOOK_PAGE_DESCRIPTION"] = "Wie die Macro Spellbook-Seite in deinem Zauberbuch deine Zauber auflistet."
L["OPTIONS_SHOW_UNLEARNED_DESCRIPTION"] =
	"Listet die Klassenzauber, die du noch nicht erlernt hast, im Abschnitt Nicht erlernt auf, damit du ihre Makros schon vorher platzieren kannst."
L["OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION"] =
	"Ein Makro leuchtet nicht mehr, wenn sein Zauber schon auf deinen Leisten liegt, auch wenn das Makro Optionen aktiviert hat."

-- Options: Macro Defaults Panel
L["TAB_MACRO_DEFAULTS"] = "Makro-Standards"
L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"] =
	"Die Optionen, mit denen jede Art von Zaubermakro beginnt. Ein Makro behält, was du über sein Rechtsklickmenü einstellst. Jede Art zeigt nur die Optionen, die ihre Zauber bieten."
L["OPTIONS_DEFAULT_MOUSEOVER_DESCRIPTION"] = "Wirkt zuerst auf den, der unter deiner Maus ist, dann auf dein Ziel."
L["OPTIONS_DEFAULT_CAST_ON_SELF_DESCRIPTION"] = "Wirkt auf dich, wenn dein Ziel den Zauber nicht erhalten kann."
L["OPTIONS_DEFAULT_TARGETS_TARGET_DESCRIPTION"] =
	"Versucht es beim Ziel deines Ziels, wenn dein Ziel den Zauber nicht erhalten kann, etwa beim Tank, den ein Feind angreift."
L["OPTIONS_DEFAULT_CURSOR_DESCRIPTION"] = "Setzt den Zauber dorthin, wo dein Cursor hinzeigt, ohne Zielkreis."
L["OPTIONS_DEFAULT_DYNAMIC_RANK_DESCRIPTION"] =
	"Wirkt den höchsten Rang, den die Stufe des freundlichen Spielers zulässt."
L["OPTIONS_DEFAULT_STOP_CASTING_DESCRIPTION"] =
	"Bricht zuerst ab, was du gerade wirkst, damit dieser Zauber sofort losgeht."
L["OPTIONS_DEFAULT_STOP_ATTACK_DESCRIPTION"] = "Beendet zuerst deinen automatischen Nahkampfangriff."
L["OPTIONS_DEFAULT_STOP_IF_CHANNELING_DESCRIPTION"] =
	"Tut nichts, während du einen Zauber kanalisierst, damit ein Tastendruck das Kanalisieren nie unterbricht."
L["OPTIONS_DEFAULT_STOP_IF_STEALTHED_DESCRIPTION"] =
	"Tut nichts, während du verstohlen bist, damit ein Tastendruck Verstohlenheit oder Schleichen nie beendet."
L["OPTIONS_DEFAULT_LEAVE_FORM_DESCRIPTION"] =
	"Verlässt zuerst deine aktuelle Gestalt, damit der Zauber gewirkt werden kann."
L["OPTIONS_DEFAULT_TARGET_ENEMY_DESCRIPTION"] =
	"Visiert zuerst den nächsten Feind an, wenn du keinen lebenden Feind im Ziel hast."
L["OPTIONS_DEFAULT_TARGET_FRIEND_DESCRIPTION"] =
	"Visiert zuerst den nächsten Verbündeten an, wenn du keinen lebenden Verbündeten im Ziel hast."
L["OPTIONS_DEFAULT_PET_ATTACK_DESCRIPTION"] = "Schickt auch deinen Begleiter los, um dein Ziel anzugreifen."
L["OPTIONS_DEFAULT_START_ATTACK_DESCRIPTION"] = "Startet nach dem Wirken deinen automatischen Nahkampfangriff."
L["OPTIONS_DEFAULT_AUTO_SHOT_DESCRIPTION"] = "Startet nach dem Wirken den Automatischen Schuss oder deinen Zauberstab."
L["OPTIONS_DEFAULT_ONCE_PER_TARGET_DESCRIPTION"] = "Wirkt einmal und dann erst wieder, wenn dein Ziel wechselt."
L["OPTIONS_DEFAULT_ONCE_PER_COMBAT_DESCRIPTION"] =
	"Wirkt einmal und dann erst wieder, wenn der Kampf endet oder dein Ziel wechselt."
L["OPTIONS_DEFAULT_NEVER_TURN_OFF_DESCRIPTION"] =
	"Lässt Gestalt oder Aspekt an, wenn du das Makro erneut drückst, statt sie auszuschalten."
L["OPTIONS_DEFAULT_HIDE_ERRORS_DESCRIPTION"] =
	"Entfernt den roten Fehlertext, den das Makro auf dem Bildschirm hinterlässt."
L["OPTIONS_DEFAULT_MUTE_ERRORS_DESCRIPTION"] = "Schaltet das Fehlergeräusch stumm, während das Makro läuft."
L["OPTIONS_DEFAULT_COMBAT_CHECK_DESCRIPTION"] =
	"Lässt diese Makros nur im Kampf, nur außerhalb des Kampfes oder immer wirken."
L["OPTIONS_KIND_EXAMPLES"] = "Deine Zauber: %s"
L["OPTIONS_KIND_EXAMPLES_MORE"] = "%s und %d weitere"
L["KIND_ENEMY"] = "Zauber gegen Feinde"
L["KIND_ENEMY_DESCRIPTION"] = "Zauber, die du auf einen Feind wirkst, etwa Angriffe und Schwächungen."
L["KIND_FRIENDLY"] = "Freundliche Zauber"
L["KIND_FRIENDLY_DESCRIPTION"] = "Zauber, die du auf einen Verbündeten wirkst, etwa Heilungen."
L["KIND_BUFF"] = "Stärkungszauber"
L["KIND_BUFF_DESCRIPTION"] = "Zauber, die einem Verbündeten eine anhaltende Stärkung geben."
L["KIND_ANYONE"] = "Zauber für Freund oder Feind"
L["KIND_ANYONE_DESCRIPTION"] = "Zauber, die du auf einen Verbündeten oder einen Feind wirken kannst."
L["KIND_GROUND"] = "Bodenzauber"
L["KIND_GROUND_DESCRIPTION"] = "Zauber, die du auf dem Boden platzierst."
L["KIND_FORM"] = "Gestalten, Haltungen und Aspekte"
L["KIND_FORM_DESCRIPTION"] = "Zauber, die aktiv bleiben, bis du sie ausschaltest oder wechselst."
L["KIND_SELF"] = "Selbst- und Flächenzauber"
L["KIND_SELF_DESCRIPTION"] = "Zauber ohne Ziel, die auf dich oder um dich herum wirken."

-- Options: Custom Macros Panel
L["TAB_CUSTOM_MACROS"] = "Eigene Makros"
L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"] =
	"Deine eigenen Makros, auf der Seite unter Eigene aufgelistet. Entfernst du eines hier, bleibt sein Makro in /macro, damit du es selbst löschen kannst."
L["OPTIONS_CUSTOM_ADD"] = "Makro hinzufügen"
L["OPTIONS_CUSTOM_ADD_DESCRIPTION"] = "Fügt am Ende der Liste ein neues eigenes Makro hinzu."
L["OPTIONS_CUSTOM_NEW_NAME"] = "Neues Makro"
L["OPTIONS_CUSTOM_NAME"] = "Name"
L["OPTIONS_CUSTOM_NAME_DESCRIPTION"] =
	"Der Name des Makros. WoW behält die ersten %d Bytes, das sind in Sprachen wie Russisch, Chinesisch oder Koreanisch weniger Buchstaben."
L["OPTIONS_CUSTOM_SECTION"] = "Abschnitt"
L["OPTIONS_CUSTOM_SECTION_DESCRIPTION"] =
	"Wo das Makro auf der Seite aufgelistet wird: unter Eigene oder bei den Zaubern eines Reiters deines Zauberbuchs."
L["OPTIONS_CUSTOM_BODY_DESCRIPTION"] =
	"Der Text des Makros, bis zu %d Bytes. Eine erste Zeile mit #showtooltip und einem Zaubernamen zeigt das Symbol dieses Zaubers."
L["OPTIONS_CUSTOM_STATUS_NEEDS"] =
	"Dieses Makro braucht einen Namen und einen Makrotext, bevor es auf der Seite erscheint."
L["OPTIONS_CUSTOM_STATUS_TOO_LONG"] = "Zu lang: %d / %d Bytes. Es erscheint erst auf der Seite, wenn es hineinpasst."
L["OPTIONS_CUSTOM_STATUS_TAKEN"] =
	"Ein anderes Makro auf der Seite hat bereits diesen Namen, daher erscheint dieses nicht."
L["OPTIONS_CUSTOM_REMOVE_DESCRIPTION"] = "Entfernt dieses Makro aus der Liste."
L["OPTIONS_CUSTOM_REMOVE_CONFIRM"] = "Dieses eigene Makro entfernen?"
L["OPTIONS_CUSTOM_RESTORE"] = "Standards wiederherstellen"
L["OPTIONS_CUSTOM_RESTORE_DESCRIPTION"] = "Ersetzt deine eigenen Makros durch die, mit denen deine Klasse beginnt."
L["OPTIONS_CUSTOM_RESTORE_CONFIRM"] = "Alle deine eigenen Makros durch die Standards deiner Klasse ersetzen?"

-- Options: Feedback & Support Panel
L["OPTIONS_LEVEL_UP_TITLE"] = "Hilf Macro Spellbook beim Leveln"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Dieses Add-on wurde von Spielern entwickelt, die dieses Spiel lieben und es für alle so unterhaltsam wie möglich machen wollen. Wir werden nie um Spenden bitten. Die wahre Freude liegt darin zu wissen, dass unsere Arbeit das Spiel für dich ein bisschen besser macht. Wenn das so ist, würden wir uns freuen, davon zu hören!"
L["OPTIONS_LEVEL_UP_WAYS"] = "Hier sind ein paar Möglichkeiten, wie du uns helfen kannst, mehr Spieler zu erreichen."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Feedback geben: Einen Fehler gefunden oder eine Idee? Sag es uns auf Discord. Dein Feedback hilft uns, das Add-on zu verbessern, und Pull Requests sind immer willkommen."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Erzähl es weiter: Kennst du jemanden, dem dieses Add-on gefallen könnte? Erzähl davon. Mundpropaganda hilft mehr Spielern, großartige Add-ons zu entdecken."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Favorit auf CurseForge: Öffne unten den CurseForge-Link, melde dich an und klicke auf den Stern unter der Schaltfläche Download. Favoriten helfen mehr Spielern, das Add-on zu entdecken."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Star auf GitHub: Öffne unten den GitHub-Link, melde dich an und klicke oben rechts auf Star. Stars helfen dem Projekt, sich für weitere kostenlose Entwicklerwerkzeuge zu qualifizieren."
L["OPTIONS_LEVEL_UP_THANKS"] = "Danke, dass du dich für Macro Spellbook entschieden hast!"

L["OPTIONS_FEEDBACK"] = "Feedback & Unterstützung"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Links für Feedback & Unterstützung"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "Um einen Link zu kopieren, klicke in sein Feld und drücke dann Strg+A und Strg+C."
L["OPTIONS_VERSION"] = "Version %s"

-- Key Bindings
L["BINDING_TOGGLE_PAGE"] = "Macro Spellbook ein-/ausblenden"

-- Messages
L["CHAT_LOADED"] =
	"Version %s. Einstellungen (einschließlich der Option, diese Nachricht abzuschalten) findest du unter Optionen > AddOns > Macro Spellbook. Gefällt dir dieses Add-on? Erzähl es einem Freund, setze es auf CurseForge auf deine Favoriten oder gib ihm einen Star auf GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Aus Sicherheitsgründen können die Optionen im Kampf nicht geöffnet werden."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "Aus Sicherheitsgründen kann die Tastenbelegung im Kampf nicht geöffnet werden."
L["KEY_BINDINGS_LOCATION"] = "Öffne das Spielmenü, dann %s, dann %s, und suche den Abschnitt Macro Spellbook."
L["ERROR_MACRO_SLOTS_FULL"] = "Keine freien Makroplätze. Lösche ein Makro in /macro, um Platz zu schaffen."
L["ERROR_GENERAL_MACRO_SLOTS_FULL"] =
	"Keine freien allgemeinen Makroplätze. Lösche ein allgemeines Makro in /macro, um Platz zu schaffen."
L["CHAT_MACRO_TOO_LONG"] =
	'Das Makro "%s" ist mit seinen Optionen %d Bytes lang, mehr als die %d, die ein Makro fasst. Schalte eine Option ab, um es zu kürzen.'
L["CHAT_CUSTOM_NEEDS_NAME_BODY"] =
	"Das eigene Makro #%d braucht einen Namen und einen Makrotext, bevor es auf der Seite erscheint."
L["CHAT_CUSTOM_TOO_LONG"] =
	'Das eigene Makro "%s" ist %d Bytes lang, mehr als die %d, die ein Makro fasst. Kürze seinen Text, um es zur Seite hinzuzufügen.'
L["CHAT_CUSTOM_NAME_TAKEN"] =
	'Das eigene Makro "%s" hat denselben Namen (die ersten %d Bytes) wie ein anderes Makro auf der Seite. Benenne es um, um es zur Seite hinzuzufügen.'
