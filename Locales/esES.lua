local addonTable = select(2, ...)
local L = addonTable.L or {}
addonTable.L = L

if GetLocale() ~= "esES" then return end

L.TOOLTIP_DROPDOWN_MOD_KEY = "Elige si se requiere una tecla modificadora al hacer clic en los componentes en la ventana de profesiones."