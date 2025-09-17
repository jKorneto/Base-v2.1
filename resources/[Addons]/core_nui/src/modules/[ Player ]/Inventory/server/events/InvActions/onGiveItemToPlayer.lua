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

RegisterNetEvent('OneLife:Inventory:GiveItemToPlayer')
AddEventHandler('OneLife:Inventory:GiveItemToPlayer', function(targetId, data)
    local xPlayer = ESX.GetPlayerFromId(source)

    local tPlayer = ESX.GetPlayerFromId(targetId)
    
    local index = data.index
    local count = data.count

    local targetInv = MOD_inventory:getInventoryPlayerByLicense(tPlayer.identifier)

    if (not targetInv) then
        print('Error, secondary inventory not exists ! Event: GiveToPlayer')
        return
    end

    if (xPlayer and targetInv) then
        local PlayerInventory = xPlayer.getInventory()
        local TargetInventory = targetInv.inventoryItems

        if (not PlayerInventory or not TargetInventory or not PlayerInventory[index]) then
            print('Error, items are not exist in player or secondary inventory ! Event: GiveToPlayer')
            return
        end

        ------HERE CHECK ITEM IS TREDABLE

        local playeritem = json.decode(json.encode(PlayerInventory[index]))

        if (playeritem == "empty") then return end

        if (not count or count > playeritem.count) then count = playeritem.count end

        local ItemInfos = MOD_Items:getItem(playeritem.name)
        if (not ItemInfos) then return end


        -- if (SecondInv.inventoryClass:) then     HERE CHECK ITEM TRADABLE

        if (playerDied[xPlayer.identifier] == true) then
            return xPlayer.showNotification("Vous ne pouvez pas donner d'item en etant mort")
        end

        if (MOD_inventory:getWeaponIsPerma(playeritem.name)) then return end ---GET WEAPON IS PERMA

        if (MOD_inventory:getItemSecurActions(playeritem)) then return end ---GET ITEM IS PROTECTED

        local SecondMaxWeight = targetInv:getInventoryMaxWeight()
        local SecondWeight = targetInv:getInventoryWeight()

        if (ItemInfos.weight == 0 or SecondMaxWeight >= (SecondWeight + (ItemInfos.weight * count))) then
            local AvailableSlot = targetInv:availableSlot()
            if (AvailableSlot) then
                local RemoveSucces = xPlayer.removeInventoryItemAtSlot(index, count)
                if (RemoveSucces) then
                    if (playeritem.id == xPlayer.get('currentWeapon')) then
                        RemoveAllPedWeapons(GetPlayerPed(xPlayer.source))
                    end

                    targetInv:addItemToSlot(AvailableSlot, count, playeritem)

                    tPlayer.showNotification("Vous avez reçu x"..count.." "..playeritem.name)
                    xPlayer.showNotification("Vous avez donner x"..count.." "..playeritem.name)


                    local IdShow = ""
                    if (playeritem.id ~= nil) then 
                        IdShow = ' ( '..playeritem.id..' )'
                    end

                    local local_date = os.date('%H:%M:%S', os.time())
                    
                    local content = {
                        {
                            ["title"] = "**Don d'item :**",
                            ["fields"] = {
                                { name = "- Donateur :", value = xPlayer.name.." ["..xPlayer.source.."] ["..xPlayer.identifier.."]" },
                                { name = "- Item :", value = playeritem.name.." x"..count..IdShow },
                                { name = "- Receveur :", value = tPlayer.name.." ["..tPlayer.source.."] ["..tPlayer.identifier.."]" },
                            },
                            ["type"]  = "rich",
                            ["color"] = 1000849,
                            ["footer"] =  {
                              ["text"]= "Powered for OneLife ©   |  "..local_date.."",
                              ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
                            },
                        }
                    }
                    MOD_inventory:sendWebHook("OneLifeRP - LOGS", content, "https://discord.com/api/webhooks/1310470874897580135/tp5kfu0SsFFtzvrqntDTrl-cpONtHGEnfH8DwTjgVx6kDvoLJZkWE2-Oy6Nq0FCPjGoE")
                end
            else
                xPlayer.showNotification("Le joueur n'a plus de place !")
            end
        else
            xPlayer.showNotification("Le joueur est trop lourd !")
        end
    end
end)