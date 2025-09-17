---@class rdmSellDrug
---@field min number
---@field max number

---@param xPlayer xPlayer
local function call_cops(xPlayer)
    local xPlayers = ESX.GetPlayers();
    local ped = GetPlayerPed(xPlayer.source);
    local coords = GetEntityCoords(ped);

    local info_possibility = math.random(1, 3);

    if (info_possibility == 1) then
        xPlayer.showNotification("Le client n'avait pas l'air très serein");
    end

    for i = 1, #xPlayers do
        local xCop = ESX.GetPlayerFromId(xPlayers[i]);
        if (xCop) then
            if (xCop.job.name == 'police') then
                xCop.triggerEvent('drug:call_cops', coords);
            end
        end
    end
end

local function sell(item_name, quantity, xPlayer, rdm, response)
    local cancel_probability = math.random(1, 2);
    local item = xPlayer.getInventoryItem(item_name);

    local itemLabel = nil
    if (item_name == "weed_og_leaf") then
        itemLabel = "pochon de weed"
    elseif (item_name == "coke_pooch") then
        itemLabel = "pochon de coke"
    elseif (item_name == "meth_pooch") then
        itemLabel = "pochon de meth"
    elseif (item_name == "fentanyl_pooch") then
        itemLabel = "pochon de fentanyl"
    end
    if (not item or item.quantity <= 0) then
        xPlayer.showNotification("Tu n'as pas de ".. itemLabel .." sur toi !");
        response(false, false);
        return;
    end

    if (cancel_probability == 1) then
        local cops_call_probability = math.random(1, 2);
        if (cops_call_probability == 1) then
            call_cops(xPlayer);
        end
        response(false, false);
        return;
    end

    if not rdm or not rdm.min or not rdm.max then
        xPlayer.showNotification("Les informations de prix sont invalides !");
        response(false, false);
        return;
    end

    if (item.quantity >= quantity) then
        local price = math.random(rdm.min, rdm.max);
        local final_price = quantity * price;
        xPlayer.removeInventoryItem(item.name, quantity);
        xPlayer.addAccountMoney('dirtycash', final_price);
        xPlayer.showNotification("Tu as vendu " ..quantity..  "x " ..itemLabel.. " pour " ..final_price.."$");
        response(true, false);
        return;
    else
        xPlayer.showNotification("Le client voulait plus de drogues que se que tu avais.");
        response(false, true);
        return;
    end
end

---@return number
local function get_cops()
    local cops = 0;
    local xPlayers = ESX.GetPlayers();
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i]);
        if (xPlayer) then
            if xPlayer.job.name == 'police' then
                cops = cops + 1;
            end
        end
	end
    return cops;
end

ESX.RegisterServerCallback('drug:sell', function(source, cb, drug_type)
	local xPlayer = ESX.GetPlayerFromId(source);

    if (not xPlayer) then return end

	local cops = get_cops();

    if (cops <= 0) then
        xPlayer.showNotification("Il n'y a pas assez de SASP en ville");
        return;
    end

    if drug_type == 'Weed' then
        sell("weed_og_leaf", 5, xPlayer, {min = 980, max = 980}, cb);
    elseif drug_type == 'Coke' then
        sell("coke_pooch", 5, xPlayer, {min = 1935, max = 1935}, cb);
    elseif drug_type == 'Meth' then
        sell("meth_pooch", 5, xPlayer, {min = 1390, max = 1390}, cb);
    elseif drug_type == "Fentanyl" then
        sell("fentanyl_pooch", 5, xPlayer, {min = 2715, max = 2715}, cb);
    end
end);