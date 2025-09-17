---@overload fun(): Mecano
Mecano = Class.new(function(class)

    ---@class Mecano: BaseObject
    local self = class
    local vehicleInCustom = {}
    local playersInCustom = {}
    local outfit = {}
    local craftItem = {}

    function self:Constructor()
        self:loadClothes()
    end

    ---@return boolean
    function self:loadClothes()
        local loadedClothes = LoadResourceFile("engine_json", "JSON/mecano_cloakroom.json")
        local converted = loadedClothes and json.decode(loadedClothes)

        outfit = loadedClothes and type(converted) == "table" and Shared.Table:SizeOf(converted) > 0 and converted or {}

        for k, v in pairs(Engine["Config"]["Mecano"]["Zones"]) do
            if (outfit[v.jobName] == nil) then
                outfit[v.jobName] = {}
            end

            if (outfit[v.jobName]["male"] == nil) then
                outfit[v.jobName]["male"] = {}
            end

            if (outfit[v.jobName]["female"] == nil) then
                outfit[v.jobName]["female"] = {}
            end
        end

        return true
    end

    ---@param vehicle number
    ---@param props table
    ---@param customZone vector3
    ---@param jobName string
    ---@return boolean
    function self:saveDefaultCustomisation(vehicle, props, customZone, jobName, license)
        if (type(vehicle) == "number" and type(props) == "table" and type(customZone) == "vector3" and type(jobName) == "string") then
            if (DoesEntityExist(vehicle)) then
                local networkId = NetworkGetNetworkIdFromEntity(vehicle)
                local plate = GetVehicleNumberPlateText(vehicle)
                local model = GetEntityModel(vehicle)

                vehicleInCustom[plate] = {
                    networkId = networkId,
                    plate = plate,
                    handle = vehicle,
                    model = model,
                    props = props,
                    customZone = customZone,
                    jobName = jobName
                }

                playersInCustom[license] = true

                return true
            end
        end

        return false
    end

    ---@param plate string
    ---@return number
    function self:getNetworkId(plate)
        return vehicleInCustom[plate].networkId
    end

    ---@param plate string
    ---@return number
    function self:getHandle(plate)
        return vehicleInCustom[plate].handle
    end

    ---@param plate string
    ---@return number
    function self:getModel(plate)
        return vehicleInCustom[plate].model
    end

    ---@param plate string
    ---@return table
    function self:getDefaultProps(plate)
        return vehicleInCustom[plate].props
    end

    ---@param plate string
    ---@return vector3
    function self:getcustomZone(plate)
        return vehicleInCustom[plate].customZone
    end

    ---@param plate string
    ---@return string
    function self:getjobName(plate)
        return vehicleInCustom[plate].jobName
    end

    ---@param plate string
    ---@return boolean
    function self:doesDefaultCustomisationExist(plate)
        return vehicleInCustom[plate] ~= nil
    end

    ---@param plate string
    ---@param license string
    function self:removeDefaultCustomisation(plate, license)
        if (self:doesDefaultCustomisationExist(plate)) then
            vehicleInCustom[plate] = nil
            playersInCustom[license] = nil
        end
    end

    ---@param license string
    ---@return boolean
    function self:isPlayerInCustom(license)
        return playersInCustom[license] ~= nil
    end

    ---@param jobName string
    ---@param percentage number
    function self:setPercentage(jobName, percentage)
        local kvpName = string.format("mecano_percentage_%s", jobName)
        local percentage = tonumber(percentage) or Engine["Config"]["Mecano"]["Zones"][jobName].minPercentage

        SetResourceKvp(kvpName, tonumber(percentage))
    end

    ---@param jobName string
    ---@return number
    function self:getPercentage(jobName)
        local kvpName = string.format("mecano_percentage_%s", jobName)

        return tonumber(GetResourceKvpString(kvpName) or Engine["Config"]["Mecano"]["Zones"][jobName].minPercentage)
    end

    ---@param jobName string
    ---@param sex string | "male" | "female"
    ---@return table
    function self:getClothes(jobName, sex)
        return outfit[jobName][sex] or {}
    end

    function self:getOutfit(jobName, sex, name)
        if (self:doesClothesNameExist(jobName, sex, name)) then
            return outfit[jobName][sex][name]
        end

        return nil
    end

    ---@param jobName string
    ---@param name string
    ---@param sex string
    ---@param clothes table
    ---@return boolean
    function self:addClothes(jobName, name, sex, clothes)
        if (type(jobName) == "string" and type(name) == "string" and type(clothes) == "table") then
            if (outfit[jobName] == nil) then
                outfit[jobName] = {}
            end

            if (sex == "male" or sex == "female") then
                if ((self:getClothesCount(jobName, sex) + 1) <= 10) then
                    if (not self:doesClothesNameExist(jobName, sex, name)) then
                        outfit[jobName][sex][name] = clothes

                        self:saveClothes()

                        return true
                    else
                        Shared.Log:Error("Clothes name already exist")
                    end
                else
                    Shared.Log:Error("Max clothes count reached")
                end
            else
                Shared.Log:Error("Invalid sex for clothes")
            end
        end

        return false
    end

    ---@param jobName string
    ---@param name string
    ---@param sex string | "male" | "female"
    ---@return boolean
    function self:removeClothes(jobName, sex, name)
        if (type(jobName) == "string" and type(sex) == "string" and type(name) == "string") then
            if (self:doesClothesNameExist(jobName, sex, name)) then
                outfit[jobName][sex][name] = nil
                self:saveClothes()

                return true
            else
                Shared.Log:Error("Clothes name does not exist")
            end
        end

        return false
    end

    function self:getClothesCount(jobName, sex)
        if (outfit[jobName][sex] ~= nil) then
            return Shared.Table:SizeOf(outfit[jobName][sex])
        end

        return 0
    end

    function self:doesClothesNameExist(jobName, sex, name)
        return outfit[jobName][sex][name] ~= nil
    end

    function self:saveClothes()
        SaveResourceFile("engine_json", "JSON/mecano_cloakroom.json", json.encode(outfit), -1)
    end

    ---@param license string
    ---@param item number
    ---@param label string
    ---@param amount number
    function self:setPlayerInCraft(license, item, label, amount)
        if (type(license) == "string" and type(item) == "string" and type(label) == "string" and type(amount) == "number") then
            if (craftItem[license] == nil) then
                craftItem[license] = {}
            end

            craftItem[license] = {
                item = item,
                label = label,
                amount = amount
            }
        end
    end

    ---@param license string
    ---@return boolean
    function self:isPlayerInCraft(license)
        return craftItem[license] ~= nil
    end

    ---@param license string
    ---@return table
    function self:getPlayerCraftItem(license)
        return craftItem[license]
    end

    ---@param license string
    function self:removePlayerInCraft(license)
        if (craftItem[license] ~= nil) then
            craftItem[license] = nil
        end
    end

    return self
end)