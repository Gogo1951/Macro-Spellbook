local L = LibStub("AceLocale-3.0"):NewLocale("MacroSpellbook", "frFR")
if not L then
	return
end

-- Add-on Names
L["ADDON_TITLE"] = "Macro Spellbook"
L["ADDON_SHORT_NAME"] = "Macro Spellbook"

-- Page: Sections
L["SECTION_UNLEARNED"] = "Non apprises"
L["SECTION_CUSTOM"] = "Personnalisées"
L["SECTION_EQUIPMENT"] = "Équipement"

-- Page: Default Custom Macros
-- TRANSLATORS: each name becomes a WoW macro name, cut to 16 bytes (about 5 Chinese or Korean characters), so keep it short.
L["CUSTOM_SPAM_WAND"] = "Baguette auto"
L["CUSTOM_PET_ABILITY"] = "Sort du familier"
L["CUSTOM_PET_ABILITY_MOUSEOVER"] = "Familier survol"
L["CUSTOM_SWIFT_JUDGE"] = "Jugement rapide"

-- Page: Macro Menu
L["MENU_GROUP_COMBAT_CHECK"] = "Condition de combat"
L["MENU_GROUP_SPELL_RANK"] = "Rang du sort"
L["MENU_GROUP_TARGETING"] = "Ciblage"
L["MENU_GROUP_BEFORE_CAST"] = "Avant l'incantation"
L["MENU_GROUP_ADD_ATTACK"] = "Ajouter une attaque"
L["MENU_GROUP_CASTING_RULES"] = "Règles d'incantation"
L["MENU_GROUP_ERRORS"] = "Messages d'erreur"
L["MENU_GROUP_USE_ITEMS_FIRST"] = "Utiliser d'abord des objets"
L["MACRO_TEXT"] = "Texte de la macro"
L["MENU_MACRO_LENGTH"] = "%d / %d"
L["MENU_OPTIONS_COUNT"] = "%d options"
L["MENU_RANK_LEARN_LEVEL"] = "%s (Niveau %d)"
L["MENU_MAX_RANK"] = "Rang maximum"
L["MENU_DYNAMIC_RANK"] = "Rang dynamique"
L["MENU_DYNAMIC_RANK_NOTE"] =
	"Le rang dynamique, basé sur le niveau d'un joueur allié, ne se met à jour qu'hors combat."
L["MENU_CAST_AT_CURSOR"] = "Lancer au curseur"
L["MENU_TARGET_NEAREST_ENEMY"] = "Cibler l'ennemi le plus proche"
L["MENU_TARGET_NEAREST_FRIEND"] = "Cibler l'allié le plus proche"
L["MENU_CAST_IF_SUMMONED"] = "Lancer %s s'il est invoqué"
L["MENU_NEVER_TURN_OFF"] = "Ne jamais désactiver"
L["MENU_LEAVE_FORM_BEFORE"] = "Quitter la forme avant de lancer"
L["MENU_RIGHT_CLICK_FOR"] = "Clic droit pour %s"
L["MENU_ONLY_IN_COMBAT"] = "Seulement en combat"
L["MENU_NEVER_IN_COMBAT"] = "Jamais en combat"
L["MENU_COMBAT_CHECK_NONE"] = "Aucune"
L["MENU_ONCE_PER_COMBAT"] = "Lancer une fois par combat"
L["MENU_ONCE_PER_TARGET"] = "Lancer une fois par cible"
L["MENU_HIDE_ERRORS"] = "Masquer les messages d'erreur"
L["MENU_MUTE_ERRORS"] = "Couper les sons d'erreur"
L["MENU_SWITCH_TO"] = "Passer en %s"
L["MENU_CAST_ON_FOCUS"] = "Lancer sur la focalisation"
L["MENU_START_AUTO_ATTACK"] = "Lancer l'attaque automatique"
L["MENU_STOP_ATTACK"] = "Arrêter l'attaque"
L["MENU_START_AUTO_SHOT"] = "Lancer le tir automatique"
L["MENU_START_PET_ATTACK"] = "Lancer l'attaque du familier"
L["MENU_START_WAND"] = "Lancer la baguette"
L["MENU_STOP_CASTING"] = "Interrompre l'incantation"
L["MENU_STOP_CASTING_NOTE"] =
	"Utilisez Interrompre l'incantation pour les sorts qui ne peuvent pas attendre, comme les interruptions et les dissipations."
