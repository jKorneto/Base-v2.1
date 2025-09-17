local main_menu = mecanoStorage:Get("craft_menu")

main_menu:IsVisible(function(Items)
    local craftItems = Engine["Config"]["Mecano"]["CraftItems"]

    for i = 1, #craftItems do
        local item = craftItems[i]

        Items:Button(item.label, "L'entreprise prend en charge le coût de l'article", {RightLabel = item.price.." ~g~$~s~",}, true, {
            onSelected = function()
                if (not Client.Mecano:isInCraft()) then
                    amount = Game.ImputText:KeyboardImput("Quantité", {
                        {type = "number", placeholder = "Entrer la quantité", required = true, min = 1, max = 25}
                    })

                    if (Game.ImputText:InputIsValid(tostring(amount[1]), "number")) then
                        Shared.Events:ToServer(Engine["Enums"].Mecano.Events.craftItem, i, tonumber(amount[1]))
                    end
                else
                    Game.Notification:showNotification("Vous êtes déjà en train de fabriquer un produit", false)
                end
            end
        })
    end
end)

Shared.Events:OnNet(Engine["Enums"].Mecano.Events.startCraftAnimation, function(time)
    if (type(time) == "number") then
        local player = Client.Player:GetPed()
        local dict = "weapons@first_person@aim_idle@p_m_zero@light_machine_gun@shared@fidgets@c"
        local anim = "fidget_low_loop"

        Game.Streaming:RequestAnimDict(dict, function()
            TaskPlayAnim(player, dict, anim, 8.0, -8.0, -1, 33, 0, false, false, false)
            Client.Mecano:setInCraft(true)

            HUDProgressBar(nil, time, function()
                ClearPedTasks(player)
                Client.Mecano:setInCraft(false)
                Shared.Events:ToServer(Engine["Enums"].Mecano.Events.receiveCraftItem)
            end)
        end)
    end
end)

CreateThread(function()
    local mecanoCraftZone = Engine["Config"]["Mecano"]["Zones"]

    for k, v in pairs(mecanoCraftZone) do
        local craftZoneCoords = v.craftZone
        local craftZone = Game.Zone("mecanoCraftZone-"..k, {
            job = v.jobName
        })

        craftZone:Start(function()
            craftZone:SetTimer(1000)
            craftZone:SetCoords(craftZoneCoords)

            craftZone:IsPlayerInRadius(5.0, function()
                craftZone:SetTimer(0)
                craftZone:Marker()

                craftZone:IsPlayerInRadius(3.0, function()
                    Game.Notification:ShowHelp("Appuyez sur ~INPUT_CONTEXT~ pour fabriquer des produits")

                    craftZone:KeyPressed("E", function()
                        Client.Mecano:setMenuStyle(v.menuStyle)
                        main_menu:Toggle()
                    end)

                    end, false, false)
            end, false, false)

            craftZone:RadiusEvents(3.0, nil, function()
                main_menu:Close()
            end)
        end)
    end
end)