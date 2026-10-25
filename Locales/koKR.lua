local L = LibStub("AceLocale-3.0"):NewLocale("MacroSpellbook", "koKR")
if not L then
	return
end

-- Add-on Names
L["ADDON_TITLE"] = "Macro Spellbook"
L["ADDON_SHORT_NAME"] = "Macro Spellbook"

-- Page: Sections
L["SECTION_UNLEARNED"] = "배우지 않음"
L["SECTION_CUSTOM"] = "사용자 지정"
L["SECTION_EQUIPMENT"] = "장비"

-- Page: Default Custom Macros
-- TRANSLATORS: each name becomes a WoW macro name, cut to 16 bytes (about 5 Chinese or Korean characters), so keep it short.
L["CUSTOM_SPAM_WAND"] = "마법봉 연타"
L["CUSTOM_PET_ABILITY"] = "펫 기술"
L["CUSTOM_PET_ABILITY_MOUSEOVER"] = "펫 (마우스)"
L["CUSTOM_SWIFT_JUDGE"] = "빠른 심판"

-- Page: Macro Menu
L["MENU_GROUP_COMBAT_CHECK"] = "전투 조건"
L["MENU_GROUP_SPELL_RANK"] = "주문 레벨"
L["MENU_GROUP_TARGETING"] = "대상 지정"
L["MENU_GROUP_BEFORE_CAST"] = "시전 전"
L["MENU_GROUP_ADD_ATTACK"] = "공격 추가"
L["MENU_GROUP_CASTING_RULES"] = "시전 규칙"
L["MENU_GROUP_ERRORS"] = "오류 메시지"
L["MENU_GROUP_USE_ITEMS_FIRST"] = "아이템 먼저 사용"
L["MACRO_TEXT"] = "매크로 내용"
L["MENU_MACRO_LENGTH"] = "%d / %d"
L["MENU_GROUP_VALUE"] = "%s: %s"
L["MENU_OPTIONS_COUNT"] = "옵션 %d개"
L["MENU_CAST_ON_MOUSEOVER"] = "마우스오버 대상에게 시전"
L["MENU_CAST_ON_SELF"] = "자신에게 시전"
L["MENU_CAST_ON_TARGETS_TARGET"] = "대상의 대상에게 시전"
L["MENU_RANK_LEARN_LEVEL"] = "%s (%d레벨에 습득)"
L["MENU_MAX_RANK"] = "최고 레벨"
L["MENU_DYNAMIC_RANK"] = "동적 레벨"
L["MENU_DYNAMIC_RANK_NOTE"] =
	"동적 레벨은 우호적인 플레이어의 레벨에 맞춰지며, 전투 중이 아닐 때만 갱신됩니다."
L["MENU_CAST_AT_CURSOR"] = "커서 위치에 시전"
L["MENU_TARGET_NEAREST_ENEMY"] = "가장 가까운 적 대상 지정"
L["MENU_TARGET_NEAREST_FRIEND"] = "가장 가까운 아군 대상 지정"
L["MENU_CAST_IF_SUMMONED"] = "소환수가 있으면 %s 시전"
L["MENU_NEVER_TURN_OFF"] = "끄지 않기"
L["MENU_LEAVE_FORM_BEFORE"] = "시전 전에 변신 해제"
L["MENU_RIGHT_CLICK_FOR"] = "오른쪽 클릭: %s"
L["MENU_ONLY_IN_COMBAT"] = "전투 중에만"
L["MENU_NEVER_IN_COMBAT"] = "전투 중에는 안 함"
L["MENU_COMBAT_CHECK_NONE"] = "없음"
L["MENU_ONCE_PER_COMBAT"] = "전투당 한 번 시전"
L["MENU_ONCE_PER_TARGET"] = "대상당 한 번 시전"
L["MENU_HIDE_ERRORS"] = "오류 메시지 숨기기"
L["MENU_MUTE_ERRORS"] = "오류 소리 끄기"
L["MENU_SWITCH_TO"] = "%s(으)로 전환"
L["MENU_CAST_ON_FOCUS"] = "주시 대상에게 시전"
L["MENU_START_AUTO_ATTACK"] = "자동 공격 시작"
L["MENU_STOP_ATTACK"] = "공격 중지"
L["MENU_START_AUTO_SHOT"] = "자동 사격 시작"
L["MENU_START_PET_ATTACK"] = "소환수 공격 시작"
L["MENU_START_WAND"] = "마법봉 시작"
L["MENU_STOP_CASTING"] = "시전 중지"
L["MENU_STOP_CASTING_NOTE"] =
	"차단이나 해제처럼 기다릴 수 없는 주문에는 시전 중지를 사용하세요."
