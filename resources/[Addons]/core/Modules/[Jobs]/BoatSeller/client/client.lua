local sell_menu = RageUI.AddMenu("", "Faites vos actions")
local sell_sub_menu = RageUI.AddSubMenu(sell_menu, "", "Faites vos actions")

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

local Boatseller = {
    Status = {
        "~b~Ouvert",
        "~b~Fermer",
        "~b~Recrutement"
    },
    StatusIndex = 1
}

local CarDealerCam = nil
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

    CurrentVeh = CreateVehicle(VehModel, Config["Boatseller"]["PreviewPos"], Config["Boatseller"]["PreviewHeading"], false, false)
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
    local CamPos = Config["Boatseller"]["Cam"]
    local CamRot = Config["Boatseller"]["CamRot"]

    if not CarDealerCam then
        CarDealerCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(CarDealerCam, CamPos.x, CamPos.y, CamPos.z)
        SetCamRot(CarDealerCam, CamRot.x, CamRot.y, CamRot.z)
        SetCamFov(CarDealerCam, 55.0)
        SetCamActive(CarDealerCam, true)
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

    if CarDealerCam then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(CarDealerCam, false)
        CarDealerCam = nil
    end
end

CreateThread(function()
    local CarDealerZone = Game.Zone("CarDealerZone")

    CarDealerZone:Start(function()
        CarDealerZone:SetTimer(1000)
        CarDealerZone:SetCoords(Config["Boatseller"]["Office"])

        CarDealerZone:IsPlayerInRadius(10.0, function()
            CarDealerZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == "boatseller" then
                CarDealerZone:Marker()
                CarDealerZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    CarDealerZone:KeyPressed("E", function()
                        TriggerServerEvent("Core:Boatseller:GetCat")
                        sell_menu:Toggle()
                    end)
                end, false, false)
            end
        end, false, false)

        CarDealerZone:RadiusEvents(3.0, nil, function()
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
                            TriggerServerEvent("Core:Boatseller:GetVehForCat", Name)
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
            Items:Separator("Aucun Bateau dans cette catégorie")
            Items:Separator("")
        else
            for _, data in ipairs(SortedVehs) do
                local Name, Veh = data.Name, data.Veh
                Items:List(Veh.name, Resseller.Status, Resseller.StatusIndex, "Prix du Bateau : " .. string.gsub(ESX.Math.GroupDigits(Veh.price), " ", " ") .. " ~g~$", {}, true, {
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
                                TriggerServerEvent("Core:Boatseller:SendBill",  GetPlayerServerId(ClosetPlayer), Name)
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

RegisterNetEvent("Core:Boatseller:ReceiveCat", function(Data)
    CategoriesData = Data or {}
end)

RegisterNetEvent("Core:Boatseller:ReceiveVehForCat", function(Data)
    VehForCarData = Data or {}
end)

-- Service
local service_menu = RageUI.AddMenu("", "Faites vos actions")

local function SetUniform()
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config["Boatseller"]["Uniform"].male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config["Boatseller"]["Uniform"].female)
        end
    end)
end

CreateThread(function()
    local CarDealerServiceZone = Game.Zone("CarDealerZone")

    CarDealerServiceZone:Start(function()
        CarDealerServiceZone:SetTimer(1000)
        CarDealerServiceZone:SetCoords(Config["Boatseller"]["Service"])

        CarDealerServiceZone:IsPlayerInRadius(10.0, function()
            CarDealerServiceZone:SetTimer(0)
            local playerData = ESX.GetPlayerData()
            local job = playerData.job.name

            if job == "boatseller" then
                CarDealerServiceZone:Marker()
                CarDealerServiceZone:IsPlayerInRadius(3.0, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    CarDealerServiceZone:KeyPressed("E", function()
                        service_menu:Toggle()
                    end)
                end, false, false)
            end
        end, false, false)

        CarDealerServiceZone:RadiusEvents(3.0, nil, function()
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
                TriggerServerEvent("iZeyy:job:takeService", "boatseller", true)
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
                TriggerServerEvent("iZeyy:job:takeService", "boatseller", false)
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
        Items:List("Status entreprise", Boatseller.Status, Boatseller.StatusIndex, nil, {}, true, {
            onListChange = function(index)
                Boatseller.StatusIndex = index
            end,
            onSelected = function(index)
                TriggerServerEvent("iZeyy:Boatseller:SendAnnoucement", Boatseller.StatusIndex)
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
                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'boatseller', 'Concessionaire Bateau', price)
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

    local Blip = AddBlipForCoord(Config["Boatseller"]["BlipsPos"])
    SetBlipSprite(Blip, 410)
    SetBlipScale(Blip, 0.5)
    SetBlipColour(Blip, 3)
    SetBlipDisplay(Blip, 4)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config["Boatseller"]["BlipsLabel"])
    EndTextCommandSetBlipName(Blip)

end)

Shared:RegisterKeyMapping("iZeyy:Boatseller:OpenMenu", { label = "open_menu_interactCarDealer" }, "F6", function()
    local job = Client.Player:GetJob().name

    if job == "boatseller" then
        main_menu:Toggle()
    end
end)