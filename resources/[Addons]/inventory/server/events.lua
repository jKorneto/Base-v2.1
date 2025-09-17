local inTrunk = false
local inGloveBox = false

function showNotification(target, msg)
    TriggerClientEvent('esx:showNotification', target, msg)
end 

RegisterNetEvent("inventory:ITEM_MOVE_TO_SLOT", function(d)
    local source <const> = source
    local fromUniqueID <const> = d.fromUniqueID
    local fromSlot <const> = d.fromSlot
    local toUniqueID <const> = d.toUniqueID
    local toSlot <const> = d.toSlot
    local quantity = math.round(tonumber(d.quantity) or 1)

    local player <const> = ESX.GetPlayerFromId(source)
    if not player then return end

    local grabbed_inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = fromUniqueID })
    local to_inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = toUniqueID })
    if not (grabbed_inventory and to_inventory) then return end

    local item <const> = grabbed_inventory:getItemBy({ slot = fromSlot })
    if not item then return end

    if type(quantity) ~= "number" or quantity > item.quantity or quantity < 1 then quantity = item.quantity end
    if not item.data.stackable then quantity = 1 end

    if (isWeapon(string.lower(item.name))) then
        RemoveAllPedWeapons(GetPlayerPed(source), true)
    end

    if grabbed_inventory:isSame(to_inventory) then
        local addedResult = grabbed_inventory:addItem({
            name = item.name,
            quantity = quantity,
            meta = item.meta,
            toSlot = toSlot
        }, true)
        if addedResult.success then
            grabbed_inventory:removeItemBy(quantity, { slot = fromSlot })
        end
    else
        local addedResult = nil

        if not item.data.tradable then
            showNotification(player.source, "L'objet n'est pas échangeable")
            return
        end

        if to_inventory.type == "dropped_grid" then
            local pX <const>, pY <const>, pZ <const> = table.unpack(GetEntityCoords(GetPlayerPed(source)))
            addedResult = to_inventory:addItem({
                name = item.name,
                quantity = quantity,
                meta = item.meta,
                toSlot = toSlot,
                coordX = pX,
                coordY = pY,
                coordZ = pZ
            }, true)
        else
            addedResult = to_inventory:addItem({
                name = item.name,
                quantity = quantity,
                meta = item.meta,
                toSlot = toSlot 
            })
        end

        if addedResult.success then
            grabbed_inventory:removeItemBy(quantity, { slot = fromSlot })

            if to_inventory.type == "player" then
                local player = ESX.GetPlayerFromIdentifier(fromUniqueID)
                local targetPlayer = ESX.GetPlayerFromIdentifier(toUniqueID)

                if (item.name == "cash") then
                    if (player) then
                        player.removeAccountMoney(item.name, math.round(quantity))
                    end

                    if (targetPlayer) then
                        targetPlayer.addAccountMoney(item.name, math.round(quantity))
                    end
                elseif (item.name == "dirtycash") then
                    if (player) then
                        player.removeAccountMoney(item.name, math.round(quantity))
                    end

                    if (targetPlayer) then
                        targetPlayer.addAccountMoney(item.name, math.round(quantity))
                    end
                end
            else
                if (item.name == "cash") then
                    player.removeAccountMoney(item.name, math.round(quantity))
                elseif (item.name == "dirtycash") then
                    player.removeAccountMoney(item.name, math.round(quantity))
                end
            end
        end

        if to_inventory.type == "player" then
            local player = ESX.GetPlayerFromIdentifier(toUniqueID)
            local targetPlayer = ESX.GetPlayerFromIdentifier(fromUniqueID)

            if (grabbed_inventory.type == "player") then
                exports["core"]:SendLogs(
                    "Inventory",
                    "Fouilles",
                    string.format("Le joueur %s (***%s***) à récuperé **%sx** - **%s** dans l'inventaire du joueur %s (***%s***)",
                        player.getName(),
                        player.identifier,
                        quantity,
                        item.data.label,
                        targetPlayer.getName(),
                        targetPlayer.identifier
                    ),
                    "https://discord.com/api/webhooks/1328105016518774855/HW8LjQD9nQrjot3UC7Xh9Hfzzz7Z_HzSFLRPgsUdMEXx8sD21GLryhE5fjpOaTL42okF"
                )
            end

            if (grabbed_inventory.type == "trunk") then
                exports["core"]:SendLogs(
                    "Inventory",
                    "Coffre",
                    string.format("Le joueur %s (***%s***) à récuperé **%sx** - **%s** dans le coffre du véhicule (***%s***)",
                        player.getName(),
                        player.identifier,
                        quantity,
                        item.data.label,
                        grabbed_inventory.plate
                    ),
                    "https://discord.com/api/webhooks/1328106049307410557/67oidCCVWK2uk1wH3pDeQyjm2-jESAfpcoZq9cI30APrcH8fbNa6IPq3LIvs2VS1pwNc"
                )
            end

            if (grabbed_inventory.type == "glovebox") then
                exports["core"]:SendLogs(
                    "inventory",
                    "Boite à gants",
                    string.format("Le joueur %s (***%s***) à récuperé **%sx** - **%s** dans la boite à gants du véhicule (***%s***)",
                        player.getName(),
                        player.identifier,
                        quantity,
                        item.data.label,
                        grabbed_inventory.plate
                    ),
                    "https://discord.com/api/webhooks/1328405328064155658/htseZXJ_skszSbmIHENbUDC81ZDwV0V4htGQ-Jt1CQaz1kc1F4-Sh6-UxGPFSKLe4Opi"
                )
            end

            if (grabbed_inventory.type == "stash") then
                exports["core"]:SendLogs(
                    "inventory",
                    "Coffre société",
                    string.format("Le joueur %s (***%s***) à récuperé **%sx** - **%s** dans le coffre de la société **%s**",
                        player.getName(),
                        player.identifier,
                        quantity,
                        item.data.label,
                        grabbed_inventory.inventoryName
                    ),
                    "https://discord.com/api/webhooks/1328407303690518618/tmMj1oTWcsbODEMHqYXdV9yfhI935LxYRG1YymFeNA3Aut2gkoCoYxMR9c_HDPS9G49p"
                )
            end

            if (grabbed_inventory.type == "dropped_grid") then
                exports["core"]:SendLogs(
                    "Inventory",
                    "Sol",
                    string.format("Le joueur %s (***%s***) à récuperé au sol **%dx** - **%s** à la position (%.2f, %.2f, %.2f)",
                        player.getName(),
                        player.identifier,
                        quantity,
                        item.data.label,
                        item.coordX, item.coordY, item.coordZ
                    ),
                    "https://discord.com/api/webhooks/1328431415683059816/8txJ8vIAeuGueHWHmwGO6PbrNRCqM4AwX6NWQxSIeItnWSTBT6LBpj0cXIF2dGQ6MsSk"
                )
            end

        elseif to_inventory.type == "trunk" then
            exports["core"]:SendLogs(
                "Inventory",
                "Coffre",
                string.format("Le joueur %s (***%s***) à déposé **%sx** - **%s** dans le coffre du véhicule (***%s***)",
                    player.getName(),
                    player.identifier,
                    quantity,
                    item.data.label,
                    to_inventory.plate
                ),
                "https://discord.com/api/webhooks/1328106049307410557/67oidCCVWK2uk1wH3pDeQyjm2-jESAfpcoZq9cI30APrcH8fbNa6IPq3LIvs2VS1pwNc"
            )

        elseif to_inventory.type == "glovebox" then
            exports["core"]:SendLogs(
                "inventory",
                "Boite à gants",
                string.format("Le joueur %s (***%s***) à déposé **%sx** - **%s** dans la boite à gants du véhicule (***%s***)",
                    player.getName(),
                    player.identifier,
                    quantity,
                    item.data.label,
                    to_inventory.plate
                ),
                "https://discord.com/api/webhooks/1328405328064155658/htseZXJ_skszSbmIHENbUDC81ZDwV0V4htGQ-Jt1CQaz1kc1F4-Sh6-UxGPFSKLe4Opi"
            )
        elseif to_inventory.type == "stash" then
            exports["core"]:SendLogs(
                "inventory",
                "Coffre société",
                string.format("Le joueur %s (***%s***) à déposé **%sx** - **%s** dans le coffre de la société **%s**",
                    player.getName(),
                    player.identifier,
                    quantity,
                    item.data.label,
                    to_inventory.inventoryName
                ),
                "https://discord.com/api/webhooks/1328407303690518618/tmMj1oTWcsbODEMHqYXdV9yfhI935LxYRG1YymFeNA3Aut2gkoCoYxMR9c_HDPS9G49p"
            )
        end
    end
