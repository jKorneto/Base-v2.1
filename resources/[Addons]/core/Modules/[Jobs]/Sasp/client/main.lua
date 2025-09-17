local main_menu = RageUI.AddMenu("", "Faites vos actions")
local player_action_menu = RageUI.AddSubMenu(main_menu, "", "Faites vos actions")
local fine_menu = RageUI.AddSubMenu(player_action_menu, "", "Faites vos actions")
local vehicle_action_menu = RageUI.AddSubMenu(main_menu, "", "Faites vos actions")
local vehicle_info_menu = RageUI.AddSubMenu(vehicle_action_menu, "", "Faites vos actions")
local backup_menu = RageUI.AddSubMenu(main_menu, "", "Faites vos actions")
local object_menu = RageUI.AddSubMenu(main_menu, "", "Faites vos actions")
local delete_object_menu = RageUI.AddSubMenu(object_menu, "", "Faites vos actions")
local shield_menu = RageUI.AddSubMenu(main_menu, "", "Faites vos actions")

local armory_menu = RageUI.AddMenu("", "Faites vos actions")
local armory_menu_sub1 = RageUI.AddSubMenu(armory_menu, "", "Faites vos actions")
local armory_menu_sub2 = RageUI.AddSubMenu(armory_menu, "", "Faites vos actions")
local armory_menu_sub3 = RageUI.AddSubMenu(armory_menu, "", "Faites vos actions")
local garage_menu = RageUI.AddMenu("", "Faites vos actions")
local cloakroom_menu = RageUI.AddMenu("", "Faites vos actions")
local seized_trunk = RageUI.AddMenu("", "Faites vos actions")
local put_wepaon_seized = RageUI.AddSubMenu(seized_trunk, "", "Faites vos actions")


local isInService = false
local Amende = false
local CopHandCuff = false
local backupTimeout = false
local ShieldActive = false
local ShieldTimeout = false
local receiveInfo = {}
local IventoryWeapon = {}

isHandcuff = false
isEscort = false

main_menu:SetSpriteBanner("commonmenu", "interaction_legal")
main_menu:SetButtonColor(0, 137, 201, 255)
player_action_menu:SetSpriteBanner("commonmenu", "interaction_legal")
player_action_menu:SetButtonColor(0, 137, 201, 255)
fine_menu:SetSpriteBanner("commonmenu", "interaction_legal")
fine_menu:SetButtonColor(0, 137, 201, 255)
vehicle_action_menu:SetSpriteBanner("commonmenu", "interaction_legal")
vehicle_action_menu:SetButtonColor(0, 137, 201, 255)
vehicle_info_menu:SetSpriteBanner("commonmenu", "interaction_legal")
vehicle_info_menu:SetButtonColor(0, 137, 201, 255)
backup_menu:SetSpriteBanner("commonmenu", "interaction_legal")
backup_menu:SetButtonColor(0, 137, 201, 255)
object_menu:SetSpriteBanner("commonmenu", "interaction_legal")
object_menu:SetButtonColor(0, 137, 201, 255)
delete_object_menu:SetSpriteBanner("commonmenu", "interaction_legal")
delete_object_menu:SetButtonColor(0, 137, 201, 255)
shield_menu:SetSpriteBanner("commonmenu", "interaction_legal")
shield_menu:SetButtonColor(0, 137, 201, 255)
armory_menu:SetSpriteBanner("commonmenu", "interaction_legal")
armory_menu:SetButtonColor(0, 137, 201, 255)
armory_menu_sub1:SetSpriteBanner("commonmenu", "interaction_legal")
armory_menu_sub1:SetButtonColor(0, 137, 201, 255)
armory_menu_sub2:SetSpriteBanner("commonmenu", "interaction_legal")
armory_menu_sub2:SetButtonColor(0, 137, 201, 255)
garage_menu:SetSpriteBanner("commonmenu", "interaction_legal")
garage_menu:SetButtonColor(0, 137, 201, 255)
cloakroom_menu:SetSpriteBanner("commonmenu", "interaction_legal")
cloakroom_menu:SetButtonColor(0, 137, 201, 255)
seized_trunk:SetSpriteBanner("commonmenu", "interaction_legal")
seized_trunk:SetButtonColor(0, 137, 201, 255)
put_wepaon_seized:SetSpriteBanner("commonmenu", "interaction_legal")
put_wepaon_seized:SetButtonColor(0, 137, 201, 255)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    while ESX.GetPlayerData()["job"] == nil do
        Wait(2000)
    end
end)

