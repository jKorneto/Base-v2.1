local accessories_menu = clothesStorage:Get("accessories_menu")
local accessories = nil
local hasLoaded = false
local filter = {accessorie = 1, variant = 1}
local price = Engine["Config"]["ClothesShop"]["Prices"]["accessories"]

accessories_menu:IsVisible(function(Items)
    local actualAccessory = (Client.ClothesShop:getActualClothe("chain_1") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("chain_1") + 1
    local actualAccessoryVariant = (Client.ClothesShop:getActualClothe("chain_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("chain_2") + 1

    if (not hasLoaded) then
        accessories, variants = Client.ClothesShop:loadClothes(7)
        filter.accessory = actualAccessory
        filter.variant = actualAccessoryVariant

        accessories_menu:AddInstructionButton({
            GetControlInstructionalButton(0, 250, 0),
            "Rechercher"
        })

        hasLoaded = true
    end

    local RightBadgeAccessory = (actualAccessory == filter.accessory) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeVariant = (actualAccessoryVariant == filter.variant and actualAccessory == filter.accessory) and RageUI.BadgeStyle.Clothes or nil

    Items:List("Accessoires", accessories, filter.accessory, nil, {RightBadge = RightBadgeAccessory}, true, {
        onListChange = function(index)
            filter.accessory = index
            filter.variant = 1

            SetPedComponentVariation(Client.Player:GetPed(), 7, filter.accessory - 1, filter.variant - 1, true)
        end
    })

    Items:List("Variantes", variants[filter.accessory - 1], filter.variant, nil, {RightBadge = RightBadgeVariant}, true, {
        onListChange = function(index)
            filter.variant = index

            SetPedComponentVariation(Client.Player:GetPed(), 7, filter.accessory - 1, filter.variant - 1, true)
        end
    })

    Items:Button("Payer", nil, {RightLabel = price.. " ~g~$~s~"}, true, {
        onSelected = function()
            local sex = (GetEntityModel(Client.Player:GetPed()) == GetHashKey("mp_m_freemode_01") and "male") or "female"

            local clothes = {
                {component = "chain_1", index = filter.accessory - 1, clothesType = "chains", name = "Chaine", variantComponent = "chain_2", variant = filter.variant - 1},
                {component = "chain_2", index = filter.variant - 1}
            }

            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.buyClothes, clothes, sex)
        end
    })

    CreateThread(function()
        if (IsControlJustPressed(1, 250)) then
            local number = Game.ImputText:KeyboardImput("Rechercher", {
                {type = "number", placeholder = ("Numéro d'Accessoire (1-%s)"):format(#accessories), min = 1, max = #accessories, required = true}
            })
            
            filter.accessory = tonumber(number[1])
            filter.variant = 1

            if (filter.accessory == 1) then
                ClearPedProp(Client.Player:GetPed(), 7)
                return
            end

            SetPedComponentVariation(Client.Player:GetPed(), 7, filter.accessory - 1, filter.variant - 1, true)
        end
    end)
end, nil, function()
    Client.ClothesShop:createCamera()
    accessories_menu:RemoveInstructionButton({
        GetControlInstructionalButton(0, 250, 0)
    })
    hasLoaded = false
end)
