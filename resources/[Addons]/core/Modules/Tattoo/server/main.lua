local Timeout = {}

RegisterNetEvent("iZeyy:Tattoo:Remove", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local Price = Config["Tattoo"]["DelPrice"]

    if (xPlayer) then
        if (not Timeout[xPlayer.identifier] or GetGameTimer() - Timeout[xPlayer.identifier] > 10000) then
            Timeout[xPlayer.identifier] = GetGameTimer();
            if (xPlayer.getAccount("cash").money >= Price) then
                local Bill = ESX.CreateBill(0, xPlayer.source, Price, "Tattoo", "server")
                if Bill then
                    MySQL.Async.execute("UPDATE playerstattoos SET tattoos = @tattoos WHERE identifier = @identifier", {['@tattoos'] = json.encode({}), ['@identifier'] = xPlayer.identifier})
                    xPlayer.showNotification("Vous avez supprimer touts vos Tatouages")
                    TriggerClientEvent("iZeyy:Tattoo:DelTatoo", xPlayer.source)
                else
                    xPlayer.showNotification("Vous avez refusé la facture")
                end
            else
                xPlayer.showNotification("Vous n'avez pas assez d'argent")
            end
        else
            xPlayer.showNotification("Vous devez attendre 10 secondes avant de pouvoir effacer à nouveau.");
        end
    end
end)

RegisterNetEvent("iZeyy:Tattoo:Check", function(TattoosList, Value)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Price = Config["Tattoo"]["TattooPrice"]

    if (xPlayer) then
        if (xPlayer.getAccount("cash").money >= Price) then
            local Bill = ESX.CreateBill(0, xPlayer.source, Price, "Tattoo", "server")
            if Bill then
                table.insert(TattoosList, Value)
                MySQL.Async.execute("UPDATE playerstattoos SET tattoos = @tattoos WHERE identifier = @identifier", {['@tattoos'] = json.encode(TattoosList), ['@identifier'] = xPlayer.identifier})
                TriggerClientEvent("iZeyy:Tatto:Succes", xPlayer.source, Value)
                xPlayer.showNotification(("Vous avez payé %s$"):format(Price))
            else
                xPlayer.showNotification("Vous avez refusé la facture")
            end
        else
            xPlayer.showNotification("Vous n'avez pas assez d'argent")
        end
    end
end)

-- First Loads
RegisterNetEvent("iZeyy:Tattoo:FirstLoad", function()
    local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll("SELECT * FROM playerstattoos WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
		if (result[1] ~= nil) then
			local TattooList = json.decode(result[1].tattoos)
			TriggerClientEvent("iZeyy:Tattoo:GetTattoo", xPlayer.source, TattooList)
		else
			local tattooValue = json.encode({})
			MySQL.Async.execute("INSERT INTO playerstattoos (identifier, tattoos) VALUES (@identifier, @tattoo)", {['@identifier'] = xPlayer.identifier, ['@tattoo'] = tattooValue})
            TriggerClientEvent("iZeyy:Tattoo:GetTattoo", xPlayer.source, {})
		end
	end)
end)