L["MENU_STOP_IF_CHANNELING"] = "Arrêter la macro en canalisation"
L["MENU_STOP_IF_STEALTHED"] = "Arrêter la macro en camouflage"
L["MENU_SAFE_TO_SPAM_NOTE"] =
	"Pour pouvoir marteler une macro sans risque, activez Arrêter la macro en canalisation pour un sort canalisé, ou Arrêter la macro en camouflage pour Camouflage ou Rôder. Appuyer de nouveau ne rompra alors ni la canalisation ni votre camouflage."
L["MENU_USE_FOR_KIND"] = "Utiliser ces options pour la catégorie %s"
L["MENU_DUPLICATE"] = "Dupliquer"
L["MENU_USE_FOR_KIND_DESCRIPTION"] =
	"Chaque macro de la catégorie %s que vous n'avez pas réglée vous-même commence avec les options de cette macro. Ouvre Réglages par défaut des macros pour vous le montrer."

-- Page: Settings Menu
L["SETTINGS_SHOW_UNLEARNED"] = "Afficher les sorts non appris"
L["SETTINGS_COUNT_SPELLS_ON_BARS"] = "Compter les sorts des barres comme placés"
L["SETTINGS_MARK_ALL_PLACED"] = "Marquer tous les sorts comme placés"
L["SETTINGS_MARK_ALL_PLACED_DESCRIPTION"] =
	"Plus aucune macro de cette page ne brille, qu'elle soit sur vos barres ou non. Un sort appris plus tard brille tant que vous ne l'avez pas placé."
L["SETTINGS_OPEN_MACRO_DEFAULTS_DESCRIPTION"] =
	"Ouvre l'interface des options à Réglages par défaut des macros, où vous choisissez les options de départ de chaque type de macro de sort."
L["SETTINGS_OPEN_CUSTOM_MACROS_DESCRIPTION"] =
	"Ouvre l'interface des options à Macros personnalisées, où vous écrivez vos propres macros pour cette page."

-- Page: Macro Buttons
-- TRANSLATORS: each note fills the small slot under a macro button, so keep it short.
L["SUBTEXT_CUSTOM"] = "Perso"
L["SUBTEXT_FOCUS"] = "Focalisation"
L["SUBTEXT_PET"] = "Familier"
L["SUBTEXT_CURSOR"] = "Curseur"
L["SUBTEXT_STANCE"] = "Posture"
L["SUBTEXT_USE_ITEMS"] = "Objets"
L["SUBTEXT_PET_ATTACK"] = "Attaque familier"
L["SUBTEXT_DYNAMIC_RANK"] = "Rang dyn."
L["SUBTEXT_TARGET_ENEMY"] = "Ennemi proche"
L["SUBTEXT_TARGET_FRIEND"] = "Allié proche"
L["SUBTEXT_GROUP_VERSION"] = "Version groupe"
L["SUBTEXT_ONCE_PER_COMBAT"] = "1x par combat"
L["SUBTEXT_ONCE_PER_TARGET"] = "1x par cible"
L["SUBTEXT_COMBAT_ONLY"] = "En combat"
L["SUBTEXT_NO_COMBAT"] = "Hors combat"
L["SUBTEXT_LEAVE_FORM"] = "Quitte la forme"
L["SUBTEXT_NO_TOGGLE"] = "Reste actif"
L["SUBTEXT_WAND"] = "Baguette"
L["SUBTEXT_START_ATTACK"] = "Attaque auto"
L["SUBTEXT_STOP_ATTACK"] = "Stop attaque"
L["SUBTEXT_STOP_CASTING"] = "Interrompt"
L["SUBTEXT_STOP_IF_CHANNELING"] = "Pas en canalisation"
L["SUBTEXT_STOP_IF_STEALTHED"] = "Pas en camouflage"
L["SUBTEXT_HIDE_ERRORS"] = "Sans erreurs"
L["SUBTEXT_MUTE_ERRORS"] = "Erreurs muettes"
L["SUBTEXT_OPTIONS_COUNT"] = "%d options"
L["SUBTEXT_TOO_LONG"] = "Trop longue"
L["SUBTEXT_LEARN_LEVEL"] = "Niveau %d"
L["SUBTEXT_TALENT"] = "Talent"

