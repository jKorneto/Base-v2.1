Menu = {
    StaffInfo = {},
    GamerTags = {},
    PlayerSelected = nil,
    PlayerInventory = nil,
    PlayerAccounts = nil,
    PlayersWeapons = nil,
    ReportSelected = nil,
    List = {
        ClearZoneIndex = 1,
        ClearZoneItem = {Name = "10", Value = 10},
        TimeZoneIndex = 1,

        AppreciationIndex = 1,
        Item = {Name = "⭐️", Value = 1},

        GiveMoneyIndex = 1,
        GiveMoneyIndex2 = 1,
        GiveMoneyItem = {Name = "Liquide", Value = "money"},
        GiveMoneyItem2 = {Name = "Liquide", Value = "money"},
    },
    ListStaff = {},
    ItemList = {},

    Type = {
        { Name = "Voiture", Value = "car"},
        { Name = "Avion", Value = "aircraft" },
        { Name = "Bateau", Value = "boat" }
    }
}
local WeaponGive = {
    action = {
        'Pistolet',
        'Pistolet 50',
        'Pistolet Lourd',
        'Pistolet Vintage',
        'Pistolet Détresse',
        'Revolver',
        'Double Action',
        'Micro SMG',
        'SMG',
        'SMG d\'assault',
        'ADP de combat',
        'Machine Pistol',
        'Pompe',
        'Carabine',
    },
    list = 1
}
local PedsChanges = {
    action = {
        'Mon personnage',
        'Dealer',
        'Singe',
        'Tonton',
        "DOA",
        "Caleb",
        "LSPD",
        "ARMY 1",
        "Army 2",
        "Benny's",
        "Pompier",
        "EMS",
    },
    list = 1
}
local AdminMenu = {
    VehiclesList = {
        "Panto",
        "Sanchez",
    },
    VehiclesListIndex = 1,
}
local Board = {
    List = {
        "Tous",
        "En Service",
        "Hors Service"
    },
    ListIndex = 1
}
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1
local alphaFilter = false
local zoneFilter = false
PlayerInSpec = false
local selectedColor = 1
local cVarLongC = { "~s~", ""}
local cVar1, cVar2 = "~s~", ""
local showInfoStaff = false
local function cVarLong()
    return cVarLongC[selectedColor]
end

function SizeOfReport()
    local count = 0
    for k,v in pairs(sAdmin.ReportList) do 
        count = count + 1
    end
    return count
end

function ReportEnCours()
    local count = 0
    for k,v in pairs(sAdmin.ReportList) do 
        if v.Taken then 
            count = count + 1
        end
    end
    return count
end

local function MoyenneAppreciation(t)
    local a, b = 0, 0
    for k,v in pairs(t) do 
        a = a + 1
        b = b + v
    end
    return a > 0 and ESX.Math.Round(b/a, 2).."/5" or "0"
end

function KeyboardInputAdmin(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

local function TeleportToMarker()
    local blipMarker = GetFirstBlipInfoId(8)

    if not DoesBlipExist(blipMarker) then
        return
    end

    DoScreenFadeOut(650)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    local ped, coords = PlayerPedId(), GetBlipInfoIdCoord(blipMarker)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local oldCoords = GetEntityCoords(ped)

    local x, y, groundZ, Z_START = coords['x'], coords['y'], 850.0, 950.0
    local found = false

    if vehicle > 0 then
        FreezeEntityPosition(vehicle, true)
    else
        FreezeEntityPosition(ped, true)
    end

    for i = Z_START, 0, -25.0 do
        local z = i

        if (i % 2) ~= 0 then
            z = Z_START - i
        end

        NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)

        local curTime = GetGameTimer()
        while IsNetworkLoadingScene() do
            if GetGameTimer() - curTime > 1000 then
                break
            end
            Wait(0)
        end

        NewLoadSceneStop()
        SetPedCoordsKeepVehicle(ped, x, y, z)

        while not HasCollisionLoadedAroundEntity(ped) do
            RequestCollisionAtCoord(x, y, z)
            if GetGameTimer() - curTime > 1000 then
                break
            end
            Wait(0)
        end

        found, groundZ = GetGroundZFor_3dCoord(x, y, z, false)
        if found then
            Wait(0)
            SetPedCoordsKeepVehicle(ped, x, y, groundZ)
            break
        end

        Wait(0)
    end

    DoScreenFadeIn(650)

    if vehicle > 0 then
        FreezeEntityPosition(vehicle, false)
    else
        FreezeEntityPosition(ped, false)
    end

    if not found then
        SetPedCoordsKeepVehicle(ped, oldCoords['x'], oldCoords['y'], oldCoords['z'] - 1.0)
    end

    SetPedCoordsKeepVehicle(ped, x, y, groundZ)
end

local function CheckStateOfStaff(license)
    for k,v in pairs(sAdmin.AdminList) do 
        if v.license == license then 
            return "~s~En ligne"
        end
    end
    return "Hors ligne"
end

function defineorNot(str) 
    if str == nil then
        return "Non Défini"
    else
        return "Défini"
    end
end

RegisterNetEvent("dclearw")
AddEventHandler("dclearw", function(id)
   ExecuteCommand("clearloadout "..id)
end)

local string1 = nil
local string2 = nil
local select_type = "car"
local INDEXFDP = 1

local StaffInService = false

local objectsAdmin = {}    

local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

