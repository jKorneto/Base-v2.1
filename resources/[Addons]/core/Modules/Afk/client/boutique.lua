-- local main_menu = RageUI.AddMenu("", "Boutique Afk")
-- local Coins = 0

-- CreateThread(function()

--     Game.Blip("BoutiqueAfk",
--     {
--         coords = Config["Afk"]["PedPos"],
--         label = "Boutique Afk",
--         sprite = 490,
--         color = 5,
--         scale = 0.5,
--     })

--     local BoutiqueAfk = Game.Zone("BoutiqueAfk")

--     BoutiqueAfk:Start(function()
--         BoutiqueAfk:SetTimer(1000)
--         BoutiqueAfk:SetCoords(Config["Afk"]["PedPos"]) 

--         BoutiqueAfk:IsPlayerInRadius(4.0, function()
--             BoutiqueAfk:SetTimer(0)
--             ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder à la boutique")

--             BoutiqueAfk:IsPlayerInRadius(4.0, function()
--                 BoutiqueAfk:KeyPressed("E", function()
--                     if not IsPedInAnyVehicle(PlayerPedId(), false) then
--                         TriggerServerEvent("iZeyy:Afk:GetCoins")
--                     else
--                         ESX.ShowNotification("Vous ne pouvez pas accéder à la boutique en voiture")
--                     end
--                 end)
--             end)
--         end)
--     end)

--     main_menu:IsVisible(function(Items)
--         Items:Separator("Bienvenue dans la boutique AFK vous avez (~b~" .. Coins .. "~s~) jetons")
--         Items:Button("Entrer en Afk", "Vous pouvez entrer en mode AFK pour gagner des jetons ou utiliser la commande /afk dans toute les ZoneSafe", {}, true, {
--             onSelected = function()
--                 TriggerServerEvent("iZeyy:Afk:State", true)
--                 main_menu:Close()
--             end
--         })
--         Items:Line()
--         for k, v in pairs(Config["Afk"]["Items"]) do
--             Items:Button(v.label, nil, { RightLabel = v.price .. " Jetons"}, true, {
--                 onSelected = function()
--                     TriggerServerEvent("iZeyy:Afk:BuyItem", v.name, v.label, v.price, v.type)
--                 end
--             })
--         end
--     end)
-- end)

-- RegisterNetEvent("iZeyy:Afk:GetCoins", function(coins)
--     Coins = coins
--     main_menu:Toggle()
-- end)