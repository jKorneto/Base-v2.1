local main_menu = RageUI.AddMenu("", "Faites vos actions")

main_menu:IsVisible(function(Items)
    for k, v in pairs(Config["ReportMenu"]["Reason"]) do
        Items:Button(v, nil, {}, true, {
            onSelected = function()
                TriggerServerEvent("iZeyy:Report:SendTicket", v)
                main_menu:Close()
            end
        })
    end
end)

RegisterNetEvent("iZeyy:Report:OpenMenu", function()
    main_menu:Toggle()
end)