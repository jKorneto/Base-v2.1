local mainMenu = RageUI.AddMenu("", "Faites vos actions")
local interaction = RageUI.AddSubMenu(mainMenu, "", "Interactions avec le kidnappé")
local vehicle = RageUI.AddSubMenu(interaction, "", "Interactions véhicule")

mainMenu:SetSpriteBanner("commonmenu", "interaction_illegal")
mainMenu:SetButtonColor(0, 137, 201, 255)
interaction:SetSpriteBanner("commonmenu", "interaction_illegal")
interaction:SetButtonColor(0, 137, 201, 255)
vehicle:SetSpriteBanner("commonmenu", "interaction_illegal")
vehicle:SetButtonColor(0, 137, 201, 255)

CreateThread(function()
    while ESX.GetPlayerData().job2 == nil do
		Wait(500)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job)
    ESX.PlayerData.job2 = job
end)

mainMenu:IsVisible(function()

    if not exports.core:PlayerIsInSafeZone() and not exports.core:isPlayerHandcuff() and not exports.epicenter:IsInPorter() and not exports.epicenter:IsInOtage() then

        Items:Button("Interaction avec l'individu", nil, { RightLabel = "→→" }, true, {}, interaction)

        Items:Button("Interaction véhicule", nil, { RightLabel = "→→" }, true, {}, vehicle)

    else

        Items:Separator("")
        Items:Separator("~s~Action impossible en safe zone")	
        Items:Separator("")

    end

end)

interaction:IsVisible(function()

    local ped = PlayerPedId()
    local player, distance = ESX.Game.GetClosestPlayer()
    local coords = GetEntityCoords(ped)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local getPlayerSearch = GetPlayerPed(player)
    local isHandsUP = IsEntityPlayingAnim(getPlayerSearch, 'random@mugging3', 'handsup_standing_base', 3)
    local isHandcuff = IsEntityPlayingAnim(getPlayerSearch, 'mp_arresting', 'idle', 3)
    local isInVehicle = IsPedInAnyVehicle(getPlayerSearch, false)

    Items:Button("Fouiller le joueur", nil, {}, true, {
        onSelected = function()
            if player ~= -1 and distance <= 5.0 then
                if isHandsUP then
                    ExecuteCommand("me fouille l'individue")
                    TriggerServerEvent("iZeyy:gang:frisk", GetPlayerServerId(player))
                    RageUI.CloseAll()

                    CreateThread(function()
                        local Bool = true
                        while Bool do
                            local getPlayerSearch = GetPlayerPed(player)
                            local coords = GetEntityCoords(GetPlayerPed(-1))
                            local dist = #(GetEntityCoords(getPlayerSearch) - coords)
                            if (dist > 3) then
                                Bool = false
                                TriggerServerEvent("iZeyy:gang:close:frisk", GetPlayerServerId(player))
                            end
                            if not IsEntityPlayingAnim(getPlayerSearch, 'random@mugging3', 'handsup_standing_base', 3) then
                                Bool = false
                                TriggerServerEvent("iZeyy:gang:close:frisk", GetPlayerServerId(player))
                            end
                            Wait(100)
                        end
                    end)
                else
                    ESX.ShowNotification("La personne en face ne lève pas les mains")
                end
            else
                ESX.ShowNotification("Personne autour de vous")
            end
        end
    })

    Items:Button("Prendre la carte d'identité", nil, { RightLabel = "→" }, true, {
        onSelected = function()
            IdCard()
        end
    })
    
end)

vehicle:IsVisible(function()

    Items:Button("Crocheter le véhicule", nil, { RightLabel = "→" }, true, {
        onSelected = function()
            Crocheter()
        end
    })

end)

-- Prendre la carte d'identité
function IdCard()

    local Player, Dist = ESX.Game.GetClosestPlayer()
    local GetPlayerSearch = GetPlayerPed(Player)

    if Player ~= -1 and Dist <= 3.0 then

        if IsEntityPlayingAnim(GetPlayerSearch, 'random@mugging3', 'handsup_standing_base', 3) then

            TriggerServerEvent('aggressorMessage', GetPlayerServerId(Player))
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(Player), GetPlayerServerId(PlayerId()))
            interaction:Close()

        else
            ESX.ShowNotification("La personne en face ne lève pas les mains")
            TriggerServerEvent('victimMessage', GetPlayerServerId(Player))
        end
        
    else
        ESX.ShowNotification('~s~Personne autour de vous')
    end

end

-- Crochetage de véhicule
function Crocheter()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        ESX.ShowNotification("Vous ne pouvez pas voler de véhicule en étant dans un véhicule")
    else
        local vehicle = ESX.Game.GetVehicleInDirection()
        if DoesEntityExist(vehicle) then
            local plate = GetVehicleNumberPlateText(vehicle)
            local model = GetEntityModel(vehicle)
            local modelName = GetDisplayNameFromVehicleModel(model)
            local netID = NetworkGetNetworkIdFromEntity(vehicle)
            TriggerServerEvent("iZeyy:factionMenu:checkItems", plate, modelName, netID)
        end
    end
    
end

RegisterNetEvent("iZeyy:factionMenu:HasItems", function(plate, modelName, netID)
    local playerPed = PlayerPedId()
    
    if IsPedInAnyVehicle(playerPed, false) then
        ESX.ShowNotification("Vous ne pouvez pas voler de véhicule en étant dans un véhicule")
        return
    end

    if plate and modelName then
        local vehicle = NetworkGetEntityFromNetworkId(netID)

        if DoesEntityExist(vehicle) then
            local vehiclePos = GetEntityCoords(vehicle)
            StartVehicleAlarm(vehicle)
            SetVehicleAlarmTimeLeft(vehicle, 30000)
            RequestAnimDict("mini@repair")
            while not HasAnimDictLoaded("mini@repair") do
                Wait(100)
            end
            FreezeEntityPosition(PlayerPedId(), true)
            TaskPlayAnim(playerPed, "mini@repair", "fixing_a_ped", 3.0, -1, -1, 49, 0, false, false, false)
            Wait(10000)
            ClearPedTasks(playerPed)
            FreezeEntityPosition(PlayerPedId(), false)
            TriggerServerEvent("iZeyy:factionMenu:deblock", netID)
            ESX.ShowNotification("Un citoyens vous a vu volez le véhicule et a appelez le 911")
        end
    end
end)

-- Oen F7 Menu
RegisterCommand("f7", function()

    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.name ~= "unemployed2" and ESX.PlayerData.job2.name ~= "unemployed" then
        mainMenu:Toggle()
    end

end)

Shared:RegisterKeyMapping("iZeyy:factionInteractMenu:use", { label = "open_menu_factionInteract" }, "F7", function()

    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.name ~= "unemployed2" and ESX.PlayerData.job2.name ~= "unemployed" then
        mainMenu:Toggle()
    end
    
end)