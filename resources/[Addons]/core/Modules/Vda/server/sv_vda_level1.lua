local Vda = {
    HasAcces = true,
    Pos = {
        EnterPos = vector3(3725.329346, 4525.234863, 22.470528),
        EnterHeading = 181.16996765137,
        InteriorPos = vector3(576.167542, -410.377350, -69.647079),
        InteriotHeading = 88.800132751465,
        CraftPos = vector3(560.547729, -405.232880, -69.647011),
    },
    Weapons = {
        { label = "Poing Américain", name = "weapon_knuckle", price = 4000 },
        { label = "Cran d'arret", name = "weapon_switchblade", price = 8000 },
        { label = "Hache de Combat", name = "weapon_battleaxe", price = 8000 },
        { label = "Pétoire", name = "weapon_snspistol", price = 170000 },
        { label = "Pistolet", name = "weapon_pistol", price = 220000 },
        { label = "Pistolet Céramic", name = "weapon_ceramicpistol", price = 230000 },
        { label = "Micro SMG", name = "weapon_microsmg", price = 950000 },
        { label = "Tech-9", name = "weapon_machinepistol", price = 1700000 },
        { label = "Canon SCIE", name = "weapon_sawnoffshotgun", price = 2100000 }
    }
}

RegisterNetEvent("core:vda:enter:1", function()
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
            if (hasAccess(xPlayer.identifier, "vda1")) then
                TriggerClientEvent("core:vda:teleport:1", xPlayer.source, Vda.Pos.InteriorPos, Vda.Pos.InteriotHeading)
            else
                xPlayer.showNotification("Vous n'avez pas accès a cette Zone")
            end 
        else
            xPlayer.showNotification("Vous etes trop loin de la Zone")
        end
    end
end)

RegisterNetEvent("core:vda:hasmenu:1", function()
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
            if (hasAccess(xPlayer.identifier, "vda1")) then
                TriggerClientEvent("core:vda:openmenu:1", xPlayer.source)
            else
                xPlayer.showNotification("Vous n'avez pas acces a ce Menu")
            end 
        else
            xPlayer.showNotification("Vous etes trop loin de la Zone")
        end
    end
end)

RegisterNetEvent("core:vda:exit:1", function()
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
            TriggerClientEvent("core:vda:byeeee:1", xPlayer.source, Vda.Pos.EnterPos, Vda.Pos.EnterHeading)
        else
            xPlayer.showNotification("Vous etes trop loin de la Zone")
        end

    end

end)

RegisterNetEvent("core:vda:craftweapon:1", function(Label, Weapon, Price)
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
            if (hasAccess(xPlayer.identifier, "vda1")) then
            
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
                            TriggerClientEvent("core:vda:craftanim:1", xPlayer.source)
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