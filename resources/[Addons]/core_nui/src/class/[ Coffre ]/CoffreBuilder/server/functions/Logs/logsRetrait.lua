function _OneLifeCoffreBuilder:logsRetrait(source, xPlayer, itemName, itemCount)

     local Title = "Items Retrait - Coffre : "..self.jobCoffre
     local Message
     local WeebHook

     -- Logs Job
     if self.jobCoffre == "ltd_sud" then
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "avocat" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "boatseller" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "burgershot" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "journalist" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "mecano2" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "realestateagent" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "ambulance" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "label" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "mecano" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "planeseller" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "taxi" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "tequilala" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "unicorn" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "cardealer" then 
          Message = "Item retiré par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     elseif self.jobCoffre == "catcofee" then 
          Message = "Item déposé par **"..xPlayer.getFirstName().." "..xPlayer.getLastName().." - ("..xPlayer.name..")\n\n Information : **\n Item : "..itemName.."\n Nombre : "..itemCount
          WeebHook = "https://discord.com/api/webhooks/1310458771188748299/J4clGq0fkKVKJwaxrqbfBl-kJ-bEB2v6yfz7qu0SncL8NtRKxyTYQ0Ul6N8SHqnQlc47"
     end


     ---LOGS LEGAL
     self:sendWebHook(Title, Message, WeebHook, 16711697)
     
     ---ADMIN
     self:sendWebHook(Title, Message, "https://discord.com/api/webhooks/1130353535100399708/mBoJGDVwxdtc20cvwQJacwswjGQmSFl5IvmQN5IB5fCEnXdS016vI3HOwfI7xdV9YTb4", 16711697)
end