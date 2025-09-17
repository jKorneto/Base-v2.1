RegisterNetEvent('OneLife:Fuel:PayFuelVehicle')
AddEventHandler('OneLife:Fuel:PayFuelVehicle', function(cost)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        local roundedCost = ESX.Math.Round(cost)
        
        local playerMoney = xPlayer.getAccount("cash");
        local HaveMoney = (playerMoney.money >= roundedCost)

        if (HaveMoney) then
            xPlayer.removeAccountMoney("cash", roundedCost)
            
            xPlayer.showNotification("Vous avez payé " .. roundedCost .. "$ d'essence")
        else
            xPlayer.showNotification("Vous n'avez pas assez d'argent")
        end
    end
end)

ESX.RegisterServerCallback("OneLife:Fuel:GetPlayerMoney", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        local playerMoney = xPlayer.getAccount("cash");

        cb(playerMoney.money)
    end
end)

local function SendCarLogs(name, title, message, web)
    local local_date = os.date('%H:%M:%S', os.time())
  
	local embeds = {
		{
			["title"]= title,
			["description"]= message,
			["type"]= "rich",
			["color"] = 1000849,
			["footer"]= {
			    ["text"]= "Made for OneLife © |  "..local_date.."",
				["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
			},
		}
	}
  
    if message == nil or message == '' then return false end
    PerformHttpRequest(web, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 

local AuthorizedZones = {
    vector3(229.700, -800.1149, 30.5722),  -- Bennys
    vector3(1737.84, 3719.28, 33.04),     -- Sandy
    vector3(128.7822, 6622.9965, 30.7828), -- Paleto
    vector3(1855.11, 2592.72, 44.67),     -- Prison
    vector3(4905.776367, -5205.583496, 2.512049), -- Cayo Perico
    vector3(1157.349609, -1475.707031, 34.692581), -- El Burro Heights
    vector3(-1896.798, -335.5756, 49.23235), -- Hospital Ocean
    vector3(-1150.694, 2675.76, 18.09392),  -- Military
    vector3(-511.6546, -610.9404, 30.29809), -- Garage Rouge
    vector3(885.0427, -40.03032, 78.76414), -- Casino
    vector3(-1002.544434, -2606.466797, 14.127680), -- Airport
    vector3(409.755188, -1343.281860, 31.053566), -- Hospital
    vector3(-309.8607, -888.9569, 31.0806), -- Parking Rouge
    vector3(-795.0725, -1502.321, -0.42639), -- LS Dock
    vector3(1334.61, 4264.68, 29.86), -- Sandy Dock
    vector3(-290.46, 6622.72, -0.4747), -- Paleto Dock
    vector3(4893.5342, -5168.347, 1.95812), -- Cayo Perico Dock
    vector3(-1275.4285888672, -3388.3779296875, 13.9296875), -- LS Plane
    vector3(1707.7846679688, 3254.2680664062, 41.024169921875), -- Sandy Plane
    vector3(4483.8989257812, -4493.419921875, 4.1904296875) -- Cayo Perico Plane
}

RegisterNetEvent("OneLife:Garage:SendKeys", function(Target, Plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(Target)


    local PlayerCoords = GetEntityCoords(GetPlayerPed(source))
    local TargetCoords = GetEntityCoords(GetPlayerPed(Target))

    if #(PlayerCoords - PlayerCoords) < 5.0 then

        local Player = GetPlayerPed(xPlayer.source)
        local Coords = GetEntityCoords(Player)

        local withinDistance = false
        for _, position in ipairs(AuthorizedZones) do
            if #(Coords - position) <= 15 then
                withinDistance = true
                break
            end
        end

        if not withinDistance then
            return xPlayer.showNotification("Vous n'etes pas dans une zone autorisée.")
        end

        if xPlayer and xTarget then
            local vehicle = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate AND owner = @owner", {
                ['@plate'] = Plate,
                ['@owner'] = xPlayer.identifier
            })

            if #vehicle > 0 then
                local vehicleData = vehicle[1]
                if vehicleData.stored == 1 then
                    if vehicleData.boutique == true then
                        xPlayer.showNotification("Vous ne pouvez pas vendre ce véhicule car il est dans la boutique.")
                        return
                    end
                    MySQL.Async.execute("UPDATE owned_vehicles SET owner = @newOwner WHERE plate = @plate", {
                        ['@newOwner'] = xTarget.identifier,
                        ['@plate'] = Plate
                    }, function(affectedRows)
                        if affectedRows > 0 then
                            MySQL.Async.execute("DELETE FROM owned_vehicles WHERE plate = @plate AND owner = @owner", {
                                ['@plate'] = Plate,
                                ['@owner'] = xPlayer.identifier
                            })
                            xPlayer.showNotification("Vous avez donné le véhicule plaqué [~b~"..Plate.."~s~] au joueurs " .. xTarget.getName())
                            xTarget.showNotification("Vous avez reçu un véhicule plaqué [~b~"..Plate.."~s~] du joueurs " .. xPlayer.getName())
                            SendCarLogs(
                                "Transfert de véhicule",
                                "OneLife | Garage",
                                ("Le joueur **%s** (***%s***) a donné le véhicule plaque **[%s]** au joueur **%s** (***%s***)"):format(
                                    xPlayer.getName(),
                                    xPlayer.identifier,
                                    Plate,
                                    xTarget.getName(),
                                    xTarget.identifier
                                ),
                                "https://discord.com/api/webhooks/1310456788507688980/bIPzz1NJW4IT701FHACDeP12KaoV4_pCkThHNECjRja-rqKvG1ezaNKmEa6AKKzW2wYe"
                            )
                        else
                            xPlayer.showNotification("Erreur lors du transfert du véhicule.")
                        end
                    end)
                else
                    xPlayer.showNotification("Vous devez d'abord stocker ce véhicule.")
                end
            else
                xPlayer.showNotification("Vous ne possédez pas ce véhicule.")
            end
        else
            xPlayer.showNotification("Le joueur cible est introuvable.")
        end
    else
        xPlayer.showNotification("Aucun joueurs a proximité.")
    end
end)