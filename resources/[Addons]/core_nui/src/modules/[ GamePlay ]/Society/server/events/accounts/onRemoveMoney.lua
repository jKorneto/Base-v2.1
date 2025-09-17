RegisterNetEvent('OneLife:Society:RemoveMoney')
AddEventHandler('OneLife:Society:RemoveMoney', function(societyName, amount, accountType)
    local xPlayer = ESX.GetPlayerFromId(source)
    local society = MOD_Society:getSocietyByName(societyName)

    local local_date = os.date('%H:%M:%S', os.time())

    if (society) then
        if (society:IsPlayerBoss(xPlayer)) then
            local playerAccount = xPlayer.getAccount(accountType)

            if (playerAccount) then

                local societyMoney = accountType == "cash" and society:GetMoney() or accountType == "dirty_cash" and society:GetDirtyMoney() or 0

                if (societyMoney - amount >= 0) then
                    xPlayer.addAccountMoney(playerAccount.name, amount)

                    if (accountType == "cash") then
                        society:RemoveMoney(amount)
                        society:UpdateBossEvent("OneLife:Society:ReceiveMoney", society:GetMoney())
                        
                        society:SendLogsDiscord(local_date, OneLife.enums.Society.Zones[society.name].logs.money, {
                            {
                                ["title"] = "**Retrait Argent :**",
                                ["fields"] = {
                                    { name = "- Employé :", value = xPlayer.getFirstName().." "..xPlayer.getLastName().." ["..xPlayer.source.."] ["..xPlayer.identifier.."]" },
                                    { name = "- Montant retiré :", value = amount.." $" },
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
                        society:RemoveDirtyMoney(amount)
                        society:UpdateBossEvent("OneLife:Society:ReceiveDirtyMoney", society:GetDirtyMoney())
                        
                        society:SendLogsDiscord(local_date, OneLife.enums.Society.Zones[society.name].logs.linkAddMoney, {
                            {
                                ["title"] = "**Retrait Argent [SALE]:**",
                                ["fields"] = {
                                    { name = "- Employé :", value = xPlayer.getFirstName().." "..xPlayer.getLastName().." ["..xPlayer.source.."] ["..xPlayer.identifier.."]" },
                                    { name = "- Montant retiré :", value = amount.." $" },
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
                    xPlayer.showNotification("~s~Votre société n'a pas assez d'argent")
                end
            else
                xPlayer.showNotification("~s~Une erreur est survenue~s~, Event du Code erreur: ~s~ 'OneLife:Society:AddMoney'")
            end
        else
            DropPlayer(xPlayer.source, "[core_nui] Trying to get money from society storage")
        end
    end

end)