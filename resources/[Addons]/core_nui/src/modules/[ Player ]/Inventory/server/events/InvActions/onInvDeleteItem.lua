local playerDied = {}

AddEventHandler("OneLife:Player:playerDied", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (playerDied[xPlayer.identifier] == nil) then
            playerDied[xPlayer.identifier] = true
        end
    end
end)

AddEventHandler("OneLife:Player:playerRevived", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (playerDied[xPlayer.identifier] == true) then
            playerDied[xPlayer.identifier] = nil
        end
    end
end)

RegisterNetEvent('OneLife:Inventory:InvDeleteItem')
AddEventHandler('OneLife:Inventory:InvDeleteItem', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)

    local index = data.index
    local count = data.count
    local inventoryType = data.inventoryType

    if (inventoryType == 'main') then
        local PlayerInventory = xPlayer.getInventory()
        local playeritem = json.decode(json.encode(PlayerInventory[index]))

        if (playerDied[xPlayer.identifier] == true) then
            return xPlayer.showNotification("Vous ne pouvez pas jeter d'item en etant mort")
        end

        xPlayer.removeInventoryItemAtSlot(index, count)

        local local_date = os.date('%H:%M:%S', os.time())
        local Content = {
            {
                ["title"] = "**Drop item :**",
                ["fields"] = {
                    { name = "- Joueur qui a jeter :", value = xPlayer.name.." ["..source.."] ["..xPlayer.identifier.."]" },
                    { name = "- item drop :", value = count.."x "..playeritem.name },
                },
                ["type"]  = "rich",
                ["color"] = 1000849,
                ["footer"] =  {
                  ["text"]= "Powered for OneLife ©   |  "..local_date.."",
                  ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
                },
            }
        }

        MOD_inventory:sendWebHook('Logs Delete item', Content, "https://discord.com/api/webhooks/1310471328133939271/NmhO4J75KGAK4ZaOoVkNpWgYbg0KFOhYpKRHbSIF3k1SiNSGF_oCSZDUrKpRdQ8vkrtb")
    end
end)