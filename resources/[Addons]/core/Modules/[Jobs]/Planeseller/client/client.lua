local sell_menu = RageUI.AddMenu("", "Faites vos actions")
local sell_sub_menu = RageUI.AddSubMenu(sell_menu, "", "Faites vos actions")
local catalog_menu = RageUI.AddMenu("", "Voici notre Catalogue")
local catalog_sub_menu = RageUI.AddSubMenu(catalog_menu, "", "Voici notre Catalogue")

local InService = false

local CategoriesData = {}
local VehForCarData = {}
local VehicleSpawned = {}

local Resseller = {
    Status = {
        "~b~Visualiser",
        "~b~Quitter",
        "~b~Acheter"

    },
    StatusIndex = 1
}

local Planeseller = {
    Status = {
        "~b~Ouvert",
        "~b~Fermer",
        "~b~Recrutement"
    },
    StatusIndex = 1
}

local Preview = {
    Status = {
        "~b~Visualiser",
        "~b~Quitter"

    },
    StatusIndex = 1
}

local PlaneSellerCam = nil
local CurrentVeh = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    while ESX.GetPlayerData()["job"] == nil do
        Wait(2000)
    end
end)

local function CarPreview(VehModel)
    RequestModel(VehModel)
    while not HasModelLoaded(VehModel) do
        Wait(0)
    end

    if CurrentVeh and DoesEntityExist(CurrentVeh) then
        DeleteEntity(CurrentVeh)
    end

    CurrentVeh = CreateVehicle(VehModel, Config["Planeseller"]["PreviewPos"], Config["Planeseller"]["PreviewHeading"], false, false)
    FreezeEntityPosition(CurrentVeh, true)
    SetVehicleDoorsLocked(CurrentVeh, 2)
    SetEntityInvincible(CurrentVeh, true)
    SetVehicleFixed(CurrentVeh)
    SetVehicleDirtLevel(CurrentVeh, 0.0)
    SetVehicleEngineOn(CurrentVeh, true, true, true)
    SetVehicleLights(CurrentVeh, 2)
    SetVehicleCustomPrimaryColour(CurrentVeh, 255, 255, 255)
    SetVehicleCustomSecondaryColour(CurrentVeh, 255, 255, 255)
end

local function ShowCdCam(VehModel)
    local PlayerPed = PlayerPedId()
    local CamPos = Config["Planeseller"]["Cam"]
    local CamRot = Config["Planeseller"]["CamRot"]

    if not PlaneSellerCam then
        PlaneSellerCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(PlaneSellerCam, CamPos.x, CamPos.y, CamPos.z)
        SetCamRot(PlaneSellerCam, CamRot.x, CamRot.y, CamRot.z)
        SetCamFov(PlaneSellerCam, 35.0)
        SetCamActive(PlaneSellerCam, true)
        RenderScriptCams(true, false, 0, true, true)
    end

    CarPreview(VehModel)
end

local function DrestroyCdCam()
    local PlayerPed = PlayerPedId()

    if CurrentVeh and DoesEntityExist(CurrentVeh) then
        DeleteEntity(CurrentVeh)
        CurrentVeh = nil
    end

    if PlaneSellerCam then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(PlaneSellerCam, false)
        PlaneSellerCam = nil
    end
end

