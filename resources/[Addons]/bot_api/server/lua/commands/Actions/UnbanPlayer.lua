function _bot_api:UnbanPlayer(ban_id, cb)

    local data = {}
    data[1] = ban_id

     exports['epicenter']:debanPlayer(0, data, function(msg)
        cb(msg)
    end)
end