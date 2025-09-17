
local menu = {}

function menu:LoadMenu(parent)
    menu.Menu = RageUI.CreateSubMenu(parent, "", "Garage")

    menu.Menu:IsVisible(function(Items)
        Items:Button("Sortir le véhicule", nil, { RightLabel = "→→"}, true, {
            onSelected = function()
                local vehicle = MOD_Vehicle.Garage.DataVehicle
                local position = MOD_Vehicle.Garage.Data['Out']
                
                if (MOD_Vehicle:IsSpawnPointClear(position, 2)) then

                    TriggerServerEvent('OneLife:Garage:TakeVehicle', vehicle.plate, position)
                    MOD_Vehicle.Garage.vehicles = nil

                    RageUI.CloseAll()
                else
                    ESX.ShowNotification("~s~L'emplacement est occupé.")
                end
            end
        });
        Items:Button("Donner les clefs", "~r~Cette action donne les clés de façon permanente", { RightLabel = "→→"}, true, {
            onSelected = function()
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance < 5.0 then

                    local vehicle = MOD_Vehicle.Garage.DataVehicle
                
                    if vehicle and vehicle.plate then
                        TriggerServerEvent("OneLife:Garage:SendKeys", GetPlayerServerId(closestPlayer), vehicle.plate)
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification("Aucun véhicule sélectionné.")
                    end
                else
                    ESX.ShowNotification("Aucun joueurs a coté de vous")
                end
            end
        });
    end, nil, function()
        MOD_Vehicle.Garage.DataVehicle = {}
    end)
end

return menu