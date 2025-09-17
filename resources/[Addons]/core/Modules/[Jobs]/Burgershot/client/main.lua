local main_menu = RageUI.AddMenu("", "Faites vos actions")
local service_menu = RageUI.AddMenu("", "Faites vos actions")
local counter_menu = RageUI.AddMenu("", "Faites vos actions")
local garage_menu = RageUI.AddMenu("", "Faites vos actions")

local Burgershot = {
    Status = {
        "~b~Ouvert",
        "~b~Fermer",
        "~b~Recrutement"
    },
    StatusIndex = 1
}

local InService = false

main_menu:SetSpriteBanner("commonmenu", "interaction_legal")
main_menu:SetButtonColor(0, 137, 201, 255)
service_menu:SetSpriteBanner("commonmenu", "interaction_legal")
service_menu:SetButtonColor(0, 137, 201, 255)
counter_menu:SetSpriteBanner("commonmenu", "interaction_legal")
counter_menu:SetButtonColor(0, 137, 201, 255)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    while ESX.GetPlayerData()["job"] == nil do
        Wait(2000)
    end
end)

main_menu:IsVisible(function(Items)
    if (InService) then
        Items:Button("Faire une annonces", "~r~Cette action est reservé au Patron d'entreprise~s~", {}, true, {
            onSelected = function()             
                local success, inputs = pcall(function()
                    return lib.inputDialog("Annonce(s) BurgerShot", {
                        {type = "input", label = "Tapez votre Annonce", placeholer = "Ici"},
                    })
                end)
        
                if not success then
                    return
                elseif inputs == nil then
                    return
                end
        
                local announcements = inputs[1]

                if not announcements or #announcements < 10 then
                    return ESX.ShowNotification("Votre annonces doit contenir minimum 10 caractères")
                end

                TriggerServerEvent("izeyy:burgershot:sendAnnouncement", announcements)
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
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), "burgershot", "BurgerShot", price)
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

local function SetUniform(type)
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config["Burgershot"]["Uniform"][type].male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config["Burgershot"]["Uniform"][type].female)
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
            service_menu:Close()
            Wait(1000)
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent("iZeyy:job:takeService", "burgershot", true)
            SetUniform("service")
            InService = true
        end
    })
    Items:Button("Prendre la tenue Mascotte", nil, {}, true, {
        onSelected = function()
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            service_menu:Close()
            Wait(1000)
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent("iZeyy:job:takeService", "burgershot", true)
            SetUniform("mascotte")
            InService = true
        end
    })
    Items:Button("Fin de service", nil, {}, true, {
        onSelected = function()
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            service_menu:Close()
            Wait(1000)
            ClearPedTasks(PlayerPedId())
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
            TriggerServerEvent("iZeyy:job:takeService", "burgershot", false)
            InService = false
        end 
    })
end)

-- Cuisine
local function StartBurgerCreation()
    local PlayerPed = PlayerPedId()
    TaskStartScenarioInPlace(PlayerPed, 'PROP_HUMAN_BBQ', 0, true)
    SetTimeout(10000, function()
        ClearPedTasks(PlayerPed)
        TriggerServerEvent("iZeyy:BurgerShot:Coking", "burger")
    end)
end

local function StartFriesCreation()
    local PlayerPed = PlayerPedId()
    TaskStartScenarioInPlace(PlayerPed, 'PROP_HUMAN_BBQ', 0, true)
    SetTimeout(10000, function()
        ClearPedTasks(PlayerPed)
        TriggerServerEvent("iZeyy:BurgerShot:Coking", "fries")
    end)
end

local function StartDrinkCreation()
    local PlayerPed = PlayerPedId()
    TaskStartScenarioInPlace(PlayerPed, 'WORLD_HUMAN_STAND_IMPATIENT', 0, true)
    SetTimeout(5000, function()
        ClearPedTasks(PlayerPed)
        TriggerServerEvent("iZeyy:BurgerShot:Coking", "drink")
    end)
end

counter_menu:IsVisible(function(Items)
    Items:Line()
    Items:Button("Vendre un Menu", Config["Burgershot"]["Desc"], {}, true, {
        onSelected = function()
            if InService then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance < 5.0 then
                    local success, input = pcall(function()
                        return lib.inputDialog("Vente de Menu", {
                            {type = "number", label = "Entrez le prix de la commande"},
                        })
                    end)
    
                    if not success then
                        return
                    elseif input == nil then
                        ESX.ShowNotification("Entrez un texte Valide")
                    else
                        local price = input[1]
                        TriggerServerEvent("iZeyy:Burgershot:Sell", GetPlayerServerId(closestPlayer), price)
                    end
                else
                    ESX.ShowNotification("Aucun joueurs a coté de vous.")
                end
            else
                ESX.ShowNotification("Vous devez etre en service")
            end
        end
    })
end)

garage_menu:IsVisible(function(Items)
    for k, v in pairs(Config["Burgershot"]["Garage"]) do
        Items:Button(v.label, nil, {}, true, {
            onSelected = function()
                TriggerServerEvent("iZeyy:Burgershot:SpawnCar", v.label, v.model)
                garage_menu:Close()
            end
        })
    end
end)

