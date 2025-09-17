RegisterNetEvent('OneLife:GangBuilder:TakeVehicle')
AddEventHandler('OneLife:GangBuilder:TakeVehicle', function(gangId, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Gang = MOD_GangBuilder:getGangById(gangId)

    if (Gang) then
        if (Gang:DoesPlayerExist(xPlayer)) then
            local vehicleMod = Gang:GetVehicle(plate)

            if (not Gang:IsVehicleOut(plate)) then
                if (vehicleMod) then
                    MOD_Vehicle:CreateVehicle(vehicleMod.data.model, Gang.posSpawnVeh, 0.0, plate, Gang.name, function(vehicle)

                        Gang:RemoveVehicle(plate, vehicle)

                        Wait(1000)
                        local ped = GetPlayerPed(xPlayer.source)
                        SetPedIntoVehicle(ped, vehicle:GetHandle(), -1)

                        vehicle:SetProperties(vehicleMod.data, xPlayer, function()
                            vehicle:SetLocked(false)
                        end)

                        Gang:UpdateEvent("OneLife:GangBuilder:ReceiveVehicle", plate, Gang:GetVehicle(plate))
                    end, xPlayer)
                end
            else
                xPlayer.showNotification("~s~Ce véhicule est indisponible, vous devez le retrouver là où vous l'avez laissé.")
            end

        end
    end
end)