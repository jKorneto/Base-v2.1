ESX.RegisterUsableItem("kevlar", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        TriggerClientEvent("Core:Kevlar:Check", xPlayer.source)
    end
end)

RegisterNetEvent("Core:Kevlar:Valid", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local HasKevlar = xPlayer.getInventoryItem("kevlar")

    if (HasKevlar) then
       xPlayer.removeInventoryItem("kevlar", 1)
       TriggerClientEvent("Core:Kevlar:Add", xPlayer.source)
    end
end)