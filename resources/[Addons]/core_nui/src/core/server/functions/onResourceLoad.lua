function OneLife:onOneLifeReady(callback)
    AddEventHandler('OneLife:IsReady', function()
        callback()
    end)
end