main_menu:IsVisible(function(Items)

    if isInService then
        local job = Client.Player:GetJob().grade_name
        if (job == "boss") then
            Items:Button("Faire une annonces", nil, {}, true, {
                onSelected = function()             
                    local success, inputs = pcall(function()
                        return lib.inputDialog("Annonce(s) SASP", {
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

                    TriggerServerEvent("izeyy:sasp:sendAnnouncement", announcements)
                end
            })
        end
        Items:Button("Action joueur", nil, {}, true, {}, player_action_menu)
        Items:Button("Action véhicule", nil, {}, true, {}, vehicle_action_menu)
        Items:Button("Bouclier", nil, {}, true, {}, shield_menu)
        Items:Button("Stopez les PNJ", nil, {}, not StopPNJCooldown, {
            onSelected = function()
                StopPNJCooldown = true
                SetTimeout(15 * 60 * 10, function()
                    StopPNJCooldown = false
                end)
                ExecuteCommand("arretpnj")
            end
        })
        Items:Button("Demande de renfort", nil, {}, true, {}, backup_menu)
        Items:Button("Objets", nil, {}, true, {}, object_menu)
    else
        Items:Separator("")
        Items:Separator("Vous devez être en service")
        Items:Separator("")
    end
end)

RegisterNetEvent('iZeyy:police:player:handcuff', function()
    local PlayerPed = PlayerPedId()
    local ControlsAction = {24, 257, 25, 21, 263, 45, 22, 44, 37, 23, 288, 289, 170, 167, 26, 73, 199, 59, 71, 72, 36, 47, 264, 257, 140, 141, 142, 143, 75, 75}

    CreateThread(function()
        local animDict = "mp_arrest_paired"
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(100)
        end
        TaskPlayAnim(PlayerPed, animDict, "crook_p2_back_right", 8.0, -8.0, 5500, 33, 0, false, false, false)
    end)

    isHandcuff = true

    CreateThread(function()
        if (isHandcuff) then
            local animDict = "mp_arresting"
            RequestAnimDict(animDict)
            while not HasAnimDictLoaded(animDict) do
                Wait(100)
            end
            TaskPlayAnim(PlayerPed, animDict, "idle", 1.0, -1.0, -1, 1, 1, false, false, false)
            SetEnableHandcuffs(PlayerPed, true)
            SetPedCanPlayGestureAnims(PlayerPed, false)

            while isHandcuff do
                if not IsEntityPlayingAnim(PlayerPed, animDict, "idle", 3) then
                    TaskPlayAnim(PlayerPed, animDict, "idle", 1.0, -1.0, -1, 1, 1, false, false, false)
                end
                
                for i=1, #ControlsAction do
                    DisableControlAction(0, ControlsAction[i], true)
                end
                Wait(1000)
            end
        else
            ClearPedTasks(PlayerPed)
            SetEnableHandcuffs(PlayerPed, false)
            SetPedCanPlayGestureAnims(PlayerPed, true)
        end
    end)
end)


RegisterNetEvent("iZeyy:police:cop:handcuff", function()
    local PlayerPed = PlayerPedId()

    CreateThread(function()
        local animDict = "mp_arrest_paired"
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(100)
        end
        TaskPlayAnim(PlayerPed, animDict, "cop_p2_back_right", 8.0, -8.0, 5500, 33, 0, false, false, false)
    end)
end)

RegisterNetEvent("iZeyy:police:player:unhandcuff", function()
    local PlayerPed = PlayerPedId()

    isHandcuff = false
    ClearPedTasksImmediately(PlayerPed)
    SetEnableHandcuffs(PlayerPed, false)
    SetPedCanPlayGestureAnims(PlayerPed, true)
    ESX.ShowNotification("Vous avez été démenotté.")
end)

exports("isPlayerHandcuff", function()
    return isHandcuff
end)

RegisterNetEvent('iZeyy:police:player:escort', function(cop)
    isEscort = not isEscort
    copPlayer = tonumber(cop)

    CreateThread(function()
        while true do
            Wait(0)
            local player = PlayerPedId()
            local cop = GetPlayerPed(GetPlayerFromServerId(copPlayer))

            if isHandcuff then

                if isEscort then
                    AttachEntityToEntity(player, cop, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                else
                    DetachEntity(player, true, false)
                    break
                end

            else
                break
            end
        end
    end)
end)

exports("isPlayerEscort", function()
    return isEscort
end)

RegisterNetEvent('iZeyy:police:player:putInVehicle', function()
    local player = PlayerPedId()
	local coords = GetEntityCoords(player)

	if not isHandcuff then
		return
	end

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(player, vehicle, freeSeat)
				isEscort = false
			end
		end
	end

end)

RegisterNetEvent('iZeyy:police:player:putOutVehicle', function()
	local player = PlayerPedId()

	if not IsPedSittingInAnyVehicle(player) then
		return
	end

	local vehicle = GetVehiclePedIsIn(player, false)
	TaskLeaveVehicle(player, vehicle, 16)

    SetTimeout(500, function()
        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do
            Wait(100)
        end

        TaskPlayAnim(player, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
    end)
end)

player_action_menu:IsVisible(function(Items)
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
                    TriggerServerEvent("iZeyy:police:frisk", GetPlayerServerId(player))
                    RageUI.CloseAll()

                    CreateThread(function()
                        local Bool = true
                        while Bool do
                            local getPlayerSearch = GetPlayerPed(player)
                            local coords = GetEntityCoords(GetPlayerPed(-1))
                            local dist = #(GetEntityCoords(getPlayerSearch) - coords)
                            if (dist > 3) then
                                Bool = false
                                TriggerServerEvent("iZeyy:police:close:frisk", GetPlayerServerId(player))
                            end
                            if not IsEntityPlayingAnim(getPlayerSearch, 'random@mugging3', 'handsup_standing_base', 3) then
                                Bool = false
                                TriggerServerEvent("iZeyy:police:close:frisk", GetPlayerServerId(player))
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

    Items:Button("Prendre la carte d'identité", nil, {}, true, {
        onSelected = function()
            if player ~= -1 and distance <= 5.0 then
                if isHandsUP then
                    ExecuteCommand("me prends la carte d'identité de l'individu")
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(player), GetPlayerServerId(PlayerId()))
                else
                    ESX.ShowNotification("La personne en face ne lève pas les mains")
                end
            else
                ESX.ShowNotification("Personne autour de vous")
            end
        end
    })

    Items:Button("Montrer votre insigne de Police", nil, {}, true, {
        onSelected = function()
            if player ~= -1 and distance <= 5.0 then
                TriggerServerEvent("iZeyy:SASP:ShowPoliceBadge", GetPlayerServerId(player), GetPlayerServerId(PlayerId()))
            else
                ESX.ShowNotification("Personne a coté de vous.")
            end
        end
    })

	Items:Button("Mettre une amende au joueur", nil, {}, true, {}, fine_menu)

    Items:Button("Menotter le joueur", nil, {}, not CopHandCuff, {
        onSelected = function()
            if closestPlayer ~= -1 and closestDistance < 5.0 then
                if not isInVehicle then
                    if not isHandcuff then
                        CopHandCuff = true
                        TriggerServerEvent("iZeyy:police:handcuff", GetPlayerServerId(closestPlayer))
                        SetTimeout(5000, function()
                            CopHandCuff = false
                        end)
                    else
                        ESX.ShowNotification("Le joueur est déja menotté")
                    end
                else
                    ESX.ShowNotification("Cette personne se trouve à l'intérieur d'un véhicule")
                end
            else
                ESX.ShowNotification("Personne autour de vous")
            end
        end
    })

    Items:Button("Demenotter le Suspect", nil, {}, not CopHandCuff, {
        onSelected = function()
            if (closestPlayer ~= -1 and closestDistance < 5.0) then
                if not isInVehicle then
                    if isHandcuff then
                        CopHandCuff = true
                        local animDict = "mp_arresting"
                        
                        RequestAnimDict(animDict)
                        while not HasAnimDictLoaded(animDict) do
                            Wait(100)
                        end
                        TaskPlayAnim(PlayerPedId(), animDict, "a_uncuff", 1.0, -1.0, -1, 1, 1, false, false, false)
          
                        SetTimeout(6000, function()
                            ClearPedTasks(PlayerPedId())
                            TriggerServerEvent("iZeyy:police:unhandcuff", GetPlayerServerId(closestPlayer))
                            CopHandCuff = false
                        end)
                    else
                        ESX.ShowNotification("Le joueur n'est pas menotté.")
                    end
                else
                    ESX.ShowNotification("Cette personne se trouve à l'intérieur d'un véhicule.")
                end
            else
                ESX.ShowNotification("Personne autour de vous.")
            end
        end
    })
    

    Items:Button("Escorter le joueur", nil, {}, true, {
        onSelected = function()
            if closestPlayer ~= -1 and closestDistance < 5.0 then
                if isHandcuff then
                    if not isInVehicle then
                        TriggerServerEvent("iZeyy:police:escort", GetPlayerServerId(closestPlayer))
                    else
                        ESX.ShowNotification("Cette personne se trouve à l'intérieur d'un véhicule")
                    end
                else
                    ESX.ShowNotification("Cette personne n'est pas menottée")
                end
            else
                ESX.ShowNotification("Personne autour de vous")
            end
        end
    })

    Items:Button("Mettre le joueur dans le véhicule", nil, {}, true, {
        onSelected = function()
            if closestPlayer ~= -1 and closestDistance < 5.0 then
                if IsEntityAttachedToAnyPed(getPlayerSearch) then
                    TriggerServerEvent("iZeyy:police:putInVehicle", GetPlayerServerId(closestPlayer))
                else
                    ESX.ShowNotification("Vous devez escorter une personne")
                end
            else
                ESX.ShowNotification("Personne autour de vous")
            end
        end
    })

    Items:Button("Sortir le joueur du véhicule", nil, {}, true, {
        onSelected = function()
            if closestPlayer ~= -1 and closestDistance < 5.0 then
                if isInVehicle then
                    TriggerServerEvent("iZeyy:police:putOutVehicle", GetPlayerServerId(closestPlayer))
                else
                    ESX.ShowNotification("La personne ne se trouve pas à l'intérieur d'un véhicule")
                end
            else
                ESX.ShowNotification("Personne autour de vous")
            end
        end
    })

end)

shield_menu:IsVisible(function(Items)
    Items:Button("Sortir votre Bouclier", nil, {}, not ShieldActive, {
        onSelected = function()
            EnableShield()
            SetTimeout(1200, function()
                ShieldActive = true
            end)
        end
    })
    Items:Button("Ranger votre Bouclier", nil, {}, ShieldActive, {
        onSelected = function()
            DisableShield()
            SetTimeout(1200, function()
                ShieldActive = false
            end)
        end
    })
end)


fine_menu:IsVisible(function(Items)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	for k, v in pairs(Config["PoliceJob"]["Fine"]) do
		Items:Button(v.label, nil, {RightLabel = v.price.. "~g~ $"}, true, {
			onSelected = function()
				if closestPlayer ~= -1 and closestDistance < 5.0 then
					TriggerServerEvent("iZeyy:police:sendFine", GetPlayerServerId(closestPlayer), v.label)
				else
					ESX.ShowNotification("Personne autour de vous")
				end
			end
		})
	end
end)

vehicle_action_menu:IsVisible(function(Items)
    Items:Button("Rechercher une plaque", nil, {}, true, {
        onSelected = function()
            local input = lib.inputDialog("Recherche de plaque", {
                {type = "input", label = "Numéro de plaque (8 caractères)"}
            })
    
            if input == nil or #input == 0 then
                ESX.ShowNotification("~s~Saisie annulée")
                return
            end
    
            local plate = tostring(input[1])
    
            if string.len(plate) >= 7 then
                TriggerServerEvent("iZeyy:police:requestVehicleInfo", plate)
            else
                ESX.ShowNotification("~s~Le numéro de plaque doit contenir 8 caractères.")
                RageUI.GoBack()
                return
            end
        end
    }, vehicle_info_menu)    

    if not (vehicle_info_menu:IsOpen()) then
        receiveInfo = {}
    end 

    Items:Button("Mettre le véhicule en fourrière", nil, {}, true, {
        onSelected = function()
            local player = PlayerPedId()
            local playerCoords = GetEntityCoords(player)
            local vehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 10.0, 0, 71)
    
            if not DoesEntityExist(vehicle) then
                ESX.ShowNotification("Aucun vehicule a proximité")
            else
                RequestAnimDict('random@arrests')
                while not HasAnimDictLoaded('random@arrests') do
                    Wait(100)
                end
    
                ExecuteCommand("me fait demande à une dépanneuse")
                TaskPlayAnim(player, 'random@arrests', 'generic_radio_enter', 1.0, -1, 2500, 49, 0, 0, 0, 0)
                SetTimeout(3500, function()
                    TriggerServerEvent("iZeyy:police:putInPound", vehicle)
                    main_menu:Close()
                end)
            end
        end
    })
    
end)

RegisterNetEvent('iZeyy:police:player:receiveVehicleInfo', function(plate, owner, vehicle)
    local player = PlayerPedId()

    if vehicle then

        local modelHash = vehicle.model
        local getNameVehicleModel = GetDisplayNameFromVehicleModel(modelHash)
        local modelLabelName = GetLabelText(getNameVehicleModel)

        receiveInfo = {
            plate = plate or "Inconnue",
            owner = owner or "Inconnue (Pas déclarer)",
            vehicle = modelLabelName or "Inconnue"
        }

    else

        receiveInfo = {
            plate = plate or "Inconnue",
            owner = owner or "Inconnue (Pas déclarer)",
            vehicle = "Inconnue"
        }

    end

    if owner then
        Amende = true
    else
        Amende = false
    end

    RequestAnimDict('random@arrests')
    while not HasAnimDictLoaded('random@arrests') do
        Wait(100)
    end

    ExecuteCommand("me fait une demande au central")
    TaskPlayAnim(player, 'random@arrests', 'generic_radio_enter', 1.0, -1, 2500, 49, 0, 0, 0, 0)
end)

vehicle_info_menu:IsVisible(function(Items)
    if (next(receiveInfo) ~= nil) then
        Items:Button("Numéro de plaque :", nil, {RightLabel = receiveInfo.plate}, true, {})
        Items:Button("Propriétaire :", nil, {RightLabel = receiveInfo.owner}, true, {})
        if Amende then
            Items:Button("Mettre une amende au proprietaire", nil, {RightLabel = "→"}, true , {
                onSelected = function()
                    local playerPed = PlayerPedId()
                    ExecuteCommand("me met une amende au véhicule...")
                    ExecuteCommand("e notepad")
                    Wait(3000)
                    ExecuteCommand("emotecancel")
                    TriggerServerEvent("iZeyy:AmendeCar", receiveInfo.plate)
                    ESX.ShowNotification("Amende envoyé.")
                    RageUI.CloseAll()
                end
            })
        else
            Items:Button("Mettre une amende au proprietaire", nil, {RightLabel = "→"}, false , {})
        end
    else
        Items:Separator("")
        Items:Separator("Chargement en cours..")
        Items:Separator("")
    end
end)

RegisterNetEvent('iZeyy:police:player:receiveBackupAlert', function(coords, type)
	if type == "low" then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		ESX.ShowNotification("Demande de renfort demandé.\nRéponse: ~g~CODE-2")
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 2
	elseif type == 'mid' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		ESX.ShowNotification("Demande de renfort demandé.\nRéponse: ~y~CODE-3")
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 47
	else
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
		ESX.ShowNotification("Demande de renfort demandé.\nRéponse: ~o~CODE-99")
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", 1)
		color = 1
	end

    local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, 161)
	SetBlipScale(blip, 1.2)
	SetBlipColour(blip, color)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Demande renfort')
	EndTextCommandSetBlipName(blip)
    SetTimeout(80000, function()
        RemoveBlip(blip)
    end)
end)

backup_menu:IsVisible(function(Items)
    local player = PlayerPedId()
    local coords  = GetEntityCoords(player)

    RequestAnimDict('random@arrests')
    while not HasAnimDictLoaded('random@arrests') do
        Wait(100)
    end

    Items:Button("Petite demande (CODE-2)", nil, {}, not backupTimeout, {
        onSelected = function()
            if not backupTimeout then
                backupTimeout = true
                ExecuteCommand("me fait une demande de renfort")
                TaskPlayAnim(player, 'random@arrests', 'generic_radio_enter', 1.0, -1, 2500, 49, 0, 0, 0, 0)
                TriggerServerEvent("iZeyy:police:callBackup", coords, "low")
                SetTimeout(60000, function()
                    backupTimeout = false
                end)
            end
        end
    })
    Items:Button("Moyenne demande (CODE-3)", nil, {}, not backupTimeout, {
        onSelected = function()
            if not backupTimeout then
                backupTimeout = true
                ExecuteCommand("me fait une demande de renfort")
                TaskPlayAnim(player, 'random@arrests', 'generic_radio_enter', 1.0, -1, 2500, 49, 0, 0, 0, 0)
                TriggerServerEvent("iZeyy:police:callBackup", coords, "mid")
                SetTimeout(60000, function()
                    backupTimeout = false
                end)
            end
        end
    })
    Items:Button("Grande demande (CODE-99)", nil, {}, not backupTimeout, {
        onSelected = function()
            if not backupTimeout then
                backupTimeout = true
                ExecuteCommand("me fait une demande de renfort")
                TaskPlayAnim(player, 'random@arrests', 'generic_radio_enter', 1.0, -1, 2500, 49, 0, 0, 0, 0)
                TriggerServerEvent("iZeyy:police:callBackup", coords, "hight")
                SetTimeout(60000, function()
                    backupTimeout = false
                end)
            end
        end
    })
end)


local objectList = {}
local objectCounter = 0

local function spawnProps(model, label)
    local player = PlayerPedId()
    local prop = (type(model) == 'number' and model or GetHashKey(model))
    local coords  = GetEntityCoords(player)
    local forward = GetEntityForwardVector(player)
    local x, y, z   = table.unpack(coords + forward * 3.0)

    if objectCounter < Config["PoliceJob"]["MaxProps"] then
        CreateThread(function()
            ESX.Streaming.RequestModel(prop)
            local object = CreateObject(prop, x, y, z, true, true, true)
            table.insert(objectList, {label = label, entity = object})
            objectCounter = objectCounter + 1

            SetEntityAsMissionEntity(object, false, false)
            SetEntityHeading(object, GetEntityHeading(player))
            FreezeEntityPosition(object, true)
            SetEntityInvincible(object, true)
            SetModelAsNoLongerNeeded(prop)
            PlaceObjectOnGroundProperly(object)

            RequestCollisionAtCoord(coords)

            while not HasCollisionLoadedAroundEntity(object) do
                Wait(100)
            end

        end)
    else
        ESX.ShowNotification("Vous avez atteint la limite d'objets poser")
    end

end

object_menu:IsVisible(function(Items)
    Items:Button("Cônes", nil, {}, true, {
        onSelected = function()
            local playerPed = PlayerPedId()
            if IsPedInAnyVehicle(playerPed, false) then
                ESX.ShowNotification("Vous ne pouvez pas sortir d'objets en étant dans un véhicule")
            else
                spawnProps("prop_roadcone02a", "Cônes")
            end
        end
    })

    Items:Button("Barrière", nil, {}, true, {
        onSelected = function()
            local playerPed = PlayerPedId()
            if IsPedInAnyVehicle(playerPed, false) then
                ESX.ShowNotification("Vous ne pouvez pas sortir d'objets en étant dans un véhicule")
            else
                spawnProps("prop_barrier_work05", "Barrière")
            end
        end
    })
    Items:Line()
    Items:Button("Supprimer", nil, {}, true, {}, delete_object_menu)
end)

local function propsMarker(props)
    local pos = GetEntityCoords(props)
    DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, Config["MarkerRGB"]["R"], Config["MarkerRGB"]["G"], Config["MarkerRGB"]["B"], Config["MarkerRGB"]["A1"], 0, 1, 2, 0, nil, nil, 0)
end

delete_object_menu:IsVisible(function(Items)
    if #objectList == 0 then
        Items:Separator("")
        Items:Separator("Aucun objets trouvé")
        Items:Separator("")
    else
        for k, v in pairs(objectList) do
            Items:Button(""..v.label.." #"..k.."", nil, {}, true, {
                onActive = function()
                    propsMarker(v.entity)
                end,
                onSelected = function()
                    local playerPed = PlayerPedId()
                    if IsPedInAnyVehicle(playerPed, false) then
                        ESX.ShowNotification("Vous ne pouvez pas supprimer d'objets en étant dans un véhicule")
                    else
                        DeleteObject(v.entity)
                        table.remove(objectList, k)
                        objectCounter = objectCounter - 1
                    end
                end
            })
        end
    end
end)

CreateThread(function()

    local ArmoryZone = Game.Zone("SASPZone")

    ArmoryZone:Start(function()
        ArmoryZone:SetTimer(1000)
        ArmoryZone:SetCoords(Config["PoliceJob"]["Armory"])

        ArmoryZone:IsPlayerInRadius(5.0, function()
            ArmoryZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            if playerData.job.name == "police" then
                ArmoryZone:Marker()
                ArmoryZone:IsPlayerInRadius(2.5, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    ArmoryZone:KeyPressed("E", function()
                        if (not exports.core:IsServerInBlackout()) then
                            armory_menu:Toggle()
                        else
                            ESX.ShowNotification("En raison de la situation critique actuelle et des mesures de sécurité imposées par le gouverneur, nous avons temporairement réquisitionné toutes vos armes.")
                        end
                    end)
                end)
            end
        end)
    end)

    local CloakRoomZone = Game.Zone("SASPZone")

    CloakRoomZone:Start(function()
        CloakRoomZone:SetTimer(1000)
        CloakRoomZone:SetCoords(Config["PoliceJob"]["Cloakroom"])

        CloakRoomZone:IsPlayerInRadius(5.0, function()
            CloakRoomZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            if playerData.job.name == "police" then
                CloakRoomZone:Marker()
                CloakRoomZone:IsPlayerInRadius(2.5, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    CloakRoomZone:KeyPressed("E", function()
                        cloakroom_menu:Toggle()
                    end)
                end)
            end
        end)
    end)

    local SeizedTrunkZone = Game.Zone("SASPZone")

    SeizedTrunkZone:Start(function()
        SeizedTrunkZone:SetTimer(1000)
        SeizedTrunkZone:SetCoords(Config["PoliceJob"]["SeizedTrunk"])

        SeizedTrunkZone:IsPlayerInRadius(5.0, function()
            SeizedTrunkZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            if playerData.job.name == "police" then
                SeizedTrunkZone:Marker()
                SeizedTrunkZone:IsPlayerInRadius(2.5, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    SeizedTrunkZone:KeyPressed("E", function()
                        seized_trunk:Toggle()
                    end)
                end)
            end
        end)
    end)

    local GarageZone = Game.Zone("SASPZone")

    GarageZone:Start(function()
        GarageZone:SetTimer(1000)
        GarageZone:SetCoords(Config["PoliceJob"]["Garage"])

        GarageZone:IsPlayerInRadius(5.0, function()
            GarageZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            if playerData.job.name == "police" then
                GarageZone:Marker()
                GarageZone:IsPlayerInRadius(2.5, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    GarageZone:KeyPressed("E", function()
                        garage_menu:Toggle()
                    end)
                end)
            end
        end)
    end)

    local GarageDeleteZone = Game.Zone("SASPZone")

    GarageDeleteZone:Start(function()
        GarageDeleteZone:SetTimer(1000)
        GarageDeleteZone:SetCoords(Config["PoliceJob"]["DeleteCar"])

        GarageDeleteZone:IsPlayerInRadius(60, function()
            GarageDeleteZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == "police" then
                GarageDeleteZone:Marker(nil, nil, 3.0)
                GarageDeleteZone:IsPlayerInRadius(8.0, function()
                    ESX.ShowHelpNotification("pour ranger le véhicule")
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

    local Blip = AddBlipForCoord(Config["PoliceJob"]["BlipsPos"])
    SetBlipSprite(Blip, 526)
    SetBlipScale(Blip, 0.5)
    SetBlipColour(Blip, 3)
    SetBlipDisplay(Blip, 4)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Commissariat de Police")
    EndTextCommandSetBlipName(Blip)
    local BlipsZone = AddBlipForRadius(Config["PoliceJob"]["BlipsPos"], 1000.0)
    SetBlipSprite(BlipsZone, 1)
    SetBlipColour(BlipsZone, 3)
    SetBlipAlpha(BlipsZone, 100)

end)

armory_menu:IsVisible(function(Items)
    if isInService then
        Items:Button("Armes de Service", nil, {}, true, {}, armory_menu_sub1)
        Items:Button("Equipements", nil, {}, true, {}, armory_menu_sub2)
        Items:Button("Chargeur", nil, {}, true, {}, armory_menu_sub3)
        Items:Button("Rendre votre Equipements", nil, {}, true, {
            onSelected = function()
                TriggerServerEvent("iZeyy:police:weaponService")
            end
        })
    else
        Items:Separator("")
        Items:Separator("Vous n'etes pas en service")
        Items:Separator("")
    end
end)

armory_menu_sub1:IsVisible(function(Items)
    local playerData = ESX.GetPlayerData()
    local grade = playerData.job.grade

    for k, v in pairs(Config["PoliceJob"]["ArmoryWeapon"]) do
        if tonumber(grade) >= tonumber(v.grade) then
            Items:Button(v.label, nil, {RightLabel = "→→"}, true, {
                onSelected = function()
                    TriggerServerEvent("iZeyy:police:takeArmoryWeapon", v.weapon, v.label)
                end
            })
        end
    end
end)

armory_menu_sub2:IsVisible(function(Items)
    local playerData = ESX.GetPlayerData()
    local grade = playerData.job.grade

    for k, v in pairs(Config["PoliceJob"]["ArmoryItems"]) do
        if tonumber(grade) >= tonumber(v.grade) then
            Items:Button(v.label, nil, {RightLabel = "→→"}, true, {
                onSelected = function()
                    TriggerServerEvent("iZeyy:police:takeArmoryItems", v.items, v.label)
                end
            })
        end
    end
end)

armory_menu_sub3:IsVisible(function(Items)
    local playerData = ESX.GetPlayerData()
    local grade = playerData.job.grade

    for k, v in pairs(Config["PoliceJob"]["ArmoryAmmo"]) do
        if tonumber(grade) >= tonumber(v.grade) then
            Items:Button(v.label, nil, {RightLabel = "→→"}, true, {
                onSelected = function()
                    TriggerServerEvent("iZeyy:police:takeArmoryAmmo", v.items, v.label)
                end
            })
        end
    end
end)

garage_menu:IsVisible(function(Items)
    local playerData = ESX.GetPlayerData()
    local grade = playerData.job.grade

    if isInService then
        for k, v in pairs(Config["PoliceJob"]["GarageVehicle"]) do
            if tonumber(grade) >= tonumber(v.grade) then
                Items:Button(v.label, nil, { RightLabel = "→→"}, true, {
                    onSelected = function()
                        TriggerServerEvent("iZeyy:police:spawnVehicle", v.vehicle, v.label)
                        garage_menu:Close()
                    end
                })
            end
        end
    else
        Items:Separator("")
        Items:Separator("Vous n'etes pas en service")
        Items:Separator("")
    end
end)

local function setUniform(type)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, Config["PoliceJob"]["Uniform"][type].male)

			if type == 'bullet' then
				TriggerServerEvent("iZeyy:kevlar:addforjob", "police", 100)
			end
		else
			TriggerEvent('skinchanger:loadClothes', skin, Config["PoliceJob"]["Uniform"][type].female)

			if type == 'bullet' then
				TriggerServerEvent("iZeyy:kevlar:addforjob", "police", 100)
			end
		end
	end)
end

cloakroom_menu:IsVisible(function(Items)
    if isInService then
        Items:Button("Mettre un gilet pare-balles", nil, {}, true, {
            onSelected = function()
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Wait(1000)
                ClearPedTasks(PlayerPedId())
                setUniform("bullet")
            end
        })
        Items:Button("Mettre un gilet cadet", nil, {}, true, {
            onSelected = function()
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Wait(1000)
                ClearPedTasks(PlayerPedId())
                setUniform("gilet")
            end
        })
        Items:Button("Retirer le gilet", nil, {}, true, {
            onSelected = function()
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Wait(1000)
                ClearPedTasks(PlayerPedId())
                setUniform("ungilet")
                TriggerServerEvent("iZeyy:kevlar:remove")
            end
        })
        Items:Button("Reprendre ses vêtements", nil, {}, true, {
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
                TriggerServerEvent("iZeyy:job:takeService", "police", false)
                TriggerServerEvent("iZeyy:police:weaponService")
                TriggerServerEvent("iZeyy:job:policeService", false)
                ESX.ShowNotification("Vous avez quitter votre service")
                isInService = false
            end
        })
    else
        Items:Button("Prendre sa tenue", nil, {}, true, {
            onSelected = function()
                local playerData = ESX.GetPlayerData()
                local grade = playerData.job.grade_name    
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Wait(1000)
                ClearPedTasks(PlayerPedId())
                setUniform(grade)
                TriggerServerEvent("iZeyy:job:takeService", "police", true)
                TriggerServerEvent("iZeyy:job:policeService", true)
                ESX.ShowNotification("Vous avez pris votre service")
                isInService = true
            end
        })
    end
end)

seized_trunk:IsVisible(function(Items)
    if isInService then
        Items:Button("Detruire de l'argent(s) sale", nil, {}, true, {
            onSelected = function()
                local success, input = pcall(function()
                    return lib.inputDialog("Destruction d'argent sale", {
                        {type = "number", label = "Entrez le montant"},
                    })
                end)

                if not success then
                    return
                elseif input == nil then
                    ESX.ShowNotification("Entrez un texte Valide")
                else
                    local count = input[1]
                    TriggerServerEvent('iZeyy:Trunk:destroyDirtyMoney', count)
                end
            end
        })
        Items:Button("Detruire une armes saisie", nil, {}, true, {
            onSelected = function()
                TriggerServerEvent("iZeyy:police:requestInventory")
            end
        }, put_wepaon_seized)
    else
        Items:Separator("")
        Items:Separator("Vous n'etes pas en service")
        Items:Separator("")
    end
end)

RegisterNetEvent("iZeyy:police:receiveLoadout", function(weapons)
    if (type(weapons) == "table") then
        for i = 1, #weapons do
            local weapon = weapons[i]
            table.insert(IventoryWeapon, {
                label = weapon.label,
                name = weapon.name,
                itemType = 'weapons',
            })
        end
    end
end)

RegisterNetEvent("iZeyy:police:removeWeapon", function(index)
    if (IventoryWeapon[index]) then
        table.remove(IventoryWeapon, index)
    end
end)

put_wepaon_seized:IsVisible(function(Items)
    if isInService then
        if next(IventoryWeapon) ~= nil then

            for k,v in pairs(IventoryWeapon) do
                local isPermanent = ESX.IsWeaponPermanent(v.name)

                if not isPermanent then
                    Items:Button(""..v.label, nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("iZeyy:police:deposeWeapon", k, {name = v.name, label = v.label})
                        end
                    })
                else
                    Items:Button(""..v.label, "Vous pouvez pas prendre cette arme car elle est permanente", {}, false, {})
                end

            end

        else
            Items:Separator("")
            Items:Separator("Aucune arme dans l'inventaire")
            Items:Separator("")
        end
    else
        Items:Separator("")
        Items:Separator("Vous n'etes pas en service")
        Items:Separator("")
    end
end, nil, function()
    IventoryWeapon = {}
end)

Shared:RegisterKeyMapping("iZeyy:SASP:OpenMenu", { label = "open_menu_interactSasp" }, "F6", function()
    local job = Client.Player:GetJob().name

    if job == "police" then
        main_menu:Toggle()
    end
end)