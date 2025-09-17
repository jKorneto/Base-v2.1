local vehicles_menu = shopStorage:Get("vehicles_menu")
local limited_vehicles_menu = shopStorage:Get("limited_vehicles_menu")

local vehiclesActions = {
    list = {
        "Acheter",
        "Visualiser"
    },

    index = 1,
    vehicleIndex = 1
}

vehicles_menu:IsVisible(function(Items)
    local vehicles = Engine["Config"]["Shop"]["vehicles"]

    Items:Button("Véhicules Limités", nil, {LeftBadge = RageUI.BadgeStyle.Star}, true, {
        onActive = function()
            vehiclesActions.vehicleIndex = "limited"
        end,
        onSelected = function()
            Client.Shop:requestLimitedVehicles()
        end
    }, limited_vehicles_menu)

    Items:Line()

    for i = 1, #vehicles do
        local vehicle = vehicles[i]

        Items:List(vehicle.label, vehiclesActions.list, vehiclesActions.index, nil, {}, true, {
            onActive = function()
                vehiclesActions.vehicleIndex = i
            end,
            onListChange = function(index)
                vehiclesActions.index = index
            end,
            onSelected = function(index)
                if (index == 1) then
                    Client.Shop:buyVehicle(i)
                elseif (index == 2) then
                    Client.Shop:enterPreview(vehicle.name)
                end
            end
        })
    end
end, function(Panels)
    local shopID = Shared.Math:GroupDigits(Client.Player:GetUniqueID())
    local coins = Shared.Math:GroupDigits(Client.Shop:getCoins())
    local isVip = Client.Vip:isPlayerVip()
    local vehiclePrice = vehiclesActions.vehicleIndex == "limited" and 0 or Client.Shop:getVehiclePrice(vehiclesActions.vehicleIndex)
    local vipInfo = not isVip and "~r~Deviens VIP pour profiter de réductions sur les véhicules !" or nil
    local multiplier, reduction = Client.Shop:getReduction()
    local vipPrice = vehiclePrice * multiplier
    local finalPrice = isVip and vipPrice or vehiclePrice
    local price = ""
    local limitedShow = false

    if (vehiclesActions.vehicleIndex == "limited") then
        limitedShow = true
    else
        limitedShow = false
    end

    if (finalPrice == 0) then
        price = "~g~Gratuit"
    elseif (isVip) then
        price = "~b~"..Shared.Math:GroupDigits(math.floor(finalPrice)).." ~s~(VIP -"..reduction.."%)"
    else
        price = "~b~"..Shared.Math:GroupDigits(math.floor(finalPrice))..""
    end
    
    Panels:info("Boutique",
        {"ID Boutique :", "OneCoins :", not limitedShow and "Prix :" or vipInfo, not limitedShow and vipInfo or nil},
        {"~b~"..shopID, "~b~"..coins, not limitedShow and price or nil}
    )
end, function()
    Client.Shop:leavePreview()
end)

limited_vehicles_menu:IsVisible(function(Items)
    local limitedVehicles = Client.Shop:getLimitedVehicles()

    if (limitedVehicles ~= nil) then
        if (next(limitedVehicles) ~= nil) then
            for i = 1, #limitedVehicles do
                local vehicle = limitedVehicles[i]

                Items:List(vehicle.label, vehiclesActions.list, vehiclesActions.index, nil, {}, true, {
                    onActive = function()
                        vehiclesActions.vehicleIndex = i
                    end,
                    onListChange = function(index)
                        vehiclesActions.index = index
                    end,
                    onSelected = function(index)
                        if (index == 1) then
                            Client.Shop:buyLimitedVehicle(i)
                        elseif (index == 2) then
                            Client.Shop:enterPreview(vehicle.model)
                        end
                    end
                })
            end
        else
            Items:Separator("Aucun véhicule limité disponible")
        end
    else
        Items:Separator("Chargement des véhicules limités...")
    end
end, function(Panels)
    local shopID = Shared.Math:GroupDigits(Client.Player:GetUniqueID())
    local coins = Shared.Math:GroupDigits(Client.Shop:getCoins())
    local isVip = Client.Vip:isPlayerVip()
    local vehiclePrice = vehiclesActions.vehicleIndex == "limited" and 0 or Client.Shop:getLimitedVehiclePrice(vehiclesActions.vehicleIndex)
    local vehicleQuantity = vehiclesActions.vehicleIndex == "limited" and 0 or Client.Shop:getLimitedVehicleQuantity(vehiclesActions.vehicleIndex)
    local vipInfo = not isVip and "~r~Deviens VIP pour profiter de réductions sur les véhicules !" or nil
    local multiplier, reduction = Client.Shop:getReduction()
    local vipPrice = vehiclePrice * multiplier
    local finalPrice = isVip and vipPrice or vehiclePrice
    local limitedVehicles = Client.Shop:getLimitedVehicles()
    local price = ""

    if (limitedVehicles ~= nil) then
        if (finalPrice == 0) then
            price = "~g~Gratuit"
        elseif (isVip) then
            price = "~b~"..Shared.Math:GroupDigits(math.floor(finalPrice)).." ~s~(VIP -"..reduction.."%)"
        else
            price = "~b~"..Shared.Math:GroupDigits(math.floor(finalPrice))..""
        end
        
        Panels:info("Boutique",
            {"ID Boutique :", "OneCoins :", next(limitedVehicles) ~= nil and "Quantité :" or nil, next(limitedVehicles) ~= nil and "Prix :" or nil, next(limitedVehicles) ~= nil and vipInfo or nil},
            {"~b~"..shopID, "~b~"..coins, next(limitedVehicles) ~= nil and vehicleQuantity or nil, next(limitedVehicles) ~= nil and price or nil}
        )
    end
end)



Shared.Events:OnNet(Engine["Enums"].Shop.Events.receiveLimitedCommand, function()
    local imput = Game.ImputText:KeyboardImput("Ajouter un véhicule limité", {
        {type = "input", placeholder = "Model du véhicule", required = true},
        {type = "input", placeholder = "Label du véhicule", required = true},
        {type = "number", placeholder = "Quantité de véhicule", required = true},
        {type = "number", placeholder = "Prix du véhicule", required = true}
    })

    if (imput ~= nil) then
        if (Game.ImputText:InputIsValid(imput[1], "string")
        and Game.ImputText:InputIsValid(imput[2], "string") 
        and Game.ImputText:InputIsValid(tostring(imput[3]), "number") 
        and Game.ImputText:InputIsValid(tostring(imput[4]), "number")) then
            Shared.Events:ToServer(Engine["Enums"].Shop.Events.addLimitedVehicle, imput[1], imput[2], imput[3], imput[4])
        else
            Game.Notification:showNotification("Les informations saisies sont invalides", false)
        end
    end
end)