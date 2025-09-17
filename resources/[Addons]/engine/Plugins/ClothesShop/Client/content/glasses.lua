local glasses_menu = clothesStorage:Get("glasses_menu")
local glasses = nil
local hasLoaded = false
local filter = {glasses = 1, variant = 1}
local price = Engine["Config"]["ClothesShop"]["Prices"]["glasses"]

glasses_menu:IsVisible(function(Items)
    local actualGlasses = (Client.ClothesShop:getActualClothe("glasses_1") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("glasses_1") + 1
    local actualGlassesVariant = (Client.ClothesShop:getActualClothe("glasses_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("glasses_2") + 1

    if (not hasLoaded) then
        glasses, variants = Client.ClothesShop:loadProps(1)
        filter.glasses = actualGlasses
        filter.variant = actualGlassesVariant

        glasses_menu:AddInstructionButton({
            GetControlInstructionalButton(0, 250, 0),
            "Rechercher"
        })

        hasLoaded = true
    end

    local RightBadgeGlasses = (actualGlasses == filter.glasses) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeVariant = (actualGlassesVariant == filter.variant and actualGlasses == filter.glasses) and RageUI.BadgeStyle.Clothes or nil

    Items:List("Lunettes", glasses, filter.glasses, nil, {RightBadge = RightBadgeGlasses}, true, {
        onListChange = function(index)
            filter.glasses = index
            filter.variant = 1

            if (filter.glasses == 1) then
                ClearPedProp(Client.Player:GetPed(), 1)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 1, filter.glasses - 1, filter.variant - 1, true)
        end
    })

    Items:List("Variantes", variants[filter.glasses - 1], filter.variant, nil, {RightBadge = RightBadgeVariant}, true, {
        onListChange = function(index)
            filter.variant = index

            if (filter.glasses == 1) then
                ClearPedProp(Client.Player:GetPed(), 1)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 1, filter.glasses - 1, filter.variant - 1, true)
        end
    })

    Items:Button("Payer", nil, {RightLabel = price.. " ~g~$~s~"}, true, {
        onSelected = function()
            local value = filter.glasses - 1
            local sex = (GetEntityModel(Client.Player:GetPed()) == GetHashKey("mp_m_freemode_01") and "male") or "female"

            if (filter.glasses == 1) then
                value = -1
            end

            local clothes = {   
                {component = "glasses_1", index = value, clothesType = "glasses", name = "Lunettes", variantComponent = "glasses_2", variant = filter.variant - 1},
                {component = "glasses_2", index = filter.variant - 1}
            }

            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.buyClothes, clothes, sex)
        end
    })

    CreateThread(function()
        if (IsControlJustPressed(1, 250)) then
            local number = Game.ImputText:KeyboardImput("Rechercher", {
                {type = "number", placeholder = ("Numéro de Lunettes (1-%s)"):format(#glasses), min = 1, max = #glasses, required = true}
            })
            
            filter.glasses = tonumber(number[1])
            filter.variant = 1

            if (filter.glasses == 1) then
                ClearPedProp(Client.Player:GetPed(), 1)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 1, filter.glasses - 1, filter.variant - 1, true)
        end
    end)
end, nil, function()
    Client.ClothesShop:createCamera()
    glasses_menu:RemoveInstructionButton({
        GetControlInstructionalButton(0, 250, 0)
    })
    hasLoaded = false
end)