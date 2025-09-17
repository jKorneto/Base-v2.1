RegisterNUICallback("ITEM_MOVE_TO_SLOT", function(d, cb)
    local data = d
    local isPermanent = ESX.IsWeaponPermanent(data.name)
    
    if ((data.fromUniqueID == data.toUniqueID) or (not isPermanent)) then
        TriggerServerEvent("inventory:ITEM_MOVE_TO_SLOT", d)
        cb({})
    end
end)
RegisterNUICallback("ADD_NOTE_ITEM", function(d, cb)
    TriggerServerEvent("inventory:ADD_NOTE_ITEM", d)
    cb({})
end)
RegisterNUICallback("RENAME_ITEM", function(d, cb)
    TriggerServerEvent("inventory:RENAME_ITEM", d)
    cb({})
end)
RegisterNUICallback("CRAFT_ITEM", function(d, cb)
    TriggerServerEvent("inventory:CRAFT_ITEM", d)
    cb({})
end)
RegisterNUICallback("USE_ITEM", function(d, cb)
    TriggerServerEvent("inventory:USE_ITEM", d)
    cb({})
end)
RegisterNUICallback("BUY_FROM_SHOP", function(d, cb)
    TriggerServerEvent("inventory:BUY_FROM_SHOP", d)
    cb({})
end)
RegisterNUICallback("ITEM_ADD_ATTACHMENT_WEAPON", function(d, cb)
    TriggerServerEvent("inventory:ITEM_ADD_ATTACHMENT_WEAPON", d)
    cb({})
end)
RegisterNUICallback("ITEM_REMOVE_ATTACHMENT_WEAPON", function(d, cb)
    TriggerServerEvent("inventory:ITEM_REMOVE_ATTACHMENT_WEAPON", d)
    cb({})
end)
RegisterNUICallback("CLOSE_SECOND_INVENTORY", function(d, cb)
    local uniqueID = d.uniqueID
    TriggerServerEvent("inventory:CLOSE_SECOND_INVENTORY", uniqueID)
    cb({})
end)
RegisterNUICallback("NEARBY_GET_PLAYERS", function(_, cb)
    local localPlayer = PlayerPedId()
    local playerPos = GetEntityCoords(localPlayer)
    local players = GetActivePlayers()

    local nearPlayers = {}

    for k, v in pairs(players) do
        local ped = GetPlayerPed(v)
        if ped ~= localPlayer then
            local dist = #(playerPos - GetEntityCoords(ped))
            if dist < CONFIG.NEARBY_PLAYER_RANGE then
                local name = nil
                if CONFIG.NEARBY_PLAYERS_SHOW_NAMES then
                    name = GetPlayerName(v)
                end

                nearPlayers[#nearPlayers + 1] = {
                    serverId = GetPlayerServerId(v),
                    name = name
                }
            end
        end
    end

    if #nearPlayers < 1 then
        showNotification("Aucun joueur n'est à proximité")
    end

    cb(nearPlayers)
end)
RegisterNUICallback("GIVE_ITEM_TO_TARGET", function(d, cb)
    local hash = d.itemHash
    local item = ScriptClient.Player.Inventory:GetItemBy({ itemHash = hash })
    local isPermanent = ESX.IsWeaponPermanent(item.name)
    
    if (not isPermanent) then
        TriggerServerEvent("inventory:GIVE_ITEM_TO_TARGET", d)
    end
    cb({})
end)
RegisterNUICallback("DROP_ITEM_ON_GROUND", function(d, cb)
    local hash = d.itemHash
    local item = ScriptClient.Player.Inventory:GetItemBy({ itemHash = hash })
    local isPermanent = ESX.IsWeaponPermanent(item.name)
    
    if (not isPermanent) then
        TriggerServerEvent("inventory:DROP_ITEM_ON_GROUND", d)
    end
    cb({})
end)
