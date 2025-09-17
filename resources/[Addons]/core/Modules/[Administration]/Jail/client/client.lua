local main_menu = RageUI.AddMenu("", Shared.Lang:Translate("jail_menu_title"))
local isInJail = false
local jailData = {}
local playerIsValid = false
local target = nil
local isDoTask = false
local lastNumTask = 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    while ESX.GetPlayerData()["job"] == nil do
        Wait(2000)
    end
    TriggerServerEvent("core:jail:onConnecting")
end)

main_menu:IsVisible(function(Items)
    for k, v in pairs(Config["Jail"]["Sanction"]) do
        Items:Button(v.label, nil, {RightLabel = v.count.." "..Shared.Lang:Translate("tasks")}, true, {
            onSelected = function()
                TriggerServerEvent("core:jail:sendPlayer", target, v.count, v.label)
                RageUI.CloseAll()
                target = nil
            end 
        })
    end

    Items:Button(Shared.Lang:Translate("custom_task"), nil, {}, true, {
        onSelected = function()

            local success, inputs = pcall(function()
                return lib.inputDialog("Joueur selectionné " .. target, {
                    {type = "number", label = "Nombre de Tache", placeholer = "10"},
                    {type = "input", label = "Raison de la Sanction", placeholer = "Raison"},
                })
            end)
    
            if not success then
                return
            elseif inputs == nil then
                return
            end
    
            local task = tonumber(inputs[1])
            local reason = inputs[2]

            if not task or task < 1 then
                return ESX.ShowNotification("Nombre de Tache incorrect")
            end

            if not reason then
                return ESX.ShowNotification("Raison Invalide")
            end

            TriggerServerEvent("core:jail:sendPlayer", target, task, reason)
            
        end
    })

end)

local function LaunchTasks()
    CreateThread(function()
        while isInJail do
            Wait(1000)
            local player = PlayerPedId()
            local coords = GetEntityCoords(player)
            SetEntityInvincible(player, true)
            if #(coords - Config["Jail"]["EnterPosition"]) > Config["Jail"]["ZoneSize"] then
                SetEntityCoords(player, Config["Jail"]["EnterPosition"])
            end
        end
        if jailData and jailData[1] then
            jailData[1].reason = nil
            jailData[1].task = nil
        end
    end)
end

local function createNewMarker(position)
    local player = PlayerPedId()
    taskZone = Game.Zone("taskZone")
    task_blip = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipRoute(task_blip, 1)

    taskZone:Start(function()
        if (isDoTask) then
            taskZone:SetTimer(1000)
            taskZone:SetCoords(position)

            taskZone:IsPlayerInRadius(25.0, function()
                taskZone:SetTimer(0)
                taskZone:Marker()

                taskZone:IsPlayerInRadius(3, function()
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour faire votre tache")

                    taskZone:KeyPressed("E", function()
                        TaskStartScenarioInPlace(player, "CODE_HUMAN_MEDIC_KNEEL", -1, false)
                        HUDProgressBar(Shared.Lang:Translate("task_progressbar"), 5)
                        Wait(5000)
                        ClearPedTasksImmediately(player)
                        RemoveBlip(task_blip)
                        taskZone:Stop()
                        isDoTask = false
                        if (isInJail) then
                            jailData[1].task = jailData[1].task - 1
                            TriggerServerEvent("core:jail:removeTask")
                            startTaskPosition()
                        end
                    end)
                    
                end, true, false)

            end, true, false)
        end
    end)

end

function startTaskPosition()
    CreateThread(function()
        ::task_renew::
        local randomNumber = math.random(1, #Config["Jail"]["TaskPos"])

        for k,v in pairs(Config["Jail"]["TaskPos"]) do
            if (not isDoTask) then

                if (randomNumber == v.number) then

                    if (randomNumber ~= lastNumTask) then
                        lastNumTask = v.number
                        isDoTask = true
                        createNewMarker(v.position)
                        break
                    else
                        goto task_renew
                        break
                    end
                    
                end
            end
        end
    end)
end

RegisterNetEvent("core:jail:receiveSanction", function(value, reason, name)
    isInJail = true
    startTaskPosition()
    LaunchTasks()
    table.insert(jailData, {task = value, reason = reason, staffname = name})
end)

RegisterNetEvent("core:jail:openMenu", function(id)
    if (id ~= nil) then
        target = id
        main_menu:Toggle()
    end
end)

RegisterNetEvent("core:jail:finish", function()
    ESX.TriggerServerCallback('core:jail:checkPlayer', function(validator)
        playerIsValid = validator
        if (playerIsValid) then
            isInJail = false
            Wait(1000)
            isDoTask = false
            jailData = {}
            taskZone:Stop()
            local player = PlayerPedId()
            SetEntityInvincible(player, false)
            RemoveBlip(task_blip)
        end
    end)
end)

---@return boolean
exports("isPlayerInJail", function()
    return isInJail
end)