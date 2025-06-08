local addonTable = select(2, ...)
addonTable.pos = 0
addonTable.recipes = {}
addonTable.allRecipes = {}
addonTable.ignoreSelection = false
addonTable.itemToRecipeCache = {}

local prevButton, nextButton

local function AddRecipeToHistory(recipeID)
    if addonTable.pos < #addonTable.recipes then
        for i = #addonTable.recipes, addonTable.pos + 1, -1 do
            table.remove(addonTable.recipes, i)
        end
    end
    table.insert(addonTable.recipes, recipeID)
    addonTable.pos = #addonTable.recipes
end

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

local function CreateNavButton(name, parent, point, relativeTo, relativePoint, x, y, textureAtlas, direction)
    local btn = CreateFrame("Button", name, parent)
    btn:SetSize(20, 20)
    btn:SetPoint(point, relativeTo, relativePoint, x, y)
    btn.texture = btn:CreateTexture()
    btn.texture:SetAtlas(textureAtlas)
    btn:SetNormalTexture(btn.texture)
    btn:SetHighlightAtlas(textureAtlas, "ADD")
    btn:SetFrameLevel(1000)
    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Click to go " .. direction, 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return btn
end

EventRegistry:RegisterCallback("ProfessionsFrame.Show", function()
    addonTable.pos = 0
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

    if not prevButton and not nextButton then
        nextButton = CreateNavButton(
            "ReagentClickNextButton",
            ProfessionsFrame,
            "RIGHT",
            ProfessionsFrame.CraftingPage.SchematicForm.TrackRecipeCheckbox,
            "LEFT",
            -5,
            0,
            "common-icon-forwardarrow",
            "forward"
        )
        nextButton:SetScript("OnClick", function()
            local testIndex = addonTable.pos + 1
            if addonTable.recipes[testIndex] then
                addonTable.pos = testIndex
                addonTable.ignoreSelection = true
                C_TradeSkillUI.OpenRecipe(addonTable.recipes[addonTable.pos])
                PlaySound(SOUNDKIT.IG_CHAT_SCROLL_UP, "Master")
            end
        end)

        prevButton = CreateNavButton(
            "ReagentClickPreviousButton",
            ProfessionsFrame,
            "RIGHT",
            nextButton,
            "LEFT",
            -5,
            0,
            "common-icon-backarrow",
            "back"
        )
        prevButton:SetScript("OnClick", function()
            local testIndex = addonTable.pos - 1
            if addonTable.recipes[testIndex] then
                addonTable.pos = testIndex
                addonTable.ignoreSelection = true
                C_TradeSkillUI.OpenRecipe(addonTable.recipes[addonTable.pos])
                PlaySound(SOUNDKIT.IG_CHAT_SCROLL_DOWN, "Master")
            end
        end)

        nextButton:Show()
        prevButton:Show()
    end
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
        AddRecipeToHistory(recipe.recipeID)
    end
end)