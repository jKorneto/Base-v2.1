local main_menu = RageUI.AddMenu("", "Faites vos actions")
local service_menu = RageUI.AddMenu("", "Faites vos actions")
local garage_menu = RageUI.AddMenu("", "Faites vos actions")
local InService = false

main_menu:SetSpriteBanner("commonmenu", "interaction_legal")
main_menu:SetButtonColor(0, 137, 201, 255)
service_menu:SetSpriteBanner("commonmenu", "interaction_legal")
service_menu:SetButtonColor(0, 137, 201, 255)
garage_menu:SetSpriteBanner("commonmenu", "interaction_legal")
garage_menu:SetButtonColor(0, 137, 201, 255)

local AgenceHomo = {
    StatusList = {
        "~s~Ouvertures",
        "~s~Fermutures",
        "~s~Recrutement"
    },
    StatusListIndex = 1,

    Name = "",
    Price = 250000,
    Interior = nil, 
    Weight = 1500,
    Pos = {
        Enter = nil,
        Exit = nil,
        Chest = nil
    },
    PropertyList = {
        ListName = {
            "~s~Entrepot Grand [~b~VIP~s~]",
            "~s~Entrepot Moyen",
            "~s~Entrepot Petit",
            -- Appart
            "~s~Appartement Moderne",
            "~s~Appartement Modeste",
            "~s~Appartement Luxueux #1",
            "~s~Appartement Luxueux #2",
            "~s~Appartement Luxueux #3",
            -- Villa
            "~s~Villa [~b~VIP~s~] #1",
            "~s~Villa [~b~VIP~s~] #2",
            -- Bureau
            "~s~Bureau [~b~VIP~s~] #1",
            "~s~Bureau #2"
            
        },
        ListValue = {
            "Entrepot1",
            "Entrepot2",
            "Entrepot3",
            "Appartement1",
            "Appartement2",
            "Appartement3",
            "Appartement4",
            "Appartement5",
            "Villa1",
            "Villa2",
            "Bureau1",
            "Bureau2"
        },
        ListNameIndex = 1,
        ListValueIndex = 1
    }
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    while ESX.GetPlayerData()["job"] == nil do
        Wait(2000)
    end
end)

local function SetUniform()
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config["Dynasty8"]["Uniform"].male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config["Dynasty8"]["Uniform"].female)
        end
    end)
end

CreateThread(function()
    local Blip = AddBlipForCoord(Config["Dynasty8"]["BlipsPos"])
	SetBlipSprite (Blip, 350)
	SetBlipDisplay(Blip, 4)
	SetBlipScale  (Blip, 0.5)
	SetBlipColour (Blip, 0)
	SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Agence Immobilière")
    EndTextCommandSetBlipName(Blip)

    local DynastyServiceZone = Game.Zone("DynastyServiceZone")

    DynastyServiceZone:Start(function()
        DynastyServiceZone:SetTimer(1000)
        DynastyServiceZone:SetCoords(Config["Dynasty8"]["ServicePos"]) 

        DynastyServiceZone:IsPlayerInRadius(10.0, function()
            DynastyServiceZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == "realestateagent" then
                DynastyServiceZone:Marker()

                DynastyServiceZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    DynastyServiceZone:KeyPressed("E", function()
                        service_menu:Toggle()
                    end)
                end)
            end
        end)
    end)

    local DynastyGarageZone = Game.Zone("DynastyGarageZone")

    DynastyGarageZone:Start(function()
        DynastyGarageZone:SetTimer(1000)
        DynastyGarageZone:SetCoords(Config["Dynasty8"]["CarMenuPos"]) 

        DynastyGarageZone:IsPlayerInRadius(10.0, function()
            DynastyGarageZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == "realestateagent" then
                DynastyGarageZone:Marker()

                DynastyGarageZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    DynastyGarageZone:KeyPressed("E", function()
                        garage_menu:Toggle()
                    end)
                end)
            end
        end)
    end)

    service_menu:IsVisible(function(Items)
        Items:Button("Prendre votre service", nil, {}, true, {
            onSelected = function()
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Wait(1000)
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("iZeyy:job:takeService", "realestateagent", true)
                SetUniform()
                InService = true
            end
        })
        Items:Button("Prendre votre fin de service", nil, {}, true, {
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
                TriggerServerEvent("iZeyy:job:takeService", "realestateagent", false)
                InService = false
            end 
        })
    end)

    garage_menu:IsVisible(function(Items)
        for k,v in pairs(Config["Dynasty8"]["VehList"]) do
            Items:Button(v.label, nil, { RightLabel = "Prendre →"}, true, {
                onSelected = function()
                    TriggerServerEvent("iZeyy:Dynasty8:SpawnVehicle", v.model, v.label)
                    garage_menu:Close()
                end
            })
        end
    end)

    main_menu:IsVisible(function(Items)
        if (InService) then
            Items:List("Status Entreprise", AgenceHomo.StatusList, AgenceHomo.StatusListIndex, nil, {}, true, {
                onListChange = function(index)
                    AgenceHomo.StatusListIndex = index
                end,
                onSelected = function(index)
                    TriggerServerEvent("iZeyy:Dynasty8:SendAnnoucement", AgenceHomo.StatusListIndex)
                end
            })
            Items:Button("Faire une Facture", nil, {}, true, {
                onSelected = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance < 5.0 then
                        local success, input = pcall(function()
                            return lib.inputDialog("Montant", {
                                {type = "number", label = "Indiquez un montant"},
                            })
                        end)
                
                        if not success then
                            return
                        elseif input == nil then
                            ESX.ShowNotification("Montant invalide")
                        else
                            local amount = input[1]
                            if tonumber(amount) == nil then
                                ESX.ShowNotification("Montant invalide")
                            else
                                ESX.ShowNotification("Facture envoyée avec succès !")
                                TriggerServerEvent('sendLogs:Facture', GetPlayerServerId(closestPlayer), amount)
                                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'realestateagent', "Dynasty 8", amount)
                            end
                        end
                    else
                        ESX.ShowNotification("Aucun joueur à proximité.")
                    end
                end
            })
            Items:Button("Crée une Proprieté", nil, {}, true, {
                onSelected = function ()
                    main_menu:Close()
                    ExecuteCommand("openProperties")
                end
            })
        else
            Items:Separator("")
            Items:Separator("Vous n'etes pas en service")
            Items:Separator("")
        end
    end)

end)

Shared:RegisterKeyMapping("iZeyy:Realestateagent:OpenMenu", { label = "open_menu_interactRealestateagent" }, "F6", function()
    local job = Client.Player:GetJob().name

    if job == "realestateagent" then
        main_menu:Toggle()
    end
end)