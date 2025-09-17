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

RegisterNetEvent('OneLife:Inventory:InvMoveToSecond')
AddEventHandler('OneLife:Inventory:InvMoveToSecond', function(data, weaponSave)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    local index = data.index
    local droppedTo = data.droppedTo
    local count = data.count

    local SecondInv = MOD_inventory:getSecondInventoryData(xPlayer.SecondInvData)

    if (not SecondInv) then
        print('Error, secondary inventory not exists ! Event: InvMoveToSecond')
        return
    end

    if (SecondInv.type == "player") then return end

    if (xPlayer and SecondInv) then
        local PlayerInventory = xPlayer.getInventory()
        local SecondInventory = SecondInv.inventoryItems

        if (not PlayerInventory or not SecondInventory or not PlayerInventory[index] or not SecondInventory[droppedTo]) then
            print('Error, items are not exist in player or secondary inventory ! Event: InvMoveToSecond')
            return
        end

        ------HERE CHECK ITEM IS TREDABLE

        local playeritem = json.decode(json.encode(PlayerInventory[index]))
        local seconditem = json.decode(json.encode(SecondInventory[droppedTo]))

        if (not playeritem or not seconditem) then return end
        if (playeritem == "empty") then return end

        if (not count or count > playeritem.count) then count = playeritem.count end

        local ItemInfos = MOD_Items:getItem(playeritem.name)
        if (not ItemInfos) then return end

        if (playerDied[xPlayer.identifier] == true) then
            return xPlayer.showNotification("Vous ne pouvez pas déposer d'item en etant mort")
        end

        if (MOD_inventory:getWeaponIsPerma(playeritem.name)) then return end ---GET WEAPON IS PERMA

        if (MOD_inventory:getItemSecurActions(playeritem)) then return end ---GET ITEM IS PROTECTED


        local SecondMaxWeight = SecondInv:getInventoryMaxWeight()
        local SecondWeight = SecondInv:getInventoryWeight()

        if (ItemInfos.weight == 0 or SecondMaxWeight >= (SecondWeight + (ItemInfos.weight * count))) then
            if (SecondInv:isFreeSlotOrSameItem(droppedTo, playeritem.name)) then
                local RemoveSucces = xPlayer.removeInventoryItemAtSlot(index, count)
                if (RemoveSucces) then

                    -------REMOVE WEAPON AND SET AMMO IN ARGS
                    if (playeritem.id == xPlayer.get('currentWeapon') and playeritem.args ~= nil) then
                        -- playeritem.args.ammo = weaponSave.ammo
                        RemoveAllPedWeapons(GetPlayerPed(xPlayer.source))
                        TriggerClientEvent('OneLife:Inventory:WeaponSet', source, nil)
                        xPlayer.set('currentWeapon', nil)
                    end

                    SecondInv:addItemToSlot(droppedTo, count, playeritem)

                    if (SecondInv.type == "player") then
                        xPlayer.SecondInvData:logsDepot(source, xPlayer, playeritem.name, playeritem.id, count)
                    elseif (SecondInv.type == "vehicule") then
                        xPlayer.SecondInvData:saveInventory()
                        xPlayer.SecondInvData:logsDepot(source, xPlayer, playeritem.name, playeritem.id, count)
                    elseif (SecondInv.type == "properties") then
                        xPlayer.SecondInvData:saveInventory()
                        xPlayer.SecondInvData:logsDepot(source, xPlayer, playeritem.name, playeritem.id, count)
                    elseif (SecondInv.type == "coffrebuilder") then
                        xPlayer.SecondInvData:saveInventory()
                        xPlayer.SecondInvData:logsDepot(source, xPlayer, playeritem.name, playeritem.id, count)
                    elseif (SecondInv.type == "coffresociety") then
                        xPlayer.SecondInvData:saveInventory()
                        xPlayer.SecondInvData:logsDepot(source, xPlayer, playeritem.name, playeritem.id, count)
                    elseif (SecondInv.type == "coffregang") then
                        xPlayer.SecondInvData:saveInventory()
                        xPlayer.SecondInvData:logsDepot(source, xPlayer, playeritem.name, playeritem.id, count)
                    end
                end
            end
        else
            -------NOTIF PLAYER
        end
    end
end)