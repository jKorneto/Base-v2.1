local Vehicles = {}

function Vehicles:openNearTrunks()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closeVehicleNetIds = {}

    if GetVehiclePedIsIn(playerPed, false) ~= 0 then return end

    local vehiclePool = GetGamePool('CVehicle')
    for i = 1, #vehiclePool do
        local veh = vehiclePool[i]
        local vehCoords = GetEntityCoords(veh)
        local dist = #(playerCoords - vehCoords)
        if dist < 5.0 and GetVehicleDoorLockStatus(veh) == 1 then
            closeVehicleNetIds[#closeVehicleNetIds + 1] = NetworkGetNetworkIdFromEntity(veh)
        end
    end

    if #closeVehicleNetIds > 0 then
        TriggerServerEvent("inventory:OPEN_NEAR_TRUNKS", closeVehicleNetIds)
    end
end

function Vehicles:openGlovebox()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if DoesEntityExist(vehicle) then
            TriggerServerEvent("inventory:OPEN_VEHICLE_GLOVEBOX_INVENTORY")
        end
    end
end

AddEventHandler("inventory:onInventoryOpen", function()
    Vehicles:openGlovebox()
    Vehicles:openNearTrunks()
end)
