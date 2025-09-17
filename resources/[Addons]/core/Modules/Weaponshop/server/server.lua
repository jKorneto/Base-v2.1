local ppaPlayers = {}

local function isPlayerWithinDistance(xPlayer, positions, distance)
    local Player = GetPlayerPed(xPlayer.source)
    local Coords = GetEntityCoords(Player)

    for _, position in ipairs(positions) do
        if #(Coords - position) <= distance then
            return true
        end
    end

    return false
end

CreateThread(function()
    MySQL.Async.fetchAll("SELECT owner FROM user_licenses WHERE type = @type", {
        ["@type"] = "weapon"
    }, function(result)
        if (result) then
            for _, row in ipairs(result) do
                ppaPlayers[row.owner] = true
            end
            Shared.Log:Success("All players with PPA have been loaded.")
        else
            Shared.Log:Error("No players found with PPA")
        end
    end)
end)

RegisterNetEvent(Enums.Weaponshop.RequestPPA, function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        if not isPlayerWithinDistance(xPlayer, Config["Weaponshop"]["Pos"], 15) then
            return
        end

        if (ppaPlayers[xPlayer.identifier]) then
            TriggerClientEvent(Enums.Weaponshop.ReceiveInfo, xPlayer.source, true)
        else
            TriggerClientEvent(Enums.Weaponshop.ReceiveInfo, xPlayer.source, false)
        end
    end
end)

RegisterNetEvent(Enums.Weaponshop.BuyPPALicense, function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local Price = Config["Weaponshop"]["PPAPrice"]

    if (xPlayer) then

        if not isPlayerWithinDistance(xPlayer, Config["Weaponshop"]["Pos"], 15) then
            return
        end

        if (not ppaPlayers[xPlayer.identifier]) then
            local Bill = ESX.CreateBill(0, xPlayer.source, Price, "Weaponshop", "server")

            if (Bill) then
                ppaPlayers[xPlayer.identifier] = true
                MySQL.Async.execute("INSERT INTO user_licenses (owner, type) VALUES (@owner, @type)", {
                    ["@owner"] = xPlayer.identifier,
                    ["@type"] = "weapon"
                }, function(rowsChanged)
                    if (rowsChanged > 0) then
                        xPlayer.showNotification("Vous etes desormais detenteur du PPA")
                        xPlayer.addInventoryItem("weapon", 1)
                    else
                        Shared.Log:Error("Erreur lors de l'ajout du PPA dans la BDD")
                    end
                end)
            else
                xPlayer.showNotification("Vous avez refusé la facture")
            end
        else
            xPlayer.showNotification("Vous possedez déja le PPA")
        end
    end
end)

RegisterNetEvent(Enums.Weaponshop.BuyWeapon, function(name, label, price, cat, amout)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        if not isPlayerWithinDistance(xPlayer, Config["Weaponshop"]["Pos"], 15) then
            return
        end

        local CorrectItem = false
        for k, v in pairs(Config["Weaponshop"]["List"][cat]) do
            if name == v.name and label == v.label and price == v.price then
                CorrectItem = true
                break
            end
        end

        if (not CorrectItem) then
            return
        end

        if (CorrectItem) then
            if (cat == "VIP") then
                if (not xPlayer.GetVIP()) then
                    return xPlayer.showNotification("Vous devez possedez le VIP afin de pouvoir acheter cette armes")
                end
            end

            if (cat == "Letale") then
                if (not ppaPlayers[xPlayer.identifier]) then
                    return xPlayer.showNotification("Vous devez possedez le PPA afin d'acheter cette armes")
                end
            end

            if (xPlayer.canCarryItem(string.lower(name), amout)) then
                local newPrice = price * amout
                local Bill = ESX.CreateBill(0, xPlayer.source, newPrice, "Ammunation", "server")
                if Bill then
                    if (cat == "White" or cat == "Letale" or cat == "VIP") then
                        xPlayer.addWeapon(name, amout)
                        xPlayer.showNotification(("Vous avez reçu %s"):format(label))
                        CoreSendLogs(
                            "Achat d'arme",
                            "OneLife | Achat",
                            ("Le joueur **%s** (***%s***) a acheté **%s** (***%s***) a l'armurerie pour **%s$**."):format(
                                xPlayer.getName(),
                                xPlayer.identifier,
                                name,
                                label,
                                newPrice
                            ),
                            Config["Log"]["Other"]["BuyPPALicense"]
                        )
                    elseif (cat == "Munitions" or cat == "Accessories") then
                        xPlayer.addInventoryItem(name, amout)
                        xPlayer.showNotification(("Vous avez reçu %s"):format(label))
                        CoreSendLogs(
                            "Achat d'arme",
                            "OneLife | Achat",
                            ("Le joueur **%s** (***%s***) a acheté **%s** (***%s***) a l'armurerie pour **%s$**."):format(
                                xPlayer.getName(),
                                xPlayer.identifier,
                                name,
                                label,
                                newPrice
                            ),
                            Config["Log"]["Other"]["BuyPPALicense"]
                        )
                    end
                else
                    xPlayer.showNotification("Vous avez refusé la facture")
                end
            else
                xPlayer.showNotification("Vous n'avez pas assez de place sur vous")
            end
        end

    end
        
end)

-- Ammo
ESX.RegisterUsableItem("clip", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local HasItem = xPlayer.getInventoryItem("clip")
        if (HasItem and HasItem.quantity > 0) then
            TriggerClientEvent("iZeyy:Ammunation:AddClip", xPlayer.source) 
        else
            DropPlayer(xPlayer.source, "Desynchronisation avec le serveur | Utilisation d'items (CLIP)")
        end
    end
end)

RegisterNetEvent("iZeyy:Ammunation:RemoveClip", function(NumberAmmo)
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local HasItem = xPlayer.getInventoryItem("clip")
        if (HasItem and HasItem.quantity > 0) then
            xPlayer.removeInventoryItem("clip", 1)
            TriggerEvent("OneLife:Inventory:AddWeaponAmmo", false, NumberAmmo, xPlayer.source)
        else
            DropPlayer(xPlayer.source, "Desynchronisation avec le serveur | Utilisation d'items (CLIP)")
        end
    end
end)

ESX.RegisterUsableItem("munitions", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local HasItem = xPlayer.getInventoryItem("munitions")
        if (HasItem and HasItem.quantity > 0) then
            TriggerClientEvent("iZeyy:Ammunation:AddAmmo", xPlayer.source)
        else
            DropPlayer(xPlayer.source, "Desynchronisation avec le serveur | Utilisation d'items (MUNITIONS)")
        end
    end
end)

RegisterNetEvent("iZeyy:Ammunation:RemoveAmmo", function(NumberAmmo)
    local xPlayer = ESX.GetPlayerFromId(source) 
    if (xPlayer) then
        local HasItem = xPlayer.getInventoryItem("munitions")
        if (HasItem and HasItem.quantity > 0) then
            xPlayer.removeInventoryItem("munitions", 1)
            TriggerEvent("OneLife:Inventory;AddWeaponAmmo", false, NumberAmmo, xPlayer.source)
        else
            DropPlayer(xPlayer.source, "Desynchronisation avec le serveur | Utilisation d'items (MUNITIONS)")
        end
    end
end)