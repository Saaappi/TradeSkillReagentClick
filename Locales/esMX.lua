local addonTable = select(2, ...)
local L = addonTable.L or {}
addonTable.L = L

if GetLocale() ~= "esMX" then return end

L.TOOLTIP_DROPDOWN_MOD_KEY = "	Elige si se necesita una tecla modificadora al hacer clic en los materiales en la ventana de profesiones."