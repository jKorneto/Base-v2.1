local history_menu = shopStorage:Get("history_menu")

history_menu:IsVisible(function(Items)
    local history = Client.Shop:getHistory()

    if (history ~= nil) then
        if (next(history) ~= nil) then
            for i = 1, #history do
                local playerHistory = history[i]
                local price = (playerHistory.price > 0 or playerHistory.price < 0) and "~b~"..playerHistory.price.."~s~" or "~g~Gratuit"

                Items:Button(playerHistory.transaction, playerHistory.date, {RightLabel = price}, true, {})
            end
        else
            Items:Separator("Votre historique est vide")
        end
    else
        Items:Separator("Chargement de l'historique...")
    end
end)