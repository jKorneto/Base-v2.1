RegisterNetEvent("engine:item:use", function(source, item, extra)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (type(xPlayer) == "table") then
        local itemName = item.name
        local itemLabel = item.data.label
        local itemVip = extra.isVip or false

        if (itemVip) then
            if (not xPlayer.GetVIP()) then
                return Server:showNotification(xPlayer.source, "Vous n'avez pas le VIP", false)
            end
        end

        local playerItem = xPlayer.getInventoryItem(itemName)

        if (playerItem) then
            xPlayer.removeInventoryItem(itemName, 1)
            Shared.Events:ToClient(xPlayer.source, "engine:item:eat", itemName, itemLabel, extra)
        else
            Server:showNotification(xPlayer.source, "Vous n'avez pas cette objet", false)
        end
    end
end)