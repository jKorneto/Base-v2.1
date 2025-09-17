-- local CurrentWeapon = {}

-- RegisterNetEvent('OneLife:Inventory:WeaponSet')
-- AddEventHandler('OneLife:Inventory:WeaponSet', function(data)
--     CurrentWeapon = data

--     if (data ~= nil) then
--         local throwableWeapon = Configcore_nui.filterItem.throwables[data.hash]

--         if (throwableWeapon) then
--             CreateThread(function()
--                 while CurrentWeapon and CurrentWeapon.hash do
--                     local playerPed = PlayerPedId()
                    
--                     if IsPedShooting(playerPed) then
--                         TriggerServerEvent('OneLife:Inventory:RemoveWeaponAmmo', CurrentWeapon.id, 1)
--                     end

--                     Wait(0)
--                 end
--             end)
--         end
--     end
-- end)


-- local QueueSaveAmmo = {}

-- local WaitShoot = false
-- AddEventHandler('CEventGunShot', function(entities, eventEntity, args)
--     if (eventEntity ~= PlayerPedId()) then return end

--     if (not WaitShoot) then
--         WaitShoot = true

--         if (QueueSaveAmmo[CurrentWeapon.id] == nil) then
--             QueueSaveAmmo[CurrentWeapon.id] = 0 
--         end

--         QueueSaveAmmo[CurrentWeapon.id] += 1

--         CreateThread(function()
--             Wait(20)
--             WaitShoot = false
--         end)
--     end
-- end)

-- CreateThread(function()
--     while true do

--         for id,ammo in pairs(QueueSaveAmmo) do
--             TriggerServerEvent('OneLife:Inventory:RemoveWeaponAmmo', id, ammo)

--             QueueSaveAmmo[id] = nil
--         end

        
--         local ped = PlayerPedId()
--         if (GetSelectedPedWeapon(ped) ~= -1569615261) then
--             local _, weaponHash = GetCurrentPedWeapon(ped, true);

--             if (CurrentWeapon.hash ~= weaponHash) then
--                 RemoveAllPedWeapons(PlayerPedId())
--             end

--             if (CurrentWeapon == nil and weaponHash) then
--                 RemoveAllPedWeapons(PlayerPedId())
--             end

--         end


--         Wait(1000)
--     end
-- end)

local bypassWeaponAnim2 = false

function WeaponEquip()
    local playerPed = PlayerPedId()

    if (not bypassWeaponAnim2) then
        if (not IsPedInAnyVehicle(playerPed, false)) then
            local dict, anim = 'reaction@intimidation@1h', 'intro'
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Wait(10)
            end

            TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, -1, 49, 0, false, false, false)

            Wait(2000)

            ClearPedTasks(playerPed)
        end
    end
end

RegisterNetEvent('OneLife:Inventory:WeaponEquip', function()
    WeaponEquip()
end)

function WeaponDisarm()
    local playerPed = PlayerPedId()

    if (not bypassWeaponAnim2) then
        if (not IsPedInAnyVehicle(playerPed, false)) then
            local dict, anim = 'reaction@intimidation@1h', 'outro'

            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Wait(1)
            end

            TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, -1, 49, 0, false, false, false)

            Wait(2000)
            ClearPedTasks(playerPed)
        end
    end
end


RegisterNetEvent('OneLife:Inventory:WeaponDisarm', function()
    WeaponDisarm()
end)

RegisterCommand("weaponbypass", function()
	bypassWeaponAnim = not bypassWeaponAnim
	if ESX.GetPlayerData()['group'] == "fondateur" then
		if not bypassWeaponAnim then
			ESX.ShowNotification("weaponbypass ~s~désactivé")
			bypassWeaponAnim2 = false
		else
			bypassWeaponAnim2 = true
			ESX.ShowNotification("weaponbypass ~s~activé")
		end
	else
		ESX.ShowNotification("Permission invalide")
	end
end)