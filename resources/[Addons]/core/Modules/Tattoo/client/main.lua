local main_menu = RageUI.AddMenu("", "Faites vos actions")
local cat_menu = RageUI.AddSubMenu(main_menu, "", "Faites vos actions")
local CurrentTattoos = {}

local CatSelected = nil

main_menu:SetSpriteBanner("commonmenu", "interaction_tattoos")
main_menu:SetButtonColor(152, 30, 37, 255)
cat_menu:SetSpriteBanner("commonmenu", "interaction_tattoos")
cat_menu:SetButtonColor(152, 30, 37, 255)

CreateThread(function()
    for k, v in pairs(Config["Tattoo"]["Pos"]) do
        local Blip = AddBlipForCoord(v)
		SetBlipSprite(Blip, 75)
		SetBlipColour(Blip, 1)
		SetBlipAsShortRange(Blip, true)
		SetBlipScale(Blip, 0.5)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName("Tatoueur")
		EndTextCommandSetBlipName(Blip)

        local TattooZone = Game.Zone("TattooZone")

        TattooZone:Start(function()
            TattooZone:SetTimer(1000)
            TattooZone:SetCoords(v) 
    
            TattooZone:IsPlayerInRadius(2.0, function()
                TattooZone:SetTimer(0)
                TattooZone:Marker()
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir avec le Tatoueur")

                TattooZone:IsPlayerInRadius(2.0, function()
                    TattooZone:KeyPressed("E", function()
                        if not exports["epicenter"]:IsInStaff() then
                            if not exports.core:IsServerInBlackout() then
                                main_menu:Toggle()
                            else
                                ESX.ShowNotification("Nous sommes actuellement fermé en raison de la situation actuelle desolé")
                            end
                        else
                            ESX.ShowNotification("Vous ne pouvez pas utiliser ce menu en staff")
                        end
                    end)
                end, false, false)

            end, false, false)

            TattooZone:RadiusEvents(2.0, nil, function()
                main_menu:Close()
            end)
        end)
    end
end)

local function SetDefaultSkin()
    local PlayerPed = PlayerPedId()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		local model = nil

		if skin.sex == 0 then
			model = `mp_m_freemode_01`
		else
			model = `mp_f_freemode_01`
		end

		ESX.Streaming.RequestModel(model)
		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)
		TriggerEvent('skinchanger:loadSkin', skin)
		TriggerEvent('esx:restoreLoadout')
	end)
	for k, v in pairs(CurrentTattoos) do
		ApplyPedOverlay(PlayerPed, GetHashKey(v.collection), GetHashKey(v.texture))
	end
end

local function ShowTattoo(current, collection)
    local PlayerPed = PlayerPedId()

    ClearPedDecorations(PlayerPed)
    for k, v in pairs(CurrentTattoos) do
        ApplyPedOverlay(PlayerPed, GetHashKey(v.collection), GetHashKey(v.texture))
    end

    if (GetEntityModel(PlayerPed) == -1667301416) then
		SetPedComponentVariation(PlayerPed, 8, 14, 0, 2)
		SetPedComponentVariation(PlayerPed, 3, 15, 0, 2)
		SetPedComponentVariation(PlayerPed, 11, 15, 0, 2)
		SetPedComponentVariation(PlayerPed, 4, 15, 0, 2)
		SetPedComponentVariation(PlayerPed, 6, 51, 0, 2)
		SetPedComponentVariation(PlayerPed, 5, 0, 0, 2)
	else
		SetPedComponentVariation(PlayerPed, 8, 15, 0, 2)
		SetPedComponentVariation(PlayerPed, 3, 15, 0, 2)
		SetPedComponentVariation(PlayerPed, 11, 15, 0, 2)
		SetPedComponentVariation(PlayerPed, 4, 14, 0, 2)
		SetPedComponentVariation(PlayerPed, 6, 99, 0, 2)
		SetPedComponentVariation(PlayerPed, 5, 0, 0, 2)
	end

	ApplyPedOverlay(PlayerPed, GetHashKey(current), GetHashKey(collection))
end

main_menu:IsVisible(function(Items)
    local PlayerPed = PlayerPedId()
    local DelPrice = Config["Tattoo"]["DelPrice"]
    FreezeEntityPosition(PlayerPed, true)
    
    Items:Button("Effacer tout vos Tatouages", nil, {RightLabel = DelPrice.." ~g~$~s~"}, true, {
        onSelected = function()
            TriggerServerEvent("iZeyy:Tattoo:Remove")
        end
    })
    Items:Line()
    for k, v in pairs(Config["Tattoo"]["Categories"]) do
        Items:Button(v.name, nil, {}, true, {
            onSelected = function()
                CatSelected = v.value
            end
        }, cat_menu)
    end
end, nil, function()
    local PlayerPed = PlayerPedId()
    FreezeEntityPosition(PlayerPed, false)
    SetDefaultSkin()
end)

cat_menu:IsVisible(function(Items)
    local PlayerPed = PlayerPedId()
    local TattooPrice = Config["Tattoo"]["TattooPrice"]
    for k, v in pairs(Config["Tattoo"]["List"][CatSelected]) do
        Items:Button("Tatouage #" .. k, nil, {RightLabel = TattooPrice.." ~g~$~s~"}, true, {
            onActive = function()
                ShowTattoo(CatSelected, v.nameHash)
            end,
            onSelected = function()
                ClearPedDecorations(PlayerPed)
                TriggerServerEvent("iZeyy:Tattoo:Check", CurrentTattoos, {collection = CatSelected, texture = v.nameHash})
            end
        })
    end
end)

-- Event
RegisterNetEvent("iZeyy:Tattoo:GetTattoo", function(TattosList)
    local PlayerPed = PlayerPedId()
    for k, v in pairs(TattosList) do
        ApplyPedOverlay(PlayerPed, GetHashKey(v.collection), GetHashKey(v.texture))
    end
    CurrentTattoos = TattosList
end)

RegisterNetEvent("iZeyy:Tattoo:DelTatoo", function()
    local PlayerPed = PlayerPedId()
    ClearPedDecorations(PlayerPed)
end)

local LoadSkin = false
AddEventHandler("skinchanger:loadSkin", function(skin)
    local PlayerPed = PlayerPedId()
	if (not firstLoad) then
		CreateThread(function()
			while not GetEntityModel(PlayerPed == `mp_m_freemode_01` or GetEntityModel(PlayerPed) == `mp_f_freemode_01`) do
				Wait(10)
			end
            Wait(75)
			TriggerServerEvent("iZeyy:Tattoo:FirstLoad")
		end)
		
		LoadSkin = true
	else
		Wait(75)

		for k, v in pairs(currentTattoos) do
			ApplyPedOverlay(PlayerPed, GetHashKey(v.collection), GetHashKey(v.texture))
		end
	end
end)

RegisterNetEvent("iZeyy:Tatto:Succes", function(Value)
    table.insert(CurrentTattoos, Value)
end)