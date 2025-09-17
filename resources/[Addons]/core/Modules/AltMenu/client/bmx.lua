local VehicleId = {}

local function IsPlayerInVehicle()
    return IsPedSittingInAnyVehicle(PlayerPedId())
end

local function IsPlayerNearBmx(Entity)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local bmxCoords = GetEntityCoords(Entity.ID)
    local distance = #(playerCoords - bmxCoords)

    return distance <= 3
end

RegisterNetEvent("iZeyy:BmxSys:SpawnCar", function()
    local ped = Client.Player:GetPed()

    if exports["core"]:PlayerIsInSafeZone() then
        return Game.Notification:showNotification("Vous ne pouvez pas sortir de BMX ici")
    end
    if IsPlayerInVehicle() then
        return Game.Notification:showNotification("Vous ne pouvez pas sortir de BMX en étant dans un véhicule")
    end

    TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)
    HUDProgressBar("Sortie du BMX..", 3, function()
        ClearPedTasks(ped)
        Wait(1500)
        Shared.Events:ToServer("iZeyy:BmxSys:SpawnCar")
    end)
end)


Shared.Events:OnNet("iZeyy:BmxSys:ReceiveInfo", function(VehId)
    if (VehId) then
        table.insert(VehicleId, NetworkGetEntityFromNetworkId(VehId))
    end
end)

local function CheckVehicleId(vehicle)
    for k, v in pairs(VehicleId) do
        if (v == vehicle) then
            return true
        end
    end
    return false
end

local function DeleteBmx(Entity)
    local ped = Client.Player:GetPed()

    TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)
    HUDProgressBar("Sortie du BMX..", 3, function()
        ClearPedTasks(ped)
        Wait(1500)
        Shared.Events:ToServer("iZeyy:BmxSys:DeleteCar", NetworkGetNetworkIdFromEntity(Entity))
    end)
end

InteractMenuBmx = Game.InteractContext:AddButton("vehicle_menu", "Ranger le BMX", nil, function(onSelected, Entity)
    if (onSelected) then
        DeleteBmx(Entity.ID)
    end
end, function(Entity)
    return CheckVehicleId(Entity.ID) and not IsPlayerInVehicle() and not IsPedInVehicle(PlayerPedId(), Entity.ID, false) and not DoesEntityExist(GetPedInVehicleSeat(Entity.ID, -1)) and IsPlayerNearBmx(Entity)
end)

Shared.Events:OnNet("iZeyy:BmxSys:DeleteCar", function(VehId)
    if (VehId) then
        for k, v in pairs(VehicleId) do
            if (v == NetworkGetEntityFromNetworkId(VehId)) then
                table.remove(VehicleId, k)
            end
        end
    end
end)