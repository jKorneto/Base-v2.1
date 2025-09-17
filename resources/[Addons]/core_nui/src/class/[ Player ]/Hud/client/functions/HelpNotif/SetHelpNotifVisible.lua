---@return void
function _core_nui:SetHelpNotifVisible(message)

    sendUIMessage({
        HelpNotifShow = true,
        HelpText = message
    })

end