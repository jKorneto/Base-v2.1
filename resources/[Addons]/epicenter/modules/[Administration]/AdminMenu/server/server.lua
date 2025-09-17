sAdminSrv = {
    Notification = function(id, str)
        TriggerClientEvent('esx:showNotification', id, str)
    end,
    NotifiedAllStaff = function(str)
        for k,v in pairs(sAdminSrv.AdminList) do 
            sAdminSrv.Notification(k, str) -- pour que meme ceux en service recoivent   
        end
    end,
    GetDate = function()
        local date = os.date('*t')
        
        if date.day < 10 then date.day = '0' .. tostring(date.day) end
        if date.month < 10 then date.month = '0' .. tostring(date.month) end
        if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
        if date.min < 10 then date.min = '0' .. tostring(date.min) end
        if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    
        return(date.day ..'/'.. date.month ..'/'.. date.year ..' - '.. date.hour ..':'.. date.min ..':'.. date.sec)
    end,
    GetHours = function()
        local date = os.date('*t')

        if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
        if date.min < 10 then date.min = '0' .. tostring(date.min) end
        if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    
        return(date.hour ..':'.. date.min ..':'.. date.sec)
    end,
    Print = function(str) 
        -- print(sAdmin.Config.Print.DefaultPrefix.." "..str)
    end,
    Debug = function(str) 
        -- print(sAdmin.Config.Print.DebugPrefix.." "..str)
    end,
    UpdateReport = function()
        for k,v in pairs(sAdminSrv.AdminList) do 
            TriggerClientEvent("sAdmin:UpdateReportsList", k, sAdminSrv.ReportsList)
        end
    end,
    AdminList = {},
    PlayersList = {},
    ReportsList = {},
    Items = {},
    TriggersForStaff = function(triggerName, args)
        for k,v in pairs(sAdminSrv.AdminList) do 
            TriggerClientEvent(triggerName, k, args)
        end
    end
}

local inService = {}

exports('IsInService', function(identifier)
    return inService[identifier] or false
end)

exports('GetReportsList', function()
    return sAdminSrv.ReportsList
end)

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(result)
        for k, v in pairs(result) do
            sAdminSrv.Items[k] = { label = v.label, name = v.name }
        end
    end)
end)

RegisterNetEvent('sAdmin:IsAdmin')
AddEventHandler('sAdmin:IsAdmin', function()
    local _source = source
	if not _source then return end
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end 
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= sAdmin.Config.DefaultGroup then 
        local dbQuery = false
        if not sAdminSrv.AdminList[_source] then

            sAdminSrv.AdminList[_source] = {}
            sAdminSrv.AdminList[_source].source = _source
            sAdminSrv.AdminList[_source].name = GetPlayerName(_source)
            sAdminSrv.AdminList[_source].license = xPlayer.identifier
            sAdminSrv.AdminList[_source].inService = false
            sAdminSrv.AdminList[_source].grade = xGroup

            MySQL.Async.fetchAll('SELECT * FROM `staff` WHERE `license`=@license', {
                ['@license'] = xPlayer.identifier
            }, function(result)
                if result[1] then
                    sAdminSrv.AdminList[_source].reportEffectued = tonumber(result[1].report)
                    sAdminSrv.AdminList[_source].appreciation = json.decode(result[1].evaluation)
                else
                    MySQL.Sync.execute('INSERT INTO `staff` (name, license, evaluation, report) VALUES (@name, @license, @evaluation, @report)', {
                        ['@name'] = GetPlayerName(_source),
                        ['@license'] = xPlayer.identifier,
                        ['@evaluation'] = json.encode({}),
                        ['@report'] = 0,
                    }, function() end)

                    sAdminSrv.AdminList[_source].reportEffectued = 0
                    sAdminSrv.AdminList[_source].appreciation = {}

                    AddReportList(xPlayer.identifier, GetPlayerName(_source))
                end
                dbQuery = true
            end)

            while not dbQuery do Wait(1) end

            --sAdminSrv.Notification(_source, "~s~Administration~s~\nVotre mode staff est actuellement ~s~désactivé~s~.\n[~s~"..sAdmin.Config.KeyOpenMenu.."~s~] pour ouvrir le menu.")
            TriggerClientEvent("sAdmin:NewAdmin", -1, sAdminSrv.AdminList[_source])
            TriggerClientEvent("sAdmin:GetPlayerList", _source, sAdminSrv.PlayersList)
            TriggerClientEvent("sAdmin:GetReports", _source, sAdminSrv.ReportsList)

            return
        else
            sAdminSrv.AdminList[_source].source = _source
            sAdminSrv.AdminList[_source].inService = false
            sAdminSrv.AdminList[_source].grade = xGroup
            --sAdminSrv.Notification(_source, "~s~Administration~s~\nVotre mode staff est actuellement ~s~désactivé~s~.\n[~s~"..sAdmin.Config.KeyOpenMenu.."~s~] pour ouvrir le menu.")
            TriggerClientEvent("sAdmin:NewAdmin", -1, sAdminSrv.AdminList[_source])

            if sAdmin.Config.Debug then 
                sAdminSrv.Debug("Refresh du staff "..GetPlayerName(_source))
            end
        end
    end
end)

local function AddNewAdmin(source, playerName, identifier, grade)
    sAdminSrv.AdminList[source] = {}
    sAdminSrv.AdminList[source].source = source
    sAdminSrv.AdminList[source].name = playerName
    sAdminSrv.AdminList[source].license = identifier
    sAdminSrv.AdminList[source].inService = false
    sAdminSrv.AdminList[source].grade = grade

    MySQL.Sync.execute('INSERT INTO `staff` (name, license, evaluation, report) VALUES (@name, @license, @evaluation, @report)', {
        ['@name'] = playerName,
        ['@license'] = identifier,
        ['@evaluation'] = json.encode({}),
        ['@report'] = 0,
    }, function() end)

    sAdminSrv.AdminList[source].reportEffectued = 0
    sAdminSrv.AdminList[source].appreciation = {}
    sAdminSrv.PlayersList[source].group = grade

    AddReportList(identifier, GetPlayerName(source))

    TriggerClientEvent("sAdmin:NewAdmin", -1, sAdminSrv.AdminList[source])
    TriggerClientEvent("sAdmin:UpdatePlayerList", -1, source, sAdminSrv.PlayersList[source])
    TriggerClientEvent("sAdmin:GetPlayerList", source, sAdminSrv.PlayersList)
    TriggerClientEvent("sAdmin:GetReports", source, sAdminSrv.ReportsList)
end

local function updateAdmin(xPlayer)
    sAdminSrv.AdminList[xPlayer.source].source = xPlayer.source
    sAdminSrv.AdminList[xPlayer.source].inService = false
    sAdminSrv.AdminList[xPlayer.source].grade = xPlayer.getGroup()
    TriggerClientEvent("sAdmin:NewAdmin", -1, sAdminSrv.AdminList[xPlayer.source])
end

local function removeAdmin(xPlayer)
    sAdminSrv.AdminList[xPlayer.source] = nil
    sAdminSrv.PlayersList[xPlayer.source].group = sAdmin.Config.DefaultGroup
    MySQL.Sync.execute('DELETE FROM `staff` WHERE `license`= @license', {
        ['@license'] = xPlayer.identifier
    })

    TriggerClientEvent("sAdmin:RemoveAdmin", -1, xPlayer.source)
    TriggerClientEvent("sAdmin:UpdatePlayerList", -1, xPlayer.source, sAdminSrv.PlayersList[xPlayer.source])
