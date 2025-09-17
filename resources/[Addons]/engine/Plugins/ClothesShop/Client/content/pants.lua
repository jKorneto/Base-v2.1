local pants_menu = clothesStorage:Get("pants_menu")
local pants = nil
local hasLoaded = false
local filter = {pant = 1, variant = 1}
local price = Engine["Config"]["ClothesShop"]["Prices"]["pants"]

pants_menu:IsVisible(function(Items)
    local actualPant = (Client.ClothesShop:getActualClothe("pants_1") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("pants_1") + 1
    local actualPantVariant = (Client.ClothesShop:getActualClothe("pants_2") + 1) == 0 and 1 or Client.ClothesShop:getActualClothe("pants_2") + 1

    if (not hasLoaded) then
        pants, variants = Client.ClothesShop:loadClothes(4)
        filter.pant = actualPant
        filter.variant = actualPantVariant

        pants_menu:AddInstructionButton({
            GetControlInstructionalButton(0, 250, 0),
            "Rechercher"
        })

        hasLoaded = true
    end

    local RightBadgePant = (actualPant == filter.pant) and RageUI.BadgeStyle.Clothes or nil
    local RightBadgeVariant = (actualPantVariant == filter.variant and actualPant == filter.pant) and RageUI.BadgeStyle.Clothes or nil

    Items:List("Pantalon", pants, filter.pant, nil, {RightBadge = RightBadgePant}, true, {
        onListChange = function(index)
            filter.pant = index
            filter.variant = 1

            SetPedComponentVariation(Client.Player:GetPed(), 4, filter.pant - 1, filter.variant - 1, true)
        end
    })

    Items:List("Variantes", variants[filter.pant - 1], filter.variant, nil, {RightBadge = RightBadgeVariant}, true, {
        onListChange = function(index)
            filter.variant = index

            SetPedComponentVariation(Client.Player:GetPed(), 4, filter.pant - 1, filter.variant - 1, true)
        end
    })

    Items:Button("Payer", nil, {RightLabel = price.. " ~g~$~s~"}, true, {
        onSelected = function()
            local sex = (GetEntityModel(Client.Player:GetPed()) == GetHashKey("mp_m_freemode_01") and "male") or "female"

            local clothes = {
                {component = "pants_1", index = filter.pant - 1, clothesType = "pants", name = "Pantalon", variantComponent = "pants_2", variant = filter.variant - 1},
                {component = "pants_2", index = filter.variant - 1}
            }

            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.buyClothes, clothes, sex)
        end
    })

    CreateThread(function()
        if (IsControlJustPressed(1, 250)) then
            local number = Game.ImputText:KeyboardImput("Rechercher", {
                {type = "number", placeholder = ("Numéro de Pantalon (1-%s)"):format(#pants), min = 1, max = #pants, required = true}
            })
            
            filter.pant = tonumber(number[1])
            filter.variant = 1

            SetPedComponentVariation(Client.Player:GetPed(), 4, filter.pant - 1, filter.variant - 1, true)
        end
    end)
end, nil, function()
    Client.ClothesShop:createCamera()
    pants_menu:RemoveInstructionButton({
        GetControlInstructionalButton(0, 250, 0)
    })
    hasLoaded = false
end)

