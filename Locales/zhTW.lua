local addonTable = select(2, ...)
local L = addonTable.L or {}
addonTable.L = L

if GetLocale() ~= "zhTW" then return end

L.TOOLTIP_DROPDOWN_MOD_KEY = "選擇在專業技能視窗中點擊材料時是否需要按下修飾鍵鍵。"