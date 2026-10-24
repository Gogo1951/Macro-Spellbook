local L = LibStub("AceLocale-3.0"):NewLocale("MacroSpellbook", "itIT")
if not L then
	return
end

-- Add-on Names
L["ADDON_TITLE"] = "Macro Spellbook"
L["ADDON_SHORT_NAME"] = "Macro Spellbook"

-- Page: Sections
L["SECTION_UNLEARNED"] = "Non appresi"
L["SECTION_CUSTOM"] = "Personalizzate"
L["SECTION_EQUIPMENT"] = "Equipaggiamento"

-- Page: Default Custom Macros
-- TRANSLATORS: each name becomes a WoW macro name, cut to 16 bytes (about 5 Chinese or Korean characters), so keep it short.
L["CUSTOM_SPAM_WAND"] = "Bacchetta auto"
L["CUSTOM_PET_ABILITY"] = "Abil. famiglio"
L["CUSTOM_PET_ABILITY_MOUSEOVER"] = "Famiglio (mouse)"
L["CUSTOM_SWIFT_JUDGE"] = "Giudizio rapido"

-- Page: Macro Menu
L["MENU_GROUP_COMBAT_CHECK"] = "Condizione di combattimento"
L["MENU_GROUP_SPELL_RANK"] = "Grado dell'incantesimo"
L["MENU_GROUP_TARGETING"] = "Selezione del bersaglio"
L["MENU_GROUP_BEFORE_CAST"] = "Prima del lancio"
L["MENU_GROUP_ADD_ATTACK"] = "Aggiungi attacco"
L["MENU_GROUP_CASTING_RULES"] = "Regole di lancio"
L["MENU_GROUP_ERRORS"] = "Messaggi di errore"
L["MENU_GROUP_USE_ITEMS_FIRST"] = "Usa prima gli oggetti"
L["MACRO_TEXT"] = "Testo della macro"
L["MENU_MACRO_LENGTH"] = "%d / %d"
L["MENU_GROUP_VALUE"] = "%s: %s"
L["MENU_OPTIONS_COUNT"] = "%d opzioni"
L["MENU_CAST_ON_MOUSEOVER"] = "Lancia al passaggio del mouse"
L["MENU_CAST_ON_SELF"] = "Lancia su te stesso"
L["MENU_CAST_ON_TARGETS_TARGET"] = "Lancia sul bersaglio del bersaglio"
L["MENU_RANK_LEARN_LEVEL"] = "%s (Livello %d)"
L["MENU_MAX_RANK"] = "Grado massimo"
L["MENU_DYNAMIC_RANK"] = "Grado dinamico"
L["MENU_DYNAMIC_RANK_NOTE"] =
	"Il grado dinamico, basato sul livello di un giocatore amico, si aggiorna solo fuori dal combattimento."
L["MENU_CAST_AT_CURSOR"] = "Lancia sul cursore"
L["MENU_TARGET_NEAREST_ENEMY"] = "Seleziona il nemico più vicino"
L["MENU_TARGET_NEAREST_FRIEND"] = "Seleziona l'alleato più vicino"
L["MENU_CAST_IF_SUMMONED"] = "Lancia %s se evocato"
L["MENU_NEVER_TURN_OFF"] = "Non disattivare mai"
L["MENU_LEAVE_FORM_BEFORE"] = "Esci dalla forma prima del lancio"
L["MENU_RIGHT_CLICK_FOR"] = "Clic destro per %s"
L["MENU_ONLY_IN_COMBAT"] = "Solo in combattimento"
L["MENU_NEVER_IN_COMBAT"] = "Mai in combattimento"
L["MENU_COMBAT_CHECK_NONE"] = "Nessuna"
L["MENU_ONCE_PER_COMBAT"] = "Lancia una volta per combattimento"
L["MENU_ONCE_PER_TARGET"] = "Lancia una volta per bersaglio"
L["MENU_HIDE_ERRORS"] = "Nascondi i messaggi di errore"
L["MENU_MUTE_ERRORS"] = "Silenzia i suoni di errore"
L["MENU_SWITCH_TO"] = "Passa a %s"
L["MENU_CAST_ON_FOCUS"] = "Lancia sul focus"
L["MENU_START_AUTO_ATTACK"] = "Avvia l'attacco automatico"
L["MENU_STOP_ATTACK"] = "Ferma l'attacco"
L["MENU_START_AUTO_SHOT"] = "Avvia il tiro automatico"
L["MENU_START_PET_ATTACK"] = "Avvia l'attacco del famiglio"
L["MENU_START_WAND"] = "Avvia la bacchetta"
L["MENU_STOP_CASTING"] = "Interrompi il lancio"
L["MENU_STOP_CASTING_NOTE"] =
	"Usa Interrompi il lancio per gli incantesimi che non possono aspettare, come interruzioni e dissoluzioni."
