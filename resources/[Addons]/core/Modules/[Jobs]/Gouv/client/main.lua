local main_menu = RageUI.AddMenu("", "Faites vos actions")
local player_menu = RageUI.AddSubMenu(main_menu, "", "Faites vos actions")
local object_menu = RageUI.AddSubMenu(main_menu, "", "Faites vos actions")
local delete_object_menu = RageUI.AddSubMenu(object_menu    , "", "Faites vos actions")
local service_menu = RageUI.AddMenu("", "Faites vos actions")
local armory_menu = RageUI.AddMenu("", "Faites vos actions")
local vehicle_menu = RageUI.AddMenu("", "Faites vos actions")
local office_menu = RageUI.AddMenu("", "Faites vos actions")

local isInService = true
local GouvHandCuff = false
local isHandcuff = false
local isEscort = false

local SocietyData = {}

main_menu:SetSpriteBanner("commonmenu", "interaction_legal")
main_menu:SetButtonColor(0, 137, 201, 255)
player_menu:SetSpriteBanner("commonmenu", "interaction_legal")
player_menu:SetButtonColor(0, 137, 201, 255)
object_menu:SetSpriteBanner("commonmenu", "interaction_legal")
object_menu:SetButtonColor(0, 137, 201, 255)
delete_object_menu:SetSpriteBanner("commonmenu", "interaction_legal")
delete_object_menu:SetButtonColor(0, 137, 201, 255)
service_menu:SetSpriteBanner("commonmenu", "interaction_legal")
service_menu:SetButtonColor(0, 137, 201, 255)
armory_menu:SetSpriteBanner("commonmenu", "interaction_legal")
armory_menu:SetButtonColor(0, 137, 201, 255)
vehicle_menu:SetSpriteBanner("commonmenu", "interaction_legal")
vehicle_menu:SetButtonColor(0, 137, 201, 255)
office_menu:SetSpriteBanner("commonmenu", "interaction_legal")
office_menu:SetButtonColor(0, 137, 201, 255)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    while ESX.GetPlayerData()["job"] == nil do
        Wait(2000)
    end
end)

main_menu:IsVisible(function(Items)
    if (isInService) then
        Items:Button("Interaction Citoyens", nil, {}, true, {}, player_menu)
        Items:Button("Interaction Objets", nil, {}, true, {}, object_menu)
    else
        Items:Separator("")
        Items:Separator("Vous devez etre en service")
        Items:Separator("")
    end     
end)

