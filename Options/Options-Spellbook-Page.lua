local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Spellbook Page Panel
--------------------------------------------------------------------------------

--[[
	The page-wide settings, the same keys the page's settings menu toggles. Each change redraws an open page.
	Show Unlearned Spells is left out where the TOC left the unlearned-spells file out.
]]
local function PageToggle(order, nameKey, descKey, getter, setter, hidden)
	return {
		type = "toggle",
		name = L[nameKey],
		desc = L[descKey],
		width = "full",
		order = order,
		hidden = hidden,
		get = function()
			return getter()
		end,
		set = function(_, value)
			setter(value)
			ns:RefreshMacros()
		end,
	}
end

function ns.BuildSpellbookPageOptions()
	return {
		type = "group",
		name = L["TAB_SPELLBOOK_PAGE"],
		args = {
			descIntro = ns.OptionsDesc(L["OPTIONS_SPELLBOOK_PAGE_DESCRIPTION"], 1),
			spacerToggles = ns.OptionsSpacer(2),
			toggleShowUnlearned = PageToggle(
				3,
				"SETTINGS_SHOW_UNLEARNED",
				"OPTIONS_SHOW_UNLEARNED_DESCRIPTION",
				ns.ShowsUnlearned,
				ns.SetShowUnlearned,
				function()
					return ns.ForEachUnlearnedSpell == nil
				end
			),
			toggleCountSpellsOnBars = PageToggle(
				4,
				"SETTINGS_COUNT_SPELLS_ON_BARS",
				"OPTIONS_COUNT_SPELLS_ON_BARS_DESCRIPTION",
				ns.CountsSpellsOnBars,
				ns.SetCountSpellsOnBars
			),
		},
	}
end