end)
RegisterNetEvent("inventory:CLOSE_SECOND_INVENTORY", function(uniqueID)
    local source <const> = source
    local inv <const> = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = uniqueID }) --[[@as unknown]]
    if not inv then return end

    if type(inv.close) == 'function' then
        inTrunk = false
        inGloveBox = false
        inv:close(source)
    end
end)
RegisterNetEvent("inventory:ADD_NOTE_ITEM", function(data)
    local source <const>   = source
    local itemHash <const> = data.itemHash
    local uniqueID <const> = data.uniqueID
    local newNote <const>  = data.newNote

    local player <const>   = ESX.GetPlayerFromId(source)
    if not player then return end

    local inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = uniqueID })
    if not inventory then return end
    local item <const> = inventory:getItemBy({ itemHash = itemHash })
    if not item then return end

    if item.meta.note == newNote then return end

    if type(newNote) == "string" and string.len(newNote) > 0 then
        item.meta.note = newNote
    else
        item.meta.note = nil
    end

    inventory:OnItemUpdated(item)
    showNotification(player.source, "Note modifiée avec succès")
end)
RegisterNetEvent("inventory:CRAFT_ITEM", function(data)
    local playerId <const> = source
    local slotIndex <const> = data.slotIndex
    local craftPlaceId <const> = data.craftPlaceId

    local player <const> = ESX.GetPlayerFromId(playerId)
    if not player then return end

    local inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ source = playerId })
    if not inventory then return end

    local craft_class <const> = ScriptServer.Managers.CraftPlaces:GetCraftingPlace(craftPlaceId)
    if not craft_class then return end

    local craft_item <const> = craft_class:GetCraftItemOnSlot(slotIndex)
    if not craft_item then return end

    local hasEverything = true

    for i = 1, #craft_item.ingredients do
        local ingredient = craft_item.ingredients[i]
        local i_quantity = inventory:getItemQuantityBy({ name = ingredient.name })
        if i_quantity < ingredient.quantity then
            hasEverything = false
            break
        end
    end

    if not hasEverything then
        showNotification(player.source, "Certains ingrédients manquent")
        return
    end

    local addedResult = inventory:addItem({
        name = craft_item.name,
        quantity = craft_item.quantity,
        meta = craft_item.meta
    })
    if not addedResult then
        showNotification(player.source, "Vous n'avez pas assez de place dans votre réserve")
        return
    end

    for i = 1, #craft_item.ingredients do
        local ingredient = craft_item.ingredients[i]
        local iData = ScriptShared.Items:Get(ingredient.name)
        if iData then
            if iData.stackable then
                inventory:removeItemBy(ingredient.quantity, { name = ingredient.name })
            else
                -- Removing non stackable items
                for j = 1, ingredient.quantity do
                    inventory:removeItemBy(1, { name = ingredient.name })
                end
            end
        end
    end
