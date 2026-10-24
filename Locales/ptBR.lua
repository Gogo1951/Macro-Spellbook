local L = LibStub("AceLocale-3.0"):NewLocale("MacroSpellbook", "ptBR")
if not L then
	return
end

-- Add-on Names
L["ADDON_TITLE"] = "Macro Spellbook"
L["ADDON_SHORT_NAME"] = "Macro Spellbook"

-- Page: Sections
L["SECTION_UNLEARNED"] = "Não aprendidos"
L["SECTION_CUSTOM"] = "Personalizadas"
L["SECTION_EQUIPMENT"] = "Equipamento"

-- Page: Default Custom Macros
-- TRANSLATORS: each name becomes a WoW macro name, cut to 16 bytes (about 5 Chinese or Korean characters), so keep it short.
L["CUSTOM_SPAM_WAND"] = "Varinha em loop"
L["CUSTOM_PET_ABILITY"] = "Hab. do ajudante"
L["CUSTOM_PET_ABILITY_MOUSEOVER"] = "Ajudante (mouse)"
L["CUSTOM_SWIFT_JUDGE"] = "Julgar rápido"

-- Page: Macro Menu
L["MENU_GROUP_COMBAT_CHECK"] = "Condição de combate"
L["MENU_GROUP_SPELL_RANK"] = "Grau do feitiço"
L["MENU_GROUP_TARGETING"] = "Seleção de alvo"
L["MENU_GROUP_BEFORE_CAST"] = "Antes de lançar"
L["MENU_GROUP_ADD_ATTACK"] = "Adicionar ataque"
L["MENU_GROUP_CASTING_RULES"] = "Regras de lançamento"
L["MENU_GROUP_ERRORS"] = "Mensagens de erro"
L["MENU_GROUP_USE_ITEMS_FIRST"] = "Usar itens primeiro"
L["MACRO_TEXT"] = "Texto da macro"
L["MENU_MACRO_LENGTH"] = "%d / %d"
L["MENU_GROUP_VALUE"] = "%s: %s"
L["MENU_OPTIONS_COUNT"] = "%d opções"
L["MENU_CAST_ON_MOUSEOVER"] = "Lançar ao passar o mouse"
L["MENU_CAST_ON_SELF"] = "Lançar em si mesmo"
L["MENU_CAST_ON_TARGETS_TARGET"] = "Lançar no alvo do alvo"
L["MENU_RANK_LEARN_LEVEL"] = "%s (Nível %d)"
L["MENU_MAX_RANK"] = "Grau máximo"
L["MENU_DYNAMIC_RANK"] = "Grau dinâmico"
L["MENU_DYNAMIC_RANK_NOTE"] =
	"O grau dinâmico, baseado no nível de um jogador amistoso, só é atualizado fora de combate."
L["MENU_CAST_AT_CURSOR"] = "Lançar no cursor"
L["MENU_TARGET_NEAREST_ENEMY"] = "Selecionar o inimigo mais próximo"
L["MENU_TARGET_NEAREST_FRIEND"] = "Selecionar o aliado mais próximo"
L["MENU_CAST_IF_SUMMONED"] = "Lançar %s se invocado"
L["MENU_NEVER_TURN_OFF"] = "Nunca desativar"
L["MENU_LEAVE_FORM_BEFORE"] = "Sair da forma antes de lançar"
L["MENU_RIGHT_CLICK_FOR"] = "Clique direito para %s"
L["MENU_ONLY_IN_COMBAT"] = "Só em combate"
L["MENU_NEVER_IN_COMBAT"] = "Nunca em combate"
L["MENU_COMBAT_CHECK_NONE"] = "Nenhuma"
L["MENU_ONCE_PER_COMBAT"] = "Lançar uma vez por combate"
L["MENU_ONCE_PER_TARGET"] = "Lançar uma vez por alvo"
L["MENU_HIDE_ERRORS"] = "Ocultar mensagens de erro"
L["MENU_MUTE_ERRORS"] = "Silenciar sons de erro"
L["MENU_SWITCH_TO"] = "Mudar para %s"
L["MENU_CAST_ON_FOCUS"] = "Lançar no foco"
L["MENU_START_AUTO_ATTACK"] = "Iniciar ataque automático"
L["MENU_STOP_ATTACK"] = "Parar ataque"
L["MENU_START_AUTO_SHOT"] = "Iniciar disparo automático"
L["MENU_START_PET_ATTACK"] = "Iniciar ataque do ajudante"
L["MENU_START_WAND"] = "Iniciar varinha"
L["MENU_STOP_CASTING"] = "Parar lançamento"
L["MENU_STOP_CASTING_NOTE"] =
	"Use Parar lançamento em feitiços que não podem esperar, como interrupções e dissipações."
