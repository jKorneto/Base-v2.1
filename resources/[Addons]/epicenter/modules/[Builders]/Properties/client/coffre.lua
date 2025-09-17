function OpenMenuCoffreProperties(info, notPersonnal)
    local label, price, poids = info.label, info.price, info.poids
    local menu = RageUI.CreateMenu(label, "Coffre - Que voulez vous faire ?")
    local actionCoffre = RageUI.CreateSubMenu(menu, "", "Que voulez-vous faire ?")

    RageUI.Visible(menu, not RageUI.Visible(menu))

    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()

            RageUI.Button("Coffre", nil, { RightLabel = "→" }, true, {
                onSelected = function()
                    TriggerServerEvent("OneLife:Inventory:OpenSecondInventory", "properties", {name = info.name, weight = info.poids})
                    RageUI.CloseAll()
                end
            })
            RageUI.Button("Actions sur la Propriete", nil, { RightLabel = "→" }, true, {
                onSelected = function()
                end
            }, actionCoffre)

        end, function()
        end)

        RageUI.IsVisible(actionCoffre, function()

            -- RageUI.Button("Nom de la Propriete :", nil, { RightLabel = label }, true, {})
            local proprio
            if not notPersonnal then 
                proprio = "Vous"
            else 
                proprio = info.owner
            end
            RageUI.Button("Propriétaire :", nil, { RightLabel = proprio }, true, {})
            RageUI.Button("Prix d'achat :", nil, { RightLabel = price.."$" }, true, {})
            RageUI.Button("Prix de revente :", nil, { RightLabel = math.floor((price*75)/100).."$" }, true, {})
            RageUI.Button("Poids maximal du coffre :", nil, { RightLabel = poids.."kg" }, true, {})
            -- RageUI.Button("Poids du coffre utilisé :", nil, { RightLabel = GetWeightRestantProperties(Coffre).."/"..info.poids }, true, {})

            -- RageUI.Button("Rendre la Propriete", "~s~Vous renderez cette Propriete pour "..math.floor((price*75)/100).."$", { RightLabel = "→" }, not notPersonnal, {
            --     onSelected = function()
            --         TriggerServerEvent("Properties:PlayerHasRenderProperties", info, math.floor((price*75)/100))
            --     end
            -- })
            RageUI.Button("Rendre la Propriete", nil, { RightLabel = "→" }, not notPersonnal, {
                onSelected = function()
                    ESX.ShowNotification("Veuillez contactez l'agence immobiliere afin de rendre cette propriété")
                end
            })

        end, function()
        end)


        if not RageUI.Visible(menu) and not RageUI.Visible(actionCoffre) and not RageUI.Visible(depositMenu) then
            menu = RMenu:DeleteType('menu', true)
            actionCoffre = RMenu:DeleteType('actionCoffre', true)
            depositMenu = RMenu:DeleteType('depositMenu', true)
        end
    end
end