end)

RegisterNetEvent("inventory:RENAME_ITEM", function(data)
    local source <const>   = source
    local itemHash <const> = data.itemHash
    local uniqueID <const> = data.uniqueID
    local newName <const>  = data.newName

    local player <const>   = ESX.GetPlayerFromId(source)
    if not player then return end

    local inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = uniqueID })
    if not inventory then return end
    local item <const> = inventory:getItemBy({ itemHash = itemHash })
    if not item then return end

    if item.meta.customName == newName then return end

    if type(newName) == "string" and string.len(newName) > 0 then
        if (item.name ~= "cash" and item.name ~= "dirtycash") then
            item.meta.customName = newName
            inventory:OnItemUpdated(item)
            showNotification(player.source, "L'objet a été renommé avec succès")
        else
            showNotification(player.source, "Vous ne pouvez pas renommé de l'argent")
        end
    else
        item.meta.customName = nil
    end
end)

RegisterNetEvent("inventory:OPEN_NEAR_SHOPS", function()
    local playerId = source

    local playerPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)

    for k, v in pairs(ScriptShared.Shops) do
        for i = 1, #v.locations do
            local shopCoord = v.locations[i]
            local dist = #(playerCoords - shopCoord)
            if dist < CONFIG.SHOP_OPEN_RANGE then
                local shop = ScriptServer.Managers.Shops:GetShop(k)
                if shop then
                    shop:openShop(playerId)
                end
                break -- important that this is here! not under the k,v
            end
        end
    end