L["MENU_STOP_IF_CHANNELING"] = "Parar macro se canalizando"
L["MENU_STOP_IF_STEALTHED"] = "Parar macro se em furtividade"
L["MENU_SAFE_TO_SPAM_NOTE"] =
	"Para poder apertar uma macro sem parar com segurança, ative Parar macro se canalizando para um feitiço canalizado, ou Parar macro se em furtividade para Furtividade ou Espreitar. Assim, apertar de novo não interrompe a canalização nem a sua furtividade."
L["MENU_USE_FOR_KIND"] = "Usar estas opções na categoria %s"
L["MENU_DUPLICATE"] = "Duplicar"
L["MENU_REMOVE_COPY"] = "Remover esta cópia"
L["MENU_USE_FOR_KIND_DESCRIPTION"] =
	"Toda macro da categoria %s que você não ajustou por conta própria começa com as opções desta macro. Abre Padrões das macros para mostrar a você."

-- Page: Settings Menu
L["SETTINGS_SHOW_UNLEARNED"] = "Mostrar feitiços não aprendidos"
L["SETTINGS_COUNT_SPELLS_ON_BARS"] = "Contar feitiços nas barras como colocados"
L["SETTINGS_MARK_ALL_PLACED"] = "Marcar todos os feitiços como colocados"
L["SETTINGS_MARK_ALL_PLACED_DESCRIPTION"] =
	"Nenhuma macro desta página brilha mais, esteja ou não nas suas barras. Um feitiço que você aprender depois continua brilhando até ser colocado."
L["SETTINGS_CLEAR_PLACED"] = "Limpar marcas de colocado"
L["SETTINGS_CLEAR_PLACED_DESCRIPTION"] = "Faz brilhar de novo cada macro marcada que não está nas suas barras."
L["SETTINGS_OPEN_MACRO_DEFAULTS_DESCRIPTION"] =
	"Abre a interface de opções em Padrões das macros, onde você escolhe as opções com que cada tipo de macro de feitiço começa."
L["SETTINGS_OPEN_CUSTOM_MACROS_DESCRIPTION"] =
	"Abre a interface de opções em Macros personalizadas, onde você escreve suas próprias macros para esta página."

-- Page: Macro Buttons
-- TRANSLATORS: each note fills the small slot under a macro button, so keep it short.
L["SUBTEXT_CUSTOM"] = "Pessoal"
L["SUBTEXT_FOCUS"] = "Foco"
L["SUBTEXT_PET"] = "Ajudante"
L["SUBTEXT_CURSOR"] = "No cursor"
L["SUBTEXT_MOUSEOVER"] = "Com mouse"
L["SUBTEXT_CAST_ON_SELF"] = "Em si"
L["SUBTEXT_STANCE"] = "Postura"
L["SUBTEXT_USE_ITEMS"] = "Usar itens"
L["SUBTEXT_PET_ATTACK"] = "Ataque ajudante"
L["SUBTEXT_DYNAMIC_RANK"] = "Grau dinâm."
L["SUBTEXT_TARGETS_TARGET"] = "Alvo do alvo"
L["SUBTEXT_TARGET_ENEMY"] = "Inimigo próximo"
L["SUBTEXT_TARGET_FRIEND"] = "Aliado próximo"
L["SUBTEXT_GROUP_VERSION"] = "Versão de grupo"
L["SUBTEXT_ONCE_PER_COMBAT"] = "1 por combate"
L["SUBTEXT_ONCE_PER_TARGET"] = "1 por alvo"
L["SUBTEXT_COMBAT_ONLY"] = "Só em combate"
L["SUBTEXT_NO_COMBAT"] = "Fora de combate"
L["SUBTEXT_LEAVE_FORM"] = "Sai da forma"
L["SUBTEXT_NO_TOGGLE"] = "Fica ativo"
L["SUBTEXT_WAND"] = "Varinha"
L["SUBTEXT_START_ATTACK"] = "Ataque auto."
L["SUBTEXT_STOP_ATTACK"] = "Para ataque"
L["SUBTEXT_STOP_CASTING"] = "Para lançam."
L["SUBTEXT_STOP_IF_CHANNELING"] = "Não ao canalizar"
L["SUBTEXT_STOP_IF_STEALTHED"] = "Não em furtividade"
L["SUBTEXT_HIDE_ERRORS"] = "Sem erros"
L["SUBTEXT_MUTE_ERRORS"] = "Erros mudos"
L["SUBTEXT_OPTIONS_COUNT"] = "%d opções"
L["SUBTEXT_TOO_LONG"] = "Muito longa"
L["SUBTEXT_LEARN_LEVEL"] = "Nível %d"
L["SUBTEXT_TALENT"] = "Talento"

