local RecolteKeyPressed = false
local SellKeyPressed = false

local function StartRecolte()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    TaskStartScenarioAtPosition(playerPed, "WORLD_HUMAN_STAND_FISHING", playerCoords.x, playerCoords.y, playerCoords.z, heading, -1, false, true)
    SetTimeout(10000, function()
        ClearPedTasks(playerPed)
        TriggerServerEvent("iZeyy:Fishing:Recolte")
    end)
end


local function StartSell()
    TriggerServerEvent("iZeyy:Fishing:Sell")
end

CreateThread(function()

    local Blip = AddBlipForCoord(Config["Fishing"]["RecolteBlips"])
    SetBlipSprite(Blip, 762)
    SetBlipScale(Blip, 0.5)
    SetBlipColour(Blip, 3)
    SetBlipDisplay(Blip, 4)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config["Fishing"]["RecolteBlipsLabel"])
    EndTextCommandSetBlipName(Blip)

    local RecolteZone = Game.Zone("RecolteZone")

    RecolteZone:Start(function()
        RecolteZone:SetTimer(1000)
        RecolteZone:SetCoords(Config["Fishing"]["RecoltePos"])

        RecolteZone:IsPlayerInRadius(8.0, function()
            RecolteZone:SetTimer(0)
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour pecher")

            RecolteZone:IsPlayerInRadius(8.0, function()

                RecolteZone:KeyPressed("E", function()
                    if not (IsPedSwimming(PlayerPedId())) then
                        if not RecolteKeyPressed then
                            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                                RecolteKeyPressed = true
                                StartRecolte()
                                SetTimeout(4000, function()
                                    RecolteKeyPressed = false
                                end)
                            else
                                ESX.ShowNotification("Vous ne pouvez pas pecher en voiture")
                            end
                        end
                    else
                        ESX.ShowNotification("Vous ne pouvez pas pecher en nageant")
                    end
                end)

            end, false, false)
        end, false, false)
    end)

    local Blip = AddBlipForCoord(Config["Fishing"]["SellPos"])
    SetBlipSprite(Blip, 456)
    SetBlipScale(Blip, 0.7)
    SetBlipColour(Blip, 3)
    SetBlipDisplay(Blip, 4)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config["Fishing"]["SellBlipsLabel"])
    EndTextCommandSetBlipName(Blip)

    local Model = GetHashKey(Config["Fishing"]["PedModel"])
    RequestModel(Model)
    while not HasModelLoaded(Model) do Wait(1) end
    local Ped = CreatePed(4, Model, Config["Fishing"]["SellPedPos"], Config["Fishing"]["SellPedHeading"], false, true)
    FreezeEntityPosition(Ped, true)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, true)

    local SellZone = Game.Zone("SellZone")

    SellZone:Start(function()
        SellZone:SetTimer(1000)
        SellZone:SetCoords(Config["Fishing"]["SellPos"])

        SellZone:IsPlayerInRadius(5.0, function()
            SellZone:SetTimer(0)
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour vendre")

            SellZone:IsPlayerInRadius(5.0, function()

                SellZone:KeyPressed("E", function()
                    if not SellKeyPressed then
                        if not IsPedInAnyVehicle(PlayerPedId(), false) then
                            SellKeyPressed = true
                            StartSell()
                            SetTimeout(4000, function()
                                SellKeyPressed = false
                            end)
                        else
                            ESX.ShowNotification("Vous ne pouvez pas vendre en voiture")
                        end
                    end
                end)

            end, false, false)
        end, false, false)
    end)
end)