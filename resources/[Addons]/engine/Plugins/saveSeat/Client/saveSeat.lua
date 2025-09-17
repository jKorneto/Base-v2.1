local function requestVehicleByNetID(networkID)
    if (type(networkID) == "number") then
        local tries = 0

        while (not NetworkDoesNetworkIdExist(networkID)) do
            tries += 1

            if (tries >= 200) then
                break
            end

            Wait(10)
        end

        return tries < 200
    end
end

Shared.Events:OnNet(Engine["Enums"].Vehicles.Events.ReceiveSeat, function(networkID, vehiclePosition, seatIndex, maxPassengers)
    if (type(networkID) == "number" and type(vehiclePosition) == "vector3" and type(seatIndex) == "number" and type(maxPassengers) == "number") then
        local player = Client.Player:GetPed()

        DoScreenFadeOut(1000)

        while not IsScreenFadedOut() do
            Wait(0)
        end

        SetEntityVisible(player, false)
        NetworkSetEntityInvisibleToNetwork(player, true)
        SetEntityProofs(player, false, true, true, true)
        SetEntityCoords(player, vehiclePosition.x, vehiclePosition.y, vehiclePosition.z)

        if (requestVehicleByNetID(networkID)) then
            local vehicle = NetToVeh(networkID)

            if (vehicle ~= 0 and DoesEntityExist(vehicle)) then
                if (GetPedInVehicleSeat(vehicle, seatIndex) == 0) then
                    SetPedIntoVehicle(player, vehicle, seatIndex)
                else
                    for i = -1, maxPassengers do
                        local pedInSeat = GetPedInVehicleSeat(vehicle, i)

                        if (pedInSeat == 0) then
                            SetPedIntoVehicle(player, vehicle, i)
                            break
                        end
                    end
                end
            end
        end

        SetEntityVisible(player, true)
        NetworkSetEntityInvisibleToNetwork(player, false)
        SetEntityProofs(player, false, false, false, false)

        Wait(1000)
        DoScreenFadeIn(1000)
    end
end)