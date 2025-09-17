local stuck_cooldown = false

RegisterCommand("stuck", function()
    if not stuck_cooldown then
        
        stuck_cooldown = true
        SetEntityCoords(GetPlayerPed(-1), GetEntityCoords(GetPlayerPed(-1)).x, GetEntityCoords(GetPlayerPed(-1)).y, GetEntityCoords(GetPlayerPed(-1)).z + 1.0)
        FreezeEntityPosition(GetPlayerPed(-1), false)
        Wait(10000)
        stuck_cooldown = false
    else
        ESX.ShowNotification("Veuillez patienter entre chaque utilisation de cette fonctionnalité")
    end
end)