-- Page: Macro Tooltip
L["TOOLTIP_NOT_LEARNED"] = "Pas encore appris"
L["TOOLTIP_LEARN_LEVEL"] = "Votre maître de classe l'enseigne au niveau %d."
L["TOOLTIP_LEARN_TALENT"] = "S'apprend avec vos talents."
L["TOOLTIP_NOT_ON_BARS"] = "Pas sur vos barres d'action"
L["TOOLTIP_TOO_LONG"] = "Trop longue : %d / %d octets. Désactivez une option pour la raccourcir."
L["TOOLTIP_OPTIONS_ON"] = "Options activées : %s"
L["TOOLTIP_EQUIPMENT_SLOT"] =
	"Utilise ce que vous portez à l'emplacement %s, donc elle fonctionne toujours quand vous changez d'équipement."
L["TOOLTIP_KEY_CLICK_DRAG"] = "Clic ou glisser"
L["TOOLTIP_ACTION_PLACE_ON_BAR"] = "Placer sur vos barres d'action"
L["TOOLTIP_KEY_RIGHT_CLICK"] = "Clic droit"
L["TOOLTIP_ACTION_MACRO_OPTIONS"] = "Options de la macro"

-- Spellbook Tab Tooltip
L["SPELLBOOK_TAB_DESCRIPTION"] = "Les sorts de votre classe en macros à un clic."
L["TOOLTIP_KEY_CLICK"] = "Clic"
L["TOOLTIP_ACTION_OPEN_PAGE"] = "Ouvrir Macro Spellbook"

-- Page: Layout
L["PAGE_EMPTY"] =
	"Pas encore de macros. Rendez visite à votre maître de classe pour apprendre vos premiers sorts, ou ajoutez vos propres macros dans Options > AddOns > Macro Spellbook > Macros personnalisées."
L["PAGE_MACRO_SLOTS"] = "Emplacements de macros"
L["TOOLTIP_MACRO_SLOTS"] =
	"Chaque macro que vous placez occupe un emplacement de macro. Les emplacements de personnage appartiennent à ce personnage et se remplissent en premier. Les emplacements généraux sont partagés par tous les personnages de votre compte."
L["PAGE_MACRO_GENERAL"] = "Générales"
L["PAGE_MACRO_CHARACTER"] = "Personnage"
L["PAGE_FOOTER"] =
	"Cliquez sur une macro ou glissez-la sur vos barres. Une macro qui brille n'est pas encore sur vos barres. Clic droit sur une macro pour ses options."

-- Options: General Panel
L["OPTIONS_DESCRIPTION"] =
	"Macros au survol, au curseur et sur soi pour chaque sort de classe, créées en un clic depuis un nouvel onglet du grimoire, sans syntaxe de macro. Elles se mettent à jour quand vous montez de niveau, vous entraînez ou changez de spécialisation. Un clic droit ajoute la focalisation, l'interruption de l'incantation, l'attaque automatique, l'attaque du familier ou les bijoux."
L["OPTIONS_ENABLE_WELCOME"] = "Activer le message de bienvenue"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Affiche dans le chat un message de bienvenue d'une ligne avec la version à chaque connexion."
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Raccourcis clavier"
L["OPTIONS_KEY_SET"] = "Définir la touche"
L["OPTIONS_KEY_SET_DESCRIPTION"] =
	"Ouvre la liste des raccourcis clavier du jeu, où Macro Spellbook a sa propre section."
L["OPTIONS_KEY_BINDING_TOGGLE_DESCRIPTION"] =
	"Ouvre et ferme Macro Spellbook. Il a aussi son propre onglet dans votre grimoire."
L["OPTIONS_DELETE_MACROS_HEADER"] = "Supprimer les macros"
L["OPTIONS_DELETE_MACROS_DESCRIPTION"] =
	"Supprime les macros créées par Macro Spellbook, ce qui les retire aussi de vos barres d'action. Vos propres macros ne sont jamais touchées, et la page recrée chacune d'elles quand vous cliquez dessus ou la faites glisser."
L["OPTIONS_DELETE_CHARACTER_MACROS"] = "Supprimer les macros du personnage"
L["OPTIONS_DELETE_CHARACTER_MACROS_DESCRIPTION"] =
	"Supprime les macros de Macro Spellbook de l'onglet de macros de ce personnage. Vos autres personnages gardent les leurs jusqu'à ce que vous fassiez de même sur eux."
L["OPTIONS_DELETE_CHARACTER_MACROS_CONFIRM"] =
	"Supprimer toutes les macros de Macro Spellbook de ce personnage ? Elles sont aussi retirées de vos barres d'action."
