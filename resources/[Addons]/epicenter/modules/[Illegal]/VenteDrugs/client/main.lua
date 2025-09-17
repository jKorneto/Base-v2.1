local NearestePed = nil
local DejaVenduPed = {}
local inSell = false
local DispoVente = false

CreateThread(function()
    while ESX == nil do
        Wait(100)
    end
    SetDeepOceanScaler(0.0);
    while true do
        local zone = GetZoneDevant()
        local ped = ESX.Game.GetClosestPed(zone, {})
        local model = GetEntityModel(ped)
        if ped ~= PlayerPedId() and not IsPedAPlayer(ped) and not IsPedInAnyVehicle(ped, 1) and not IsPedDeadOrDying(ped, 1) then
            if model ~= GetHashKey("s_m_m_doctor_01") and
                model ~= GetHashKey("a_m_m_eastsa_02") and
                model ~= GetHashKey("a_m_m_hillbilly_01") and
                model ~= GetHashKey("a_f_y_hipster_02") and
                model ~= GetHashKey("a_m_y_dhill_01") and
                model ~= GetHashKey("a_m_m_eastsa_01") and
                model ~= GetHashKey("s_m_m_dockwork_01") and
                model ~= GetHashKey("mp_m_waremech_01") and
                model ~= GetHashKey("ig_trafficwarden") and
                model ~= GetHashKey("a_m_m_prolhost_01") and
                model ~= GetHashKey("s_m_m_ups_02") and
                model ~= GetHashKey("s_f_y_cop_01") and
                model ~= GetHashKey("S_M_Y_Casino_01") and
                model ~= GetHashKey("s_m_m_autoshop_02") and
                model ~= GetHashKey("S_F_Y_Casino_01") and
                model ~= GetHashKey("a_f_y_femaleagent") and
                model ~= GetHashKey("s_m_m_dockwork_01") and
                model ~= GetHashKey("s_m_y_dockwork_01") and
                model ~= GetHashKey("s_m_y_dealer_01") and
                model ~= GetHashKey("s_m_y_robber_01") and
                model ~= GetHashKey("mp_f_boatstaff_01") and
                model ~= GetHashKey("s_m_y_construct_01") and
                model ~= GetHashKey("s_m_m_gardener_01") and
                model ~= GetHashKey("a_f_y_business_02") and
                model ~= GetHashKey("s_m_y_cop_01") and
                model ~= GetHashKey("s_m_m_security_01") and
                model ~= GetHashKey("a_c_boar") and
                model ~= GetHashKey("a_c_deer") and
                model ~= GetHashKey("a_c_dolphin") and
                model ~= GetHashKey("a_c_fish") and
                model ~= GetHashKey("a_c_hen") and
                model ~= GetHashKey("a_c_humpback") and
                model ~= GetHashKey("a_c_husky") and
                model ~= GetHashKey("a_c_killerwhale") and
                model ~= GetHashKey("a_c_mtlion") and
                model ~= GetHashKey("a_c_pig") and
                model ~= GetHashKey("a_c_poodle") and
                model ~= GetHashKey("a_c_pug") and
                model ~= GetHashKey("a_c_rabbit_01") and
                model ~= GetHashKey("a_c_rat") and
                model ~= GetHashKey("a_c_retriever") and
                model ~= GetHashKey("a_c_rhesus") and
                model ~= GetHashKey("a_c_rottweiler") and
                model ~= GetHashKey("a_c_seagull") and
                model ~= GetHashKey("a_c_sharkhammer") and
                model ~= GetHashKey("a_c_sharktiger") and
                model ~= GetHashKey("a_c_shepherd") and
                model ~= GetHashKey("a_c_stingray") and
                model ~= GetHashKey("a_c_pigeon") and
                model ~= GetHashKey("a_c_westy") and
                model ~= GetHashKey("a_c_cat_01") and
                model ~= GetHashKey("s_m_m_pilot_02") and
                model ~= GetHashKey("a_c_chickenhawk") and
                model ~= GetHashKey("a_c_chimp") and
                model ~= GetHashKey("a_c_chop") and
                model ~= GetHashKey("a_c_cormorant") and
                model ~= GetHashKey("a_c_cow") and
                model ~= GetHashKey("a_c_coyote") and
                model ~= GetHashKey("a_c_crow") and
                model ~= GetHashKey("a_c_rat") and
                model ~= GetHashKey("mp_m_shopkeep_01") and
                model ~= GetHashKey("mp_m_weapexp_01") and
                model ~= GetHashKey("csb_burgerdrug") and
                model ~= GetHashKey("a_f_m_bevhills_02") and
                model ~= GetHashKey("s_m_m_doctor_01") and
                model ~= GetHashKey("a_m_m_eastsa_02") and
                model ~= GetHashKey("ig_hunter") and
                model ~= GetHashKey("a_m_y_downtown_01") and
                model ~= GetHashKey("a_m_m_afriamer_01") and
                model ~= GetHashKey("a_m_y_vindouche_01") and
                model ~= GetHashKey("s_m_y_sheriff_01") and
                model ~= GetHashKey("s_m_m_armoured_01") and
                model ~= GetHashKey("s_m_m_armoured_02") and
                model ~= GetHashKey("a_m_y_business_02") and
                model ~= GetHashKey("a_m_y_vinewood_01") and
                model ~= GetHashKey("s_m_y_factory_01") and
                model ~= GetHashKey("g_m_y_salvaboss_01") and
                model ~= GetHashKey("s_m_m_armoured_01") and
                model ~= GetHashKey("csb_stripper_01") and
                model ~= GetHashKey("s_m_m_bouncer_01") and
                model ~= GetHashKey("csb_bryony") and
                model ~= GetHashKey("s_m_y_mime") then
                local coords = GetEntityCoords(ped, true)
                local distance = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), coords, true), 0)
                if distance <= 10 and not exports.core:PlayerIsInSafeZone() then
                    NearestePed = ped
                else
                    NearestePed = nil
                end
            end
        end
        Wait(2500)
    end
