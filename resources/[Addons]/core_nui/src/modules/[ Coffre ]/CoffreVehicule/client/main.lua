-- RegisterKeyMapping('opencoffre', 'Ouvrir le coffre vehicule', 'keyboard', 'L')
-- RegisterCommand("opencoffre", function ()
--     openmenuvehicle()
-- end)

local isInventoryOpen = false

function openmenuvehicle()
    if (MOD_inventory.class:getPlayerInInventory()) then return end

    local playerCoords = GetEntityCoords(PlayerPedId())

    if IsPedInAnyVehicle(PlayerPedId(), false) then
        ESX.ShowNotification("~s~Vous ne pouvez ouvrir le coffre ici !")
        return
    else
        local closestVehicle, closestDistance = API_Vehicles:getClosest(vector3(playerCoords.x, playerCoords.y, playerCoords.z))

        -- Vérifie s'il y a un véhicule à proximité
        if (not closestVehicle or closestVehicle == 0) then
            ESX.ShowNotification("~s~Aucun véhicule à proximité")
            return
        end

        -- Vérifie si la distance au véhicule est supérieure à 5 mètres
        if (closestDistance > 10.0) then
            ESX.ShowNotification("~s~Aucun véhicule à proximité")
            return
        end

        -- Vérifie si le coffre du véhicule est fermé
        if (GetVehicleDoorLockStatus(closestVehicle) == 2) then
            TriggerEvent("esx:showNotification", "~s~Ce coffre est fermé.")
        else
            -- Ouverture du coffre si toutes les conditions sont respectées
            ExecuteCommand("me Ouvre le coffre du véhicule...")
            TriggerServerEvent("OneLife:Inventory:OpenSecondInventory", "vehicule", NetworkGetNetworkIdFromEntity(closestVehicle))

            isInventoryOpen = true

            CreateThread(function()
                while isInventoryOpen do
                    Wait(1000)

                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local vehicleCoords = GetEntityCoords(closestVehicle)
                    local distanceToVehicle = Vdist(playerCoords, vehicleCoords)

                    if distanceToVehicle > 10.0 then
                        exports['core_nui']:CloseInventory()
                        ESX.ShowNotification("Vous êtes trop loin du véhicule ! L'inventaire est fermé.")
                        isInventoryOpen = false
                    end

                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        exports['core_nui']:CloseInventory()
                        isInventoryOpen = false
                    end
                end
            end)
        end
    end
end

function VehicleInFront()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end