local function OpenMenu(data)
    if ESX.GetPlayerData()['group'] == "user" and ESX.GetPlayerData()['group'] == nil then
        ESX.ShowNotification("~s~Vous n'avez pas accès à ce menu.")
        return
    end
    if sAdmin.Config.Debug then 
        sAdmin.Debug("Ouverture du menu")
    end
    local menu = RageUI.CreateMenu("", "Interaction disponible", 1150, 30)
    local persoMenu = RageUI.CreateSubMenu(menu, "", "Interaction personnel", 1150, 30)
    local persoMenu2 = RageUI.CreateSubMenu(persoMenu, "", "Interaction personnel", 1150, 30)
    local PropsList = RageUI.CreateSubMenu(persoMenu, "", "Remove Props", 1150, 30)
    local vehMenu = RageUI.CreateSubMenu(menu, "", "Interaction véhicule", 1150, 30)
    local joueurMenu = RageUI.CreateSubMenu(menu, "", "Interaction joueurs", 1150, 30)
    local joueurActionMenu = RageUI.CreateSubMenu(joueurMenu, "", "Actions sur le joueur", 1150, 30)
    local cardinal = RageUI.CreateSubMenu(menu, "", "Interaction serveur", 1150, 30)
    local inventoryMenu = RageUI.CreateSubMenu(joueurActionMenu, "", "Inventaire du joueur", 1150, 30)
    local reportMenu = RageUI.CreateSubMenu(menu, "", "Liste des reports", 1150, 30)
    local reportInfoMenu = RageUI.CreateSubMenu(reportMenu, "", "Informations du report", 1150, 30)
    local staffList = RageUI.CreateSubMenu(menu, "", "Liste des staffs", 1150, 30)
    local staffAction = RageUI.CreateSubMenu(staffList, "", "Actions sur ce staff", 1150, 30)
    local itemListe = RageUI.CreateSubMenu(joueurActionMenu, "", "Liste des items", 1150, 30)
    local itemListeMe = RageUI.CreateSubMenu(joueurActionMenu, "", "Liste des items", 1150, 30)
    local staffBoard = RageUI.CreateSubMenu(menu, "", "Tableau de Statistique", 1150, 30)
    
    RageUI.Visible(menu, not RageUI.Visible(menu))

    Citizen.CreateThread(function()
        while menu do
            Wait(800)
            if cVar1 == "" then
                cVar1 = "~s~"
            else
                cVar1 = ""
            end
            if cVar2 == "~s~" then
                cVar2 = ""
            else
                cVar2 = ""
            end
        end
    end)

    Citizen.CreateThread(function()
        while menu do
            Wait(250)
            selectedColor = selectedColor + 1
            if selectedColor > #cVarLongC then
                selectedColor = 1
            end
        end
    end)

    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()
            if data.inService then 
                state = "~s~Actif"
            else 
                state = "~s~Inactif"
            end
            RageUI.Checkbox("Mode Staff", nil, data.inService, {}, {
                onChecked = function()
                    data.inService = true
                    sAdmin.inService = true
                    StaffInService = true
                    showInfoStaff = true
                    TriggerServerEvent("sAdmin:ChangeState", true, data)
                    -- if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
                    --     return
                    -- else
                    --     ToogleNoClip()
                    --     inNoclip = true
                    -- end
                end,
                onUnChecked = function()
                    data.inService = false
                    sAdmin.inService = false
                    StaffInService = false
                    TriggerServerEvent("sAdmin:ChangeState", false, data)
                    showInfoStaff = false
                    --TriggerEvent('SHOW_NOTIFTOP', false, ('Nombre de Reports (~r~%s~s~) | Report Counter (~y~%s~s~) | Nombre de staff (~g~%s~s~)'):format(nombreDeReports, reportEffectued, nombreDeStaff), "rgba(255, 255, 255, 1)")

                    if inNoclip then
                        inNoclip = false
                        CreateThread(function()
                            ToogleNoClip()
                        end)
                    end
                    if showName then 
                        showName = false
                        showNames(showName)
                    end
                    if showBlips then 
                        showBlips = false
                        showBlipsF(showBlips)
                    end
                    if inInvisible then 
                        inInvisible = false
                        SetEntityInvincible(PlayerPedId(), false)
                        SetEntityVisible(PlayerPedId(), true, false)
                    end
                end,
            })
            RageUI.Line()
            --RageUI.Separator(" ~s~SASP en Service (~b~"..sAdmin.ServiceCountList.LSPD.."~s~) | LSMC en Service (~b~"..sAdmin.ServiceCountList.EMS.."~s~)")
            -- RageUI.Line()
            RageUI.Button("Liste des Reports (~b~" .. SizeOfReport() .. "~s~)", nil, {RightLabel = "→"}, data.inService and sAdmin.Config.Perms.AccesCat["report_menu"][data.grade], {}, reportMenu)
            RageUI.Button("Liste des Joueurs (~b~"..SizeOfPlayersList().."~s~)", nil, {RightLabel = "→"}, data.inService and sAdmin.Config.Perms.AccesCat["interaction_players"][data.grade], {}, joueurMenu)
            RageUI.Button("Gestion Véhicules", nil, {RightLabel = "→"}, data.inService and sAdmin.Config.Perms.AccesCat["interaction_vehicle"][data.grade], {}, vehMenu)
            RageUI.Button("Gestion Personnel", nil, {RightLabel = "→"}, data.inService and sAdmin.Config.Perms.AccesCat["interaction_perso"][data.grade], {}, persoMenu)
            RageUI.Button("Tableau de Statistique", nil, {RightLabel = "→"}, data.inService and sAdmin.Config.Perms.AccesCat["interactBoard"][data.grade], {
                onSelected = function()
                    TriggerServerEvent("sAdmin:GetStaff")
                end
            }, staffBoard)
            RageUI.Button("Gestion Serveur", nil, {RightLabel = "→"}, data.inService and sAdmin.Config.Perms.AccesCat["interaction_cardinal"][data.grade], {}, cardinal)

        end, function()
        end)

        RageUI.IsVisible(reportMenu, function()
      
            if next(sAdmin.ReportList) == nil then
                RageUI.Separator("")
                RageUI.Separator("Aucun Report actuellement")
                RageUI.Separator("")
            else
                for k,v in pairs(sAdmin.ReportList) do
                    if (v.TakenBy == nil) then v.TakenBy = "Personne" end
                    if (v.Name == nil) then v.Name = "????" end
                    if (v.Raison == nil) then v.Raison = "????" end
                    if (v.Date == nil) then v.Date = "????" end
                    if not v.Taken then
                        RageUI.Button("~r~En Attente~s~ | ID: ~s~"..k.."~s~ - "..v.Name, "~b~Raison~s~: "..v.Raison.."\n~b~Crée le a~s~: "..v.Date, {RightLabel = "→"}, true, {
                            onSelected = function()
                                TriggerServerEvent("sAdmin:UpdateReport", k) 
                                Menu.ReportSelected = v
                            end
                        }, reportInfoMenu)
                    else 
                        RageUI.Button("~g~En Cours~s~ | ID: ~s~"..k.."~s~ - "..v.Name, "~b~Raison~s~: "..v.Raison.."\n~b~Crée le a~s~: "..v.Date.."\n~b~Pris en charge par~s~: "..v.TakenBy, {RightLabel = "→"}, true, {
                            onSelected = function()
                                Menu.ReportSelected = v
                            end
                        }, reportInfoMenu)
                    end
                end
            end
        
        end, function()
        end)        

        RageUI.IsVisible(reportInfoMenu, function()
            
            while Menu.ReportSelected == nil do Wait(1) end
 
            RageUI.Button("Pseudo :", nil, {RightLabel = "~s~"..Menu.ReportSelected.Name}, true, {})
            RageUI.Button("Raison :",nil , {RightLabel = "~s~"..Menu.ReportSelected.Raison}, true, {})
            RageUI.Button("Heure :", nil, {RightLabel = "~s~"..Menu.ReportSelected.Date}, true, {})
            RageUI.Button("Staff", nil, {RightLabel = "~s~"..Menu.ReportSelected.TakenBy}, true, {})
            RageUI.Line()
            RageUI.Button("Gestion du Joueur", nil, {RightLabel = "→"}, true, {
                onSelected = function()
                    Menu.PlayerSelected = {ped = GetPlayerPed(Menu.ReportSelected.Source), id = Menu.ReportSelected.Source}
                end
            }, joueurActionMenu)
            RageUI.Button("Cloturer ce report", nil, {RightLabel = "→"}, true, {
                onSelected = function()
                    local success, input = pcall(function()
                        return lib.inputDialog("Confirmation", {
                            {type = "input", label = "Confirmez avec 'oui' pour clore le report"}
                        })
                    end)
            
                    if input[1] and input[1]:lower() == "oui" then
                        TriggerServerEvent("sAdmin:ClotureReport", Menu.ReportSelected.Source)
                        TriggerServerEvent("sAdmin:Update:Board")
                        RageUI.GoBack()
                    else
                        ESX.ShowNotification("~r~Veuillez entrer 'oui' pour confirmer.")
                    end
                end
            })
            
         
        end, function()
        end)
            

        RageUI.IsVisible(persoMenu, function()
            if sAdmin.Config.Perms.Buttons["cat_persoMenu"]["noclip"][data.grade] then
                RageUI.Checkbox('No Clip', nil, inNoclip, {}, {
                    onChecked = function()
                        inNoclip = true
                        --ESX.ShowNotification("Mode noclip activé")

                        CreateThread(function()
                            ToogleNoClip()
                        end)
                    end,
                    onUnChecked = function()
                        inNoclip = false
                        --ESX.ShowNotification("Mode noclip désactivé")

                        CreateThread(function()
                            ToogleNoClip()
                        end)
                    end,
                })
                if sAdmin.Config.Perms.Buttons["cat_persoMenu"]["show_gamertags"][data.grade] then
                    RageUI.Checkbox('Affichez les Noms', nil, showName, {}, {
                        onChecked = function()
                            showName = true
                            ESX.ShowNotification("Vous avez affiché les noms")
                            showNames(showName)
                        end,
                        onUnChecked = function()
                            showName = false
                            ESX.ShowNotification("Vous avez masqué les noms")
                            showNames(showName)
                        end,
                    })
                end
                if sAdmin.Config.Perms.Buttons["cat_persoMenu"]["show_gamertags"][data.grade] then
                    RageUI.Checkbox('Affichez les Blips', nil, showBlips, {}, {
                        onChecked = function()
                            showBlips = true
                            ESX.ShowNotification("Vous avez affiché les blips")
                            showBlipsF(showBlips)
                        end,
                        onUnChecked = function()
                            showBlips = false
                            ESX.ShowNotification("Vous avez masqué les blips")
                            showBlipsF(showBlips)
                        end,
                    })
                end
                RageUI.Button("Instance par défaut", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_persoMenu"]["noclip"][data.grade], {
                    onSelected = function()
                        TriggerServerEvent("sAdmin:resetBucket")
                    end
                })
            end
            RageUI.Button('Se TP sur Marker ', nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_persoMenu"]["teleport_waypoint"][data.grade], {
                onSelected = function() 
                    local WaypointHandle = GetFirstBlipInfoId(8)
                    
                    if DoesBlipExist(WaypointHandle) then
                        TeleportToMarker()
                        ESX.ShowNotification("Téléporté au marqueur avec succés")
                    else
                        ESX.ShowNotification("Il n'y a pas de marqueur sur ta map")
                    end
                end
            })
            RageUI.Button("Options Supplémentaires", nil, {RightLabel = "→"}, sAdmin.Config.Perms.AccesCat["personnal_gestion_2"][data.grade], {}, persoMenu2)
        end, function()
        end)

        RageUI.IsVisible(persoMenu2, function()
            RageUI.List('Give de l\'argent', {
                { Name = "Liquide", Value = "cash" },   
                { Name = "Banque", Value = "bank" },
                { Name = "Argent sale", Value = "dirtycash" }
            }, Menu.List.GiveMoneyIndex, nil, {}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["giveMoney"][data.grade], {
                onListChange = function(Index, Item)
                    Menu.List.GiveMoneyIndex = Index
                    Menu.List.GiveMoneyItem = Item
                end,
                onSelected = function()
                    local success, input = pcall(function()
                        return lib.inputDialog("Montant", {
                            {type = "number", label = "Entrez le montant"}
                        })
                    end)
        
                    if not success then
                    elseif input == nil then
                    elseif input[1] and input[1] > 0 then
                        local amount = tonumber(input[1])
                        TriggerServerEvent("sAdmin:GiveMoney:Perso", Menu.List.GiveMoneyItem.Value, amount)
                    else
                        ESX.ShowNotification("Le montant est incorrect")
                    end
                end
            })
            RageUI.List('Supprimer de l\'argent', {
                { Name = "Liquide", Value = "cash" },   
                { Name = "Banque", Value = "bank" },
                { Name = "Argent sale", Value = "dirtycash" }
            }, Menu.List.GiveMoneyIndex2, nil, {}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["giveMoney"][data.grade], {
                onListChange = function(Index, Item)
                    Menu.List.GiveMoneyIndex2 = Index
                    Menu.List.GiveMoneyItem2 = Item
                end,
                onSelected = function()
                    local success, input = pcall(function()
                        return lib.inputDialog("Supprimer de l'argent", {
                            {type = "number", label = "Entrez le montant"}
                        })
                    end)
        
                    if not success then
                    elseif input == nil then
                    elseif input[1] and input[1] > 0 then
                        local amount = tonumber(input[1])
                        TriggerServerEvent("sAdmin:DeleteMoney:Perso", Menu.List.GiveMoneyItem2.Value, amount)
                    else
                        ESX.ShowNotification("Le montant est incorrect")
                    end
                end
            })
            RageUI.Checkbox('Pistol Staff', nil, pistolMode, {}, {
                onChecked = function()
                    pistolMode = true
                    ExecuteCommand("staffgun")
                end,
                onUnChecked = function()
                    pistolMode = false
                    ExecuteCommand("staffgun")
                end,
            })
            RageUI.Checkbox('Afficher les Informations', nil, showInfoStaff, {}, {
                onChecked = function()
                    showInfoStaff = true
                    DrawStaff(true)
                end,
                onUnChecked = function()
                    showInfoStaff = false
                    DrawStaff(false)
                end,
            })
        end, function()
        end)

        RageUI.IsVisible(vehMenu, function()

            local pPed = PlayerPedId()
		    local plyCoords = GetEntityCoords(pPed)
            RageUI.List("Spawn un véhicule", AdminMenu.VehiclesList, AdminMenu.VehiclesListIndex, nil, {}, true, {
                onListChange = function(Index)
                    AdminMenu.VehiclesListIndex = Index
                end;
                onSelected = function(Index)
                    if Index == 1 then
                        TriggerServerEvent("sAdmin:spawnVehicle", 'panto', plyCoords)
                    elseif Index == 2 then
                        TriggerServerEvent("sAdmin:spawnVehicle", 'sanchez', plyCoords)
                        
                    end
                end
            })
            RageUI.Button("Réparer le véhicule", nil, { RightLabel = "→→" }, sAdmin.Config.Perms.Buttons["cat_vehMenu"]["repairVehicle"][data.grade], {
                onActive = function()
                    sAdmin.ClosetVehWithDisplay()
                end,
                onSelected = function()
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local veh = GetVehiclePedIsIn(player)

                    local vehicle = GetClosestVehicleAdmin(GetEntityCoords(PlayerPedId()), nil)
                    if (vehicle ~= -1) then
                        print(vehicle)
                        TriggerServerEvent("sAdmin:repairVehicle", VehToNet(vehicle), "all")
                    else
                        ESX.ShowNotification("Aucun véhicule à proximité")
                    end
                end
            })
            RageUI.Button("Réparer le moteur", nil, { RightLabel = "→→" }, sAdmin.Config.Perms.Buttons["cat_vehMenu"]["repairVehicle"][data.grade], {
                onActive = function()
                    sAdmin.ClosetVehWithDisplay()
                end,
                onSelected = function()
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local veh = GetVehiclePedIsIn(player)

                    local vehicle = GetClosestVehicleAdmin(GetEntityCoords(PlayerPedId()), nil)
                    if (vehicle ~= -1) then
                        TriggerServerEvent("sAdmin:repairVehicle", VehToNet(vehicle), "engine")
                    else
                        ESX.ShowNotification("Aucun véhicule à proximité")
                    end
                end
            })
            RageUI.Button("Nettoyer le véhicule", nil, { RightLabel = "→→" }, sAdmin.Config.Perms.Buttons["cat_vehMenu"]["repairVehicle"][data.grade], {
                onActive = function()
                    sAdmin.ClosetVehWithDisplay()
                end,
                onSelected = function()
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local veh = GetVehiclePedIsIn(player)

                    local vehicle = GetClosestVehicleAdmin(GetEntityCoords(PlayerPedId()), nil)
                    if (vehicle ~= -1) then
                        TriggerServerEvent("sAdmin:repairVehicle", VehToNet(vehicle), "cleaning")
                    else
                        ESX.ShowNotification("Aucun véhicule à proximité")
                    end
                end
            })
            RageUI.Button("Retourner le véhicule", nil, { RightLabel = "→→" }, sAdmin.Config.Perms.Buttons["cat_vehMenu"]["repairVehicle"][data.grade], {
                onActive = function()
                    sAdmin.ClosetVehWithDisplay()
                end,
                onSelected = function()
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)

                    local vehicle = GetClosestVehicleAdmin(GetEntityCoords(PlayerPedId()), nil)
                    if (vehicle ~= -1) then
                        if (IsEntityUpsidedown(vehicle)) then
                            TriggerServerEvent("sAdmin:returnVehicle", VehToNet(vehicle))
                        else
                            ESX.ShowNotification("Le véhicule n'est pas retournée")
                        end
                    end
                end
            })
            RageUI.Button("Supprimer le véhicule", nil, { RightLabel = "→→" }, sAdmin.Config.Perms.Buttons["cat_vehMenu"]["clearVehicle"][data.grade], {
                onActive = function()
                    sAdmin.ClosetVehWithDisplay()
                end,
                onSelected = function()
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local veh = GetVehiclePedIsIn(player)

                    local vehicle = GetClosestVehicleAdmin(GetEntityCoords(PlayerPedId()), nil)
                    if (vehicle ~= -1) then
                        TriggerServerEvent("sAdmin:deleteVehicle", VehToNet(vehicle))
                    else
                        ESX.ShowNotification("Aucun véhicule à proximité")
                    end
                    
                end
            })
            RageUI.Button("Faire le plein d'essence", nil, { RightLabel = "→→" }, true, {
                onSelected = function()
                    local player = PlayerPedId()
                    local veh = GetVehiclePedIsIn(player)

                    if veh ~= 0 then
                        exports["core_nui"]:SetFuel(veh, 100)
                    else
                        ESX.ShowNotification("Vous devez être dans un véhicule")
                    end   
                end
            })
            RageUI.Button("Upgrade le véhicule au max", nil, { RightLabel = "→→" }, sAdmin.Config.Perms.Buttons["cat_vehMenu"]["upgradeVehicules"][data.grade], {
                onActive = function()
                    sAdmin.ClosetVehWithDisplay()
                end;
                onSelected = function()
                    local veh = GetClosestVehicleAdmin(GetEntityCoords(PlayerPedId()), nil)
                    local player = PlayerPedId()
                    local inveh = GetVehiclePedIsIn(player, false)

                    if inveh ~= 0 then
                        NetworkRequestControlOfEntity(veh)
                        while not NetworkHasControlOfEntity(veh) do
                            Wait(1)
                        end
                        ESX.Game.SetVehicleProperties(veh, {
                            modEngine = 5,
                            modBrakes = 4,
                            modTransmission = 4,
                            modSuspension = 3,
                            windowTint = 2,
                            modXenon = true,
                            modTurbo = true
                        })
                        ESX.ShowNotification("~s~Les performances du véhicule ont été upgrade avec succès.")
                    else
                        ESX.ShowNotification("Vous devez être dans un véhicule")
                    end
                end
            })
            -- RageUI.Button("Changez la plaque du véhicule", nil, { RightLabel = "→→" }, sAdmin.Config.Perms.Buttons["cat_vehMenu"]["upgradeVehicules"][data.grade], {
            --     onActive = function()
            --         sAdmin.ClosetVehWithDisplay()
            --     end,
            --     onSelected = function()
            --         local player = PlayerPedId()
            --         local inveh = GetVehiclePedIsIn(player, false)
                
            --         if inveh ~= 0 then
            --             local success, input = pcall(function()
            --                 return lib.inputDialog("Changer la plaque", {
            --                     {type = "input", label = "Entrez la nouvelle plaque d'immatriculation"}
            --                 })
            --             end)
            
            --             if not success then
            --                 return
            --             elseif input == nil then
            --                 ESX.ShowNotification("Erreur : Le dialogue a été annulé")
            --             elseif input[1] and input[1] ~= "" then
            --                 local newPlate = input[1]
                            
            --                 local veh = GetClosestVehicleAdmin(GetEntityCoords(PlayerPedId()), nil)
            --                 NetworkRequestControlOfEntity(veh)
            --                 while not NetworkHasControlOfEntity(veh) do
            --                     Wait(1)
            --                 end
                            
            --                 ESX.Game.SetVehicleProperties(veh, {
            --                     plate = newPlate
            --                 })
                            
            --                 ESX.ShowNotification("~s~La plaque a été changée en : " .. newPlate)
            --             else
            --                 ESX.ShowNotification("Veuillez entrer une plaque valide.")
            --             end
            --         else
            --             ESX.ShowNotification("Vous devez être dans un véhicule")
            --         end
            --     end
            -- })
            
        end, function()
        end)

        RageUI.IsVisible(joueurMenu, function()

            RageUI.Checkbox("Filtre alphabétique", nil, alphaFilter, {}, {
                onChecked = function()
                    alphaFilter = true
                end;
                onUnChecked = function()
                    alphaFilter = false
                end
            })

            -- RageUI.Checkbox("Restreindre à ma zone", nil, zoneFilter, {}, {
            --     onChecked = function()
            --         zoneFilter = true
            --     end;
            --     onUnChecked = function()
            --         zoneFilter = false
            --     end
            -- })

            RageUI.Button("Téléportation aléatoire", nil, {RightLabel = "→→"}, true, {
                onSelected = function()
                    TriggerServerEvent('iZeyy:teleportToRandomPlayer')
                end
            })
            
            
            if alphaFilter then
                RageUI.List("Alphabet", filterArray, filter, nil, {}, true, {
                    onListChange = function(Index)
                        filter = Index
                    end
                })
            end

            RageUI.Line()

            if not zoneFilter then 
                for k,v in pairs(sAdmin.PlayersList) do 
                    if v.name ~= nil then
                        if alphaFilter then
                            if starts(v.name:lower(), filterArray[filter]:lower()) then
            
                                local group = ""
                                if v.group == "user" then 
                                    group = " - "
                                elseif v.group == "friends" then
                                    group = " [~q~AMIS~s~] - "
                                elseif v.group == "helpeur" then
                                    group = " [~g~HELPEUR~s~] - "
                                elseif v.group == "moderateur" then
                                    group = " [~b~MODERATEUR~s~] - "
                                elseif v.group == "admin" then
                                    group = " [~r~ADMIN~s~] - "
                                elseif v.group == "responsable" then
                                    group = " [~y~RESPONSABLE~s~] - "
                                elseif v.group == "gerantstaff" then
                                    group = " [~o~GERANT-STAFF~s~] - "
                                elseif v.group == "fondateur" then
                                    group = " [~l~FONDATEUR~s~] - "
                                end
                
                                if group ~= nil then
                                    RageUI.Button("["..k.."]" .. group .. v.name .. " - "..v.idUnique, "~s~Heure de connexion : ~b~"..v.hoursLogin.."\n~s~Nom & Prénom : ~b~"..v.firstname.." "..v.lastname, {RightLabel = "→"}, true, {
                                        onActive = function()
                                            sAdmin.PlayerMakrer(GetPlayerPed(k))
                                        end,
                                        onSelected = function()
                                            Menu.PlayerSelected = {ped = GetPlayerPed(k), id = k}
                                        end
                                    }, joueurActionMenu)
                                end

                            end
                        else
                            local group = ""
                            if v.group == "user" then 
                                group = " - "
                            elseif v.group == "friends" then
                                group = " [~q~AMIS~s~] - "
                            elseif v.group == "helpeur" then
                                group = " [~g~HELPEUR~s~] - "
                            elseif v.group == "moderateur" then
                                group = " [~b~MODERATEUR~s~] - "
                            elseif v.group == "admin" then
                                group = " [~r~ADMIN~s~] - "
                            elseif v.group == "responsable" then
                                group = " [~y~RESPONSABLE~s~] - "
                            elseif v.group == "gerantstaff" then
                                group = " [~o~GERANT-STAFF~s~] - "
                            elseif v.group == "fondateur" then
                                group = " [~l~FONDATEUR~s~] - "
                            end
                            RageUI.Button("["..k.."]" .. group .. v.name .. " - "..v.idUnique, "~s~Heure de connexion : ~b~"..v.hoursLogin.."\n~s~Nom & Prénom : ~b~"..v.firstname.." "..v.lastname, {RightLabel = "→"}, true, {
                                onActive = function()
                                    sAdmin.PlayerMakrer(GetPlayerPed(k))
                                end,
                                onSelected = function()
                                    Menu.PlayerSelected = {ped = GetPlayerPed(k), id = k}
                                end
                            }, joueurActionMenu)
                        end
                    end
                end
            else
                for _,player in pairs(GetActivePlayers()) do 
                    local sID = GetPlayerServerId(player)
                    local name = GetPlayerName(player)
                    if name ~= nil then
                        if alphaFilter then
                            if starts(name:lower(), filterArray[filter]:lower()) then
                                RageUI.Button("ID: "..sID.." - "..name, nil, {RightLabel = "→"}, true, {
                                    onActive = function()
                                        sAdmin.PlayerMakrer(GetPlayerPed(sID))
                                    end,
                                    onSelected = function()
                                        Menu.PlayerSelected = {ped = GetPlayerPed(sID), id = sID}
                                    end
                                }, joueurActionMenu)
                            end
                        else
                            RageUI.Button("ID: "..sID.." - "..name, nil, {RightLabel = "→"}, true, {
                                onActive = function()
                                    sAdmin.PlayerMakrer(GetPlayerPed(sID))
                                end,
                                onSelected = function()
                                    Menu.PlayerSelected = {ped = GetPlayerPed(sID), id = sID}
                                end
                            }, joueurActionMenu)
                        end
                    end
                end
            end
        end, function()
        end)

        RageUI.IsVisible(joueurActionMenu, function()
            
            -- RageUI.Separator("↓ Téléportation ↓")
            RageUI.Button("Goto", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["goto"][data.grade], {
                onSelected = function()
                    TriggerServerEvent("sAdmin:Goto", Menu.PlayerSelected.id)
                end
            })            
            RageUI.Button("Bring", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["bring"][data.grade], {
                onSelected = function()
                    TriggerServerEvent("sAdmin:Bring", Menu.PlayerSelected.id)
                end
            })            
            RageUI.Button("Bring Back", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["bring"][data.grade], {
                onSelected = function()
                    TriggerServerEvent("sAdmin:BringBack", Menu.PlayerSelected.id)
                end
            })
            RageUI.Button("Bring au PC", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["tpparkingcentral"][data.grade], {
               onSelected = function()
                   TriggerServerEvent("sAdmin:TpParking", Menu.PlayerSelected.id)
               end
            })
            -- RageUI.Separator("↓ Sanction ↓")
            RageUI.Line()
            RageUI.Button("Freeze le joueur", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["freeze"][data.grade], {
                onSelected = function()
                    TriggerServerEvent("sAdmin:Freeze", Menu.PlayerSelected.id)
                end
            })
            RageUI.Button("Kick le joueur", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["kick"][data.grade], {
                onSelected = function()
                    local success, input = pcall(function()
                        return lib.inputDialog("Kick", {
                            {type = "input", label = "Entrez la raison pour le kick"}
                        })
                    end)
            
                    if not success then
                        -- print("Erreur lors de l'ouverture du dialogue : " .. tostring(input))
                    elseif input == nil then
                        -- ESX.ShowNotification("Erreur : Le dialogue a été annulé")
                    elseif input[1] and input[1] ~= "" then
                        local reason = input[1]
                        TriggerServerEvent("sAdmin:Kick", Menu.PlayerSelected.id, tostring(reason))
                        RageUI.CloseAll()
                    else 
                        ESX.ShowNotification("Message invalide")
                    end
                end
            })     
            RageUI.Button("Jail le joueur", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["freeze"][data.grade], {
                onSelected = function()
                    RageUI.CloseAll()
                    ExecuteCommand("jail " .. Menu.PlayerSelected.id)
                end
            })
            RageUI.Button("Spectate le joueur", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["spec"][data.grade], {
                onSelected = function()
                    local playerId = Menu.PlayerSelected.id
                    local localPedId = PlayerPedId()
                    
                    if playerId == GetPlayerServerId(PlayerId()) then 
                        ESX.ShowNotification("Tu peux pas te spec toi même !")
                    else
                        Admin:StartSpectate({
                            id = Menu.PlayerSelected.id,
                            ped = GetPlayerPed(GetPlayerFromServerId(Menu.PlayerSelected.id))
                        })
                    end
                end
            })

            -- RageUI.Separator("↓ Autre ↓")
            RageUI.Button("Envoyer un message", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["sendMess"][data.grade], {
                onSelected = function()
                    local success, input = pcall(function()
                        return lib.inputDialog("Message", {
                            {type = "input", label = "Entrez votre message"} -- Use input type for text
                        })
                    end)
            
                    if not success then
                        -- print("Erreur lors de l'ouverture du dialogue : " .. tostring(input))
                    elseif input == nil then
                        -- ESX.ShowNotification("Erreur : Le dialogue a été annulé")
                    elseif input[1] and input[1] ~= "" then
                        local message = input[1] -- Get the message from the input
                        TriggerServerEvent("sAdmin:SendMessageGros", Menu.PlayerSelected.id, tostring(message))
                    else 
                        ESX.ShowNotification("Message invalide")
                    end
                end
            })
            
            RageUI.Line()
            RageUI.Button("Réanimer le joueur", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["revive"][data.grade], {
                onSelected = function()
                    ExecuteCommand("revive "..Menu.PlayerSelected.id)
                end
            })
            RageUI.Button("Voir l'inventaire", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["showInventory"][data.grade], {
                onSelected = function()
                    TriggerServerEvent("OneLife:Inventory:OpenSecondInventory", "fplayerStaff", Menu.PlayerSelected.id)
                    RageUI.CloseAll()
                end
            })
            RageUI.Button("Voir son Historique de Sanction", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["showInventory"][data.grade], {
                onSelected = function()
                    ExecuteCommand("ss "..Menu.PlayerSelected.id)
                    RageUI.CloseAll()
                end
            })
            RageUI.Line()
            RageUI.Button("Clear Loadout (~r~Armes~s~)", "~r~ATTENTION~s~ cette option supprime toutes les armes du joueur ! (~r~sauf armes perms~s~)", {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["clearLoadout"][data.grade], {
                onSelected = function()
                    TriggerServerEvent("dclearloadout", Menu.PlayerSelected.id)
                   RageUI.CloseAll()
                end
            }, inventoryMenu)
            if sAdmin.Config.Perms.Buttons["cat_playersActions"]["giveMoney"][data.grade] then
                RageUI.List('Give de l\'argent', {
                    { Name = "Liquide", Value = "cash" },   
                    { Name = "Banque", Value = "bank" },
                    { Name = "Argent sale", Value = "dirtycash" }
                }, Menu.List.GiveMoneyIndex, nil, {}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["giveMoney"][data.grade], {
                    onListChange = function(Index, Item)
                        Menu.List.GiveMoneyIndex = Index
                        Menu.List.GiveMoneyItem = Item
                    end,
                    onSelected = function()
                        local success, input = pcall(function()
                            return lib.inputDialog("Ajouter de l'argent", {
                                {type = "number", label = "Entrez le montant"}
                            })
                        end)
            
                        if not success then
                        elseif input == nil then
                        elseif input[1] and input[1] > 0 then
                            local amount = tonumber(input[1])
                            TriggerServerEvent("sAdmin:GiveMoney", Menu.PlayerSelected.id, Menu.List.GiveMoneyItem.Value, amount)
                        else
                            ESX.ShowNotification("Le montant est incorrect")
                        end
                    end
                })
                RageUI.List('Supprimer de l\'argent', {
                    { Name = "Liquide", Value = "cash" },   
                    { Name = "Banque", Value = "bank" },
                    { Name = "Argent sale", Value = "dirtycash" }
                }, Menu.List.GiveMoneyIndex2, nil, {}, sAdmin.Config.Perms.Buttons["cat_playersActions"]["giveMoney"][data.grade], {
                    onListChange = function(Index, Item)
                        Menu.List.GiveMoneyIndex2 = Index
                        Menu.List.GiveMoneyItem2 = Item
                    end,
                    onSelected = function()
                        local success, input = pcall(function()
                            return lib.inputDialog("Supprimer de l'argent", {
                                {type = "number", label = "Entrez le montant"}
                            })
                        end)
            
                        if not success then
                        elseif input == nil then
                        elseif input[1] and input[1] > 0 then
                            local amount = tonumber(input[1])
                            TriggerServerEvent("sAdmin:DeleteMoney", Menu.PlayerSelected.id, Menu.List.GiveMoneyItem2.Value, amount)
                        else
                            ESX.ShowNotification("Le montant est incorrect")
                        end
                    end
                })
            end                    
        end, function()
        end)
        
        RageUI.IsVisible(cardinal, function()

            RageUI.Button("Reset les Report", "Utilisez ceci à la fin de chaque réunion Staff", {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_cardinalActions"]["deleteReport"][data.grade], {
                onSelected = function()
                    local input = lib.inputDialog("Confirmation de Reset", {
                        {type = "input", label = "Etes-vous sûr de vouloir Reset ? (oui pour confirmer)"}
                    })

                    if input == nil or #input == 0 then
                        ESX.ShowNotification("~s~Saisie annulée")
                        return
                    end

                    if input[1]:lower() == "oui" then
                        --TriggerServerEvent("tF:resetReport")    
                        TriggerServerEvent("iZeyy:Admin:ResetReport")    
                        ESX.ShowNotification("~s~Information\n~s~Reset report effectué avec succès !")
                    else
                        ESX.ShowNotification("~s~Erreur !\n~s~Format invalide !")
                    end
                end
            })
            
            RageUI.Button("Give un Véhicule", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_cardinalActions"]["giveVehicle"][data.grade], {
                onSelected = function()
                    local success, inputs = pcall(function()
                        return lib.inputDialog("Donner un véhicule", {
                            {type = "number", label = "ID du Joueur"},             -- Player ID
                            {type = "input", label = "Nom du Véhicule"},            -- Vehicle model
                            {type = "input", label = "Type de Véhicule (car/plane/boat)"},  -- Vehicle type
                            {type = "number", label = "Véhicule Boutique (1 = Oui / 0 = Non)"} -- Boutique type
                        })
                    end)
            
                    if not success then
                        print("Erreur lors de l'ouverture du dialogue : " .. tostring(inputs))
                        return
                    elseif inputs == nil then
                        return
                    end
            
                    local id = tonumber(inputs[1])            -- ID du Joueur
                    local model = inputs[2]                    -- Nom du Véhicule
                    local vehicletype = inputs[3]               -- Type de Véhicule
                    local boutiquetype = tonumber(inputs[4])    -- Type de Boutique
            
                    -- Validate ID
                    if not id then
                        ESX.ShowNotification("ID incorrect")
                        return
                    end
            
                    if vehicletype ~= "car" and vehicletype ~= "plane" and vehicletype ~= "boat" then
                        ESX.ShowNotification("Type de véhicule incorrect")
                        return
                    end
            
                    -- Validate boutique type
                    if not boutiquetype or (boutiquetype ~= 0 and boutiquetype ~= 1) then
                        ESX.ShowNotification("Indiquer un numéro entre 0-1 pour le type de boutique")
                        return
                    end
                    TriggerServerEvent('sAdmin:giveVehicle', id, model, vehicletype, boutiquetype)
                end
            })
            RageUI.Button("Se mettre en Peds", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_cardinalActions"]["peds"][data.grade], {
                onSelected = function()
                    local success, input = pcall(function()
                        return lib.inputDialog("Nom du Ped", {
                            {type = "input", label = "Entrez le nom du Ped", placeholder = "https://docs.fivem.net/docs/game-references/ped-models/"} -- Use input type for text
                        })
                    end)
            
                    if not success then
                        -- print("Erreur lors de l'ouverture du dialogue : " .. tostring(input))
                    elseif input == nil then
                        -- ESX.ShowNotification("Erreur : Le dialogue a été annulé")
                    elseif input[1] and input[1] ~= "" then
                        local PedName = input[1] -- Get the ped name from the input
            
                        ESX.Streaming.RequestModel(PedName, function()
                            SetPlayerModel(PlayerId(), PedName)
                            SetModelAsNoLongerNeeded(PedName)
                            TriggerEvent('esx:restoreLoadout')
                        end)
                    else
                        ESX.ShowNotification("Veuillez entrer un nom de Ped valide.")
                    end
                end
            })
            RageUI.Button("Reprendre son Personnage", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_cardinalActions"]["resetPeds"][data.grade], {
                onSelected = function()
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                        local isMale = skin.sex == 0
                        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                            TriggerEvent('skinchanger:loadSkin', skin, function()
                                TriggerEvent('esx:restoreLoadout');
                            end);
                        end)
                    end)
                end
            })

            RageUI.Line()

            RageUI.Button("Gérer un Gang", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_cardinalActions"]["gang"][data.grade], {
                onSelected = function()
                   RageUI.CloseAll()
                   ExecuteCommand("sGangBuilder")
                end
            })

            RageUI.Button("Gérer un Event", nil, {RightLabel = "→"}, sAdmin.Config.Perms.Buttons["cat_cardinalActions"]["event"][data.grade], {
                onSelected = function()
                   RageUI.CloseAll()
                   ExecuteCommand("eventmenu")
                end
            })

        end, function()
        end)

        RageUI.IsVisible(inventoryMenu, function()
           
            if Menu.PlayerInventory == nil and Menu.PlayerAccounts == nil and Menu.PlayersWeapons == nil then 
                RageUI.Separator("")
                RageUI.Separator("~s~En attente")
                RageUI.Separator("")
            else 
                RageUI.Line()
                for k,v in pairs(Menu.PlayerAccounts) do
                    RageUI.Button(v.label, nil, {RightLabel = v.money.."$"}, true, {})
                end
                RageUI.Line()
                for k,v in pairs(Menu.PlayerInventory) do 
                    if v.count > 0 then
                        RageUI.Button("x"..v.count.." "..v.label, nil, {}, true, {})
                    end
                end
                RageUI.Line()
                for k,v in pairs(Menu.PlayersWeapons) do 
                    RageUI.Button(v, nil, {}, true, {})
                end
            end

        end, function()
        end)

        RageUI.IsVisible(itemListe, function()
            for id, itemInfos in pairs(Menu.ItemList) do
                RageUI.Button(itemInfos.label .. " - ~s~" .. itemInfos.name, nil, {RightLabel = "→"}, true, {
                    onSelected = function()
                        -- Use a dialog to input the amount
                        local success, input = pcall(function()
                            return lib.inputDialog("Montant", {
                                {type = "number", label = "Entrez le montant"}
                            })
                        end)
        
                        -- Check if the dialog opened successfully
                        if not success then
                            -- print("Erreur lors de l'ouverture du dialogue : " .. tostring(input))
                            return
                        elseif not input or not input[1] then
                            -- ESX.ShowNotification("Erreur : Le dialogue a été annulé")
                            return
                        end
        
                        local amount = tonumber(input[1]) -- Convert the input to a number
        
                        -- Validate amount
                        if amount and amount > 0 then
                            TriggerServerEvent("sAdmin:GiveItem", Menu.PlayerSelected.id, itemInfos.name, amount)
                        else
                            ESX.ShowNotification("Le montant doit être supérieur à zéro")
                        end
        
                        RageUI.GoBack()
                    end
                })
            end
        end, function()
        end)        

        RageUI.IsVisible(itemListeMe, function()
            for id, itemInfos in pairs(Menu.ItemList) do
                RageUI.Button(itemInfos.label .. " - ~s~" .. itemInfos.name, nil, {RightLabel = "→"}, true, {
                    onSelected = function()
                        local success, input = pcall(function()
                            return lib.inputDialog("Montant", {
                                {type = "number", label = "Entrez le montant"}
                            })
                        end)
        
                        if not success then
                            return
                        elseif input == nil or not input[1] then
                            return
                        end
        
                        local amount = tonumber(input[1])
        
                        -- Validate amount
                        if amount and amount > 0 then
                            TriggerServerEvent("sAdmin:GiveItemMe", itemInfos.name, amount) -- Trigger server event to give item
                            RageUI.CloseAll() -- Close the menu after the action
                        else
                            ESX.ShowNotification("Le montant doit être supérieur à zéro") -- Notify invalid amount
                        end
                    end
                })
            end
        end, function()
        end) 
        
        RageUI.IsVisible(staffBoard, function()
            if Menu.StaffInfo and #Menu.StaffInfo > 0 then
                RageUI.List("Filtrer par", Board.List, Board.ListIndex, nil, {}, true, {
                    onListChange = function(Index)
                        Board.ListIndex = Index
                    end
                })
        
                local filteredStaff = {}
                for i, v in ipairs(Menu.StaffInfo) do
                    if Board.ListIndex == 1 then
                        table.insert(filteredStaff, v)
                    elseif Board.ListIndex == 2 then
                        if v.state == true then
                            table.insert(filteredStaff, v)
                        end
                    elseif Board.ListIndex == 3 then
                        if v.state == false then
                            table.insert(filteredStaff, v)
                        end
                    end
                end
                
                table.sort(filteredStaff, function(a, b)
                    return a.report > b.report
                end)
                
                RageUI.Line()

                for i, v in ipairs(filteredStaff) do
                    local status = " [~o~Inconnu~s~]"
        
                    if v.state == true then
                        status = " [~g~En Service~s~]"
                    elseif v.state == false then
                        status = " [~r~Hors Service~s~]"
                    end
        
                    RageUI.Button(v.name .. status, nil, { RightLabel = v.report .. " Report(s) effectué" }, true, {})
                end
            else
                RageUI.Separator("~r~Aucune donnée trouvée~s~")
            end
        end, function()
        end)
        
        

        if not RageUI.Visible(menu) and not RageUI.Visible(persoMenu) and not RageUI.Visible(PropsList) and not RageUI.Visible(vehMenu) and not RageUI.Visible(joueurMenu) 
        and not RageUI.Visible(joueurActionMenu) and not RageUI.Visible(cardinal) and not RageUI.Visible(inventoryMenu) and not RageUI.Visible(reportMenu) 
        and not RageUI.Visible(reportInfoMenu) and not RageUI.Visible(staffList) and not RageUI.Visible(staffAction) and not RageUI.Visible(itemListe) and not RageUI.Visible(itemListeMe) and not RageUI.Visible(staffBoard) and not RageUI.Visible(persoMenu2) then
            menu = RMenu:DeleteType('menu', true)
            persoMenu = RMenu:DeleteType('persoMenu', true)
            persoMenu2 = RMenu:DeleteType('persoMenu2', true)
            vehMenu = RMenu:DeleteType('vehMenu', true)
            joueurMenu = RMenu:DeleteType('joueurMenu', true)
            joueurActionMenu = RMenu:DeleteType('joueurActionMenu', true)
            cardinal = RMenu:DeleteType('cardinal', true)
            inventoryMenu = RMenu:DeleteType('inventoryMenu', true)
            reportMenu = RMenu:DeleteType('reportMenu', true)
            reportInfoMenu = RMenu:DeleteType('reportInfoMenu', true)
            staffList = RMenu:DeleteType('staffList', true)
            staffAction = RMenu:DeleteType('staffAction', true)
            itemListe = RMenu:DeleteType('itemListe', true)
            itemListeMe = RMenu:DeleteType('itemListeMe', true)
            staffBoard = RMenu:DeleteType('staffBoard', true)
            Menu.PlayerSelected = nil 
            Menu.PlayerInventory = nil
            Menu.PlayerAccounts = nil
            Menu.PlayersWeapons = nil
        end
    end

