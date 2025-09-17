local function GetByNetworkId(networkId, callback)
    CreateThread(function()
        local obj = NetworkGetEntityFromNetworkId(networkId)
        local tries = 0

        while not DoesEntityExist(obj) do
            obj = NetworkGetEntityFromNetworkId(networkId)
            Wait(0)
            tries = tries + 1
            if tries > 250 then
                break
            end
        end

        if (callback) then callback(obj) end
    end)
end

local function RequestControl(vehicle, callback)
    CreateThread(function()
        if (DoesEntityExist(vehicle)) then

            while not NetworkHasControlOfEntity(vehicle) and DoesEntityExist(vehicle) do
                NetworkRequestControlOfEntity(vehicle)
                Wait(0)
            end

            if (callback) then callback() end
        end
    end)
end

-- RegisterNetEvent('OneLife:Vehicle:SetVehicleProperties', function(netId, properties)
--     local timer = GetGameTimer()
--     while not NetworkDoesEntityExistWithNetworkId(tonumber(netId)) do
--         Wait(0)
--         if GetGameTimer() - timer > 10000 then
--             return
--         end
--     end

--     local vehicle = NetToVeh(tonumber(netId))
--     local timer = GetGameTimer()
--     while NetworkGetEntityOwner(vehicle) ~= PlayerId() do
--         Wait(0)
--         if GetGameTimer() - timer > 10000 then
--             return
--         end
--     end

--     API_Vehicles:setProperties(vehicle, properties)
-- end)

RegisterNetEvent('OneLife:Vehicle:SetVehicleProperties', function(netId, properties)
    GetByNetworkId(netId, function(vehicle)
        local props = properties

        RequestControl(vehicle, function()
            API_Vehicles:setProperties(vehicle, props)
        end)
    end)
end)