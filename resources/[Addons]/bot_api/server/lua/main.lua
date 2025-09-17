_bot_api = {}

exports('GetClassbot_api', function()
    return _bot_api
end)

exports('bot_apiGetReportsLists', function()
    ReportsList = {}

    for k,v in pairs( exports['epicenter']:GetReportsList()) do
        table.insert(ReportsList, v)
    end

    return ReportsList
end)

exports('bot_apiGetStaffBoard', function()
    return  exports['epicenter']:GetStaffBoard()
end)