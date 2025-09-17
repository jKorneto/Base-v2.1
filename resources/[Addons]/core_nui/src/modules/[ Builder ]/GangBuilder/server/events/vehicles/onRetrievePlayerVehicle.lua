RegisterNetEvent('OneLife:GangBuilder:RetrievePlayerVehicle')
AddEventHandler('OneLife:GangBuilder:RetrievePlayerVehicle', function(gangId, vehiclePlate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Gang = MOD_GangBuilder:getGangById(gangId)

    if (Gang) then
        if (Gang:DoesPlayerExist(xPlayer)) then
            local vehicle = Gang:GetVehicle(vehiclePlate)

            if (vehicle) then
                local owner = Gang:GetVehicleOwner(vehiclePlate)

                if (owner) then
                    if (owner == xPlayer.getIdentifier()) then
                        MySQL.Async.execute("INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (@owner, @plate, @vehicle, @type, @stored)", {
                            ["owner"] = owner,
                            ["plate"] = vehiclePlate,
                            ["vehicle"] = json.encode(Gang:GetVehicleProps(vehiclePlate)),
                            ["type"] = "car",
                            ["stored"] = 1
                        }, function()
                            local manageVehicle = MOD_Vehicle:GetVehicleByPlate(vehiclePlate)

                            if (manageVehicle) then
                                MOD_Vehicle:RemoveVehicle(vehiclePlate)
                            end

                            Gang:DeleteVehicle(vehiclePlate)

                            Gang:UpdateEvent("OneLife:GangBuilder:ReceiveVehicle", plate, Gang:GetVehicle(plate))

                            xPlayer.showNotification("~s~Votre véhicule a été ranger dans votre garage personnel.")
                        end)
                    end
                end
            end
        end
    end
end)