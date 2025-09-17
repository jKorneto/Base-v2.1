function _bot_api:GiveWeapon(id, weapon, cb)
	local xPlayer = ESX.GetPlayerFromId(id)

	if (xPlayer) then
        if (ESX.GetWeapon(weapon)) then

            xPlayer.addWeapon(weapon, 1);
            xPlayer.showNotification('Vous venez de recevoir x~b~1 '..weapon..'~s~ dans vottre inventaire.')

            cb("Le joueur "..xPlayer.name.." a bien reçu "..weapon.." !")
        else
            cb("Le nom de l\'arme est invalide.")
        end
	else
        cb("Le joueur n'est pas connecter !")
	end
end