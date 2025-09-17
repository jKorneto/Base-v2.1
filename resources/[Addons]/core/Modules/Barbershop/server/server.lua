-- RegisterNetEvent("iZeyy:Barber:Buy", function(headtype, components, color1, color2)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     if (xPlayer) then
--         local Player = GetPlayerPed(xPlayer.source)
--         local Coords = GetEntityCoords(Player)

--         local WithinDistance = false
--         for _, Barber in ipairs(Config["Barber"]["Positions"]) do
--             if #(Coords - Barber.pos) <= 15 then
--                 WithinDistance = true
--                 break
--             end
--         end

--         if (WithinDistance) then
--             local Price = nil
--             if (headtype == "hair_1") then
--                 Price = 100
--             elseif (headtype == "beard") then
--                 Price = 75
--             end

--             local PlayerMoney = xPlayer.getAccount("cash").money or xPlayer.getAccount("bank").money
--             local AccType = xPlayer.getAccount("cash").money >= Price and "cash" or "bank"

--             if (PlayerMoney < Price) then
--                 return xPlayer.showNotification("Vous n'avez pas assez d'argent sur vous")
--             end
            
--             if (PlayerMoney >= Price) then
--                 local Bill = ESX.CreateBill(0, xPlayer.source, Price, "Superette", "server")
--                 if Bill then
--                     xPlayer.removeAccountMoney(AccType, Price)
--                     TriggerClientEvent("iZeyy:Barber:Save", xPlayer.source, headtype, components, color1, color2)
--                 end
--             end
--         end
--     end

-- end)