end

RegisterNetEvent("sAdmin:updateStaff", function(xPlayer, oldGroup, newGroup)
    if (type(xPlayer) == "table") then
        local oldGroup = tostring(oldGroup)
        local newGroup = tostring(newGroup)

        if (oldGroup ~= newGroup) then
            if (newGroup == sAdmin.Config.DefaultGroup) then
                removeAdmin(xPlayer)
                TriggerEvent("admin:update:group", xPlayer.source)
                return
            end

            if (not sAdminSrv.AdminList[xPlayer.source]) then
                AddNewAdmin(
                    xPlayer.source,
                    GetPlayerName(xPlayer.source), 
                    xPlayer.identifier, 
                    newGroup
                )
                TriggerEvent("admin:update:group", xPlayer.source)
            else
                TriggerEvent("admin:update:group", xPlayer.source)
                updateAdmin(xPlayer)
            end
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not sAdminSrv.PlayersList[_source] then 
        sAdminSrv.PlayersList[_source] = {}
        sAdminSrv.PlayersList[_source].source = _source
        sAdminSrv.PlayersList[_source].name = GetPlayerName(_source)
        sAdminSrv.PlayersList[_source].hoursLogin = sAdminSrv.GetHours()
        sAdminSrv.PlayersList[_source].group = xPlayer.getGroup(_source)
        
        local firstName = xPlayer.getFirstName()
        local lastName = xPlayer.getLastName()
        
        if firstName == "" then
            firstName = "New"
        end

        if lastName == "" then
            lastName = "Player"
        end
        
        sAdminSrv.PlayersList[_source].firstname = firstName
        sAdminSrv.PlayersList[_source].lastname = lastName
        sAdminSrv.PlayersList[_source].idUnique = xPlayer.get('character_id')
        TriggerClientEvent("sAdmin:NewPlayerList", -1, _source, sAdminSrv.PlayersList[_source])
        --print(json.encode(sAdminSrv.PlayersList))
    end
end)

RegisterNetEvent('sAdmin:updateGroupe')
AddEventHandler('sAdmin:updateGroupe', function(source, newGroupe)
    local _source = source

    if sAdminSrv.AdminList[_source] then 
        sAdminSrv.AdminList[_source].grade = newGroupe
        TriggerClientEvent("sAdmin:UpdateAdminGroup", _source, _source, newGroupe)
    else 
        DropPlayer(_source, "Déco reco toi pour éviter les petits bugs de synchronisation que tu pourrais rencontrer.")
    end
end)

AddEventHandler('playerDropped', function(reason)
    local _source = source

    if sAdminSrv.PlayersList[_source] then 
        sAdminSrv.PlayersList[_source] = nil
        sAdminSrv.TriggersForStaff("sAdmin:RemovePlayerList", _source)
    end

    if sAdminSrv.ReportsList[_source] then 
        sAdminSrv.ReportsList[_source] = nil 
        sAdminSrv.UpdateReport()
    end

    if sAdminSrv.AdminList[_source] then 
        MySQL.Sync.execute('UPDATE staff SET evaluation = @evaluation, report = @report WHERE license = @license', {
            ['@license'] = sAdminSrv.AdminList[_source].license,
            ['@evaluation'] = json.encode(sAdminSrv.AdminList[_source].appreciation),
            ['@report'] = GetReportByLicense(sAdminSrv.AdminList[_source].license)
        })
        sAdminSrv.AdminList[_source] = nil
        TriggerClientEvent("sAdmin:RemoveAdmin", -1, _source) 
    end
end)

