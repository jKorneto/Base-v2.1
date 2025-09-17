RegisterNetEvent('OneLife:Society:AddMoney')
AddEventHandler('OneLife:Society:AddMoney', function(societyName, amount, accountType)
    local xPlayer = ESX.GetPlayerFromId(source)
    local society = MOD_Society:getSocietyByName(societyName)

    local local_date = os.date('%H:%M:%S', os.time())

    if (society) then
        if (society:IsPlayerBoss(xPlayer)) then
            local playerAccount = xPlayer.getAccount(accountType)

            if (playerAccount) then
                if (playerAccount.money >= amount) then
                    xPlayer.removeAccountMoney(playerAccount.name, amount)

                    if (accountType == "cash") then
                        society:AddMoney(amount)
                        society:UpdateBossEvent("OneLife:Society:ReceiveMoney", society:GetMoney())
                        
                        society:SendLogsDiscord(local_date, OneLife.enums.Society.Zones[society.name].logs.money, {
                            {
                                ["title"] = "**Dépot d'argent :**",
                                ["fields"] = {
                                    { name = "- Employé :", value = xPlayer.getFirstName().." "..xPlayer.getLastName().." ["..xPlayer.source.."] ["..xPlayer.identifier.."]" },
                                    { name = "- Montant déposé :", value = amount.." $" },
                                    { name = "- Entreprise :", value = society.label },
                                },
                                ["type"]  = "rich",
                                ["color"] = 1000849,
                                ["footer"] =  {
                                  ["text"]= "Powered for OneLife ©   |  "..local_date.."",
                                  ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
                                },
                            }
                        })
                    elseif (accountType == "dirty_cash") then
                        society:AddDirtyMoney(amount)
                        society:UpdateBossEvent("OneLife:Society:ReceiveDirtyMoney", society:GetDirtyMoney())
                        
                        society:SendLogsDiscord(local_date, OneLife.enums.Society.Zones[society.name].logs.money, {
                            {
                                ["title"] = "**Dépot d'argent [SALE]:**",
                                ["fields"] = {
                                    { name = "- Employé :", value = xPlayer.getFirstName().." "..xPlayer.getLastName().." ["..xPlayer.source.."] ["..xPlayer.identifier.."]" },
                                    { name = "- Montant déposé :", value = amount.." $" },
                                    { name = "- Entreprise :", value = society.label },
                                },
                                ["type"]  = "rich",
                                ["color"] = 1000849,
                                ["footer"] =  {
                                  ["text"]= "Powered for OneLife ©   |  "..local_date.."",
                                  ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
                                },
                            }
                        })
                    end
                else
                    xPlayer.showNotification("~s~Vous n'avez pas assez d'argent");
                end
            else
                xPlayer.showNotification("~s~Une erreur est survenue~s~, Event du Code erreur: ~s~ 'OneLife:Society:AddMoney'")
            end
        else
            DropPlayer(xPlayer.source, "[core_nui] Trying to get money from society storage")
        end
    end

end)