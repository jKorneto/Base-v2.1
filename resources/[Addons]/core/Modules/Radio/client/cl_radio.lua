local pma = exports["pma-voice"]
local currentFrequence = 0
local mainMenu = RageUI.AddMenu("Radio", "Menu radio")

local Radio = {
    TickRadio = false,
    InfosRadio = false,
    Bruitages = true,
    Statut = "~s~Allumé",
    VolumeRadio = 1,
    jobChannels = {
        {job = "police", min=1, max=15},
        {job = "bcso", min=1, max=15},
        {job = "fib", min=1, max=15},
        {job = "ambulance", min=1, max=15},
        {job = "gouv", min=1, max=15} 
    },
    Frequence = "0",
}

local RadioState = {
    Status = false,
}

-- Menu Radio
mainMenu:IsVisible(function(Items)
    Items:Checkbox("Allumée/Eteindre", nil, RadioState.Status, {}, {
        onSelected = function()
            RadioState.Status = not RadioState.Status
            if RadioState.Status then
                pma:setVoiceProperty("radioEnabled", true)
                ESX.ShowNotification("Radio Allumée.")
            else
                pma:setRadioChannel(0)
                pma:setVoiceProperty("radioEnabled", false)
                ESX.ShowNotification("Radio Eteinte.")
            end
        end
    })

    if RadioState.Status then
        Items:Checkbox("Activer les bruitages", nil, RadioState.Bruitages, {}, {
            onSelected = function()
                if RadioState.Bruitages then 
                    RadioState.Bruitages = false
                    pma:setVoiceProperty("micClicks", false)
                    ESX.ShowNotification("Bruitages radio désactives")
                else
                    RadioState.Bruitages = true 
                    ESX.ShowNotification("Bruitages radio activés")
                    pma:setVoiceProperty("micClicks", true)
                end
            end
        })

        Items:Button("Vous etes sur la fréquence", nil, { RightLabel = Radio.Frequence.." Mhz"}, true, {})

        Items:Line()

        Items:Button("Se connecter à une fréquence ", nil, { RightLabel = "→" }, true, {
            onSelected = function()
                local success, input = pcall(function()
                    return lib.inputDialog("Fréquence", {
                        {type = "number", label = "Entrez la fréquence (max 500 MHZ)"},
                    })
                end)
        
                if not success then
                    return
                elseif input == nil then
                    ESX.ShowNotification("Frequence Invalide")
                    return
                end
        
                local Frequence = input[1]
                local PlayerData = ESX.GetPlayerData(_source)
                local restricted = {}
        
                if Frequence == nil then return end
        
                if Frequence > 500 then
                    ESX.ShowNotification("La fréquence ne peut pas dépasser 500 MHZ.")
                    return
                end
        
                for i,v in pairs(Radio.jobChannels) do
                    if Frequence >= v.min and Frequence <= v.max then
                        table.insert(restricted, v)
                    end
                end
                        
                if #restricted > 0 then
                    for i,v in pairs(restricted) do
                        if PlayerData.job.name == v.job and Frequence >= v.min and Frequence <= v.max then
                            Radio.Frequence = tostring(Frequence)
                            pma:setRadioChannel(Frequence)
                            ESX.ShowNotification("Fréquence définie sur "..Frequence.." MHZ")
                            currentFrequence = Frequence
                            break
                        elseif i == #restricted then
                            ESX.ShowNotification("Échec de la connexion : cette fréquence est réservée par l'État de Los Santos")
                            break
                        end
                    end
                else
                    Radio.Frequence = tostring(Frequence)
                    pma:setRadioChannel(Frequence)
                    ESX.ShowNotification("Fréquence définie sur "..Frequence.." MHZ")
                    TriggerServerEvent('OneLifePass:taskCountAdd:premium', 4, 1)
                    currentFrequence = Frequence
                end
            end
        })
        
    
        Items:Button("Se déconnecter de la fréquence", nil, { RightLabel = "→" }, true, {
            onSelected = function()
                Radio.Frequence = "0"
                ESX.ShowNotification("Vous vous êtes déconnecter de la fréquence")
            end
        })
    end
end)

RegisterNetEvent("iZeyy:radio:receiveOpen", function()
    if (not mainMenu:IsShowing()) then
        mainMenu:Toggle()
    end
end)

Shared:RegisterKeyMapping("iZeyy:radio:OpenMenu", { label = "open_menu_radio" }, "F2", function()
    if (not mainMenu:IsShowing()) then
        TriggerServerEvent("iZeyy:radio:requestOpen")
    end
end)