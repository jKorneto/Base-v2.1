RegisterNetEvent("iZeyy:Bar:changeMusic", function(UrlMusic, Zone)
    local xPlayer = ESX.GetPlayerFromId(source)

    local playerJob = xPlayer.job.name
    if Config["Bar"]["List"][playerJob] then
        local ZoneMusicId = Config["Bar"]["List"][playerJob].zoneMusicId
        TriggerClientEvent("iZeyy:Bar:playMusic", -1, UrlMusic, Zone, ZoneMusicId)
    else
        xPlayer.ban(0, "Tentative de triche (iZeyy:Bar) Code: 0x0004")
    end
end)

RegisterNetEvent("iZeyy:Bar:stopMusic", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local foundJob = false

    for k, v in pairs(Config["Bar"]["List"]) do
        if (xPlayer.job.name == k) then
            foundJob = true
            local ZoneMusicId = Config["Bar"]["List"][xPlayer.job.name].zoneMusicId
            TriggerClientEvent("iZeyy:Bar:stopMusic", -1, ZoneMusicId)
            break
        end
    end

    if not foundJob then
        return xPlayer.showNotification("Vous n'avez le Job afin de STOP la musique")
    end
end)

RegisterNetEvent("core:music:volume", function(masterVol)
    local xPlayer = ESX.GetPlayerFromId(source)
    local foundJob = false

    for k, v in pairs(Config["Bar"]["List"]) do
        if (xPlayer.job.name == k) then
            foundJob = true
            local ZoneMusicId = Config["Bar"]["List"][xPlayer.job.name].zoneMusicId
            local MusiqueSound = masterVol
            exports["xsound"]:setVolume(-1, ZoneMusicId, MusiqueSound)
            break
        end
    end

    if not foundJob then
        return xPlayer.showNotification("Vous n'avez le Job afin de changer le volume")
    end
end)

