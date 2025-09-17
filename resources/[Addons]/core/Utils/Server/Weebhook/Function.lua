function CoreSendLogs(name, title, message, web)
    local local_date = os.date('%H:%M:%S', os.time())
  
    if message ~= nil and message ~= '' then
        message = message:gsub("license:xxxxx", "license:izeyounet")
    else
        return false
    end

    local embeds = {
        {
            ["title"] = title,
            ["description"] = message,
            ["type"] = "rich",
            ["color"] = Config["LogColorCode"],
            ["footer"] = {
                ["text"] = "Made for " .. Config["ServerName"] .. " ©   |  " .. local_date .. "",
                ["icon_url"] = Config["ServerImage"]
            },
        }
    }

    PerformHttpRequest(web, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embeds }), { ['Content-Type'] = 'application/json' })
end


exports('SendLogs', CoreSendLogs)