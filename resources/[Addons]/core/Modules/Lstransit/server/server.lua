RegisterNetEvent("Core:Lstransit:BuyTicket", function(pos, station)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        local Player = GetPlayerPed(xPlayer.source)
        local Coords = GetEntityCoords(Player)

        local WithinDistance = false
        for _, Lstransit in ipairs(Config["Lstransit"]["Station"]) do
            if #(Coords - Lstransit.pedPos) <= 15 then
                WithinDistance = true
                break
            end
        end

        if (not WithinDistance) then
            return DropPlayer(xPlayer.source, "Desynchronisation avec le serveur veuillez vous reconnectez")
        end

        local Price = Config["Lstransit"]["Price"]

        local Bill = ESX.CreateBill(0, xPlayer.source, Price, "Ls Transit", "server")
        if Bill then
            TriggerClientEvent("Core:Lstransit:Pay", xPlayer.source, pos, station)
        else
            xPlayer.showNotification("Vous avez refusé la facture")
        end
    end
end)