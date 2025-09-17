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

RegisterNetEvent('OneLife:Inventory:InvMoveToMain')
AddEventHandler('OneLife:Inventory:InvMoveToMain', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    local index = data.index
    local droppedTo = data.droppedTo
    local count = data.count

    local SecondInv = MOD_inventory:getSecondInventoryData(xPlayer.SecondInvData)

    if (not SecondInv) then
        print('Error, secondary inventory not exists ! Event: InvMoveToMain')
        return
    end

    if (SecondInv.type == "player") then return end

    if (xPlayer) then
        local PlayerInventory = xPlayer.getInventory()
        local SecondInventory = SecondInv.inventoryItems

        if (not PlayerInventory or not SecondInventory or not PlayerInventory[droppedTo] or not SecondInventory[index]) then
            print('Error, items are not exist in player or secondary inventory ! Event: InvMoveToMain')
            return
        end
        
        local playeritem = json.decode(json.encode(PlayerInventory[droppedTo]))
        local seconditem = json.decode(json.encode(SecondInventory[index]))

        if (not playeritem or not seconditem) then return end
        
        if (seconditem == "empty") then return end

        if (not count or count > seconditem.count) then count = seconditem.count end

        local ItemInfos = MOD_Items:getItem(seconditem.name)

        if (playerDied[xPlayer.identifier] == true) then
            return xPlayer.showNotification("Vous ne pouvez pas prendre d'item en etant mort")
        end
        
        if (not ItemInfos) then return end
        
        local PlayerMaxWeight =  40
        local PlayerWeight =  xPlayer.getWeight()

        if (ItemInfos.weight == 0 or PlayerMaxWeight >= PlayerWeight + (ItemInfos.weight * count)) then
            if (xPlayer.isFreeSlotOrSameItem(droppedTo, seconditem.name)) then
                local RemoveSucces = SecondInv:removeInventoryItemAtSlot(index, count)
                if (RemoveSucces) then
                    xPlayer.addItemToSlot(droppedTo, count, seconditem)

                    if (SecondInv.type == "player") then
                        xPlayer.SecondInvData:logsRetrait(source, xPlayer, seconditem.name, count)
                    elseif (SecondInv.type == "vehicule") then
                        xPlayer.SecondInvData:saveInventory()
                        xPlayer.SecondInvData:logsRetrait(source, xPlayer, seconditem.name, count)
                    elseif (SecondInv.type == "properties") then
                        xPlayer.SecondInvData:saveInventory()
                        xPlayer.SecondInvData:logsRetrait(source, xPlayer, seconditem.name, count)
                    elseif (SecondInv.type == "coffrebuilder") then
                        xPlayer.SecondInvData:saveInventory()
                        xPlayer.SecondInvData:logsRetrait(source, xPlayer, seconditem.name, count)
                    elseif (SecondInv.type == "coffresociety") then
                        xPlayer.SecondInvData:saveInventory()
                        xPlayer.SecondInvData:logsRetrait(source, xPlayer, seconditem.name, count)
                    elseif (SecondInv.type == "coffregang") then
                        xPlayer.SecondInvData:saveInventory()
                        xPlayer.SecondInvData:logsRetrait(source, xPlayer, seconditem.name, count)
                    end
                end
            end
        else
            ----NOTIF PLAYER
        end
    end
end)