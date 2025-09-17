local speedLimit = Config["AntiCheat"]["SpeedLimit"]
local checkingSpeed = false
local secuCode = Config["AntiCheat"]["SecuCode"]
local inVehicle = false

AddEventHandler("gameEventTriggered", function(name, args)
    if (name == "CEventNetworkPlayerEnteredVehicle") then
        local player = PlayerPedId()

        CreateThread(function()
            while true do
                Wait(1000)
                
                local vehicle = GetVehiclePedIsIn(player, false)

                if (vehicle ~= 0) then
                    if (GetPedInVehicleSeat(vehicle, -1) == player) then
                        if not inVehicle then
                            inVehicle = true
                        end
                        
                        local speed = GetEntitySpeed(vehicle) * 3.6
                        local playerCoords = GetEntityCoords(player)
                        
                        if (playerCoords.z <= -2) then
                            Shared.Log:Info("^7[^4AntiCheat^7] => Vous etes sous la carte.")
                        else
                            if (speed > speedLimit) then
                                local speedValue = string.format("%.0f", speed)
                            local reason = ("SpeedLimit - %s Kmh"):format(speedValue)
                            TriggerServerEvent("Core:AntiCheat:Ban", reason, secuCode)
                            end
                        end
                    end
                else
                    if (inVehicle) then
                        inVehicle = false
                        break
                    end
                end
            end
        end)
    end
end)