L["OPTIONS_DELETE_GENERAL_MACROS"] = "Supprimer les macros générales"
L["OPTIONS_DELETE_GENERAL_MACROS_DESCRIPTION"] =
	"Supprime les macros de Macro Spellbook de l'onglet Macros générales, partagé par tous les personnages de votre compte : vos autres personnages y perdent donc aussi les leurs."
L["OPTIONS_DELETE_GENERAL_MACROS_CONFIRM"] =
	"Supprimer toutes les macros générales de Macro Spellbook ? Tous les personnages de votre compte les perdent, et elles sont aussi retirées de vos barres d'action."
L["OPTIONS_COMMANDS_HEADER"] = "/Commandes"
L["OPTIONS_COMMAND"] = "/msb"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Ouvre l'interface des options de cet add-on."

-- Options: Spellbook Page Panel
L["TAB_SPELLBOOK_PAGE"] = "Page du grimoire"
L["OPTIONS_SPELLBOOK_PAGE_DESCRIPTION"] = "Comment la page Macro Spellbook de votre grimoire liste vos sorts."
L["OPTIONS_SHOW_UNLEARNED_DESCRIPTION"] =
	"Liste les sorts de classe que vous n'avez pas encore appris dans une section Non apprises, pour placer leurs macros à l'avance."
L["OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION"] =
	"Une macro cesse de briller quand son sort est déjà sur vos barres, même si la macro a des options activées."

-- Options: Macro Defaults Panel
L["TAB_MACRO_DEFAULTS"] = "Réglages par défaut des macros"
L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"] =
	"Les options avec lesquelles commence chaque type de macro : vos macros d'objets ici, et chaque type de macro de sort sur sa propre page en dessous. Ce que vous réglez sur une macro depuis son menu clic droit est conservé."
L["OPTIONS_DEFAULT_CURSOR_DESCRIPTION"] = "Place le sort là où pointe votre curseur, sans cercle de ciblage."
L["OPTIONS_DEFAULT_DYNAMIC_RANK_DESCRIPTION"] = "Lance le rang le plus élevé que permet le niveau du joueur allié."
L["OPTIONS_DEFAULT_STOP_CASTING_DESCRIPTION"] =
	"Interrompt d'abord ce que vous incantez, pour que ce sort parte aussitôt."
L["OPTIONS_DEFAULT_STOP_ATTACK_DESCRIPTION"] = "Arrête d'abord votre attaque automatique de mêlée."
L["OPTIONS_DEFAULT_STOP_IF_CHANNELING_DESCRIPTION"] =
	"Ne fait rien pendant que vous canalisez un sort, donc un appui ne rompt jamais la canalisation."
L["OPTIONS_DEFAULT_STOP_IF_STEALTHED_DESCRIPTION"] =
	"Ne fait rien pendant que vous êtes camouflé, donc un appui ne rompt jamais Camouflage ou Rôder."
L["OPTIONS_DEFAULT_LEAVE_FORM_DESCRIPTION"] =
	"Quitte d'abord votre forme actuelle, pour que le sort puisse être lancé."
L["OPTIONS_DEFAULT_TARGET_ENEMY_DESCRIPTION"] =
	"Cible d'abord l'ennemi le plus proche quand vous n'avez aucun ennemi vivant en cible."
L["OPTIONS_DEFAULT_TARGET_FRIEND_DESCRIPTION"] =
	"Cible d'abord l'allié le plus proche quand vous n'avez aucun allié vivant en cible."
L["OPTIONS_DEFAULT_PET_ATTACK_DESCRIPTION"] = "Envoie aussi votre familier attaquer votre cible."
L["OPTIONS_DEFAULT_START_ATTACK_DESCRIPTION"] = "Lance votre attaque automatique de mêlée après l'incantation."
L["OPTIONS_DEFAULT_AUTO_SHOT_DESCRIPTION"] = "Lance Tir automatique ou votre baguette après l'incantation."
L["OPTIONS_DEFAULT_ONCE_PER_TARGET_DESCRIPTION"] = "Lance une fois, puis plus avant que votre cible change."
L["OPTIONS_DEFAULT_ONCE_PER_COMBAT_DESCRIPTION"] =
	"Lance une fois, puis plus avant la fin du combat ou un changement de cible."
L["OPTIONS_DEFAULT_NEVER_TURN_OFF_DESCRIPTION"] =
	"Garde la forme ou l'aspect actif quand vous appuyez de nouveau sur la macro, au lieu de le désactiver."
