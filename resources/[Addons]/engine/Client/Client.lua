---@type Client
Client = Class.new(function(class)

    ---@class Client: BaseObject
    local self = class

    function self:Constructor()
        Shared:Initialized("Client")
    end

    ---@return boolean
    function self:IsOwner()
        for i = 1, #Engine["Config"]["Owner"] do
            if (Engine["Config"]["Owner"][i] == self.Player.identifier) then
                return true
            end
        end

        return false
    end

    ---@param playerData xPlayer | table
    function self:InitializePlayer(playerData)
        Shared.Log:Success("Player Data Initialized.")
        ---@type LocalPlayer
        self.Player = LocalPlayer(playerData)
        self.Mecano = MecanoListener()
        self.EnterSpawn = EnterSpawnListener
        self.Bill = BillListener()
        self.ClothesShop = ClothesListener()
        self.Vip = VipListener()
        self.Shop = ShopListener()
        self.Heist = HeistListener()
    end

    ---@param gameEventName string
    ---@param callback fun(data: table)
    function self:SubscribeToGameEvent(gameEventName, callback)
        AddEventHandler("gameEventTriggered", function(event, data)
            if (event == gameEventName) then
                if (callback) then
                    callback(data)
                end
            end
        end)
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
                        Shared.Log:Error(("Error while loading file: ^4%s^0, Error informations: ^1%s^0"):format(filePath, pcallErr))
                    end
                else
                    Shared.Log:Error(("Error while loading file: ^4%s^0, Error informations: ^1%s^0"):format(filePath, err))
                end
            end
        end
    end

    return self
end)()