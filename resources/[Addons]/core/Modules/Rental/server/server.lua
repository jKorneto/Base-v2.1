local RentalVehicles = {}

---@param type string
---@param owner string
---@return boolean
local function hasRental(type, owner)
    if (RentalVehicles[type]) then
        for k, v in pairs(RentalVehicles[type]) do
            if (v.owner == owner) then
                return true
            end
        end
    end

    return false
end

RegisterNetEvent("core:rental:rentVehicle", function(type, index, model, time)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (not hasRental(type, xPlayer.identifier)) then
            local RentalData = Config["Rental"]["Vehicles"][type][index]
            local vehicle = Config["Rental"]["Vehicles"][type][index].model[model]
            local timer = Config["Rental"]["Times"][time].time
            local price = Config["Rental"]["Times"][time].price

            if (vehicle) then
                local bill = ESX.CreateBill(0, xPlayer.source, price, "Location de véhicule", "server")

                if (bill) then

                    ESX.SpawnVehicle(model, RentalData.spawn, RentalData.spawnHeading, nil, false, xPlayer, xPlayer.identifier, function(vehicle)
                        local vehPlate = vehicle:GetPlate()

                        if (vehPlate) then
                            if (not RentalVehicles[type]) then
                                RentalVehicles[type] = {}
                            end

                            table.insert(RentalVehicles[type], {
                                owner = xPlayer.identifier,
                                source = xPlayer.source,
                                vehicle = vehicle,
                                plate = vehiclePlate,
                                time = os.time() + (timer * 60)
                            })
                        end
                    end)

                end
            end
        else
            xPlayer.showNotification("Vous avez déja une location en cours")
        end
    end
end)

RegisterNetEvent(Enums.Player.Events.PlayerLoaded, function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        if (RentalVehicles[xPlayer.identifier]) then
            RentalVehicles[xPlayer.identifier].source = xPlayer.source
        end
    end
end)

CreateThread(function()
    while true do
        Wait(60000)

        for type, vehicles in pairs(RentalVehicles) do
            for k, rentalData in pairs(vehicles) do
                local currentTime = os.time()

                if (rentalData.time <= currentTime) then
                    local vehicle = rentalData.vehicle
                    local plate = rentalData.plate
                    local player = GetPlayerPed(rentalData.source)
                    local dist = nil
    
                    if (player ~= 0) then
                        local playerPos = GetEntityCoords(player)
                        local vehiclePos = GetEntityCoords(vehicle:GetHandle())
                        dist = #(playerPos - vehiclePos)
                    end
    
                    if (dist and dist <= 50) then
                        local netId = NetworkGetNetworkIdFromEntity(vehicle:GetHandle())
                        TriggerClientEvent("core:rental:leaveVehicle", rentalData.source, netId)
                        SetVehicleDoorsLocked(vehicle:GetHandle(), 2)
                    else
                        SetVehicleDoorsLocked(vehicle:GetHandle(), 2)
                    end

                    vehicles[k] = nil
                end
            end
        end
    end
end)