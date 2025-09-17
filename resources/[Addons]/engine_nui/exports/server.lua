exports("SendNUIMessage", function(source, message, route)
    TriggerClientEvent("engine_nui:receiveNuiMessage", source, message, route)
end)

exports("SetNuiFocus", function(source, hasFocus, hasCursor)
    TriggerClientEvent("engine_nui:receiveNuiFocus", source, hasFocus, hasCursor)
end)

exports("SetNuiFocusKeepInput", function(keepInput)
    TriggerClientEvent("engine_nui:receiveNuiFocusKeepInput", source, keepInput)
end)

exports("openUrl", function(source, url)
    TriggerClientEvent("engine_nui:receiveOpenUrl", source, url)
end)

