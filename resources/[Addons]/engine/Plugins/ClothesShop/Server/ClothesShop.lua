---@overload fun(): ClothesShop
ClothesShop = Class.new(function(class)
    ---@class ClothesShop: BaseObject
    local self = class
    local outfit = {}

    function self:Constructor()
        self:loadClothes()
    end

    ---@param sex string | "male" | "female"
    ---@return table | nil
    function self:getDefaultUnderpants(sex)
        local defaultUnderpants = Engine["Config"]["ClothesShop"]["Underwear"][sex][1]

        if (defaultUnderpants) then
            local selectedUnderpants = {
                texture = defaultUnderpants.texture,
                variant = defaultUnderpants.variant
            }

            return selectedUnderpants
        end

        return nil
    end

    ---@return boolean
    function self:loadClothes()
        local loadedClothes = LoadResourceFile("engine_json", "JSON/saved_clothes.json")
        local converted = loadedClothes and json.decode(loadedClothes)

        outfit = loadedClothes and type(converted) == "table" and Shared.Table:SizeOf(converted) > 0 and converted or {}
        return true
    end

    ---@param identifier string
    ---@return table | nil
    function self:getOutfits(identifier)
        if (type(identifier) == "string") then
            return outfit[identifier]
        end

        return nil
    end

    ---@param identifier string
    ---@param name string
    ---@param skin table
    ---@return boolean
    function self:addOutfit(identifier, name, skin)
        if (type(identifier) == "string" and type(name) == "string" and type(skin) == "table") then
            if (outfit[identifier] == nil) then
                outfit[identifier] = {}
            end

            table.insert(outfit[identifier], {
                name = name,
                skin = skin
            })

            self:saveClothes()
            return true
        end

        return false
    end

    ---@param identifier string
    ---@param index number
    ---@param name string
    ---@return boolean
    function self:renameOutfit(identifier, index, name)
        if (type(identifier) == "string" and type(index) == "number" and type(name) == "string") then
            if (outfit[identifier] ~= nil) then
                outfit[identifier][index].name = name
                self:saveClothes()
                return true
            end
        end

        return false
    end

    ---@param identifier string
    ---@param index number
    ---@return boolean
    function self:removeOutfit(identifier, index)
        if (type(identifier) == "string" and type(index) == "number") then
            if (outfit[identifier] ~= nil) then
                table.remove(outfit[identifier], index)

                if (#outfit[identifier] == 0) then
                    outfit[identifier] = nil
                end

                self:saveClothes()
                return true
            end
        end

        return false
    end

    ---@param identifier string
    ---@return boolean
    function self:removeAllOutfits(identifier)
        if (type(identifier) == "string") then
            if (outfit[identifier] ~= nil) then
                outfit[identifier] = nil
                self:saveClothes()
                return true
            end
        end

        return false
    end

    ---@return boolean
    function self:saveClothes()
        SaveResourceFile("engine_json", "JSON/saved_clothes.json", json.encode(outfit), -1)
        return true
    end

    function self:getItemByComponent(component)
        if (type(component) == "string") then
            if (Engine["Config"]["ClothesShop"]["Items"][component] ~= nil) then
                return Engine["Config"]["ClothesShop"]["Items"][component]
            end
        end

        return nil
    end

    function self:getImageName(sex, itemType, drawable, index)
        if (type(sex) == "string" and type(itemType) == "string" and type(drawable) == "number" and type(index) == "number") then
            local isProp = Engine["Config"]["ClothesShop"]["Animation"][itemType].prop or false
            local clotheIndex = Engine["Config"]["ClothesShop"]["Animation"][itemType].id
            local formatStr = isProp and "%s/%s/%s_prop_%s_%s%s.png" or "%s/%s/%s_%s_%s%s.png"

            return string.format(formatStr, sex, itemType, sex, clotheIndex, drawable, index > 0 and "_" .. index or "")
        end

        return nil
    end

    return self
end)