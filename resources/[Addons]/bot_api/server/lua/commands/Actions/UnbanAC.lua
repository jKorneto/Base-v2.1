function _bot_api:UnbanAC(ban_id, cb)
    local succes = exports['WaveShield']:unbanPlayer(ban_id, "Unban", "From discord bot")

    if (succes) then
        cb("Le joueur avec le ban ID WaveShield "..ban_id.." est unban !")
    else
        cb("Ce ban ID WaveShield ne correspond pas !")
    end
end