end)

CreateThread(function()
    while true do
        local count = 0
        local attente = 3000
        for k,v in ipairs(DejaVenduPed) do
            local NetPed = NetworkGetEntityFromNetworkId(v)
            if DoesEntityExist(NetPed) then
                count = count + 1
                attente = 1000
            end
        end
        if count == 0 then
            DejaVenduPed = {}
            attente = 10000
        end
        Wait(attente)
    end
end)

CreateThread(function()
    while ESX == nil do
        Wait(100)
    end
    while true do

        local waitdrogue = 250
        for k,v in ipairs(DejaVenduPed) do
            local NetPed = NetworkGetEntityFromNetworkId(v)
            if NetPed == NearestePed then
                NearestePed = nil
            end
        end

        if NearestePed ~= nil then
            if DispoVente == true then
                local ped = NearestePed
                local coords = GetEntityCoords(ped, true)
                local distance = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), coords, true), 0)
                if distance <= 5.0 then
                    waitdrogue = 1
                    if distance >= 3.0 then
                        DrawMarker(0, coords.x, coords.y, coords.z+1.2, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 255, 255, 255, 155, 1, 1, 0, 0)
                    else
                        DrawMarker(0, coords.x, coords.y, coords.z+1.2, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 255, 255, 255, 155, 1, 1, 0, 0)
                        ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour essayer de vendre de la Drogue')
                        if IsControlJustReleased(1, 51) then
                            local PedNetId = NetworkGetNetworkIdFromEntity(ped)
                            OpenNpcMenu(PedNetId)
                        end
                    end
                else
                    NearestePed = nil
                end
            end
        end
        Wait(waitdrogue)
    end
end)

function GetZoneDevant()
    local backwardPosition = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
	return backwardPosition
end

---@param entityId number
---@param netId number
local function reset(entityId, netId)
    table.insert(DejaVenduPed, netId);
    NearestePed = nil;
    inSell = false;
end

---@param entityId number
---@param netId number
local function SellSuccess(entityId, netId)
    if (not DoesEntityExist(entityId)) then
        ESX.ShowNotification("Une erreur est survenue");
        return;
    end

    while (not HasAnimDictLoaded("mp_common")) do
        RequestAnimDict("mp_common");
        Wait(1);
    end

    TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 2.0, 2.0, -1, 0, 0, false, false, false)
    TaskPlayAnim(entityId, "mp_common", "givetake1_a", 2.0, 2.0, -1, 0, 0, false, false, false)
    Wait(4500);
    FreezeEntityPosition(entityId, false);
end

---@param entityId number
---@param netId number
local function SellFailed(entityId, netId, invalidQuantity)
    if (not DoesEntityExist(entityId)) then
        ESX.ShowNotification("Une erreur est survenue");
        return;
    end

    local plyPed = PlayerPedId();
    FreezeEntityPosition(entityId, false);
    if (not invalidQuantity) then
        ESX.ShowAdvancedNotification('Notification', "Drogue", "Degage d'ici avant que j'appel les flics ou quoi je veux pas ta merde", 'CHAR_CALL911', 8);
        TaskCombatPed(entityId, plyPed, 0, 16);
    end
end

