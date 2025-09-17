local SpawnBmx = {}

Shared.Events:OnNet("iZeyy:BmxSys:SpawnCar", function(xPlayer)
    if (type(xPlayer) == "table") then
        local HasBmx = xPlayer.getInventoryItem(tostring(Config["Bmx"]["SpawnName"])).quantity

        if (tonumber(HasBmx) < 1) then
            ServershowNotification(xPlayer.source, "Vous n'avez pas de BMX sur vous", false)
            return
        end

        if (xPlayer.removeInventoryItem(tostring(Config["Bmx"]["SpawnName"]), 1)) then

            local SpawnName = tostring(Config["Bmx"]["SpawnName"])
            local PlayerPos = xPlayer.getCoords(true)

            if (IsSpawnPointClear(PlayerPos, 5)) then
                ESX.SpawnVehicle(tostring(SpawnName),  vector3(PlayerPos.x, PlayerPos.y + 0.5, PlayerPos.z), 0, nil, false, nil, function(vehicle)

                    if (not SpawnBmx[xPlayer.identifier]) then
                        SpawnBmx[xPlayer.identifier] = {}
                    end

                    table.insert(SpawnBmx[xPlayer.identifier], {
                        owner = xPlayer.identifier,
                        vehicle = vehicle
                    })

                    local VehicleId = NetworkGetNetworkIdFromEntity(vehicle:GetHandle())
                    Shared.Events:ToClient(xPlayer.source, "iZeyy:BmxSys:ReceiveInfo", VehicleId)
                end)
            else
                xPlayer.showNotification("La place est déja occupé par un véhicule")
            end
        end
    end
end)

Shared.Events:OnNet("iZeyy:BmxSys:DeleteCar", function(xPlayer, VehId)
    if (type(xPlayer) == "table") then
        local VehicleId = tonumber(VehId)
        local Vehicle = NetworkGetEntityFromNetworkId(VehicleId)

        if (Vehicle) and DoesEntityExist(Vehicle) then
            for k, v in pairs(SpawnBmx[xPlayer.identifier]) do
                if (v.vehicle:GetHandle() == Vehicle) then
                    if (xPlayer.canCarryItem(tostring(Config["Bmx"]["SpawnName"]), 1)) then
                        table.remove(SpawnBmx[xPlayer.identifier], k)
                        Shared.Events:ToClient(xPlayer.source, "iZeyy:BmxSys:DeleteCar", VehicleId)
                        DeleteEntity(Vehicle)
                        xPlayer.addInventoryItem(tostring(Config["Bmx"]["SpawnName"]), 1)
                    else
                        xPlayer.showNotification("Vous n'avez pas de place sur vous")
                    end
                end
            end
        end
    end
end)