end)

RegisterNetEvent("inventory:OPEN_NEAR_CRAFTPLACES", function()
    local playerId = source

    local playerPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)

    for k, v in pairs(ScriptShared.CraftPlaces) do
        for i = 1, #v.locations do
            local locationCoords = v.locations[i].coords
            local locationMaxRange = v.locations[i].range

            local dist = #(playerCoords - locationCoords)
            if dist < locationMaxRange then
                local craftClass = ScriptServer.Managers.CraftPlaces:GetCraftingPlace(k)
                if craftClass then
                    craftClass:OpenCrafting(playerId)
                end
                break -- important that this is here! not under the k,v
            end
        end
    end
end)

RegisterNetEvent("inventory:OPEN_NEAR_TRUNKS", function(vehicleNetIds)
    local playerId = source
    local playerPed = GetPlayerPed(playerId)

    if GetVehiclePedIsIn(playerPed, false) ~= 0 then return end

    for i = 1, #vehicleNetIds do
        local netId = vehicleNetIds[i]
        local veh = NetworkGetEntityFromNetworkId(netId)

        if DoesEntityExist(veh) then
            local plate = GetVehicleNumberPlateText(veh)
            if CONFIG.IS_VEHICLE_EXIST(plate) then
                local modelHash = GetEntityModel(veh)
                local uniqueID <const> = 'trunk-' .. plate
                local trunk_inventory = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = uniqueID }) --[[@as TrunkInventory]]
                if not trunk_inventory then
                    trunk_inventory = ScriptServer.Classes.TrunkInventory.new({
                        inventoryName = string.format('COFFRE (%s)', plate),
                        maxWeight = CONFIG.VEHICLE_SIZES.getTrunkMaxWeight(modelHash),
                        plate = plate,
                        slotsAmount = CONFIG.VEHICLE_SIZES.getTrunkSlots(modelHash),
                        uniqueID = uniqueID
                    })
                end

                inTrunk = true
                trunk_inventory:open(playerId)

                while inTrunk do
                    local vehCoords = GetEntityCoords(veh)
                    local playerCoords = GetEntityCoords(playerPed)
                    local distance = #(playerCoords - vehCoords)
                    if distance >= 5 then
                        trunk_inventory:close(playerId)
                        break
                    end
                    Wait(1000)
                end
            end
        end

    end
end)

RegisterNetEvent("inventory:OPEN_VEHICLE_GLOVEBOX_INVENTORY", function()
    local playerId = source

    local playerPed = GetPlayerPed(playerId)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if not DoesEntityExist(vehicle) or GetEntityType(vehicle) ~= 2 then return end

    local plate = GetVehicleNumberPlateText(vehicle)
    if not CONFIG.IS_VEHICLE_EXIST(plate) then return end

    local modelHash = GetEntityModel(vehicle)

    local uniqueID = 'glovebox-' .. plate
    local glovebox_inventory = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = uniqueID }) --[[@as GloveboxInventory]]
    if not glovebox_inventory then
        glovebox_inventory = ScriptServer.Classes.GloveboxInventory.new({
            inventoryName = string.format('BOÎTE À GANTS'),
            maxWeight = CONFIG.VEHICLE_SIZES.getGloveboxMaxWeight(modelHash),
            plate = plate,
            slotsAmount = CONFIG.VEHICLE_SIZES.getGloveboxSlots(modelHash),
            uniqueID = uniqueID
        })
    end

    glovebox_inventory:open(playerId)
    inGloveBox = true

    while inGloveBox do
        local vehCoords = GetEntityCoords(vehicle)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - vehCoords)
        if distance >= 3 then
            glovebox_inventory:close(playerId)
            break
        end
        Wait(1000)
    end