L["MENU_STOP_IF_CHANNELING"] = "Ferma la macro se canalizzi"
L["MENU_STOP_IF_STEALTHED"] = "Ferma la macro se sei furtivo"
L["MENU_SAFE_TO_SPAM_NOTE"] =
	"Per premere una macro a ripetizione senza rischi, attiva Ferma la macro se canalizzi per un incantesimo canalizzato, o Ferma la macro se sei furtivo per Furtività o Aggirarsi. Premerla di nuovo non interromperà più la canalizzazione o la tua furtività."
L["MENU_USE_FOR_KIND"] = "Usa queste opzioni per la categoria %s"
L["MENU_DUPLICATE"] = "Duplica"
L["MENU_REMOVE_COPY"] = "Rimuovi questa copia"
L["MENU_USE_FOR_KIND_DESCRIPTION"] =
	"Ogni macro della categoria %s che non hai impostato tu parte con le opzioni di questa macro. Apre Predefiniti delle macro per mostrartelo."

-- Page: Settings Menu
L["SETTINGS_SHOW_UNLEARNED"] = "Mostra gli incantesimi non appresi"
L["SETTINGS_COUNT_SPELLS_ON_BARS"] = "Considera piazzati gli incantesimi sulle barre"
L["SETTINGS_MARK_ALL_PLACED"] = "Segna tutti gli incantesimi come piazzati"
L["SETTINGS_MARK_ALL_PLACED_DESCRIPTION"] =
	"Nessuna macro di questa pagina si illumina più, che sia sulle tue barre o no. Un incantesimo che impari in seguito resta illuminato finché non lo piazzi."
L["SETTINGS_CLEAR_PLACED"] = "Cancella i segni di piazzamento"
L["SETTINGS_CLEAR_PLACED_DESCRIPTION"] = "Fa di nuovo illuminare ogni macro segnata che non è sulle tue barre."
L["SETTINGS_OPEN_MACRO_DEFAULTS_DESCRIPTION"] =
	"Apre l'interfaccia delle opzioni su Predefiniti delle macro, dove scegli le opzioni con cui parte ogni tipo di macro di incantesimo."
L["SETTINGS_OPEN_CUSTOM_MACROS_DESCRIPTION"] =
	"Apre l'interfaccia delle opzioni su Macro personalizzate, dove scrivi le tue macro per questa pagina."

-- Page: Macro Buttons
-- TRANSLATORS: each note fills the small slot under a macro button, so keep it short.
L["SUBTEXT_CUSTOM"] = "Personale"
L["SUBTEXT_FOCUS"] = "Sul focus"
L["SUBTEXT_PET"] = "Famiglio"
L["SUBTEXT_CURSOR"] = "Cursore"
L["SUBTEXT_MOUSEOVER"] = "Col mouse"
L["SUBTEXT_CAST_ON_SELF"] = "Su di te"
L["SUBTEXT_STANCE"] = "Postura"
L["SUBTEXT_USE_ITEMS"] = "Usa oggetti"
L["SUBTEXT_PET_ATTACK"] = "Attacco famiglio"
L["SUBTEXT_DYNAMIC_RANK"] = "Grado din."
L["SUBTEXT_TARGETS_TARGET"] = "Bers. del bers."
L["SUBTEXT_TARGET_ENEMY"] = "Nemico vicino"
L["SUBTEXT_TARGET_FRIEND"] = "Alleato vicino"
L["SUBTEXT_GROUP_VERSION"] = "Versione gruppo"
L["SUBTEXT_ONCE_PER_COMBAT"] = "1 per combatt."
L["SUBTEXT_ONCE_PER_TARGET"] = "1 per bersaglio"
L["SUBTEXT_COMBAT_ONLY"] = "Solo in combatt."
L["SUBTEXT_NO_COMBAT"] = "Fuori combatt."
L["SUBTEXT_LEAVE_FORM"] = "Esce da forma"
L["SUBTEXT_NO_TOGGLE"] = "Resta attivo"
L["SUBTEXT_WAND"] = "Bacchetta"
L["SUBTEXT_START_ATTACK"] = "Attacco auto"
L["SUBTEXT_STOP_ATTACK"] = "Ferma attacco"
L["SUBTEXT_STOP_CASTING"] = "Interrompe"
L["SUBTEXT_STOP_IF_CHANNELING"] = "Non se canalizzi"
L["SUBTEXT_STOP_IF_STEALTHED"] = "Non se furtivo"
L["SUBTEXT_HIDE_ERRORS"] = "Senza errori"
L["SUBTEXT_MUTE_ERRORS"] = "Errori muti"
L["SUBTEXT_OPTIONS_COUNT"] = "%d opzioni"
L["SUBTEXT_TOO_LONG"] = "Troppo lunga"
L["SUBTEXT_LEARN_LEVEL"] = "Livello %d"
L["SUBTEXT_TALENT"] = "Talento"

