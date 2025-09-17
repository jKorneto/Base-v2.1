function _OneLifeCoffreGang:logsRetrait(source, xPlayer, itemName, itemCount)
     local local_date = os.date('%H:%M:%S', os.time())
     local link = "https://discord.com/api/webhooks/1310463404141576304/OvzrYbyM2eg6ohshkvwwDCawTQgs8ecIwzLnsGs5mcm1yVURjkIEyZUp0NkhsjzPZCBQ"
     local content = {
         {
             ["title"] = "**Retrait Item(s) :**",
             ["fields"] = {
                 { name = "- Joueur :", value = xPlayer.name.." ["..source.."] ["..xPlayer.identifier.."]" },
                 { name = "- Item retiré :", value = itemName.." x"..itemCount },
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