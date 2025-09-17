local main_menu = RageUI.AddMenu("", "Ascenseur")

local ElevatorPos = {
    { pos = vec3(67.585564, -364.682312, 41.331150 - 1.0), heading = 160.78915405273, label = "Sous-Sol" },
    { pos = vec3(69.995323, -387.850769, 48.518990 - 1.0), heading = 254.34762573242, label = "Accueil" },
    { pos = vec3(83.279648, -388.191528, 85.336533 - 1.0), heading = 164.92539978027, label = "Hélipad" },
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
