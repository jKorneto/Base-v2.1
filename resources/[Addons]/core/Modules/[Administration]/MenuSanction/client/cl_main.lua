local main_menu = RageUI.AddMenu("", "Historique des sanctions")

local Name = ""
local Data = {}

local function formatDate(dateString)
    local year, month, day, hour, min = dateString:match("(%d+)-(%d+)-(%d+) (%d+):(%d+)")
    return string.format("%02d/%02d/%04d - %02d:%02d", day, month, year, hour, min)
end

main_menu:IsVisible(function(Items)
    if (#Data > 0) then
        for k, v in pairs(Data) do
            local formattedDate = formatDate(v.sanction_date)
            local rightLabel = formattedDate
            local description = ""

            if v.type == "jail" then
                description = "Nombre de tâches : ~r~" .. v.tasks
            elseif v.type == "ban" then
                if v.ban == 0 then
                    description = "Durée du ban : ~r~Permanent"
                else
                    description = "Durée du ban : ~r~" .. v.ban .. "h"
                end
            end

            Items:Button(v.name .. " (~b~" .. v.reason .. "~s~)", description, { RightLabel = rightLabel }, true, {})
        end
    else
        Items:Separator("Aucune sanction trouvée")
    end
end)

Shared.Events:OnNet("core:admin:openMenu", function(playerName, receivedData)
    Data = receivedData
    Name = playerName
    main_menu:SetSubtitle("Historique des sanctions de : " .. Name)  -- Ajoutez cette ligne pour mettre à jour le sous-titre
    table.sort(Data, function(a, b)
        return a.sanction_date > b.sanction_date
    end)
    main_menu:Toggle()
end)