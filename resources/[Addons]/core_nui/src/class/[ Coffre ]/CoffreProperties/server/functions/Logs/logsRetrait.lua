function _OneLifeCoffreProperties:logsRetrait(source, xPlayer, itemName, itemCount)
    local local_date = os.date('%H:%M:%S', os.time())
    local link = "https://discord.com/api/webhooks/1310461639740624906/AdrME3ddVMFX0H9xigHAc5u7JFx607xG5LP2k8e_BgOGB_e6n4rtliJTl7HLDNbAL_fn"
    local content = {
        {
            ["title"] = "**Retrait Item(s) :**",
            ["fields"] = {
                { name = "- Joueur :", value = xPlayer.name.." ["..source.."] ["..xPlayer.identifier.."]" },
                { name = "- Item retiré :", value = itemName.." x"..itemCount },
                { name = "- Entreprise / Gang :", value = self.propertiesName },
            },
            ["type"]  = "rich",
            ["color"] = 1000849,
            ["footer"] =  {
              ["text"]= "Powered for OneLife ©   |  "..local_date.."",
              ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
            },
        }
    }
    PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({username = "Logs Properties", embeds = content}), { ['Content-Type'] = 'application/json' })
end