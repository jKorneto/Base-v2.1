---@overload fun(): MecanoListener
MecanoListener = Class.new(function(class)

    ---@class MecanoListener: BaseObject
    local self = class
    local inService = false
    local inCustom = false
    local inCraft = false
    local vehicleInCustom = {}
    local savePrice = {}
    local outfits = {}
    local percentage = nil
    local price = 0
    local mainMenu = nil

    ---@private
    function self:Constructor()
        mainMenu = mecanoStorage:Get("custom_menu")
    end

    function self:setInService(bool)
        if (type(bool) == "boolean") then
            inService = bool
        end
    end

    ---@return boolean
    function self:isInService()
        return inService
    end

    ---@param bool boolean
    function self:setInCustom(bool)
        if (type(bool) == "boolean") then
            inCustom = bool
        end
    end

    ---@return boolean
    function self:isInCustom()
        return inCustom
    end

    ---@param bool boolean
    function self:setInCraft(bool)
        if (type(bool) == "boolean") then
            inCraft = bool
        end
    end

    ---@return boolean
    function self:isInCraft()
        return inCraft
    end

    ---@return number
    function self:getCustomPrices()
        return price or 0
    end

    function self:setMenuStyle(style)
        local menuStyle = Engine["Config"]["Mecano"]["MenuStyle"][style] or "interaction_mecano"
        local menuColor = Engine["Config"]["Mecano"]["MenuColors"][style] or {R = 203, G = 202, B = 205, A = 255}

        for k, v in pairs(mecanoStorage:GetAll()) do
            local menu = mecanoStorage:Get(k)

            menu:SetSpriteBanner("commonmenu", menuStyle)
            menu:SetButtonColor(menuColor.R, menuColor.G, menuColor.B, menuColor.A)
        end
    end

    ---@param vehicle number
    ---@return boolean
    function self:saveDefaultCustomisation(vehicle)
        if (type(vehicle) == "number" and vehicle ~= 0 and DoesEntityExist(vehicle)) then
            vehicleInCustom = {
                ID = vehicle,
                class = Game.Vehicle:GetClass(vehicle),
                props = Game.Vehicle:GetProperties(vehicle)
            }

            return true
        end

        return false
    end

    ---@return table
    function self:getProps()
        return vehicleInCustom.props
    end

    ---@return number
    function self:getVehicleHandle()
        return vehicleInCustom.ID
    end

    function self:getClass()
        return vehicleInCustom.class
    end

    function self:getPlate()
        return vehicleInCustom.props.plate
    end

    function self:checkVehicleExist()
        if (not DoesEntityExist(self:getVehicleHandle())) then
            self:resetDefaultCustomisation()
        end
    end

    ---@param customType string
    ---@param value any
    function self:editDefaultCustomisation(customType, value)
        if (vehicleInCustom.props[customType]) then
            vehicleInCustom.props[customType] = value
        end
    end

    ---@param customType string
    ---@return table
    function self:getDefaultCustomisationByType(customType)
        return vehicleInCustom.props[customType]
    end

    function self:resetDefaultCustomisation()
        self:closeMenu()

        if (DoesEntityExist(self:getVehicleHandle())) then
            Game.Vehicle:SetHandbrake(self:getVehicleHandle(), false)
        end

        Shared.Events:ToServer(Engine["Enums"].Mecano.Events.resetCustom, GetVehicleNumberPlateText(self:getVehicleHandle()))
        vehicleInCustom = {}
        savePrice = {}
    end

    function self:changeBillState()
        self:closeMenu()

        if (DoesEntityExist(self:getVehicleHandle())) then
            Game.Vehicle:SetHandbrake(self:getVehicleHandle(), false)
        end

        vehicleInCustom = {}
        savePrice = {}
    end

    ---@param customType string
    ---@param value table
    ---@param price number
    function self:addPriceForCustomisation(customType, value, price, label)
        local defaultCustom = self:getDefaultCustomisationByType(customType)

        if (type(defaultCustom) ~= "table" and type(value) ~= "table") then
            if (self:getProps()) then
                if (defaultCustom ~= value) then
                    savePrice[customType] = {price = price, label = label or "Customisation"}
                else
                    savePrice[customType] = nil
                end
            end
        elseif (#defaultCustom == #value) then
            local isDefault = true

            for i = 1, #defaultCustom do
                if (defaultCustom[i] ~= value[i]) then
                    isDefault = false
                    break
                end
            end

            savePrice[customType] = isDefault and nil or {price = price, label = label or "Customisation"}
        end
    end

    function self:addPriceForWheels(wheelType, ID, price, label)
        local defaultWheels = self:getDefaultCustomisationByType("modFrontWheels")
        local defaultWheelsType = self:getDefaultCustomisationByType("wheels")

        if (type(defaultWheels) == "number" and type(defaultWheelsType) == "number") then
            if (defaultWheels ~= ID or defaultWheelsType ~= wheelType) then
                savePrice["modFrontWheels"] = {price = price, label = label or "Customisation"}

                if (defaultWheelsType == wheelType and defaultWheels == ID) then
                    savePrice["modFrontWheels"] = nil
                end
            else
                savePrice["modFrontWheels"] = nil
            end
        end
    end

    function self:getAllPrices()
        return savePrice
    end

    function self:getMultiplier()
        local vehicleClass = self:getClass()
        local multiplier = Engine["Config"]["Mecano"]["Multiplier"]

        return multiplier[vehicleClass] or 1.0
    end

    ---@param customType string
    ---@return number | table
    function self:getPriceForCustomisation(customType)
        if (type(Engine["Config"]["Mecano"]["Prices"][customType]) == "table") then
            local data = {}

            for i = 0, #Engine["Config"]["Mecano"]["Prices"][customType] do
                if (Engine["Config"]["Mecano"]["Prices"][customType][i] ~= nil) then
                    local price = Engine["Config"]["Mecano"]["Prices"][customType][i] * self:getMultiplier()
                    
                    data[i] = price
                end
            end

            return data
        end

        return Engine["Config"]["Mecano"]["Prices"][customType] * self:getMultiplier()
    end

    function self:calculatePrice()
        price = 0

        for k, v in pairs(savePrice) do
            if (v) then
                price = price + v.price
            end
        end
        
        return price
    end

    function self:removePriceForCustomisation(customType)
        savePrice[customType] = nil
    end
    
    ---@param vehicle number
    ---@param selectedZone table
    function self:openMenu(vehicle, selectedZone)
        if (not mainMenu:IsShowing()) then
            if (vehicle and vehicle ~= 0 and DoesEntityExist(vehicle)) then
                Game.Vehicle:SetCustomizable(vehicle)
                Game.Vehicle:SetHandbrake(vehicle, true)
                self:saveDefaultCustomisation(vehicle)
                self:setInCustom(true)
                self:showMoneyBar()
                Shared.Events:ToServer(Engine["Enums"].Mecano.Events.startCustom, self:getProps(), selectedZone.customZone, selectedZone.jobName)
                mainMenu:SetData("selected_custom", {job = selectedZone.jobName, type = selectedZone.customType})
                mainMenu:Toggle()
            else
                Game.Notification:showNotification("Vous devez être dans un véhicule pour faire cela", false)
            end
        end
    end

    function self:closeMenu()
        if (mainMenu:IsShowing()) then
            mainMenu:Close()
        end

        self:setInCustom(false)
        mainMenu:SetData("selected_custom", nil)
    end

    function self:showMoneyBar()
        local function DrawAdvancedText(text, x, y, color, font)
            SetTextFont(ServerFontStyle)
            SetTextScale(0.0, 0.30)
            SetTextColour(color[1], color[2], color[3], color[4])
            SetTextCentre(true)
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName(text)
            EndTextCommandDisplayText(x, y)
        end
    
        local safeZone = GetSafeZoneSize()
        local safeZoneX = (1.0 - safeZone) * 0.5
        local safeZoneY = (1.0 - safeZone) * 0.5
        local drawX = 0.950 - safeZoneX
        local drawY = 0.945 - safeZoneY
    
        CreateThread(function()
            while self:isInCustom() do
                local price = Shared.Math:GroupDigits(self:calculatePrice())

                DrawSprite("timerbars", "all_black_bg", drawX, drawY, 0.1, 0.03, 0.0, 0, 0, 0, 180)
                DrawAdvancedText("Cout : " .. price .. " ~g~$~s~", drawX, drawY - 0.015, {255, 255, 255, 255}, 4)
                self:checkVehicleExist()
                Wait(0)
            end
        end)
    end

    ---@return number
    function self:getPercentage()
        return tonumber(percentage)
    end

    ---@param amount number
    function self:setPercentage(amount)
        percentage = amount
    end

    function self:requestPercentage()
        percentage = nil
        Shared.Events:ToServer(Engine["Enums"].Mecano.Events.requestPercentage)
    end

    function self:getClothes()
        return outfits
    end

    ---@param clothes table
    function self:setClothes(clothes)
        if (type(clothes) == "table") then  
            outfits = clothes
        end
    end

    ---@param sex string | "male" | "female"
    function self:requestClothes(sex)
        outfits = nil
        Shared.Events:ToServer(Engine["Enums"].Mecano.Events.requestClothes, sex)
    end

    ---@param name string
    ---@param sex string
    function self:addClothes(name, sex)
        if (type(name) == "string" and type(sex) == "string") then
            TriggerEvent('skinchanger:getSkin', function(clothe)
                local outfit = {
                    ["pants_1"] = tonumber(clothe.pants_1), 
                    ["pants_2"] = tonumber(clothe.pants_2), 
                    ["tshirt_1"] = tonumber(clothe.tshirt_1), 
                    ["tshirt_2"] = tonumber(clothe.tshirt_2), 
                    ["bproof_1"] = tonumber(clothe.bproof_1), 
                    ["bproof_2"] = tonumber(clothe.bproof_2), 
                    ["torso_1"] = tonumber(clothe.torso_1), 
                    ["torso_2"] = tonumber(clothe.torso_2), 
                    ["arms"] = tonumber(clothe.arms), 
                    ["arms_2"] = tonumber(clothe.arms_2), 
                    ["decals_1"] = tonumber(clothe.decals_1), 
                    ["decals_2"] = tonumber(clothe.decals_2),
                    ["mask_1"] = tonumber(clothe.mask_1),
                    ["mask_2"] = tonumber(clothe.mask_2),
                    ["helmet_1"] = tonumber(clothe.helmet_1),
                    ["helmet_2"] = tonumber(clothe.helmet_2),
                    ["shoes_1"] = tonumber(clothe.shoes_1), 
                    ["shoes_2"] = tonumber(clothe.shoes_2), 
                    ["chain_1"] = tonumber(clothe.chain_1), 
                    ["chain_2"] = tonumber(clothe.chain_2),
                    ["ears_1"] = tonumber(clothe.ears_1), 
                    ["ears_2"] = tonumber(clothe.ears_2),
                    ["watches_1"] = tonumber(clothe.watches_1), 
                    ["watches_2"] = tonumber(clothe.watches_2),
                    ["glasses_1"] = tonumber(clothe.glasses_1), 
                    ["glasses_2"] = tonumber(clothe.glasses_2),
                    ["bracelets_1"] = tonumber(clothe.bracelets_1), 
                    ["bracelets_2"] = tonumber(clothe.bracelets_2),
                    ["bags_1"] = tonumber(clothe.bags_1), 
                    ["bags_2"] = tonumber(clothe.bags_2)
                }
                
                Shared.Events:ToServer(Engine["Enums"].Mecano.Events.addClothes, name, sex, outfit)
            end)
        end
    end

    ---@param name string
    ---@param sex string
    function self:removeClothes(name, sex)
        if (type(name) == "string" and type(sex) == "string") then
            Shared.Events:ToServer(Engine["Enums"].Mecano.Events.removeClothes, name, sex)
        end
    end

    function self:removeClothesByName(name)
        if (type(name) == "string") then
            outfits[name] = nil
        end
    end

    function self:takeOutfit(outfit)
        if (type(outfit) == "table") then
            TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerEvent('skinchanger:loadClothes', skin, outfit)
            end)
        end
    end

    return self
end)