TriggerEvent(Config.Get.ESX, function(obj) ESX = obj end)

RegisterNetEvent("JustGod:UpdatePlayer", function()
	local src = source;
	local xPlayer = ESX.GetPlayerFromId(src);
	if (xPlayer) then
		xPlayer.triggerEvent('iZeyy:Player:ReloadPlayer', {
            character_id = xPlayer.character_id,
            identifier = xPlayer.identifier,
            name = xPlayer.name,
            firstName = xPlayer.getFirstName(),
            lastName = xPlayer.getLastName(),
            money = xPlayer.getAccount("cash"),
            dirty = xPlayer.getAccount("dirtycash"),
            bank = xPlayer.getAccount("bank"),
            accounts = xPlayer.getAccounts(),
            level = xPlayer.getLevel(),
            group = xPlayer.getGroup(),
            job = xPlayer.getJob(),
            job2 = xPlayer.getJob2(),
            inventory = xPlayer.getInventory(),
            lastPosition = xPlayer.getLastPosition(),
            weight = xPlayer.getWeight(),
            maxWeight = 40,
            xp = xPlayer.getXP(),
            vip = xPlayer.GetVIP(),
            isDead = xPlayer.isDead(),
            isHurt = xPlayer.isHurt(),
            hurtTime = xPlayer.getHurtTime(),
		})
	end
end);