-- Page: Macro Tooltip
L["TOOLTIP_NOT_LEARNED"] = "Non ancora appreso"
L["TOOLTIP_LEARN_LEVEL"] = "Il tuo istruttore di classe lo insegna al livello %d."
L["TOOLTIP_LEARN_TALENT"] = "Si impara dai tuoi talenti."
L["TOOLTIP_NOT_ON_BARS"] = "Non è sulle tue barre delle azioni"
L["TOOLTIP_TOO_LONG"] = "Troppo lunga: %d / %d byte. Disattiva un'opzione per accorciarla."
L["TOOLTIP_OPTIONS_ON"] = "Opzioni attive: %s"
L["TOOLTIP_EQUIPMENT_SLOT"] =
	"Usa ciò che indossi nello slot %s, così continua a funzionare quando cambi equipaggiamento."
L["TOOLTIP_KEY_CLICK_DRAG"] = "Clic o trascina"
L["TOOLTIP_ACTION_PLACE_ON_BAR"] = "Piazza sulle tue barre delle azioni"
L["TOOLTIP_KEY_RIGHT_CLICK"] = "Clic destro"
L["TOOLTIP_ACTION_MACRO_OPTIONS"] = "Opzioni della macro"

-- Spellbook Tab Tooltip
L["SPELLBOOK_TAB_DESCRIPTION"] = "Gli incantesimi della tua classe come macro a un clic."
L["TOOLTIP_KEY_CLICK"] = "Clic"
L["TOOLTIP_ACTION_OPEN_PAGE"] = "Apri Macro Spellbook"

-- Page: Layout
L["PAGE_EMPTY"] =
	"Ancora nessuna macro. Visita il tuo istruttore di classe per imparare i tuoi primi incantesimi, oppure aggiungi le tue macro in Opzioni > AddOn > Macro Spellbook > Macro personalizzate."
L["PAGE_MACRO_SLOTS"] = "Spazi per le macro"
L["TOOLTIP_MACRO_SLOTS"] =
	"Ogni macro che piazzi occupa uno spazio per le macro. Gli spazi del personaggio appartengono a questo personaggio e si riempiono per primi. Gli spazi generali sono condivisi da tutti i personaggi del tuo account."
L["PAGE_MACRO_GENERAL"] = "Generali"
L["PAGE_MACRO_CHARACTER"] = "Personaggio"
L["PAGE_FOOTER"] =
	"Clicca o trascina una macro sulle tue barre. Una macro illuminata non è ancora sulle tue barre. Clic destro su una macro per le sue opzioni."

-- Options: General Panel
L["OPTIONS_DESCRIPTION"] =
	"Macro al passaggio del mouse, sul cursore e su te stesso per ogni incantesimo di classe, create con un clic da una nuova scheda del libro degli incantesimi, senza sintassi delle macro. Si aggiornano quando sali di livello, ti addestri o cambi specializzazione. Con il clic destro aggiungi focus, interruzione del lancio, attacco automatico, attacco del famiglio o monili."
L["OPTIONS_ENABLE_WELCOME"] = "Attiva il messaggio di benvenuto"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Mostra in chat un benvenuto di una riga con la versione ogni volta che accedi."
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Assegnazione tasti"
L["OPTIONS_KEY_SET"] = "Assegna tasto"
L["OPTIONS_KEY_SET_DESCRIPTION"] =
	"Apre l'elenco di assegnazione tasti del gioco, dove Macro Spellbook ha una sezione tutta sua."
