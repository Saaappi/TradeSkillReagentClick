local addonTable = select(2, ...)
local L = addonTable.L or {}
addonTable.L = L

if GetLocale() ~= "deDE" then return end

L.TOOLTIP_DROPDOWN_MOD_KEY = "Wähle aus, ob beim Anklicken von Reagenzien im Berufsfenster eine Modifikatortaste erforderlich ist."