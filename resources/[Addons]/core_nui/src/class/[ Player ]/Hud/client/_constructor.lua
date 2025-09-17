_core_nui = {}

local __instance = {
    __index = _core_nui
}

setmetatable(_core_nui, {
    __call = function()
        local self = setmetatable({}, __instance)

        self.StateHud = true
        self.StateSpeedoMeter = false
    
        self.PlayerData =  {
            id = GetPlayerServerId(PlayerId()),
            health = 0,
            shield = 0,
            states = nil
        }
        self.ServerInfos = {
            playerConnected = 0
        }

        
        self:UpdatePlayerData()
        self:LoadTaskSpeedoMeter()

        --Functions
        exportMetatable(_core_nui, self)

        return (self)
    end
})