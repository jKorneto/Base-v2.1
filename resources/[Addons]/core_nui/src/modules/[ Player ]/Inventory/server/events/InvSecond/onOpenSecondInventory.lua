RegisterNetEvent('OneLife:Inventory:OpenSecondInventory')
AddEventHandler('OneLife:Inventory:OpenSecondInventory', function(type, InvId, xPly)
    local xPlayer = ESX.GetPlayerFromId(source) or xPly
    
    xPlayer.set('SecondInvData', nil)

    if (xPlayer.get('SecondInvData') == nil or next(xPlayer.get('SecondInvData')) == nil) then
        if (type == "fplayeril") then
            if (xPlayer.job2.name ~= "unemployed2") then
                MOD_inventory:openPlayerFouilleIl(xPlayer, InvId)
            end
        elseif (type == "fplayerl") then
            if (xPlayer.job.name ~= "unemployed") then
                MOD_inventory:openPlayerFouilleIl(xPlayer, InvId)
            end
        elseif (type == "fplayerStaff") then
            local xGroup = xPlayer.getGroup()

            if xGroup ~= "user" then
                exports["inventory"]:FriskTarget(xPlayer.source, InvId)
            end
        end

        if (type == "vehicule") then
            MOD_CoffreVehicule:openVehiculeByNetId(xPlayer, InvId)
        elseif (type == "properties") then
            local invExist = exports["inventory"]:InventoryExist(InvId.name)

            if (invExist) then
                exports["inventory"]:OpenStash(xPlayer.source, InvId.name, "job")
            else
                local stash = exports["inventory"]:RegisterStash({
                    isPublic = false,
                    isPermanent = true,
                    inventoryName = InvId.name,
                    maxWeight = InvId.weight,
                    slotsAmount = 150,
                    uniqueID = InvId.name,
                    groups = {
                        ["all"] = "all",
                    }
                })

                if (stash) then
                    exports["inventory"]:OpenStash(xPlayer.source, InvId.name, "job")
                end
            end
        elseif (type == "coffrebuilder") then
            --MOD_CoffreBuilder:openCoffreBuilderById(xPlayer, InvId)
        elseif (type == "coffresociety") then
            local invExist = exports["inventory"]:InventoryExist(InvId.."-stash")

            if (invExist) then
                exports["inventory"]:OpenStash(xPlayer.source, InvId.."-stash", "job")
            else
                local stash = exports["inventory"]:RegisterStash({
                    isPublic = false,
                    isPermanent = true,
                    inventoryName = "Coffre "..InvId,
                    maxWeight = 5000,
                    slotsAmount = 150,
                    uniqueID = InvId.."-stash",
                    groups = {
                        [InvId] = 0,
                    }
                })

                if (stash) then
                    exports["inventory"]:OpenStash(xPlayer.source, InvId.."-stash", "job")
                end
            end
        elseif (type == "coffregang") then
            local invExist = exports["inventory"]:InventoryExist(InvId.."-stash")

            if (invExist) then
                exports["inventory"]:OpenStash(xPlayer.source, InvId.."-stash", "job2")
            else
                local stash = exports["inventory"]:RegisterStash({
                    isPublic = false,
                    isPermanent = true,
                    inventoryName = "Coffre "..InvId,
                    maxWeight = 2500,
                    slotsAmount = 150,
                    uniqueID = InvId.."-stash",
                    groups = {
                        [InvId] = 0,
                    }
                })

                if (stash) then
                    exports["inventory"]:OpenStash(xPlayer.source, InvId.."-stash", "job2")
                end
            end
        end

        -- TriggerClientEvent('OneLife:Inventory:OpenPlayerInventory', xPlayer.source)
    end
end)