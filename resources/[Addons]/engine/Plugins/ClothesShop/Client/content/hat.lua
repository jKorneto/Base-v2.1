local hat_menu = clothesStorage:Get("hat_menu")
local hats = nil
local hasLoaded = false
local filter = {hat = 1, variant = 1}
local price = Engine["Config"]["ClothesShop"]["Prices"]["hats"]

hat_menu:IsVisible(function(Items)
    local actualHat = (Client.ClothesShop:getActualClothe("helmet_1") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("helmet_1") + 1
    local actualHatVariant = (Client.ClothesShop:getActualClothe("helmet_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("helmet_2") + 1

    if (not hasLoaded) then
        hats, variants = Client.ClothesShop:loadProps(0)
        filter.hat = actualHat
        filter.variant = actualHatVariant

        hat_menu:AddInstructionButton({
            GetControlInstructionalButton(0, 250, 0),
            "Rechercher"
        })

        hasLoaded = true
    end

    local RightBadgeHat = (actualHat == filter.hat) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeVariant = (actualHatVariant == filter.variant and actualHat == filter.hat) and RageUI.BadgeStyle.Clothes or nil

    Items:List("Chapeaux", hats, filter.hat, nil, {RightBadge = RightBadgeHat}, true, {
        onListChange = function(index)
            filter.hat = index
            filter.variant = 1

            if (filter.hat == 1) then
                ClearPedProp(Client.Player:GetPed(), 0)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 0, filter.hat - 1, filter.variant - 1, true)
        end
    })

    Items:List("Variantes", variants[filter.hat - 1], filter.variant, nil, {RightBadge = RightBadgeVariant}, true, {
        onListChange = function(index)
            filter.variant = index

            if (filter.hat == 1) then
                ClearPedProp(Client.Player:GetPed(), 0)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 0, filter.hat - 1, filter.variant - 1, true)
        end
    })
    
    Items:Button("Payer", nil, {RightLabel = price.. " ~g~$~s~"}, true, {
        onSelected = function()
            local value = filter.hat - 1
            local sex = (GetEntityModel(Client.Player:GetPed()) == GetHashKey("mp_m_freemode_01") and "male") or "female"

            if (filter.hat == 1) then
                value = -1
            end

            local clothes = {   
                {component = "helmet_1", index = value, clothesType = "hats", name = "Chapeau", variantComponent = "helmet_2", variant = filter.variant - 1},
                {component = "helmet_2", index = filter.variant - 1}
            }

            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.buyClothes, clothes, sex)
        end
    })

    CreateThread(function()
        if (IsControlJustPressed(1, 250)) then
            local number = Game.ImputText:KeyboardImput("Rechercher", {
                {type = "number", placeholder = ("Numéro de Chapeau (1-%s)"):format(#hats), min = 1, max = #hats, required = true}
            })
            
            filter.hat = tonumber(number[1])
            filter.variant = 1

            if (filter.hat == 1) then
                ClearPedProp(Client.Player:GetPed(), 0)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 0, filter.hat - 1, filter.variant - 1, true)
        end
    end)


end, nil, function()
    Client.ClothesShop:createCamera()
    hat_menu:RemoveInstructionButton({
        GetControlInstructionalButton(0, 250, 0)
    })
    hasLoaded = false
end)