-- Page: Macro Tooltip
L["TOOLTIP_NOT_LEARNED"] = "Ainda não aprendido"
L["TOOLTIP_LEARN_LEVEL"] = "Seu instrutor de classe ensina no nível %d."
L["TOOLTIP_LEARN_TALENT"] = "Aprendido pelos seus talentos."
L["TOOLTIP_NOT_ON_BARS"] = "Não está nas suas barras de ação"
L["TOOLTIP_TOO_LONG"] = "Longa demais: %d / %d bytes. Desative uma opção para encurtá-la."
L["TOOLTIP_OPTIONS_ON"] = "Opções ativadas: %s"
L["TOOLTIP_EQUIPMENT_SLOT"] =
	"Usa o que você estiver vestindo no espaço %s, então continua funcionando quando você troca de equipamento."
L["TOOLTIP_KEY_CLICK_DRAG"] = "Clicar ou arrastar"
L["TOOLTIP_ACTION_PLACE_ON_BAR"] = "Colocar nas suas barras de ação"
L["TOOLTIP_KEY_RIGHT_CLICK"] = "Clique direito"
L["TOOLTIP_ACTION_MACRO_OPTIONS"] = "Opções da macro"

-- Spellbook Tab Tooltip
L["SPELLBOOK_TAB_DESCRIPTION"] = "Os feitiços da sua classe como macros de um clique."
L["TOOLTIP_KEY_CLICK"] = "Clicar"
L["TOOLTIP_ACTION_OPEN_PAGE"] = "Abrir o Macro Spellbook"

-- Page: Layout
L["PAGE_EMPTY"] =
	"Ainda não há macros. Visite seu instrutor de classe para aprender seus primeiros feitiços, ou adicione suas próprias macros em Opções > AddOns > Macro Spellbook > Macros personalizadas."
L["PAGE_MACRO_SLOTS"] = "Espaços de macro"
L["TOOLTIP_MACRO_SLOTS"] =
	"Cada macro que você coloca ocupa um espaço de macro. Os espaços de personagem são deste personagem e são preenchidos primeiro. Os espaços gerais são compartilhados por todos os personagens da sua conta."
L["PAGE_MACRO_GENERAL"] = "Gerais"
L["PAGE_MACRO_CHARACTER"] = "Personagem"
L["PAGE_FOOTER"] =
	"Clique em uma macro ou arraste-a para suas barras. Uma macro brilhando ainda não está nas suas barras. Clique com o botão direito em uma macro para ver as opções."

-- Options: General Panel
L["OPTIONS_DESCRIPTION"] =
	"Macros de mouseover, no cursor e em si mesmo para cada feitiço de classe, criadas com um clique em uma nova aba do grimório, sem sintaxe de macro. Elas se atualizam quando você sobe de nível, treina ou troca de especialização. Clique com o botão direito para adicionar foco, parar lançamento, ataque automático, ataque do ajudante ou uso de berloques."
