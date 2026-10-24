local L = LibStub("AceLocale-3.0"):NewLocale("MacroSpellbook", "esES")
if not L then
	return
end

-- Add-on Names
L["ADDON_TITLE"] = "Macro Spellbook"
L["ADDON_SHORT_NAME"] = "Macro Spellbook"

-- Page: Sections
L["SECTION_UNLEARNED"] = "Sin aprender"
L["SECTION_CUSTOM"] = "Personalizadas"
L["SECTION_EQUIPMENT"] = "Equipo"

-- Page: Default Custom Macros
L["CUSTOM_SPAM_WAND"] = "Varita en bucle"
L["CUSTOM_PET_ABILITY"] = "Poder de mascota"
L["CUSTOM_PET_ABILITY_MOUSEOVER"] = "Mascota (ratón)"
L["CUSTOM_SWIFT_JUDGE"] = "Juicio rápido"

-- Page: Macro Menu
L["MENU_GROUP_COMBAT_CHECK"] = "Condición de combate"
L["MENU_GROUP_ABILITY_RANK"] = "Rango del hechizo"
L["MENU_GROUP_TARGETING"] = "Selección de objetivo"
L["MENU_GROUP_BEFORE_CAST"] = "Antes de lanzar"
L["MENU_GROUP_AFTER_CAST"] = "Después de lanzar"
L["MENU_GROUP_CASTING_RULES"] = "Reglas de lanzamiento"
L["MENU_GROUP_ERRORS"] = "Mensajes de error"
L["MENU_GROUP_USE_ITEMS_FIRST"] = "Usar objetos primero"
L["MENU_MACRO_TEXT"] = "Texto de la macro"
L["MENU_MACRO_LENGTH"] = "%d / %d"
L["MENU_GROUP_VALUE"] = "%s: %s"
L["MENU_OPTIONS_COUNT"] = "%d opciones"
L["MENU_CAST_ON_MOUSEOVER"] = "Lanzar al pasar el ratón"
L["MENU_CAST_ON_SELF"] = "Lanzar sobre ti"
L["MENU_CAST_ON_TARGETS_TARGET"] = "Lanzar sobre el objetivo del objetivo"
L["MENU_MAX_RANK"] = "Rango máximo"
L["MENU_DYNAMIC_RANK"] = "Rango dinámico"
L["MENU_DYNAMIC_RANK_NOTE"] =
	"El rango dinámico, basado en el nivel de un jugador amistoso, solo se actualiza fuera de combate."
L["MENU_CAST_AT_CURSOR"] = "Lanzar en el cursor"
L["MENU_TARGET_NEAREST_ENEMY"] = "Seleccionar el enemigo más cercano"
L["MENU_CAST_IF_SUMMONED"] = "Lanzar %s si está invocado"
L["MENU_DOWNRANK_IN_RAIDS"] = "Rango 1 en bandas"
L["MENU_NEVER_TURN_OFF"] = "No desactivar nunca"
L["MENU_NEVER_TURN_OFF_NOTE"] =
	"No desactivar nunca mantiene la facultad activa cuando vuelves a pulsar la macro, en lugar de desactivarla."
L["MENU_LEAVE_FORM_BEFORE"] = "Salir de la forma antes de lanzar"
L["MENU_RIGHT_CLICK_FOR"] = "Clic derecho para %s"
L["MENU_ONLY_IN_COMBAT"] = "Solo en combate"
L["MENU_NEVER_IN_COMBAT"] = "Nunca en combate"
L["MENU_COMBAT_CHECK_NONE"] = "Ninguna"
L["MENU_ONCE_PER_COMBAT"] = "Lanzar una vez por combate"
L["MENU_ONCE_PER_TARGET"] = "Lanzar una vez por objetivo"
L["MENU_HIDE_ERRORS"] = "Ocultar mensajes de error"
L["MENU_MUTE_ERRORS"] = "Silenciar sonidos de error"
L["MENU_SPAMMABLE"] = "Repetible"
L["MENU_SWITCH_TO"] = "Cambiar a %s"
L["MENU_CAST_ON_FOCUS"] = "Lanzar sobre el foco"
L["MENU_ENABLE_PET_ATTACK"] = "Activar ataque de mascota"
L["MENU_START_AUTO_ATTACK"] = "Iniciar ataque automático"
L["MENU_STOP_ATTACK"] = "Detener ataque"
L["MENU_START_AUTO_SHOT"] = "Iniciar disparo automático"
L["MENU_START_WAND"] = "Iniciar varita"
L["MENU_STOP_CASTING"] = "Detener lanzamiento"
L["MENU_STOP_CASTING_NOTE"] =
	"Usa Detener lanzamiento en hechizos que no pueden esperar, como interrupciones y disipaciones."

