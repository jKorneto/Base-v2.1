local RecolteKeyPressed = false
local SellKeyPressed = false

local function StartRecolte()
    RequestAnimDict("amb@world_human_gardener_plant@male@base")
    while (not HasAnimDictLoaded("amb@world_human_gardener_plant@male@base")) do
        Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 1.0, -1.0, 4000, 0, 1, true, true, true)
    SetTimeout(4000, function()
        TriggerServerEvent("iZeyy:Tomates:Recolte")
    end)
end

local function StartSell()
    TriggerServerEvent("iZeyy:Tomates:Sell")
end

CreateThread(function()

    local Blip = AddBlipForCoord(Config["Tomates"]["RecolteBlips"])
    SetBlipSprite(Blip, 365)
    SetBlipScale(Blip, 0.8)
    SetBlipColour(Blip, 1)
    SetBlipDisplay(Blip, 4)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config["Tomates"]["RecolteBlipsLabel"])
    EndTextCommandSetBlipName(Blip)

    for k, v in pairs(Config["Tomates"]["RecoltePos"]) do
        local RecolteZone = Game.Zone("RecolteZone")

        RecolteZone:Start(function()
            RecolteZone:SetTimer(1000)
            RecolteZone:SetCoords(v.pos)

            RecolteZone:IsPlayerInRadius(8.0, function()
                RecolteZone:SetTimer(0)
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour recolter")

                RecolteZone:IsPlayerInRadius(8.0, function()

                    RecolteZone:KeyPressed("E", function()
                        if not RecolteKeyPressed then
                            if not IsPedInAnyVehicle(PlayerPedId(), false) then 
                                RecolteKeyPressed = true
                                StartRecolte()
                                SetTimeout(4000, function()
                                    RecolteKeyPressed = false
                                end)
                            else
                                ESX.ShowNotification("Vous ne pouvez pas recolter en voiture")
                            end
                        end
                    end)

                end, false, false)
            end, false, false)
        end)
    end

    local Blip = AddBlipForCoord(Config["Tomates"]["SellPos"])
    SetBlipSprite(Blip, 456)
    SetBlipScale(Blip, 0.7)
    SetBlipColour(Blip, 1)
    SetBlipDisplay(Blip, 4)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config["Tomates"]["SellBlipsLabel"])
    EndTextCommandSetBlipName(Blip)

    local Model = GetHashKey(Config["Tomates"]["PedModel"])
    RequestModel(Model)
    while not HasModelLoaded(Model) do Wait(1) end
    local Ped = CreatePed(4, Model, Config["Tomates"]["SellPedPos"], Config["Tomates"]["SellPedHeading"], false, true)
    FreezeEntityPosition(Ped, true)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, true)

    local SellZone = Game.Zone("SellZone")

    SellZone:Start(function()
        SellZone:SetTimer(1000)
        SellZone:SetCoords(Config["Tomates"]["SellPos"])

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