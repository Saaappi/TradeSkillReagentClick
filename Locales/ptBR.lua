local addonTable = select(2, ...)
local L = addonTable.L or {}
addonTable.L = L

if GetLocale() ~= "ptBR" then return end

L.TOOLTIP_DROPDOWN_MOD_KEY = "Escolha se uma tecla modificadora é necessária ao clicar nos reagentes na janela de profissões."