RegisterNetEvent("iZeyy:Bar:buyItems", function(Target, Item, Count, Price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        for k, v in pairs(Config["Bar"]["List"]) do
            if xPlayer.job.name == k then
                local xTarget = ESX.GetPlayerFromId(Target)
                if xTarget then
                    local PlayerPed = GetPlayerPed(xPlayer.source)
                    local TargetPed = GetPlayerPed(xTarget.source)
                    local PlayerPos = GetEntityCoords(PlayerPed)
                    local TargetPos = GetEntityCoords(TargetPed)
                    local Distance = #(PlayerPos - TargetPos)
                    local JobLabel = Config["Bar"]["List"][xPlayer.job.name].jobLabel
                    local JobName = Config["Bar"]["List"][xPlayer.job.name]

                    if #(PlayerPos - Config["Bar"]["List"][xPlayer.job.name].barPos) > 15.0 then
                        xPlayer.ban(0, "Tentative de triche (iZeyy:Bar) Code: 0x0002")
                        return
                    end

                    if Distance <= 10.0 then
                        if (xPlayer.canCarryItem(Item, Count)) then
                            local Bill = ESX.CreateBill(xPlayer.source, xTarget.source, Price * 2, JobLabel, "society", xPlayer.job.name)
                            if Bill then
                                xTarget.addInventoryItem(Item, Count)
                                ESX.RemoveSocietyMoney(k, Price)
                            else
                                xPlayer.showNotification("Le joueur à refuser la facture")
                            end
                        else
                            xPlayer.showNotification("Le joueur n'a pas de place sur lui")
                        end
                    else
                        xPlayer.ban(0, "Tentative de triche (iZeyy:Bar) Code: 0x0003")
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("iZeyy:Bar:sendAnnouncement", function(announcementType)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if (Config["Bar"]["List"][xPlayer.job.name] ~= nil) then
            local jobLabel = Config["Bar"]["List"][xPlayer.job.name].jobLabel
            local announcementContent = announcementType == 1 and "open" or announcementType == 2 and "close" or "recruitment"
            local message = Config["Bar"]["List"][xPlayer.job.name].announcements[announcementContent]

            showSocietyNotify(xPlayer, xPlayer.job.name, jobLabel, message, "Informations", 10)
        end
    end
end)

RegisterNetEvent("izeyy:bar:sendAnnouncementperso", function(announcement)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        for k, v in pairs(Config["Bar"]["List"]) do
            if xPlayer.job.name == k then

                if (xPlayer.job.grade == 3) then
                    local jobLabel = xPlayer.job.label
                    showSocietyNotify(xPlayer, xPlayer.job.name, jobLabel, announcement, "Entreprise", 10)
                else
                    return
                end
                
            end

        end

    end
end)

RegisterNetEvent("iZeyy:Bar:frisk", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (Config["Bar"]["List"][xPlayer.job.name] == nil) then
            return xPlayer.ban(0, "(iZeyy:Bar:frisk)")
        end

        local player = GetPlayerPed(xPlayer.source)
        local target = GetPlayerPed(xTarget.source)
        local playerCoords = GetEntityCoords(player)
        local targetCoords = GetEntityCoords(target)

        if #(playerCoords - targetCoords) > 15 then
            return xPlayer.ban(0, "(iZeyy:Bar:frisk) #2")
        end

        exports["inventory"]:FriskTarget(xPlayer.source, xTarget.source)
    end
end)

RegisterNetEvent("iZeyy:Bar:close:frisk", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if (type(xPlayer) == "table" and type(xTarget) == "table") then
        if (Config["Bar"]["List"][xPlayer.job.name] == nil) then
            return xPlayer.ban(0, "(iZeyy:Bar:frisk)")
        end

        exports["inventory"]:CloseFrisk(xPlayer.source, xTarget.source)
    end
end)

-- @Items
ESX.RegisterUsableItem("vodka", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('vodka', 1)
    TriggerClientEvent('fowlmas:status:add', source, 'thirst', 450000)
	TriggerClientEvent('esx_basicneeds:oncoffee', source)
    TriggerClientEvent('esx:showNotification', source, "Vous avez consommé un(e) vodka")
end)

ESX.RegisterUsableItem("vodkaenergy", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('vodkaenergy', 1)
    TriggerClientEvent('fowlmas:status:add', source, 'thirst', 450000)
	TriggerClientEvent('esx_basicneeds:oncoffee', source)
    TriggerClientEvent('esx:showNotification', source, "Vous avez consommé un(e) vodka energy")
end)

ESX.RegisterUsableItem("vodkafruit", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('vodkafruit', 1)
    TriggerClientEvent('fowlmas:status:add', source, 'thirst', 450000)
	TriggerClientEvent('esx_basicneeds:oncoffee', source)
    TriggerClientEvent('esx:showNotification', source, "Vous avez consommé un(e) vodka fruit")
end)

ESX.RegisterUsableItem("vodkaredbull", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('vodkaredbull', 1)
    TriggerClientEvent('fowlmas:status:add', source, 'thirst', 450000)
	TriggerClientEvent('esx_basicneeds:oncoffee', source)
    TriggerClientEvent('esx:showNotification', source, "Vous avez consommé un(e) vodka redbull")
end)

ESX.RegisterUsableItem("jager", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('jager', 1)
    TriggerClientEvent('fowlmas:status:add', source, 'thirst', 450000)
	TriggerClientEvent('esx_basicneeds:oncoffee', source)
    TriggerClientEvent('esx:showNotification', source, "Vous avez consommé un(e) jager")
end)

ESX.RegisterUsableItem("martini", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('martini', 1)
    TriggerClientEvent('fowlmas:status:add', source, 'thirst', 450000)
	TriggerClientEvent('esx_basicneeds:oncoffee', source)
    TriggerClientEvent('esx:showNotification', source, "Vous avez consommé un(e) martini")
end)

ESX.RegisterUsableItem("redbull", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('redbull', 1)
    TriggerClientEvent('fowlmas:status:add', source, 'thirst', 450000)
	TriggerClientEvent('esx_basicneeds:oncoffee', source)
    TriggerClientEvent('esx:showNotification', source, "Vous avez consommé un(e) redbull")
end)