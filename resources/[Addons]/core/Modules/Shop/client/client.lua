local main_menu = RageUI.AddMenu("", "Articles Disponible")
local food_menu = RageUI.AddSubMenu(main_menu, "", "Articles Disponible")
local drink_menu = RageUI.AddSubMenu(main_menu, "", "Articles Disponible")
local other_menu = RageUI.AddSubMenu(main_menu, "", "Articles Disponible")
local vip_menu = RageUI.AddSubMenu(main_menu, "", "Articles Disponible")

local CatSelected = nil

local function OpenShop(ShopType)

    if (ShopType == "247") then
        main_menu:SetSpriteBanner("commonmenu", "interaction_247")
        main_menu:SetButtonColor(0, 107, 86, 255)
        food_menu:SetSpriteBanner("commonmenu", "interaction_247")
        food_menu:SetButtonColor(0, 107, 86, 255)
        drink_menu:SetSpriteBanner("commonmenu", "interaction_247")
        drink_menu:SetButtonColor(0, 107, 86, 255)
        other_menu:SetSpriteBanner("commonmenu", "interaction_247")
        other_menu:SetButtonColor(0, 107, 86, 255)
        vip_menu:SetSpriteBanner("commonmenu", "interaction_247")
        vip_menu:SetButtonColor(0, 107, 86, 255)
    elseif (ShopType == "ltd") then
        main_menu:SetSpriteBanner("commonmenu", "interaction_ltd")
        main_menu:SetButtonColor(35, 41, 89, 255)
        food_menu:SetSpriteBanner("commonmenu", "interaction_ltd")
        food_menu:SetButtonColor(35, 41, 89, 255)
        drink_menu:SetSpriteBanner("commonmenu", "interaction_ltd")
        drink_menu:SetButtonColor(35, 41, 89, 255)
        other_menu:SetSpriteBanner("commonmenu", "interaction_ltd")
        other_menu:SetButtonColor(35, 41, 89, 255)
        vip_menu:SetSpriteBanner("commonmenu", "interaction_ltd")
        vip_menu:SetButtonColor(35, 41, 89, 255)
    elseif (ShopType == "robs") then
        main_menu:SetSpriteBanner("commonmenu", "interaction_rob_liquor")
        main_menu:SetButtonColor(196, 40, 53, 255)
        food_menu:SetSpriteBanner("commonmenu", "interaction_rob_liquor")
        food_menu:SetButtonColor(196, 40, 53, 255)
        drink_menu:SetSpriteBanner("commonmenu", "interaction_rob_liquor")
        drink_menu:SetButtonColor(196, 40, 53, 255)
        other_menu:SetSpriteBanner("commonmenu", "interaction_rob_liquor")
        other_menu:SetButtonColor(196, 40, 53, 255)
        vip_menu:SetSpriteBanner("commonmenu", "interaction_rob_liquor")
        vip_menu:SetButtonColor(196, 40, 53, 255)
    end

    main_menu:Toggle()

end

