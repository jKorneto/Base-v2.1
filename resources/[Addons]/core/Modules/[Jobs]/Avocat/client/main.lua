local main_menu = RageUI.AddMenu("", "Faites vos actions")
local service_menu = RageUI.AddMenu("", "Faites vos actions")
local garage_menu = RageUI.AddMenu("", "Faites vos actions")

local InService = true

local Avocat = {
    Status = {
        "~b~Ouvert",
        "~b~Fermer",
        "~b~Recrutement"
    },
    StatusIndex = 1
}

main_menu:SetSpriteBanner("commonmenu", "interaction_legal")
main_menu:SetButtonColor(0, 137, 201, 255)
service_menu:SetSpriteBanner("commonmenu", "interaction_legal")
service_menu:SetButtonColor(0, 137, 201, 255)
garage_menu:SetSpriteBanner("commonmenu", "interaction_legal")
garage_menu:SetButtonColor(0, 137, 201, 255)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    while ESX.GetPlayerData()["job"] == nil do
        Wait(2000)
    end
end)

CreateThread(function()
    -- Blips
    local blip = AddBlipForCoord(Config["Avocat"]["EnterPos"])
	SetBlipSprite(blip, 269)
    SetBlipScale(blip, 0.5)
    SetBlipColour(blip, 0)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cabinet des Avocats")
    EndTextCommandSetBlipName(blip)

    -- Entrée
    local AvocatEnterZone = Game.Zone("AvocatEnterZone")

    AvocatEnterZone:Start(function()
        AvocatEnterZone:SetTimer(1000)
        AvocatEnterZone:SetCoords(Config["Avocat"]["EnterPos"]) 

        AvocatEnterZone:IsPlayerInRadius(10.0, function()
            AvocatEnterZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == 'avocat' then 
                AvocatEnterZone:Marker()

                AvocatEnterZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    AvocatEnterZone:KeyPressed("E", function()
                        SetEntityCoords(PlayerPedId(), Config["Avocat"]["ExitPos"])
                    end)
                end)
            end
        end)
    end)

    -- Sortie
    local AvocatExitZone = Game.Zone("AvocatExitZone")

    AvocatExitZone:Start(function()
        AvocatExitZone:SetTimer(1000)
        AvocatExitZone:SetCoords(Config["Avocat"]["ExitPos"]) 

        AvocatExitZone:IsPlayerInRadius(10.0, function()
            AvocatExitZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == 'avocat' then
                AvocatExitZone:Marker()

                AvocatExitZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    AvocatExitZone:KeyPressed("E", function()
                        SetEntityCoords(PlayerPedId(), Config["Avocat"]["EnterPos"])
                    end)
                end)
            end
        end)
    end)

    -- Service
    local AvocatServiceZone = Game.Zone("AvocatServiceZone")

    AvocatServiceZone:Start(function()
        AvocatServiceZone:SetTimer(1000)
        AvocatServiceZone:SetCoords(Config["Avocat"]["ServicePos"]) 

        AvocatServiceZone:IsPlayerInRadius(10.0, function()
            AvocatServiceZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == 'avocat' then
                AvocatServiceZone:Marker()

                AvocatServiceZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    AvocatServiceZone:KeyPressed("E", function()
                        service_menu:Toggle()
                    end)
                end)
            end
        end)
    end)

    -- Demande de SASP au PDP
    local AvocatHelpZone = Game.Zone("AvocatHelpZone")

    AvocatHelpZone:Start(function()
        AvocatHelpZone:SetTimer(1000)
        AvocatHelpZone:SetCoords(Config["Avocat"]["HelpPos"]) 

        AvocatHelpZone:IsPlayerInRadius(10.0, function()
            AvocatHelpZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == 'avocat' then
                AvocatHelpZone:Marker()

                AvocatHelpZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    AvocatHelpZone:KeyPressed("E", function()
                        TriggerServerEvent("iZeyy:Avocat:SendSignal")
                    end)
                end)
            end
        end)
    end)

    -- Garage
    local AvocatGarageZone = Game.Zone("AvocatGarageZone")

    AvocatGarageZone:Start(function()
        AvocatGarageZone:SetTimer(1000)
        AvocatGarageZone:SetCoords(Config["Avocat"]["CarMenuPos"]) 

        AvocatGarageZone:IsPlayerInRadius(10.0, function()
            AvocatGarageZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == 'avocat' then
                AvocatGarageZone:Marker()

                AvocatGarageZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    AvocatGarageZone:KeyPressed("E", function()
                        garage_menu:Toggle()
                    end)
                end)
            end
        end)
    end)
end)

-- Service
local function SetUniform()
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config["Avocat"]["Uniform"].male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config["Avocat"]["Uniform"].female)
        end
    end)
end

service_menu:IsVisible(function(Items)
    Items:Button("Prendre votre Service", nil, {}, true, {
        onSelected = function()
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Wait(1000)
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent("iZeyy:job:takeService", "avocat", true)
            SetUniform()
            InService = true
        end
    })
    Items:Button("Fin de service", nil, {}, true, {
        onSelected = function()
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Wait(1000)
            ClearPedTasks(PlayerPedId())
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
            TriggerServerEvent("iZeyy:job:takeService", "avocat", false)
            InService = false
        end 
    })
end)

-- F6
main_menu:IsVisible(function(Items)
    if (InService) then
        Items:List("Status entreprise", Avocat.Status, Avocat.StatusIndex, nil, {}, true, {
            onListChange = function(index)
                Avocat.StatusIndex = index
            end,
            onSelected = function(index)
                TriggerServerEvent("iZeyy:Avocat:SendAnnoucement", Avocat.StatusIndex)
            end
        })
        Items:Button("Faire une facture", nil, {}, true, {
            onSelected = function()
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance < 5.0 then
                    local success, input = pcall(function()
                        return lib.inputDialog("Montant", {
                            {type = "number", label = "Entrez votre prix"},
                        })
                    end)

                    if not success then
                        return
                    elseif input == nil then
                        ESX.ShowNotification("Entrez un texte Valide")
                    else
                        local price = input[1]
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'avocat', 'Cabinet des Avocat', price)
                    end
                else
                    ESX.ShowNotification("Aucun joueurs a coté de vous.")
                end
            end
        })
    else
        Items:Separator("")
        Items:Separator("Vous devez etre en service")
        Items:Separator("")
    end
end)

Shared:RegisterKeyMapping("iZeyy:Avocat:OpenMenu", { label = "open_menu_interactAvocat" }, "F6", function()
    local job = Client.Player:GetJob().name

    if job == "avocat" then
        main_menu:Toggle()
    end
end)

-- Garage
garage_menu:IsVisible(function(Items)
    if (InService) then
        for k, v in pairs(Config["Avocat"]["VehList"]) do
            Items:Button(v.label, nil, { RightLabel = "Prendre →"}, true, {
                onSelected = function()
                    TriggerServerEvent("iZeyy:Avocat:SpawnVehicle", v.model, v.label)
                    garage_menu:Close()
                end
            })
        end
    else
        Items:Separator("")
        Items:Separator("Vous devez etre en service")
        Items:Separator("")
    end
end)
