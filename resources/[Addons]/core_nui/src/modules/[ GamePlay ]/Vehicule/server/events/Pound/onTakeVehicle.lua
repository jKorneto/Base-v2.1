RegisterNetEvent('OneLife:Pound:TakeVehicle')
AddEventHandler('OneLife:Pound:TakeVehicle', function(vehiclePlate, positionOut)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vPlate = vehiclePlate

    if (xPlayer) then
        local PoundSpawnV = OneLife.enums.Pound.Prices['SpawnVehicle']
        local Notif = "Vous avez payé ".. PoundSpawnV .."~s~$"
    
        if xPlayer.GetVIP() then 
            PoundSpawnV = 0
            Notif = "L'assurance à pris en charge les honoraires !"
        end

        if (MOD_Vehicle.vehiclesOut[vPlate]) then
            if (DoesEntityExist(MOD_Vehicle.vehiclesOut[vPlate])) then
                TriggerClientEvent('OneLife:Pound:RefreshVehicles', xPlayer.source)
                return xPlayer.showNotification("~s~Vous devez aller chercher votre véhicule là où vous l'avez stationné, s'il vous a été voler merci de contacter les forces de l'ordre.")
            end

            MOD_Vehicle.vehiclesOut[vPlate] = nil
        end

        local Bill = ESX.CreateBill(0, xPlayer.source, PoundSpawnV, "Fourriere", "server") 
        if Bill then

            MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND stored = 0", {
                ["@owner"] = xPlayer.getIdentifier(),
                ["@plate"] = vPlate
            }, function(result)
                if (#result > 0) then
                    local ped = GetPlayerPed(xPlayer.source)
                    local props = json.decode(result[1].vehicle)

                    if (positionOut) then
                    
                        if not xPlayer.GetVIP() then 
                            xPlayer.removeAccountMoney("cash", PoundSpawnV)
                        end

                        TriggerClientEvent('OneLife:Pound:RefreshVehicles', xPlayer.source)

                        MOD_Vehicle:CreateVehicle(props.model, positionOut, positionOut["heading"], result[1].plate, xPlayer.getIdentifier(), function(vehicle, defaultProperties)
                            MOD_Vehicle.vehiclesOut[result[1].plate] = vehicle:GetHandle()

                            xPlayer.showNotification(Notif)

                            Wait(1000)
                            local ped = GetPlayerPed(xPlayer.source)
                            SetPedIntoVehicle(ped, vehicle:GetHandle(), -1)

                            vehicle:SetProperties(props, xPlayer, function()
                                vehicle:SetLocked(true)
                            end)
                        end, xPlayer)

                    else
                        TriggerClientEvent('OneLife:Pound:RefreshVehicles', xPlayer.source)
                        xPlayer.showNotification("~s~Une erreur est survenue")
                    end
                else
                    TriggerClientEvent('OneLife:Pound:RefreshVehicles', xPlayer.source)
                    xPlayer.showNotification("~s~Une erreur est survenue")
                end
            end)

        end
    end
end)