function SellDrugs(npc, type)
    local ped = NetworkGetEntityFromNetworkId(npc);

    if (not inSell) then
        local heading = GetEntityHeading(ped);
        local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.14, 0.0);

        inSell = true;

        reset(ped, npc);
        FreezeEntityPosition(ped, true);
        SetEntityHeading(PlayerPedId(), heading - 180.1);
        SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z, 0);
        Wait(300);
        ESX.TriggerServerCallback("drug:sell", function(success, invalidQuantity)
            if (success) then
                SellSuccess(ped, npc);
                return;
            end
            SellFailed(ped, npc, invalidQuantity);
        end, type);
    else
        ESX.ShowAdvancedNotification('Notification', "Drogue", "Une vente est déjà en cours...", 'CHAR_CALL911', 8);
    end
end

RegisterNetEvent("drug:call_cops", function(coords)
    ESX.ShowAdvancedNotification("LSPD CENTRAL", "Vente de drogue", "Des citoyens ont vu des gens vendre de la drogue.", "CHAR_CHAT_CALL", 8)

    local blip = AddBlipForCoord(coords);
    SetBlipSprite(blip, 51);
    SetBlipScale(blip, 0.6);
    SetBlipColour(blip, 47);

    local blipZone = AddBlipForCoord(coords);
    SetBlipSprite(blipZone, 161);
    SetBlipScale(blipZone, 1.0);
    SetBlipColour(blipZone, 47);
    SetBlipAsShortRange(blipZone, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Drogues (criminel)")
    EndTextCommandSetBlipName(blipZone)

    Wait(60 * 1000);
    RemoveBlip(blip);
    RemoveBlip(blipZone);
end)

function openVenteDrogue(npc)
	local menu = RageUI.CreateMenu("", "Vente de Drogue au PNJ")

    RageUI.Visible(menu, not RageUI.Visible(menu))

	while menu do
		Wait(0)

        RageUI.IsVisible(menu, function()
            RageUI.Button('Vendre de la Weed', "Niveau 5 requis pour vendre de la Weed", {}, true, {onSelected = function()
                if (CurrentPlayerXP >= 5) then
                    RageUI.CloseAll()
                    SellDrugs(npc, "Weed")
                else
                    ESX.ShowNotification("Vous n'avez pas le niveau nécéssaire pour vendre de la Weed")
                end
            end})

            RageUI.Button('Vendre de la Coke', "Niveau 10 requis pour vendre de la Coke", {}, true, {onSelected = function()
                if (CurrentPlayerXP >= 10) then
                    RageUI.CloseAll()
                    SellDrugs(npc, "Coke")
                else
                    ESX.ShowNotification("Vous n'avez pas le niveau nécéssaire pour vendre de la Coke")
                end
            end})

            RageUI.Button('Vendre de la Meth', "Niveau 15 requis pour vendre de la Meth", {}, true, {onSelected = function()
                if (CurrentPlayerXP >= 15) then
                    RageUI.CloseAll()
                    SellDrugs(npc, "Meth")
                else
                    ESX.ShowNotification("Vous n'avez pas le niveau nécéssaire pour vendre de la Meth")
                end
            end})

            RageUI.Button('Vendre de la Fentanyl', "Niveau 20 requis pour vendre de la Fentanyl", {}, true, {onSelected = function()
                if (CurrentPlayerXP >= 20) then
                    RageUI.CloseAll()
                    SellDrugs(npc, "Fentanyl")
                else
                    ESX.ShowNotification("Vous n'avez pas le niveau nécéssaire pour vendre de la Fentanyl")
                end
            end})
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

local TargetNpc = nil
local count = 0

function OpenNpcMenu(npc)
    openVenteDrogue(npc)
    Wait(100)
    local ped = NetworkGetEntityFromNetworkId(npc)
    TaskTurnPedToFaceEntity(ped, PlayerPedId(), 5000)
    TargetNpc = npc
end

function ActivateDrugsRessell()
    activeSellDrugs = not activeSellDrugs

    if activeSellDrugs then
        DispoVente = true
        ESX.ShowAdvancedNotification('Notification', "Drogue", "Vous avez activé la vente de drogue", 'CHAR_CALL911', 8)
    else
        DispoVente = false
        ESX.ShowAdvancedNotification('Notification', "Drogue", "Vous avez désactivé la vente de drogue", 'CHAR_CALL911', 8)
    end
end

RegisterNetEvent("Core:Drugs:ActivateDrugsRessell")
AddEventHandler("Core:Drugs:ActivateDrugsRessell", function()
    ActivateDrugsRessell()
end)

RegisterCommand("drugspnj", function()
    ActivateDrugsRessell()
end)