CreateThread(function()
    local PlaneSellerZone = Game.Zone("PlaneSellerZone")

    PlaneSellerZone:Start(function()
        PlaneSellerZone:SetTimer(1000)
        PlaneSellerZone:SetCoords(Config["Planeseller"]["Office"])

        PlaneSellerZone:IsPlayerInRadius(10.0, function()
            PlaneSellerZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == "planeseller" then
                PlaneSellerZone:Marker()
                PlaneSellerZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    PlaneSellerZone:KeyPressed("E", function()
                        TriggerServerEvent("Core:Planeseller:GetCat")
                        sell_menu:Toggle()
                    end)
                end, false, false)
            end
        end, false, false)

        PlaneSellerZone:RadiusEvents(3.0, nil, function()
            sell_menu:Close()
        end)
    end)

    sell_menu:IsVisible(function(Items)
        if (InService) then
            local SortedCategories = {}
            for Name, Category in pairs(CategoriesData) do
                table.insert(SortedCategories, {Name = Name, Category = Category})
            end
        
            table.sort(SortedCategories, function(a, b)
                return a.Category.label < b.Category.label
            end)
            if #SortedCategories == 0 then
                Items:Separator("")
                Items:Separator("Aucune catégorie trouvé")
                Items:Separator("")
            else
                for _, data in ipairs(SortedCategories) do
                    local Name, Category = data.Name, data.Category
                    Items:Button(Category.label, nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("Core:Planeseller:GetVehForCat", Name)
                        end
                    }, sell_sub_menu)
                end
            end
        else
            Items:Separator("")
            Items:Separator("Vous devez etre en service")
            Items:Separator("")
        end
    end, nil, function()
        CategoriesData = {}
        VehForCarData = {}
    end)
    

    sell_sub_menu:IsVisible(function(Items)
        local SortedVehs = {}
    
        for Name, Veh in pairs(VehForCarData) do
            table.insert(SortedVehs, {Name = Name, Veh = Veh})
        end
        
        table.sort(SortedVehs, function(a, b)
            return a.Veh.name < b.Veh.name
        end)
        
        if #SortedVehs == 0 then
            Items:Separator("")
            Items:Separator("Aucun Avions dans cette catégorie")
            Items:Separator("")
        else
            for _, data in ipairs(SortedVehs) do
                local Name, Veh = data.Name, data.Veh
                local Desc = "Prix du Véhicule (Usine) : " .. string.gsub(ESX.Math.GroupDigits(Veh.price), " ", " ") .. " ~g~$~s~\nPrix du Véhicule (Vente) : " .. string.gsub(ESX.Math.GroupDigits(Veh.price * 2), " ", " ") .. " ~g~$ "
                Items:List(Veh.name, Resseller.Status, Resseller.StatusIndex, Desc, {}, true, {
                    onListChange = function(index) 
                        Resseller.StatusIndex = index
                    end,
                    onSelected = function(index)
                        if index == 1 then
                            sell_sub_menu:SetClosable(false)
                            ShowCdCam(Name)
                            InCam = true
                        elseif index == 2 then
                            if InCam then
                                sell_sub_menu:SetClosable(true)
                                DrestroyCdCam(Name)
                                InCam = false
                            else
                                ESX.ShowNotification("Vous n'êtes pas en preview")
                            end
                        elseif index == 3 then
                            sell_sub_menu:SetClosable(true)
                            DrestroyCdCam()
                            local ClosetPlayer, Distance = ESX.Game.GetClosestPlayer()
                            if ClosetPlayer == -1 or Distance > 5.0 then
                                ESX.ShowNotification("Aucun joueur à proximité")
                            else
                                TriggerServerEvent("Core:Planeseller:SendBill",  GetPlayerServerId(ClosetPlayer), Name)
                            end
                        end
                    end
                })
            end
        end
    end, nil, function()
        VehForCarData = {}
    end)

end)

RegisterNetEvent("Core:Planeseller:ReceiveCat", function(Data)
    CategoriesData = Data or {}
end)

RegisterNetEvent("Core:Planeseller:ReceiveVehForCat", function(Data)
    VehForCarData = Data or {}
end)

-- Service
local service_menu = RageUI.AddMenu("", "Faites vos actions")

local function SetUniform()
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config["Planeseller"]["Uniform"].male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config["Planeseller"]["Uniform"].female)
        end
    end)
end

CreateThread(function()
    local PlaneSellerServiceZone = Game.Zone("PlaneSellerZone")

    PlaneSellerServiceZone:Start(function()
        PlaneSellerServiceZone:SetTimer(1000)
        PlaneSellerServiceZone:SetCoords(Config["Planeseller"]["Service"])

        PlaneSellerServiceZone:IsPlayerInRadius(10.0, function()
            PlaneSellerServiceZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == "planeseller" then
                PlaneSellerServiceZone:Marker()
                PlaneSellerServiceZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    PlaneSellerServiceZone:KeyPressed("E", function()
                        service_menu:Toggle()
                    end)
                end, false, false)
            end
        end, false, false)

        PlaneSellerServiceZone:RadiusEvents(3.0, nil, function()
            service_menu:Close()
        end)
        
    end)

    service_menu:IsVisible(function(Items)
        Items:Button("Prendre votre Service", nil, {}, not InService, {
            onSelected = function ()
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Wait(1000)
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("iZeyy:job:takeService", "planeseller", true)
                SetUniform()
                InService = true
                service_menu:Close()
            end
        })
        Items:Button("Fin de Service", nil, {}, InService, {
            onSelected = function()
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Wait(1000)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
                TriggerServerEvent("iZeyy:job:takeService", "planeseller", false)
                InService = false
                service_menu:Close()
            end
        }, Submenu)
    end)
end)

-- F6 Menu
local main_menu = RageUI.AddMenu("", "Faites vos actions")

