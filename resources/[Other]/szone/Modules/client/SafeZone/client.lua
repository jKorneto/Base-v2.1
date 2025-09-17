exports("ShowNuiInSafeZone", function()
    SendNUIMessage({
        type = 'safezone:set', 
        isInSafezone = true
    })
end)

exports("ShowNuiNotInSafeZone", function()
    SendNUIMessage({
        type = 'safezone:set', 
        isInSafezone = false
    })
end)