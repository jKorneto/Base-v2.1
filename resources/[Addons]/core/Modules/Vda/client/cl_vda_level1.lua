local MainMenu = RageUI.AddMenu("", "Vente d'armes illégal")

local Vda = {
    Timeout = false,
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

CreateThread(function()

    local VdaEnter = Game.Zone("VdaEnter")

    VdaEnter:Start(function()
        VdaEnter:SetTimer(1000)
        VdaEnter:SetCoords(Vda.Pos.EnterPos)

        VdaEnter:IsPlayerInRadius(2.5, function()
            VdaEnter:SetTimer(0)
            VdaEnter:Marker()
            local job = Client.Player:GetJob()

            if job ~= "police" then 
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

                VdaEnter:IsPlayerInRadius(2.5, function()
                    VdaEnter:KeyPressed("E", function()
                        TriggerServerEvent("core:vda:enter:1")
                    end)
                end)
            end
        end)
    end)

    local VdaCraft = Game.Zone("VdaCraft")

    VdaCraft:Start(function()
        VdaCraft:SetTimer(1000)
        VdaCraft:SetCoords(Vda.Pos.CraftPos)

        VdaCraft:IsPlayerInRadius(3.5, function()
            VdaCraft:SetTimer(0)
            local job = Client.Player:GetJob()

            if job ~= "police" then 
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

                VdaCraft:IsPlayerInRadius(3.5, function()
                    VdaCraft:KeyPressed("E", function()
                        TriggerServerEvent("core:vda:hasmenu:1")
                    end)
                end)
            end
        end)
    end)

    local VdaExit = Game.Zone("VdaExit")

    VdaExit:Start(function()
        VdaExit:SetTimer(1000)
        VdaExit:SetCoords(Vda.Pos.InteriorPos)

        VdaExit:IsPlayerInRadius(3.5, function()
            VdaExit:SetTimer(0)
            local job = Client.Player:GetJob()

            if job ~= "police" then 
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")

                VdaExit:IsPlayerInRadius(3.5, function()
                    VdaExit:KeyPressed("E", function()
                        TriggerServerEvent("core:vda:exit:1")
                    end)
                end)
            end
        end)
    end)
        
    MainMenu:IsVisible(function(Items)
        for k, v in pairs(Vda.Weapons) do
            Items:Button(v.label, nil, { RightLabel = (Shared.Math:GroupDigits(v.price .. "~g~$")) }, not Vda.Timeout, {
                onSelected = function()
                    TriggerServerEvent("core:vda:craftweapon:1", v.label, v.name, v.price)
                end
            })
        end
    end)

end)

RegisterNetEvent("core:vda:teleport:1", function(Coords, Heading)
    local Player = Client.Player:GetPed()
    Elevator:Teleport(Player, Coords, Heading)
    Vda.HasAcces = true
end)

RegisterNetEvent("core:vda:openmenu:1", function()
    if (Vda.HasAcces) then
        MainMenu:Toggle()
    else
        ESX.ShowNotification("Veuillez sortir de la zone et re rentré")
    end
end)

RegisterNetEvent("core:vda:byeeee:1", function(Coords, Heading)
    local Player = Client.Player:GetPed()
    Elevator:Teleport(Player, Coords, Heading)
    Vda.HasAcces = false    
end)

local function SetClosable(boolean)
    MainMenu:SetClosable(boolean)
end

RegisterNetEvent("core:vda:craftanim:1", function()
    Game.Streaming:RequestAnimDict("weapons@first_person@aim_idle@p_m_zero@light_machine_gun@shared@fidgets@c", function()
        Vda.Timeout = true
        SetClosable(false)
        SetTimeout(30000, function()
            Vda.Timeout = false
            SetClosable(true)
            ClearPedTasksImmediately(Client.Player:GetPed())
        end)
        TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_idle@p_m_zero@light_machine_gun@shared@fidgets@c", "fidget_low_loop", 8.0, -8.0, -1, 33, 0, false, false, false)
        HUDProgressBar("Armes en cours de production...", 30, function() end)
    end)
end)