CreateThread(function()
    main_menu:IsVisible(function(Items)
        Items:List("Status entreprise", Planeseller.Status, Planeseller.StatusIndex, nil, {}, true, {
            onListChange = function(index)
                Planeseller.StatusIndex = index
            end,
            onSelected = function(index)
                if index == 1 then
                    if (InService) then
                        TriggerServerEvent("iZeyy:Planeseller:SendAnnoucement", "open")
                    else
                        ESX.ShowNotification("Vous ne pouvez pas faire d'annonces si vous n'etes pas service")
                    end
                elseif index == 2 then
                    if (InService) then
                        TriggerServerEvent("iZeyy:Planeseller:SendAnnoucement", "close")
                    else
                        ESX.ShowNotification("Vous ne pouvez pas faire d'annonces si vous n'etes pas service")
                    end
                elseif index == 3 then
                    if (InService) then
                        TriggerServerEvent("iZeyy:Planeseller:SendAnnoucement", "recrutement")
                    else
                        ESX.ShowNotification("Vous ne pouvez pas faire d'annonces si vous n'etes pas service")
                    end
                end
            end
        })
        Items:Button("Faire une facture", nil, {}, true, {
            onSelected = function()
                if (InService) then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance < 5.0 then
                        local success, input = pcall(function()
                            return lib.inputDialog("Montant", {
                                {type = "number", label = "Entrez votre prix"},
                            })
                        end)
    
                        if not success then
                            return
                        elseif input == nil then
                            ESX.ShowNotification("Entrez un texte Valide")
                        else
                            local price = input[1]
                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'planeseller', 'Concessionaire Avions', price)
                        end
                    else
                        ESX.ShowNotification("Aucun joueurs a coté de vous.")
                    end
                else
                    ESX.ShowNotification("Vous ne pouvez faire de facture si vous n'etes pas service")
                end
            end
        })
    end)

    local Blip = AddBlipForCoord(Config["Planeseller"]["BlipsPos"])
    SetBlipSprite(Blip, 423)
    SetBlipScale(Blip, 0.5)
    SetBlipColour(Blip, 3)
    SetBlipDisplay(Blip, 4)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config["Planeseller"]["BlipsLabel"])
    EndTextCommandSetBlipName(Blip)

end)

CreateThread(function()
    local PlaneSellerCatalogZone = Game.Zone("PlaneSellerZone")

    PlaneSellerCatalogZone:Start(function()
        PlaneSellerCatalogZone:SetTimer(1000)
        PlaneSellerCatalogZone:SetCoords(Config["Planeseller"]["Catalog"])

        PlaneSellerCatalogZone:IsPlayerInRadius(10.0, function()
            PlaneSellerCatalogZone:SetTimer(0)

            PlaneSellerCatalogZone:Marker()
            PlaneSellerCatalogZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    PlaneSellerCatalogZone:KeyPressed("E", function()
                        TriggerServerEvent("Core:Planeseller:GetCat")
                        catalog_menu:Toggle()
                    end)
                end, false, false)

        end, false, false)

        PlaneSellerCatalogZone:RadiusEvents(3.0, nil, function()
            catalog_menu:Close()
        end)
        
    end)

    catalog_menu:IsVisible(function(Items)
        local SortedCategories = {}
        for Name, Category in pairs(CategoriesData) do
            table.insert(SortedCategories, {Name = Name, Category = Category})
        end
    
        table.sort(SortedCategories, function(a, b)
            return a.Category.label < b.Category.label
        end)
        if #SortedCategories == 0 then
            Items:Separator("")
            Items:Separator("Aucune catégorie trouvé")
            Items:Separator("")
        else
            for _, data in ipairs(SortedCategories) do
                local Name, Category = data.Name, data.Category
                Items:Button(Category.label, nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent("Core:Planeseller:GetVehForCat", Name)
                    end
                }, catalog_sub_menu)
            end
        end
    end, nil, function()
        CategoriesData = {}
        VehForCarData = {}
    end)

    catalog_sub_menu:IsVisible(function(Items)
        local SortedVehs = {}
    
        for Name, Veh in pairs(VehForCarData) do
            table.insert(SortedVehs, {Name = Name, Veh = Veh})
        end
        
        table.sort(SortedVehs, function(a, b)
            return a.Veh.name < b.Veh.name
        end)
        
        if #SortedVehs == 0 then
            Items:Separator("")
            Items:Separator("Aucun véhicule dans cette catégorie")
            Items:Separator("")
        else
            for _, data in ipairs(SortedVehs) do
                local Name, Veh = data.Name, data.Veh
                Items:List(Veh.name, Preview.Status, Preview.StatusIndex, "Prix du Véhicule : " .. string.gsub(ESX.Math.GroupDigits(Veh.price * 2), " ", " ") .. " ~g~$", {}, true, {
                    onListChange = function(index) 
                        Preview.StatusIndex = index
                    end,
                    onSelected = function(index)
                        if index == 1 then
                            catalog_sub_menu:SetClosable(false)
                            ShowCdCam(Name)
                            InCam = true
                        elseif index == 2 then
                            if InCam then
                                catalog_sub_menu:SetClosable(true)
                                DrestroyCdCam(Name)
                                InCam = false
                            else
                                ESX.ShowNotification("Vous n'êtes pas en preview")
                            end
                        end
                    end
                })
            end
        end
    end, nil, function()
        VehForCarData = {}
    end)

end)

Shared:RegisterKeyMapping("iZeyy:Planeseller:OpenMenu", { label = "open_menu_interactPlaneSeller" }, "F6", function()
    local job = Client.Player:GetJob().name

    if job == "planeseller" then
        main_menu:Toggle()
    end
end)