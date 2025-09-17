local main_menu = RageUI.AddMenu("", "Faites vos actions")

CreateThread(function()

    local Blip = AddBlipForCoord(Config["CenterJob"]["Pos"])
	SetBlipSprite(Blip, 590)
    SetBlipScale(Blip, 0.5)
    SetBlipColour(Blip, 2)
    SetBlipDisplay(Blip, 4)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Centre des Emplois")
    EndTextCommandSetBlipName(Blip)

    local Model = GetHashKey(Config["CenterJob"]["PedModel"])
    RequestModel(Model)
    while not HasModelLoaded(Model) do Wait(1) end
    local Ped = CreatePed(4, Model, Config["CenterJob"]["Ped"], Config["CenterJob"]["Heading"], false, true)
    FreezeEntityPosition(Ped, true)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, true)

    local CenterJobZone = Game.Zone("CenterJobZone")
    CenterJobZone:Start(function()
        CenterJobZone:SetTimer(1000)
        CenterJobZone:SetCoords(Config["CenterJob"]["Pos"]) 

        CenterJobZone:IsPlayerInRadius(10.0, function()
            CenterJobZone:SetTimer(0)

            CenterJobZone:Marker()
            CenterJobZone:IsPlayerInRadius(3.0, function()
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                CenterJobZone:KeyPressed("E", function()
                    main_menu:Toggle()
                end)
            end)
        end)
    end)
end)

main_menu:IsVisible(function(Items)
    Items:Button("Démissionner de votre Job", nil, {}, true, {
        onSelected = function()
            TriggerServerEvent("iZeyy:CenterJob:Resign")
        end
    })
    Items:Line()
    for k, v in pairs(Config["CenterJob"]["FreeJob"]) do
        Items:Button(v.label, nil, {}, true, {
            onSelected = function()
                SetNewWaypoint(v.pos)
                ESX.ShowNotification("Un point GPS a etait ajouté a votre cartes rendez vous sur place pour faire vos premier dollars")
            end
        })
    end
end)