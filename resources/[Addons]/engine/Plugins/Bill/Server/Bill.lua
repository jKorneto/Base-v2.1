---@overload fun(): Bill
Bill = Class.new(function(class)

    ---@class Bill: BaseObject
    local self = class;
    local billData = {}

    function self:sendLog(message)
        Engine.Discord:SendMessage("Billing", message)
    end

    function self:openBillMenu(source, price)
        if (type(price) == "number") then
            local xPlayer = ESX.GetPlayerFromId(source)

            if (self:doesBillDataExist(xPlayer.identifier)) then
                local playerMoney = xPlayer.getAccount("cash").money
                local playerBank = xPlayer.getAccount("bank").money

                if (playerMoney >= price or playerBank >= price) then
                    Shared.Events:ToClient(xPlayer.source, Engine["Enums"].Bill.Events.openBill, price, playerMoney, playerBank)
                else
                    billData[xPlayer.identifier].hasAccepted = false
                    Server:showNotification(xPlayer.source, "Vous n'avez pas assez d'argent pour cette facture", false)
                end
            end
		end
    end

    ---@param identifier string
    ---@param source number
    ---@param target number
    ---@param price number
    ---@param reason string
    ---@param billType "society" | "user" | "server"
    ---@param societyName string
    ---@return boolean
    function self:addBillData(identifier, source, target, price, reason, billType, societyName)
        if (not billData[identifier]) then
            billData[identifier] = {
                source = source,
                target = target,
                price = price,
                reason = reason,
                billType = billType,
                societyName = societyName,
                hasAccepted = nil,
                timer = nil
            }

            return true
        end

        return false
    end

    ---@param identifier string
    ---@param paymentType "cash" | "bank"
    function self:buyBill(identifier, paymentType)
        if (self:doesBillDataExist(identifier)) then
            local price = self:getBillData(identifier).price
            local billType = self:getBillData(identifier).billType
            local reason = self:getBillData(identifier).reason

            if (billType == "society") then
                local society = self:getBillData(identifier).societyName
                local societyExist = ESX.DoesSocietyExist(society)
                local xPlayer = ESX.GetPlayerFromId(self:getBillData(identifier).source)
                local xTarget = ESX.GetPlayerFromId(self:getBillData(identifier).target)
                local playerMoney = xTarget.getAccount(paymentType).money

                if (xPlayer and xTarget and societyExist and playerMoney) then
                    if (playerMoney >= tonumber(price)) then
                        xTarget.removeAccountMoney(paymentType, price)
                        ESX.AddSocietyMoney(society, price)
                        Server:showNotification(xTarget.source, "Vous avez payer la facture", false)
                        Server:showNotification(xPlayer.source, "Votre facture a été payer", false)
                        billData[identifier].hasAccepted = true
                        self:sendLog(
                            string.format("Le joueur **%s** ***(%s)*** a payé en **%s** la facture provenant du joueur **%s** ***(%s)*** pour la société **%s** d'une valeur de ***%s $*** pour la raison : **%s**",
                                xTarget.name, 
                                xTarget.identifier, 
                                paymentType, 
                                xPlayer.name, 
                                xPlayer.identifier, 
                                society, 
                                price, 
                                reason
                            )
                        )
                    else
                        billData[identifier].hasAccepted = false
                        Server:showNotification(xTarget.source, "Vous n'avez pas assez d'argent pour cette facture", false)
                    end
                else
                    self:refuseBill(identifier)
                    Shared.Log:Error(("Society (%s) not exist"):format(society))
                end
            elseif (billType == "user") then
                local xPlayer = ESX.GetPlayerFromId(self:getBillData(identifier).source)
                local xTarget = ESX.GetPlayerFromId(self:getBillData(identifier).target)
                local playerMoney = xTarget.getAccount(paymentType).money

                if (xPlayer and xTarget and playerMoney) then
                    if (playerMoney >= tonumber(price)) then
                        xTarget.removeAccountMoney(paymentType, price)
                        xPlayer.addAccountMoney(paymentType, price)
                        Server:showNotification(xTarget.source, "Vous avez payer la facture", false)
                        Server:showNotification(xPlayer.source, "Votre facture a été payer", false)
                        billData[identifier].hasAccepted = true
                        self:sendLog(
                            string.format("Le joueur **%s** ***(%s)*** a payé en **%s** la facture provenant du joueur **%s** ***(%s)*** d'une valeur de ***%s $*** pour la raison: **%s**",
                                xTarget.name, 
                                xTarget.identifier, 
                                paymentType, 
                                xPlayer.name, 
                                xPlayer.identifier, 
                                price, 
                                reason
                            )
                        )
                    else
                        billData[identifier].hasAccepted = false
                        Server:showNotification(xTarget.source, "Vous n'avez pas assez d'argent pour cette facture", false)
                    end
                end
            elseif (billType == "server") then
                local xTarget = ESX.GetPlayerFromId(self:getBillData(identifier).target)
                local playerMoney = xTarget.getAccount(paymentType).money

                if (xTarget and playerMoney) then
                    if (playerMoney >= tonumber(price)) then
                        xTarget.removeAccountMoney(paymentType, price)
                        Server:showNotification(xTarget.source, "Vous avez payer la facture", false)
                        billData[identifier].hasAccepted = true
                        self:sendLog(
                            string.format("Le joueur **%s** ***(%s)*** a payé en **%s** la facture provenant du **Serveur** d'une valeur de ***%s $*** pour la raison: **%s**", 
                                xTarget.name, 
                                xTarget.identifier, 
                                paymentType, 
                                price, 
                                reason
                            )
                        )
                    else
                        billData[identifier].hasAccepted = false
                        Server:showNotification(xTarget.source, "Vous n'avez pas assez d'argent pour cette facture", false)
                    end
                end
            end
        end
    end

    ---@param identifier string
    ---@return boolean
    function self:doesBillDataExist(identifier)
        return billData[identifier] ~= nil
    end

    ---@param identifier string
    ---@return table
    function self:getBillData(identifier)
        return billData[identifier]
    end

    ---@param identifier string
    function self:removeBillData(identifier)
        if (self:doesBillDataExist(identifier)) then
            billData[identifier] = nil
        end
    end

    ---@param identifier string
    ---@return boolean
    function self:hasAccepted(identifier)
        if (self:doesBillDataExist(identifier)) then
            return billData[identifier].hasAccepted
        end

        return nil
    end

    ---@param identifier string
    ---@param paymentType "cash" | "bank"
    function self:acceptBill(identifier, paymentType)
        if (self:doesBillDataExist(identifier)) then
            self:buyBill(identifier, paymentType)

            if (not self:timerHasPassed(identifier)) then
                self:stopTimer(identifier)
            end
        end
    end

    ---@param identifier string
    function self:refuseBill(identifier)
        if (self:doesBillDataExist(identifier)) then
            billData[identifier].hasAccepted = false

            if (not self:timerHasPassed(identifier)) then
                self:stopTimer(identifier)
            end
        end
    end

    ---@param identifier string
    ---@param time number
    function self:createTimer(identifier, time)
        if (self:doesBillDataExist(identifier)) then
            billData[identifier].timer = Shared.Timer(time)
            billData[identifier].timer:Start()
        end
    end

    ---@param identifier string
    ---@return boolean
    function self:timerHasPassed(identifier)
        if (self:doesBillDataExist(identifier)) then
            return billData[identifier].timer:HasPassed()
        end

        return nil
    end

    ---@param identifier string
    function self:stopTimer(identifier)
        if (self:doesBillDataExist(identifier)) then
            billData[identifier].timer:Stop()
        end
    end

    ---@param identifier string
    function self:isBillPending(identifier)
        return self:doesBillDataExist(identifier) and not self:timerHasPassed(identifier)
    end

    ---@param source number
    ---@param target number
    ---@param price number
    ---@param reason string
    ---@param billType "society" | "user" | "server"
    ---@param societyName string
    function self:sendBill(source, target, price, reason, billType, societyName)
        local xPlayer = ESX.GetPlayerFromId(source)
        local xTarget = ESX.GetPlayerFromId(target)

        if (type(xPlayer) == "table" and type(xTarget) == "table") then

            if self:isBillPending(xTarget.identifier) then
                Server:showNotification(xTarget.source, "Une facture est déjà en attente.", false)
                return false
            end

            if (billType == "society") then
                local societyExist = ESX.DoesSocietyExist(societyName)

                if (societyExist) then
                    self:addBillData(xTarget.identifier, 
                        xPlayer.source, 
                        xTarget.source, 
                        price, 
                        reason, 
                        "society", 
                        societyName
                    )
                else
                    Shared.Log:Error(("Society (%s) not exist"):format(societyName))
                end
            elseif (billType == "user") then
                self:addBillData(xTarget.identifier, 
                    xPlayer.source, 
                    xTarget.source, 
                    price, 
                    reason, 
                    "user"
                )
            elseif (billType == "server") then
                self:addBillData(xTarget.identifier, 
                    xPlayer.source, 
                    xTarget.source, 
                    price, 
                    reason, 
                    "server"
                )
            end

            Shared.Events:ToClient(xTarget.source, Engine["Enums"].Bill.Events.receiveBill, true)

            self:openBillMenu(xTarget.source, self:getBillData(xTarget.identifier).price)
            self:createTimer(xTarget.identifier, 10)

            while (self:hasAccepted(xTarget.identifier) == nil and not self:timerHasPassed(xTarget.identifier)) do
                Wait(500)
            end

            Shared.Events:ToClient(xTarget.source, Engine["Enums"].Bill.Events.closeBill)

            local hasAccepted = self:hasAccepted(xTarget.identifier) or false

            self:removeBillData(xTarget.identifier)

            return hasAccepted
        end
    end

    return self
end)