CreateThread(function()

    for k, v in pairs(Config["Shop"]["Positions"]) do

        local Blip = AddBlipForCoord(v.pos)
        SetBlipSprite(Blip, 59)
        SetBlipScale(Blip, 0.5)
        SetBlipColour(Blip, 2)
        SetBlipDisplay(Blip, 4)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Superette")
        EndTextCommandSetBlipName(Blip)

        local ShopZone = Game.Zone("ShopZone")

        ShopZone:Start(function()
            ShopZone:SetTimer(1000)
            ShopZone:SetCoords(v.pos)

            ShopZone:IsPlayerInRadius(8.0, function()
                ShopZone:SetTimer(0)
                ShopZone:Marker()

                ShopZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu")
                    ShopZone:KeyPressed("E", function()
                        if (not exports.core:IsServerInBlackout()) then
                            OpenShop(v.type)
                        else
                            ESX.ShowNotification("Nous sommes actuellement fermé en raison de la situation actuelle desolé")
                        end
                    end)

                end, false, false)

            end, false, false)

            ShopZone:RadiusEvents(3.0, nil, function()
                main_menu:Close()
            end)
        end)
    end

    for k, v in pairs(Config["Shop"]["List"]) do
        main_menu:IsVisible(function(Items)
            Items:Button("Nourritures", nil, {}, true, {
                onSelected = function()
                    CatSelected = "Foods"
                end
            }, food_menu)
            Items:Button("Boissons", nil, {}, true, {
                onSelected = function()
                    CatSelected = "Drinks"
                end
            }, drink_menu)
            Items:Button("Autres", nil, {}, true, {
                onSelected = function()
                    CatSelected = "Other"
                end
            }, other_menu)
            local PlayerIsVip = exports["engine"]:isPlayerVip()
            if PlayerIsVip then
                Items:Button("Catégories [~b~VIP~s~]", nil, {}, true, {
                    onSelected = function ()
                        CatSelected = "VIP"
                    end
                }, vip_menu)
            else
                Items:Button("Catégories [~b~VIP~s~]", "Vous devez etre VIP pour accéder a cette Catégorie", {}, false, {})
            end
        end)
    end

    food_menu:IsVisible(function(Items)
        for k, v in pairs(Config["Shop"]["List"][CatSelected]) do
            Items:Button(v.label, nil, { RightLabel = v.price.."~g~$"}, true, {
                onSelected = function()

                    local success, inputs = pcall(function()
                        return lib.inputDialog("Superette", {
                            {type = "number", label = "Combien en voulez vous ?", placeholder = "1"},
                        })
                    end)
            
                    if not success then
                        return
                    elseif inputs == nil then
                        return
                    end
            
                    local amout = inputs[1]

                    if not amout or amout < 1 then
                        return ESX.ShowNotification("Vous devez en acheté minimum 1")
                    end

                    TriggerServerEvent("iZeyy:Shop:Buy", v.name, v.label, v.price, CatSelected, amout)
                    main_menu:Close()

                end
            })
        end
    end)

    drink_menu:IsVisible(function(Items)
        for k, v in pairs(Config["Shop"]["List"][CatSelected]) do
            Items:Button(v.label, nil, { RightLabel = v.price.."~g~$"}, true, {
                onSelected = function()

                    local success, inputs = pcall(function()
                        return lib.inputDialog("Superette", {
                            {type = "number", label = "Combien en voulez vous ?", placeholder = "1"},
                        })
                    end)
            
                    if not success then
                        return
                    elseif inputs == nil then
                        return
                    end
            
                    local amout = inputs[1]

                    if not amout or amout < 1 then
                        return ESX.ShowNotification("Vous devez en acheté minimum 1")
                    end

                    TriggerServerEvent("iZeyy:Shop:Buy", v.name, v.label, v.price, CatSelected, amout)
                    main_menu:Close()

                end
            })
        end
    end)

    other_menu:IsVisible(function(Items)
        for k, v in pairs(Config["Shop"]["List"][CatSelected]) do
            Items:Button(v.label, nil, { RightLabel = v.price.."~g~$"}, true, {
                onSelected = function()

                    local success, inputs = pcall(function()
                        return lib.inputDialog("Superette", {
                            {type = "number", label = "Combien en voulez vous ?", placeholder = "1"},
                        })
                    end)
            
                    if not success then
                        return
                    elseif inputs == nil then
                        return
                    end
            
                    local amout = inputs[1]

                    if not amout or amout < 1 then
                        return ESX.ShowNotification("Vous devez en acheté minimum 1")
                    end

                    TriggerServerEvent("iZeyy:Shop:Buy", v.name, v.label, v.price, CatSelected, amout)
                    main_menu:Close()

                end
            })
        end
    end)

    vip_menu:IsVisible(function(Items)
        for k, v in pairs(Config["Shop"]["List"][CatSelected]) do
            Items:Button(v.label, nil, { RightLabel = v.price.."~g~$"}, true, {
                onSelected = function()

                    local success, inputs = pcall(function()
                        return lib.inputDialog("Superette", {
                            {type = "number", label = "Combien en voulez vous ?", placeholder = "1"},
                        })
                    end)
            
                    if not success then
                        return
                    elseif inputs == nil then
                        return
                    end
            
                    local amout = inputs[1]

                    if not amout or amout < 1 then
                        return ESX.ShowNotification("Vous devez en acheté minimum 1")
                    end

                    TriggerServerEvent("iZeyy:Shop:VipBuy", v.name, v.label, v.price, CatSelected, amout)
                    main_menu:Close()
                    
                end
            })
        end
    end)

end)