end

RegisterNetEvent("sAdmin:Staff:Info", function(info)
    Menu.StaffInfo = info
    --print(json.encode(Menu.StaffInfo))
end)

Citizen.CreateThread(function()
    while true do
        if showInfoStaff then
            DrawStaff(true)
        else
            Citizen.Wait(100)
        end
        Citizen.Wait(0)
    end
end)

local CanOpenMenu = false
local announcestring = false

RegisterNetEvent('announceForMessage')
AddEventHandler('announceForMessage', function(msg, name)
	announcestring = msg
    thename = name
	PlaySoundFrontend("DELETE","HUD_DEATHMATCH_SOUNDSET", 1)
	Citizen.Wait(5000)
	announcestring = false
end)

function Initialize(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString("~s~Message Staff ~w~("..thename..")")
    PushScaleformMovieFunctionParameterString(announcestring)
    PopScaleformMovieFunctionVoid()
    return scaleform
end


Citizen.CreateThread(function()
while true do
	Wait(0)
        if announcestring then
            scaleform = Initialize("mp_big_message_freemode")
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    ESX.PlayerLoaded = true
end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	CanOpenMenu = true
end);

RegisterCommand("+adminMenu", function()
    local pPed = PlayerId()
    local pId = GetPlayerServerId(pPed)
    for k,v in pairs(sAdmin.AdminList) do 
        if k == pId then 
            OpenMenu(v)
            return
        end
    end 
end, false)

RegisterNetEvent('iZeyy:performTeleport')
AddEventHandler('iZeyy:performTeleport', function(targetCoords)
    local currentPed = GetPlayerPed(-1)

    if not inNoclip then
        inNoclip = true
        CreateThread(function()
            ToogleNoClip()
        end)
    end

    SetEntityCoords(currentPed, targetCoords.x, targetCoords.y, targetCoords.z + 2.0, false, false, false, false)
    if IsEntityAtCoord(currentPed, targetCoords.x, targetCoords.y, targetCoords.z + 2.0, 1.0, 1.0, 1.0, false, true, 0) then
        return
    else
        ESX.ShowNotification("Échec de la téléportation")
    end
end)

RegisterKeyMapping("+adminMenu", "Menu Admin", 'keyboard', sAdmin.Config.KeyOpenMenu)

RegisterNetEvent("sAdmin:GetStaffsList")
AddEventHandler("sAdmin:GetStaffsList", function(staffList)
    Menu.ListStaff = staffList
end)

RegisterNetEvent("sAdmin:ReceiveItemList")
AddEventHandler("sAdmin:ReceiveItemList", function(itemList)
    Menu.ItemList = itemList
end)

local send = false
Citizen.CreateThread(function()
    while true do 
        if PlayerInSpec then 
            if (not send) then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour quitter le mode spectate")
                send = true
            end

            if IsControlJustPressed(1, 51) then
                Admin:ExitSpectate()
            end

            Wait(1)
        else 
            send = false
            Wait(1000)
        end
    end
end)

RegisterNetEvent('receiveLicenceForWipe')
AddEventHandler('receiveLicenceForWipe', function(licence)
    print('La licence du joueur est : '..licence)
end)

RegisterCommand("+tpm", function()
    local pPed = PlayerId()
    local pId = GetPlayerServerId(pPed)
    local data = {}

    for k, v in pairs(sAdmin.AdminList) do 
        if (k == pId) then 
            data = v
            break
        end
    end


    if (sAdmin.Config.Perms.Buttons["cat_persoMenu"]["teleport_waypoint"][data.grade]) then
        local WaypointHandle = GetFirstBlipInfoId(8)
                        
        if DoesBlipExist(WaypointHandle) then
            TeleportToMarker()
            ESX.ShowNotification("Téléporté au marqueur avec succés")
        else
            ESX.ShowNotification("Il n'y a pas de marqueur sur ta map")
        end
    end
end, false)

RegisterKeyMapping("+tpm", "Teleport to marker", 'keyboard', sAdmin.Config.KeyTPMarker)