L["OPTIONS_DEFAULT_HIDE_ERRORS_DESCRIPTION"] = "Efface le texte d'erreur rouge que la macro laisse à l'écran."
L["OPTIONS_DEFAULT_MUTE_ERRORS_DESCRIPTION"] = "Coupe le son d'erreur pendant que la macro s'exécute."
L["OPTIONS_DEFAULT_COMBAT_CHECK_DESCRIPTION"] =
	"Permet à ces macros de lancer seulement en combat, seulement hors combat, ou les deux."
L["OPTIONS_KIND_YOUR_SPELLS"] = "Vos sorts"
L["OPTIONS_KIND_YOUR_ITEMS"] = "Vos objets"
L["OPTIONS_KIND_MORE"] = "Et %d autres."
L["OPTIONS_KIND_NO_SPELLS"] = "Aucun de vos sorts n'est de ce type."
L["OPTIONS_KIND_NO_ITEMS"] = "Aucun de vos objets équipés n'a d'effet Utiliser."
L["KIND_ENEMY"] = "Sorts offensifs"
L["KIND_ENEMY_DESCRIPTION"] = "Les sorts lancés sur un ennemi, comme vos attaques et affaiblissements."
L["KIND_FRIENDLY"] = "Sorts amicaux"
L["KIND_FRIENDLY_DESCRIPTION"] = "Les sorts lancés sur un allié, comme vos soins."
L["KIND_BUFF"] = "Améliorations"
L["KIND_BUFF_DESCRIPTION"] = "Les sorts qui donnent à un allié une amélioration durable."
L["KIND_ANYONE"] = "Sorts pour allié ou ennemi"
L["KIND_ANYONE_DESCRIPTION"] = "Les sorts qui peuvent viser un allié ou un ennemi."
L["KIND_GROUND"] = "Sorts ciblés au sol"
L["KIND_GROUND_DESCRIPTION"] = "Les sorts que vous placez au sol."
L["KIND_FORM"] = "Formes, postures et aspects"
L["KIND_FORM_DESCRIPTION"] = "Les sorts qui restent actifs jusqu'à ce que vous les coupiez ou en changiez."
L["KIND_SELF"] = "Sorts personnels et de zone"
L["KIND_SELF_DESCRIPTION"] = "Les sorts sans cible, lancés sur vous ou autour de vous."
L["KIND_ITEM"] = "Macros d'objets"
L["KIND_ITEM_DESCRIPTION"] = "Les macros qui utilisent vos objets équipés, comme les bijoux."

-- Options: Custom Macros Panel
L["TAB_CUSTOM_MACROS"] = "Macros personnalisées"
L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"] =
	"Vos propres macros, listées sur la page sous Personnalisées. En retirer une ici laisse sa macro dans /macro, à vous de la supprimer."
L["OPTIONS_CUSTOM_ADD"] = "Ajouter une macro"
L["OPTIONS_CUSTOM_ADD_DESCRIPTION"] = "Ajoute une nouvelle macro personnalisée à la fin de la liste."
L["OPTIONS_CUSTOM_NEW_NAME"] = "Nouvelle macro"
L["OPTIONS_CUSTOM_NAME"] = "Nom"
L["OPTIONS_CUSTOM_NAME_DESCRIPTION"] =
	"Le nom de la macro. WoW en garde les %d premiers octets, soit moins de lettres dans des langues comme le russe, le chinois ou le coréen."
L["OPTIONS_CUSTOM_SECTION"] = "Rubrique"
L["OPTIONS_CUSTOM_SECTION_DESCRIPTION"] =
	"Où la macro est listée sur la page : sous Personnalisées, ou avec les sorts de l'un des onglets de votre grimoire."
L["OPTIONS_CUSTOM_BODY_DESCRIPTION"] =
	"Le texte de la macro, jusqu'à %d octets. Une première ligne avec #showtooltip et un nom de sort affiche l'icône de ce sort."
L["OPTIONS_CUSTOM_STATUS_NEEDS"] = "Cette macro a besoin d'un nom et d'un texte avant d'apparaître sur la page."
L["OPTIONS_CUSTOM_STATUS_TOO_LONG"] =
	"Trop longue : %d / %d octets. Elle n'apparaîtra pas sur la page tant qu'elle ne tiendra pas."
