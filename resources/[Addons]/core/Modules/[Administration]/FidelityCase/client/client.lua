RegisterNetEvent("iZeyy:Case:Fidelity", function(label)
    ESX.ShowNotification(("Vous avez gagné (~b~%s~s~) !"):format(label))
    RageUI.PlaySound("HUD_AWARDS", "FLIGHT_SCHOOL_LESSON_PASSED")
end)