end)

RegisterNetEvent("inventory:OPEN_NEAR_FACTION_SAFES", function()
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)

    for k, v in pairs(CONFIG.FACTION_INVENTORIES) do
        local safePos = vector3(v.x, v.y, v.z)
        local dist = #(playerCoords - safePos)
        if dist < CONFIG.FACTION_SAFE_OPEN_RANGE then
            local safe = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = k }) --[[@as FactionInventory]]
            if safe then
                safe:open(playerId)
            end
        end
    end
end)

RegisterNetEvent("inventory:OPEN_NEAR_CHEST_SAFES", function()
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)

    for k, v in pairs(CONFIG.CHEST_INVENTORIES) do
        local safePos = vector3(v.coords.x, v.coords.y, v.coords.z)
        local dist = #(playerCoords - safePos)
        if dist < CONFIG.CHEST_OPEN_RANGE then
            local safe = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = k }) --[[@as CheastInventory]]
            if safe then
                safe:open(playerId)
            end
        end
    end
end)

RegisterNetEvent("inventory:BUY_FROM_SHOP", function(data)
    local source <const> = source
    local shopId <const> = data.shopId
    local fromSlot <const> = data.fromSlot
    local toSlot <const> = data.toSlot
    local quantity = math.round(tonumber(data.quantity) or 1)

    local inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ source = source })
    if not inventory then return end

    local shop <const> = ScriptServer.Managers.Shops:GetShop(shopId)
    if not shop then return end

    local shop_item <const> = shop:GetShopItemOnSlot(fromSlot)
    if not shop_item then return end

    local iData <const> = ScriptShared.Items:Get(shop_item.name)
    if not iData then return end

    if type(quantity) ~= "number" or quantity < 1 then quantity = 1 end
    if not iData.stackable then quantity = 1 end

    local player <const> = ESX.GetPlayerFromId(source)
    if not player then return end

    local finalPrice = shop_item.price * quantity

    local playerMoney = player.getAccount("cash").money
    if (playerMoney >= finalPrice) then
        takingAccount = "cash"
    elseif (shop.black_money) then
        local playerBlackMoney = player.getAccount("cash").money
        if (playerBlackMoney >= finalPrice) then
            takingAccount = "cash"
        end
    else
        player.showInventoryNotification("error", "Vous n'avez pas assez d'argent !")
        return
    end

    local addedResult = inventory:addItem({
        name = shop_item.name,
        meta = shop_item.meta,
        quantity = quantity,
        toSlot = toSlot
    })
    if addedResult.success then
        player.removeAccountMoney(takingAccount, finalPrice, true)
        player.showInventoryNotification("success", "Vous avez acheté "..quantity.." "..iData.label.." pour "..finalPrice.."$ !")
    end
end)

