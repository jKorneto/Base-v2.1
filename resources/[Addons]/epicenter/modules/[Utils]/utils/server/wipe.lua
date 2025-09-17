---@param identifier string
local function deleteAllOwnedVehicles(identifier)
    if (type(identifier) == "string") then
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
            ['@owner'] = identifier
        }, function(result)
            for i = 1, #result, 1 do
                local plate = result[i].plate
                local isVehicleFromShop = result[i].boutique ~= nil and (result[i].boutique == 1 or result[i].boutique == true)

                exports["inventory"]:deleteInventory("trunk-"..plate)
                exports["inventory"]:deleteInventory("glovebox-"..plate)

                if (not isVehicleFromShop) then
                    MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
                        ['@plate'] = plate
                    })
                end
            end
        end)
    end
end

---@param identifier string
local function updatePlayerValues(identifier)
    if (type(identifier) == "string") then
        for k, v in pairs(ConfigWipe.TableUpdate) do
            MySQL.Async.execute("UPDATE "..v.name.." SET "..v.var.." = @"..v.var.." WHERE "..v.id.." = @"..v.id.."", {
                ["@"..v.id] = identifier,
                ["@"..v.var] = v.value
            })
        end
    end
end

---@param identifier string
local function deletePlayerValues(identifier)
    if (type(identifier) == "string") then
        for k, v in pairs(ConfigWipe.TableDelete) do 
            MySQL.Async.execute("DELETE FROM "..v.name.." WHERE "..v.id.." = @"..v.id.."", {
                ["@"..v.id] = identifier
            })
        end
    end
end

---@param identifier string
local function resetAccounts(identifier)
    if (type(identifier) == "string") then
        local newAccounts = {}

        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
            ["@identifier"] = identifier
        }, function(result)
            accounts = json.decode(result[1].accounts)

            if (accounts ~= nil) then
                for k, v in pairs(accounts) do 
                    table.insert(newAccounts, {
                        name = v.name,
                        money = 0
                    })
                end

                MySQL.Async.execute("UPDATE users SET accounts = @accounts WHERE identifier = @identifier", {
                    ["@identifier"] = identifier,
                    ["@accounts"] = json.encode(newAccounts),
                })
            end
        end)
    end
end

---@param identifier string
local function resetInventory(identifier)
    if (type(identifier) == "string") then
        MySQL.Async.fetchAll("SELECT * FROM inventory_4_items WHERE uniqueID = @uniqueID", {
            ["@uniqueID"] = identifier
        }, function(result)
            local inventory = {}
            local items = json.decode(result[1].items)

            for k, v in pairs(items) do
                if (ESX.IsWeaponPermanent(v.name) or v.name == "cash" or v.name == "dirtycash") then
                    table.insert(inventory, v)
                end
            end

            MySQL.Async.execute("UPDATE inventory_4_items SET items = @items WHERE uniqueID = @uniqueID", {
                ["@uniqueID"] = identifier,
                ["@items"] = json.encode(inventory),
            })
        end)
    end
end

RegisterCommand("wipe", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer.source == 0 or (xPlayer and ConfigWipe.Autorized[xPlayer.getGroup()])) then
        local identifier = args[1]

        if (type(identifier) == "string") then
            local tPlayer = ESX.GetPlayerFromIdentifier(identifier)

            if (type(tPlayer) == "table") then
                DropPlayer(tPlayer.source, "Vous venez d'être WIPE, vous pouvez dès à présent vous reconnecter, bon jeu sur OneLife !")
            end

            exports["engine"]:removeAllOutfits(identifier)
            deleteAllOwnedVehicles(identifier)
            resetInventory(identifier)
            updatePlayerValues(identifier)
            deletePlayerValues(identifier)
            resetAccounts(identifier)

            if (xPlayer.source ~= 0) then
                xPlayer.showNotification(("Le joueur ~b~%s~s~ à été wipe !"):format(tPlayer and tPlayer.getName() or identifier))
            else
                print(("Le joueur (^4%s^0) à été wipe !"):format(tPlayer and tPlayer.getName() or identifier))
            end

            SendLogs("Wipe", "OneLife | Wipe", "La licence **"..args[1].."** vient de se faire wipe par **"..xPlayer.getName().."**", "https://discord.com/api/webhooks/1310473050004918342/e4rmeZ5BA3rO9lpZK5v-QC2wYWPrL5RmXXvi6t7ARVS9nY4zt5XnHGQgddQzMTPq-co9")
        else
            if (xPlayer.source ~= 0) then
                xPlayer.showNotification("Veuillez saisir la licence du joueur à wipe")
            else
                print("It is necessary to enter the license to wipe the player")
            end
        end
    end
end)