ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local isUnderWater = false

function CheckOxMask()
    ESX.TriggerServerCallback('server:hasOxygenMask', function(hasOxygenMask)
        local playerPed = GetPlayerPed(-1)
        if hasOxygenMask then
            SetPedMaxTimeUnderwater(playerPed, 600.0) -- 10 minutes
            ESX.ShowNotification("10 Minutes d'apnée disponible")
        else
            SetPedMaxTimeUnderwater(playerPed, 15.0) -- 15 seconds
            ESX.ShowNotification("15 Seconde d'apnée disponible")
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playerPed = GetPlayerPed(-1)

        if IsPedSwimmingUnderWater(playerPed) then
            if not isUnderWater then
                isUnderWater = true
                CheckOxMask()
            end
        else
            if isUnderWater then
                isUnderWater = false
            end
        end
    end
end)