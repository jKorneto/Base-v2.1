local main_menu = RageUI.AddMenu("", "Faite vos actions")
local InGoFast = false

local GoFast = {}

CreateThread(function()
    
    local StartGofastZone = Game.Zone("StartGofastZone")

    StartGofastZone:Start(function()
        StartGofastZone:SetTimer(1000)
        StartGofastZone:SetCoords(Config["GoFast"]["Pos"]) 

        StartGofastZone:IsPlayerInRadius(5.0, function()
            StartGofastZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job ~= "police" then 
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

                StartGofastZone:IsPlayerInRadius(2.0, function()
                    StartGofastZone:KeyPressed("E", function()
                        main_menu:Toggle()
                    end)
                end, false, false)
            end
        end, false, false)

        StartGofastZone:RadiusEvents(3.0, nil, function()
            main_menu:Close()
        end)
    end)

    local Model = GetHashKey(Config["GoFast"]["Ped"])
    RequestModel(Model)
    while not HasModelLoaded(Model) do
        Wait(10)
    end
    local Ped = CreatePed(9, Model, Config["GoFast"]["Pos"], Config["GoFast"]["PosHeading"], false, true)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, true)
    FreezeEntityPosition(Ped, true)

    main_menu:IsVisible(function(Items)
        Items:Button("Commencer le GoFast", nil, {}, true, {
            onSelected = function()
                TriggerServerEvent("OneLife:GoFast:Start")
                InGoFast = true
            end
        })
    end)

end)

RegisterNetEvent("OneLife:GoFast:Start", function(GoFastInfo)
    if (InGoFast) then
        GoFast = {
            isActive = GoFastInfo.isActive,
            endPos = GoFastInfo.endpos
        }
        
        if (GoFast.isActive) then
            GoFastBlip = AddBlipForCoord(GoFast.endPos)
            SetBlipSprite(GoFastBlip, 1)
            SetBlipScale(GoFastBlip, 0.5)
            SetBlipColour(GoFastBlip, 5)
            SetBlipDisplay(GoFastBlip, 4)
            SetBlipAsShortRange(GoFastBlip, true)
            SetBlipRoute(GoFastBlip, true)
            SetBlipRouteColour(GoFastBlip, 5)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Fin du GoFast")
            EndTextCommandSetBlipName(GoFastBlip)
    
            local EndGoFastZone = Game.Zone("EndGoFastZone")

            EndGoFastZone:Start(function()
                EndGoFastZone:SetTimer(1000)
                EndGoFastZone:SetCoords(GoFast.endPos) 
        
                EndGoFastZone:IsPlayerInRadius(5.0, function()
                    EndGoFastZone:SetTimer(0)
                    local playerData = ESX.GetPlayerData()
                    local job = playerData.job.name
        
                    if job ~= "police" then 
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour finir le gofast")
        
                        EndGoFastZone:IsPlayerInRadius(5.0, function()
                            EndGoFastZone:KeyPressed("E", function()
                                local ped = PlayerPedId()
                                local vehicle = GetVehiclePedIsIn(ped, false)
                                local vehiclePlate = GetVehicleNumberPlateText(vehicle)
                                TaskLeaveVehicle(ped, vehicle, 0)
                                InGoFast = false
                                GoFast = {
                                    isActive = false,
                                    endPos = nil
                                }
                                RemoveBlip(GoFastBlip)
                                TriggerServerEvent("OneLife:GoFast:End", vehiclePlate)
                                EndGoFastZone:Stop()
                            end)
                        end, false, true)
                    end
                end, false, true)
        
            end)

        else
            RemoveBlip(GoFastBlip)
            EndGoFastZone:Stop()
        end
    end
end)