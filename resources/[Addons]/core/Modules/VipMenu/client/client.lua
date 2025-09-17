local main_menu = RageUI.AddMenu("", "Faites vos actions")
local prop_menu = RageUI.AddSubMenu(main_menu, "", "Faites vos actions")
local delete_prop_menu = RageUI.AddSubMenu(prop_menu, "", "Faites vos actions")

local WeaponSkin = {
    VariantColor = {
        "~s~Or",
        "~s~Bleu",
        "~s~Rose",
        "~s~Armée",
        "~s~Orange",
        "~s~Vert",
        "~s~Platine",
    },
    VariantColorIndex = 1
}

local Pets = {}
local DriftMode = {}
local GestPet = false
local DriftModeActif = false
local DriftSpeedLimit = 150.0

local LastSpawnTime = 0
local CoolDownTime = 900000 -- 15 minutes en millisecondes
local HasSpawned = false

RegisterNetEvent("iZeyy:VIPSys:openVIPMenu", function()
    if not exports.epicenter:IsInStaff() then
        local isVIP = exports["engine"]:isPlayerVip()

        if (isVIP) then
            main_menu:Toggle()
        end
    else
        ESX.ShowNotification("Action impossible en mode staff !")
    end
end)

local objectList = {}
local objectCounter = 0

local function spawnProps(model, label)
    local player = PlayerPedId()
    local prop = (type(model) == 'number' and model or GetHashKey(model))
    local coords  = GetEntityCoords(player)
    local forward = GetEntityForwardVector(player)
    local x, y, z   = table.unpack(coords + forward * 3.0)

    if objectCounter < 3 then
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

local function TintWeapon(weapon, tintIndex, color)
    for _, TintNum in pairs(Config["VIP"]["WeaponAllowed"]) do
        if weapon == GetHashKey(TintNum) then
            local playerPed = PlayerPedId()
            SetPedWeaponTintIndex(playerPed, GetHashKey(TintNum), tintIndex)
            ESX.ShowNotification("Vous avez changé la couleur de votre arme en " .. color)
            return
        end
    end
    if weapon == -1569615261 then
        ESX.ShowNotification("Tu ne peux pas avoir de skin sur tes mains")
    end
end

local function TakeOutPet()
    if not DoesEntityExist(vipdog) then
        RequestModel('a_c_husky')
        while not HasModelLoaded('a_c_husky') do Wait(0) end
        vipdog = CreatePed(4, 'a_c_husky', GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -0.98), 0.0, true, true)
        SetEntityAsMissionEntity(vipdog, true, true)
    else
        return
    end
end

local function RetracPet()
    if DoesEntityExist(vipdog) then
        DeleteEntity(vipdog)
    else
        return
    end
end

local function loadDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

