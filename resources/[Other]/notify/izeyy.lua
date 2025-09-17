local iznotif = {}

function MontreToiBasique(message, timeout, position, progress, theme, title, subject, icon)

    title = string.upper(title)
    subject = string.upper(subject)

    if message == nil then
        return PrintError("^1INOTIFY ERROR: ^7Notification message is nil")
    end

    if type(message) == "number" then
        message = tostring(message)
    end

    if title == nil then
        title = ""
    end
    
    if subject == nil then
        subject = ""
    end    

    if not tonumber(timeout) then
        timeout = qdqsdq.tut
    end
    
    if position == nil then
        position = qdqsdq.osi
    end
    
    if progress == nil then
        progress = false
    end  

    local id = nil
    local duplicateID = vaCheckDuplicateCheck(message)

    if duplicateID then
        id = duplicateID
    else
        id = askipuuid(message)
        iznotif[id] = message
    end
    
    AjouteNotif({
        duplicate   = duplicateID ~= false,
        id          = id,
        type        = "advanced",
        message     = message,
        title       = title,
        subject     = subject,
        icon        = qdqsdq.cones[icon],
        banner      = nil,
        timeout     = timeout,
        position    = position,
        progress    = progress,
        theme       = theme,
    })
end

function MontreToiVert(message, timeout, position, progress)
    MontreToiBasique(message, timeout, position, progress, "success")
end

function MontreToiJaune(message, timeout, position, progress)
    MontreToiBasique(message, timeout, position, progress, "info")
end

function MontreToiOrange(message, timeout, position, progress)
    MontreToiBasique(message, timeout, position, progress, "warning")
end

function MontreToiRouge(message, timeout, position, progress)
    MontreToiBasique(message, timeout, position, progress, "error")
end

function MontreToiAvance(message, title, subject, banner, timeout, position, progress, theme, icon)
    title = string.upper(title)
    subject = string.upper(subject)

    if message == nil then
        return PrintError("^1INOTIFY ERROR: ^7Notification message is nil")
    end

    if type(message) == "number" then
        message = tostring(message)
    end

    if title == nil then
        title = ""
    end
    
    if subject == nil then
        subject = ""
    end

    if not tonumber(timeout) then
        timeout = qdqsdq.tut
    end
    
    if position == nil then
        position = qdqsdq.osi
    end
    
    if progress == nil then
        progress = false
    end  

    local id = nil
    local duplicateID = vaCheckDuplicateCheck(message)

    if duplicateID then
        id = duplicateID
    else
        id = askipuuid(message)
        iznotif[id] = message
    end

    AjouteNotif({
        duplicate   = duplicateID ~= false,
        id          = id,
        type        = "advanced",
        message     = message,
        title       = title,
        subject     = subject,
        icon        = qdqsdq.cones[icon],
        banner      = nil,
        timeout     = timeout,
        position    = position,
        progress    = progress,
        theme       = theme,
    })
end

function SauveTonPosition(position)
    SetResourceKvp("qzqsdffzqsdv", position)
    qdqsdq.osi = GetResourceKvpString("qzqsdffzqsdv")
end

function AjouteNotif(data)
    data.config = Config
    SendNUIMessage(data)
end

function PrintError(message)
    local s = string.rep("=", string.len(message))
    print(s)
    print(message)
    print(s)  
end

function vaCheckDuplicateCheck(message)
    for id, msg in pairs(iznotif) do
        if msg == message then
            return id
        end
    end

    return false
end

function askipuuid(message)
    math.randomseed(GetGameTimer() + string.len(message))
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

RegisterNetEvent("izeyy;send")
AddEventHandler("izeyy;send", MontreToiBasique)

RegisterNetEvent("izeyy;sendAdvanced")
AddEventHandler("izeyy;sendAdvanced", MontreToiAvance)

RegisterNetEvent("izeyy;sendSuccess")
AddEventHandler("izeyy;sendSuccess", MontreToiVert)

RegisterNetEvent("izeyy;sendInfo")
AddEventHandler("izeyy;sendInfo", MontreToiJaune)

RegisterNetEvent("izeyy;sendWarning")
AddEventHandler("izeyy;sendWarning", MontreToiOrange)

RegisterNetEvent("izeyy;sendError")
AddEventHandler("izeyy;sendError", MontreToiRouge)

RegisterNetEvent("izeyy;savePosition")
AddEventHandler("izeyy;savePosition", SauveTonPosition)

RegisterNUICallback("nui_removed", function(data, cb)
    iznotif[data.id] = nil
    cb('ok')
end)