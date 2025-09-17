RegisterNetEvent("iZeyy:CenterJob:Resign", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
	local coords = GetEntityCoords(player)
    
    if (xPlayer) then
        if #(coords - Config["CenterJob"]["Pos"]) < 15 then
            if (xPlayer.getJob().name ~= "unemployed") then
                xPlayer.setJob("unemployed", 0)
                xPlayer.showNotification("Démission effectué avec succès")
            else
                xPlayer.showNotification("Vous etes déja au chomage")
            end
        else
            xPlayer.ban(0, "(iZeyy:CenterJob:Resign) (coords)")
        end
    end
end)