L["MENU_STOP_IF_CHANNELING"] = "정신 집중 중이면 매크로 중지"
L["MENU_STOP_IF_STEALTHED"] = "은신 중이면 매크로 중지"
L["MENU_SAFE_TO_SPAM_NOTE"] =
	"매크로를 연타해도 안전하게 하려면, 정신 집중 주문에는 정신 집중 중이면 매크로 중지를, 은신이나 숨기에는 은신 중이면 매크로 중지를 켜세요. 그러면 다시 눌러도 정신 집중이나 은신이 풀리지 않습니다."
L["MENU_USE_FOR_KIND"] = "모든 %s에 이 옵션 사용"
L["MENU_DUPLICATE"] = "복제"
L["MENU_REMOVE_COPY"] = "이 사본 제거"
L["MENU_USE_FOR_KIND_DESCRIPTION"] =
	"%s에서 직접 설정하지 않은 모든 매크로가 이 매크로의 옵션으로 시작합니다. 확인할 수 있도록 매크로 기본값을 엽니다."

-- Page: Settings Menu
L["SETTINGS_SHOW_UNLEARNED"] = "배우지 않은 주문 표시"
L["SETTINGS_COUNT_SPELLS_ON_BARS"] = "단축바의 주문을 배치된 것으로 간주"
L["SETTINGS_MARK_ALL_PLACED"] = "모든 주문을 배치됨으로 표시"
L["SETTINGS_MARK_ALL_PLACED_DESCRIPTION"] =
	"단축바에 있든 없든 이 페이지의 모든 매크로가 더 이상 빛나지 않습니다. 나중에 배우는 주문은 배치할 때까지 계속 빛납니다."
L["SETTINGS_CLEAR_PLACED"] = "배치 표시 지우기"
L["SETTINGS_CLEAR_PLACED_DESCRIPTION"] = "단축바에 없는 표시된 매크로가 모두 다시 빛나게 합니다."
L["SETTINGS_OPEN_MACRO_DEFAULTS_DESCRIPTION"] =
	"설정 화면의 매크로 기본값을 엽니다. 여기서 각 종류의 주문 매크로가 처음 가질 옵션을 고릅니다."
L["SETTINGS_OPEN_CUSTOM_MACROS_DESCRIPTION"] =
	"설정 화면의 사용자 지정 매크로를 엽니다. 여기서 이 페이지에 넣을 매크로를 직접 작성합니다."