-- Page: Settings Menu
L["SETTINGS_SHOW_UNLEARNED"] = "Mostrar hechizos sin aprender"
L["SETTINGS_COUNT_SPELLS_ON_BARS"] = "Contar hechizos en barras como colocados"
L["SETTINGS_MARK_ALL_PLACED"] = "Marcar todos los hechizos como colocados"
L["SETTINGS_MARK_ALL_PLACED_DESCRIPTION"] =
	"Ninguna macro de esta página vuelve a brillar, esté donde esté. Un hechizo que aprendas después seguirá brillando hasta que lo coloques."
L["SETTINGS_CLEAR_PLACED"] = "Borrar marcas de colocado"
L["SETTINGS_CLEAR_PLACED_DESCRIPTION"] = "Vuelve a hacer brillar cada macro marcada que no esté en tus barras."
L["SETTINGS_OPEN_OPTIONS"] = "Abrir opciones"
L["SETTINGS_OPEN_OPTIONS_DESCRIPTION"] =
	"Abre Macro Spellbook en la interfaz de opciones, donde están tus macros personalizadas."

-- Page: Macro Buttons
-- TRANSLATORS: each note fills the small slot under a macro button, so keep it short.
L["SUBTEXT_CUSTOM"] = "Personal"
L["SUBTEXT_FOCUS"] = "Foco"
L["SUBTEXT_PET"] = "Mascota"
L["SUBTEXT_CURSOR"] = "En cursor"
L["SUBTEXT_MOUSEOVER"] = "Con ratón"
L["SUBTEXT_CAST_ON_SELF"] = "Sobre ti"
L["SUBTEXT_STANCE"] = "Actitud"
L["SUBTEXT_USE_ITEMS"] = "Usar objetos"
L["SUBTEXT_PET_ATTACK"] = "Ataque mascota"
L["SUBTEXT_RAID_RANK_1"] = "Banda R1"
L["SUBTEXT_SPAMMABLE"] = "Repetible"
L["SUBTEXT_DYNAMIC_RANK"] = "Rango dinám."
L["SUBTEXT_TARGETS_TARGET"] = "Obj. del obj."
L["SUBTEXT_TARGET_ENEMY"] = "Enemigo cercano"
L["SUBTEXT_GROUP_VERSION"] = "Versión grupal"
L["SUBTEXT_ONCE_PER_COMBAT"] = "1 por combate"
L["SUBTEXT_ONCE_PER_TARGET"] = "1 por objetivo"
L["SUBTEXT_COMBAT_ONLY"] = "Solo combate"
L["SUBTEXT_NO_COMBAT"] = "Fuera de combate"
L["SUBTEXT_LEAVE_FORM"] = "Salir de forma"
L["SUBTEXT_NO_TOGGLE"] = "Siempre activo"
L["SUBTEXT_WAND"] = "Varita"
L["SUBTEXT_START_ATTACK"] = "Ataque auto."
L["SUBTEXT_STOP_ATTACK"] = "Detener ataque"
L["SUBTEXT_STOP_CASTING"] = "Detener lanz."
L["SUBTEXT_HIDE_ERRORS"] = "Sin errores"
L["SUBTEXT_MUTE_ERRORS"] = "Errores mudos"
L["SUBTEXT_OPTIONS_COUNT"] = "%d opciones"
L["SUBTEXT_TOO_LONG"] = "Muy larga"
L["SUBTEXT_NAME_TAKEN"] = "Nombre en uso"

