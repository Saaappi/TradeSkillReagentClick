local addonTable = select(2, ...)
local L = addonTable.L or {}
addonTable.L = L

if GetLocale() ~= "ruRU" then return end

L.TOOLTIP_DROPDOWN_MOD_KEY = "Выберите, требуется ли клавиша-модификатор при нажатии на реагенты в окне профессий."