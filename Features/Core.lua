local ADDON_NAME, ns = ...

local L = ns.L

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

local function GetVersion()
	local version = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version")
	if not version or version:find("@") then
		return "Dev"
	end
	return version
end

ns.Version = GetVersion()

--------------------------------------------------------------------------------
-- Saved Variables
--------------------------------------------------------------------------------

function ns:PrintWelcome()
	if not ns.db.global.showWelcome then
		return
	end
	ns:PrintMessage(L["CHAT_LOADED"]:format(ns.Version))
end

function ns:OnPlayerLogin()
	-- MIGRATION (remove after 2026-11-23)
	ns:MigrateLegacySavedVariables()

	ns.db = LibStub("AceDB-3.0"):New(ns.SAVED_VARIABLES_NAME, ns.DATABASE_DEFAULTS)
	for _, message in ipairs({ "OnProfileChanged", "OnProfileReset", "OnProfileCopied" }) do
		ns.db.RegisterCallback(ns, message, "ApplyProfile")
	end

	-- MIGRATION (remove after 2026-11-23)
	ns:ImportLegacySettings()

	ns.RegisterOptionsPanels()
	ns:RegisterFeatureEvents()
	ns:PrintWelcome()
end

-- A profile switch, reset or copy changes every macro option, so the page and the macros it made follow it.
function ns:ApplyProfile()
	ns:RefreshOpenPages()
	for _, registryName in pairs(ns.OPTIONS_REGISTRY) do
		AceConfigRegistry:NotifyChange(registryName)
	end
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

--[[
	The add-on's complete event surface: the dispatcher registers every name here, and the Diagnostic Tools
	panel reads the same list. Each event's handler is ns:On<Event>, resolved by name when the event fires, so
	feature files loaded after Core supply their own. The trainer events belong to Trainer-Recording.lua, which
	some TOCs leave out, so they are registered only when it loaded.
]]
ns.EVENT_NAMES = {
	"PLAYER_LOGIN",
	"SPELLS_CHANGED",
	"PLAYER_EQUIPMENT_CHANGED",
	"SPELL_DATA_LOAD_RESULT",
	"ACTIONBAR_SLOT_CHANGED",
	"UPDATE_MACROS",
	"PLAYER_TARGET_CHANGED",
	"UPDATE_MOUSEOVER_UNIT",
	"TRAINER_SHOW",
	"TRAINER_UPDATE",
}

local EVENT_HANDLERS = {
	PLAYER_LOGIN = "OnPlayerLogin",
	SPELLS_CHANGED = "OnSpellsChanged",
	PLAYER_EQUIPMENT_CHANGED = "OnPlayerEquipmentChanged",
	SPELL_DATA_LOAD_RESULT = "OnSpellDataLoadResult",
	ACTIONBAR_SLOT_CHANGED = "OnActionbarSlotChanged",
	UPDATE_MACROS = "OnUpdateMacros",
	PLAYER_TARGET_CHANGED = "OnUnitsChanged",
	UPDATE_MOUSEOVER_UNIT = "OnUnitsChanged",
	TRAINER_SHOW = "OnTrainerShow",
	TRAINER_UPDATE = "OnTrainerUpdate",
}

local LOGIN_REGISTERED_EVENTS = { TRAINER_SHOW = true, TRAINER_UPDATE = true }

--[[
	Central dispatcher: every registered event routes through here. It taps the diagnostics event log first,
	a single boolean check while logging is off, then calls the event's handler.
]]
local eventFrame = CreateFrame("Frame")

eventFrame:SetScript("OnEvent", function(_, event, ...)
	if ns.diagnostics and ns.diagnostics.logging then
		ns:LogEvent(event, ...)
	end
	local handlerName = EVENT_HANDLERS[event]
	local handler = handlerName and ns[handlerName]
	if handler then
		handler(ns, ...)
	end
end)

for _, event in ipairs(ns.EVENT_NAMES) do
	if not LOGIN_REGISTERED_EVENTS[event] then
		eventFrame:RegisterEvent(event)
	end
end

-- Registers the events whose handlers only some TOCs load, once every file has.
function ns:RegisterFeatureEvents()
	for event in pairs(LOGIN_REGISTERED_EVENTS) do
		if ns[EVENT_HANDLERS[event]] then
			eventFrame:RegisterEvent(event)
		end
	end
end