-- Page: Macro Tooltip
L["TOOLTIP_NOT_LEARNED"] = "Aún sin aprender"
L["TOOLTIP_NOT_ON_BARS"] = "No está en tus barras de acción"
L["TOOLTIP_TOO_LONG"] = "Demasiado larga: %d / %d bytes. Desactiva una opción para acortarla."
L["TOOLTIP_NAME_TAKEN"] = 'Ya tienes una macro llamada "%s". Cámbiale el nombre o bórrala en /macro para usar esta.'
L["TOOLTIP_KEY_CLICK_DRAG"] = "Clic o arrastrar"
L["TOOLTIP_ACTION_PLACE_ON_BAR"] = "Colocar en tus barras de acción"
L["TOOLTIP_KEY_RIGHT_CLICK"] = "Clic derecho"
L["TOOLTIP_ACTION_MACRO_OPTIONS"] = "Opciones de la macro"

-- Spellbook Tab Tooltip
L["SPELLBOOK_TAB_DESCRIPTION"] = "Los hechizos de tu clase como macros de un clic."
L["TOOLTIP_KEY_CLICK"] = "Clic"
L["TOOLTIP_ACTION_OPEN_PAGE"] = "Abrir Macro Spellbook"

-- Page: Layout
L["PAGE_EMPTY"] =
	"Aún no hay macros. Visita a tu instructor de clase para aprender tus primeros hechizos o añade tus propias macros en Opciones > Accesorios > Macro Spellbook > Macros personalizadas."
L["PAGE_MACRO_SLOTS"] = "Espacios de macros"
L["PAGE_MACRO_GENERAL"] = "Generales"
L["PAGE_MACRO_CHARACTER"] = "Personaje"
L["PAGE_FOOTER"] =
	"Haz clic en una macro o arrástrala a tus barras. Una macro que brilla aún no está en tus barras. Haz clic derecho en una macro para ver sus opciones."

-- Options: General Panel
L["OPTIONS_DESCRIPTION"] =
	"Macros al pasar el ratón, lanzamiento en el cursor y macros sobre ti para cada hechizo de clase, creadas con un clic desde una nueva pestaña del libro de hechizos, sin sintaxis de macros. Con clic derecho añades foco, rango del hechizo, rango inferior, detener lanzamiento, ataque automático, ataque de mascota o uso de abalorios."
L["OPTIONS_ENABLE_WELCOME"] = "Activar mensaje de bienvenida"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Muestra en el chat una bienvenida de una línea con la versión cada vez que inicias sesión."
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Asignación de teclas"
L["OPTIONS_KEY_SET"] = "Asignar tecla"
L["OPTIONS_KEY_SET_DESCRIPTION"] =
	"Abre la lista de asignación de teclas del juego, donde Macro Spellbook tiene su propia sección."
L["OPTIONS_KEY_BINDING_TOGGLE_DESCRIPTION"] =
	"Abre y cierra Macro Spellbook. También tiene su propia pestaña en tu libro de hechizos."
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/msb"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre la interfaz de opciones de este add-on."

-- Options: Spellbook Page Panel
L["TAB_SPELLBOOK_PAGE"] = "Página del libro de hechizos"
L["OPTIONS_SPELLBOOK_PAGE_DESCRIPTION"] =
	"Cómo muestra tus hechizos la página de Macro Spellbook en tu libro de hechizos."
L["OPTIONS_SHOW_UNLEARNED_DESCRIPTION"] =
	"Muestra los hechizos de clase que aún no has aprendido en una sección Sin aprender, para que puedas colocar sus macros antes."
L["OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION"] =
	"Un hechizo colocado tal cual en tus barras hace que su macro deje de brillar, aunque la macro tenga opciones activadas."

