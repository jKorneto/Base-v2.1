local holdingup = false
local holdingup2 = false
local bank = ''
local store = ""
local secondsRemaining = 0
local blipRobbery = nil
local vetrineRotte = 0 

local vetrine = {
	{x = -626.735, y = -238.545, z = 38.057, heading = 214.907, isOpen = false},--
	{x = -625.697, y = -237.877, z = 38.057, heading = 217.311, isOpen = false},--
	{x = -626.825, y = -235.347, z = 38.057, heading = 33.745, isOpen = false},--
	{x = -625.77, y = -234.563, z = 38.057, heading = 33.572, isOpen = false},--
	{x = -627.957, y = -233.918, z = 38.057, heading = 215.214, isOpen = false},--
	{x = -626.971, y = -233.134, z = 38.057, heading = 215.532, isOpen = false},--
	{x = -624.433, y = -231.161, z = 38.057, heading = 305.159, isOpen = false},--
	{x = -623.045, y = -232.969, z = 38.057, heading = 303.496, isOpen = false},--
	{x = -620.265, y = -234.502, z = 38.057, heading = 217.504, isOpen = false},--
	{x = -619.225, y = -233.677, z = 38.057, heading = 213.35, isOpen = false},--
	{x = -620.025, y = -233.354, z = 38.057, heading = 34.18, isOpen = false},--
	{x = -617.487, y = -230.605, z = 38.057, heading = 309.177, isOpen = false},--
	{x = -618.304, y = -229.481, z = 38.057, heading = 304.243, isOpen = false},--
	{x = -619.741, y = -230.32, z = 38.057, heading = 124.283, isOpen = false},--
	{x = -619.686, y = -227.753, z = 38.057, heading = 305.245, isOpen = false},--
	{x = -620.481, y = -226.59, z = 38.057, heading = 304.677, isOpen = false},--
	{x = -621.098, y = -228.495, z = 38.057, heading = 127.046, isOpen = false},--
	{x = -623.855, y = -227.051, z = 38.057, heading = 38.605, isOpen = false},--
	{x = -624.977, y = -227.884, z = 38.057, heading = 48.847, isOpen = false},--
	{x = -624.056, y = -228.228, z = 38.057, heading = 216.443, isOpen = false},--
}
function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	DrawText(_x, _y)

