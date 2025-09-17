local bankAccounts = {}
local depotLimit = {}
local withdrawalLimit = {}

CreateThread(function()
    MySQL.Async.fetchAll("SELECT * FROM bank_accounts", {}, function(results)
        if (#results >= 1) then
            for _, account in pairs(results) do
                bankAccounts[account.owner] = {
                    id = account.id,
                    owner = account.owner,
                    level = account.level,
                }
            end
            Shared.Log:Info(("%s comptes bancaire chargés"):format(#results))
        else
            Shared.Log:Info("Aucun compte bancaire trouvé")
        end
    end)
end)

RegisterNetEvent("Core:Bank:CreateAcc", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        local playerPed = GetPlayerPed(xPlayer.source)
        local playerCoords = GetEntityCoords(playerPed)
    
        local distance = #(playerCoords - Config["Bank"]["AccPos"])
    
        if (distance < 15) then
            if (bankAccounts[xPlayer.identifier] == nil) then
                local defaultLevel = 1
        
                MySQL.Async.execute(
                    "INSERT INTO bank_accounts (owner, level) VALUES (@owner, @level)",
                    {
                        ["@owner"] = xPlayer.getIdentifier(),
                        ["@level"] = defaultLevel
                    },
                    function(rowsChanged)
                        if (rowsChanged > 0) then
                            bankAccounts[xPlayer.identifier] = {
                                owner = xPlayer.getIdentifier(),
                                level = defaultLevel
                            }
                            xPlayer.showNotification("Compte bancaire crée avec succès voici votre Carte bancaire")
                            xPlayer.addInventoryItem("cb", 1)
                            CoreSendLogs(
                                "Bank",
                                "OneLife | Bank",
                                ("Le Joueur ***%s*** (***%s***) viens de crée son compte bancaire"):format(
                                    xPlayer.getName(),
                                    xPlayer.getIdentifier()
                                ),
                                Config["Log"]["Other"]["Bank"]
                            )
                        end
                    end
                )            
            else
                xPlayer.showNotification("Vous avez déja un compte bancaire")
            end
        else
            return
        end
    end
end)

RegisterNetEvent("Core:Bank:CheckAcc", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (bankAccounts[xPlayer.identifier] == nil) then
            xPlayer.showNotification("Vous n'avez pas de comptes bancaires, allez à la Banque Centrale pour créer un compte")
        else
            local cash = xPlayer.getAccount("cash").money
            local bank = xPlayer.getAccount("bank").money
            local level = bankAccounts[xPlayer.identifier].level
            local card = xPlayer.getInventoryItem("cb")

            if card and card.quantity > 0 then
                TriggerClientEvent("Core:Bank:HasAcc", xPlayer.source, cash, bank, level, false)
            else
                TriggerClientEvent("Core:Bank:HasAcc", xPlayer.source, cash, bank, level, true)
            end
        end
    end
end)


RegisterNetEvent("Core:Bank:CheckCard", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (bankAccounts[xPlayer.identifier] == nil) then
            xPlayer.showNotification("Vous n'avez pas de comptes bancaire allez a la Banque Central pour crée un compte")
        else
            local HasCb = xPlayer.getInventoryItem("cb")
            if (HasCb) then
                local cash = xPlayer.getAccount("cash").money
                local bank = xPlayer.getAccount("bank").money
                local level = bankAccounts[xPlayer.identifier].level
                TriggerClientEvent("Core:Bank:HasAcc", xPlayer.source, cash, bank, level) 
            else
                xPlayer.showNotification("Vous n'avez pas de carte Bleu sur vous si vous l'avez perdu merci de vous presenter en banque afin de la refaire")
            end
        end
    end
end)

RegisterNetEvent("Core:Bank:AddAccMoney", function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer and xPlayer.getAccount("cash").money >= amount) then

        if (not depotLimit[xPlayer.identifier]) then
            depotLimit[xPlayer.identifier] = 0
        end
    
        local amountLimit = nil

        if (bankAccounts[xPlayer.identifier].level == 1) then
            amountLimit = Config["Bank"]["Limit1"]
        elseif (bankAccounts[xPlayer.identifier].level == 2) then
            amountLimit = Config["Bank"]["Limit2"]
        elseif (bankAccounts[xPlayer.identifier].level == 3) then
            amountLimit = Config["Bank"]["Limit3"]
        end

        local remainingLimit = amountLimit - depotLimit[xPlayer.identifier]
        
        if (amount <= amountLimit) then
            if (depotLimit[xPlayer.identifier] + amount <= amountLimit) then
                depotLimit[xPlayer.identifier] = depotLimit[xPlayer.identifier] + amount
                xPlayer.removeAccountMoney("cash", amount)
                xPlayer.addAccountMoney("bank", amount)
                xPlayer.showNotification(("Vous avez deposé %s$ sur votre solde bancaire"):format(Shared.Math:GroupDigits(amount)))
                CoreSendLogs(
                    "Bank",
                    "OneLife | Bank",
                    ("Le Joueur ***%s*** (***%s***) a deposé de l'argent sur son compte bancaire (***%s***$)"):format(
                        xPlayer.getName(),
                        xPlayer.getIdentifier(),
                        amount
                    ),
                    Config["Log"]["Other"]["Bank"]
                )
            else
                if (remainingLimit <= 0) then
                    xPlayer.showNotification("Vous ne pouvez plus déposer d'argent sur votre compte aujourd'hui")
                else
                    xPlayer.showNotification(("Vous ne pouvez plus déposer que %s$ sur votre compte bancaire aujourd'hui"):format(Shared.Math:GroupDigits(remainingLimit)))
                end
            end    
        else
            xPlayer.showNotification(("Limite quotidienne autorisé %s$"):format(Shared.Math:GroupDigits(amountLimit)))
        end
    else
        xPlayer.showNotification("Vous n'avez pas assez d'argent dans votre compte en espèces")
    end
end)

RegisterNetEvent("Core:Bank:RemoveAccMoney", function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer and xPlayer.getAccount("bank").money >= amount) then
    
        if (not withdrawalLimit[xPlayer.identifier]) then
            withdrawalLimit[xPlayer.identifier] = 0
        end

        local amountLimit = nil

        if (bankAccounts[xPlayer.identifier].level == 1) then
            amountLimit = Config["Bank"]["Limit1"]
        elseif (bankAccounts[xPlayer.identifier].level == 2) then
            amountLimit = Config["Bank"]["Limit2"]
        elseif (bankAccounts[xPlayer.identifier].level == 3) then
            amountLimit = Config["Bank"]["Limit3"]
        end

        local remainingLimit = amountLimit - withdrawalLimit[xPlayer.identifier]

        if (amount <= amountLimit) then
            if (withdrawalLimit[xPlayer.identifier] + amount <= amountLimit) then
                withdrawalLimit[xPlayer.identifier] = withdrawalLimit[xPlayer.identifier] + amount
                xPlayer.removeAccountMoney("bank", amount)
                xPlayer.addAccountMoney("cash", amount)
                xPlayer.showNotification(("Vous avez retiré %s$ de votre compte bancaire"):format(Shared.Math:GroupDigits(amount)))
                CoreSendLogs(
                    "Bank",
                    "OneLife | Bank",
                    ("Le Joueur ***%s*** (***%s***) a retiré de l'argent de son compte bancaire (***%s***$)"):format(
                        xPlayer.getName(),
                        xPlayer.getIdentifier(),
                        amount
                    ),
                    Config["Log"]["Other"]["Bank"]
                )
            else
                if (remainingLimit <= 0) then
                    xPlayer.showNotification("Vous avez atteint votre limite quotidienne de retrait")
                else
                    xPlayer.showNotification(("Vous ne pouvez plus retirer que %s$ aujourd'hui"):format(Shared.Math:GroupDigits(remainingLimit)))
                end
            end    
        else
            xPlayer.showNotification(("Limite quotidienne autorisée %s$"):format(Shared.Math:GroupDigits(amountLimit)))
        end
    else
        xPlayer.showNotification("Vous n'avez pas assez d'argent sur votre compte bancaire")
    end
end)

local function changeAccLevel(xPlayer, newLevel, levelprice)
    if (not xPlayer.identifier or not newLevel) then
        Shared.Log:Error(("Errur avec la mise a jours du compte du joueurs (%s) avec le niveau (%s)"):format(identifier, newLevel))
    end

    if (newLevel == 3) then
        if (not xPlayer.GetVIP()) then
            return xPlayer.showNotification("Vous devez possedez le VIP afin d'avoir ce Niveau")
        end
    end

    MySQL.Async.execute(
        "UPDATE bank_accounts SET level = @newLevel WHERE owner = @identifier",
        {
            ["@newLevel"] = newLevel,
            ["@identifier"] = xPlayer.identifier
        },
        function(rowsChanged)
            if (rowsChanged > 0) then
                bankAccounts[xPlayer.identifier] = {
                    level = newLevel
                }
                xPlayer.removeAccountMoney("bank", levelprice)
                xPlayer.showNotification(("Vous avez changé de niveau de compte votre compte est desormais niveau %s vous avez etait debité de %s$"):format(newLevel, Shared.Math:GroupDigits(levelprice)))
                CoreSendLogs(
                    "Bank",
                    "OneLife | Bank",
                    ("Le Joueur (***%s***) a mit son compte banacaire a jour nouveau niveau de compte (***%s***)"):format(
                        xPlayer.identifier,
                        newLevel
                    ),
                    Config["Log"]["Other"]["Bank"]
                )
            end
        end
    )
end

RegisterNetEvent("Core:Bank:ChangeAccLevel", function(label, desc, subprice, level)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (level ~= bankAccounts[xPlayer.identifier].level) then
            local correctInfo = false

            for k, v in pairs(Config["Bank"]["AccType"]) do
                if label == v.label and desc == v.description and subprice == v.subprice and level == v.level then
                    correctInfo = true
                    break
                end
            end

            if (correctInfo) then

                if (level == 3) then
                    if (not xPlayer.GetVIP()) then
                        return xPlayer.showNotification("Vous devez etre VIP pour acheter cette offre")
                    end
                end

                local Bill = ESX.CreateBill(0, xPlayer.source, subprice, "FleecaBank", "server")
                if Bill then
                    changeAccLevel(xPlayer, level, subprice)
                else
                    xPlayer.showNotification("Vous avez refusé la facture")
                end
            end
        else
            xPlayer.showNotification("Vous possedez déja cette offre")
        end
    end
end)

RegisterNetEvent("Core:Bank:Transfer", function(target, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if (xPlayer) then
        
        if (xTarget == nil or xTarget == -1) then
            xPlayer.showNotification("Destinataire introuvable")
        else
            playerBalance = xPlayer.getAccount("bank").money
            targetBalance = xTarget.getAccount("bank").money

            if (xPlayer.source == xTarget.source) then
                xPlayer.showNotification("Vous ne pouvez pas faire de virement à vous-même")
            else
                if (playerBalance < amount) then
                    xPlayer.showNotification("Vous n'avez pas assez d'argent en Banque")
                else
                    local fee = math.floor(amount * 0.015)
                    local amountAfterFee = amount - fee
                    
                    xPlayer.removeAccountMoney("bank", amount)
                    xTarget.addAccountMoney("bank", amountAfterFee)
                    
                    xPlayer.showNotification(("Virement effectué, vous avez envoyé (%s$), frais de transfert inclus"):format(amount))
                    xTarget.showNotification(("Vous avez reçu un virement de (%s$) après déduction des frais de %s$"):format(amountAfterFee, fee))
                    
                    CoreSendLogs(
                        "Bank",
                        "OneLife | Bank",
                        ("Le joueur %s (***%s***) a fait un virement de (***%s$***) au joueur %s (***%s***), frais de transfert: %s$"):format(
                            xPlayer.getName(),
                            xPlayer.getIdentifier(),
                            amount,
                            xTarget.getName(),
                            xTarget.getIdentifier(),
                            fee
                        ),
                        Config["Log"]["Other"]["Bank"]
                    )
                end
            end
        end
    end
end)


RegisterNetEvent("Core:Bank:BuyCard", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        if (bankAccounts[xPlayer.identifier] ~= nil) then
            local Price = 500
            local Bill = ESX.CreateBill(0, xPlayer.source, Price, "FleecaBank", "server")

            if Bill then
                xPlayer.addInventoryItem("cb", 1)
            end
        end
    end
end)