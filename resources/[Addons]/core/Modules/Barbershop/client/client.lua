-- local main_menu = RageUI.AddMenu("", "Salon de Coiffure")
-- local hair_menu = RageUI.AddSubMenu(main_menu, "", "Cheveux")
-- local beard_menu = RageUI.AddSubMenu(main_menu, "", "Barbe")

-- local defaultSkin = {}
-- local mincolorIndex1, colorIndex1 = 1, 1;
-- local mincolorIndex2, colorIndex2 = 1, 1;

-- local function OpenBarber(Type)

--     if (Type == "bobmulet") then
--         main_menu:SetSpriteBanner("commonmenu", "interaction_bob_mulet")
--         main_menu:SetButtonColor(113, 58, 58, 255)
--         hair_menu:SetSpriteBanner("commonmenu", "interaction_bob_mulet")
--         hair_menu:SetButtonColor(113, 58, 58, 255)
--         beard_menu:SetSpriteBanner("commonmenu", "interaction_bob_mulet")
--         beard_menu:SetButtonColor(113, 58, 58, 255)
--     elseif (Type == "hairhawk") then
--         main_menu:SetSpriteBanner("commonmenu", "interaction_hair_on_hawk")
--         main_menu:SetButtonColor(36, 36, 36, 255)
--         hair_menu:SetSpriteBanner("commonmenu", "interaction_hair_on_hawk")
--         hair_menu:SetButtonColor(36, 36, 36, 255)
--         beard_menu:SetSpriteBanner("commonmenu", "interaction_hair_on_hawk")
--         beard_menu:SetButtonColor(36, 36, 36, 255)
--     elseif (Type == "oheasbarber") then
--         main_menu:SetSpriteBanner("commonmenu", "interaction_osheas_barber")
--         main_menu:SetButtonColor(127, 60, 53, 255)
--         hair_menu:SetSpriteBanner("commonmenu", "interaction_osheas_barber")
--         hair_menu:SetButtonColor(127, 60, 53, 255)
--         beard_menu:SetSpriteBanner("commonmenu", "interaction_osheas_barber")
--         beard_menu:SetButtonColor(127, 60, 53, 255)
--     end

--     requestBarberInfo()
--     main_menu:Toggle()
--     createHeadCamera()
--     FreezeEntityPosition(Client.Player:GetPed(), true)
-- end

-- CreateThread(function()
--     for k, v in pairs(Config["Barber"]["Positions"]) do
--         local Blip = AddBlipForCoord(v.pos)
--         SetBlipSprite(Blip, 71)
--         SetBlipScale(Blip, 0.5)
--         SetBlipColour(Blip, 17)
--         SetBlipDisplay(Blip, 4)
--         SetBlipAsShortRange(Blip, true)
--         BeginTextCommandSetBlipName("STRING")
--         AddTextComponentString("Salon de Coiffure")
--         EndTextCommandSetBlipName(Blip)

--         local BarberZone = Game.Zone("BarberZone")

--         BarberZone:Start(function()
--             BarberZone:SetTimer(1000)
--             BarberZone:SetCoords(v.pos)

--             BarberZone:IsPlayerInRadius(8.0, function()
--                 BarberZone:SetTimer(0)
--                 BarberZone:Marker()

--                 BarberZone:IsPlayerInRadius(3.0, function()
--                     ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour changer de coupe")
--                     BarberZone:KeyPressed("E", function()
--                         OpenBarber(v.type)
--                     end)

--                 end, false, false)

--             end, false, false)

--             BarberZone:RadiusEvents(3.0, nil, function()
--                 main_menu:Close()
--             end)
--         end)
--     end

--     main_menu:IsVisible(function(Items)
--         Items:Button("Cheveux", nil, {}, true, {}, hair_menu)
--         Items:Button("Barbe", nil, {}, true, {}, beard_menu)
--     end, nil, function()
--         local PlayerPed = Client.Player:GetPed()
--         FreezeEntityPosition(PlayerPed, false)
--         destroyHeadCamera()
--     end)

--     hair_menu:IsVisible(function(Items)

--         for i = 0, Config["Barber"]["MaxHairNumber"] do 
--             Items:Button("Cheveux #" .. i, nil, {}, true, {
--                 onActive = function()
--                     SetPedComponentVariation(Client.Player:GetPed(), 2, i)
--                 end,
--                 onSelected = function()
--                     TriggerServerEvent("iZeyy:Barber:Buy", "hair_1", i, colorIndex1, colorIndex2)
--                     TriggerEvent('skinchanger:getSkin', function(skin)
--                         TriggerServerEvent('esx_skin:save', skin)
--                     end)
--                 end
--             })
--         end

--     end, function(Panels)
--         Panels:ColourPanel("Couleur de Cheveux", RageUI.PanelColour.HairCut, mincolorIndex1, colorIndex1, {
--             onColorChange = function(MinimumIndex, CurrentIndex)
--                 SetPedHairColor(Client.Player:GetPed(), CurrentIndex, colorIndex2)
--                 mincolorIndex1 = MinimumIndex
--                 colorIndex1 = CurrentIndex
--             end
--         }, 3, {
--             RightLabel = "Test",
--             RightBadge = RageUI.BadgeStyle.Alert,
--             Color = {
--                 BackgroundColor = { 0, 0, 0, 255 },
--                 HightLightColor = { 255, 255, 255, 255 },
--             },
--             LeftBadge = RageUI.BadgeStyle.Alert
--         })

--         Panels:ColourPanel("Meche de Cheveux", RageUI.PanelColour.HairCut, mincolorIndex2, colorIndex2, {
--             onColorChange = function(MinimumIndex, CurrentIndex)
--                 SetPedHairColor(Client.Player:GetPed(), colorIndex1, CurrentIndex)
--                 mincolorIndex2 = MinimumIndex
--                 colorIndex2 = CurrentIndex
--             end
--         }, 3, {
--             RightLabel = "Test",
--             RightBadge = RageUI.BadgeStyle.Alert,
--             Color = {
--                 BackgroundColor = { 0, 0, 0, 255 },
--                 HightLightColor = { 255, 255, 255, 255 },
--             },
--             LeftBadge = RageUI.BadgeStyle.Alert
--         })
--     end, function()
--         barberSetComponent('hair_1', lastBarberSkin["hair_1"])
--         barberSetComponent('hair_2', lastBarberSkin["hair_2"])
--         barberSetComponent('hair_color_1', lastBarberSkin["hair_color_1"])
--         barberSetComponent('hair_color_2', lastBarberSkin["hair_color_2"])
--         barberSetComponent('beard_1', lastBarberSkin["beard_1"])
--         barberSetComponent('beard_2', lastBarberSkin["beard_2"])
--     end)

-- end)

-- RegisterNetEvent("iZeyy:Barber:Save", function(headtype, components, color1, color2)
--     --lastBarberSkin[headtype] = components
--     -- barberSetComponent(headtype, components)
--     -- SetPedHairColor(Client.Player:GetPed(), color1, color2)
-- end)