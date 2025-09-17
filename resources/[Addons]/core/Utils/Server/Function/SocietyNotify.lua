local societyTimeouts = {}

---@param xPlayer xPlayer
---@param job string
---@param title string
---@param content string
---@param societyType string
---@param timeout number
function showSocietyNotify(xPlayer, job, title, content, societyType, timeout)
    if (type(xPlayer) == "table") then
        ::retry::

        local isAuthorizedDuringBlackout = job == "police" or job == "ambulance"

        if (not ServerInBlackout or isAuthorizedDuringBlackout) then
            local society = societyTimeouts[job]

            if (society == nil) then
                societyTimeouts[job] = Timer(timeout * 60 or 60)
                societyTimeouts[job]:Start()
    
                exports["engine_nui"]:SendNUIMessage(-1, {
                    type = 'showSocietyNotify',
                    title = title or "Default Title",
                    content = content or "Default Content",
                    societyType = societyType or "Default Society Type"
                })
            else
                if (society:HasPassed()) then
                    societyTimeouts[job] = nil
                    goto retry
                end
    
                xPlayer.showNotification(("Vous devez attendre %s avant de pouvoir envoyer une nouvelle annonce"):format(society:ShowRemaining()))
            end 
        else
            xPlayer.showNotification("Une panne d'électricité est en cours. Vous pourrez envoyer des annonces une fois la panne rétablie la reseau est seulement disponible pour la SASP ansi que les LSMC")
        end
    end
end
