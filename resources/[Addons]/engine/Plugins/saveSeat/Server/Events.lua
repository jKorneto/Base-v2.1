local saveSeat = {}

local function requestVehicle(source)
    local tries = 0
    local ped = GetPlayerPed(source)

    while (GetVehiclePedIsIn(ped, false) == 0) do
        tries += 1

        if (tries >= 200) then
            break
        end

        Wait(250)
    end

    return tries < 200
end

local function doesSaveSeatExist(identifier)
    return saveSeat[identifier] ~= nil
end

local function getSeatData(identifier)
    return saveSeat[identifier]
end

local function addSeatData(identifier, vehicle, seatIndex, maxPassengers)
    if (saveSeat[identifier] == nil) then
        saveSeat[identifier] = {
            vehicle = vehicle,
            seatIndex = seatIndex,
            maxPassengers = maxPassengers
        }
    end
end

local function editSeatData(identifier, key, value)
    if (doesSaveSeatExist(identifier)) then
        saveSeat[identifier][key] = value
    end
end

local function removeSeatData(identifier)
    if (doesSaveSeatExist(identifier)) then
        saveSeat[identifier] = nil
    end
end

Shared.Events:OnNet(Engine["Enums"].Vehicles.Events.PlayerEnteredVehicle, function(xPlayer, seatIndex, maxPassengers)
    if (type(xPlayer) == "table" and type(seatIndex) == "number" and type(maxPassengers) == "number") then
        if (requestVehicle(xPlayer.source)) then
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(xPlayer.source), false)
            addSeatData(xPlayer.identifier, vehicle, seatIndex, maxPassengers)
        end
    end
end)

Shared.Events:OnNet(Engine["Enums"].Vehicles.Events.SwitchVehicleSeat, function(xPlayer, seatIndex)
    if (type(xPlayer) == "table" and type(seatIndex) == "number") then
        if (doesSaveSeatExist(xPlayer.identifier)) then
            editSeatData(xPlayer.identifier, "seatIndex", seatIndex)
        end
    end
end)

Shared.Events:OnNet(Engine["Enums"].Vehicles.Events.LeftVehicle, function(xPlayer)
    if (type(xPlayer) == "table") then
        if (doesSaveSeatExist(xPlayer.identifier)) then
            removeSeatData(xPlayer.identifier)
        end
    end
end)

Shared.Events:OnNet(Engine["Enums"].Vehicles.Events.RequestSeat, function(xPlayer)
    if (type(xPlayer) == "table") then
        if (doesSaveSeatExist(xPlayer.identifier)) then
            local data = getSeatData(xPlayer.identifier)
            local vehicle = data.vehicle
            local seatIndex = data.seatIndex
            local maxPassengers = data.maxPassengers

            if (vehicle and DoesEntityExist(vehicle)) then
                local vehiclePosition = GetEntityCoords(vehicle)
                local networkID = NetworkGetNetworkIdFromEntity(vehicle)

                Shared.Log:Info(string.format("Player ^7[^0id: ^4%s^0, identifier: ^4%s^0, name: ^4%s^0] has spawn in vehicle. (seat: ^4%s^0)",
                    xPlayer.source, xPlayer.identifier, xPlayer.name, seatIndex
                ))

                Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Vehicles.Events.ReceiveSeat, networkID, vehiclePosition, seatIndex, maxPassengers)
            end

            removeSeatData(xPlayer.identifier)
        end
    end
end)

Server:OnPlayerDropped(function(xPlayer)
    if (doesSaveSeatExist(xPlayer.identifier)) then
        local data = getSeatData(xPlayer.identifier)

        Shared.Log:Info(string.format("Player ^7[^0id: ^4%s^0, identifier: ^4%s^0, name: ^4%s^0] has left in vehicle. (seat: ^4%s^0)",
            xPlayer.source, xPlayer.identifier, xPlayer.name, data.seatIndex
        ))
    end
end)
