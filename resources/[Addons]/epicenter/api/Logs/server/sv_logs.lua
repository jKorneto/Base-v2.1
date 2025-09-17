TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
AddEventHandler('playerDropped', function(reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    local local_date = os.date('%H:%M:%S', os.time())
    local content = {
        {
            ["title"] = "**__Information :__**",
            ["fields"] = {
                { name = "- Joueur :", value = xPlayer.name.." "..xPlayer.identifier },
                { name = '- Raison du déco :', value = reason }
            },
            ["type"]  = "rich",
            ["color"] = 1000849,
            ["footer"] =  {
              ["text"]= "Powered for OneLife ©   |  "..local_date.."",
              ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
            },
        }
    }
    PerformHttpRequest("https://discord.com/api/webhooks/1310472374205943909/mHNxSjgBkv6yy5gSs7Sknx2q8ryDMvfBy2ON6B0WSXkrJGC4GsIw3T6yIq-pPjcYUzlz", function(err, text, headers) end, 'POST', json.encode({username = "Logs Déconnexion", embeds = content}), { ['Content-Type'] = 'application/json' })
end)

AddEventHandler("playerConnecting", function ()
	local identifier
	local playerId = source
	local PcName = GetPlayerName(playerId)
	
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = string.sub(v, 9)
			break
		end
	end
    local local_date = os.date('%H:%M:%S', os.time())
        local content = {
            {
                ["title"] = "**Connexion au serveur :**",
                ["fields"] = {
                    { name = "- Joueur :", value = PcName },
                    { name = "- License  :", value = "license:"..identifier },
                },
                ["type"]  = "rich",
                ["color"] = 1000849,
                ["footer"] =  {
                  ["text"]= "Powered for OneLife ©   |  "..local_date.."",
                  ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
                },
            }
        }
        PerformHttpRequest("https://discord.com/api/webhooks/1310472374205943909/mHNxSjgBkv6yy5gSs7Sknx2q8ryDMvfBy2ON6B0WSXkrJGC4GsIw3T6yIq-pPjcYUzlz", function(err, text, headers) end, 'POST', json.encode({username = "Logs SHOP", embeds = content}), { ['Content-Type'] = 'application/json' })
end)