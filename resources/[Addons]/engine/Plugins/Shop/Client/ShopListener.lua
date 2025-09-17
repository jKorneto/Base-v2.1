---@overload fun(): ShopListener
ShopListener = Class.new(function(class)
    local self = class
    local mainMenu = nil
    local playerData = {
        history = {},
        cameraSettings = {
            camera = nil,
            isActive = false,
            azimuth = nil,
            elevation = nil,
            zoomLevel = nil,
            inShop = false,
            currentVehicle = nil
        },
        vehicle = nil,
        oldCoords = nil,
        coins = 0
    }
    local limitedVehicles = {}

    ---@private
    function self:Constructor()
        Shared:Initialized("ShopListener")
    end

    function self:openShop()
        mainMenu = shopStorage:Get("main_menu")

        if (mainMenu) then
            mainMenu:Toggle()
        end
    end

    function self:openUrl()
        exports["engine_nui"]:openUrl(Engine["Config"]["Shop"]["tebexUrl"] or "https://google.com/")
    end

    function self:requestHistory()
        playerData.history = nil
        Shared.Events:ToServer(Engine["Enums"].Shop.Events.requestHistory)
    end

    function self:setHistory(data)
        if (type(data) == "table") then
            playerData.history = data
        end
    end

    function self:getHistory()
        return playerData.history
    end

    function self:requestCoins()
        playerData.coins = nil
        Shared.Events:ToServer(Engine["Enums"].Shop.Events.requestCoins)
    end

    function self:setCoins(data)
        if (type(data) == "number") then
            playerData.coins = data
        end
    end

    function self:getCoins()
        return playerData.coins or 0
    end

    ---@return boolean
    function self:isInShop()
        return playerData.cameraSettings.inShop
    end

    ---@param state boolean
    function self:setInShop(state)
        if (type(state) == "boolean") then
            playerData.cameraSettings.inShop = state
        end
    end

    function self:getCurrentVehicle()
        return playerData.cameraSettings.currentVehicle
    end

    function self:setCurrentVehicle(vehicleName)
        if (type(vehicleName) == "string") then
            playerData.cameraSettings.currentVehicle = vehicleName
        end
    end

    function self:createVehicle(vehicleName)
        if (self:getCurrentVehicle() ~= vehicleName) then
            if (playerData.vehicle) then
                self:deleteVehicle()
            end
    
            if (Game.Streaming:RequestModel(vehicleName)) then
                local position = Engine["Config"]["Shop"]["vehiclePreview"]
                local currentColor = GetVehicleXenonLightsColor(playerData.vehicle)
    
                playerData.vehicle = CreateVehicle(GetHashKey(vehicleName), position.x, position.y, position.z, position.w, false, true)
                SetVehicleDirtLevel(playerData.vehicle, 0.0)
                SetVehicleColours(playerData.vehicle, 0, 0)
                SetVehicleInteriorColor(playerData.vehicle, 0)
                SetVehicleDashboardColor(playerData.vehicle, 0)
                self:setCurrentVehicle(vehicleName)
    
                SetVehicleEngineOn(playerData.vehicle, true, true, false)
                SetVehicleLights(playerData.vehicle, 2)
                ToggleVehicleMod(playerData.vehicle, 22, true)
                SetVehicleHeadlightsColour(playerData.vehicle, 2)
    
                return playerData.vehicle
            end
        end
    end
    

    function self:deleteVehicle()
        if (playerData.vehicle) then
            if (DoesEntityExist(playerData.vehicle)) then
                DeleteEntity(playerData.vehicle)
                playerData.vehicle = nil
            end
        end
    end

    ---@param default boolean
    function self:changeBucket(default)
        if (not self:isInShop()) then
            Shared.Events:ToServer(Engine["Enums"].Shop.Events.changeBucket, default)
        end
    end

    function self:setInvisible(state)
        if (type(state) == "boolean") then
            SetEntityVisible(Client.Player:GetPed(), not state)
        end
    end

    function self:toggleHud(state)
        if (type(state) == "boolean" and not self:isInShop()) then
            DisplayRadar(state)
            TriggerEvent("iZeyy::Hud::StateHud", state)
            TriggerEvent("iZeyy:Hud:StateStatus", state)
        end
    end

    ---@return table
    function self:getLastPosition()
        local ped = Client.Player:GetPed()
        local pedCoords = GetEntityCoords(ped)
        local pedHeading = GetEntityHeading(ped)

        playerData.oldCoords = {
            x = pedCoords.x,
            y = pedCoords.y,
            z = pedCoords.z,
            w = pedHeading
        }

        return playerData.oldCoords
    end

    function self:teleportToVehicle()
        if (not self:isInShop()) then
            DoScreenFadeOut(700)
            Wait(700)
            local ped = Client.Player:GetPed()
            local pedCoords = GetEntityCoords(ped)
            local pedHeading = GetEntityHeading(ped)
            local position = Engine["Config"]["Shop"]["vehiclePreview"]

            playerData.oldCoords = {
                x = pedCoords.x,
                y = pedCoords.y,
                z = pedCoords.z,
                w = pedHeading
            }

            Shared.Events:ToServer(Engine["Enums"].Shop.Events.setLastPosition, playerData.oldCoords)

            SetEntityCoords(ped, position.x, position.y + 5, position.z)
            FreezeEntityPosition(ped, true)
            Wait(1200)
            DoScreenFadeIn(700)
        end

        return true
    end

    function self:teleportToLastPosition()
        local ped = Client.Player:GetPed()
        local lastCoords = playerData.oldCoords

        Shared.Events:ToServer(Engine["Enums"].Shop.Events.deleteLastPosition)

        SetEntityCoords(ped, lastCoords.x, lastCoords.y, lastCoords.z)
        SetEntityHeading(ped, lastCoords.w)
        FreezeEntityPosition(ped, false)
    end

    function self:createCamera()
        if (not self:isInShop()) then
            if (playerData.cameraSettings.camera) then
                self:destroyCamera()
            end

            local vehicle = playerData.vehicle
            local vehicleCoords = GetEntityCoords(vehicle)
            local vehicleHeading = GetEntityHeading(vehicle)

            playerData.cameraSettings.azimuth = vehicleHeading - 25.0
            playerData.cameraSettings.elevation = 15
            playerData.cameraSettings.zoomLevel = 5.0

            playerData.cameraSettings.camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            SetCamActive(playerData.cameraSettings.camera, true)
            RenderScriptCams(true, false, 0, true, true)
            
            if (not playerData.cameraSettings.isActive) then
                playerData.cameraSettings.isActive = true
                self:setInShop(true)

                CreateThread(function()
                    while playerData.cameraSettings.camera do
                        SetMouseCursorActiveThisFrame()
                        DisableControlAction(0, 24, true)

                        if (IsControlJustPressed(0, 24) or IsDisabledControlPressed(0, 24)) then
                            local mouseX = GetDisabledControlNormal(0, 1)
                            local mouseY = GetDisabledControlNormal(0, 2)

                            SetMouseCursorSprite(4)
                            playerData.cameraSettings.azimuth = playerData.cameraSettings.azimuth + mouseX * 10.0
                            playerData.cameraSettings.elevation = playerData.cameraSettings.elevation + mouseY * 10.0

                            if (playerData.cameraSettings.elevation > 80.0) then
                                playerData.cameraSettings.elevation = 80.0
                            elseif (playerData.cameraSettings.elevation < -80.0) then
                                playerData.cameraSettings.elevation = -80.0
                            end
                        else
                            SetMouseCursorSprite(1)
                        end

                        local cameraX = vehicleCoords.x + playerData.cameraSettings.zoomLevel * math.cos(math.rad(playerData.cameraSettings.elevation)) * math.sin(math.rad(playerData.cameraSettings.azimuth))
                        local cameraY = vehicleCoords.y + playerData.cameraSettings.zoomLevel * math.cos(math.rad(playerData.cameraSettings.elevation)) * math.cos(math.rad(playerData.cameraSettings.azimuth))
                        local cameraZ = vehicleCoords.z + playerData.cameraSettings.zoomLevel * math.sin(math.rad(playerData.cameraSettings.elevation))

                        SetCamCoord(playerData.cameraSettings.camera, cameraX, cameraY, cameraZ)
                        PointCamAtCoord(playerData.cameraSettings.camera, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)

                        Wait(0)
                    end

                    playerData.cameraSettings.isActive = false
                end)
            end

            return playerData.cameraSettings.camera
        end
    end

    function self:destroyCamera()
        if (playerData.cameraSettings.camera) then
            RenderScriptCams(false, false, 0, true, true)
            DestroyCam(playerData.cameraSettings.camera, true)
            playerData.cameraSettings.camera = nil

            return true
        end

        return false
    end

    ---@param vehicleName string
    function self:enterPreview(vehicleName)
        self:toggleHud(false)
        self:changeBucket()
        if (self:teleportToVehicle()) then
            self:setInvisible(true)
            if (self:createVehicle(vehicleName)) then
                self:createCamera()
            end
        end
    end

    function self:leavePreview()
        if (self:isInShop()) then
            DoScreenFadeOut(700)
            Wait(700)
            self:setInShop(false)
            self:deleteVehicle()
            self:setCurrentVehicle("none")
            self:changeBucket(true)
            self:teleportToLastPosition()
            self:setInvisible(false)
            self:destroyCamera()
            Wait(1200)
            DoScreenFadeIn(700)
            self:toggleHud(true)
        end
    end

    function self:getVehiclePrice(index)
        if (type(index) == "number") then
            local vehicle = Engine["Config"]["Shop"]["vehicles"][index]
            if (vehicle) then
                return vehicle.price
            end
        end

        return 0
    end

    function self:getLimitedVehiclePrice(index)
        if (type(index) == "number") then
            local vehicle = limitedVehicles[index]

            if (vehicle ~= nil) then
                return vehicle.price
            end
        end

        return 0
    end

    function self:getLimitedVehicleQuantity(index)
        if (type(index) == "number") then
            local vehicle = limitedVehicles[index]

            if (vehicle ~= nil) then
                return vehicle.quantity
            end
        end

        return 0
    end

    function self:getReduction()
        local reduction = Engine["Config"]["Shop"]["vipReduction"]
        local multiplier = 1 - (reduction / 100)

        return multiplier, reduction
    end

    function self:buyVehicle(index)
        if (type(index) == "number") then
            local price = self:getVehiclePrice(index)
            local isVip = Client.Vip:isPlayerVip()
            local multiplier, reduction = self:getReduction()
            local vipPrice = price * multiplier
            local finalPrice = isVip and vipPrice or price
            local playerCoins = self:getCoins()
            local vehicle = Engine["Config"]["Shop"]["vehicles"][index]

            if (vehicle) then
                if (playerCoins >= finalPrice) then
                    local confirmation = Game.ImputText:KeyboardImput(string.format("Confirmation d'achat du véhicule %s (%s OneCoins)", vehicle.label, math.floor(finalPrice)), {
                        {type = "input", placeholder = "Mettre \"oui\" pour confirmer", required = true}
                    })

                    if (confirmation ~= nil) then
                        if (Game.ImputText:InputIsValid(confirmation[1], "string")) then
                            if (confirmation[1]:lower() == "oui") then
                                Shared.Events:ToServer(Engine["Enums"].Shop.Events.buyVehicle, index)
                            end
                        end
                    end
                else
                    Game.Notification:showNotification("Vous n'avez pas assez de OneCoins pour acheter ce véhicule", false)
                end
            end
        end
    end

    function self:buyLimitedVehicle(index)
        if (type(index) == "number") then
            local vehicle = limitedVehicles[index]

            if (vehicle) then
                local price = vehicle.price
                local isVip = Client.Vip:isPlayerVip()
                local multiplier, reduction = self:getReduction()
                local vipPrice = price * multiplier
                local finalPrice = isVip and vipPrice or price
                local playerCoins = self:getCoins()

                if (playerCoins >= finalPrice) then
                    local confirmation = Game.ImputText:KeyboardImput(string.format("Confirmation d'achat du véhicule %s (%s OneCoins)", vehicle.label, math.floor(finalPrice)), {
                        {type = "input", placeholder = "Mettre \"oui\" pour confirmer", required = true}
                    })

                    if (confirmation ~= nil) then
                        if (Game.ImputText:InputIsValid(confirmation[1], "string")) then
                            if (confirmation[1]:lower() == "oui") then
                                Shared.Events:ToServer(Engine["Enums"].Shop.Events.buyLimitedVehicle, index)
                            end
                        end
                    end
                else
                    Game.Notification:showNotification("Vous n'avez pas assez de OneCoins pour acheter ce véhicule", false)
                end
            end
        end
    end

    function self:requestLimitedVehicles()
        limitedVehicles = nil
        Shared.Events:ToServer(Engine["Enums"].Shop.Events.requestLimitedVehicles)
    end

    function self:setLimitedVehicles(data)
        if (type(data) == "table") then
            limitedVehicles = data
        end
    end

    function self:getLimitedVehicles()
        return limitedVehicles
    end

    function self:buyMysteryBox(index)
        if (type(index) == "number") then
            local mystery = Engine["Config"]["Shop"]["mystery"][index]
            local playerCoins = self:getCoins()

            if (mystery) then
                if (playerCoins >= mystery.price) then
                    Shared.Events:ToServer(Engine["Enums"].Shop.Events.buyMysteryBox, index)
                else
                    Game.Notification:showNotification("Vous n'avez pas assez de OneCoins pour acheter ce conteneur", false)
                end
            end
        end
    end

    function self:buyPackage(index, username)
        if (type(index) == "number") then
            local package = Engine["Config"]["Shop"]["Package"][index]
            local playerCoins = self:getCoins()

            if (package) then
                if (playerCoins >= package.price) then
                    Shared.Events:ToServer(Engine["Enums"].Shop.Events.buyPackage, index, username)
                else
                    Game.Notification:showNotification("Vous n'avez pas assez de OneCoins pour acheter ce package", false)
                end
            end
        end
    end

    function self:buyWeapon(index)
        if (type(index) == "number") then
            local weapon = Engine["Config"]["Shop"]["weapons"][index]
            local playerCoins = self:getCoins()

            if (weapon) then
                if (playerCoins >= weapon.price) then
                    Shared.Events:ToServer(Engine["Enums"].Shop.Events.buyWeapon, index)
                else
                    Game.Notification:showNotification("Vous n'avez pas assez de OneCoins pour acheter cette arme", false)
                end
            end
        end
    end

    function self:buyExWeapon(index)
        if (type(index) == "number") then
            local weapon = Engine["Config"]["Shop"]["ex_weapons"][index]
            local playerCoins = self:getCoins()

            if (weapon) then
                if (playerCoins >= weapon.price) then
                    Shared.Events:ToServer(Engine["Enums"].Shop.Events.buyExWeapon, index)
                else
                    Game.Notification:showNotification("Vous n'avez pas assez de OneCoins pour acheter cette arme", false)
                end
            end
        end
        
    end

    return self
end)