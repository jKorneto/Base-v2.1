RegisterNetEvent('OneLife:Garage:TakeVehicle')
AddEventHandler('OneLife:Garage:TakeVehicle', function(vehiclePlate, positionOut)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vPlate = vehiclePlate

    if (xPlayer) then

        if (MOD_Vehicle:GetVehicleByPlate(vPlate)) then
            MySQL.Async.execute("UPDATE owned_vehicles SET stored = @stored WHERE plate = @plate", {
                ["@stored"] = 0,
                ["@plate"] = vPlate
            })

            TriggerClientEvent('OneLife:Garage:RefreshVehicles', xPlayer.source)

            return xPlayer.showNotification("~s~Vous devez aller chercher votre véhicule là où vous l'avez stationné, s'il vous a été voler merci de contacter les forces de l'ordre.")
        end

        MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND stored = 1", {
            ["owner"] = xPlayer.getIdentifier(),
            ["plate"] = vPlate
        }, function(result)
            if (#result > 0) then
                local ped = GetPlayerPed(xPlayer.source)
                local props = json.decode(result[1].vehicle)
                
                if (positionOut) then
                    TriggerClientEvent('OneLife:Garage:RefreshVehicles', xPlayer.source)

                    MOD_Vehicle:CreateVehicle(props.model, positionOut, positionOut["heading"], vPlate, xPlayer.getIdentifier(), function(vehicle, defaultProperties)

                        MOD_Vehicle.vehiclesOut[vPlate] = vehicle:GetHandle()

                        Wait(1000)
                        local ped = GetPlayerPed(xPlayer.source)
                        SetPedIntoVehicle(ped, vehicle:GetHandle(), -1)

                        vehicle:SetProperties(props, xPlayer, function()
                            vehicle:SetLocked(true)
                        end)
                        
                        MySQL.Async.execute("UPDATE owned_vehicles SET stored = @stored WHERE plate = @plate", {
                            ["@stored"] = 0,
                            ["@plate"] = vPlate
                        })
                    end, xPlayer)

                else
                    TriggerClientEvent('OneLife:Garage:RefreshVehicles', xPlayer.source)
                    xPlayer.showNotification("~s~Une erreur est survenue.")
                end

            else
                TriggerClientEvent('OneLife:Garage:RefreshVehicles', xPlayer.source)
                xPlayer.showNotification("~s~Une erreur est survenue.")
            end
        end)
    end
end)