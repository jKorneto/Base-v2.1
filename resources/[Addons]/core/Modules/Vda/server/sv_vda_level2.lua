local Vda = {
    HasAcces = true,
    Pos = {
        EnterPos = vector3(2319.101562, 2553.302490, 47.690563),
        EnterHeading = 1274.10321044922,
        InteriorPos = vector3(1205.102051, -2268.372559, -47.258827),
        InteriotHeading = 274.96194458008,
        CraftPos = vector3(1205.976685, -2288.094971, -48.999104),
    },
    Weapons = {
        { label = "Poing Américain", name = "weapon_knuckle", price = 4000 },
        { label = "Cran d'arret", name = "weapon_switchblade", price = 8000 },
        { label = "Hache de Combat", name = "weapon_battleaxe", price = 8000 },
        { label = "Pistolet Lourd", name = "weapon_heavypistol", price = 240000 },
        { label = "Calibre 50", name = "weapon_pistol50", price = 250000 },
        { label = "Pistolet Vintage", name = "weapon_vintagepistol", price = 260000 },
        { label = "Mini SMG", name = "weapon_minismg", price = 890000 },
        { label = "AK-Compact", name = "weapon_compactrifle", price = 2720000 },
        { label = "Canon SCIE", name = "weapon_sawnoffshotgun", price = 2100000 } 
    }
}

RegisterNetEvent("core:vda:enter:2", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        if (xPlayer.job.name == "police") then
            return
        end

        local Player = GetPlayerPed(xPlayer.source)
        local PlayerPos = GetEntityCoords(Player)
        local EnterPos = Vda.Pos.EnterPos
        local Distance = #(PlayerPos - EnterPos)

        if (Distance < 15) then
            if (hasAccess(xPlayer.identifier, "vda2")) then
                TriggerClientEvent("core:vda:teleport:2", xPlayer.source, Vda.Pos.InteriorPos, Vda.Pos.InteriotHeading)
            else
                xPlayer.showNotification("Vous n'avez pas accès a cette Zone")
            end 
        else
            xPlayer.showNotification("Vous etes trop loin de la Zone")
        end
    end
end)

RegisterNetEvent("core:vda:hasmenu:2", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        if (xPlayer.job.name == "police") then
            return
        end

        local Player = GetPlayerPed(xPlayer.source)
        local PlayerPos = GetEntityCoords(Player)
        local CraftPos = Vda.Pos.CraftPos
        local Distance = #(PlayerPos - CraftPos)

        if (Distance < 15) then
            if (hasAccess(xPlayer.identifier, "vda2")) then
                TriggerClientEvent("core:vda:openmenu:2", xPlayer.source)
            else
                xPlayer.showNotification("Vous n'avez pas acces a ce Menu")
            end 
        else
            xPlayer.showNotification("Vous etes trop loin de la Zone")
        end
    end
end)

RegisterNetEvent("core:vda:exit:2", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        if (xPlayer.job.name == "police") then
            return
        end

        local Player = GetPlayerPed(xPlayer.source)
        local PlayerPos = GetEntityCoords(Player)
        local ExitPos = Vda.Pos.InteriorPos
        local Distance = #(PlayerPos - ExitPos)

        if (Distance < 15) then
            TriggerClientEvent("core:vda:byeeee:2", xPlayer.source, Vda.Pos.EnterPos, Vda.Pos.EnterHeading)
        else
            xPlayer.showNotification("Vous etes trop loin de la Zone")
        end

    end

end)

RegisterNetEvent("core:vda:craftweapon:2", function(Label, Weapon, Price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer) then

        if (xPlayer.job.name == "police") then
            return
        end

        local Player = GetPlayerPed(xPlayer.source)
        local PlayerPos = GetEntityCoords(Player)
        local CraftPos = Vda.Pos.CraftPos
        local Distance = #(PlayerPos - CraftPos)

        if (Distance < 15) then
            if (hasAccess(xPlayer.identifier, "vda2")) then
            
                local CorrectWeapon = false
                for k, v in pairs(Vda.Weapons) do
                    if Label == v.label and Weapon == v.name and Price == v.price then
                        CorrectWeapon = true
                        break
                    end
                end

                if (CorrectWeapon) then
                    local Price = tonumber(Price)

                    if (xPlayer.getAccount("dirtycash").money >= Price) then
                        if (xPlayer.canCarryItem(string.lower(Weapon), 1)) then
                            xPlayer.removeAccountMoney("dirtycash", Price)
                            xPlayer.showNotification(("Vous avez était dépité (%s$)"):format(Price))
                            TriggerClientEvent("core:vda:craftanim:2", xPlayer.source)
                            SetTimeout(30000, function()
                                xPlayer.addWeapon(Weapon, 1)
                                xPlayer.showNotification(("Vous avez reçu (%s)"):format(Label))
                                CoreSendLogs(
                                    "Vente d'armes Illégal",
                                    "OneLife | VDA",
                                    ("Le joueur **%s** (***%s***) a crée une armes (***%s***) pour **%s$** d'argent sale"):format(
                                        xPlayer.getName(),
                                        xPlayer.getIdentifier(),
                                        Weapon,
                                        Price
                                    ),
                                    Config["Log"]["Other"]["Vda"]
                                )
                            end)
                        else
                            xPlayer.showNotification("Vous n'avez pas assez de place sur vous")
                        end
                    else
                        xPlayer.showNotification("Vous n'avez pas aseez d'argent")
                    end
                end

            end
        else
            xPlayer.showNotification("Vous etes trop loin de la Zone")
        end

    end

end)