-- Page: Macro Buttons
-- TRANSLATORS: each note fills the small slot under a macro button, so keep it short.
L["SUBTEXT_CUSTOM"] = "사용자"
L["SUBTEXT_FOCUS"] = "주시 대상"
L["SUBTEXT_PET"] = "소환수"
L["SUBTEXT_CURSOR"] = "커서"
L["SUBTEXT_MOUSEOVER"] = "마우스오버"
L["SUBTEXT_CAST_ON_SELF"] = "자신"
L["SUBTEXT_STANCE"] = "태세"
L["SUBTEXT_USE_ITEMS"] = "아이템 사용"
L["SUBTEXT_PET_ATTACK"] = "소환수 공격"
L["SUBTEXT_DYNAMIC_RANK"] = "동적 레벨"
L["SUBTEXT_TARGETS_TARGET"] = "대상의 대상"
L["SUBTEXT_TARGET_ENEMY"] = "가까운 적"
L["SUBTEXT_TARGET_FRIEND"] = "가까운 아군"
L["SUBTEXT_GROUP_VERSION"] = "파티용"
L["SUBTEXT_ONCE_PER_COMBAT"] = "전투당 1회"
L["SUBTEXT_ONCE_PER_TARGET"] = "대상당 1회"
L["SUBTEXT_COMBAT_ONLY"] = "전투 중만"
L["SUBTEXT_NO_COMBAT"] = "비전투"
L["SUBTEXT_LEAVE_FORM"] = "변신 해제"
L["SUBTEXT_NO_TOGGLE"] = "계속 켬"
L["SUBTEXT_WAND"] = "마법봉"
L["SUBTEXT_START_ATTACK"] = "자동 공격"
L["SUBTEXT_STOP_ATTACK"] = "공격 중지"
L["SUBTEXT_STOP_CASTING"] = "시전 중지"
L["SUBTEXT_STOP_IF_CHANNELING"] = "정신 집중 중 안 함"
L["SUBTEXT_STOP_IF_STEALTHED"] = "은신 중 안 함"
L["SUBTEXT_HIDE_ERRORS"] = "오류 숨김"
L["SUBTEXT_MUTE_ERRORS"] = "오류 음소거"
L["SUBTEXT_OPTIONS_COUNT"] = "옵션 %d개"
L["SUBTEXT_TOO_LONG"] = "너무 김"
L["SUBTEXT_LEARN_LEVEL"] = "%d레벨"
L["SUBTEXT_TALENT"] = "특성"

-- Page: Macro Tooltip
L["TOOLTIP_NOT_LEARNED"] = "아직 배우지 않음"
L["TOOLTIP_LEARN_LEVEL"] = "직업 상급자에게 %d레벨에 배울 수 있습니다."
L["TOOLTIP_LEARN_TALENT"] = "특성으로 배웁니다."
L["TOOLTIP_NOT_ON_BARS"] = "행동 단축바에 없음"
L["TOOLTIP_TOO_LONG"] = "너무 김: %d / %d바이트. 옵션을 하나 꺼서 줄이세요."
L["TOOLTIP_OPTIONS_ON"] = "켜진 옵션: %s"
L["TOOLTIP_EQUIPMENT_SLOT"] =
	"%s 칸에 착용한 아이템을 사용하므로, 장비를 바꿔도 계속 작동합니다."
L["TOOLTIP_KEY_CLICK_DRAG"] = "클릭 또는 드래그"
L["TOOLTIP_ACTION_PLACE_ON_BAR"] = "행동 단축바에 배치"
L["TOOLTIP_KEY_RIGHT_CLICK"] = "오른쪽 클릭"
L["TOOLTIP_ACTION_MACRO_OPTIONS"] = "매크로 옵션"

-- Spellbook Tab Tooltip
L["SPELLBOOK_TAB_DESCRIPTION"] = "직업 주문을 원클릭 매크로로 제공합니다."
L["TOOLTIP_KEY_CLICK"] = "클릭"
L["TOOLTIP_ACTION_OPEN_PAGE"] = "Macro Spellbook 열기"

-- Page: Layout
L["PAGE_EMPTY"] =
	"아직 매크로가 없습니다. 직업 상급자를 찾아가 첫 주문을 배우거나, 설정 > 애드온 > Macro Spellbook > 사용자 지정 매크로에서 직접 매크로를 추가하세요."
L["PAGE_MACRO_SLOTS"] = "매크로 칸"
L["TOOLTIP_MACRO_SLOTS"] =
	"배치하는 매크로마다 매크로 칸을 하나씩 차지합니다. 캐릭터 칸은 이 캐릭터 전용이며 먼저 채워집니다. 일반 칸은 계정의 모든 캐릭터가 함께 씁니다."
