local mainMenu = HeistStorage:Get("main_menu")

mainMenu:IsVisible(function(Items)
    local canHouseHeist = Client.Heist:canHouseHeist()
    local houseStartHeistHours = Engine["Config"]["Heist"]["HouseHeistHours"].start
    local houseEndHeistHours = Engine["Config"]["Heist"]["HouseHeistHours"].ending
    local houseHeistDesc = (not canHouseHeist and string.format("Les braquages de maison sont seulement disponibles entre %sh et %sh", houseStartHeistHours, houseEndHeistHours) or nil)

    Items:Button("Braquage de maison", houseHeistDesc, {}, canHouseHeist, {
        onSelected = function()
            if (canHouseHeist) then
                Client.Heist:startHouseHeist()
            end
        end
    })

    Items:Button("Go Fast", "Mission bientot disponible", {}, Client.Heist:canGoFast(), {})
    Items:Button("Braquage de Fleeca", "Braquage bientot disponible", {}, Client.Heist:canFleecaHeist(), {})
    Items:Button("Braquage Pacific Standard", "Braquage bientot disponible", {}, Client.Heist:canPacificStandardHeist(), {})
end)