L["OPTIONS_KEY_BINDING_TOGGLE_DESCRIPTION"] =
	"Apre e chiude Macro Spellbook. Ha anche una scheda tutta sua nel tuo libro degli incantesimi."
L["OPTIONS_COMMANDS_HEADER"] = "/Comandi"
L["OPTIONS_COMMAND"] = "/msb"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Apre l'interfaccia delle opzioni di questo add-on."

-- Options: Spellbook Page Panel
L["TAB_SPELLBOOK_PAGE"] = "Pagina del libro degli incantesimi"
L["OPTIONS_SPELLBOOK_PAGE_DESCRIPTION"] =
	"Come la pagina di Macro Spellbook nel tuo libro degli incantesimi elenca i tuoi incantesimi."
L["OPTIONS_SHOW_UNLEARNED_DESCRIPTION"] =
	"Elenca gli incantesimi di classe che non hai ancora appreso in una sezione Non appresi, così puoi piazzare le loro macro in anticipo."
L["OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION"] =
	"Una macro smette di illuminarsi quando il suo incantesimo è già sulle tue barre, anche se la macro ha opzioni attive."

-- Options: Macro Defaults Panel
L["TAB_MACRO_DEFAULTS"] = "Predefiniti delle macro"
L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"] =
	"Le opzioni con cui parte ogni tipo di macro di incantesimo. Ciò che imposti su una macro dal suo menu del clic destro resta com'è. Ogni tipo elenca solo le opzioni offerte dai suoi incantesimi."
L["OPTIONS_DEFAULT_MOUSEOVER_DESCRIPTION"] = "Lancia prima su chi è sotto il mouse, poi sul tuo bersaglio."
L["OPTIONS_DEFAULT_CAST_ON_SELF_DESCRIPTION"] =
	"Lancia su di te quando il tuo bersaglio non può ricevere l'incantesimo."
L["OPTIONS_DEFAULT_TARGETS_TARGET_DESCRIPTION"] =
	"Prova il bersaglio del tuo bersaglio quando il tuo bersaglio non può ricevere l'incantesimo, come il tank che un nemico sta attaccando."
L["OPTIONS_DEFAULT_CURSOR_DESCRIPTION"] = "Piazza l'incantesimo dove punta il cursore, senza cerchio di selezione."
L["OPTIONS_DEFAULT_DYNAMIC_RANK_DESCRIPTION"] = "Lancia il grado più alto che il livello del giocatore amico consente."
L["OPTIONS_DEFAULT_STOP_CASTING_DESCRIPTION"] =
	"Interrompe prima ciò che stai lanciando, così questo incantesimo parte subito."
L["OPTIONS_DEFAULT_STOP_ATTACK_DESCRIPTION"] = "Ferma prima il tuo attacco automatico in mischia."
L["OPTIONS_DEFAULT_STOP_IF_CHANNELING_DESCRIPTION"] =
	"Non fa nulla mentre canalizzi un incantesimo, così una pressione non interrompe mai la canalizzazione."
L["OPTIONS_DEFAULT_STOP_IF_STEALTHED_DESCRIPTION"] =
	"Non fa nulla mentre sei furtivo, così una pressione non interrompe mai Furtività o Aggirarsi."
L["OPTIONS_DEFAULT_LEAVE_FORM_DESCRIPTION"] =
	"Esce prima dalla tua forma attuale, così l'incantesimo può essere lanciato."
L["OPTIONS_DEFAULT_TARGET_ENEMY_DESCRIPTION"] =
	"Seleziona prima il nemico più vicino quando non hai un nemico vivo come bersaglio."
L["OPTIONS_DEFAULT_TARGET_FRIEND_DESCRIPTION"] =
	"Seleziona prima l'alleato più vicino quando non hai un alleato vivo come bersaglio."
L["OPTIONS_DEFAULT_PET_ATTACK_DESCRIPTION"] = "Manda anche il tuo famiglio ad attaccare il tuo bersaglio."
L["OPTIONS_DEFAULT_START_ATTACK_DESCRIPTION"] = "Avvia il tuo attacco automatico in mischia dopo il lancio."
L["OPTIONS_DEFAULT_AUTO_SHOT_DESCRIPTION"] = "Avvia Tiro automatico o la tua bacchetta dopo il lancio."
L["OPTIONS_DEFAULT_ONCE_PER_TARGET_DESCRIPTION"] = "Lancia una volta, poi non più finché non cambia il tuo bersaglio."
L["OPTIONS_DEFAULT_ONCE_PER_COMBAT_DESCRIPTION"] =
	"Lancia una volta, poi non più finché il combattimento non finisce o il tuo bersaglio non cambia."