L["OPTIONS_CUSTOM_STATUS_TAKEN"] = "Une autre macro de la page porte déjà ce nom, donc celle-ci n'apparaîtra pas."
L["OPTIONS_CUSTOM_REMOVE_DESCRIPTION"] = "Retire cette macro de la liste."
L["OPTIONS_CUSTOM_REMOVE_CONFIRM"] = "Retirer cette macro personnalisée ?"
L["OPTIONS_CUSTOM_RESTORE"] = "Rétablir les réglages par défaut"
L["OPTIONS_CUSTOM_RESTORE_DESCRIPTION"] =
	"Remplace vos macros personnalisées par celles que votre classe a au départ."
L["OPTIONS_CUSTOM_RESTORE_CONFIRM"] =
	"Remplacer toutes vos macros personnalisées par celles par défaut de votre classe ?"

-- Options: Feedback & Support Panel
L["OPTIONS_LEVEL_UP_TITLE"] = "Aidez Macro Spellbook à monter de niveau"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Cet add-on a été créé par des joueurs qui adorent ce jeu et veulent le rendre aussi amusant que possible pour tous. Nous ne demanderons jamais de dons. La vraie satisfaction, c'est de savoir que notre travail rend le jeu un peu meilleur pour vous. Si c'est le cas, nous serions ravis de l'apprendre !"
L["OPTIONS_LEVEL_UP_WAYS"] = "Voici quelques façons de nous aider à toucher plus de joueurs."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Donnez votre avis : Vous avez trouvé un bug ou une idée ? Dites-le-nous sur Discord. Vos retours nous aident à améliorer l'add-on, et les pull requests sont toujours les bienvenues."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Parlez-en à un ami : Vous connaissez quelqu'un qui pourrait aimer cet add-on ? Parlez-lui-en. Le bouche-à-oreille aide plus de joueurs à découvrir de super add-ons."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Favori sur CurseForge : Ouvrez le lien CurseForge ci-dessous, connectez-vous et cliquez sur l'étoile sous le bouton Download. Les favoris aident plus de joueurs à découvrir l'add-on."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Star sur GitHub : Ouvrez le lien GitHub ci-dessous, connectez-vous et cliquez sur Star en haut à droite. Les Stars aident le projet à obtenir plus d'outils gratuits pour développeurs."
L["OPTIONS_LEVEL_UP_THANKS"] = "Merci d'avoir choisi Macro Spellbook !"

L["OPTIONS_FEEDBACK"] = "Commentaires et assistance"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Liens de commentaires et d'assistance"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "Pour copier un lien, cliquez dans son champ, puis appuyez sur Ctrl+A et Ctrl+C."
L["OPTIONS_VERSION"] = "Version %s"

-- Key Bindings
L["BINDING_TOGGLE_PAGE"] = "Afficher/masquer Macro Spellbook"

-- Messages
L["CHAT_LOADED"] =
	"Version %s. Les réglages (dont l'option pour désactiver ce message) se trouvent dans Options > AddOns > Macro Spellbook. Vous aimez cet add-on ? Parlez-en à un ami, mettez-le en favori sur CurseForge ou donnez-lui une Star sur GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Par mesure de sécurité, l'interface des options ne peut pas être ouverte en combat."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] =
	"Par mesure de sécurité, la liste des raccourcis clavier ne peut pas être ouverte en combat."
L["KEY_BINDINGS_LOCATION"] = "Ouvrez le menu du jeu, puis %s, puis %s, et cherchez la section Macro Spellbook."
L["ERROR_MACRO_SLOTS_FULL"] =
	"Aucun emplacement de macro libre. Supprimez une macro dans /macro pour faire de la place."
L["ERROR_GENERAL_MACRO_SLOTS_FULL"] =
	"Aucun emplacement de macro générale libre. Supprimez une macro générale dans /macro pour faire de la place."
L["CHAT_MACROS_DELETED"] = "Macros supprimées : %d"
L["CHAT_MACRO_TOO_LONG"] =
	'La macro "%s" fait %d octets avec ses options activées, au-delà des %d qu\'une macro peut contenir. Désactivez une option pour la raccourcir.'
L["CHAT_CUSTOM_NEEDS_NAME_BODY"] =
	"La macro personnalisée n° %d a besoin d'un nom et d'un texte avant d'apparaître sur la page."
L["CHAT_CUSTOM_TOO_LONG"] =
	"La macro personnalisée \"%s\" fait %d octets, au-delà des %d qu'une macro peut contenir. Raccourcissez son texte pour l'ajouter à la page."
L["CHAT_CUSTOM_NAME_TAKEN"] =
	'La macro personnalisée "%s" partage son nom (les %d premiers octets) avec une autre macro de la page. Renommez-la pour l\'ajouter à la page.'