RegisterNetEvent('iZeyy:gouv:player:handcuff', function()
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

RegisterNetEvent("iZeyy:gouv:cop:handcuff", function()
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

RegisterNetEvent("iZeyy:gouv:player:unhandcuff", function()
    local PlayerPed = PlayerPedId()

    isHandcuff = false
    ClearPedTasksImmediately(PlayerPed)
    SetEnableHandcuffs(PlayerPed, false)
    SetPedCanPlayGestureAnims(PlayerPed, true)
    ESX.ShowNotification("Vous avez été démenotté.")
end)

RegisterNetEvent('iZeyy:gouv:player:escort', function(cop)
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

RegisterNetEvent('iZeyy:gouv:player:putInVehicle', function()
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

RegisterNetEvent('iZeyy:gouv:player:putOutVehicle', function()
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

player_menu:IsVisible(function(Items)
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
                    TriggerServerEvent("iZeyy:gouv:frisk", GetPlayerServerId(player))
                    RageUI.CloseAll()

                    CreateThread(function()
                        local Bool = true
                        while Bool do
                            local getPlayerSearch = GetPlayerPed(player)
                            local coords = GetEntityCoords(GetPlayerPed(-1))
                            local dist = #(GetEntityCoords(getPlayerSearch) - coords)
                            if (dist > 3) then
                                Bool = false
                                TriggerServerEvent("iZeyy:gouv:close:frisk", GetPlayerServerId(player))
                            end
                            if not IsEntityPlayingAnim(getPlayerSearch, 'random@mugging3', 'handsup_standing_base', 3) then
                                Bool = false
                                TriggerServerEvent("iZeyy:gouv:close:frisk", GetPlayerServerId(player))
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

    Items:Button("Menotter le joueur", nil, {}, not GouvHandCuff, {
        onSelected = function()
            if closestPlayer ~= -1 and closestDistance < 5.0 then
                if not isInVehicle then
                    if not isHandcuff then
                        GouvHandCuff = true
                        TriggerServerEvent("iZeyy:gouv:handcuff", GetPlayerServerId(closestPlayer))
                        SetTimeout(5000, function()
                            GouvHandCuff = false
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

    Items:Button("Demenotter le Suspect", nil, {}, not GouvHandCuff, {
        onSelected = function()
            if (closestPlayer ~= -1 and closestDistance < 5.0) then
                if not isInVehicle then
                    if isHandcuff then
                        GouvHandCuff = true
                        local animDict = "mp_arresting"
                        
                        RequestAnimDict(animDict)
                        while not HasAnimDictLoaded(animDict) do
                            Wait(100)
                        end
                        TaskPlayAnim(PlayerPedId(), animDict, "a_uncuff", 1.0, -1.0, -1, 1, 1, false, false, false)
          
                        SetTimeout(6000, function()
                            ClearPedTasks(PlayerPedId())
                            TriggerServerEvent("iZeyy:gouv:unhandcuff", GetPlayerServerId(closestPlayer))
                            GouvHandCuff = false
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
                        TriggerServerEvent("iZeyy:gouv:escort", GetPlayerServerId(closestPlayer))
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
                    TriggerServerEvent("iZeyy:gouv:putInVehicle", GetPlayerServerId(closestPlayer))
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
                    TriggerServerEvent("iZeyy:gouv:putOutVehicle", GetPlayerServerId(closestPlayer))
                else
                    ESX.ShowNotification("La personne ne se trouve pas à l'intérieur d'un véhicule")
                end
            else
                ESX.ShowNotification("Personne autour de vous")
            end
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
                    TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'gouv', 'Gouvernement', price)
                end
            else
                ESX.ShowNotification("Aucun joueurs a coté de vous.")
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

    if objectCounter < 5 then
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
    local blip = AddBlipForCoord(Config["Gouv"]["BlipsPos"])
    SetBlipSprite(blip, 419)
    SetBlipScale(blip, 0.5)
    SetBlipColour(blip, 0)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Gouvernement")
    EndTextCommandSetBlipName(blip)

    local GouvServiceZone = Game.Zone("GouvServiceZone")

    GouvServiceZone:Start(function()
        GouvServiceZone:SetTimer(1000)
        GouvServiceZone:SetCoords(Config["Gouv"]["ServicePos"]) 

        GouvServiceZone:IsPlayerInRadius(10.0, function()
            GouvServiceZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == 'gouv' then 
                GouvServiceZone:Marker()

                GouvServiceZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    GouvServiceZone:KeyPressed("E", function()
                        service_menu:Toggle()
                    end)
                end)
            end
        end)
    end)

    local GouvArmoryZone = Game.Zone("GouvArmoryZone")

    GouvArmoryZone:Start(function()
        GouvArmoryZone:SetTimer(1000)
        GouvArmoryZone:SetCoords(Config["Gouv"]["Armory"]) 

        GouvArmoryZone:IsPlayerInRadius(10.0, function()
            GouvArmoryZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == 'gouv' then 
                GouvArmoryZone:Marker()

                GouvArmoryZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    GouvArmoryZone:KeyPressed("E", function()
                        armory_menu:Toggle()
                    end)
                end)
            end
        end)
    end)

    local GouvGarageZone = Game.Zone("GouvGarageZone")

    GouvGarageZone:Start(function()
        GouvGarageZone:SetTimer(1000)
        GouvGarageZone:SetCoords(Config["Gouv"]["Garage"]) 

        GouvGarageZone:IsPlayerInRadius(10.0, function()
            GouvGarageZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == 'gouv' then 
                GouvGarageZone:Marker()
                GouvGarageZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    GouvGarageZone:KeyPressed("E", function()
                        vehicle_menu:Toggle()
                    end)
                end)
            end
        end)
    end)

    local GouvGarageDeleteZone = Game.Zone("GouvGarageDeleteZone")

    GouvGarageDeleteZone:Start(function()
        GouvGarageDeleteZone:SetTimer(1000)
        GouvGarageDeleteZone:SetCoords(Config["Gouv"]["CarDeletePos"])

        GouvGarageDeleteZone:IsPlayerInRadius(60, function()
            GouvGarageDeleteZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == "gouv" then
                GouvGarageDeleteZone:Marker(nil, nil, 3.0)
                GouvGarageDeleteZone:IsPlayerInRadius(8.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule")
                    GouvGarageDeleteZone:KeyPressed("E", function()
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

    local GouvOfficeZone = Game.Zone("GouvOfficeZone")

    GouvOfficeZone:Start(function()
        GouvOfficeZone:SetTimer(1000)
        GouvOfficeZone:SetCoords(Config["Gouv"]["OfficePos"])

        GouvOfficeZone:IsPlayerInRadius(10.0, function()
            GouvOfficeZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == "gouv" then
                GouvOfficeZone:Marker()
                GouvOfficeZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    GouvOfficeZone:KeyPressed("E", function()
                        TriggerServerEvent("iZeyy:Gouv:GetSociety")
                        office_menu:Toggle()
                    end)
                end)
            end
        end)
    end)    
    
end)

local function SetUniform()
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config["Gouv"]["Uniform"].male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config["Gouv"]["Uniform"].female)
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
            TriggerServerEvent("iZeyy:job:takeService", "gouv", true)
            SetUniform()
            isInService = true
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
            TriggerServerEvent("iZeyy:job:takeService", "gouv", false)
            TriggerServerEvent("iZeyy:gouv:removeWeapon")
            isInService = false
        end 
    })
end)

armory_menu:IsVisible(function(Items)
    local playerData = ESX.GetPlayerData()
    local grade = playerData.job.grade
    local hasWeapon = false

    if (isInService) then
        Items:Button("Gillet par Balle", nil, {}, true, {
            onSelected = function()
                TriggerServerEvent("iZeyy:gouv:buyKevlar")
            end
        })
        Items:Line()
        for k, v in pairs(Config["Gouv"]["ArmoryWeapon"]) do
            if tonumber(grade) >= tonumber(v.grade) then
                hasWeapon = true
                Items:Button(v.label, nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        TriggerServerEvent("iZeyy:gouv:takeArmoryWeapon", v.weapon, v.label)
                    end
                })
            end
        end
        if not hasWeapon then
            Items:Separator()
            Items:Separator("Vous n'avez pas le grade requis pour les armes")
            Items:Separator()
        end
    else
        Items:Separator()
        Items:Separator("Vous devez etre en service")
        Items:Separator()
    end
end)

vehicle_menu:IsVisible(function(Items)
    if (isInService) then
        for k, v in pairs(Config["Gouv"]["VehList"]) do
            Items:Button(v.label, nil, { RightLabel = "Prendre →"}, true, {
                onSelected = function()
                    TriggerServerEvent("iZeyy:Gouv:SpawnVehicle", v.model, v.label)
                end
            })
        end
    else
        Items:Separator()
        Items:Separator("Vous devez etre en service")
        Items:Separator()
    end
end)

RegisterNetEvent("iZeyy:Gouv:ReceiveSocietyData", function(data)
    SocietyData = data or {}
end)

office_menu:IsVisible(function(Items)
    for _, societies in pairs(SocietyData) do
        Items:Button(societies.label, nil, {RightLabel = societies.money.."$"}, true, {})
    end
end)

-- F6
Shared:RegisterKeyMapping("iZeyy:Gouv:OpenMenu", { label = "open_menu_interactGouv" }, "F6", function()
    local job = Client.Player:GetJob().name
    if job == "gouv" then
        main_menu:Toggle()
    end
end)