L["PAGE_MACRO_GENERAL"] = "일반"
L["PAGE_MACRO_CHARACTER"] = "캐릭터"
L["PAGE_FOOTER"] =
	"매크로를 클릭하거나 단축바로 끌어다 놓으세요. 빛나는 매크로는 아직 단축바에 없는 것입니다. 매크로를 오른쪽 클릭하면 옵션이 열립니다."

-- Options: General Panel
L["OPTIONS_DESCRIPTION"] =
	"모든 직업 주문을 마우스오버, 커서 위치, 자신에게 시전하는 매크로로 새 마법책 탭에서 클릭 한 번에 만들며, 매크로 문법은 필요 없습니다. 레벨업하거나 주문을 배우거나 전문화를 바꾸면 자동으로 갱신됩니다. 오른쪽 클릭으로 주시 대상, 시전 중지, 자동 공격, 소환수 공격, 장신구 사용을 추가할 수 있습니다."
L["OPTIONS_ENABLE_WELCOME"] = "환영 메시지 사용"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"접속할 때마다 버전이 담긴 한 줄 환영 메시지를 대화창에 출력합니다."
L["OPTIONS_KEY_BINDINGS_HEADER"] = "단축키 설정"
L["OPTIONS_KEY_SET"] = "단축키 지정"
L["OPTIONS_KEY_SET_DESCRIPTION"] =
	"Macro Spellbook 전용 항목이 있는 게임의 단축키 설정 목록을 엽니다."
L["OPTIONS_KEY_BINDING_TOGGLE_DESCRIPTION"] =
	"Macro Spellbook을 열고 닫습니다. 마법책에도 전용 탭이 있습니다."
L["OPTIONS_COMMANDS_HEADER"] = "/명령어"
L["OPTIONS_COMMAND"] = "/msb"
L["OPTIONS_COMMAND_DESCRIPTION"] = "이 애드온의 설정 화면을 엽니다."

-- Options: Spellbook Page Panel
L["TAB_SPELLBOOK_PAGE"] = "마법책 페이지"
L["OPTIONS_SPELLBOOK_PAGE_DESCRIPTION"] =
	"마법책의 Macro Spellbook 페이지가 주문을 보여 주는 방식입니다."
L["OPTIONS_SHOW_UNLEARNED_DESCRIPTION"] =
	"아직 배우지 않은 직업 주문을 배우지 않음 항목에 표시하여, 매크로를 미리 배치할 수 있게 합니다."
L["OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION"] =
	"주문이 이미 단축바에 있으면, 매크로에 옵션이 켜져 있어도 그 매크로는 더 이상 빛나지 않습니다."

-- Options: Macro Defaults Panel
L["TAB_MACRO_DEFAULTS"] = "매크로 기본값"
L["OPTIONS_MACRO_DEFAULTS_DESCRIPTION"] =
	"각 종류의 주문 매크로가 처음 가지는 옵션입니다. 매크로의 오른쪽 클릭 메뉴에서 설정한 값은 그 매크로에 그대로 유지됩니다. 각 종류에는 해당 주문이 제공하는 옵션만 표시됩니다."
L["OPTIONS_DEFAULT_MOUSEOVER_DESCRIPTION"] =
	"마우스 아래에 있는 대상에게 먼저 시전하고, 없으면 현재 대상에게 시전합니다."
L["OPTIONS_DEFAULT_CAST_ON_SELF_DESCRIPTION"] = "대상이 주문을 받을 수 없으면 자신에게 시전합니다."
L["OPTIONS_DEFAULT_TARGETS_TARGET_DESCRIPTION"] =
	"대상이 주문을 받을 수 없으면, 적이 공격 중인 탱커처럼 대상의 대상에게 시전을 시도합니다."
L["OPTIONS_DEFAULT_CURSOR_DESCRIPTION"] =
	"대상 지정 원 없이 커서가 가리키는 곳에 주문을 놓습니다."
L["OPTIONS_DEFAULT_DYNAMIC_RANK_DESCRIPTION"] =
	"우호적인 플레이어의 레벨에 맞는 가장 높은 레벨로 시전합니다."
