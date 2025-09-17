ESX.AddGroupCommand("debanac", "admin", function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local banId = args[1]
        local reason = args[2]
        if #banId == 6 and tonumber(banId) then
            ExecuteCommand("waveshield unban " .. banId)
            xPlayer.showNotification("✨ Le joueur (" .. banId .. ") a été débanni AntiCheat pour la raison : " .. reason)
        else
            xPlayer.showNotification("❌ Le BanID doit est composé 6 caractères, exemple :\n/debanac 123456")
        end
    end
end, {help = "Débannir un joueur via AntiCheat", params = {
    {name = "BanID", help = "ID de bannissement à 6 chiffres"},
    {name = "Reason", help = "Raison du debannissement", optional = true}
}})