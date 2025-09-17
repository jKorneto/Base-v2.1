local inVehicle = false

local function toggleNuiFrame(shouldShow)
    SendReactMessage('setVisible', shouldShow)
end

local function getLightState(vehicle)
    local retval, lightsOn, highbeamsOn = GetVehicleLightsState(vehicle)
    return (lightsOn == 1 or highbeamsOn == 1) and true or false
end

local function getEngineState(vehicle)
    local engine = GetIsVehicleEngineRunning(vehicle)
    return engine == 1 and true or false
end

local function enterVehicle(vehicle)
    toggleNuiFrame(true)

    CreateThread(function()
        while inVehicle and DoesEntityExist(vehicle) do
            local speed = math.floor(GetEntitySpeed(vehicle) * 3.6)
            local fuel = GetVehicleFuelLevel(vehicle)
            local engine = getEngineState(vehicle)
            local headlight = getLightState(vehicle)

            SendReactMessage('setIcons', { engine = engine, headlight = headlight })
            SendReactMessage('setFuel', fuel)
            SendReactMessage('setSpeed', speed)

            Wait(100)
        end
    end)
end

local function exitVehicle()
    toggleNuiFrame(false)
end

AddEventHandler("gameEventTriggered", function(name, args)
    if (name == "CEventNetworkPlayerEnteredVehicle") then
        local player = PlayerPedId()

        CreateThread(function()
            while true do
                local vehicle = GetVehiclePedIsIn(player, false)

                if vehicle ~= 0 and GetPedInVehicleSeat(GetVehiclePedIsIn(player, false), -1) then
                    if (not inVehicle) then
                        inVehicle = true
                        enterVehicle(vehicle)
                    end
                else
                    if (inVehicle) then
                        inVehicle = false
                        exitVehicle()
                        break
                    end
                end

                Wait(500)
            end
        end)
    end
end)