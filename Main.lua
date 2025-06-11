local addonTable = select(2, ...)
addonTable.pos = 0
addonTable.recipes = {}
addonTable.allRecipes = {}
addonTable.ignoreSelection = false
addonTable.itemToRecipeCache = {}

local function FindRecipeIDByItemID(itemID)
    if not itemID then return nil end
    local cached = addonTable.itemToRecipeCache[itemID]
    if cached then return cached end
    for _, r in ipairs(addonTable.allRecipes) do
        if r.itemID == itemID then
            addonTable.itemToRecipeCache[itemID] = r.recipeID
            return r.recipeID
        end
    end
    return nil
end

EventRegistry:RegisterCallback("ProfessionsFrame.Show", function()
    addonTable.recipes = {}
    addonTable.allRecipes = {}
    addonTable.itemToRecipeCache = {}

    C_Timer.After(2, function()
        local recipeIDs = C_TradeSkillUI.GetAllRecipeIDs()
        for _, recipeID in ipairs(recipeIDs) do
            local recipeInfo = C_TradeSkillUI.GetRecipeInfo(recipeID)
            if recipeInfo.learned then
                local outputLink = C_TradeSkillUI.GetRecipeItemLink(recipeID)
                if outputLink then
                    local itemID = C_Item.GetItemInfoInstant(outputLink)
                    if itemID then
                        table.insert(addonTable.allRecipes, { recipeID = recipeID, itemID = itemID })
                        addonTable.itemToRecipeCache[itemID] = recipeID
                    end
                end
            end
        end
    end)
end)

EventRegistry:RegisterCallback("ProfessionsRecipeListMixin.Event.OnRecipeSelected", function(_, recipe)
    C_Timer.After(0.15, function()
        local schematicForm = ProfessionsFrame.CraftingPage.SchematicForm
        local slots = schematicForm:GetSlots()
        if slots then
            for _, slot in ipairs(slots) do
                slot.Button:HookScript("OnClick", function(self, key)
                    if IsControlKeyDown() and key == "LeftButton" then
                        local recipeID = FindRecipeIDByItemID(self.item)
                        if recipeID then
                            C_TradeSkillUI.OpenRecipe(recipeID)
                        end
                    end
                end)
            end
        end
    end)
    if addonTable.ignoreSelection then
        addonTable.ignoreSelection = false
        return
    end
    if recipe.learned then
        table.insert(addonTable.recipes, recipe.recipeID)
    end
end)