L["OPTIONS_DEFAULT_NEVER_TURN_OFF_DESCRIPTION"] =
	"Premere di nuovo la macro lascia attivi la forma o l'aspetto invece di disattivarli."
L["OPTIONS_DEFAULT_HIDE_ERRORS_DESCRIPTION"] = "Cancella il testo di errore rosso che la macro lascia sullo schermo."
L["OPTIONS_DEFAULT_MUTE_ERRORS_DESCRIPTION"] = "Silenzia il suono di errore mentre la macro è in esecuzione."
L["OPTIONS_DEFAULT_COMBAT_CHECK_DESCRIPTION"] =
	"Fa lanciare queste macro solo in combattimento, solo fuori dal combattimento o in entrambi i casi."
L["OPTIONS_KIND_EXAMPLES"] = "I tuoi incantesimi: %s"
L["OPTIONS_KIND_EXAMPLES_MORE"] = "%s e altri %d"
L["KIND_ENEMY"] = "Incantesimi sui nemici"
L["KIND_ENEMY_DESCRIPTION"] = "Incantesimi lanciati su un nemico, come attacchi e penalità."
L["KIND_FRIENDLY"] = "Incantesimi amichevoli"
L["KIND_FRIENDLY_DESCRIPTION"] = "Incantesimi lanciati su un alleato, come le cure."
L["KIND_BUFF"] = "Benefici"
L["KIND_BUFF_DESCRIPTION"] = "Incantesimi che danno a un alleato un beneficio duraturo."
L["KIND_ANYONE"] = "Incantesimi su alleati o nemici"
L["KIND_ANYONE_DESCRIPTION"] = "Incantesimi che puoi lanciare su un alleato o su un nemico."
L["KIND_GROUND"] = "Incantesimi a terra"
L["KIND_GROUND_DESCRIPTION"] = "Incantesimi che posizioni sul terreno."
L["KIND_FORM"] = "Forme, posture e aspetti"
L["KIND_FORM_DESCRIPTION"] = "Incantesimi che restano attivi finché non li spegni o ne scegli un altro."
L["KIND_SELF"] = "Incantesimi personali e ad area"
L["KIND_SELF_DESCRIPTION"] = "Incantesimi senza bersaglio, lanciati su di te o intorno a te."

-- Options: Custom Macros Panel
L["TAB_CUSTOM_MACROS"] = "Macro personalizzate"
L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"] =
	"Le tue macro, elencate nella pagina sotto Personalizzate. Rimuoverne una qui lascia la sua macro in /macro, da eliminare a mano."
L["OPTIONS_CUSTOM_ADD"] = "Aggiungi macro"
L["OPTIONS_CUSTOM_ADD_DESCRIPTION"] = "Aggiunge una nuova macro personalizzata in fondo all'elenco."
L["OPTIONS_CUSTOM_NEW_NAME"] = "Nuova macro"
L["OPTIONS_CUSTOM_NAME"] = "Nome"
L["OPTIONS_CUSTOM_NAME_DESCRIPTION"] = "Il nome della macro, fino a %d caratteri."
L["OPTIONS_CUSTOM_SECTION"] = "Sezione"
L["OPTIONS_CUSTOM_SECTION_DESCRIPTION"] =
	"Dove la macro è elencata nella pagina: sotto Personalizzate, o con gli incantesimi di una delle schede del tuo libro degli incantesimi."
L["OPTIONS_CUSTOM_BODY_DESCRIPTION"] =
	"Il testo della macro, fino a 255 byte. Una prima riga con #showtooltip e il nome di un incantesimo mostra l'icona di quell'incantesimo."
L["OPTIONS_CUSTOM_STATUS_NEEDS"] = "Questa macro ha bisogno di un nome e di un testo prima di apparire nella pagina."
L["OPTIONS_CUSTOM_STATUS_TOO_LONG"] = "Troppo lunga: %d / %d byte. Non apparirà nella pagina finché non ci sta."
L["OPTIONS_CUSTOM_STATUS_TAKEN"] = "Un'altra macro della pagina ha già questo nome, quindi questa non apparirà."
L["OPTIONS_CUSTOM_REMOVE_DESCRIPTION"] = "Rimuove questa macro dall'elenco."
L["OPTIONS_CUSTOM_REMOVE_CONFIRM"] = "Rimuovere questa macro personalizzata?"
L["OPTIONS_CUSTOM_RESTORE"] = "Ripristina predefiniti"
L["OPTIONS_CUSTOM_RESTORE_DESCRIPTION"] =
	"Sostituisce le tue macro personalizzate con quelle con cui parte la tua classe."