end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent("mt:missiontext")
AddEventHandler("mt:missiontext", function(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end)

function loadAnimDict( dict )  
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

RegisterNetEvent('esx_vangelico_robbery:currentlyrobbing')
AddEventHandler('esx_vangelico_robbery:currentlyrobbing', function(robb)
	holdingup2 = true
	store = robb
end)

RegisterNetEvent('esx_vangelico_robbery:killblip')
AddEventHandler('esx_vangelico_robbery:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('esx_vangelico_robbery:setblip')
AddEventHandler('esx_vangelico_robbery:setblip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 1.0)
    SetBlipColour(blipRobbery, 1)
    SetBlipAsShortRange(blipRobbery, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Braquage en Cours")
    EndTextCommandSetBlipName(blipRobbery)
end)

Citizen.CreateThread(function()
	for k,v in pairs(Stores)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 617)
		SetBlipScale(blip, 0.5)
		SetBlipColour(blip, 3)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Bijouterie de Bijouterie")
		EndTextCommandSetBlipName(blip)
	end
end)


RegisterNetEvent('esx_vangelico_robbery:toofarlocal')
AddEventHandler('esx_vangelico_robbery:toofarlocal', function(robb)
	holdingup2 = false
	ESX.ShowAdvancedNotification('Notification', "Braquage", "Braquage annulé", 'CHAR_CALL911', 8)
	robbingName = ""
	incircle = false
end)


RegisterNetEvent('esx_vangelico_robbery:robberycomplete')
AddEventHandler('esx_vangelico_robbery:robberycomplete', function(robb)
	holdingup2 = false
	ESX.ShowAdvancedNotification('Notification', "Braquage", "Braquage complété", 'CHAR_CALL911', 8)
	store = ""
	incircle = false
end)

animazione = false
incircle = false
soundid = GetSoundId()

function drawTxt2(x, y, scale, text, red, green, blue, alpha)
	SetTextFont(ServerFontStyle)
	SetTextProportional(1)
	SetTextScale(0.28, 0.28)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(text)
    DrawText(0.899, 0.920)
    DrawSprite("timerbars", "all_black_bg", 0.940, 0.935, 0.1, 0.03, 0.0, 0, 0, 0, 180)
end

Citizen.CreateThread(function()
      
	while true do
		local pos = GetEntityCoords(PlayerPedId(), true)

		for k,v in pairs(Stores)do
			local pos2 = v.position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 25.0)then
				if not holdingup2 then
					DrawMarker(6, v.position.x, v.position.y, v.position.z-0.9, 0, 0, 0, 0, 0, -90, 0.8, 0.8, 0.8, 255, 255, 255, 255, 0, 0, 0, 0)
                    DrawMarker(1, v.position.x, v.position.y, v.position.z-0.9, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.2, 255, 255, 255, 155, 0, 0, 0, 0)
					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then
						if (incircle == false) then
                            ESX.ShowNotification("Tirer pour lancer le Braquage")
						end
						incircle = true
						if IsPedShooting(PlayerPedId()) then
							if ConfigBraco.NeedBag then
							    --if borsa == 40 or borsa == 41 or borsa == 44 or borsa == 45 then
							        ESX.TriggerServerCallback('esx_vangelico_robbery:conteggio', function(CopsConnected)
								        if CopsConnected >= ConfigBraco.RequiredCopsRob then
							                TriggerServerEvent('esx_vangelico_robbery:rob', k)
								        else
                                            ESX.ShowNotification("Il n'y a pas assez de policier en ville pour braquer (".. ConfigBraco.RequiredCopsRob .. ")")
								        end
							        end)		
						       -- else
							        --TriggerEvent('esx:showNotification', _U('need_bag'))
								--end
							else
								ESX.TriggerServerCallback('esx_vangelico_robbery:conteggio', function(CopsConnected)
									if CopsConnected >= ConfigBraco.RequiredCopsRob then
										TriggerServerEvent('esx_vangelico_robbery:rob', k)
									else
										ESX.ShowNotification("Il n'y a pas assez de policier en ville pour braquer (".. ConfigBraco.RequiredCopsRob .. ")")
									end
								end)	
							end	
                        end
					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
						incircle = false
					end		
				end
			end
		end

		if holdingup2 then
			drawTxt2(0.3, 1.4, 0.45, "Vitrine brisé" .. ' : ' .. vetrineRotte .. '/' .. ConfigBraco.MaxWindows, 255, 255, 255, 255)

			for i,v in pairs(vetrine) do 
				if(GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 10.0) and not v.isOpen and ConfigBraco.EnableMarker then 
					DrawMarker(32, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 255, 255, 255, 155, 1, 1, 0, 0)
				end
				if(GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 0.75) and not v.isOpen then 
					ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour voler les bijoux")
					if IsControlJustPressed(0, 51) then
						animazione = true
					    SetEntityCoords(PlayerPedId(), v.x, v.y, v.z-0.95)
					    SetEntityHeading(PlayerPedId(), v.heading)
						v.isOpen = true 
						PlaySoundFromCoord(-1, "Glass_Smash", v.x, v.y, v.z, "", 0, 0, 0)
					    if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
					    RequestNamedPtfxAsset("scr_jewelheist")
					    end
					    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
					    Citizen.Wait(0)
					    end
					    SetPtfxAssetNextCall("scr_jewelheist")
					    StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", v.x, v.y, v.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
					    loadAnimDict( "missheist_jewel" ) 
						TaskPlayAnim(PlayerPedId(), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
					    DrawSubtitleTimed(5000, 1)
					    Citizen.Wait(5000)
					    ClearPedTasksImmediately(PlayerPedId())
					    TriggerServerEvent('esx_vangelico_robbery:gioielli')
					    PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					    vetrineRotte = vetrineRotte+1
					    animazione = false

						if vetrineRotte == ConfigBraco.MaxWindows then 
						    for i,v in pairs(vetrine) do 
								v.isOpen = false
								vetrineRotte = 0
							end
							TriggerServerEvent('esx_vangelico_robbery:endrob', store)
							ESX.ShowAdvancedNotification('Notification', "Braquage", "Vous avez braqué la bijouterie! Maintenant, allez revendre les bijoux", 'CHAR_CALL911', 8)
						    holdingup2 = false
						    StopSound(soundid)
						end
					end
				end
			end


			local pos2 = Stores[store].position

			if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -622.566, -230.183, 38.057, true) > 31.5 ) then
				TriggerServerEvent('esx_vangelico_robbery:toofar', store)
				holdingup2 = false
				for i,v in pairs(vetrine) do 
					v.isOpen = false
					vetrineRotte = 0
				end
				StopSound(soundid)
			end

		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
      
	while true do
		Wait(1)
		if animazione == true then
			if not IsEntityPlayingAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 3) then
				TaskPlayAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 8.0, 8.0, -1, 17, 1, false, false, false)
			end
		end
	end
end)

blip = false

CreateThread(function()
	while true do
		Wait(1);
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
		
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), ConfigBraco.SellPos, true) <= 10 and not blip then
            DrawMarker(6, ConfigBraco.SellPos.x,ConfigBraco.SellPos.y, ConfigBraco.SellPos.z-0.9, 0, 0, 0, 0, 0, -90, 0.8, 0.8, 0.8, 255, 255, 255, 255, 0, 0, 0, 0)
            DrawMarker(1, ConfigBraco.SellPos.x,ConfigBraco.SellPos.y, ConfigBraco.SellPos.z-0.9, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.2, 255, 255, 255, 155, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(coords, ConfigBraco.SellPos, true) < 1.0 then
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour vendre vos Bijoux")
				if IsControlJustReleased(1, 51) then
					blip = true;
					TriggerServerEvent('JustGod:ClaquetteChausette');
				end
			end
		end
	end
end)

RegisterNetEvent('JustGod:ClaquetteChausetteV2', function()
	blip = false; --"Pas asser de policier pour vendre: " .. ConfigBraco.RequiredCopsSell .. " policiers requis"
end);