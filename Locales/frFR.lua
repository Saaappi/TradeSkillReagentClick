local addonTable = select(2, ...)
local L = addonTable.L or {}
addonTable.L = L

if GetLocale() ~= "frFR" then return end

L.TOOLTIP_DROPDOWN_MOD_KEY = "Choisissez si une touche de modification est requise pour cliquer sur les composants dans la fenêtre des métiers."