RegisterNetEvent("inventory:GIVE_ITEM_TO_TARGET", function(data)
    local source <const> = source
    local itemHash <const> = data.itemHash
    local serverId <const> = data.serverId
    local quantity = math.round(tonumber(data.quantity) or 1)

    if source == serverId then return end

    local player <const> = ESX.GetPlayerFromId(source)
    local targetSelected <const> = ESX.GetPlayerFromId(serverId)
    if not player then return end

    local player_inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ source = source })
    local target_inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ source = serverId })
    if not (player_inventory and target_inventory) then return end

    local item <const> = player_inventory:getItemBy({ itemHash = itemHash })
    if not item then return end

    if not item.data.tradable then
        showNotification(player.source, "L'objet n'est pas échangeable")
        return
    end

    if type(quantity) ~= "number" or quantity > item.quantity or quantity < 1 then
        quantity = item.quantity
    end

    if not target_inventory:canCarryWeight(item.name, quantity) then
        showNotification(player.source, "L'inventaire du joueur cible n'a pas assez d'espace")
        return
    end

    if (isWeapon(string.lower(item.name))) then
        RemoveAllPedWeapons(GetPlayerPed(source), true)
    end

    local no_ref <const> = json.decode(json.encode(item))

    local addedResult = target_inventory:addItem({
        meta = no_ref.meta,
        name = no_ref.name,
        quantity = quantity
    })
    if addedResult.success then
        player_inventory:removeItemBy(quantity, { itemHash = itemHash })
        if (no_ref.name == "cash") then
            player.removeAccountMoney(no_ref.name, quantity)
            targetSelected.addAccountMoney(no_ref.name, quantity)
        elseif (no_ref.name == "dirtycash") then
            player.removeAccountMoney(no_ref.name, quantity)
            targetSelected.addAccountMoney(no_ref.name, quantity)
        end
    end

    showNotification(player.source, string.format("Vous avez donné %dx - %s au joueur %s", quantity, no_ref.data.label, targetSelected.getName()))
    showNotification(targetSelected.source, string.format("Vous avez reçu %dx - %s du joueur %s", quantity, no_ref.data.label, player.getName()))
    exports["core"]:SendLogs(
        "Inventory",
        "Item",
        string.format("Le joueur %s (***%s***) a donné **%dx** - **%s** à %s (***%s***)",
            player.getName(),
            player.identifier,
            quantity,
            no_ref.data.label,
            targetSelected.getName(),
            targetSelected.identifier
        ),
        "https://discord.com/api/webhooks/1328432868321525830/9orrHwfJbLOuX4jYpbNKPP1SQY_35He8kT6ZnPw2iZILIxJftU5pkw-IkYbdbh9i274g"
    )
end)

RegisterNetEvent("inventory:DROP_ITEM_ON_GROUND", function(data)
    local source <const> = source
    local uniqueID <const> = data.uniqueID
    local itemHash <const> = data.itemHash
    local quantity = math.round(tonumber(data.quantity) or 1)

    local player <const> = ESX.GetPlayerFromId(source)
    if not player then return end

    local inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = uniqueID })
    if not inventory then return end

    local item <const> = inventory:getItemBy({ itemHash = itemHash })
    if not item then return end

    if (not item.deletable) then 
        return showNotification(player.source, "Cette item n'est pas jetable")
    end

    if type(quantity) ~= "number" or quantity > item.quantity or quantity < 1 then
        quantity = item.quantity
    end

    if inventory.type == "dropped_grid" then
        showNotification(player.source, "Où voulez-vous déposer l'objet ?")
        return
    end

    local pX <const>, pY <const>, pZ <const> = table.unpack(GetEntityCoords(GetPlayerPed(source)))

    local close_drop_grid <const> = ScriptServer.Managers.Dropped:createOrGetGrid(pX, pY, pZ)
    if not close_drop_grid then return end

    local no_ref <const> = json.decode(json.encode(item))

    local addedResult <const> = close_drop_grid:addItem({
        name = no_ref.name,
        quantity = quantity,
        meta = no_ref.meta,
        coordX = pX,
        coordY = pY,
        coordZ = pZ
    })

    if addedResult.success then
        close_drop_grid:createObjectIfNotExist(addedResult.item)

        inventory:removeItemBy(quantity, { itemHash = no_ref.itemHash })

        if (no_ref.name == "cash") then
            player.removeAccountMoney(no_ref.name, quantity)
        elseif (no_ref.name == "dirtycash") then
            player.removeAccountMoney(no_ref.name, quantity)
        end

        showNotification(player.source, string.format("Vous avez jeter %dx - %s", quantity, no_ref.data.label))
        exports["core"]:SendLogs(
            "Inventory",
            "Jeter",
            string.format("Le joueur %s (***%s***) à jeter au sol **%dx** - **%s** à la position (%.2f, %.2f, %.2f)",
                player.getName(),
                player.identifier,
                quantity,
                no_ref.data.label,
                pX, pY, pZ
            ),
            "https://discord.com/api/webhooks/1328429775261270037/V8GObP6i4qRoGJ08LdJI8sqgrWBg_qyQ1A13xn3WC3ZhzplDoq16DIdyLTO276JsLPee"
        )

        if not close_drop_grid:hasObserver(source) then
            close_drop_grid:open(source)
        end
    end