L["OPTIONS_ENABLE_WELCOME"] = "Ativar mensagem de boas-vindas"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Mostra no chat uma mensagem de boas-vindas de uma linha com a versão sempre que você entra no jogo."
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Teclas de atalho"
L["OPTIONS_KEY_SET"] = "Definir tecla"
L["OPTIONS_KEY_SET_DESCRIPTION"] =
	"Abre a lista de teclas de atalho do jogo, onde o Macro Spellbook tem sua própria seção."
L["OPTIONS_KEY_BINDING_TOGGLE_DESCRIPTION"] =
	"Abre e fecha o Macro Spellbook. Ele também tem sua própria aba no seu grimório."
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/msb"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre a interface de opções deste add-on."

-- Options: Spellbook Page Panel
L["TAB_SPELLBOOK_PAGE"] = "Página do grimório"
L["OPTIONS_SPELLBOOK_PAGE_DESCRIPTION"] = "Como a página do Macro Spellbook no seu grimório lista seus feitiços."
L["OPTIONS_SHOW_UNLEARNED_DESCRIPTION"] =
	"Lista os feitiços de classe que você ainda não aprendeu numa seção Não aprendidos, para você colocar as macros deles antes."
L["OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION"] =
	"Uma macro para de brilhar quando o feitiço dela já está nas suas barras, mesmo que a macro tenha opções ativadas."

-- Options: Macro Defaults Panel
L["TAB_MACRO_DEFAULTS"] = "Padrões das macros"
L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"] =
	"As opções com que cada tipo de macro de feitiço começa. O que você definir em uma macro pelo menu do clique direito é mantido. Cada tipo mostra só as opções que seus feitiços oferecem."
L["OPTIONS_DEFAULT_MOUSEOVER_DESCRIPTION"] = "Lança primeiro em quem estiver sob o mouse e depois no seu alvo."
L["OPTIONS_DEFAULT_CAST_ON_SELF_DESCRIPTION"] = "Lança em você quando seu alvo não pode receber o feitiço."
L["OPTIONS_DEFAULT_TARGETS_TARGET_DESCRIPTION"] =
	"Tenta o alvo do seu alvo quando seu alvo não pode receber o feitiço, como o tanque que um inimigo está atacando."
L["OPTIONS_DEFAULT_CURSOR_DESCRIPTION"] = "Posiciona o feitiço onde o cursor aponta, sem círculo de mira."
L["OPTIONS_DEFAULT_DYNAMIC_RANK_DESCRIPTION"] = "Lança o grau mais alto que o nível do jogador amistoso permite."
L["OPTIONS_DEFAULT_STOP_CASTING_DESCRIPTION"] =
	"Para primeiro o que você estiver lançando, para que este feitiço saia na hora."
L["OPTIONS_DEFAULT_STOP_ATTACK_DESCRIPTION"] = "Para primeiro seu ataque automático corpo a corpo."
L["OPTIONS_DEFAULT_STOP_IF_CHANNELING_DESCRIPTION"] =
	"Não faz nada enquanto você canaliza um feitiço, então apertar nunca interrompe a canalização."
L["OPTIONS_DEFAULT_STOP_IF_STEALTHED_DESCRIPTION"] =
	"Não faz nada enquanto você está em furtividade, então apertar nunca interrompe Furtividade ou Espreitar."
L["OPTIONS_DEFAULT_LEAVE_FORM_DESCRIPTION"] = "Sai primeiro da sua forma atual, para que o feitiço possa ser lançado."
L["OPTIONS_DEFAULT_TARGET_ENEMY_DESCRIPTION"] =
	"Seleciona primeiro o inimigo mais próximo quando você não tem nenhum inimigo vivo como alvo."
L["OPTIONS_DEFAULT_TARGET_FRIEND_DESCRIPTION"] =
	"Seleciona primeiro o aliado mais próximo quando você não tem nenhum aliado vivo como alvo."
L["OPTIONS_DEFAULT_PET_ATTACK_DESCRIPTION"] = "Manda também seu ajudante atacar o seu alvo."
L["OPTIONS_DEFAULT_START_ATTACK_DESCRIPTION"] = "Inicia seu ataque automático corpo a corpo depois do lançamento."
L["OPTIONS_DEFAULT_AUTO_SHOT_DESCRIPTION"] = "Inicia Disparo Automático ou sua varinha depois do lançamento."
L["OPTIONS_DEFAULT_ONCE_PER_TARGET_DESCRIPTION"] = "Lança uma vez e não de novo até seu alvo mudar."
L["OPTIONS_DEFAULT_ONCE_PER_COMBAT_DESCRIPTION"] =
	"Lança uma vez e não de novo até o combate acabar ou seu alvo mudar."
