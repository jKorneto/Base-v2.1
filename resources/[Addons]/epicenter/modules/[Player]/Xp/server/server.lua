local ESX = nil

TriggerEvent(Config.Get.ESX, function(obj) ESX = obj end)

CreateThread(function()
	local timers = {};
	while true do
		local players = ESX.GetPlayers();
		local count = 0;
		Wait(60*1000*2);; -- Wait(60*1000*3);
		for i=1, #players, 1 do
			local xPlayer = ESX.GetPlayerFromId(players[i]);
			if (xPlayer) then
				if (not timers[xPlayer.identifier]) then
					timers[xPlayer.identifier] = GetGameTimer();
				elseif (GetGameTimer() - timers[xPlayer.identifier] >= 60*1000*15) then -- 60*1000*15
					count = count + 1;
					timers[xPlayer.identifier] = GetGameTimer();
					xPlayer.addXP(525);
				end
			end
		end
	end
end);

ESX.AddGroupCommand("addxp", "fondateur", function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(args[1])
    local amount = tonumber(args[2])

    if (xPlayer and xTarget) then
        xTarget.addXP(amount)
        xPlayer.showNotification("Vous avez ajouté " .. amount .. " XP à " .. xTarget.name)
        xTarget.showNotification("Vous avez reçu " .. amount .. " XP")
    end
end, {help = "addxp", params = {
    {name = "ID du joueur", help = "L'ID du joueur à sanctionner"},
    {name = "amount", help = "Quantité de XP à ajouter", type = "number"}
}})

ESX.AddGroupCommand("removexp", "fondateur", function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(args[1])
    local amount = tonumber(args[2])

    if (xPlayer and xTarget) then
        xTarget.removeXP(amount)
        xPlayer.showNotification("Vous avez retiré " .. amount .. " XP à " .. xTarget.name)
        xTarget.showNotification("Vous avez perdu " .. amount .. " XP")
    end
end, {help = "removexp", params = {
    {name = "ID du joueur", help = "L'ID du joueur à sanctionner"},
    {name = "amount", help = "Quantité de XP à retirer", type = "number"}
}})
