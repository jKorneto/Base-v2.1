if GetResourceState("Framework") == "missing" then
    RegisterNetEvent("inventory:CLIENT_LOADED", function()
        local source <const> = source
        local player <const> = ESX.GetPlayerFromId(source)
        if not player then return end

        local identifier <const> = player:getIdentifier()
        if type(identifier) ~= "string" then return end

        if not ScriptServer.Managers.Inventory:GetInventory({ source = source }) then
            ScriptServer.Classes.PlayerInventory.new({
                inventoryName = "INVENTAIRE",
                maxWeight = CONFIG.PLAYER_INVENTORY_DEFAULTS.MAX_WEIGHT,
                slotsAmount = CONFIG.PLAYER_INVENTORY_DEFAULTS.SLOTS,
                source = source,
                type = "player",
                uniqueID = identifier
            })
        end
    end)
end
