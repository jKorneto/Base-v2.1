local earring_menu = clothesStorage:Get("earring_menu")
local earrings = nil
local hasLoaded = false
local filter = {earring = 1, variant = 1}
local price = Engine["Config"]["ClothesShop"]["Prices"]["earrings"]

earring_menu:IsVisible(function(Items)
    local actualEarring = (Client.ClothesShop:getActualClothe("ears_1") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("ears_1") + 1
    local actualEarringVariant = (Client.ClothesShop:getActualClothe("ears_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("ears_2") + 1

    if (not hasLoaded) then
        earrings, variants = Client.ClothesShop:loadProps(2)
        filter.earring = actualEarring
        filter.variant = actualEarringVariant

        earring_menu:AddInstructionButton({
            GetControlInstructionalButton(0, 250, 0),
            "Rechercher"
        })

        hasLoaded = true
    end

    local RightBadgeEarring = (actualEarring == filter.earring) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeVariant = (actualEarringVariant == filter.variant and actualEarring == filter.earring) and RageUI.BadgeStyle.Clothes or nil

    Items:List("Accessoires d'oreilles", earrings, filter.earring, nil, {RightBadge = RightBadgeEarring}, true, {
        onListChange = function(index)
            filter.earring = index
            filter.variant = 1

            if (filter.earring == 1) then
                ClearPedProp(Client.Player:GetPed(), 2)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 2, filter.earring - 1, filter.variant - 1, true)
        end
    })

    Items:List("Variantes", variants[filter.earring - 1], filter.variant, nil, {RightBadge = RightBadgeVariant}, true, {
        onListChange = function(index)
            filter.variant = index

            if (filter.earring == 1) then
                ClearPedProp(Client.Player:GetPed(), 2)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 2, filter.earring - 1, filter.variant - 1, true)
        end
    })

    Items:Button("Payer", nil, {RightLabel = price.. " ~g~$~s~"}, true, {
        onSelected = function()
            local value = filter.earring - 1
            local sex = (GetEntityModel(Client.Player:GetPed()) == GetHashKey("mp_m_freemode_01") and "male") or "female"

            if (filter.earring == 1) then
                value = -1
            end

            local clothes = {   
                {component = "ears_1", index = value, clothesType = "earrings", name = "Accessoires d'oreille", variantComponent = "ears_2", variant = filter.variant - 1},
                {component = "ears_2", index = filter.variant - 1}
            }

            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.buyClothes, clothes, sex)
        end
    })

    CreateThread(function()
        if (IsControlJustPressed(1, 250)) then
            local number = Game.ImputText:KeyboardImput("Rechercher", {
                {type = "number", placeholder = ("Numéro d'Accessoires d'oreille (1-%s)"):format(#earrings), min = 1, max = #earrings, required = true}
            })
            
            filter.earring = tonumber(number[1])
            filter.variant = 1

            if (filter.earring == 1) then
                ClearPedProp(Client.Player:GetPed(), 2)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 2, filter.earring - 1, filter.variant - 1, true)
        end
    end)
end, nil, function()
    Client.ClothesShop:createCamera()
    earring_menu:RemoveInstructionButton({
        GetControlInstructionalButton(0, 250, 0)
    })
    hasLoaded = false
end)