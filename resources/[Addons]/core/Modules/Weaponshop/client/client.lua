local catSelected = ""

local main_menu = RageUI.AddMenu("", "Ammun Nation")
local sub_menu = RageUI.AddSubMenu(main_menu, "", "Ammun Nation")

local hasPpa = false

RegisterNetEvent(Enums.Weaponshop.ReceiveInfo, function(ppaInfo)
    hasPpa = ppaInfo
    main_menu:Toggle()
end)

CreateThread(function()

    main_menu:SetSpriteBanner("commonmenu", "interaction_ammunation")
    main_menu:SetButtonColor(198, 35, 32, 255)
    sub_menu:SetSpriteBanner("commonmenu", "interaction_ammunation")
    sub_menu:SetButtonColor(198, 35, 32, 255)

    for k, v in pairs(Config["Weaponshop"]["Pos"]) do

        Game.Blip("WeaponShop#"..k,
        {
            coords = v,
            label = "Armurerie",
            sprite = 110,
            color = 1,
            scale = 0.5,
        })

        local WeaponshopZone = Game.Zone("WeaponshopZone")

        WeaponshopZone:Start(function()

            WeaponshopZone:SetTimer(1000)
            WeaponshopZone:SetCoords(v)

            WeaponshopZone:IsPlayerInRadius(8.0, function()
                WeaponshopZone:SetTimer(0)
                WeaponshopZone:Marker()

                WeaponshopZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu")
                    WeaponshopZone:KeyPressed("E", function()
                        TriggerServerEvent(Enums.Weaponshop.RequestPPA)
                    end)

                end, false, false)

            end, false, false)

            WeaponshopZone:RadiusEvents(3.0, nil, function()
                main_menu:Close()
            end)
        end)
        
    end

    main_menu:IsVisible(function(Items)
        local ppaPrice = Config["Weaponshop"]["PPAPrice"]

        Items:Button("Achetez le PPA", hasPpa and "~r~Vous possedez déja le PPA", {RightLabel = Shared.Math:GroupDigits(ppaPrice).."~g~$~s~"}, not hasPpa, {
            onSelected = function()
                if (hasPpa == false) then
                    TriggerServerEvent(Enums.Weaponshop.BuyPPALicense)
                else
                    ESX.ShowNotification("Vous possedez déja le PPA")
                end
            end
        })

        Items:Button("Armes Blanche", nil, {}, true, {
            onSelected = function()
                catSelected = "White"
            end
        }, sub_menu)

        Items:Button("Armes Letale", nil, {}, true, {
            onSelected = function()
                catSelected = "Letale"
            end
        }, sub_menu)

        Items:Button("Accèsoire d'arme", nil, {}, true, {
            onSelected = function()
                catSelected = "Accessories"
            end
        }, sub_menu)

        local isVip = exports["engine"]:isPlayerVip()
        Items:Button("[~b~VIP~s~] Armes VIP", not isVip and "~r~Cette catégorie est reservé au VIP", {}, isVip, {
            onSelected = function()
                catSelected = "VIP"
            end
        }, sub_menu)

        Items:Button("Munitions", nil, {}, true, {
            onSelected = function()
                catSelected = "Munitions"
            end
        }, sub_menu)

    end)

    sub_menu:IsVisible(function(Items)

        for k, v in pairs(Config["Weaponshop"]["List"][catSelected]) do

            Items:Button(v.label, nil or v.description, { RightLabel = Shared.Math:GroupDigits(v.price.." ~g~$")}, true, {
                onSelected = function()
                    local success, inputs = pcall(function()
                        return lib.inputDialog("Ammunation", {
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

                    TriggerServerEvent(Enums.Weaponshop.BuyWeapon, v.name, v.label, v.price, catSelected, amout)
                end
            })

        end

    end)

end)

-- Ammo
RegisterNetEvent("iZeyy:Ammunation:AddClip", function()
    local PlayerPed = PlayerPedId()
    if (IsPedArmed(PlayerPed, 4)) then
        local WeaponHash = GetSelectedPedWeapon(PlayerPed)
        local WeaponModel = 416676503
        local WeaponGroupe = GetWeapontypeGroup(WeaponHash)
        if (WeaponHash) then
            AddAmmoToPed(PlayerPed, WeaponHash, 30)
            TriggerServerEvent("iZeyy:Ammunation:RemoveClip", 30)
        else
            ESX.ShowNotification("Action Impossible, Vous n'avez pas d'arme en main")
        end
    else
        ESX.ShowNotification("Action Impossible, Ce type de munitions ne convient pas")
    end
end)

RegisterNetEvent("iZeyy:Ammunation:AddAmmo", function()
    local PlayerPed = PlayerPedId()
    if (IsPedArmed(PlayerPed, 4)) then
        local WeaponHash = GetSelectedPedWeapon(PlayerPed)
        local WeaponModel = 416676503
        local WeaponGroupe = GetWeapontypeGroup(WeaponHash)
        if (WeaponHash) then
            AddAmmoToPed(PlayerPed, WeaponHash, 1)
            TriggerServerEvent("iZeyy:Ammunation:RemoveAmmo", 1)
        else
            ESX.ShowNotification("Action Impossible, Vous n'avez pas d'arme en main")
        end
    else
        ESX.ShowNotification("Action Impossible, Ce type de munitions ne convient pas")
    end
end)