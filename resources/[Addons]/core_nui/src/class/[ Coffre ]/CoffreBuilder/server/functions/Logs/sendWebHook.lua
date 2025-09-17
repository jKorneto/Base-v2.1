function _OneLifeCoffreBuilder:sendWebHook(title, message, WeebHook, color)
    local local_date = os.date('%H:%M:%S', os.time())

    local content = {
         {
              ["title"] = title,
              ["description"] = message,
              ["type"]  = "rich",
              ["color"] = 1000849,
              ["footer"] =  {
                ["text"]= "Powered for OneLife ©   |  "..local_date.."",
                ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
              },
         }
    }
    PerformHttpRequest(WeebHook, function(err, text, headers) end, 'POST', json.encode({username = "Logs Coffre Builder", embeds = content}), { ['Content-Type'] = 'application/json' })
    
end