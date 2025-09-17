---@return void
function _core_nui:UpdatePlayersConnected(int)

    self.ServerInfos.playerConnected = int

    self:UpdateServerInfosData()

end