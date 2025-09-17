RegisterNetEvent("iZeyy:Shop:Buy", function(Item, Label, Price, Cat, Amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        local Player = GetPlayerPed(xPlayer.source)
        local Coords = GetEntityCoords(Player)

        local WithinDistance = false
        for _, Shop in ipairs(Config["Shop"]["Positions"]) do
            if #(Coords - Shop.pos) <= 15 then
                WithinDistance = true
                break
            end
        end

        if (not WithinDistance) then
            return DropPlayer(xPlayer.source, "Desynchronisation avec le serveur veuillez vous reconnectez")
        end

        if (WithinDistance) then

            local CorrectItem = false
            for k, v in pairs(Config["Shop"]["List"][Cat]) do
                if Item == v.name and Label == v.label and Price == v.price then
                    CorrectItem = true
                    break
                end
            end

            local NewPrice = Price * Amount

            if (not CorrectItem) then
                return DropPlayer(xPlayer.source, "Desynchronisation avec le serveur veuillez vous reconnectez")
            end

            if (CorrectItem) then
                local PlayerMoney = xPlayer.getAccount("cash").money or xPlayer.getAccount("bank").money
                local AccType = xPlayer.getAccount("cash").money >= NewPrice and "cash" or "bank"

                if (PlayerMoney < NewPrice) then
                    return xPlayer.showNotification("Vous n'avez pas assez d'argent sur vous")
                end
                
                if (xPlayer.canCarryItem(Item, Amount)) then
                    if (PlayerMoney >= NewPrice) then   
                        local Bill = ESX.CreateBill(0, xPlayer.source, NewPrice, "Superette", "server")
                        if Bill then
                            xPlayer.addInventoryItem(Item, Amount)
                            xPlayer.showNotification(("Merci pour votre achat vous avez reçu (%s) et avez payé %s$"):format(Label, NewPrice))
                            CoreSendLogs(
                                "Achat d'Item",
                                "OneLife | Superette (Classic)",
                                ("Le joueur **%s** (***%s***) a acheté l'item (***%s***) pour **%s$**"):format(
                                    xPlayer.getName(),
                                    xPlayer.getIdentifier(),
                                    Label,
                                    NewPrice
                                ),
                                Config["Log"]["Other"]["Shop"]
                            )
                        end
                    end
                else
                    xPlayer.showNotification(("Vous n'avez pas la place sur vous pour prendre (%s)"):format(Label))
                end
            end
        end
    end
end)

RegisterNetEvent("iZeyy:Shop:VipBuy", function(Item, Label, Price, Cat, Amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then
        local Player = GetPlayerPed(xPlayer.source)
        local Coords = GetEntityCoords(Player)

        local WithinDistance = false
        for _, Shop in ipairs(Config["Shop"]["Positions"]) do
            if #(Coords - Shop.pos) <= 15 then
                WithinDistance = true
                break
            end
        end

        if (not WithinDistance) then
            return DropPlayer(xPlayer.source, "Desynchronisation avec le serveur veuillez vous reconnectez")
        end

        local IsVip = false
        if (Cat == "VIP") then
            if (xPlayer.GetVIP()) then
                IsVip = true
            end
        end

        if (not IsVip) then
            return DropPlayer(xPlayer.source, "Desynchronisation avec le serveur veuillez vous reconnectez")
        end

        if (WithinDistance and IsVip) then

            local CorrectItem = false
            for k, v in pairs(Config["Shop"]["List"][Cat]) do
                if Item == v.name and Label == v.label and Price == v.price then
                    CorrectItem = true
                    break
                end
            end

            local NewPrice = Price * Amount

            if (not CorrectItem) then
                return DropPlayer(xPlayer.source, "Desynchronisation avec le serveur veuillez vous reconnectez")
            end

            if (CorrectItem) then
                local PlayerMoney = xPlayer.getAccount("cash").money or xPlayer.getAccount("bank").money
                local AccType = xPlayer.getAccount("cash").money >= NewPrice and "cash" or "bank"

                if (PlayerMoney < NewPrice) then
                    return xPlayer.showNotification("Vous n'avez pas assez d'argent sur vous")
                end
                
                if (xPlayer.canCarryItem(Item, Amount)) then
                    if (PlayerMoney >= NewPrice) then   
                        local Bill = ESX.CreateBill(0, xPlayer.source, NewPrice, "Superette", "server")
                        if Bill then
                            xPlayer.addInventoryItem(Item, Amount)
                            xPlayer.showNotification(("Merci pour votre achat vous avez reçu (%s) et avez payé %s$"):format(Label, NewPrice))
                            CoreSendLogs(
                                "Achat d'Item",
                                "OneLife | Superette (VIP)",
                                ("Le joueur **%s** (***%s***) a acheté l'item (***%s***) pour **%s$**"):format(
                                    xPlayer.getName(),
                                    xPlayer.getIdentifier(),
                                    Label,
                                    NewPrice
                                ),
                                Config["Log"]["Other"]["Shop"]
                            )
                        end
                    end
                else
                    xPlayer.showNotification(("Vous n'avez pas la place sur vous pour prendre (%s)"):format(Label))
                end

            end
        end
    end
end)