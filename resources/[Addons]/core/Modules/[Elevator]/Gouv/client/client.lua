local main_menu = RageUI.AddMenu("", "Ascenseur")

local ElevatorPos = {
    { pos = vec3(334.614258, -1652.763672, 32.535820 - 1.0), heading = 135.09376525879, label = "Accueil" },
    { pos = vec3(334.614258, -1652.763672, 38.501366 - 1.0), heading = 135.09376525879, label = "Etage #1" },
    { pos = vec3(334.614258, -1652.763672, 47.246220 - 1.0), heading = 135.09376525879, label = "Etage #2" },
    { pos = vec3(334.614258, -1652.763672, 54.596569 - 1.0), heading = 135.09376525879, label = "Etage #3" },
}

local function IsPlayerInZone(targetPos)
    local PlayerPed = Client.Player:GetPed()
    local PlayerCoords = GetEntityCoords(PlayerPed)
    return #(PlayerCoords - targetPos) < 2.0
end

for k, v in pairs(ElevatorPos) do
    local Elevator = Game.Zone("Elevator")
    Elevator:Start(function()
        Elevator:SetTimer(1000)
        Elevator:SetCoords(v.pos)

        Elevator:IsPlayerInRadius(8.0, function()
            Elevator:SetTimer(0)
            Elevator:Marker()

            Elevator:IsPlayerInRadius(2.0, function()
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'ascenseur")
                Elevator:KeyPressed("E", function()
                    main_menu:Toggle()
                end)

            end, false, false)

        end, false, false)

        Elevator:RadiusEvents(2.0, nil, function()
            main_menu:Close()
        end)
    end)
end

main_menu:IsVisible(function(Items)
    local PlayerPed = Client.Player:GetPed()
    local PlayerCoords = GetEntityCoords(PlayerPed)

    for _, v in pairs(ElevatorPos) do
        local InZone = IsPlayerInZone(v.pos)
        local Desc = InZone and "~r~Vous vous situez déjà à cet étage" or nil

        Items:Button(v.label, Desc, {}, not InZone, {
            onSelected = function()
                Elevator:Teleport(PlayerPed, v.pos, v.heading)
                main_menu:Close()
            end
        })
    end
end)
