AdminEmsInService = {}
AdminSaspInService = {}

function CountTableElements(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

function SendServiceJob()
    for k, v in pairs(sAdminSrv.AdminList) do
        local Ems = CountTableElements(AdminEmsInService)
        local Sasp = CountTableElements(AdminSaspInService)
        TriggerClientEvent("iZeyy:UpdateServiceJob", k, Ems, Sasp)
    end
end

function SendConnectedServiceJob(source)
    local Ems = CountTableElements(AdminEmsInService)
    local Sasp = CountTableElements(AdminSaspInService)
    TriggerClientEvent("iZeyy:UpdateServiceJob", source, Ems, Sasp)
end


-- Ems
function NewEmsInService(identifier)
    if (AdminEmsInService[identifier] == nil) then
        AdminEmsInService[identifier] = true
        SendServiceJob()
    end
end

function RemoveEmsInService(identifier)
    if (AdminEmsInService[identifier] ~= nil) then
        AdminEmsInService[identifier] = nil
        SendServiceJob()
    end
end

RegisterNetEvent("iZeyy:AddEms:InService")
AddEventHandler("iZeyy:AddEms:InService", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        NewEmsInService(xPlayer.identifier)
    end
end)


RegisterNetEvent("iZeyy:RemoveEms:InService")
AddEventHandler("iZeyy:RemoveEms:InService", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        RemoveEmsInService(xPlayer.identifier)
    end
end)

-- Sasp
function NewSaspInService(identifier)
    if (AdminSaspInService[identifier] == nil) then
        AdminSaspInService[identifier] = true
        SendServiceJob()
    end
end

function RemoveSaspInService(identifier)
    if (AdminSaspInService[identifier] ~= nil) then
        AdminSaspInService[identifier] = nil
        SendServiceJob()
    end
end

RegisterNetEvent("iZeyy:AddSasp:InService")
AddEventHandler("iZeyy:AddSasp:InService", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        NewSaspInService(xPlayer.identifier)
    end
end)

RegisterNetEvent("iZeyy:RemoveSasp:InService")
AddEventHandler("iZeyy:RemoveSasp:InService", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        RemoveSaspInService(xPlayer.identifier)
    end
end)

-- Information Service Job
AddEventHandler("playerDropped", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (xPlayer.job.name == "ambulance") then
            RemoveEmsInService(xPlayer.identifier)
        elseif (xPlayer.job.name == "police") then
            RemoveSaspInService(xPlayer.identifier)
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer.group ~= "user") then
        SendConnectedServiceJob(xPlayer.source)
    end
end)
    