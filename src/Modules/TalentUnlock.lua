-- Optional, standalone module: shows the Talents tab in PlayerSpellsFrame below level 10 so the tree
-- can be viewed. Points still come from the server, so nothing can be spent early.
-- Uses nothing else in the addon. Delete this file and its line in MacroSpellbook.toc to remove it.

-- Blizzard's gate stays in place (replacing it would taint the secure spellbook buttons); we only
-- re-show the tab after Blizzard hides it.
local function showTalentTab(frame)
    if frame.IsInspecting and frame:IsInspecting() then return end
    frame.TabSystem:SetTabShown(frame.talentTabID, true)
end

local function unlock()
    local frame = PlayerSpellsFrame
    if not (frame and frame.TabSystem and frame.TabSystem.SetTabShown and frame.talentTabID) then return end
    if frame.UpdateTabs then
        hooksecurefunc(frame, "UpdateTabs", showTalentTab)
    else
        frame:HookScript("OnShow", showTalentTab)
    end
    -- the tab bar may already be built
    if frame:IsShown() then showTalentTab(frame) end
end

EventUtil.ContinueOnAddOnLoaded("Blizzard_PlayerSpells", unlock)

-- The talents keybind does nothing while gated, so toggle the talents tab ourselves.
if PlayerSpellsUtil and PlayerSpellsUtil.ToggleClassTalentOrSpecFrame then
    hooksecurefunc(PlayerSpellsUtil, "ToggleClassTalentOrSpecFrame", function()
        local canUse = C_SpecializationInfo and C_SpecializationInfo.CanPlayerUseTalentUI
        if not canUse or canUse() or InCombatLockdown() then return end
        if not PlayerSpellsFrame then C_AddOns.LoadAddOn("Blizzard_PlayerSpells") end
        local frame = PlayerSpellsFrame
        if not (frame and frame.talentTabID and frame.SetTab) then return end
        local onTalents = frame.GetTab and frame:GetTab() == frame.talentTabID
        if frame:IsShown() and onTalents then
            HideUIPanel(frame)
        else
            ShowUIPanel(frame)
            frame:SetTab(frame.talentTabID)
        end
    end)
end
