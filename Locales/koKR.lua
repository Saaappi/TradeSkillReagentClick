local addonTable = select(2, ...)
local L = addonTable.L or {}
addonTable.L = L

if GetLocale() ~= "koKR" then return end

L.TOOLTIP_DROPDOWN_MOD_KEY = "전문 기술 창에서 시약을 클릭할 때 수정 키가 필요한지 선택합니다."