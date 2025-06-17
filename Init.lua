local addonName, addonTable = ...
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, loadedAddon)
    if event == "ADDON_LOADED" and (loadedAddon == addonName) then
        if not TSRCDB then
            TSRCDB = {}
            TSRCDB["MOD_KEY"] = 2
        end
    end
end)