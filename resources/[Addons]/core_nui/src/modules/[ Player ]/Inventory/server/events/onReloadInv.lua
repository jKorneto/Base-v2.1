-- AddEventHandler("esx:playerLoaded", function(source, xPlayer)
-- 	if (xPlayer) then
-- 		TriggerEvent('OneLife:PlayerHasBeenLoadedSkin')
-- 	end
-- end)

-- AddEventHandler('onResourceStart', function(resourceName)
--     if (GetCurrentResourceName() ~= resourceName) then
--       	return
--     end

--     Wait(2000)

--     for _, playerId in ipairs(GetPlayers()) do
-- 		local xPlayer = ESX.GetPlayerFromId(playerId)
			
-- 		xPlayer.ReloadInventoryPlayer()

-- 		TriggerClientEvent('OneLife:Inventory:UpdatePlayerInventory', xPlayer.source, xPlayer.getInventory(), xPlayer.getInventoryClothes(), xPlayer.getWeight(), xPlayer.getMaxWeight())
--     end
-- end)