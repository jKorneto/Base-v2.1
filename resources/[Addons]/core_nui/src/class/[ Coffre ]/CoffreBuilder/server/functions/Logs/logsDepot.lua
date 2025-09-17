function _OneLifeCoffreBuilder:logsDepot(source, xPlayer, itemName, itemId, itemCount)

     local Title = "Items Dépose - Coffre : "..self.jobCoffre
     local Message
     local WeebHook

     -- Logs Job
     if self.jobCoffre == "avocat" then
          Message = "Item déposé par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "boatseller" then 
          Message = "Item déposé par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "burgershot" then 
          Message = "Item déposé par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "mecano2" then 
          Message = "Item déposé par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "realestateagent" then 
          Message = "Item déposé par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "ambulance" then 
          Message = "Item déposé par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "mecano" then 
          Message = "Item déposé par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "planeseller" then 
          Message = "Item déposé par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "unicorn" then 
          Message = "Item déposé par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "cardealer" then 
          Message = "Item déposé par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "catcofee" then 
          Message = "Item déposé par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     end


     ---LOGS LEGAL
     self:sendWebHook(Title, Message, WeebHook, 65280)
     
     ---ADMIN
     self:sendWebHook(Title, Message, "https://discord.com/api/webhooks/1310459030174699594/8JwuFbH4YzYAPrpPs6czz_1trEpRdZxq9413VXGlqtPVshoZdcrylNf9gDBBrZJQiqIn", 65280)
end