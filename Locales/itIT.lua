local addonTable = select(2, ...)
local L = addonTable.L or {}
addonTable.L = L

if GetLocale() ~= "itIT" then return end

L.TOOLTIP_DROPDOWN_MOD_KEY = "Scegli se è necessario un tasto modificatore per cliccare sui reagenti nella finestra dei mestieri."