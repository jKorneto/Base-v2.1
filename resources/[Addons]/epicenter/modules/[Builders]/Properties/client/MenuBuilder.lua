
RegisterCommand("openProperties", function()
    if ESX.PlayerData.job.name == "realestateagent" then 
        OpenMenu()
    end
end)

local List = {
    Actions = {
        "Déposer",
        "Prendre"
    },
    ActionIndex = 1
}

local INMAKEVISUAL = false

function DestroyCamProperties()
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', false)
	SetCamActive(cam,  false)	
	FreezeEntityPosition(PlayerPedId(), false)
	RenderScriptCams(false,  false,  0,  false,  false)
    SetFocusEntity(PlayerPedId())
end

function OpenMenu()
    local menu = RageUI.CreateMenu('', "Paramètre disponibles")

    menu:SetSpriteBanner("commonmenu", "interaction_legal")
    menu:SetButtonColor(0, 137, 201, 255)
    local DATA = {
        NAME = "", 
        LABEL = "",
        PRICE = 250000,
        INTERIORSELECTED = nil,
        POIDS = 1500,
        POSITION = {
            ENTER = nil,
            EXIT = nil, 
            COFFRE = nil
        }
    }
    local MENU = {
        MAKEVISUAL = true,
        LIST = {
            LIST = {
                { Name = "Entrepot Grand [~b~VIP~s~]", Value = "Entrepot1"},
                { Name = "Entrepot Moyen", Value = "Entrepot2"},
                { Name = "Entrepot Petit", Value = "Entrepot3"},
    
                { Name = "Appartement Moderne", Value = "Appartement1" },
                { Name = "Appartement Modeste", Value = "Appartement2" },
                { Name = "Appartement Luxueux #1", Value = "Appartement3" },
                { Name = "Appartement Luxueux #2", Value = "Appartement4" },
                { Name = "Appartement Luxueux #3", Value = "Appartement5" },
                -- { Name = "Appartement Luxueux #4", Value = "Appartement6" },
    
                { Name = "Villa [~b~VIP~s~] #1", Value = "Villa1" },
                { Name = "Villa [~b~VIP~s~] #2", Value = "Villa2" },
    
                { Name = "Bureau [~b~VIP~s~] #1", Value = "Bureau1" },
                { Name = "Bureau #2", Value = "Bureau2" },
            },
            INDEX = 1
        }
    }
    RageUI.Visible(menu, not RageUI.Visible(menu))

    while menu do
        Wait(0)

        RageUI.IsVisible(menu, function()
            RageUI.List("Intérieur", MENU.LIST.LIST, MENU.LIST.INDEX, "Prix : ~s~"..DATA.PRICE.."~s~$\n~s~Poids : ~s~"..DATA.POIDS.."~s~Kg", {}, true, {
                onListChange = function(Index, Item)
                    MENU.LIST.INDEX = Index;
                    if MENU.MAKEVISUAL then
                        CreatCamPorperties(Item.Value)
                        INMAKEVISUAL = true
                    end
                    DATA.INTERIORSELECTED = Item.Value
                    DATA.PRICE = Propeties.List[Item.Value].PRIX
                    DATA.POIDS = Propeties.List[Item.Value].POIDS
                    DATA.POSITION.ENTER = Propeties.List[Item.Value].INSIDE
                    DATA.POSITION.COFFRE = Propeties.List[Item.Value].ROOM_MENU
                end
            })  -- <-- Add this closing brace to close the RageUI.List argument table        
            if INMAKEVISUAL then
                RageUI.Button("Sortir de la Previsualisation", nil, {RightLabel = "→"}, true, {
                    onSelected = function()
                        DestroyCamProperties()
                        INMAKEVISUAL = false
                    end
                })
            else
                RageUI.Button("Sortir de la Previsualisation", nil, {RightLabel = "→"}, false, {})
            end
            local RightLabelExit 
            if DATA.POSITION.EXIT == nil then 
                RightLabelExit = "~s~Non définis"
            else 
                RightLabelExit = "~s~Définis"
            end
            
            RageUI.Button('Position de l\'entrée', nil, {RightLabel = RightLabelExit}, true, {
                onSelected = function() 
                    if not MAKEVISUAL then
                        local pPed = PlayerPedId()
                        local pCoords = GetEntityCoords(pPed)
                        DATA.POSITION.EXIT = pCoords
                    else 
                        ESX.ShowNotification("~s~Création de Propriete~s~\nVous devez désactiver la visualisation.")
                    end
                end
            })
            RageUI.Line()
            RageUI.Button('Crée la Proprieté', nil, {RightLabel = "→"},  DATA.POIDS ~= nil and DATA.POSITION.EXIT ~= nil, {
                onSelected = function()
                    if not exports.core:PlayerIsInSafeZone() then
                        TriggerServerEvent("Properties:CreatedProperties", DATA)
                        RageUI.CloseAll()
                        DestroyCamProperties()
                    else
                        ESX.ShowNotification("Impossible en safe zone !")
                    end
                end
            })    
        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
            DestroyCamProperties()
        end
    end
end