L["OPTIONS_DEFAULT_NEVER_TURN_OFF_DESCRIPTION"] =
	"Apertar a macro de novo mantém a forma ou o aspecto ativo em vez de desativá-lo."
L["OPTIONS_DEFAULT_HIDE_ERRORS_DESCRIPTION"] = "Limpa o texto de erro vermelho que a macro deixa na tela."
L["OPTIONS_DEFAULT_MUTE_ERRORS_DESCRIPTION"] = "Silencia o som de erro enquanto a macro é executada."
L["OPTIONS_DEFAULT_COMBAT_CHECK_DESCRIPTION"] =
	"Faz estas macros lançarem só em combate, só fora de combate ou em ambos."
L["OPTIONS_KIND_EXAMPLES"] = "Seus feitiços: %s"
L["OPTIONS_KIND_EXAMPLES_MORE"] = "%s e mais %d"
L["KIND_ENEMY"] = "Feitiços contra inimigos"
L["KIND_ENEMY_DESCRIPTION"] = "Feitiços lançados em um inimigo, como ataques e penalidades."
L["KIND_FRIENDLY"] = "Feitiços amistosos"
L["KIND_FRIENDLY_DESCRIPTION"] = "Feitiços lançados em um aliado, como curas."
L["KIND_BUFF"] = "Bônus"
L["KIND_BUFF_DESCRIPTION"] = "Feitiços que dão a um aliado um bônus duradouro."
L["KIND_ANYONE"] = "Feitiços para aliado ou inimigo"
L["KIND_ANYONE_DESCRIPTION"] = "Feitiços que podem ser lançados em um aliado ou em um inimigo."
L["KIND_GROUND"] = "Feitiços no chão"
L["KIND_GROUND_DESCRIPTION"] = "Feitiços que você posiciona no chão."
L["KIND_FORM"] = "Formas, posturas e aspectos"
L["KIND_FORM_DESCRIPTION"] = "Feitiços que ficam ativos até você desligá-los ou trocar por outro."
L["KIND_SELF"] = "Feitiços pessoais e de área"
L["KIND_SELF_DESCRIPTION"] = "Feitiços sem alvo, lançados em você ou ao seu redor."

-- Options: Custom Macros Panel
L["TAB_CUSTOM_MACROS"] = "Macros personalizadas"
L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"] =
	"Suas próprias macros, listadas na página em Personalizadas. Remover uma aqui deixa a macro dela em /macro para você apagar."
L["OPTIONS_CUSTOM_ADD"] = "Adicionar macro"
L["OPTIONS_CUSTOM_ADD_DESCRIPTION"] = "Adiciona uma nova macro personalizada ao fim da lista."
L["OPTIONS_CUSTOM_NEW_NAME"] = "Nova macro"
L["OPTIONS_CUSTOM_NAME"] = "Nome"
L["OPTIONS_CUSTOM_NAME_DESCRIPTION"] = "O nome da macro, com até %d caracteres."
L["OPTIONS_CUSTOM_SECTION"] = "Seção"
L["OPTIONS_CUSTOM_SECTION_DESCRIPTION"] =
	"Onde a macro aparece na página: em Personalizadas ou com os feitiços de uma das abas do seu grimório."
L["OPTIONS_CUSTOM_BODY_DESCRIPTION"] =
	"O texto da macro, com até 255 bytes. Uma primeira linha com #showtooltip e o nome de um feitiço mostra o ícone desse feitiço."
