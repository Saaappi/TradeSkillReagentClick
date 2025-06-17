local addonName, addonTable = ...
local frame
local dropdown

local function IsSelected(value)
    return value == TSRCDB["MOD_KEY"]
end

local function SetSelected(value)
    TSRCDB["MOD_KEY"] = value
    dropdown:SetShown(true)
end

local function SlashHandler(msg)
    local cmd, rest = msg:match("^(%S*)%s*(.-)$")
    cmd = cmd:lower()

    if cmd == "" then
        if frame and frame:IsVisible() then frame:Hide(); return end
        if not frame then
            frame = CreateFrame("Frame", nil, UIParent, "ButtonFrameTemplate")

            frame.versionLabel = frame:CreateFontString()
            frame.versionLabel:SetFontObject(GameFontHighlight)
            frame.versionLabel:SetText(C_AddOns.GetAddOnMetadata(addonName, "Version"))
            frame.versionLabel:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -15, -30)

            frame:SetToplevel(true)
            table.insert(UISpecialFrames, frame:GetName())
            frame:SetSize(300, 200)
            frame:SetPoint("CENTER")
            frame:Raise()

            frame:SetMovable(true)
            frame:SetClampedToScreen(true)
            frame:RegisterForDrag("LeftButton")
            frame:SetScript("OnDragStart", function()
            frame:StartMoving()
            frame:SetUserPlaced(false)
            end)
            frame:SetScript("OnDragStop", function()
            frame:StopMovingOrSizing()
            frame:SetUserPlaced(false)
            end)

            ButtonFrameTemplate_HidePortrait(frame)
            ButtonFrameTemplate_HideButtonBar(frame)
            frame.Inset:Hide()
            frame:EnableMouse(true)
            frame:SetScript("OnMouseWheel", function() end)

            frame:SetTitle(addonName)

            if not dropdown then
                dropdown = CreateFrame("DropdownButton", nil, frame, "WowStyle1DropdownTemplate")
                dropdown:EnableMouseWheel(true)
                dropdown:SetWidth(180)
                dropdown:SetPoint("CENTER", frame, "CENTER")
                MenuUtil.HookTooltipScripts(dropdown, function()
                    GameTooltip:AddLine(addonTable.L["TOOLTIP_DROPDOWN_MOD_KEY"], 1, 1, 1, 1, true)
                end)
            end

            local options = {
                { NONE, 0 },
                { ALT_KEY, 1 },
                { CTRL_KEY, 2 }
            }
            dropdown:SetupMenu(function(_, rootDescription)
                for _, option in ipairs(options) do
                    local radio = rootDescription:CreateRadio(option[1], IsSelected, SetSelected, option[2])
                end
            end)

            dropdown:Show()
        else
            frame:Show()
        end
    end
end

SLASH_TRADESKILLREAGENTCLICK1 = "/tsrc"
SlashCmdList["TRADESKILLREAGENTCLICK"] = SlashHandler