main_menu:IsVisible(function(Items)
    Items:List("Skin Armes", WeaponSkin.VariantColor, WeaponSkin.VariantColorIndex, nil, {}, true, {
        onListChange = function(index)
            WeaponSkin.VariantColorIndex = index
        end,
        onSelected = function(index)
            local selectedColor = WeaponSkin.VariantColor[index]
            local PlayerPed = PlayerPedId()
            if index == 1 then
                if IsPedArmed(PlayerPed, 6) then 
                    local weapon = GetSelectedPedWeapon(PlayerPed)
                    TintWeapon(weapon, 2, "Or")
                else
                    ESX.ShowNotification("Vous devez être armé pour changer la couleur de votre arme.")
                end
            elseif index == 2 then
                if IsPedArmed(PlayerPed, 6) then 
                    local weapon = GetSelectedPedWeapon(PlayerPed)
                    TintWeapon(weapon, 5, "Bleu")
                else
                    ESX.ShowNotification("Vous devez être armé pour changer la couleur de votre arme.")
                end
            elseif index == 3 then
                if IsPedArmed(PlayerPed, 6) then 
                    local weapon = GetSelectedPedWeapon(PlayerPed)
                    TintWeapon(weapon, 3, "Rose")
                else
                    ESX.ShowNotification("Vous devez être armé pour changer la couleur de votre arme.")
                end
            elseif index == 4 then
                if IsPedArmed(PlayerPed, 6) then 
                    local weapon = GetSelectedPedWeapon(PlayerPed)
                    TintWeapon(weapon, 4, "Armée")
                else
                    ESX.ShowNotification("Vous devez être armé pour changer la couleur de votre arme.")
                end
            elseif index == 5 then
                if IsPedArmed(PlayerPed, 6) then 
                    local weapon = GetSelectedPedWeapon(PlayerPed)
                    TintWeapon(weapon, 6, "Orange")
                else
                    ESX.ShowNotification("Vous devez être armé pour changer la couleur de votre arme.")
                end
            elseif index == 6 then
                if IsPedArmed(PlayerPed, 6) then 
                    local weapon = GetSelectedPedWeapon(PlayerPed)
                    TintWeapon(weapon, 1, "Vert")
                else
                    ESX.ShowNotification("Vous devez être armé pour changer la couleur de votre arme.")
                end
            elseif index == 7 then
                if IsPedArmed(PlayerPed, 6) then 
                    local weapon = GetSelectedPedWeapon(PlayerPed)
                    TintWeapon(weapon, 7, "Platine")
                else
                    ESX.ShowNotification("Vous devez être armé pour changer la couleur de votre arme.")
                end
            end
        end
    })
    Items:Button("Spawn un Props", nil, { RightLabel = "→→" }, true, {}, prop_menu)
    Items:Button("Faggio de secours", nil, { RightLabel = "→→" }, true, {
        onSelected = function()
            local PlayerPed = PlayerPedId()
            if not IsPedInAnyVehicle(PlayerPed, false) then
                TriggerServerEvent("iZeyy:VIP:SpwanCar")
            else
                ESX.ShowNotification("Vous ne pouvez pas faire spawn de véhicule en étant dans un véhicule")
            end
        end
    })
    Items:Checkbox("Mode Drift", nil, DriftMode.States, {}, {
        onSelected = function()
            if DriftMode.States then 
                DriftMode.States = false
                DriftModeActif = false
                ESX.ShowNotification("Vous désactivez le mode drift")
            else
                DriftMode.States = true 
                DriftModeActif = true
                activeDrift()
                ESX.ShowNotification("Vous activez le mode drift")
            end
        end
    })
    Items:Checkbox("Chien de compagnie", nil, Pets.States, {}, {
        onSelected = function()
            if Pets.States then 
                Pets.States = false
                GestPet = false
                ESX.ShowNotification("Vous avez rentrez votre chien")
                RetracPet()
            else
                local PlayerPed = PlayerPedId()
                if not IsPedInAnyVehicle(PlayerPed, false) then
                    Pets.States = true 
                    GestPet = true
                    ESX.ShowNotification("Vous avez sorti votre chien")
                    TakeOutPet()
                else
                    ESX.ShowNotification("Vous ne pouvez pas sortir votre chien en étant dans un véhicule")
                end
            end
        end
    })    
    if GestPet then
        Items:Line()
        Items:Button("Lui dire de s'assoir", nil, { RightLabel = "→→" }, true, {
            onSelected = function()
                if DoesEntityExist(vipdog) then
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(vipdog), true) <= 5.0 then
                        if IsEntityPlayingAnim(vipdog, "creatures@rottweiler@amb@world_dog_sitting@base", "base", 3) then
                            ClearPedTasks(vipdog)
                        else
                            loadDict('rcmnigel1c')
                            TaskPlayAnim(PlayerPedId(), 'rcmnigel1c', 'hailing_whistle_waive_a', 8.0, -8, -1, 120, 0, false, false, false)
                            Wait(2000)
                            loadDict("creatures@rottweiler@amb@world_dog_sitting@base")
                            TaskPlayAnim(vipdog, "creatures@rottweiler@amb@world_dog_sitting@base", "base", 8.0, -8, -1, 1, 0, false, false, false)
                        end
                    else
                        ESX.ShowNotification('~r~Le chien est trop loin de vous !')
                    end
                else
                    ESX.ShowNotification('~r~Vous n\'avez pas de chien !')
                end
            end
        })
        Items:Button("Lui dire de vous suivre", nil, { RightLabel = "→→" }, true, {
            onSelected = function()
                local playerPed = PlayerPedId()
                if DoesEntityExist(vipdog) then
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(vipdog), true) <= 5.0 then
                        ExecuteCommand("me dit au chien de le suivre")
                        TaskGoToEntity(vipdog, playerPed, -1, 1.0, 10.0, 1073741824, 1)
                    else
                        ESX.ShowNotification('Le chien est trop loin de vous !')
                    end
                else
                    ESX.ShowNotification('Vous n\'avez pas de chien !')
                end
            end
        })
    end
