local Price = 120

RegisterNetEvent("iZeyy:Parachute:HasMoney", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        local Player = GetPlayerPed(xPlayer.source)
        local Coords = GetEntityCoords(Player)

        local withinDistance = false
        for _, v in pairs(Config["Parachute"]["Pos"]) do
            local position = v.pos
            if #(Coords - position) <= 15 then
                withinDistance = true
                break
            end
        end
        
        if (not withinDistance) then
            xPlayer.ban(0, "Tentative de triche detectée (iZeyy:Parachute:HasMoney #1)")
        end

        if (withinDistance) then

            local Bill = ESX.CreateBill(0, xPlayer.source, Price, "Parachute", "server")
            if Bill then
                if (xPlayer.canCarryItem("gadget_parachute", 1)) then
                    xPlayer.addWeapon("GADGET_PARACHUTE", 1)
                    xPlayer.showNotification("Vous avez reçu votre parachute")
                else
                    xPlayer.showNotification("Vous n'avez pas assez de place sur vous")
                end
            end
        end
    end
end)