L["OPTIONS_CUSTOM_RESTORE_CONFIRM"] =
	"Sostituire tutte le tue macro personalizzate con quelle predefinite della tua classe?"

-- Options: Feedback & Support Panel
L["OPTIONS_LEVEL_UP_TITLE"] = "Aiuta Macro Spellbook a salire di livello"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Questo add-on è stato creato da giocatori che amano questo gioco e vogliono renderlo il più divertente possibile per tutti. Non chiederemo mai donazioni. La vera soddisfazione sta nel sapere che il nostro lavoro rende il gioco un po' migliore per te. Se è così, ci farebbe piacere saperlo!"
L["OPTIONS_LEVEL_UP_WAYS"] = "Ecco alcuni modi per aiutarci a raggiungere più giocatori."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Condividi il tuo parere: Hai trovato un bug o hai un'idea? Faccelo sapere su Discord. Il tuo feedback ci aiuta a migliorare l'add-on, e le pull request sono sempre benvenute."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Dillo a un amico: Conosci qualcuno a cui potrebbe piacere questo add-on? Parlagliene. Il passaparola aiuta più giocatori a scoprire ottimi add-on."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Preferito su CurseForge: Apri il link di CurseForge qui sotto, accedi e clicca sulla stella sotto il pulsante Download. I preferiti aiutano più giocatori a scoprire l'add-on."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Star su GitHub: Apri il link di GitHub qui sotto, accedi e clicca su Star in alto a destra. Le Star aiutano il progetto a ottenere più strumenti gratuiti per sviluppatori."
L["OPTIONS_LEVEL_UP_THANKS"] = "Grazie per aver scelto Macro Spellbook!"

L["OPTIONS_FEEDBACK"] = "Feedback e supporto"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Link per feedback e supporto"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "Per copiare un link, clicca nella sua casella, poi premi Ctrl+A e Ctrl+C."
L["OPTIONS_VERSION"] = "Versione %s"

-- Key Bindings
L["BINDING_TOGGLE_PAGE"] = "Mostra/nascondi Macro Spellbook"

-- Messages
L["CHAT_LOADED"] =
	"Versione %s. Le impostazioni (inclusa l'opzione per disattivare questo messaggio) si trovano in Opzioni > AddOn > Macro Spellbook. Ti piace questo add-on? Dillo a un amico, aggiungilo ai preferiti su CurseForge o dagli una Star su GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] =
	"Per sicurezza, l'interfaccia delle opzioni non può essere aperta durante il combattimento."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] =
	"Per sicurezza, l'elenco di assegnazione tasti non può essere aperto durante il combattimento."
L["KEY_BINDINGS_LOCATION"] = "Apri il menu di gioco, poi %s, poi %s, e cerca la sezione Macro Spellbook."
L["ERROR_MACRO_SLOTS_FULL"] = "Nessuno spazio libero per le macro. Elimina una macro in /macro per fare spazio."
L["ERROR_GENERAL_MACRO_SLOTS_FULL"] =
	"Nessuno spazio libero per le macro generali. Elimina una macro generale in /macro per fare spazio."
L["CHAT_MACRO_TOO_LONG"] =
	'La macro "%s" è di %d byte con le sue opzioni attive, oltre i %d che una macro può contenere. Disattiva un\'opzione per accorciarla.'
L["CHAT_CUSTOM_NEEDS_NAME_BODY"] =
	"La macro personalizzata n. %d ha bisogno di un nome e di un testo prima di apparire nella pagina."
L["CHAT_CUSTOM_TOO_LONG"] =
	'La macro personalizzata "%s" è di %d byte, oltre i %d che una macro può contenere. Accorcia il suo testo per aggiungerla alla pagina.'
L["CHAT_CUSTOM_NAME_TAKEN"] =
	'La macro personalizzata "%s" ha lo stesso nome (i primi %d caratteri) di un\'altra macro della pagina. Rinominala per aggiungerla alla pagina.'