RegisterNetEvent('sAdmin:ChangeState')
AddEventHandler('sAdmin:ChangeState', function(state, data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= sAdmin.Config.DefaultGroup then 
        if state == true then
            if xPlayer.getGroup() ~= "fondateur" and xPlayer.getGroup() ~= "gerantstaff" and xPlayer.getGroup() ~= "responsable" then
                TriggerClientEvent('sAdmin:changeStaffPed', source, "nValTrue")
                SendLogsOther("Staff", "OneLife | Service", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de prendre son service", "https://discord.com/api/webhooks/1310485591435247746/N01FmZtr_ew6ARgVSARx_YQ_6YEhkt3xocsn8-uusoS__uFS95MiHWSKfjBTavYp3Vo-")
                --sAdminSrv.NotifiedAllStaff(("Le Staff (~b~%s~s~) a activé son menu staff"):format(xPlayer.name))
            end
        else
            TriggerClientEvent('sAdmin:changeStaffPed', source, "nValFalse")
            SendLogsOther("Staff", "OneLife | Service", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de quitter son service", "https://discord.com/api/webhooks/1310485591435247746/N01FmZtr_ew6ARgVSARx_YQ_6YEhkt3xocsn8-uusoS__uFS95MiHWSKfjBTavYp3Vo-")
            --sAdminSrv.NotifiedAllStaff(("Le Staff (~b~%s~s~) a desactivé son menu staff"):format(xPlayer.name))
        end
        if sAdminSrv.AdminList[_source] then 
            sAdminSrv.AdminList[_source].inService = state
            --TriggerClientEvent('sAdmin:StaffState', source, state, data)
            if (state == true) then
                sAdminSrv.NotifiedAllStaff(("Le Staff (~b~%s~s~) a activé son menu staff"):format(xPlayer.name))
                if not inService[xPlayer.identifier] then
                    inService[xPlayer.identifier] = true
                    --print("add de la liste en service")
                end
            else
                sAdminSrv.NotifiedAllStaff(("Le Staff (~b~%s~s~) a desactivé son menu staff"):format(xPlayer.name))
                if inService[xPlayer.identifier] then
                    inService[xPlayer.identifier] = false
                    --print("delete de la liste en service")
                end
            end
            return
        end
    else 
        TriggerEvent("tF:Protect", source, '(Admin ChangeState)')
    end
end)

RegisterNetEvent("sAdmin:Goto")
AddEventHandler("sAdmin:Goto", function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= "user" then 
        local targetCoords = GetEntityCoords(GetPlayerPed(id))
        local bucket = GetPlayerRoutingBucket(xPlayer.source)
        local targetBucket = GetPlayerRoutingBucket(tPlayer.source)

        if (bucket ~= targetBucket) then
            exports["Framework"]:SetPlayerRoutingBucket(xPlayer.source, targetBucket)
            xPlayer.showNotification("Vous avez été téléporté dans une autre instance")
        end

        TriggerClientEvent("sAdmin:Tp", _source, targetCoords)
        SendLogsOther("Staff", "OneLife | Teleport", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) s'est téléporter sur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***)", "https://discord.com/api/webhooks/1310486206278144060/u-9qO-D4N5CfenRpcLya83QVKOLKUJlmTKpQof3nk5opxK0g-DaDEzESXXjAn-ycuDz3")
    else 
        TriggerEvent("tF:Protect", source, '(Admin Goto)')
    end
end)

RegisterNetEvent("sAdmin:resetBucket", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (xPlayer.getGroup() ~= "user") then
            local bucket = GetPlayerRoutingBucket(xPlayer.source)

            if (bucket ~= 0) then
                exports["Framework"]:SetPlayerRoutingBucket(xPlayer.source, 0)
            else
                xPlayer.showNotification("Vous êtes déjà dans l'instance par défaut")
            end
        end
    end
end)

RegisterNetEvent("sAdmin:Bring")
AddEventHandler("sAdmin:Bring", function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()

    if id == -1 then
        DropPlayer("Une erreur est servenue !")
        return
    end
    if xGroup ~= "user" then 
        local pCoords = GetEntityCoords(GetPlayerPed(_source))
        TriggerClientEvent("sAdmin:Tp", id, pCoords)
        SendLogsOther("Staff", "OneLife | Teleport", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) à téléporter sur lui **"..tPlayer.name.."** (***"..tPlayer.identifier.."***)", "https://discord.com/api/webhooks/1310486206278144060/u-9qO-D4N5CfenRpcLya83QVKOLKUJlmTKpQof3nk5opxK0g-DaDEzESXXjAn-ycuDz3")
    else 
        TriggerEvent("tF:Protect", source, '(Admin Bring)')
    end
end)

local freeze = {}
RegisterNetEvent("sAdmin:Freeze")
AddEventHandler("sAdmin:Freeze", function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= "user" then 
        if not freeze[tPlayer.identifier] then
            FreezeEntityPosition(GetPlayerPed(tPlayer.source), true)
            freeze[tPlayer.identifier] = true
        else
            FreezeEntityPosition(GetPlayerPed(tPlayer.source), false)
            freeze[tPlayer.identifier] = false
        end
        SendLogsOther("Staff", "OneLife | Freeze", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de freeze le joueur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***)", "https://discord.com/api/webhooks/1310486651436269578/wvwAlPAH3FJ2BBVz6o14a5eewtQV8CCFuVt0EoVF7_W5Qjq04Wxgs-tvB3eMh2lWfsIM")
    else 
        TriggerEvent("tF:Protect", source, '(Admin Freeze)')
    end
end)

RegisterNetEvent("sAdmin:GiveMoney")
AddEventHandler("sAdmin:GiveMoney", function(id, moneyType, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()

    if not tPlayer then
        xPlayer.showNotification("Le joueurs n'est pas connecté")
        return
    end

    if amount <= 0 then
        xPlayer.showNotification("Montant Invalide")
        return
    end

    if xGroup ~= "user" then
        if moneyType == "money" then
            tPlayer.addAccountMoney("cash", amount)
            tPlayer.showNotification(string.format("Vous avez recu %d$ de la part du Staff: %s", amount, xPlayer.name))
            xPlayer.showNotification(string.format("Le joueur %s a bien reçu %d$", tPlayer.name, amount))
        else
            tPlayer.addAccountMoney(moneyType, amount)
            tPlayer.showNotification(string.format("Vous avez recu %d$ de la part du Staff: %s", amount, xPlayer.name))
            xPlayer.showNotification(string.format("Le joueur %s a bien reçu %d$", tPlayer.name, amount))
        end
        SendLogsOther("Staff", "OneLife | Money", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de donner de l'argent au joueur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***) [**"..moneyType..", "..amount.." $**]", "https://discord.com/api/webhooks/1310452076307812394/aEzl5nRkrSzpJ8ifz1skNcdCJ-EF1WpBlv-ODZS8qqSfznyAhxVQ2-oVX3dzsWVB8kn2")
    else 
        TriggerEvent("tF:Protect", source, '(Admin GiveMoney)')
    end
end)

RegisterNetEvent("sAdmin:DeleteMoney")
AddEventHandler("sAdmin:DeleteMoney", function(id, moneyType, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()

    if not tPlayer then
        xPlayer.showNotification("Le joueurs n'est pas connecté")
        return
    end

    if amount <= 0 then
        xPlayer.showNotification("Montant Invalide")
        return
    end

    if xGroup ~= "user" then
        if moneyType == "money" then
            tPlayer.removeAccountMoney("cash", amount)
            tPlayer.showNotification(string.format("Vous avez perdu %d$ de la part du Staff: %s", amount, xPlayer.name))
            xPlayer.showNotification(string.format("Le joueur %s a bien perdu %d$", tPlayer.name, amount))
        else
            tPlayer.removeAccountMoney(moneyType, amount)
            tPlayer.showNotification(string.format("Vous avez perdu %d$ de la part du Staff: %s", amount, xPlayer.name))
            xPlayer.showNotification(string.format("Le joueur %s a bien perdu %d$", tPlayer.name, amount))
        end
        SendLogsOther("Staff", "OneLife | Money", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de supprimer de l'argent au joueur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***) [**"..moneyType..", "..amount.." $**]", "https://discord.com/api/webhooks/1310452076307812394/aEzl5nRkrSzpJ8ifz1skNcdCJ-EF1WpBlv-ODZS8qqSfznyAhxVQ2-oVX3dzsWVB8kn2")
    else 
        TriggerEvent("tF:Protect", source, '(Admin DeleteMoney)')
    end
end)        

RegisterNetEvent("sAdmin:GiveMoney:Perso", function(moneyType, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if amount <= 0 then
        xPlayer.showNotification("Montant Invalide")
        return
    end

    if xGroup ~= "user" then
        if moneyType == "money" then
            xPlayer.addAccountMoney("cash", amount)
            xPlayer.showNotification(string.format("Vous avez recu %d$", amount, xPlayer.name))
        else
            xPlayer.addAccountMoney(moneyType, amount)
            xPlayer.showNotification(string.format("Vous avez recu %d$", amount, xPlayer.name))
        end
        SendLogsOther("Staff", "OneLife | Money", "Le staff **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de donner de se give de l'argent au [**"..moneyType..", "..amount.." $**]", "https://discord.com/api/webhooks/1310452076307812394/aEzl5nRkrSzpJ8ifz1skNcdCJ-EF1WpBlv-ODZS8qqSfznyAhxVQ2-oVX3dzsWVB8kn2")
    else 
        TriggerEvent("tF:Protect", source, '(Admin GiveMoneyPerso)')
    end
end)

RegisterNetEvent("sAdmin:DeleteMoney:Perso")
AddEventHandler("sAdmin:DeleteMoney:Perso", function(moneyType, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if amount <= 0 then
        xPlayer.showNotification("Montant Invalide")
        return
    end

    if (xGroup ~= "user") then
        if (moneyType == "cash") then
            xPlayer.removeAccountMoney("cash", amount)
            xPlayer.showNotification(string.format("Vous vous etes retiré %d$", amount, xPlayer.name))
        else
            xPlayer.removeAccountMoney(moneyType, amount)
            xPlayer.showNotification(string.format("Vous vous etes retiré %d$", amount, xPlayer.name))
        end
        SendLogsOther("Staff", "OneLife | Money", "Le staff **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de se retirer de l'argent [**"..moneyType..", "..amount.." $**]", "https://discord.com/api/webhooks/1310452076307812394/aEzl5nRkrSzpJ8ifz1skNcdCJ-EF1WpBlv-ODZS8qqSfznyAhxVQ2-oVX3dzsWVB8kn2")
    else
        TriggerEvent("tF:Protect", source, '(Admin DeleteMoneyPerso)')
    end
end)

RegisterNetEvent("sAdmin:GiveItem")
AddEventHandler("sAdmin:GiveItem", function(id, item, amount)
    -- print(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= "user" then 
        tPlayer.addInventoryItem(item, amount)
        SendLogsOther("Staff", "OneLife | Item", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de donner un item au joueur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***) [**"..item..", "..amount.."**]", "https://discord.com/api/webhooks/1310452262270668852/GGEs0P_7R0cqNJYaWcjUZw8-tQukMzTLrGEPiZepn3n7P96CAN4fOMkrELpYXmtK9NXd")
    else 
        TriggerEvent("tF:Protect", source, '(Admin GiveItem)')
    end
end)

RegisterNetEvent("sAdmin:GiveMoneyMe")
AddEventHandler("sAdmin:GiveMoneyMe", function(moneyType, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= "user" then 
        xPlayer.addAccountMoney(moneyType, amount)
        SendLogsOther("Staff", "OneLife | Money", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de se donner de l'argent [**"..moneyType..", "..amount.." $**]", "https://discord.com/api/webhooks/1310487036402204756/1gz-TUCnzDtEvzVrWBiWpsa4yateURcjvDkaqhhmpRcfAnGT0wTkb19mM1utl-DXuwvo")
    else 
        TriggerEvent("tF:Protect", source, '(Admin GiveMoneyMe)')
    end
end)

RegisterNetEvent("sAdmin:GiveItemMe")
AddEventHandler("sAdmin:GiveItemMe", function(item, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= "user" then 
        xPlayer.addInventoryItem(item, amount)
        SendLogsOther("Staff", "OneLife | Item", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de se donner un item [**"..item..", "..amount.."**]", "https://discord.com/api/webhooks/1310487036402204756/1gz-TUCnzDtEvzVrWBiWpsa4yateURcjvDkaqhhmpRcfAnGT0wTkb19mM1utl-DXuwvo")
    else 
        TriggerEvent("tF:Protect", source, '(Admin GiveItemMe)')
    end
end)

RegisterServerEvent('sAdmin:GiveWeapons')
AddEventHandler('sAdmin:GiveWeapons', function(model, ammo)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'fondateur' and xPlayer.getGroup() ~= 'admin' and xPlayer.getGroup() ~= "gerant" then
        TriggerEvent("tF:Protect", source, '(admin:weapon)');
        return
    end
    xPlayer.addWeapon(model, 1)
    SendLogsOther("Staff", "OneLife | Armes", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de se donner une arme [**"..model..", "..ammo.."**]", "https://discord.com/api/webhooks/1310487036402204756/1gz-TUCnzDtEvzVrWBiWpsa4yateURcjvDkaqhhmpRcfAnGT0wTkb19mM1utl-DXuwvo")
end)

RegisterNetEvent("sAdmin:SendMessageGros")
AddEventHandler("sAdmin:SendMessageGros", function(id, message)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()
    local name = xPlayer.name

    if xGroup ~= "user" then 
        TriggerClientEvent("announceForMessage", id, message, name)
        SendLogsOther("Staff", "OneLife | Message", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de d'envoyer un message au joueur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***) [**"..message.."**]", "https://discord.com/api/webhooks/1310487172666753144/NAd2erKmZtxoz8R0GkTpPGZqBNXUJH8JDbfuqHRqm7ZwtLeJXyZcKVFE1LqAls_P-u7C")
    else 
        TriggerEvent("tF:Protect", source, '(Admin SendMessage)')
    end
end)

RegisterNetEvent("sAdmin:SendMessage")
AddEventHandler("sAdmin:SendMessage", function(id, message)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= "user" then 
        sAdminSrv.Notification(id, "~s~Message de "..xPlayer.name.."~s~\n"..message)
        SendLogsOther("Staff", "OneLife | Message", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de d'envoyer un message au joueur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***) [**"..message.."**]", "https://discord.com/api/webhooks/1310487172666753144/NAd2erKmZtxoz8R0GkTpPGZqBNXUJH8JDbfuqHRqm7ZwtLeJXyZcKVFE1LqAls_P-u7C")
    else 
        TriggerEvent("tF:Protect", source, '(Admin SendMessage)')
    end
end)


RegisterNetEvent("sAdmin:TpParking")
AddEventHandler("sAdmin:TpParking", function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= "user" then 
        TriggerClientEvent("sAdmin:TpParking", id)
        SendLogsOther("Staff", "OneLife | Teleport", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de téléporter le joueur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***) au parking centrale", "https://discord.com/api/webhooks/1310487365776576512/MYi-D2cMl0G59kCcTlXSwvNbcRoXDgYuUr9A6uA9yURy2KTPPr6QQi2QsEW0wgU47j47")
    else 
        TriggerEvent("tF:Protect", source, '(Admin TpParking)')
    end
end)

RegisterNetEvent("sAdmin:Kick")
AddEventHandler("sAdmin:Kick", function(id, reason)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= "user" then 
        DropPlayer(id, "Vous avez été kick.\nRaison : "..reason)
        SendLogsOther("Staff", "OneLife | Kick", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de kick le joueur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***) pour la raison [**"..reason.."**]", "https://discord.com/api/webhooks/1310482784070144000/uNi8Vt1G8QgM-YkD_yipWE90-hjvcY-VHfHq8x4tTKtPPhY6bFD0y5ryKaW8P4lNBZ_M")
    else 
        TriggerEvent("tF:Protect", source, '(Admin Kick)')
    end
end)

RegisterNetEvent("sAdmin:ShowInventory")
AddEventHandler("sAdmin:ShowInventory", function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= "user" then 
        local xTarget = ESX.GetPlayerFromId(id)
        local targetInventory = xTarget.getInventory(false)
        local targetAccount = xTarget.getAccounts()
        local targetWeapons = {}

        local list = ESX.GetWeaponList()

        for i=1, #list, 1 do
            if xTarget.hasWeapon(list[i].name) then 
                table.insert(targetWeapons, list[i].label)
            end
        end
        TriggerClientEvent("sAdmin:ShowInventory", _source, targetInventory, targetAccount, targetWeapons)
    else 
        TriggerEvent("tF:Protect", source, '(Admin ShowInventory)')
    end
end)

local reportCooldown = 60000
local playerCooldowns = {} 

RegisterCommand("report", function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local coords = GetEntityCoords(GetPlayerPed(source))

    if not xPlayer then return end

    if #(coords - sAdmin.Config.JailPos) <= 250 then
        xPlayer.showNotification("Vous ne pouvez pas faire de report en prison")
        return
    end

    TriggerClientEvent("iZeyy:Report:OpenMenu", xPlayer.source)
end, false)

RegisterNetEvent("iZeyy:Report:SendTicket", function(Reason)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local coords = GetEntityCoords(GetPlayerPed(source))

    if not xPlayer then return end

    if sAdminSrv.ReportsList[_source] then
        xPlayer.showNotification("Vous avez déjà un report en attente.")
        return
    end

    if #(coords - sAdmin.Config.JailPos) <= 250 then
        return
    end

    if playerCooldowns[_source] and playerCooldowns[_source] > GetGameTimer() then
        local timeRemaining = math.ceil((playerCooldowns[_source] - GetGameTimer()) / 60000)
        xPlayer.showNotification("Vous devez attendre avant de pouvoir refaire un report")
        return
    end

    local formattedReason = type(Reason) == "table" and table.concat(Reason, " ") or tostring(Reason)

    xPlayer.showNotification("Votre report a bien été envoyé !")
    local xName = GetPlayerName(_source)
    sAdminSrv.ReportsList[_source] = {
        Name = xName,
        Source = _source,
        Date = sAdminSrv.GetDate(),
        Raison = formattedReason,
        Taken = false,
        TakenBy = nil
    }

    sAdminSrv.NotifiedAllStaff("Un report est arrivé")
    sAdminSrv.UpdateReport()
    playerCooldowns[_source] = GetGameTimer() + reportCooldown
end)

RegisterNetEvent('sAdmin:UpdateReport')
AddEventHandler('sAdmin:UpdateReport', function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()
    local theName = xPlayer.name

    if xGroup ~= sAdmin.Config.DefaultGroup then 
        if sAdminSrv.ReportsList[id] then 
            sAdminSrv.ReportsList[id].Taken = true 
            sAdminSrv.ReportsList[id].TakenBy = theName
            sAdminSrv.UpdateReport()
            local targetCoords = GetEntityCoords(GetPlayerPed(id))
            TriggerClientEvent("sAdmin:Tp", _source, targetCoords, true)
            SendLogsOther("Staff", "OneLife | Report", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de prendre le report de **"..tPlayer.name.."** (***"..tPlayer.identifier.."***)", "https://discord.com/api/webhooks/1310487620484206622/SjRG6hKYtwNheB8D6d6ptDpzl-E1lfBZyF5kikB9cngNMFfE0xUBn7i1tmaqJKrPjhvQ")
        end
    end
end)

local PlayersPossibleEval = {}

RegisterNetEvent('sAdmin:ClotureReport')
AddEventHandler('sAdmin:ClotureReport', function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= sAdmin.Config.DefaultGroup then 
        sAdminSrv.AdminList[_source].reportEffectued = sAdminSrv.AdminList[_source].reportEffectued + 1
        TriggerClientEvent("sAdmin:UpdateNumberReport", _source, sAdminSrv.AdminList[_source].reportEffectued)
        -- TriggerClientEvent("sAdmin:OpenAvisMenu", id, {id = _source, name = GetPlayerName(_source), reasonReport = sAdminSrv.ReportsList[id].Raison})
        if sAdminSrv.ReportsList[id] then 
            sAdminSrv.Notification(_source, "Vous avez cloturer le report de "..sAdminSrv.ReportsList[id].Name)
            SendLogsOther("Staff", "OneLife | Report", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de cloturer le report de **"..tPlayer.name.."** (***"..tPlayer.identifier.."***)", "https://discord.com/api/webhooks/1310487620484206622/SjRG6hKYtwNheB8D6d6ptDpzl-E1lfBZyF5kikB9cngNMFfE0xUBn7i1tmaqJKrPjhvQ")
            sAdminSrv.ReportsList[id] = nil
            PlayersPossibleEval[id] = true
            sAdminSrv.UpdateReport()
        end
    end
end)

RegisterServerEvent('tF:resetReport')
AddEventHandler('tF:resetReport', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "fondateur" then
        MySQL.Async.execute("UPDATE staff SET report = 0;", {}, function() end)
    else
        TriggerEvent("tF:Protect", source, '(tF:resetReport)');
    end
end)

-- RegisterNetEvent('sAdmin:AddEvaluation')
-- AddEventHandler('sAdmin:AddEvaluation', function(staffId, evaluation)
--     local _source = source
--     local xPlayer = ESX.GetPlayerFromId(_source)
--     local tPlayer = ESX.GetPlayerFromId(staffId)
    
--     if PlayersPossibleEval[_source] then
--         PlayersPossibleEval[_source] = nil
--         if evaluation ~= nil and sAdminSrv.AdminList[_source].appreciation ~= nil and staffId ~= nil then
--             if sAdminSrv.AdminList[_source] then 
--                 table.insert(sAdminSrv.AdminList[_source].appreciation, evaluation)
--             end
--             TriggerClientEvent("sAdmin:UpdateAvis", staffId, staffId, sAdminSrv.AdminList[_source].appreciation)
--             sAdminSrv.Notification(_source, "Votre évaluation a été envoyé avec succés.")
--             SendLogsOther("Staff", "OneLife | Avis", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient de donner un avis au staff **"..tPlayer.name.."** (***"..tPlayer.identifier.."***) ["..evaluation.."/5]", "https://discord.com/api/webhooks/1093171998747799632/5jgZ_1vexX6rv53JBmrtp9mc6-QLCSGQmYqtAw447GlQog94rwRy5kmor-5jLaZPSeX6")
--         end
--     end
-- end)

RegisterCommand("debugstaff", function()
    -- print(json.encode(sAdminSrv.AdminList))
end, false)

RegisterNetEvent('sAdmin:GetStaffsList')
AddEventHandler('sAdmin:GetStaffsList', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= sAdmin.Config.DefaultGroup then 
        MySQL.Async.fetchAll('SELECT * FROM `staff`', {}, function(result)
            TriggerClientEvent("sAdmin:GetStaffsList", _source, result)
        end)    
    end
end)

RegisterNetEvent('sAdmin:GetItemList')
AddEventHandler('sAdmin:GetItemList', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= sAdmin.Config.DefaultGroup then 
        TriggerClientEvent("sAdmin:ReceiveItemList", _source, sAdminSrv.Items)   
    end
end)

local function GetStaffWithLicense(license)
    for k,v in pairs(sAdminSrv.AdminList) do 
        if v.license == license then 
            return k
        end
    end
    return nil
end

RegisterCommand("clearreport", function(source, args)
    local _source = source 
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= sAdmin.Config.DefaultGroup then 
        if args[1] then
            local staffId = GetStaffWithLicense(args[1])
            if staffId then
                sAdminSrv.AdminList[staffId].reportEffectued = 0
                sAdminSrv.Notification(_source, "Votre avez clear les reports de "..sAdminSrv.AdminList[staffId].name..".")
                TriggerClientEvent("sAdmin:UpdateNumberReport", staffId, sAdminSrv.AdminList[_source].reportEffectued)
            else 
                MySQL.Sync.execute('UPDATE staff SET report = @report WHERE license = @license', {
                    ['@license'] = args[1],
                    ['@report'] = 0
                })
                sAdminSrv.Notification(_source, "Votre avez clear les reports.")
            end
        else 
            sAdminSrv.Notification(_source, "Vous devez spécifier une license.")
        end
    end
end, false)

RegisterCommand("clearavis", function(source, args)
    local _source = source 
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
   if xGroup ~= sAdmin.Config.DefaultGroup then 
        if args[1] then
            local staffId = GetStaffWithLicense(args[1])
            if staffId then
                sAdminSrv.AdminList[staffId].appreciation = {}
                sAdminSrv.Notification(_source, "Votre avez clear les avis de "..sAdminSrv.AdminList[staffId].name..".")
                TriggerClientEvent("sAdmin:UpdateAvis", staffId, staffId, sAdminSrv.AdminList[_source].appreciation)
            else 
                MySQL.Sync.execute('UPDATE staff SET evaluation = @reporevaluationt WHERE license = @license', {
                    ['@license'] = args[1],
                    ['@evaluation'] = json.encode({})
                })
                sAdminSrv.Notification(_source, "Votre avez clear les avis.")
            end
        else 
            sAdminSrv.Notification(_source, "Vous devez spécifier une license.")
        end
    end
end, false)

RegisterCommand("deletstaff", function(source, args)
    local _source = source 
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= sAdmin.Config.DefaultGroup then 
        if args[1] then
            local staffId = GetStaffWithLicense(args[1])
            if staffId then
                sAdminSrv.AdminList[staffId].appreciation = {}
                sAdminSrv.Notification(_source, "Votre avez supprimer le staff "..sAdminSrv.AdminList[staffId].name..".")
            else 
                MySQL.Sync.execute('DELETE FROM staff WHERE license=@license', {
                    ['@license'] = args[1]
                })
                sAdminSrv.Notification(_source, "Votre avez supprimer le staff.")
            end
        else 
            sAdminSrv.Notification(_source, "Vous devez spécifier une license.")
        end
    end
end, false)

RegisterCommand("goto", function(source, args)
    local _source = source 
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(args[1])
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= "user" then 
        if args[1] ~= nil then
            if GetPlayerName(tonumber(args[1])) ~= nil then
                local coords = GetEntityCoords(GetPlayerPed(tonumber(args[1])))
                TriggerClientEvent("sAdmin:Tp", source, coords)
                SendLogsOther("Staff", "OneLife | Teleport", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) s'est téléporter sur le joueur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***)", "https://discord.com/api/webhooks/1310486206278144060/u-9qO-D4N5CfenRpcLya83QVKOLKUJlmTKpQof3nk5opxK0g-DaDEzESXXjAn-ycuDz3")
            end
        end
    end
end, false)

RegisterCommand("bring", function(source, args)
    local _source = source 
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(args[1])
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= "user" then 
        if args[1] ~= nil then
            if GetPlayerName(tonumber(args[1])) ~= nil then
                local target = tonumber(args[1])
                local coords = GetEntityCoords(GetPlayerPed(source))
                TriggerClientEvent("sAdmin:setCoords", target, coords)
                SendLogsOther("Staff", "OneLife | Teleport", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) à téléporter sur lui le joueur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***)", "https://discord.com/api/webhooks/1310486206278144060/u-9qO-D4N5CfenRpcLya83QVKOLKUJlmTKpQof3nk5opxK0g-DaDEzESXXjAn-ycuDz3")
            end
        end
    end
end, false)

RegisterServerEvent('sAdmin:giveVehicle')
AddEventHandler('sAdmin:giveVehicle', function(id, model, type, boutique)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)

    if not (xPlayer.getGroup() == 'fondateur' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == "gerant") then        
        TriggerEvent("tF:Protect", source, '(sAdmin:giveVehicle)')
        return
    end

    -- Validate the target player
    if not tPlayer then
        TriggerClientEvent('esx:showNotification', source, "Le joueur n'est pas trouvé.")
        return
    end

    ESX.SpawnVehicle(model, GetEntityCoords(GetPlayerPed(tPlayer.source)), 0.0, nil, false, tPlayer, tPlayer.getIdentifier(), function(vehicle)
        if not vehicle then
            TriggerClientEvent('esx:showNotification', source, "Erreur lors de la création du véhicule.")
            return
        end


        MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, state, boutique, stored) VALUES (@owner, @plate, @vehicle, @type, @state, @boutique, @stored)', {
            ['@owner']      = tPlayer.identifier,
            ['@plate']      = vehicle.plate,
            ['@vehicle']    = json.encode({
                model = vehicle.model,
                plate = vehicle.plate
            }),
            ['@state']      = 1,
            ['@boutique']   = boutique,
            ['@stored']     = 1,
            ['@type']       = type
        }, function(rowsChanged)
            if rowsChanged > 0 then
                SendLogsOther("Staff", "OneLife | Give Car", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient d'ajouter un véhicule dans le garage du joueur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***) ["..vehicle.plate.."]", "https://discord.com/api/webhooks/1310487858657624105/UgMp13wZh1ujBFTrJdNqMKEMr6ITrsqZo_QvRGPJsG-UVa8_jYLAoqY_YepJ-gzvMiIC")
                TriggerClientEvent('esx:showNotification', tPlayer.source, "Vous avez reçu un véhicule.")
                TriggerClientEvent('esx:showNotification', source, "Vous avez donné un véhicule à "..tPlayer.name..".")
            else
                TriggerClientEvent('esx:showNotification', source, "Erreur lors de l'insertion dans la base de données.")
            end
        end)
    end)
end)


RegisterNetEvent("sAdmin:spawnVehicle")
AddEventHandler("sAdmin:spawnVehicle", function(model, position)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then
        TriggerEvent("tF:Protect", source, '(sAdmin:spawnVehicle)');
        return
    end
    ESX.SpawnVehicle(GetHashKey(model), position, 90.0, nil, false, xPlayer, xPlayer.identifier, function(vehicle)
        SetPedIntoVehicle(GetPlayerPed(xPlayer.source), vehicle:GetHandle(), -1)
    end)
end)

RegisterNetEvent("sAdmin:repairVehicle", function(vehicleNetId, category)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (type(xPlayer) == "table") then
        if (xPlayer.getGroup() ~= "user") then
            local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)

            if (vehicle and vehicle ~= 0 and DoesEntityExist(vehicle)) then
                if (type(category) == "string") then
                    TriggerClientEvent("sAdmin:syncRepairVehicle", xPlayer.source, vehicleNetId, category)
                end
            end
        end
    end
end)

RegisterNetEvent("sAdmin:returnVehicle", function(vehicleNetId)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (type(xPlayer) == "table") then
        if (xPlayer.getGroup() ~= "user") then
            local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)

            if (vehicle and vehicle ~= 0 and DoesEntityExist(vehicle)) then
                TriggerClientEvent("sAdmin:syncReturnVehicle", xPlayer.source, vehicleNetId)
            end
        end
    end
end)

RegisterNetEvent("sAdmin:deleteVehicle", function(vehicleId)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (type(xPlayer) == "table") then
        if (xPlayer.getGroup() ~= "user") then
            local vehicle = NetworkGetEntityFromNetworkId(vehicleId)
            if DoesEntityExist(vehicle) then
                DeleteEntity(vehicle)
            end
        end
    end
end)

RegisterServerEvent("dclearloadout")
AddEventHandler("dclearloadout", function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local tPlayer = ESX.GetPlayerFromId(id)
    for k,v in ipairs(tPlayer.getLoadout()) do
        local vweaponperms = ESX.IsWeaponPermanent(v.name)
        if xPlayer.getGroup() ~= 'fondateur' and xPlayer.getGroup() ~= 'admin' and xPlayer.getGroup() ~= 'moderateur' and xPlayer.getGroup() ~= 'gerantstaff' then
            TriggerEvent("tF:Protect", source, '(dclearloadout)');
            break
        end
        
        if vweaponperms then
            xPlayer.showNotification("Vous ne pouvez pas clear les armes de car ce joueur il possede une ou plusieurs armes perms")
            break
        else
            xPlayer.showNotification("Les armes de  ~s~"..tPlayer.name.."~s~ on bien etait supprimer !")
            TriggerClientEvent("dclearw", src, id)
            -- print("^4[ClearLoadout]^7 ^2"..xPlayer.name..  "^2("..xPlayer.identifier..")^7 vien de wipe armes ^1"..tPlayer.name..  "^1("..tPlayer.identifier..")")
        end
    end
end)

function CreateRandomPlateTextForXP()
    local plate = ""
    math.randomseed(GetGameTimer())
    for i = 1, 4 do
        plate = plate .. characters[math.random(1, #characters)]
    end
    plate = plate .. ""
    for i = 1, 4 do
        plate = plate .. math.random(1, 9)
    end
    return plate
end

-- giveitem
RegisterCommand('giveItemConsole', function(source, args, item, count)
    if source == 0 then
        local xPlayer = ESX.GetPlayerFromId(args[1])
        xPlayer.addInventoryItem(args[2], tonumber(args[3]), nil, true)
        print("Vous avez give : x"..tonumber(args[3]).." "..args[2].." à "..xPlayer.name)
    end
end)

-- giveweapon
RegisterCommand('giveWeaponConsole', function(source, args, weapon)
    if source == 0 then
        local xPlayer = ESX.GetPlayerFromId(args[1])
        xPlayer.addWeapon(args[2], 1)
        print("Vous avez give : "..args[2].." à "..xPlayer.name)
    end
end)

-- clearinventory
RegisterCommand('clearInventoryConsole', function(source, args)
    if source == 0 then
        local xPlayer = ESX.GetPlayerFromId(args[1])
        xPlayer.clearInventoryItem()
        print("Vous avez clear inventaire : "..xPlayer.name)
    end
end)

-- clearweapon No perm
RegisterCommand('clearLoadoutConsole', function(source, args)
    if source == 0 then
        local xPlayer = ESX.GetPlayerFromId(args[1])
        xPlayer.clearAllInventoryWeapons(false)
        print("Vous avez clear armes (Non perm) à : "..xPlayer.name)
    end
end)

-- clearweapon No perm
RegisterCommand('clearAllLoadoutConsole', function(source, args)
    if source == 0 then
        local xPlayer = ESX.GetPlayerFromId(args[1])
        xPlayer.clearAllInventoryWeapons(true)
        print("Vous avez clear all armes à : "..xPlayer.name)
    end
end)

-- revive
RegisterCommand('reviveConsole', function(source, args)
    if source == 0 then
        local xPlayer = ESX.GetPlayerFromId(args[1])
        TriggerClientEvent('ambulance:revive', args[1])
        print("Vous avez revive : "..xPlayer.name)
    end
end)

-- debug player
RegisterCommand("debugPlayerConsole", function(source, args)
    if source == 0 then
        if (args[1]) then
            local player;
            if (args[1]:find("license:")) then
                player = ESX.GetPlayerFromIdentifier(args[1]);
            else
                player = ESX.GetPlayerFromId(tonumber(args[1]));
            end
            if (player) then
                TriggerEvent('esx:playerDropped', player.source, xPlayer, reason)
                ESX.Players[player.source] = nil;
            end
        else
            if (source > 0) then
                ESX.GetPlayerFromId(source).showNotification("~s~Vous devez entrer une license ou un id valide.");
            else
            --    ESX.Logs.Warn("^1Vous devez entrer une license ou un id valide.");
                print("^1Vous devez entrer une license ou un id valide.");
            end
        end
    end
end)

-- setjob
RegisterCommand('jobConsole', function(source, args, job, grade)
    if source == 0 then
        local xPlayer = ESX.GetPlayerFromId(args[1])
        xPlayer.setJob(args[2], args[3])
        print("Vous avez setjob : "..xPlayer.name.." | "..args[2].." "..args[3])
    end
end)

-- setjob2
RegisterCommand('job2Console', function(source, args, job, grade)
    if source == 0 then
        local xPlayer = ESX.GetPlayerFromId(args[1])
        xPlayer.setJob2(args[2], args[3])
        print("Vous avez setjob2 : "..xPlayer.name.." | "..args[2].." "..args[3])
    end
end)

-- Tppc
RegisterCommand("ConsoleTppc", function(source, args)
    if source == 0 then
        local players = args[1]
        TriggerClientEvent('Console:Tppc', players)
    end
end)

-- heal
RegisterCommand('healConsole', function(source, args)
    if source == 0 then
        local xPlayer = ESX.GetPlayerFromId(args[1])
        TriggerClientEvent('ambulance:heal', args[1])
        print("Vous avez heal : "..xPlayer.name)
    end
end)

-- Change license
RegisterCommand("updateLicense", function(source, args)
    if source == 0 then
        -- Users
        MySQL.Async.fetchAll('SELECT * FROM `users` WHERE `identifier`=@identifier', {
            ['@identifier'] = args[1]
        }, function(result)
            if result[1] then
                MySQL.Sync.execute('UPDATE users SET identifier = @report WHERE identifier = @license', {
                    ['@license'] = args[1],
                    ['@report'] = args[2],
                })
            end
        end)
        -- account_info
        MySQL.Async.fetchAll('SELECT * FROM `account_info` WHERE `license`=@license', {
            ['@license'] = args[1]
        }, function(result)
            if result[1] then
                MySQL.Sync.execute('UPDATE account_info SET license = @report WHERE license = @doze', {
                    ['@doze'] = args[1],
                    ['@report'] = args[2],
                })
            end
        end)
        -- clothes_data
        MySQL.Async.fetchAll('SELECT * FROM `clothes_data` WHERE `identifier`=@identifier', {
            ['@identifier'] = args[1]
        }, function(result)
            if result[1] then
                MySQL.Sync.execute('UPDATE clothes_data SET identifier = @report WHERE identifier = @license', {
                    ['@license'] = args[1],
                    ['@report'] = args[2],
                })
            end
        end)
        -- kq_extra
        MySQL.Async.fetchAll('SELECT * FROM `kq_extra` WHERE `player`=@identifier', {
            ['@identifier'] = args[1]
        }, function(result)
            if result[1] then
                MySQL.Sync.execute('UPDATE kq_extra SET player = @report WHERE player = @license', {
                    ['@license'] = args[1],
                    ['@report'] = args[2],
                })
            end
        end)
        -- properties_list
        MySQL.Async.fetchAll('SELECT * FROM `properties_list` WHERE `owner`=@identifier', {
            ['@identifier'] = args[1]
        }, function(result)
            if result[1] then
                MySQL.Sync.execute('UPDATE properties_list SET owner = @report WHERE owner = @license', {
                    ['@license'] = args[1],
                    ['@report'] = args[2],
                })
            end
        end)
        -- user_licenses
        MySQL.Async.fetchAll('SELECT * FROM `user_licenses` WHERE `owner`=@identifier', {
            ['@identifier'] = args[1]
        }, function(result)
            if result[1] then
                MySQL.Sync.execute('UPDATE user_licenses SET owner = @report WHERE owner = @license', {
                    ['@license'] = args[1],
                    ['@report'] = args[2],
                })
            end
        end)
        -- billing
        MySQL.Async.fetchAll('SELECT * FROM `billing` WHERE `identifier`=@identifier', {
            ['@identifier'] = args[1]
        }, function(result)
            if result[1] then
                MySQL.Sync.execute('UPDATE billing SET identifier = @report WHERE identifier = @license', {
                    ['@license'] = args[1],
                    ['@report'] = args[2],
                })
            end
        end)
        -- clothes_data
        MySQL.Async.fetchAll('SELECT * FROM `clothes_data` WHERE `identifier`=@identifier', {
            ['@identifier'] = args[1]
        }, function(result)
            if result[1] then
                MySQL.Sync.execute('UPDATE clothes_data SET identifier = @report WHERE identifier = @license', {
                    ['@license'] = args[1],
                    ['@report'] = args[2],
                })
            end
        end)
        -- playerstattoos
        MySQL.Async.fetchAll('SELECT * FROM `playerstattoos` WHERE `identifier`=@identifier', {
            ['@identifier'] = args[1]
        }, function(result)
            if result[1] then
                MySQL.Sync.execute('UPDATE playerstattoos SET identifier = @report WHERE identifier = @license', {
                    ['@license'] = args[1],
                    ['@report'] = args[2],
                })
            end
        end)
        -- phone_phones
        MySQL.Async.fetchAll('SELECT * FROM `phone_phones` WHERE `id`=@identifier', {
            ['@identifier'] = args[1]
        }, function(result)
            if result[1] then
                MySQL.Sync.execute('UPDATE phone_phones SET id = @report WHERE id = @license', {
                    ['@license'] = args[1],
                    ['@report'] = args[2],
                })
            end
        end)
        -- owned_vehicles
        MySQL.Async.fetchAll('SELECT * FROM `owned_vehicles` WHERE `owner`=@identifier', {
            ['@identifier'] = args[1]
        }, function(result)
            if result[1] then
                MySQL.Sync.execute('UPDATE owned_vehicles SET owner = @report WHERE owner = @license', {
                    ['@license'] = args[1],
                    ['@report'] = args[2],
                })
            end
        end)
    
        print("Vous avez update "..args[1].." -> "..args[2].." avec succès !")
        -- FIN
    end
end)

-- Delete voiture
RegisterCommand("deleteCar", function(source, args)
    if source == 0 then
        MySQL.Sync.execute('DELETE FROM owned_vehicles WHERE plate=@plate', {
            ['@plate'] = args[1]
        })
        print("Vous avez supprimer le véhicule : "..args[1])
    end
end)

-- giveCar
RegisterCommand('giveCar', function(source, args)
	if source == 0 then
		givevoiture(source, args, 'car', Boutique)
	end
end)

function givevoiture(_source, args, vehicleType, Boutique)
	if _source == 0 then
		local sourceID = args[1]
        local playerName = GetPlayerName(args[1])
        TriggerClientEvent('epicenter:spawnVehicle', sourceID, args[1], args[2], args[3], playerName, 'console', vehicleType)
	end
end

RegisterServerEvent('epicenter:setVehicle')
AddEventHandler('epicenter:setVehicle', function (vehicleProps, Boutique, playerID, vehicleType)
	local _source = playerID
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, state, boutique, stored, type) VALUES (@owner, @plate, @vehicle, @state, @boutique, @stored, @type)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
        ['@state']   = 1,
        ['@boutique'] = Boutique,
		['@stored']  = 1,
		['type'] = vehicleType
	}, function ()
        ESX.GiveCarKey(xPlayer, vehicleProps.plate);
        xPlayer.showNotification("Vous avez reçu un véhicule")
	end)
end)

RegisterServerEvent('epicenter:printToConsole')
AddEventHandler('epicenter:printToConsole', function(msg)
	-- print(msg)
end)


RegisterNetEvent("sAdmin:BringBack")
AddEventHandler("sAdmin:BringBack", function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()

    if id == -1 then
        DropPlayer("Une erreur est servenue !")
        return
    end
    if xGroup ~= "user" then 
        TriggerClientEvent("sAdmin:BringBack", id)
        SendLogsOther("Staff", "OneLife | BringBack", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) à bring back **"..tPlayer.name.."** (***"..tPlayer.identifier.."***)", "https://discord.com/api/webhooks/1310487980024008734/UOuS_v8dUYhITJHgmf7oIaneo8He_6xOGzR377dMUqVyn0ZVYKVgPtPWKLmklfZ2IAIX")
    else 
        TriggerEvent("tF:Protect", source, '(Admin BringBack)')
    end
end)

RegisterCommand("bringback", function(source, args)
    local _source = source 
    local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromId(args[1])
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= "user" then 
        if args[1] ~= nil then
            if GetPlayerName(tonumber(args[1])) ~= nil then
                local id = tonumber(args[1])
                TriggerClientEvent("sAdmin:BringBack", id)
                SendLogsOther("Staff", "OneLife | BringBack", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) à bring back le joueur **"..tPlayer.name.."** (***"..tPlayer.identifier.."***)", "https://discord.com/api/webhooks/1310487980024008734/UOuS_v8dUYhITJHgmf7oIaneo8He_6xOGzR377dMUqVyn0ZVYKVgPtPWKLmklfZ2IAIX")
            end
        end
    end
end, false)


-- local CountPoliceInService = {}
-- local CountEmsInService = {}

-- local function GetCountPoliceInService()
--     return #CountPoliceInService
-- end

-- local function AddCountPoliceInService(source)
--     if (CountPoliceInService[source] == nil) then
--         table.insert(CountPoliceInService, source)
--         updateServiceCount()
--     end
-- end

-- local function RemoveCountPoliceInService(source)
--     if (CountPoliceInService[source] ~= nil) then
--         table.remove(CountPoliceInService, source)
--         updateServiceCount()
--     end
-- end

-- RegisterNetEvent('iZeyy:AddCountPoliceInService')
-- AddEventHandler('iZeyy:AddCountPoliceInService', function(source)
--     AddCountPoliceInService(source)
-- end)

-- RegisterNetEvent('iZeyy:RemoveCountPoliceInService')
-- AddEventHandler('iZeyy:RemoveCountPoliceInService', function(source)
--     RemoveCountPoliceInService(source)
-- end)

-- local function GetCountEmsInService()
--     return #CountEmsInService
-- end

-- local function AddCountEmsInService(source)
--     if (CountEmsInService[source] == nil) then
--         table.insert(CountEmsInService, source)
--         updateServiceCount()
--     end
-- end

-- function RemoveCountEmsInService(source)
--     if (CountEmsInService[source] ~= nil) then
--         table.remove(CountEmsInService, source)
--         updateServiceCount()
--     end
-- end

-- RegisterNetEvent('iZeyy:AddCountEMSInService')
-- AddEventHandler('iZeyy:AddCountEMSInService', function(source)
--     AddCountEmsInService(source)
-- end)

-- RegisterNetEvent('iZeyy:RemoveCountEMSInService')
-- AddEventHandler('iZeyy:RemoveCountEMSInService', function(source)
--     RemoveCountEmsInService(source)
-- end)

-- function updateServiceCount()
--     for src, v in pairs(sAdminSrv.AdminList) do 
--         local LSPD = GetCountPoliceInService()
--         local EMS = GetCountEmsInService()

--         TriggerClientEvent("sAdmin:UpdateCountService", src, LSPD, EMS)
--     end
-- end

-- AddEventHandler("playerDropped", function()
--     local xPlayer = ESX.GetPlayerFromId(source)

--     if (xPlayer) then
--         if (xPlayer.job.name == "ambulance") then
--             RemoveCountEmsInService(xPlayer.source)
--         elseif (xPlayer.job.name == "police") then
--             RemoveCountPoliceInService(xPlayer.source)
--         end

--         if inService[xPlayer.identifier] then
--             inService[xPlayer.identifier] = false
--             --print("delete de la liste en service")
--         end
--     end
-- end)

RegisterNetEvent('iZeyy:teleportToRandomPlayer')
AddEventHandler('iZeyy:teleportToRandomPlayer', function()
    local src = source
    local players = GetPlayers()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    for i = #players, 1, -1 do
        if tonumber(players[i]) == src then
            table.remove(players, i)
        end
    end

    if #players > 0 then
        local randomPlayerId = players[math.random(#players)]
        local targetPed = GetPlayerPed(randomPlayerId)
        local targetCoords = GetEntityCoords(targetPed)
        TriggerClientEvent('iZeyy:performTeleport', src, targetCoords)
    elseif #players < 1 then
        xPlayer.showNotification("Aucun joueurs connecté")
    end
end)

RegisterCommand("getLicenceForWipe", function(source, args, rawCommand)
    local _source = source
    local identifier = nil

    for k,v in ipairs(GetPlayerIdentifiers(_source)) do
        if string.match(v, 'license:') then
            identifier = v
            break
        end
    end

    if identifier then
        -- Transmettre la licence au client qui a demandé
        TriggerClientEvent('receiveLicenceForWipe', _source, identifier)
    end
end, false) -- false pour que cette commande ne soit pas restreinte aux admins

RegisterNetEvent("sAdmin:getInfo", function(playerId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerInfo = sAdmin.PlayersList[playerId]
    TriggerClientEvent("sAdmin:getInfo", _source, playerInfo)
end)
