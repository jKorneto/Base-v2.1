local shoes_menu = clothesStorage:Get("shoes_menu")
local shoes = nil
local hasLoaded = false
local filter = {shoe = 1, variant = 1}
local price = Engine["Config"]["ClothesShop"]["Prices"]["shoes"]

shoes_menu:IsVisible(function(Items)
    local actualShoe = (Client.ClothesShop:getActualClothe("shoes_1") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("shoes_1") + 1
    local actualShoeVariant = (Client.ClothesShop:getActualClothe("shoes_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("shoes_2") + 1

    if (not hasLoaded) then
        shoes, variants = Client.ClothesShop:loadClothes(6)
        filter.shoe = actualShoe
        filter.variant = actualShoeVariant

        shoes_menu:AddInstructionButton({
            GetControlInstructionalButton(0, 250, 0),
            "Rechercher"
        })

        hasLoaded = true
    end

    local RightBadgeShoe = (actualShoe == filter.shoe) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeVariant = (actualShoeVariant == filter.variant and actualShoe == filter.shoe) and RageUI.BadgeStyle.Clothes or nil

    Items:List("Chaussures", shoes, filter.shoe, nil, {RightBadge = RightBadgeShoe}, true, {
        onListChange = function(index)
            filter.shoe = index
            filter.variant = 1

            SetPedComponentVariation(Client.Player:GetPed(), 6, filter.shoe - 1, filter.variant - 1, true)
        end
    })

    Items:List("Variantes", variants[filter.shoe - 1], filter.variant, nil, {RightBadge = RightBadgeVariant}, true, {
        onListChange = function(index)
            filter.variant = index

            SetPedComponentVariation(Client.Player:GetPed(), 6, filter.shoe - 1, filter.variant - 1, true)
        end
    })

    Items:Button("Payer", nil, {RightLabel = price.. " ~g~$~s~"}, true, {
        onSelected = function()
            local sex = (GetEntityModel(Client.Player:GetPed()) == GetHashKey("mp_m_freemode_01") and "male") or "female"
            local clothes = {   
                {component = "shoes_1", index = filter.shoe - 1, clothesType = "shoes", name = "Chaussures", variantComponent = "shoes_2", variant = filter.variant - 1},
                {component = "shoes_2", index = filter.variant - 1}
            }

            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.buyClothes, clothes, sex)
        end
    })

    CreateThread(function()
        if (IsControlJustPressed(1, 250)) then
            local number = Game.ImputText:KeyboardImput("Rechercher", {
                {type = "number", placeholder = ("Numéro des Chaussures (1-%s)"):format(#shoes), min = 1, max = #shoes, required = true}
            })

            filter.shoe = tonumber(number[1])
            filter.variant = 1

            SetPedComponentVariation(Client.Player:GetPed(), 6, filter.shoe - 1, filter.variant - 1, true)
        end
    end)
end, nil, function()
    Client.ClothesShop:createCamera()
    shoes_menu:RemoveInstructionButton({
        GetControlInstructionalButton(0, 250, 0)
    })
    hasLoaded = false
end)
