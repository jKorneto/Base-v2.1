function _OneLifeCoffreSociety:logsDepot(source, xPlayer, itemName, itemId, itemCount)
    local IdShow = ""
    if itemId ~= nil and type(itemId) ~= 'boolean' then
        IdShow = ' ( '..tostring(itemId)..' )'
    end

    local local_date = os.date('%H:%M:%S', os.time())
    local link = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
    local content = {
        {
            ["title"] = "**Dépot Item(s) :**",
            ["fields"] = {
                { name = "- Joueur :", value = xPlayer.name.." ["..source.."] ["..xPlayer.identifier.."]" },
                { name = "- Item déposé :", value = itemName.." x"..itemCount..IdShow },
                { name = "- Entreprise / Gang :", value = self.jobName },
            },
            ["type"]  = "rich",
            ["color"] = 1000849,
            ["footer"] =  {
                ["text"]= "Powered for OneLife ©   |  "..local_date.."",
                ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
            },
        }
    }
    PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({username = "Logs Society", embeds = content}), { ['Content-Type'] = 'application/json' })
end