L["OPTIONS_DEFAULT_STOP_CASTING_DESCRIPTION"] =
	"시전 중인 주문을 먼저 멈춰서 이 주문이 바로 나가게 합니다."
L["OPTIONS_DEFAULT_STOP_ATTACK_DESCRIPTION"] = "근접 자동 공격을 먼저 멈춥니다."
L["OPTIONS_DEFAULT_STOP_IF_CHANNELING_DESCRIPTION"] =
	"주문을 정신 집중하는 동안에는 아무것도 하지 않아서, 눌러도 정신 집중이 끊기지 않습니다."
L["OPTIONS_DEFAULT_STOP_IF_STEALTHED_DESCRIPTION"] =
	"은신 중에는 아무것도 하지 않아서, 눌러도 은신이나 숨기가 풀리지 않습니다."
L["OPTIONS_DEFAULT_LEAVE_FORM_DESCRIPTION"] =
	"현재 변신을 먼저 해제해서 주문을 시전할 수 있게 합니다."
L["OPTIONS_DEFAULT_TARGET_ENEMY_DESCRIPTION"] =
	"살아 있는 적을 대상으로 잡고 있지 않으면 가장 가까운 적을 먼저 대상으로 지정합니다."
L["OPTIONS_DEFAULT_TARGET_FRIEND_DESCRIPTION"] =
	"살아 있는 아군을 대상으로 잡고 있지 않으면 가장 가까운 아군을 먼저 대상으로 지정합니다."
L["OPTIONS_DEFAULT_PET_ATTACK_DESCRIPTION"] = "소환수도 대상을 공격하게 합니다."
L["OPTIONS_DEFAULT_START_ATTACK_DESCRIPTION"] = "시전한 뒤 근접 자동 공격을 시작합니다."
L["OPTIONS_DEFAULT_AUTO_SHOT_DESCRIPTION"] = "시전한 뒤 자동 사격이나 마법봉을 시작합니다."
L["OPTIONS_DEFAULT_ONCE_PER_TARGET_DESCRIPTION"] =
	"한 번 시전한 뒤에는 대상이 바뀔 때까지 다시 시전하지 않습니다."
L["OPTIONS_DEFAULT_ONCE_PER_COMBAT_DESCRIPTION"] =
	"한 번 시전한 뒤에는 전투가 끝나거나 대상이 바뀔 때까지 다시 시전하지 않습니다."
L["OPTIONS_DEFAULT_NEVER_TURN_OFF_DESCRIPTION"] =
	"매크로를 다시 눌러도 변신이나 상을 끄지 않고 계속 유지합니다."
L["OPTIONS_DEFAULT_HIDE_ERRORS_DESCRIPTION"] = "매크로가 화면에 남기는 빨간 오류 문구를 지웁니다."
L["OPTIONS_DEFAULT_MUTE_ERRORS_DESCRIPTION"] = "매크로가 실행되는 동안 오류 소리를 끕니다."
L["OPTIONS_DEFAULT_COMBAT_CHECK_DESCRIPTION"] =
	"이 매크로를 전투 중에만, 전투 중이 아닐 때만, 또는 언제든 시전하게 합니다."
