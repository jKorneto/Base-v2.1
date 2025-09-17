ESX.RegisterUsableItem('cagoule', function(source)
	TriggerClientEvent('iZeyy:cagoule', source)
end)

RegisterNetEvent('iZeyy:CagouletSet')
AddEventHandler('iZeyy:CagouletSet', function(player)
	if player == -1 then return end
	local xPlayer = ESX.GetPlayerFromId(player)
	local Player = ESX.GetPlayerFromId(source)
	if Player.getInventoryItem('cagoule').count == 0 then 
		TriggerEvent("tF:Protect", source, '(iZeyy:CagouletSet)');
	else
		if (xPlayer) then
			if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(player))) > 50 then
				DropPlayer(source, 'Tentative cheat cagoule')
			else
				TriggerClientEvent('iZeyy:CagouleSet', xPlayer.source)
			end
		end
	end
end)

ESX.AddGroupCommand("cagoule", "admin", function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
    if args[1] == -1 then 
        xPlayer.ban(0, "Tentative de Cheat Cagoule (-1)")
        return
    end
    if args[1] == '-1' then 
        xPlayer.ban(0, "Tentative de Cheat Cagoule (-1)")
        return
    end    
    TriggerClientEvent('iZeyy:CagouleSet', args[1])
end, {help = "Masqué la vue a un joueurs", params = {
    {name = "Id", help = "Id du joueurs"}
}})