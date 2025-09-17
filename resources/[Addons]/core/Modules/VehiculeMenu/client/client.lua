local main_menu = RageUI.AddMenu("", "Gestion véhicule")

local ActionList = {
    engineActionList = {
        "Allumer",
        "Éteindre",
    },

    maxSpeedList = {
        "50",
        "80",
        "120",
        "Retirer",
    },

	doorsList = {
        "Toutes les portes",
        "Porte avant-gauche",
        "Porte avant-droite",
        "Porte arrière-gauche",
        "Porte arrière-droite",
		"Capot",
		"Coffre"
    },

    maxSpeedListIndex = 1,
    engineActionIndex = 1,
	doorActionIndex = 1,
	doorIndex = 1,
}

local function IsPlayerInDriverSeat()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local seatIndex = -1
    return IsPedSittingInVehicle(playerPed, vehicle) and GetPedInVehicleSeat(vehicle, seatIndex) == playerPed
end

local function doorState()
	local playerPed = PlayerPedId()
	local GetVehicle = GetVehiclePedIsIn(playerPed, false)
	local GetVehicleDoorLockStatus = GetVehicleDoorLockStatus(GetVehicle)

	if GetVehicleDoorLockStatus == 1 then
		return "~r~Désactiver"
	elseif GetVehicleDoorLockStatus == 2 then
		return "~g~Actif"
	end
end

local function isAllowedToManageVehicle()
    if IsPedInAnyVehicle(PlayerPedId(),false) then

        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

		if doorState() == "~g~Actif" then
			return ESX.ShowNotification("Le véhicule est verrouillé")
		end

        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
            return true
        end

        return false

    end

    return false
end

local function doorAction(door)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
		return 
	end

    local veh = GetVehiclePedIsIn(PlayerPedId(), false)

    if door == -1 then

        if ActionList.doorActionIndex == 1 then
            for i = 0, 7 do
                SetVehicleDoorOpen(veh, i, false, false)
            end
        else
            for i = 0, 7 do
                SetVehicleDoorShut(veh, i, false)
            end
        end

        doorCoolDown = true

        SetTimeout(500, function()
            doorCoolDown = false
        end)

        return
    end

    if ActionList.doorActionIndex == 1 then
        SetVehicleDoorOpen(veh,door,false,false)
        doorCoolDown = true
        SetTimeout(500, function()
            doorCoolDown = false
        end)
    else
        SetVehicleDoorShut(veh,door,false)
        doorCoolDown = true
        SetTimeout(500, function()
            doorCoolDown = false
        end)
    end
end


InteractMenuBmx = Game.InteractContext:AddButton("vehicle_menu", "Gestion véhicule", nil, function(onSelected, Entity)
    if (onSelected) then
        local vehicle = Entity.ID
        if (not main_menu:IsOpen() and IsPlayerInDriverSeat()) then
            main_menu:Toggle()
        else
            Game.Notification:showNotification("Vous devez être dans le véhicule et en place conducteur pour accéder au menu")
        end
    end
end, function(Entity)
    return IsPedSittingInAnyVehicle(PlayerPedId()) and IsPlayerInDriverSeat() and Entity.ID == GetVehiclePedIsIn(PlayerPedId(), false)
end)

CreateThread(function()
    while true do
        Wait(1000)
        if main_menu:IsOpen() then
            if not IsPedSittingInAnyVehicle(PlayerPedId()) or not IsPlayerInDriverSeat() then
                main_menu:Close()
            end
        end
    end
end)

CreateThread(function()
    main_menu:IsVisible(function(Items)
        local playerPed = Client.Player:GetPed()

        if IsPedSittingInAnyVehicle(playerPed) then
            local GetVehicle = GetVehiclePedIsIn(playerPed, false)
            local GetVehicleFuel = exports["core_nui"]:GetFuel(GetVehicle) or 0
            local VehicleFuelRounded = (math.round(GetVehicleFuel))
            local GetVehicleHealth = (math.round(GetVehicleEngineHealth(GetVehicle)) / 10)
    
            Items:Separator("Verrouillage centralisé : "..doorState().."")
            Items:Separator("Carburant : "..VehicleFuelRounded.."L" .. " - État du moteur : "..GetVehicleHealth.."%")
    
            Items:Line()
    
            Items:List("Action Moteur", ActionList.engineActionList, ActionList.engineActionIndex, nil, {}, true, {
                onListChange = function(index)
                    ActionList.engineActionIndex = index
                end,
    
                onSelected = function(index)
                    if index == 1 then
                        SetVehicleEngineOn(GetVehicle, true, true, false)
                    else
                        SetVehicleEngineOn(GetVehicle, false, true, true)
                    end
                end
            })
    
            Items:List("Limiteur de vitesse", ActionList.maxSpeedList, ActionList.maxSpeedListIndex, nil, {}, true, {
                onListChange = function(index)
                    ActionList.maxSpeedListIndex = index
                end,
                onSelected = function(index)

                    local vehicleSpeed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6

                    if index == 1 then
                        if vehicleSpeed < 50 then
                            SetVehicleMaxSpeed(GetVehicle, 13.7)
                        else
                            Game.Notification:showNotification("Vous ne pouvez pas changer la limite de vitesse lorsque le véhicule roule à plus de 50 km/h.")
                        end
                    elseif index == 2 then
                        if vehicleSpeed < 80 then
                            SetVehicleMaxSpeed(GetVehicle, 22.0)
                        else
                            Game.Notification:showNotification("Vous ne pouvez pas changer la limite de vitesse lorsque le véhicule roule à plus de 80 km/h.")
                        end
                    elseif index == 3 then
                        if vehicleSpeed < 120 then
                            SetVehicleMaxSpeed(GetVehicle, 33.0)
                        else
                            Game.Notification:showNotification("Vous ne pouvez pas changer la limite de vitesse lorsque le véhicule roule à plus de 120 km/h.")
                        end
                    elseif index == 4 then
                        SetVehicleMaxSpeed(GetVehicle, 0.0)
                    end
                end
            })
    
            Items:List("Action portes", {"Ouvrir","Fermer"}, ActionList.doorActionIndex, nil, {}, true, {
                onListChange = function(index)
                    ActionList.doorActionIndex = index
                end,
            })
            
            Items:List("Ouverture", ActionList.doorsList, ActionList.doorIndex, nil, {}, true, {
                onListChange = function(index)
                    ActionList.doorIndex = index
                end,
                onSelected = function(index)
                    if isAllowedToManageVehicle() then
                        local vehicleSpeed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6
                        if vehicleSpeed < 10 then
                            if index == 1 then
                                doorAction(-1) 
                            elseif index == 2 then
                                doorAction(0) 
                            elseif index == 3 then
                                doorAction(1) 
                            elseif index == 4 then
                                doorAction(2) 
                            elseif index == 5 then
                                doorAction(3) 
                            elseif index == 6 then
                                doorAction(4) 
                            elseif index == 7 then
                                doorAction(5) 
                            end
                        else
                            Game.Notification:showNotification("Vous ne pouvez pas ouvrir ou fermer les portes lorsque le véhicule roule à plus de 10 km/h.")
                        end
                    end
                end
            })            
    
        else
            Items:Separator("")
            Items:Separator("Vous devez être dans un véhicule")
            Items:Separator("")
        end
    end)
end)
