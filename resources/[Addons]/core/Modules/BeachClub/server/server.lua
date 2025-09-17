RegisterNetEvent("iZeyy:BeachClub:BuyItems", function(label, name, price)

    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        local correctItems = false
        for k, v in pairs(Config["BeachClub"]["Items"]) do
            if (label == v.label and name == v.name and price == v.price) then
                correctItems = true
                break
            end
        end

        if (not correctItems) then
            return xPlayer.showNotification("Cette objets n'est pas dans notre liste")
        end

        if (correctItems) then
            local pPed = GetPlayerPed(xPlayer.source)
            local pCoords = GetEntityCoords(pPed)

            local dist = #(pCoords - Config["BeachClub"]["BarPos"])

            if (dist < 100) then

                local Bill = ESX.CreateBill(0, xPlayer.source, price, "BeachClub", "server")
                if (Bill) then
                    xPlayer.addInventoryItem(name, 1)
                end
            end
        end
    end

end)