end)

RegisterNetEvent("inventory:OPEN_NEAR_DROPPED_GRID", function()
    local source <const> = source
    local pX <const>, pY <const>, pZ <const> = table.unpack(GetEntityCoords(GetPlayerPed(source)))
    local close_drop_grid <const> = ScriptServer.Managers.Dropped:gridAt(pX, pY, pZ)
    if not close_drop_grid then return end
    close_drop_grid:open(source)
end)

RegisterNetEvent("inventory:REDUCE_WEAPON_AMMO", function()
    local source <const> = source
    local inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ source = source }) --[[@as PlayerInventory]]
    if not inventory then return end

    local usedWeapon = inventory:getItemBy({ itemHash = inventory.usedWeaponItemHash })
    if not usedWeapon then return end

    if CONFIG.AMMO_WEAPONS[usedWeapon.data.weaponHash] then
        inventory:removeItemBy(1, { name = CONFIG.AMMO_WEAPONS[usedWeapon.data.weaponHash] })
    elseif CONFIG.THROWABLE_WEAPONS[usedWeapon.data.weaponHash] then
        inventory:removeItemBy(1, { itemHash = inventory.usedWeaponItemHash })
    elseif CONFIG.MISC_WEAPONS[usedWeapon.data.weaponHash] then
        inventory:removeItemBy(math.random(3, 5), { itemHash = inventory.usedWeaponItemHash })
    end
end)

RegisterNetEvent("inventory:USE_ITEM", function(data)
    local source <const> = source
    local itemHash <const> = data.itemHash
    local uniqueID <const> = data.uniqueID

    local inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = uniqueID })
    if not inventory then return end
    local item <const> = inventory:getItemBy({ itemHash = itemHash })
    if not item then return end

    local player_inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ source = source }) --[[@as PlayerInventory]]
    if not player_inventory then return end

    --if item.data.weaponHash and not exports["core"]:PlayerIsInSafeZone(source) then
    if item.data.weaponHash then
        player_inventory:UseWeaponItem(item)
    end

    if (item.data.event and item.data.event.client_event) then
        TriggerClientEvent(item.data.event.client_event, source, item)
    end

    if (item.data.event and item.data.event.server_event) then
        if (item.data.event.param_event == nil) then
            TriggerEvent(item.data.event.server_event, source, item)
        else
            TriggerEvent(item.data.event.server_event, source, item, item.data.event.param_event)
        end
    end

    if item.data.event and type(item.data.event.onUseDeleteAmount) == "number" and item.data.event.onUseDeleteAmount > 0 then
        inventory:removeItemBy(item.data.event.onUseDeleteAmount, { itemHash = itemHash })
    end
end)

RegisterNetEvent("inventory:USE_SLOT", function(slot)
    local source <const> = source
    local inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ source = source })
    if not inventory then return end
    local item <const> = inventory:getItemBy({ slot = slot })
    if not item then return end

    local player_inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ source = source }) --[[@as PlayerInventory]]
    if not player_inventory then return end

    --if item.data.weaponHash and not exports["core"]:PlayerIsInSafeZone(source) then
        player_inventory:UseWeaponItem(item)
    --end

    if item.data.server and type(item.data.server.export) == "string" then
        local parts <const> = {}
        for part in string.gmatch(item.data.server.export, "[^.]+") do
            table.insert(parts, part)
        end

        local resource <const> = parts[1]
        local func <const> = parts[2]

        exports[resource][func](nil, source, item)

        if type(item.data.server.onUseDeleteAmount) == "number" and item.data.server.onUseDeleteAmount > 0 then
            inventory:removeItemBy(item.data.server.onUseDeleteAmount, { itemHash = itemHash })
        end
    end
end)

RegisterNetEvent("inventory:OPEN_STASH", function(uniqueID)
    local source <const> = source
    exports[ScriptServer.resourceName]:OpenStash(source, uniqueID)
end)