-- Options: Macro Defaults Panel
L["TAB_MACRO_DEFAULTS"] = "Valores predeterminados de macros"
L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"] =
	"Las opciones con las que empieza cada tipo de macro de hechizo. Lo que ajustes en una macro desde su menú de clic derecho se mantiene. Cada tipo solo muestra las opciones que ofrecen sus hechizos."
L["OPTIONS_KIND_EXAMPLES"] = "Tus hechizos: %s"
L["OPTIONS_KIND_EXAMPLES_MORE"] = "%s y %d más"
L["KIND_ENEMY"] = "Hechizos contra enemigos"
L["KIND_ENEMY_DESCRIPTION"] = "Hechizos que lanzas a un enemigo, como ataques y perjuicios."
L["KIND_FRIENDLY"] = "Hechizos amistosos"
L["KIND_FRIENDLY_DESCRIPTION"] = "Hechizos que lanzas a un aliado, como sanaciones y beneficios."
L["KIND_ANYONE"] = "Hechizos para aliado o enemigo"
L["KIND_ANYONE_DESCRIPTION"] = "Hechizos que puedes lanzar a un aliado o a un enemigo."
L["KIND_GROUND"] = "Hechizos de área en el suelo"
L["KIND_GROUND_DESCRIPTION"] = "Hechizos que colocas en el suelo."
L["KIND_FORM"] = "Formas, actitudes y aspectos"
L["KIND_FORM_DESCRIPTION"] = "Hechizos que siguen activos hasta que los desactivas o cambias a otro."
L["KIND_SELF"] = "Hechizos propios y de área"
L["KIND_SELF_DESCRIPTION"] = "Hechizos sin objetivo, lanzados sobre ti o a tu alrededor."

-- Options: Custom Macros Panel
L["TAB_CUSTOM_MACROS"] = "Macros personalizadas"
L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"] =
	"Tus propias macros, que aparecen en la página en Personalizadas. Si quitas una aquí, su macro se queda en /macro para que la borres tú."
L["OPTIONS_CUSTOM_ADD"] = "Añadir macro"
L["OPTIONS_CUSTOM_ADD_DESCRIPTION"] = "Añade una nueva macro personalizada al final de la lista."
L["OPTIONS_CUSTOM_NEW_NAME"] = "Nueva macro"
L["OPTIONS_CUSTOM_NAME"] = "Nombre"
L["OPTIONS_CUSTOM_NAME_DESCRIPTION"] = "El nombre de la macro, hasta %d caracteres."
L["OPTIONS_CUSTOM_SECTION"] = "Sección"
L["OPTIONS_CUSTOM_SECTION_DESCRIPTION"] =
	"Dónde aparece la macro en la página: en Personalizadas o junto a los hechizos de una de las pestañas de tu libro de hechizos."
L["OPTIONS_CUSTOM_BODY"] = "Texto de la macro"
L["OPTIONS_CUSTOM_BODY_DESCRIPTION"] =
	"El texto de la macro, hasta 255 bytes. Una primera línea con #showtooltip y el nombre de un hechizo muestra el icono de ese hechizo."
L["OPTIONS_CUSTOM_STATUS_NEEDS"] = "Esta macro necesita un nombre y un texto antes de aparecer en la página."
L["OPTIONS_CUSTOM_STATUS_TOO_LONG"] = "Demasiado larga: %d / %d bytes. No aparecerá en la página hasta que quepa."
L["OPTIONS_CUSTOM_STATUS_TAKEN"] = "Otra macro de la página ya tiene este nombre, así que esta no aparecerá."
L["OPTIONS_CUSTOM_REMOVE"] = "Quita esta macro de la lista."
L["OPTIONS_CUSTOM_REMOVE_CONFIRM"] = "¿Quitar esta macro personalizada?"
L["OPTIONS_CUSTOM_RESTORE"] = "Restablecer valores predeterminados"
L["OPTIONS_CUSTOM_RESTORE_DESCRIPTION"] = "Sustituye tus macros personalizadas por las que tu clase trae de serie."
L["OPTIONS_CUSTOM_RESTORE_CONFIRM"] = "¿Sustituir todas tus macros personalizadas por las predeterminadas de tu clase?"

