
local menu = {}

local PoundSpawnV = OneLife.enums.Pound.Prices['SpawnVehicle']
local AssuText = "Devenez ~b~VIP~s~ pour être assurée !"

function menu:LoadMenu(parent)
    menu.Menu = RageUI.CreateSubMenu(parent, "", "Fourrières")

    menu.Menu:IsVisible(function(Items)
        local vehicle = MOD_Vehicle.Pound.DataVehicle
        local CurrentPound = MOD_Vehicle.Pound.Data

        if (not vehicle) then
            Items:Separator("Chargement du véhicule")
        else
            local playerVip = exports["engine"]:isPlayerVip()

            if (playerVip) then
                PoundSpawnV = 0
                AssuText = "Vous etes assurée grace au ~b~VIP~s~"
            else
                PoundSpawnV = 0
                AssuText = "Vous etes assurée grace au ~b~VIP~s~"
            end

            Items:Button("Sortir le véhicule", AssuText, { RightLabel = "".. PoundSpawnV .."~g~$" }, true, {
                onSelected = function()

                    local position = CurrentPound['Spawn']

                    if (MOD_Vehicle:IsSpawnPointClear(position, 2)) then

                        TriggerServerEvent('OneLife:Pound:TakeVehicle', vehicle.plate, position)

                        MOD_Vehicle.Pound.vehicles = nil

                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification("~s~L'emplacement est occupé.")
                    end
                end
            });
        end
    end, nil, function()
        MOD_Vehicle.Garage.DataVehicle = {}
    end)
end

return menu