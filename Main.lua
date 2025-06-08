local addonTable = select(2, ...)
local prevButton, nextButton
addonTable.pos = 0
addonTable.recipes = {}
addonTable.ignoreSelection = false

local function AddRecipeToHistory(recipeID)
    -- Truncate history if not at end
    if addonTable.pos < #addonTable.recipes then
        for i = #addonTable.recipes, addonTable.pos + 1, -1 do
            table.remove(addonTable.recipes, i)
        end
    end
    -- Add new recipe and move pointer
    table.insert(addonTable.recipes, recipeID)
    addonTable.pos = #addonTable.recipes
    print("Added to history. Position:", addonTable.pos)
end

EventRegistry:RegisterCallback("ProfessionsFrame.Show", function()
    if not prevButton and not nextButton then
        nextButton = CreateFrame("Button", nil, ProfessionsFrame)
        nextButton:SetSize(20, 20)
        nextButton:SetPoint("BOTTOM", ProfessionsFrame.CraftingPage.RecipeList.SearchBox, "TOP", 5, 10)
        nextButton.texture = nextButton:CreateTexture()
        nextButton.texture:SetAtlas("common-icon-forwardarrow")
        nextButton:SetNormalTexture(nextButton.texture)
        nextButton:SetHighlightAtlas("common-icon-forwardarrow", "ADD")

        nextButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Click to go forward", 1, 1, 1, 1, true)
            GameTooltip:Show()
        end)
        nextButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
        nextButton:SetScript("OnClick", function(self)
            local testIndex = addonTable.pos + 1
            if addonTable.recipes[testIndex] then
                addonTable.pos = testIndex
                print("Moved forward. Position:", addonTable.pos)
                addonTable.ignoreSelection = true
                C_TradeSkillUI.OpenRecipe(addonTable.recipes[addonTable.pos])
                PlaySound(SOUNDKIT.IG_CHAT_SCROLL_UP, "Master")
            end
        end)

        prevButton = CreateFrame("Button", "ReagentClickPrevButton", ProfessionsFrame)
        prevButton:SetSize(20, 20)
        prevButton:SetPoint("RIGHT", nextButton, "LEFT", -5, 0)
        prevButton.texture = prevButton:CreateTexture()
        prevButton.texture:SetAtlas("common-icon-backarrow")
        prevButton:SetNormalTexture(prevButton.texture)
        prevButton:SetHighlightAtlas("common-icon-backarrow", "ADD")

        prevButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Click to go back", 1, 1, 1, 1, true)
            GameTooltip:Show()
        end)
        prevButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
        prevButton:SetScript("OnClick", function(self)
            local testIndex = addonTable.pos - 1
            if addonTable.recipes[testIndex] then
                addonTable.pos = testIndex
                print("Moved backward. Position:", addonTable.pos)
                addonTable.ignoreSelection = true
                C_TradeSkillUI.OpenRecipe(addonTable.recipes[addonTable.pos])
                PlaySound(SOUNDKIT.IG_CHAT_SCROLL_DOWN, "Master")
            end
        end)

        nextButton:Show()
        prevButton:Show()
    end
end)

EventRegistry:RegisterCallback("ProfessionsFrame.Hide", function()
    addonTable.pos = 0
    addonTable.recipes = {}
end)

EventRegistry:RegisterCallback("ProfessionsRecipeListMixin.Event.OnRecipeSelected", function(_, recipe)
    if addonTable.ignoreSelection then
        addonTable.ignoreSelection = false
        return
    end
    if recipe.learned then
        AddRecipeToHistory(recipe.recipeID)
    end
end)