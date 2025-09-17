---Sends data to UI
---@param action string
---@param data any
function SendUIMessage(action, data)
    SendNUIMessage({
      action = action,
      data = data
    })
end

---Toggle UI
---@param shouldShow boolean
function ToggleNuiFrame(shouldShow, disableBlur)
    SetNuiFocus(shouldShow, shouldShow)
    SendUIMessage('setVisible', shouldShow)
    if not shouldShow then
        if not disableBlur then 
          TriggerScreenblurFadeOut(500)
        end
        SendUIMessage('openPage', false)
        if (ActiveMinigamePromise) then
          ActiveMinigamePromise:resolve(false)
          ActiveMinigamePromise = nil
        end
    else
        if not disableBlur then 
            TriggerScreenblurFadeOut(500)
        end
        SendUIMessage("setSettings", {
          imageSource = Config.UIImageSource,
          locale = {
              space_key = "Déverrouiller la goupille",
              arrow_key = "Déplacer le crochet",
              time_left = "Temps restant"
          }
        })
    end
end

RegisterNUICallback('hide', function(_, cb)
    ToggleNuiFrame(false)
    cb(true)
end)