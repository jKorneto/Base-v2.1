ESX.AddGroupCommand("car", "friends", function(source, args, user)
    local model = (type(args[1]) == "number" and args[1] or GetHashKey(args[1]))
    local xPlayer = ESX.GetPlayerFromId(source)
    local plyCoords = GetEntityCoords(GetPlayerPed(source))

    local isFounder = xPlayer.getGroup() == "fondateur"

    if (not isFounder) then
        for _, blacklistedModel in ipairs(Config["BlacklistVehicle"]["HashKey"]) do
            if (model == blacklistedModel) then
                xPlayer.showNotification("Ce véhicule est interdit.")
                return
            end
        end
    end

    exports["core_nui"]:SpawnVehicle(model, plyCoords, 0.0, nil, false, xPlayer, xPlayer.identifier, function(vehicle)
        SetPedIntoVehicle(GetPlayerPed(xPlayer.source), vehicle:GetHandle(), -1)
    end)

end, {help = "spawn un véhicule", params = {
    {name = "car", help = "nom de la voiture"}
}})

ESX.AddGroupCommand("dv", "friends", function(Source, Args)
    local xPlayer = ESX.GetPlayerFromId(Source)
    local Radius = tonumber(Args[1]) or 1

    if (Radius) > 50 then
        xPlayer.showNotification("Le rayon est trop grand, veuillez spécifier un rayon de 50 mètres ou moins.")
        return
    end

    if (xPlayer) then
        local PlayerCoords = xPlayer.getCoords(true)
        local VehicleDeleted = false
        local PlayerVehicle = GetVehiclePedIsIn(GetPlayerPed(Source), false)

        if PlayerVehicle ~= 0 then
            DeleteEntity(PlayerVehicle)
            VehicleDeleted = true
        else
            for _, Vehicle in pairs(GetAllVehicles()) do
                local VehicleCoords = GetEntityCoords(Vehicle)

                if #(PlayerCoords - VehicleCoords) <= Radius then
                    local VehNetId = NetworkGetNetworkIdFromEntity(Vehicle)
                    if VehNetId then
                        DeleteEntity(Vehicle)
                        VehicleDeleted = true
                    end
                end
            end
        end

        if (VehicleDeleted) then
            if (PlayerVehicle) ~= 0 then
                xPlayer.showNotification("Votre véhicule a été supprimé.")
            else
                xPlayer.showNotification(("Vous avez supprimé les véhicules dans une zone de %s mètres"):format(Radius))
            end
        else
            xPlayer.showNotification("Aucun véhicule trouvé à supprimer.")
        end
    end
end, {help = "Supprimer le véhicule", params = {
    {name = "Radius", help = "Optionnel, supprime chaque véhicule dans le rayon spécifié (max 50 mètres)"}
}})