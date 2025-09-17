function SendLogsOther(name, title, message, web)
    local local_date = os.date('%H:%M:%S', os.time())
  
	local embeds = {
		{
			["title"]= title,
			["description"]= message,
			["type"]= "rich",
            ["color"] = 1000849,
            ["footer"] =  {
              ["text"]= "Powered for OneLife ©   |  "..local_date.."",
              ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
            },
		}
	}
  
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(web, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end