---@type Shared
Shared = Class.new(function(class)

    ---@class Shared: BaseObject
    local self = class

    function self:Constructor()

        self.colors = {
            blue = "~b~",
            purple = "~p~",
            yellow = "~y~",
            green = "~g~",
            red = "~r~",
            black = "~b~",
            orange = "~o~"
        }

        self.Lang = Lang()
        self.Log = Log()

        self:LoadESX()

        self.Math = Math
        self.String = String()
        self.Storage = StorageManager()
        self.Table = Table
        self.Vehicle = UVehicle()
        self.Timer = Timer
        self.Events = NetworkEvents()
        self.Commands = {}

        self:Initialized("Shared")
    end

    function self:LoadESX()
        ESX = exports["Framework"]:getSharedObject()

        if (ESX) then
            self.Log:Success("ESX loaded.")
            SetTimeout(1500, function()
                TriggerEvent("engine:esx:loaded")
            end)
        else
            self.Log:Error("ESX not loaded. Aborting.")
            self:Shutdown()
        end
    end

    ---Close the server
    function self:Shutdown()
        if (IsDuplicityVersion()) then
            SetTimeout(200, os.exit)
            self.Log:Info("Shutting down...")
        end
    end

    ---@Crédits go to https://gist.github.com/jrus
    ---@param template string ex: '4xxx-yxxx'
    ---@return string
    function self:Uuid(template)
        local temp = template or 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'

        return string.gsub(temp, '[xy]', function (c)
            local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
            return string.format('%x', v)
        end)
    end

    ---@param ObjectName string
    function self:Initialized(ObjectName)
        return self.Log:Debug(string.format("^7[ ^6%s ^7]^0 initialized.", ObjectName))
    end
    
    ---@return table
    function self:GetCommands()
        return self.Commands
    end

    ---@param commandName string
    ---@param callback fun(xPlayer: xPlayer, args: table)
    ---@param adminOnly table
    function self:RegisterCommand(commandName, callback, suggestion, adminOnly)
        local is_server = IsDuplicityVersion()

        if type(suggestion) == "table" then
            if type(suggestion.params) ~= "table" then
                suggestion.params = {}
            end

            if type(suggestion.help) ~= "string" then
                suggestion.help = ""
            end

            table.insert(self.Commands, {name = ("/%s"):format(commandName:lower()), help = suggestion.help, params = suggestion.params})
        end

        return RegisterCommand(commandName, function(source, args)
            if (is_server) then
                local playerId = source
                local Player = ESX.GetPlayerFromId(playerId)

                if (playerId ~= 0 and Player == nil) then
                    return
                end
                
                if (callback) then callback(Player, args) end
            else
                if (callback) then callback(args) end
            end
        end, false)

    end

    ---@param commandName string
    ---@param description table label: string, args: any
    ---@param defaultKey string
    ---@param callback fun(args: table)
    function self:RegisterKeyMapping(commandName, description, defaultKey, callback)
        description = type(description) == "table" and description or { label = "No label set" }

        if (not IsDuplicityVersion()) then
            self:RegisterCommand(commandName, callback)
            RegisterKeyMapping(commandName, description.label,
                "keyboard",
                defaultKey
            )
        else
            self.Log:error("Shared:RegisterKeyMapping(): This method is client only.")
        end
    end

    ---Get user defined server name
    ---@return string
    function self:ServerName()
        return Engine["Config"]["ServerName"] or "ServerName"
    end

    ---Get user defined server color
    ---@return string
    function self:ServerColor()
        return self.colors[Engine["Config"]["ServerColor"]] or "~HUD_COLOUR_PURE_WHITE~"
    end

    ---Get user defined server code color
    ---@return string
    function self:ServerColorCode()
        return self.colors[Engine["Config"]["ServerColorCode"]] or "~HUD_COLOUR_PURE_WHITE~"
    end

        ---@return boolean
        function self:IsJob2Enabled()
            return Engine["Config"]["Job2Enabled"];
        end
    

    ---@param var any
    ---@return boolean
    function self:IsString(var)
        return type(var) == "string"
    end

    ---@param var any
    ---@return boolean
    function self:IsNumber(var)
        return type(var) == "number"
    end

    ---@param var any
    ---@return boolean
    function self:IsBoolean(var)
        return type(var) == "boolean"
    end

    ---@param weaponName string
    ---@return boolean
    function self:IsWeaponPermanent(weaponName)
        local config = Engine["Config"]["PermanantWeapons"]

        for i = 1, #config do
            if (string.upper(config[i]) == string.upper(weaponName)) then
                return true
            end
        end

        return false
    end

    function self:IsItemPermanent(itemName)
        local config = Engine["Config"]["PermanantItems"]

        for i = 1, #config do
            if (string.lower(config[i]) == string.lower(itemName)) then
                return true
            end
        end

        return false
    end

    ---@param weaponName string
    ---@return string | nil
    function self:GetWeaponType(weaponName)
        for weaponType, weaponList in pairs(Engine["Enums"].Weapons.ByType) do
            for wName, _ in pairs(weaponList) do
                if (string.upper(wName) == string.upper(weaponName)) then
                    return weaponType
                end
            end
        end

        return nil
    end

    ---@param filePath string | table
    function self:Require(filePath)
        if (filePath) then
            if (type(filePath) == "table") then
                for i = 1, #filePath do
                    if (filePath[i] and filePath[i]["Path"] and filePath[i]["File"]) then
                        self:Require(filePath[i]["Path"], filePath[i]["File"])
                    end
                end
            elseif (type(filePath) == "string") then
                local file = LoadResourceFile("engine", filePath)
                local func, err = load(file)

                if (func) then
                    local success, pcallErr = pcall(func)

                    if (not success) then
                        self.Log:Error(("Error while loading file: ^4%s^0, Error informations: ^1%s^0"):format(filePath, pcallErr))
                    end
                else
                    self.Log:Error(("Error while loading file: ^4%s^0, Error informations: ^1%s^0"):format(filePath, err))
                end
            end
        end
    end

    return self
end)()