RegisterNetEvent("inventory:ITEM_ADD_ATTACHMENT_WEAPON", function(d)
    local source <const> = source
    local fromUniqueID <const> = d.fromUniqueID
    local toUniqueID <const> = d.toUniqueID
    local draggedItemhash <const> = d.draggedItemhash
    local toItemHash <const> = d.toItemHash

    local player <const> = ESX.GetPlayerFromId(source)
    if not player then return end

    local from_inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = fromUniqueID })
    local to_inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = toUniqueID })
    if not (from_inventory and to_inventory) then return end

    local draggedItem <const> = from_inventory:getItemBy({ itemHash = draggedItemhash })
    local to_item <const> = to_inventory:getItemBy({ itemHash = toItemHash })
    if not (draggedItem and to_item) then return end

    if to_item.data.weaponHash == nil then
        showNotification(player.source, "Il ne s'agit pas d'une arme")
        return
    end

    -- Modify these lines, if you do not want the player to be able to equip a Shotgun attachment on the pistol for example.
    -- (You have to define the allowedAttachments table under the weapon item data.)
    local canAddAttachment = true
    local hasThisAttachment = false

    -- local canAddAttachment = false
    -- local hasThisAttachment = false
    -- -- if type(to_item.data.allowedAttachments) == "table" then
    -- --     for k, v in pairs(to_item.data.allowedAttachments) do
    -- --         if v == draggedItem.name then
    -- --             canAddAttachment = true
    -- --             break
    -- --         end
    -- --     end
    -- -- end

    if not canAddAttachment then
        showNotification(player.source, "Vous ne pouvez pas utiliser cet accessoire sur cette arme")
        return
    end

    if type(to_item.meta.attachments) ~= "table" then
        to_item.meta.attachments = {}
    end

    if #to_item.meta.attachments >= 5 then
        showNotification(player.source, "Il n'est pas possible d'ajouter d'autres accessoires à cette arme")
        return
    end

    for k, v in pairs(to_item.meta.attachments) do
        if v == draggedItem.name then
            hasThisAttachment = true
            break
        end
    end

    if hasThisAttachment then
        showNotification(player.source, "Vous avez déjà ce type d'accessoire sur cette arme")
        return
    end

    to_item.meta.attachments[#to_item.meta.attachments + 1] = draggedItem.name
    to_inventory:OnItemUpdated(to_item)
    from_inventory:removeItemBy(nil, { itemHash = draggedItemhash })

    if to_inventory.type == "player" then
        TriggerClientEvent("inventory:UpdateWeaponAttachments", to_inventory.source, to_item)
    end
end)

RegisterNetEvent("inventory:ITEM_REMOVE_ATTACHMENT_WEAPON", function(d)
    local source <const> = source
    local fromUniqueID <const> = d.fromUniqueID
    local fromItemHash <const> = d.fromItemHash
    local fromAttIndex <const> = d.fromAttIndex
    local toUniqueID <const> = d.toUniqueID
    local toSlot <const> = d.toSlot

    local from_inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = fromUniqueID })
    local to_inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ uniqueID = toUniqueID })
    if not (from_inventory and to_inventory) then return end

    local from_item <const> = from_inventory:getItemBy({ itemHash = fromItemHash })
    if not from_item then return end

    if type(from_item.meta.attachments) ~= "table" then
        from_item.meta.attachments = {}
    end

    local attachment <const> = from_item.meta.attachments[fromAttIndex]
    if not attachment then return end

    local response = to_inventory:addItem({
        name = attachment,
        quantity = 1,
        toSlot = toSlot
    })
    if response.success then
        table.remove(from_item.meta.attachments, fromAttIndex)
        to_inventory:OnItemUpdated(from_item)

        if to_inventory.type == "player" then
            TriggerClientEvent("inventory:UpdateWeaponAttachments", to_inventory.source, from_item)
        end
    end
end)
RegisterNetEvent("inventory:REDUCE_WEAPON_DURABILITY", function()
    local source <const> = source
    local player_inventory <const> = ScriptServer.Managers.Inventory:GetInventory({ source = source }) --[[@as PlayerInventory]]
    if not player_inventory then return end
    player_inventory:ReduceWeaponDurability()
end)
