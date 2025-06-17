local addonTable = select(2, ...)
local L = addonTable.L or {}
addonTable.L = L

if GetLocale() ~= "enUS" then return end

L.TOOLTIP_DROPDOWN_MOD_KEY = "Choose whether a modifier key is required when clicking on reagents in the trade skill window."