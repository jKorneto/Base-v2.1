local KevlarBreak = false
local KevlarEquiped = false

AddEventHandler("entityDamaged", function (Player)
    local PlayerPed = PlayerPedId()

    if (Player == PlayerPedId()) then
        if (GetPedArmour(PlayerPed) ~= 0) then
            KevlarEquiped = true
        elseif (GetPedArmour(PlayerPed) <= 0 and KevlarEquiped) then
            KevlarBreak = true
            ClearTimecycleModifier()
            SetEntityInvincible(PlayerPed, true)
            ESX.ShowNotification("Vous Kevlar c'est brisé, vous etes K.O")
            SetPedToRagdoll(PlayerPed, 3000, 3000, 0, 0, 0, 0)
            SetPedComponentVariation(PlayerPed, 9, 0, 0, 0)
            SetTimeout(3000, function()
                SetEntityInvincible(PlayerPed, false)
                ResetPedRagdollTimer(PlayerPed)
                KevlarBreak = false
                KevlarEquiped = false
            end)
        end
    end
end)

RegisterNetEvent("Core:Kevlar:Check", function()
    local PlayerPed = PlayerPedId()

    if (GetVehiclePedIsIn(PlayerPed, false) == 0) then
        if (GetPedArmour(PlayerPed) >= 20) then
            ESX.ShowNotification("Vous avez déja un Kevlar sur vous")
            return
        else
            TriggerServerEvent("Core:Kevlar:Valid")
        end
    else
        ESX.ShowNotification("Vous ne pouvez pas faire cette actions en etant dans un véhicule")
    end
end)

RegisterNetEvent("Core:Kevlar:Add", function()
    local PlayerPed = PlayerPedId()

    if (KevlarEquiped == false) then
        TaskStartScenarioInPlace(PlayerPed, "CODE_HUMAN_MEDIC_KNEEL", -1, false)
        HUDProgressBar("Mise de Kevlar en cours...", 5, function()
            ClearPedTasks(PlayerPed)
            SetPedArmour(PlayerPed, 100)
            SetPedComponentVariation(PlayerPed, 9, 12, 0, 0)
            KevlarEquiped = true
        end)
    end
end)