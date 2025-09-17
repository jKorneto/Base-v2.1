local IsVisible = false

RegisterNetEvent("anti:tiktokeur:salope", function(Url)
    if (not IsVisible) then
        UrlImage = Url
        IsVisible = true

        SendNUIMessage({
            type = "showImage",
            url = UrlImage
        })

        SetTimeout(12500, function()
            if (IsVisible) then
                TriggerServerEvent("anti:tiktokeur:byeeeee")
            end
        end)
    end
end)