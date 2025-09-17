local main_menu = RageUI.AddMenu("", "Magasin de Masque")
local filter = {Mask1 = 1, Mask2 = 1}

local price = Config["MaskShop"]["Price"]

local function KillCam()
    RenderScriptCams(0, 1, 1500, 0, 0)
    SetCamActive(cam, false)
    ClearPedTasks(PlayerPedId())
    DestroyAllCams(true)
end

local function CreateHeadCam()
    CreateThread(function()
        local pPed = PlayerPedId()
        local pos = GetOffsetFromEntityInWorldCoords(pPed, 0.0, 1.0, 0.7)
        local posLook = GetOffsetFromEntityInWorldCoords(pPed, 0.0, 0.0, 0.65)

        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)

        SetCamActive(cam, true)
        SetCamCoord(cam, pos.x, pos.y, pos.z)
        SetCamFov(cam, 25.0)
        PointCamAtCoord(cam, posLook.x, posLook.y, posLook.z)
        RenderScriptCams(1, 1, 1500, 0, 0)

        while true do
            Wait(500)
            if not main_menu:IsOpen() then

                FreezeEntityPosition(pPed, false)
                KillCam()

                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)

                break

            end
        end
    end)
end

CreateThread(function()

    for k,v in pairs(Config["MaskShop"]["Pos"]) do

        local Blips = AddBlipForCoord(Config["MaskShop"]["Pos"][k].x, Config["MaskShop"]["Pos"][k].y, Config["MaskShop"]["Pos"][k].z)
        SetBlipSprite(Blips, 362)
        SetBlipDisplay(Blips, 4)
        SetBlipScale(Blips, 0.5)
        SetBlipColour(Blips, 47)
        SetBlipAsShortRange(Blips, true)
        
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Magasin de masque")
        EndTextCommandSetBlipName(Blips)

    end

end)

main_menu:IsVisible(function(Items)
    local Mask1 = {}
    local Mask2 = {}
    local numberOfVariations1 = GetNumberOfPedPropDrawableVariations(PlayerPedId(), 0)
    local numberOfVariations2 = GetNumberOfPedTextureVariations(PlayerPedId(), 1, filter.Mask1)

    for i = 0, numberOfVariations1 do 
        Mask1[i] = i-1
    end

    for i = 0, numberOfVariations2 do 
        Mask2[i] = i-1
    end

    FreezeEntityPosition(PlayerPedId(), true)

    Items:List("Masque", Mask1, filter.Mask1, "Appuyez ~h~ENTRER~h~ pour choisir un numéro", {}, true, {
        onListChange = function(Index)
            filter.Mask1 = Index
            filter.Mask2 = 1
            TriggerEvent('skinchanger:change', 'mask_1', filter.Mask1)
            TriggerEvent('skinchanger:change', 'mask_2', filter.Mask2)
        end,
    
        onSelected = function()
            -- Utilisation de lib.inputDialog pour demander le numéro du masque
            local success, input = pcall(function()
                return lib.inputDialog("Numero de masque", {
                    {type = "number", label = "Entrez le numéro de masque"}
                })
            end)
    
            if not success then
                -- print("Erreur lors de l'ouverture du dialogue : " .. tostring(input))
                return
            elseif input == nil or input[1] == nil then
                ESX.ShowNotification("Erreur : Le dialogue a été annulé ou le numéro est invalide.")
                return
            end
    
            local number = tonumber(input[1]) -- Récupérer le numéro saisi
    
            -- Validation du numéro
            if number and number > 0 and number <= numberOfVariations1 then
                filter.Mask1 = number + 1
                filter.Mask2 = 1
                TriggerEvent('skinchanger:change', 'mask_1', filter.Mask1)
                TriggerEvent('skinchanger:change', 'mask_2', filter.Mask2)
            else
                ESX.ShowNotification("Numéro de masque invalide.")
            end
        end
    })
    

    Items:List("Variation", Mask2, filter.Mask2, "Appuyez ~h~ENTRER~h~ pour choisir un numéro", {}, true, {
        onListChange = function(Index)
            filter.Mask2 = Index
            TriggerEvent('skinchanger:change', 'mask_2', filter.Mask2)
        end,
    
        onSelected = function()
            local success, input = pcall(function()
                return lib.inputDialog("Choisissez un numéro de masque", {
                    {type = "number", label = "Numéro de masque"}
                })
            end)
    
            if not success then
                return
            elseif input == nil or input[1] == nil then
                ESX.ShowNotification("Erreur : Le dialogue a été annulé")
                return
            end
    
            local number = tonumber(input[1])
    
            if number and number > 0 and number <= tonumber(numberOfVariations2) then
                filter.Mask2 = number + 1 -- Ajuster le numéro si nécessaire
                TriggerEvent('skinchanger:change', 'mask_1', filter.Mask1)
                TriggerEvent('skinchanger:change', 'mask_2', filter.Mask2)
            else
                ESX.ShowNotification("Numéro de masque invalide")
            end
        end
    })
    

    Items:Button("Payer le masque", nil, { RightLabel = price .. "$"}, true, {
        onSelected = function()
            TriggerServerEvent("iZeyy:maskshop:pay", filter.Mask1, filter.Mask2)
            RageUI.CloseAll()
        end
    })
end)

CreateThread(function()
    while true do
        local Sleep = 1000
        local pCoords = GetEntityCoords(PlayerPedId())
        local isCloseEnough = false

        for k,v in pairs(Config["MaskShop"]["Pos"]) do
            local distance = #(vector3(pCoords.x, pCoords.y, pCoords.z) - vector3(v.x, v.y, v.z))

            if distance <= 2.5 then
                Sleep = 0
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au magasin de masque")
                if IsControlJustPressed(0, 51) then
                    main_menu:Toggle()
                    CreateHeadCam()
                end
                isCloseEnough = true
                break
            end
        end

        if not isCloseEnough and main_menu:IsOpen() then
            main_menu:Close()
        end

        Wait(Sleep)
    end
end)

RegisterNetEvent("iZeyy:maskshop:save", function(mask1, mask2)
    TriggerEvent('skinchanger:change', 'mask_1', mask1)
    TriggerEvent('skinchanger:change', 'mask_2', mask2)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)                                    
    end)
end)