L["OPTIONS_KIND_EXAMPLES"] = "내 주문: %s"
L["OPTIONS_KIND_EXAMPLES_MORE"] = "%s 외 %d개"
L["KIND_ENEMY"] = "적 대상 주문"
L["KIND_ENEMY_DESCRIPTION"] = "공격이나 약화 효과처럼 적에게 시전하는 주문입니다."
L["KIND_FRIENDLY"] = "아군 대상 주문"
L["KIND_FRIENDLY_DESCRIPTION"] = "치유처럼 아군에게 시전하는 주문입니다."
L["KIND_BUFF"] = "강화 효과"
L["KIND_BUFF_DESCRIPTION"] = "아군에게 오래 지속되는 강화 효과를 거는 주문입니다."
L["KIND_ANYONE"] = "아군 또는 적 대상 주문"
L["KIND_ANYONE_DESCRIPTION"] = "아군이나 적 모두에게 시전할 수 있는 주문입니다."
L["KIND_GROUND"] = "지면 지정 주문"
L["KIND_GROUND_DESCRIPTION"] = "지면에 배치하는 주문입니다."
L["KIND_FORM"] = "변신, 태세 및 상"
L["KIND_FORM_DESCRIPTION"] = "끄거나 다른 것으로 바꿀 때까지 유지되는 주문입니다."
L["KIND_SELF"] = "자신 및 광역 주문"
L["KIND_SELF_DESCRIPTION"] = "대상 없이 자신이나 주변에 시전하는 주문입니다."

-- Options: Custom Macros Panel
L["TAB_CUSTOM_MACROS"] = "사용자 지정 매크로"
L["OPTIONS_CUSTOM_MACROS_DESCRIPTION"] =
	"직접 만든 매크로로, 페이지의 사용자 지정 항목에 표시됩니다. 여기서 제거해도 매크로는 /macro에 남으니 직접 삭제하세요."
L["OPTIONS_CUSTOM_ADD"] = "매크로 추가"
L["OPTIONS_CUSTOM_ADD_DESCRIPTION"] = "목록 끝에 새 사용자 지정 매크로를 추가합니다."
L["OPTIONS_CUSTOM_NEW_NAME"] = "새 매크로"
L["OPTIONS_CUSTOM_NAME"] = "이름"
L["OPTIONS_CUSTOM_NAME_DESCRIPTION"] =
	"매크로 이름. WoW는 앞의 %d바이트만 남기므로, 러시아어, 중국어, 한국어 같은 언어에서는 들어가는 글자 수가 더 적습니다."
L["OPTIONS_CUSTOM_SECTION"] = "항목"
L["OPTIONS_CUSTOM_SECTION_DESCRIPTION"] =
	"페이지에서 매크로가 표시될 위치입니다. 사용자 지정 항목이나 마법책 탭 중 하나의 주문과 함께 표시됩니다."
L["OPTIONS_CUSTOM_BODY_DESCRIPTION"] =
	"매크로 내용, 최대 %d바이트. 첫 줄에 #showtooltip과 주문 이름을 쓰면 그 주문의 아이콘이 표시됩니다."
L["OPTIONS_CUSTOM_STATUS_NEEDS"] =
	"이 매크로가 페이지에 표시되려면 이름과 매크로 내용이 필요합니다."
L["OPTIONS_CUSTOM_STATUS_TOO_LONG"] =
	"너무 김: %d / %d바이트. 길이에 맞을 때까지 페이지에 표시되지 않습니다."
L["OPTIONS_CUSTOM_STATUS_TAKEN"] =
	"페이지의 다른 매크로가 이미 이 이름을 쓰고 있어 이 매크로는 표시되지 않습니다."
L["OPTIONS_CUSTOM_REMOVE_DESCRIPTION"] = "이 매크로를 목록에서 제거합니다."
L["OPTIONS_CUSTOM_REMOVE_CONFIRM"] = "이 사용자 지정 매크로를 제거할까요?"
L["OPTIONS_CUSTOM_RESTORE"] = "기본값 복원"
L["OPTIONS_CUSTOM_RESTORE_DESCRIPTION"] = "사용자 지정 매크로를 직업의 기본 매크로로 바꿉니다."
L["OPTIONS_CUSTOM_RESTORE_CONFIRM"] = "모든 사용자 지정 매크로를 직업의 기본 매크로로 바꿀까요?"

