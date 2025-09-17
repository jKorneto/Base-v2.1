local sellMenu = HeistStorage:Get("sell_menu")

Shared.Events:OnNet(Engine["Enums"].Heist.Events.startHouseZone, function(category, position, hasSleepingPed)
    if (houseData == nil) then
        if (type(position) == "vector3") then
            Client.Heist:setHouseCategory(category)
            Client.Heist:setHousePosition(position)
            Client.Heist:startHouseEnterZone()
            Client.Heist:setHasSleepingPed(hasSleepingPed or false)
        end
    end
end)

Shared.Events:OnNet(Engine["Enums"].Heist.Events.receiveItem, function(index)
    if (type(index) == "number") then
        local houseItems = Engine["Config"]["Heist"]["HouseReward"][Client.Heist:getHouseCategory()]

        if (houseItems) then
            local item = houseItems[index]

            if (item) then
                local itemName = item.item
                local itemLabel = item.label

                TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_KNEEL", 0, true)

                HUDProgressBar("Vous récupérez "..itemLabel, 5, function()
                    Client.Player:ClearTasks(true)
                    Client.Heist:deleteItemsBlip(index)
                    Client.Heist:deleteHouseItemZone(index)
                    Client.Heist:setInTakeItem(false)
                    Client.Heist:addItemCount()
                end)
            end
        end
    end
end)

Shared.Events:OnNet(Engine["Enums"].Heist.Events.sendHousePosition, function(position)
    if (type(position) == "vector3") then
        Client.Heist:makeAlertPolice(position)
    end
end)

Shared.Events:OnNet(Engine["Enums"].Heist.Events.successHouseHeist, function()
    Client.Heist:resetItemCount()
    Client.Heist:resetGlobalHouseTimer()
    Client.Heist:stopHouseResellZone()
    Client.Heist:deleteResellBlip()
    Client.Heist:deleteResellPed()
end)
