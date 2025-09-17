playerInService = {}

RegisterNetEvent("iZeyy:job:takeService", function(job, active)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        if (xPlayer.job.name ~= job) then
            xPlayer.ban(0, "(iZeyy:job:takeService)")
            return
        end

        if (job == "ambulance") then
            if (active) then
                TriggerEvent("iZeyy:AddEms:InService", xPlayer.source)
            else
                TriggerEvent("iZeyy:RemoveEms:InService", xPlayer.source)
            end
        elseif (job == "police") then
            if (active) then
                TriggerEvent("iZeyy:AddSasp:InService", xPlayer.source)
            else
                TriggerEvent("iZeyy:RemoveSasp:InService", xPlayer.source)
            end
        end

        for k, v in pairs(Config["Log"]["Job"]) do
            if (k == job) then
                local webhook = v["take_service"]

                if (webhook) then

                    if active then
                        if (playerInService[xPlayer.identifier] == nil) then
                            playerInService[xPlayer.identifier] = {}
                            playerInService[xPlayer.identifier].job = job
                            playerInService[xPlayer.identifier].inService = true
                            CoreSendLogs("TakeService", "OneLife | TakeService", ("%s %s (***%s***) viens de prendre son service en tant que (***%s***)"):format(xPlayer.getLastName(), xPlayer.getFirstName(), xPlayer.identifier, xPlayer.getJob().label), webhook)
                        end
                    else
                        if (playerInService[xPlayer.identifier] ~= nil) then
                            playerInService[xPlayer.identifier] = nil
                            CoreSendLogs("LeaveService", "OneLife | LeaveService", ("%s %s (***%s***) viens de quitter son service de (***%s***)"):format(xPlayer.getLastName(), xPlayer.getFirstName(), xPlayer.identifier, xPlayer.getJob().label), webhook)
                        end
                    end

                end

            end

        end

    end

end)

AddEventHandler("playerDropped", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        
        if (playerInService[xPlayer.identifier] ~= nil) then
            local job = xPlayer.job.name

            for k, v in pairs(Config["Log"]["Job"]) do

                if (k == job) then

                    local webhook = v["take_service"]

                    if (webhook) then

                        if (playerInService[xPlayer.identifier] ~= nil) then
                            playerInService[xPlayer.identifier] = nil
                            CoreSendLogs("LeaveService", "OneLife | LeaveService", ("%s %s (***%s***) viens de quitter son service de (***%s***) (playerDropped)"):format(xPlayer.getLastName(), xPlayer.getFirstName(), xPlayer.identifier, xPlayer.getJob().label), webhook)
                        end

                    end
                    
                end

            end

        end

    end

end)

exports("GetPlayerInService", function(identifier)

    if (playerInService[identifier] ~= nil) then
        return playerInService[identifier]
    else
        return nil
    end

end)