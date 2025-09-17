local webhook = 'https://discord.com/api/webhooks/1310476442718703676/WKeyDbavTFdV5re_UoJSjxEDUkBj-sNPvYpuwCizppGWSG1RzFjK1L3bz9PljO3ShIXv'

ESX.RegisterServerCallback('screenshot:getwebhook', function(source, cb)
    cb('https://discord.com/api/webhooks/1310476442718703676/WKeyDbavTFdV5re_UoJSjxEDUkBj-sNPvYpuwCizppGWSG1RzFjK1L3bz9PljO3ShIXv')
end)

RegisterNetEvent("GameCore:TakeScreen")
AddEventHandler("GameCore:TakeScreen", function(source)
    TriggerClientEvent('GameCore:GetScreen', source)
end)

ESX.AddGroupCommand('screen', 'helpeur', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(args[1])
    local sourcePlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Screen Joueurs", content = "----Début des screen du joueur "..xPlayer.name.." demander par "..sourcePlayer.name.."----"}), { ['Content-Type'] = 'application/json' })
        for i = 1, 5 do
            Wait(2000)
            TriggerEvent('GameCore:TakeScreen', args[1])
            Wait(2000)
        end
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Screen Joueurs", content = "----Fin des screen du joueur "..xPlayer.name.." demander par "..sourcePlayer.name.."----"}), { ['Content-Type'] = 'application/json' })
    else
        ESX.ChatMessage(source, "Le joueur n'est pas en ligne.")
    end
end, {help = "screen", params = {
    {name = "screen", help = "ID du joueurs"}
}})