-- Options: Feedback & Support Panel
L["OPTIONS_LEVEL_UP_TITLE"] = "Ayuda a Macro Spellbook a subir de nivel"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Este add-on lo han creado jugadores a los que les encanta este juego y quieren hacerlo lo más divertido posible para todos. Nunca te pediremos donativos. La verdadera satisfacción es saber que nuestro trabajo hace el juego un poco mejor para ti. Si es así, ¡nos encantaría saberlo!"
L["OPTIONS_LEVEL_UP_WAYS"] = "Estas son algunas formas de ayudarnos a llegar a más jugadores."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Danos tu opinión: ¿Has encontrado un error o tienes una idea? Cuéntanoslo en Discord. Tus comentarios nos ayudan a mejorar el add-on, y las pull requests siempre son bienvenidas."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Díselo a un amigo: ¿Conoces a alguien a quien le podría gustar este add-on? Háblale de él. El boca a boca ayuda a más jugadores a descubrir grandes add-ons."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Favorito en CurseForge: Abre el enlace de CurseForge de abajo, inicia sesión y haz clic en la estrella bajo el botón Download. Los favoritos ayudan a más jugadores a descubrir el add-on."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Star en GitHub: Abre el enlace de GitHub de abajo, inicia sesión y haz clic en Star, arriba a la derecha. Las Stars ayudan al proyecto a optar a más herramientas gratuitas para desarrolladores."
L["OPTIONS_LEVEL_UP_THANKS"] = "¡Gracias por elegir Macro Spellbook!"

L["OPTIONS_FEEDBACK"] = "Comentarios y soporte"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Enlaces de comentarios y soporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "Para copiar un enlace, haz clic en su casilla y pulsa Ctrl+A y Ctrl+C."
L["OPTIONS_VERSION"] = "Versión %s"

-- Key Bindings
L["BINDING_TOGGLE_PAGE"] = "Mostrar/ocultar Macro Spellbook"

-- Messages
L["CHAT_LOADED"] =
	"Versión %s. La configuración (incluida la opción de desactivar este mensaje) está en Opciones > Accesorios > Macro Spellbook. ¿Te gusta este add-on? Cuéntaselo a un amigo, márcalo como favorito en CurseForge o dale una Star en GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Como medida de seguridad, la interfaz de opciones no se puede abrir durante el combate."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] =
	"Como medida de seguridad, la lista de asignación de teclas no se puede abrir durante el combate."
L["KEY_BINDINGS_LOCATION"] = "Abre el menú del juego, luego %s, luego %s, y busca la sección Macro Spellbook."
L["ERROR_NO_FREE_MACRO_SLOTS"] = "No hay espacios de macros libres."
L["ERROR_NO_FREE_GENERAL_MACRO_SLOTS"] = "No hay espacios de macros generales libres."
L["CHAT_MACRO_NAME_TAKEN"] =
	'Ya tienes una macro llamada "%s", así que no se ha tocado. Cámbiale el nombre o bórrala en /macro para usar esta.'
L["CHAT_MACRO_TOO_LONG"] =
	'La macro "%s" ocupa %d bytes con sus opciones activadas, más de los %d que admite una macro. Desactiva una opción para acortarla.'
L["CHAT_CUSTOM_NEEDS_NAME_BODY"] =
	"La macro personalizada n.º %d necesita un nombre y un texto antes de aparecer en la página."
L["CHAT_CUSTOM_TOO_LONG"] =
	'La macro personalizada "%s" ocupa %d bytes, más de los %d que admite una macro. Acorta su texto para añadirla a la página.'
L["CHAT_CUSTOM_NAME_TAKEN"] =
	'La macro personalizada "%s" comparte nombre (los primeros %d caracteres) con otra macro de la página. Cámbiale el nombre para añadirla a la página.'
