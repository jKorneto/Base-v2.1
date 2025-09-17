--[[
  This file is part of Onelife RolePlay.
  Copyright (c) Onelife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

ESX = nil

TriggerEvent(Config.Get.ESX, function(obj) ESX = obj end)

RegisterServerEvent('barbershop:pay')
AddEventHandler('barbershop:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    local Bill = ESX.CreateBill(0, xPlayer.source, 15, "FleecaBank", "server")
    if Bill then
        xPlayer.showNotification("Vous avez payé 15$")
        TriggerClientEvent("closeBarberMenu", _source)
    end
end)