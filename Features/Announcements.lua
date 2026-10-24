local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Messaging
--------------------------------------------------------------------------------

-- Player-only branded print. Macro Spellbook sends no chat to other players.
function ns:PrintMessage(message)
	print(
		GetColor("INFO")
			.. L["ADDON_SHORT_NAME"]
			.. "|r "
			.. GetColor("SEPARATOR")
			.. "//"
			.. "|r "
			.. GetColor("TEXT")
			.. message
			.. "|r"
	)
end
