local addonTable = select(2, ...)
local L = addonTable.L or {}
addonTable.L = L

if GetLocale() ~= "zhCN" then return end

L.TOOLTIP_DROPDOWN_MOD_KEY = "选择在专业技能窗口中点击材料时是否需要按下修饰键。"