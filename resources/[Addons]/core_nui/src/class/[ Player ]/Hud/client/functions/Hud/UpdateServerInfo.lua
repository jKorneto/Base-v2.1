---@return void
function _core_nui:UpdateServerInfosData(bool)

    sendUIMessage({
        event = 'SetServerInfosData',
        ServerInfos = {
            playerConnected = self.ServerInfos.playerConnected
        }
    })

end