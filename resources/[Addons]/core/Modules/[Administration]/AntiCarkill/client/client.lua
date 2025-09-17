CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        
        for _, vehicle in pairs(GetGamePool('CVehicle')) do
            local vehiclePos = GetEntityCoords(vehicle)
            local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, vehiclePos.x, vehiclePos.y, vehiclePos.z)
            
            if distance < 10.0 then
                local driver = GetPedInVehicleSeat(vehicle, -1)
                if driver and driver ~= 0 then
                    SetEntityNoCollisionEntity(playerPed, vehicle, true)
                end
            end
        end
    end
end)
