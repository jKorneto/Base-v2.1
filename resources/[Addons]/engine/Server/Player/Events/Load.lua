AddEventHandler("esx:playerLoaded", function(playerSrc)
    local xPlayer = ESX.GetPlayerFromId(playerSrc)

    if (xPlayer) then
        local player = {
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
        }

        Shared.Events:ToClient(xPlayer, Engine["Enums"].Player.Events.ReceivePlayerData, player)
    end
end)

AddEventHandler("engine:esx:loaded", function()
    local players = GetPlayers()

    for i = 1, #players do
        local xPlayer = ESX.GetPlayerFromId(tonumber(players[i]))

        if (type(xPlayer) == "table") then
            local player = {
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
            }
            
            Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Player.Events.ReceivePlayerData, player)
        end
    end
end)