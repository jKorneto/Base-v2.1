local inUse = false

Shared.Events:OnNet("engine:item:eat", function(itemName, itemLabel, extra)
    if (not inUse) then
        local itemProp = extra.prop
        local itemType = extra.type or "hunger"
        local itemNutritionPourcentage = extra.nutrition or 10
        local itemAnimationDict = extra.animationDict
        local itemAnimation = extra.animation

        if (itemProp == nil) then
            if (itemType == "hunger") then
                itemProp = "prop_cs_burger_01"
            elseif (itemType == "thirst") then
                itemProp = "prop_ld_flow_bottle"
            end
        end

        local player = Client.Player:GetPed()
        local x, y, z = table.unpack(GetEntityCoords(player))
        local prop = CreateObject(GetHashKey(itemProp), x, y, z + 0.2, true, true, true)

        if (itemType == "hunger") then
            if (not itemAnimation) then
                itemAnimationDict = "mp_player_inteat@burger"
                itemAnimation = "mp_player_int_eat_burger_fp"
            end

            AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
            Game.Streaming:RequestAnimDict(itemAnimationDict)
        elseif (itemType == "thirst") then
            if (not itemAnimation) then
                itemAnimationDict = "mp_player_intdrink"
                itemAnimation = "loop_bottle"
            end

            AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 18905), 0.125, -0.035, 0.027, 65.0, 1200.0, 180.0, true, true, false, true, 1, true)
            Game.Streaming:RequestAnimDict(itemAnimationDict)
        end

        local progressText = itemType == "hunger" and "Vous êtes en train de manger.." or "Vous êtes en train de boire.."
        inUse = true

        TaskPlayAnim(player, itemAnimationDict, itemAnimation, 3.0, -8, -1, 49, 0, 0, 0, 0)
        HUDProgressBar(progressText, 5, function()
            TriggerEvent("fowlmas:status:add", itemType, itemNutritionPourcentage * 10000)
            ClearPedTasks(player)
            DeleteEntity(prop)
            inUse = false
        end)
    else
        Game.Notification:showNotification("Vous êtes déjà en train de manger ou de boire", false)
    end
end)