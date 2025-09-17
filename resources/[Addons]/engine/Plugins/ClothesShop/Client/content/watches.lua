local watches_menu = clothesStorage:Get("watches_menu")
local watches = nil
local hasLoaded = false
local filter = {watches = 1, variant = 1}
local price = Engine["Config"]["ClothesShop"]["Prices"]["watches"]

watches_menu:IsVisible(function(Items)
    local actualWatches = (Client.ClothesShop:getActualClothe("watches_1") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("watches_1") + 1
    local actualWatchesVariant = (Client.ClothesShop:getActualClothe("watches_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("watches_2") + 1

    if (not hasLoaded) then
        watches, variants = Client.ClothesShop:loadProps(6)
        filter.watches = actualWatches
        filter.variant = actualWatchesVariant

        watches_menu:AddInstructionButton({
            GetControlInstructionalButton(0, 250, 0),
            "Rechercher"
        })

        hasLoaded = true
    end

    local RightBadgeWatches = (actualWatches == filter.watches) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeVariant = (actualWatchesVariant == filter.variant and actualWatches == filter.watches) and RageUI.BadgeStyle.Clothes or nil

    Items:List("Montres", watches, filter.watches, nil, {RightBadge = RightBadgeWatches}, true, {
        onListChange = function(index)
            filter.watches = index
            filter.variant = 1

            if (filter.watches == 1) then
                ClearPedProp(Client.Player:GetPed(), 6)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 6, filter.watches - 1, filter.variant - 1, true)
        end
    })

    Items:List("Variantes", variants[filter.watches - 1], filter.variant, nil, {RightBadge = RightBadgeVariant}, true, {
        onListChange = function(index)
            filter.variant = index

            if (filter.watches == 1) then
                ClearPedProp(Client.Player:GetPed(), 6)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 6, filter.watches - 1, filter.variant - 1, true)
        end
    })

    Items:Button("Payer", nil, {RightLabel = price.. " ~g~$~s~"}, true, {
        onSelected = function()
            local value = filter.watches - 1
            local sex = (GetEntityModel(Client.Player:GetPed()) == GetHashKey("mp_m_freemode_01") and "male") or "female"


            if (filter.watches == 1) then
                value = -1
            end

            local clothes = {   
                {component = "watches_1", index = value, clothesType = "watches", name = "Montre", variantComponent = "watches_2", variant = filter.variant - 1},
                {component = "watches_2", index = filter.variant - 1}
            }

            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.buyClothes, clothes, sex)
        end
    })

    CreateThread(function()
        if (IsControlJustPressed(1, 250)) then
            local number = Game.ImputText:KeyboardImput("Rechercher", {
                {type = "number", placeholder = ("Numéro de Montre (1-%s)"):format(#watches), min = 1, max = #watches, required = true}
            })
            
            filter.watches = tonumber(number[1])
            filter.variant = 1

            if (filter.watches == 1) then
                ClearPedProp(Client.Player:GetPed(), 6)
                return
            end

            SetPedPropIndex(Client.Player:GetPed(), 6, filter.watches - 1, filter.variant - 1, true)
        end
    end)
end, nil, function()
    Client.ClothesShop:createCamera()
    watches_menu:RemoveInstructionButton({
        GetControlInstructionalButton(0, 250, 0)
    })
    hasLoaded = false
end)