L["OPTIONS_CUSTOM_STATUS_NEEDS"] = "Esta macro precisa de um nome e de um texto antes de aparecer na página."
L["OPTIONS_CUSTOM_STATUS_TOO_LONG"] = "Longa demais: %d / %d bytes. Ela não vai aparecer na página até caber."
L["OPTIONS_CUSTOM_STATUS_TAKEN"] = "Outra macro da página já tem este nome, então esta não vai aparecer."
L["OPTIONS_CUSTOM_REMOVE_DESCRIPTION"] = "Remove esta macro da lista."
L["OPTIONS_CUSTOM_REMOVE_CONFIRM"] = "Remover esta macro personalizada?"
L["OPTIONS_CUSTOM_RESTORE"] = "Restaurar padrões"
L["OPTIONS_CUSTOM_RESTORE_DESCRIPTION"] = "Substitui suas macros personalizadas pelas que sua classe tem de início."
L["OPTIONS_CUSTOM_RESTORE_CONFIRM"] = "Substituir todas as suas macros personalizadas pelas padrão da sua classe?"

-- Options: Feedback & Support Panel
L["OPTIONS_LEVEL_UP_TITLE"] = "Ajude o Macro Spellbook a subir de nível"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Este add-on foi criado por jogadores que amam este jogo e querem torná-lo o mais divertido possível para todos. Nunca vamos pedir doações. A verdadeira satisfação vem de saber que nosso trabalho deixa o jogo um pouco melhor para você. Se for o caso, adoraríamos saber!"
L["OPTIONS_LEVEL_UP_WAYS"] = "Aqui estão algumas formas de nos ajudar a alcançar mais jogadores."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Dê sua opinião: Encontrou um bug ou tem uma ideia? Conte para a gente no Discord. Seu feedback nos ajuda a melhorar o add-on, e pull requests são sempre bem-vindos."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Conte a um amigo: Conhece alguém que pode gostar deste add-on? Fale dele para essa pessoa. O boca a boca ajuda mais jogadores a descobrir ótimos add-ons."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Favorite no CurseForge: Abra o link do CurseForge abaixo, entre na sua conta e clique na estrela abaixo do botão Download. Os favoritos ajudam mais jogadores a descobrir o add-on."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Star no GitHub: Abra o link do GitHub abaixo, entre na sua conta e clique em Star no canto superior direito. As Stars ajudam o projeto a se qualificar para mais ferramentas gratuitas para desenvolvedores."
L["OPTIONS_LEVEL_UP_THANKS"] = "Obrigado por escolher o Macro Spellbook!"

L["OPTIONS_FEEDBACK"] = "Feedback e suporte"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Links de feedback e suporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "Para copiar um link, clique na caixa dele e pressione Ctrl+A e Ctrl+C."
L["OPTIONS_VERSION"] = "Versão %s"

-- Key Bindings
L["BINDING_TOGGLE_PAGE"] = "Mostrar/ocultar o Macro Spellbook"

-- Messages
L["CHAT_LOADED"] =
	"Versão %s. As configurações (incluindo a opção de desativar esta mensagem) ficam em Opções > AddOns > Macro Spellbook. Gostando deste add-on? Conte a um amigo, favorite no CurseForge ou dê uma Star no GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Por segurança, a interface de opções não pode ser aberta durante o combate."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "Por segurança, a lista de teclas de atalho não pode ser aberta durante o combate."
L["KEY_BINDINGS_LOCATION"] = "Abra o menu do jogo, depois %s, depois %s, e procure a seção Macro Spellbook."
L["ERROR_MACRO_SLOTS_FULL"] = "Não há espaços de macro livres. Apague uma macro em /macro para abrir espaço."
L["ERROR_GENERAL_MACRO_SLOTS_FULL"] =
	"Não há espaços de macro gerais livres. Apague uma macro geral em /macro para abrir espaço."
L["CHAT_MACRO_TOO_LONG"] =
	'A macro "%s" tem %d bytes com as opções ativadas, acima dos %d que cabem em uma macro. Desative uma opção para encurtá-la.'
L["CHAT_CUSTOM_NEEDS_NAME_BODY"] =
	"A macro personalizada nº %d precisa de um nome e de um texto antes de aparecer na página."
L["CHAT_CUSTOM_TOO_LONG"] =
	'A macro personalizada "%s" tem %d bytes, acima dos %d que cabem em uma macro. Encurte o texto dela para adicioná-la à página.'
L["CHAT_CUSTOM_NAME_TAKEN"] =
	'A macro personalizada "%s" tem o mesmo nome (os primeiros %d caracteres) de outra macro da página. Renomeie-a para adicioná-la à página.'