-- Pos
CreateThread(function()

    local blip = AddBlipForCoord(Config["Burgershot"]["BurgerPos"])
	SetBlipSprite(blip, 106)
    SetBlipScale(blip, 0.5)
    SetBlipColour(blip, 5)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("BurgerShot")
    EndTextCommandSetBlipName(blip)

    local BurgerZone = Game.Zone("BurgershotServicePos")

    BurgerZone:Start(function()
        BurgerZone:SetTimer(1000)
        BurgerZone:SetCoords(Config["Burgershot"]["ServicePos"]) 

        BurgerZone:IsPlayerInRadius(10.0, function()
            BurgerZone:SetTimer(0)
            local job = Client.Player:GetJob().name
            if job == "burgershot" then 
                BurgerZone:Marker()
                BurgerZone:IsPlayerInRadius(1.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    BurgerZone:KeyPressed("E", function()
                        service_menu:Toggle()
                    end)
                end)
            end
        end)
    end)

    local BurgerZone = Game.Zone("BurgerCreationZone")
    BurgerZone:Start(function()
        BurgerZone:SetTimer(1000)
        BurgerZone:SetCoords(Config["Burgershot"]["BurgerPos"])

        BurgerZone:IsPlayerInRadius(10.0, function()
            BurgerZone:SetTimer(0) 
            local job = Client.Player:GetJob().name          
            if job == "burgershot" and InService then
                BurgerZone:Marker()
                BurgerZone:IsPlayerInRadius(1.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour faire un burger")
                    BurgerZone:KeyPressed("E", function()
                        StartBurgerCreation()
                    end)
                end)
            end
        end)
    end)

    local FriesZone = Game.Zone("FriesCreationZone")
    FriesZone:Start(function()
        FriesZone:SetTimer(1000)
        FriesZone:SetCoords(Config["Burgershot"]["FriesPos"])

        FriesZone:IsPlayerInRadius(10.0, function()
            FriesZone:SetTimer(0)
            local job = Client.Player:GetJob().name
            if job == "burgershot" and InService then
                FriesZone:Marker()
                FriesZone:IsPlayerInRadius(1.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour faire des frites")
                    FriesZone:KeyPressed("E", function()
                        StartFriesCreation()
                    end)
                end)
            end
        end)
    end)

    local DrinkZone = Game.Zone("DrinkCreationZone")
    DrinkZone:Start(function()
        DrinkZone:SetTimer(1000)
        DrinkZone:SetCoords(Config["Burgershot"]["DrinkPos"])

        DrinkZone:IsPlayerInRadius(10.0, function()
            DrinkZone:SetTimer(0)
            local job = Client.Player:GetJob().name
            if job == "burgershot" and InService then
                DrinkZone:Marker()
                DrinkZone:IsPlayerInRadius(1.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour remplir une boisson")
                    DrinkZone:KeyPressed("E", function()
                        StartDrinkCreation()
                    end)
                end)
            end
        end)
    end)

    for k, v in pairs(Config["Burgershot"]["CounterPos"]) do
        local CounterZone = Game.Zone("CounterZone_" .. k)
        CounterZone:Start(function()
            CounterZone:SetTimer(1000)
            CounterZone:SetCoords(v)

            CounterZone:IsPlayerInRadius(10.0, function()
                CounterZone:SetTimer(0)
                local job = Client.Player:GetJob().name
                if job == "burgershot" and InService then
                    CounterZone:Marker()
                    CounterZone:IsPlayerInRadius(1.0, function()
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au comptoir")
                        CounterZone:KeyPressed("E", function()
                            counter_menu:Toggle()
                        end)
                    end)
                end
            end)
        end)
    end

    local GarageZone = Game.Zone("GarageZone")
    GarageZone:Start(function()
        GarageZone:SetTimer(1000)
        GarageZone:SetCoords(Config["Burgershot"]["GaragePos"])

        GarageZone:IsPlayerInRadius(10.0, function()
            GarageZone:SetTimer(0)
            local job = Client.Player:GetJob().name
            if job == "burgershot" and InService then
                GarageZone:Marker()
                GarageZone:IsPlayerInRadius(1.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage")
                    GarageZone:KeyPressed("E", function()
                        garage_menu:Toggle()
                    end)
                end)
            end
        end)
    end)

    local GarageDeleteZone = Game.Zone("DeleteZone")

    GarageDeleteZone:Start(function()
        GarageDeleteZone:SetTimer(1000)
        GarageDeleteZone:SetCoords(Config["Burgershot"]["DeletePos"])

        GarageDeleteZone:IsPlayerInRadius(60, function()
            GarageDeleteZone:SetTimer(0)
            local job = Client.Player:GetJob().name

            if job == "burgershot" and InService then
                GarageDeleteZone:Marker(nil, nil, 3.0)
                GarageDeleteZone:IsPlayerInRadius(8.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule")
                    GarageDeleteZone:KeyPressed("E", function()
                        local ped = PlayerPedId()
                        local vehicle = GetVehiclePedIsIn(ped, false)

                        TaskLeaveVehicle(ped, vehicle, 0)
                        SetTimeout(2000, function()
                            DeleteEntity(vehicle)
                        end)
                    end)
                end, false, true)
            end
        end, false, true)
    end)

end)

-- F6
Shared:RegisterKeyMapping("iZeyy:Burgershot:OpenMenu", { label = "open_menu_interactBurgershot" }, "F6", function()
    local job = Client.Player:GetJob().name

    if job == "burgershot" then
        main_menu:Toggle()
    end
end)