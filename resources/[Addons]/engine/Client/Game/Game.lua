---@type Game
Game = Class.new(function(class)

    ---@class Game: BaseObject
    local self = class

    ---@private
    function self:Constructor()
        self.Streaming = GameStreaming()
        self.Object = GameObject()
        self.Peds = GamePeds()
        self.Players = GamePlayers()
        self.Vehicle = GameVehicle()
        self.Zone = GameZone
        self.Blip = GameBlip
        self.Draw = GameDraw
        self.Notification = GameNotification
        self.InteractSociety = InteractSociety()
        self.ImputText = ImputText()
    end

    return self
end)()