-- Options: Feedback & Support Panel
L["OPTIONS_LEVEL_UP_TITLE"] = "Macro Spellbook 레벨 업 돕기"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"이 애드온은 이 게임을 사랑하고 모두에게 최대한 즐거운 게임을 만들고 싶은 플레이어들이 만들었습니다. 저희는 절대 후원을 요청하지 않습니다. 저희의 작업이 여러분의 게임을 조금 더 낫게 만든다는 것을 아는 것이 진정한 보람입니다. 그렇다면 꼭 알려 주세요!"
L["OPTIONS_LEVEL_UP_WAYS"] =
	"더 많은 플레이어에게 다가갈 수 있도록 도와주는 방법은 다음과 같습니다."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• 의견 보내기: 버그를 찾았거나 아이디어가 있나요? Discord에서 알려 주세요. 여러분의 의견은 애드온을 개선하는 데 도움이 되며, 풀 리퀘스트는 언제나 환영합니다."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• 친구에게 알리기: 이 애드온을 좋아할 만한 사람을 알고 있나요? 알려 주세요. 입소문은 더 많은 플레이어가 좋은 애드온을 발견하는 데 도움이 됩니다."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• CurseForge에서 즐겨찾기: 아래 CurseForge 링크를 열고 로그인한 다음 Download 버튼 아래의 별을 클릭하세요. 즐겨찾기는 더 많은 플레이어가 애드온을 발견하는 데 도움이 됩니다."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• GitHub에서 Star 누르기: 아래 GitHub 링크를 열고 로그인한 다음 오른쪽 위의 Star를 클릭하세요. Star는 프로젝트가 더 많은 무료 개발자 도구를 받는 데 도움이 됩니다."
L["OPTIONS_LEVEL_UP_THANKS"] = "Macro Spellbook을 선택해 주셔서 감사합니다!"

L["OPTIONS_FEEDBACK"] = "피드백 및 지원"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "피드백 및 지원 링크"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "링크를 복사하려면 칸을 클릭한 다음 Ctrl+A, Ctrl+C를 누르세요."
L["OPTIONS_VERSION"] = "버전 %s"

-- Key Bindings
L["BINDING_TOGGLE_PAGE"] = "Macro Spellbook 열기/닫기"

-- Messages
L["CHAT_LOADED"] =
	"버전 %s. 설정(이 메시지를 끄는 옵션 포함)은 설정 > 애드온 > Macro Spellbook에 있습니다. 이 애드온이 마음에 드시나요? 친구에게 알리고, CurseForge에서 즐겨찾기하거나 GitHub에서 Star를 눌러 주세요. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "안전을 위해 전투 중에는 설정 화면을 열 수 없습니다."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "안전을 위해 전투 중에는 단축키 설정 목록을 열 수 없습니다."
L["KEY_BINDINGS_LOCATION"] =
	"게임 메뉴를 열고 %s, %s 순으로 들어가 Macro Spellbook 항목을 찾으세요."
L["ERROR_MACRO_SLOTS_FULL"] =
	"빈 매크로 칸이 없습니다. /macro에서 매크로를 삭제해 자리를 만드세요."
L["ERROR_GENERAL_MACRO_SLOTS_FULL"] =
	"빈 일반 매크로 칸이 없습니다. /macro에서 일반 매크로를 삭제해 자리를 만드세요."
L["CHAT_MACRO_TOO_LONG"] =
	'"%s" 매크로는 옵션을 켠 상태로 %d바이트라서 매크로 최대 길이인 %d바이트를 넘습니다. 옵션을 하나 꺼서 줄이세요.'
L["CHAT_CUSTOM_NEEDS_NAME_BODY"] =
	"사용자 지정 매크로 #%d이(가) 페이지에 표시되려면 이름과 매크로 내용이 필요합니다."
L["CHAT_CUSTOM_TOO_LONG"] =
	'사용자 지정 매크로 "%s"은(는) %d바이트라서 매크로 최대 길이인 %d바이트를 넘습니다. 페이지에 추가하려면 내용을 줄이세요.'
L["CHAT_CUSTOM_NAME_TAKEN"] =
	'사용자 지정 매크로 "%s"의 이름(앞 %d바이트)이 페이지의 다른 매크로와 같습니다. 페이지에 추가하려면 이름을 바꾸세요.'
