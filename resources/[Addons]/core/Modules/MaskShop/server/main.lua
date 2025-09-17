RegisterNetEvent('iZeyy:maskshop:pay', function(mask1, mask2)

	local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config["MaskShop"]["Price"]

    if (xPlayer) then
        local Bill = ESX.CreateBill(0, xPlayer.source, price, "Tattoo", "server")
        if Bill then
            xPlayer.showNotification("Vous avez payer "..price.." ~g~$")
            TriggerClientEvent("iZeyy:maskshop:save", xPlayer.source, mask1, mask2)
        else
            xPlayer.showNotification("Vous avez refusé la facture")
        end
        
    end
end)