---@overload fun(): ClothesListener
ClothesListener = Class.new(function(class)

    ---@class ClothesListener: BaseObject
    local self = class
    local mainMenu = nil
    local hasAddInstructionButton = false
    local peds = {}
    local cameraSettings = {
        camera = nil,
        isActive = false,
        boneCoords = nil,
        azimuth = nil,
        elevation = nil,
        zoomLevel = nil,
        bodyPart = "none"
    }
    local playerData = {
        inShop = false,
        interiorID = 0,
        actualOutfit = {},
        underpants = nil,
        outfits = nil,
        needPlayerInvisible = false,
        invisiblePlayers = {}
    }

    ---@private
    function self:Constructor()
        Shared:Initialized("ClothesListener")
        mainMenu = clothesStorage:Get("main_menu")
        self:initialize()
    end

    ---@private
    function self:initialize()
        CreateThread(function()
            for interiorID, v in pairs(Engine["Config"]["ClothesShop"]["Shop"]) do
                local ped = Engine["Config"]["ClothesShop"]["Shop"][interiorID]["ped"]
        
                if (ped) then
                    Game.Peds:Spawn(ped.model, ped.position, ped.heading, true, true, function(entity)
                        peds[interiorID] = entity
                    end)

                    Game.Blip("ClothesShop#"..interiorID,
                        {
                            coords = ped.position,
                            label = Engine["Config"]["ClothesShop"]["Shop"][interiorID]["BlipName"],
                            sprite = 73,
                            color = 17,
                            scale = 0.5,
                        }
                    )
                end
            end
        end)

        CreateThread(function()
            local interval = 1000

            while (true) do
                if (Client.Player ~= nil) then
                    local player = Client.Player:GetPed()
                    local interiorID = GetInteriorFromEntity(player)

                    if (interiorID ~= 0 and not self:isPlayerInShop()) then
                        if (self:doesShopExist(interiorID)) then
                            if (self:onEntered(interiorID)) then
                                interval = 500
                            end
                        end
                    end

                    if (interiorID == 0 and self:isPlayerInShop()) then
                        if (self:onExited()) then
                            interval = 1000
                        end
                    end
                end

                Wait(interval)
            end
        end)
    end

    ---@private
    function self:checkControls()
        if (self:isPlayerInShop()) then
            local player = Client.Player:GetPed()
            local disabledKeys = Engine["Config"]["ClothesShop"]["DisableKey"]

            SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)

            for i = 1, #disabledKeys do
                local currentKey = disabledKeys[i]

                if (currentKey ~= nil) then
                    DisableControlAction(currentKey.group, currentKey.key, true)
                end
            end
        end
    end

    ---@return boolean
    function self:isInStaffMode()
        return exports["epicenter"]:IsInStaff()
    end

    ---@retun boolean
    function self:IsServerInBlackout()
        return exports.core:IsServerInBlackout()
    end

    ---@private
    ---@param interiorID number
    ---@return boolean
    function self:onEntered(interiorID)
        if (not self:isPlayerInShop()) then
            local player = Client.Player:GetPed()

            if (player) then
                NetworkSetFriendlyFireOption(false)
                SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
                DisablePlayerFiring(player, true)
                self:setPlayerInShop(true, interiorID)
                self:pedSpeak("GENERIC_HI")

                CreateThread(function()
                    while (self:isPlayerInShop()) do
                        if (not mainMenu:IsShowing()) then
                            Game.Notification:ShowHelp("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le magasin")

                            if (IsControlJustReleased(0, Engine["Enums"].Controls["E"])) then
                                if (not self:isInStaffMode()) then
                                    if (not self:IsServerInBlackout()) then
                                        local style = Engine["Config"]["ClothesShop"]["Shop"][interiorID]["menuStyle"]
                                        self:requestActualOutfit()
                                        self:startAnimation(function()
                                            self:setMenuStyle(style)
                                            self:createCamera()
                                            mainMenu:Toggle() 
                                        end)
                                    else
                                        Game.Notification:showNotification("Nous sommes actuellement fermé repassez plus tard")
                                    end
                                else
                                    Game.Notification:showNotification("Vous pouvez pas faire cela en mode staff", false)
                                end
                            end
                        end

                        self:checkControls()
                        Wait(0)
                    end
                end)

                return true
            end
        end

        return false
    end

    ---@private
    ---@return boolean
    function self:onExited()
        if (self:isPlayerInShop()) then
            local player = Client.Player:GetPed()

            if (player) then
                NetworkSetFriendlyFireOption(true)
                DisablePlayerFiring(player, false)
                self:setPlayerInShop(false)

                if (mainMenu:IsShowing()) then
                    mainMenu:Close()
                end

                if (cameraSettings.camera) then
                    self:destroyCamera()
                end

                return true
            end
        end

        return false
    end

    ---@return boolean
    function self:isPlayerInShop()
        return playerData.inShop
    end

    ---@return number
    function self:getInteriorID()
        return playerData.interiorID
    end

    ---@param bool boolean
    ---@param interiorID? number
    function self:setPlayerInShop(bool, interiorID)
        if (type(bool) == "boolean") then
            playerData.inShop = bool
            playerData.interiorID = interiorID or 0
        end
    end

    ---@param interiorID number
    ---@return entity
    function self:getPedFromInteriorID(interiorID)
        return peds[interiorID]
    end

    ---@param text string
    function self:pedSpeak(text)
        local ped = self:getPedFromInteriorID(self:getInteriorID())

        if (ped) then
            PlayPedAmbientSpeechNative(ped, text, "Speech_Params_Force_Shouted_Critical")
        end
    end

    ---@param interiorID number
    ---@return boolean
    function self:doesShopExist(interiorID)
        return Engine["Config"]["ClothesShop"]["Shop"][interiorID] ~= nil
    end

    function self:setMenuStyle(style)
        local menuStyle = Engine["Config"]["ClothesShop"]["MenuStyle"][style] or "interaction_binco"
        local menuColor = Engine["Config"]["ClothesShop"]["MenuColors"][style] or {R = 52, G = 123, B = 200, A = 255}

        for k, v in pairs(clothesStorage:GetAll()) do
            local menu = clothesStorage:Get(k)

            menu:SetSpriteBanner("commonmenu", menuStyle)
            menu:SetButtonColor(menuColor.R, menuColor.G, menuColor.B, menuColor.A)

            if (not hasAddInstructionButton) then
                menu:AddInstructionButton({
                    GetControlInstructionalButton(0, 221, 0),
                    "Haut - Bas"
                })
                menu:AddInstructionButton({
                    GetControlInstructionalButton(0, 220, 0),
                    "Gauche - Droite"
                })
                menu:AddInstructionButton({
                    GetControlInstructionalButton(0, 24, 0),
                    "Bouger la caméra"
                })
            end
        end

        hasAddInstructionButton = true
    end

    function self:startAnimation(callback)
        local player = Client.Player:GetPed()
        local dict = "anim@heists@heist_corona@team_idles@male_a"
        local anim = "idle"

        if (player) then
            Game.Streaming:RequestAnimDict(dict, function()
                FreezeEntityPosition(player, true)
                TaskPlayAnim(player, dict, anim, 8.0, -8, -1, 49, 0, true, true, true)
                callback(true)
            end)
        end
    end

    function self:stopAnimation()
        local player = Client.Player:GetPed()

        if (player) then
            Client.Player:ClearTasks()
            FreezeEntityPosition(player, false)
        end
    end

    ---@param bodyPart? "head" | "torso" | "legs" | "foot"
    ---@return camera
    function self:createCamera(bodyPart)
        if (cameraSettings.bodyPart ~= bodyPart) then
            if (cameraSettings.camera) then
                self:destroyCamera()
            end

            local ped = Client.Player:GetPed()
            local pedCoords = GetEntityCoords(ped)
            local pedHeading = GetEntityHeading(ped)
            cameraSettings.boneCoords = nil
            cameraSettings.azimuth = pedHeading + 180.0
            cameraSettings.elevation = 10
            cameraSettings.zoomLevel = 1.5

            if (bodyPart == "head") then
                cameraSettings.zoomLevel = 0.7
                cameraSettings.boneCoords = GetPedBoneCoords(ped, 0x796E)
            elseif (bodyPart == "torso") then
                cameraSettings.zoomLevel = 1.0
                cameraSettings.boneCoords = GetPedBoneCoords(ped, 0x60F0)
            elseif (bodyPart == "legs") then
                cameraSettings.zoomLevel = 1.0
                cameraSettings.boneCoords = GetPedBoneCoords(ped, 0xF9BB)
            elseif (bodyPart == "foot") then
                cameraSettings.zoomLevel = 0.7
                cameraSettings.boneCoords = GetPedBoneCoords(ped, 0x3779)
            else
                cameraSettings.zoomLevel = 2.0
                cameraSettings.boneCoords = vector3(pedCoords.x, pedCoords.y, pedCoords.z)
            end

            cameraSettings.bodyPart = bodyPart

            cameraSettings.camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            SetCamActive(cameraSettings.camera, true)
            RenderScriptCams(true, false, 0, true, true)
            
            if (not cameraSettings.isActive) then
                cameraSettings.isActive = true

                CreateThread(function()
                    while cameraSettings.camera do
                        SetMouseCursorActiveThisFrame()

                        if (IsControlJustPressed(0, 24) or IsDisabledControlPressed(0, 24)) then
                            local mouseX = GetDisabledControlNormal(0, 1)
                            local mouseY = GetDisabledControlNormal(0, 2)

                            SetMouseCursorSprite(4)
                            cameraSettings.azimuth = cameraSettings.azimuth + mouseX * 10.0
                            cameraSettings.elevation = cameraSettings.elevation + mouseY * 10.0

                            if (cameraSettings.elevation > 80.0) then
                                cameraSettings.elevation = 80.0
                            elseif (cameraSettings.elevation < -80.0) then
                                cameraSettings.elevation = -80.0
                            end
                        else
                            SetMouseCursorSprite(1)
                        end

                        local cameraX = cameraSettings.boneCoords.x + cameraSettings.zoomLevel * math.cos(math.rad(cameraSettings.elevation)) * math.sin(math.rad(cameraSettings.azimuth))
                        local cameraY = cameraSettings.boneCoords.y + cameraSettings.zoomLevel * math.cos(math.rad(cameraSettings.elevation)) * math.cos(math.rad(cameraSettings.azimuth))
                        local cameraZ = cameraSettings.boneCoords.z + cameraSettings.zoomLevel * math.sin(math.rad(cameraSettings.elevation))

                        SetCamCoord(cameraSettings.camera, cameraX, cameraY, cameraZ)
                        PointCamAtCoord(cameraSettings.camera, cameraSettings.boneCoords.x, cameraSettings.boneCoords.y, cameraSettings.boneCoords.z)

                        Wait(0)
                    end

                    cameraSettings.isActive = false
                end)
            end
        end

        return cameraSettings.camera
    end

    ---@return boolean
    function self:destroyCamera()
        if (cameraSettings.camera) then
            RenderScriptCams(false, false, 0, true, true)
            DestroyCam(cameraSettings.camera, true)
            cameraSettings.camera = nil
            cameraSettings.bodyPart = "none"

            return true
        end

        return false
    end

    function self:requestActualOutfit()
        TriggerEvent('skinchanger:getSkin', function(outfit)
            local skin = {
                ["pants_1"] = tonumber(outfit.pants_1), 
                ["pants_2"] = tonumber(outfit.pants_2), 
                ["tshirt_1"] = tonumber(outfit.tshirt_1), 
                ["tshirt_2"] = tonumber(outfit.tshirt_2), 
                ["bproof_1"] = tonumber(outfit.bproof_1), 
                ["bproof_2"] = tonumber(outfit.bproof_2), 
                ["torso_1"] = tonumber(outfit.torso_1), 
                ["torso_2"] = tonumber(outfit.torso_2), 
                ["arms"] = tonumber(outfit.arms), 
                ["arms_2"] = tonumber(outfit.arms_2), 
                ["decals_1"] = tonumber(outfit.decals_1), 
                ["decals_2"] = tonumber(outfit.decals_2),
                ["mask_1"] = tonumber(outfit.mask_1),
                ["mask_2"] = tonumber(outfit.mask_2),
                ["helmet_1"] = tonumber(outfit.helmet_1),
                ["helmet_2"] = tonumber(outfit.helmet_2),
                ["shoes_1"] = tonumber(outfit.shoes_1), 
                ["shoes_2"] = tonumber(outfit.shoes_2), 
                ["chain_1"] = tonumber(outfit.chain_1), 
                ["chain_2"] = tonumber(outfit.chain_2),
                ["ears_1"] = tonumber(outfit.ears_1), 
                ["ears_2"] = tonumber(outfit.ears_2),
                ["watches_1"] = tonumber(outfit.watches_1), 
                ["watches_2"] = tonumber(outfit.watches_2),
                ["glasses_1"] = tonumber(outfit.glasses_1), 
                ["glasses_2"] = tonumber(outfit.glasses_2),
                ["bracelets_1"] = tonumber(outfit.bracelets_1), 
                ["bracelets_2"] = tonumber(outfit.bracelets_2),
                ["bags_1"] = tonumber(outfit.bags_1), 
                ["bags_2"] = tonumber(outfit.bags_2),
            }

            playerData.actualOutfit = skin
        end)
    end

    ---@param clothesType string
    ---@return number
    function self:getActualClothe(clothesType)
        return playerData.actualOutfit[clothesType]
    end

    function self:getActualOutfit()
        return playerData.actualOutfit
    end

    function self:resetOutfit()
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent('skinchanger:loadClothes', skin, self:getActualOutfit())
        end)
    end

    ---@param propIndex number
    function self:loadProps(propIndex)
        local player = Client.Player:GetPed()
        local maxPropsVariants = GetNumberOfPedPropDrawableVariations(player, propIndex)
        local variants = {}
        local textures = {}

        for i = 0, maxPropsVariants -1 do
            local maxTextures = GetNumberOfPedPropTextureVariations(player, propIndex, i)
            local texturesCount = {}

            for k = 1, maxTextures - 1 do
                table.insert(texturesCount, k)
            end

            variants[i] = i
            textures[i] = next(texturesCount) ~= nil and texturesCount or {1}
        end

        return variants, textures
    end

    ---@param componentIndex number
    function self:loadClothes(componentIndex)
        local player = Client.Player:GetPed()
        local maxComponentsVariants = GetNumberOfPedDrawableVariations(player, componentIndex)
        local variants = {}
        local textures = {}

        for i = 0, maxComponentsVariants - 1 do
            local maxTextures = GetNumberOfPedTextureVariations(player, componentIndex, i)
            local texturesCount = {}

            for k = 1, maxTextures - 1 do
                table.insert(texturesCount, k)
            end

            variants[i] = i
            textures[i] = next(texturesCount) ~= nil and texturesCount or {1}
        end

        return variants, textures
    end

    ---@param data table
    function self:setUnderpants(data)
        if (type(data) == "table") then
            playerData.underpants = data
        end
    end

    function self:getUnderpants()
        return playerData.underpants
    end

    function self:undress()
        local player = Client.Player:GetPed()
        local sex = (GetEntityModel(player) == GetHashKey("mp_m_freemode_01") and "male") or "female"
        local undress = Engine["Config"]["ClothesShop"]["Undress"][sex]

        if (undress) then
            TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerEvent('skinchanger:loadClothes', skin, undress)
            end)
        end
    end

    function self:requestOutfits()
        outfits = nil
        Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.requestOutfits)
    end

    function self:setOutfits(data)
        if (type(data) == "table") then
            playerData.outfits = data
        end
    end

    function self:getOutfits()
        return playerData.outfits
    end

    function self:takeOutfit(index)
        if (type(index) == "number") then
            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.takeOutfit, index)
        end
    end

    function self:renameOutfit(index, name)
        if (type(index) == "number" and type(name) == "string") then
            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.renameOutfit, index, name)
        end
    end

    function self:deleteOutfit(index)
        if (type(index) == "number") then
            Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.deleteOutfit, index)
        end
    end

    function self:saveOutfit(name)
        if (type(name) == "string") then
            local player = Client.Player:GetPed()

            TriggerEvent('skinchanger:getSkin', function(outfit)
                local skin = {
                    ["pants_1"] = tonumber(outfit.pants_1), 
                    ["pants_2"] = tonumber(outfit.pants_2),
                    ["tshirt_1"] = tonumber(outfit.tshirt_1), 
                    ["tshirt_2"] = tonumber(outfit.tshirt_2), 
                    ["bproof_1"] = tonumber(outfit.bproof_1),
                    ["bproof_2"] = tonumber(outfit.bproof_2),
                    ["torso_1"] = tonumber(outfit.torso_1),
                    ["torso_2"] = tonumber(outfit.torso_2),
                    ["arms"] = tonumber(outfit.arms),
                    ["arms_2"] = tonumber(outfit.arms_2),
                    ["decals_1"] = tonumber(outfit.decals_1),
                    ["decals_2"] = tonumber(outfit.decals_2),
                    ["mask_1"] = tonumber(outfit.mask_1),
                    ["mask_2"] = tonumber(outfit.mask_2),
                    ["helmet_1"] = tonumber(outfit.helmet_1),
                    ["helmet_2"] = tonumber(outfit.helmet_2),
                    ["shoes_1"] = tonumber(outfit.shoes_1),
                    ["shoes_2"] = tonumber(outfit.shoes_2),
                    ["chain_1"] = tonumber(outfit.chain_1),
                    ["chain_2"] = tonumber(outfit.chain_2),
                    ["ears_1"] = tonumber(outfit.ears_1),
                    ["ears_2"] = tonumber(outfit.ears_2),
                    ["watches_1"] = tonumber(outfit.watches_1),
                    ["watches_2"] = tonumber(outfit.watches_2),
                    ["glasses_1"] = tonumber(outfit.glasses_1),
                    ["glasses_2"] = tonumber(outfit.glasses_2),
                    ["bracelets_1"] = tonumber(outfit.bracelets_1),
                    ["bracelets_2"] = tonumber(outfit.bracelets_2),
                    ["bags_1"] = tonumber(outfit.bags_1),
                    ["bags_2"] = tonumber(outfit.bags_2)
                }

                Shared.Events:ToServer(Engine["Enums"].ClothesShop.Events.saveOutfit, name, skin)
            end)
        end
    end

    function self:makeAnimation(dict, anim, flag, time, callback)
        local ped = Client.Player:GetPed()

        if (ped) then
            Game.Streaming:RequestAnimDict(dict, function()
                if (Client.Player:IsInAnyVehicle()) then
                    flag = 51
                end
        
                TaskPlayAnim(ped, dict, anim, 3.0, 3.0, time, flag, 0, false, false, false)
            end)

            local waitMS = time - 500

            if (waitMS < 500) then
                waitMS = 500
            end

            Wait(waitMS)
            callback()
        end
    end

    return self
end)