end)


prop_menu:IsVisible(function(Items)
    Items:Button("Canapé", nil, { RightLabel = "→" }, true, {
        onSelected = function()
            local PlayerPed = PlayerPedId()
            if IsPedInAnyVehicle(PlayerPed, false) then
                ESX.ShowNotification("Vous ne pouvez faire apparaitres d'objets dans un vehicule")
            else
                spawnProps("v_tre_sofa_mess_b_s", "Canapé")
            end
        end
    })
    Items:Button("Parasol", nil, { RightLabel = "→" }, true, {
        onSelected = function()
            local PlayerPed = PlayerPedId()
            if IsPedInAnyVehicle(PlayerPed, false) then
                ESX.ShowNotification("Vous ne pouvez faire apparaitres d'objets dans un vehicule")
            else
                spawnProps("prop_parasol_01", "Parasol")
            end
        end
    })
    Items:Button("Chaise", nil, { RightLabel = "→" }, true, {
        onSelected = function()
            local PlayerPed = PlayerPedId()
            if IsPedInAnyVehicle(PlayerPed, false) then
                ESX.ShowNotification("Vous ne pouvez faire apparaitres d'objets dans un vehicule")
            else
                spawnProps("prop_skid_chair_01", "Chaise")
            end
        end
    })
    Items:Line()
    Items:Button("Supprimer", nil, {}, true, {}, delete_prop_menu)
end)

local function propsMarker(props)
    local pos = GetEntityCoords(props)
    DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 32, 118, 211, 200, 0, 1, 2, 0, nil, nil, 0)
end

delete_prop_menu:IsVisible(function(Items)
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

local function angle(veh)
    if not veh then return false end
    local vx, vy, vz = table.unpack(GetEntityVelocity(veh))
    local modV = math.sqrt(vx * vx + vy * vy)
    local rx, ry, rz = table.unpack(GetEntityRotation(veh, 0))
    local sn, cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))

    if GetEntitySpeed(veh) * 3.6 < 5 or GetVehicleCurrentGear(veh) == 0 then return 0, modV end
    
    local cosX = (sn * vx + cs * vy) / modV
    if cosX > 0.966 or cosX < 0 then return 0, modV end
    return math.deg(math.acos(cosX)) * 0.5, modV
end

function activeDrift()
    CreateThread(function()
        while DriftModeActif do
            local Sleep = 1000
    
            local ped = GetPlayerPed(-1)
            if IsPedInAnyVehicle(ped, false) then
                local car = GetVehiclePedIsUsing(ped)
                local ang, speed = angle(car)

                Sleep = 0
                local CarSpeed = GetEntitySpeed(car)

                if GetPedInVehicleSeat(car, -1) == ped then
                    if CarSpeed * 3.6 <= DriftSpeedLimit then
                        if IsControlPressed(1, 21) then
                            SetVehicleReduceGrip(car, true)
                        else
                            SetVehicleReduceGrip(car, false)
                        end
                    end
                end
            end

            Wait(Sleep)
        end
    end)
end