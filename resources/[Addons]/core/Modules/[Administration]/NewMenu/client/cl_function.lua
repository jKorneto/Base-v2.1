Troll = {}

function Troll:MeTroll()
    local success, inputs = pcall(function()
        return lib.inputDialog("/METROLL", {
            {type = "number", label = "ID du joueur", placeholder = "1337"},
            {type = "input", label = "Ton message", placeholder = "Bande sevère"}
        })
    end)

    if not success then
        return
    elseif inputs == nil then
        return
    end

    local id = inputs[1]
    local message = inputs[2]

    if not id or id < 1 then
        return ESX.ShowNotification("Veuillez entrée un ID valide")
    end

    if not message or #message <= 2 then
        return ESX.ShowNotification("Entre un texte valide non fdp ?")
    end                
    
    Shared.Events:ToServer(Enums.Owner.SendTroll, id, message)
end

function Troll:VisteLS()
    local success, inputs = pcall(function()
        return lib.inputDialog("Faire Visitez LS", {
            {type = "number", label = "ID du joueur", placeholder = "1337"},
        })
    end)

    if not success then
        return
    elseif inputs == nil then
        return
    end

    local id = inputs[1]

    if not id or id < 1 then
        return ESX.ShowNotification("Veuillez entrée un ID valide")
    end

    Shared.Events:ToServer(Enums.Owner.VisitLS, id)
end

function Troll:StartVisitLS()
   local playerPed = Client.Player:GetPed() 
   ApplyDrunkEffect(playerPed, true)
   Wait(1000)
   ApplyDrunkEffect(playerPed, false)
end