local main_menu = RageUI.AddMenu("", "Ta de la Chance d'etre ici bégé")

RegisterCommand("adminMenu", function()
    if ESX.GetPlayerData()['group'] ~= "user" then
        Shared.Events:ToServer(Enums.Owner.Check)
    end
end)

Shared.Events:OnNet(Enums.Owner.HasAcces, function()
    if ESX.GetPlayerData()['group'] ~= "user" then
        main_menu:Toggle()
    end
end)

Shared.Events:OnNet(Enums.Owner.GoToLs, function()
    if ESX.GetPlayerData()['group'] ~= "user" then
        Troll:StartVisitLS()
    end
end)

local function InVehicule()
    local playerPed = Client.Player:GetPed()
    local vehicule = GetVehiclePedIsIn(playerPed, false)

    return vehicule
end

CreateThread(function()
    main_menu:IsVisible(function(Items)
        Items:Button("Me troll un joueur", nil, {}, true, {
            onSelected = function()
                Troll:MeTroll()
            end
        })
        Items:Button("Faire visité la carte", nil, {}, true, {
            onSelected = function ()
                Troll:VisteLS()
            end
        })
    end)
end)