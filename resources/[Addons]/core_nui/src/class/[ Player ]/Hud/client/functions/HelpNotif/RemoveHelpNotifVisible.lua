---@return void
function _core_nui:RemoveHelpNotifVisible()

    sendUIMessage({
        HelpNotifShow = false
    })

end