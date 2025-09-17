RegisterNetEvent("iZeyy:Case:Fidelity", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    local HasCase = xPlayer.getInventoryItem("fidelitycase")

    if (HasCase and HasCase.quantity >= 1) then
        xPlayer.removeInventoryItem("fidelitycase", 1)

        local Reward = {
            { Name = "weapon_pistol", Label = "Pistolet", Quantity = 1, Type = "weapon" },
            { Name = "bread", Label = "10x Pain", Quantity = 10, Type = "item" },
            { Name = 125000, Label = "125 000~g~$~s~", Quantity = 1, Type = "money" },
        }

        local randomIndex = math.random(1, #Reward)
        local selectedReward = Reward[randomIndex]

        if selectedReward.Type == "weapon" then
            xPlayer.addWeapon(selectedReward.Name, selectedReward.Quantity)
        elseif selectedReward.Type == "item" then
            xPlayer.addInventoryItem(selectedReward.Name, selectedReward.Quantity)
        elseif selectedReward.Type == "money" then
            xPlayer.addAccountMoney("cash", selectedReward.Name)
        end
        
        TriggerClientEvent("iZeyy:Case:Fidelity", xPlayer.source, selectedReward.Label)
    else
        xPlayer.showNotification("Vous n'avez pas de caisse dans votre inventaire")
    end
end)