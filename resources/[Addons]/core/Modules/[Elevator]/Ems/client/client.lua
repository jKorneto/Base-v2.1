local main_menu = RageUI.AddMenu("", "Ascenseur")

local ElevatorPos = {
    { pos = vec3(360.243500, -1410.649780, 32.429218 - 1.0), heading = 153.89114379883, label = "Accueil" },
    { pos = vec3(334.372681, -1432.784302, 46.513111 - 1.0), heading = 143.50091552734, label = "Hélipad" },
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
