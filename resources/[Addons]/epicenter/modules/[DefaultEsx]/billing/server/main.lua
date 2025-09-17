--[[
  This file is part of OneLife RolePlay.
  Copyright (c) OneLife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local bills = {}
local maxBillAmount = 10000000

RegisterNetEvent('esx_billing:sendBill', function(playerId, sharedAccountName, label, amount)
	local _source = source

	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount        = ESX.Math.Round(amount)

	local society = ESX.DoesSocietyExist(sharedAccountName);

	if amount < 0 then
		-- print(('esx_billing: %s attempted to send a negative bill!'):format(xPlayer.identifier))
	elseif (not society) then

		if (xTarget) then
			if xPlayer.job.name == sharedAccountName then
				MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @a', {
					['@a'] = xTarget.identifier
				}, function(r)

					if #r > 0 then
						xPlayer.showNotification("La personne sélectionner a déjà une ou plusieurs factures impayées.")
						xTarget.showNotification("Vous avez déjà une ou plusieurs factures impayées.");
						return;
					end

					MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
					{
						['@identifier']  = xTarget.identifier,
						['@sender']      = xPlayer.identifier,
						['@target_type'] = 'player',
						['@target']      = xPlayer.identifier,
						['@label']       = label,
						['@amount']      = amount,
					}, function(rowsChanged)
						TriggerClientEvent('esx:showNotification', xPlayer.source, "vous avez envoyé une facture de : "..amount.."~s~$")
						TriggerClientEvent('esx:showNotification', xTarget.source, "vous avez ~s~reçu~s~ une facture")

						local link = "https://discord.com/api/webhooks/1310476919778840607/Z-YsfXcId3ro_LDdlT84PL420qRBJd_CUO9h_xYjGeSivpKDY23O3QzWBKC6gbci0-D1"
					
		                    local local_date = os.date('%H:%M:%S', os.time())
							local content = {
								{
									["title"] = "**Envoie facture :**",
									["fields"] = {
										{ name = "- Receveur :", value = xPlayer.name.." ["..xPlayer.identifier.."]"},
										{ name = "- Envoyeur :", value = xTarget.name.." ["..xTarget.identifier.."]"},
										{ name = "- Information facture :", value = "Entreprise : `"..target.."`\nMontant de la facture : `"..amount.."`\nRaison de la facture : `"..label.."`" },

									},
									["type"]  = "rich",
                                    ["color"] = 1000849,
                                    ["footer"] =  {
                                      ["text"]= "Powered for OneLife ©   |  "..local_date.."",
                                      ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
                                    },
								}
							}
							PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({username = "Logs Facture", embeds = content}), { ['Content-Type'] = 'application/json' })

						-- sendWebhookforbill("Facture", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient d'envoyer une facture de "..amount.."$ au joueur **"..xTarget.name.."** (***"..xTarget.identifier.."***) pour l'entreprise **"..label.."** " ,10105796);
					end);

				end)
			else
				TriggerEvent("tF:Protect", source, '(esx_billing:sendBill)');
			end
		end
	elseif (society) then

		if xTarget ~= nil then
			MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @a', {
				['@a'] = xTarget.identifier
			}, function(r)

				-- if #r > 0 then
				-- 	xPlayer.showNotification("La personne sélectionner a déjà une ou plusieurs factures impayées.")
				-- 	xTarget.showNotification("Vous avez déjà une ou plusieurs factures impayées.");
				-- 	return;
				-- end

				MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
				{
					['@identifier']  = xTarget.identifier,
					['@sender']      = xPlayer.identifier,
					['@target_type'] = 'society',
					['@target']      = sharedAccountName,
					['@label']       = label,
					['@amount']      = amount,
				}, function(rowsChanged)
					TriggerClientEvent('esx:showNotification', xTarget.source, "vous avez ~s~reçu~s~ une facture")

					local link = "https://discord.com/api/webhooks/1310476919778840607/Z-YsfXcId3ro_LDdlT84PL420qRBJd_CUO9h_xYjGeSivpKDY23O3QzWBKC6gbci0-D1"
					
					local local_date = os.date('%H:%M:%S', os.time())

					local content = {
						{
							["title"] = "**Envoie facture :**",
							["fields"] = {
								{ name = "- Receveur :", value = xPlayer.name.." ["..xPlayer.identifier.."]"},
								{ name = "- Envoyeur :", value = xTarget.name.." ["..xTarget.identifier.."]"},
								{ name = "- Information facture :", value = "Entreprise : `"..sharedAccountName.."`\nMontant de la facture : `"..amount.."$`\nRaison de la facture : `"..label.."`" },

							},
							["type"]  = "rich",
                            ["color"] = 1000849,
                            ["footer"] =  {
                              ["text"]= "Powered for OneLife ©   |  "..local_date.."",
                              ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
                            },
						}
					}
					PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({username = "Logs Facture", embeds = content}), { ['Content-Type'] = 'application/json' })

					-- sendWebhookforbill("Facture", "Le joueur **"..xPlayer.name.."** (***"..xPlayer.identifier.."***) vient d'envoyer une facture de "..amount.."$ au joueur **"..xTarget.name.."** (***"..xTarget.identifier.."***) pour l'entreprise **"..label.."** " ,16776960);
				end);

			end)
		end
	end
end)

Citizen.CreateThread(function()
    while true do

        bills = {}

        Citizen.Wait(10 * 1000)
    end
end)

AddEventHandler("esx:SendBillFromServer", function(source, playerId, sharedAccountName, label, amount)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount        = ESX.Math.Round(amount)

	local society = ESX.DoesSocietyExist(sharedAccountName);

	if amount < 0 then
		-- print(('esx_billing: %s attempted to send a negative bill!'):format(xPlayer.identifier))
	elseif (not society) then

		if (xTarget) then
			MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
				{
					['@identifier']  = xTarget.identifier,
					['@sender']      = xPlayer.identifier,
					['@target_type'] = 'player',
					['@target']      = xPlayer.identifier,
					['@label']       = label,
					['@amount']      = amount,
				}, function(rowsChanged)
					TriggerClientEvent('esx:showNotification', xTarget.source, "vous avez ~s~reçu~s~ une facture")
				end)
		end

	elseif (society) then

		if xTarget ~= nil then
			MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
				{
					['@identifier']  = xTarget.identifier,
					['@sender']      = xPlayer.identifier,
					['@target_type'] = 'society',
					['@target']      = sharedAccountName,
					['@label']       = label,
					['@amount']      = amount,
				}, function(rowsChanged)
					TriggerClientEvent('esx:showNotification', xTarget.source, "vous avez ~s~reçu~s~ une facture")
				end)
		end

	end

end);

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}
		for i=1, #result, 1 do
			table.insert(bills, {
				id         = result[i].id,
				identifier = result[i].identifier,
				sender     = result[i].sender,
				targetType = result[i].target_type,
				target     = result[i].target,
				label      = result[i].label,
				amount     = result[i].amount
			})
		end
		cb(bills)
	end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}
		for i=1, #result, 1 do
			table.insert(bills, {
				id         = result[i].id,
				identifier = result[i].identifier,
				sender     = result[i].sender,
				targetType = result[i].target_type,
				target     = result[i].target,
				label      = result[i].label,
				amount     = result[i].amount
			})
		end
		cb(bills)
	end)
end)

ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, id)
	local xPlayer = ESX.GetPlayerFromId(source)


	MySQL.Async.fetchAll('SELECT * FROM billing WHERE id = @id', {
		['@id'] = id
	}, function(result)
		local sender     = result[1].sender
		local targetType = result[1].target_type
		local target     = result[1].target
		local amount     = result[1].amount

		local xTarget = ESX.GetPlayerFromIdentifier(sender)

		if targetType == 'player' then

			if xTarget ~= nil then
				local HaveCount = xPlayer.getAccount('cash')
				
				if HaveCount and HaveCount.money >= amount then

					MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
						['@id'] = id
					}, function()
						local governmentTax = amount * 0.02 -- 2% de la somme
						local paymentToTarget = amount - governmentTax -- 98% pour le job qui a créé la facture
						local testOrTono = paymentToTarget - paymentToTarget * 10/100 -- Appliquer la réduction si VIP
					
						if xPlayer.GetVIP() then 
							if target == "cardealer" or target == "police" then
								xPlayer.removeAccountMoney('cash', testOrTono)
								ESX.AddSocietyMoney(target, paymentToTarget)
								ESX.AddSocietyMoney('gouv', governmentTax) -- Ajout de la taxe à la société gouvernementale
								TriggerClientEvent('esx:showNotification', xPlayer.source, "Facture réglée " .. ESX.Math.GroupDigits(testOrTono) .. "$")
							else
								xPlayer.removeAccountMoney('cash', amount)
								ESX.AddSocietyMoney(target, paymentToTarget)
								ESX.AddSocietyMoney('gouv', governmentTax) -- Ajout de la taxe à la société gouvernementale
								TriggerClientEvent('esx:showNotification', xPlayer.source,  "Facture réglée " .. ESX.Math.GroupDigits(amount) .. "$")
							end
						else
							xPlayer.removeAccountMoney('cash', amount)
							ESX.AddSocietyMoney(target, paymentToTarget)
							ESX.AddSocietyMoney('gouv', governmentTax) -- Ajout de la taxe à la société gouvernementale
							TriggerClientEvent('esx:showNotification', xPlayer.source,  "Facture réglée " .. ESX.Math.GroupDigits(amount) .. "$")
						end
					
						local link = "https://discord.com/api/webhooks/1310477574354370590/-DqiCw_Asq4ONNdY6-h0ivrxnUiOKCafjMns9R500Fw_zoHd0tfc1yeDYplc9fVEOCAD"
						local local_date = os.date('%H:%M:%S', os.time())
					
						local content = {
							{
								["title"] = "**Paiement facture :**",
								["fields"] = {
									{ name = "- Receveur :", value = xPlayer.name.." ["..xPlayer.identifier.."]"},
									{ name = "- Envoyeur :", value = xTarget.name.." ["..xTarget.identifier.."]"},
									{ name = "- Information facture :", value = "Entreprise : `"..target.."`\nMontant de la facture : `"..amount.."$`" },
								},
								["type"]  = "rich",
                                ["color"] = 1000849,
                                ["footer"] =  {
                                  ["text"]= "Powered for OneLife ©   |  "..local_date.."",
                                  ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
                                },
							}
						}
						PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({username = "Logs Facture", embeds = content}), { ['Content-Type'] = 'application/json' })
						cb()
					end)
					

				elseif xPlayer.getBank() >= amount then
					MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						MySQL.Async.fetchAll('SELECT * FROM billing WHERE id = @id', {
							['@id'] = id
						}, function(result)
							if result[1].split == true then
								-- print('Society paid invoice with split')
								local percent = 0.05
								xPlayer.removeAccountMoney('bank', amount)
								xTarget.addAccountMoney('bank', amount*(1-percent))

								local worker = ESX.GetPlayerFromIdentifier(result[1].sender)
								worker.addAccountMoney('bank', amount*percent)
							else
								xPlayer.removeAccountMoney('bank', amount)
								xTarget.addAccountMoney('bank', amount)
							end
						end)

						TriggerClientEvent('esx:showNotification', xPlayer.source, "Facture réglée " .. ESX.Math.GroupDigits(amount) .. "$")
						TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez reçu un paiement de "..ESX.Math.GroupDigits(amount).."$ 2% de cette somme ont été pris par l'État")

						local link = "https://discord.com/api/webhooks/1310477574354370590/-DqiCw_Asq4ONNdY6-h0ivrxnUiOKCafjMns9R500Fw_zoHd0tfc1yeDYplc9fVEOCAD"
					
						local local_date = os.date('%H:%M:%S', os.time())
	
						local content = {
							{
								["title"] = "**Paiement facture :**",
								["fields"] = {
									{ name = "- Receveur :", value = xPlayer.name.." ["..xPlayer.identifier.."]"},
									{ name = "- Envoyeur :", value = xTarget.name.." ["..xTarget.identifier.."]"},
									{ name = "- Information facture :", value = "Entreprise : `"..sharedAccountName.."`\nMontant de la facture : `"..amount.."$`\nRaison de la facture : `"..label.."`" },
	
								},
								["type"]  = "rich",
                                ["color"] = 1000849,
                                ["footer"] =  {
                                  ["text"]= "Powered for OneLife ©   |  "..local_date.."",
                                  ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
                                },
							}
						}
						PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({username = "Logs Facture", embeds = content}), { ['Content-Type'] = 'application/json' })
						cb()
					end)

				else
					TriggerClientEvent('esx:showNotification', xTarget.source, "La personne n'a pas assez d'argent sur son compte")
					TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez pas assez d'argent")
					cb()
				end

			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "La personne n'est pas en ville")
				cb()
			end

		else
			local society = ESX.DoesSocietyExist(target);

			if (society) then

				if xPlayer.getAccount('cash').money >= amount then
					MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						MySQL.Async.fetchAll('SELECT * FROM billing WHERE id = @id', {
							['@id'] = id
						}, function(result)
							local governmentTax = amount * 0.02 -- 2% de la somme pour le gouvernement
							local paymentToTarget = amount - governmentTax -- 98% pour le job qui a créé la facture
							local testOrTono = paymentToTarget - paymentToTarget * 10 / 100 -- Appliquer la réduction si VIP
					
							if xPlayer.GetVIP() then  
								if target == "cardealer" or target == "police" then
									xPlayer.removeAccountMoney('cash', testOrTono)
									ESX.AddSocietyMoney(target, paymentToTarget) -- Ajout de la somme au job
									ESX.AddSocietyMoney('gouv', governmentTax) -- Ajout de la taxe au gouvernement
									TriggerClientEvent('esx:showNotification', xPlayer.source, "Facture réglée " .. ESX.Math.GroupDigits(testOrTono) .. "$")
								else
									xPlayer.removeAccountMoney('cash', amount)
									ESX.AddSocietyMoney(target, paymentToTarget) -- Ajout de la somme au job
									ESX.AddSocietyMoney('gouv', governmentTax) -- Ajout de la taxe au gouvernement
									TriggerClientEvent('esx:showNotification', xPlayer.source, "Facture réglée " .. ESX.Math.GroupDigits(amount) .. "$")
								end
							else
								xPlayer.removeAccountMoney('cash', amount)
								ESX.AddSocietyMoney(target, paymentToTarget) -- Ajout de la somme au job
								ESX.AddSocietyMoney('gouv', governmentTax) -- Ajout de la taxe au gouvernement
								TriggerClientEvent('esx:showNotification', xPlayer.source,  "Facture réglée " .. ESX.Math.GroupDigits(amount) .. "$")
							end
						end)
					
						if xTarget ~= nil then
							TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez reçu un paiement de "..ESX.Math.GroupDigits(amount).."$ 2% de cette somme ont été pris par l'État")
						end
					
						local link = "https://discord.com/api/webhooks/1310477574354370590/-DqiCw_Asq4ONNdY6-h0ivrxnUiOKCafjMns9R500Fw_zoHd0tfc1yeDYplc9fVEOCAD"
						local local_date = os.date('%H:%M:%S', os.time())
					
						local content = {
							{
								["title"] = "**Paiement facture :**",
								["fields"] = {
									{ name = "- Receveur :", value = xPlayer.name.." ["..xPlayer.identifier.."]"},
									{ name = "- Envoyeur :", value = xTarget and (xTarget.name.." ["..xTarget.identifier.."]") or ("["..sender.."]") },
									{ name = "- Information facture :", value = "Entreprise : `"..target.."`\nMontant de la facture : `"..amount.."$`" },
								},
								["type"]  = "rich",
                                ["color"] = 1000849,
                                ["footer"] =  {
                                  ["text"]= "Powered for OneLife ©   |  "..local_date.."",
                                  ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
                                },
							}
						}
					
						PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({username = "Logs Facture", embeds = content}), { ['Content-Type'] = 'application/json' })
					
						cb()
					end)
					

				elseif xPlayer.getAccount('bank').money >= amount then
					MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						MySQL.Async.fetchAll('SELECT * FROM billing WHERE id = @id', {
							['@id'] = id
						}, function(result)
							local governmentTax = amount * 0.02
							local paymentToTarget = amount - governmentTax
							local testOrTono = paymentToTarget - paymentToTarget * 10 / 100
					
							if xPlayer.GetVIP() then  
								if target == "cardealer" or target == "police" then
									xPlayer.removeAccountMoney('bank', testOrTono)
									ESX.AddSocietyMoney(target, paymentToTarget)
									ESX.AddSocietyMoney('gouv', governmentTax)
									TriggerClientEvent('esx:showNotification', xPlayer.source, "Facture réglée " .. ESX.Math.GroupDigits(testOrTono) .. "$")
								else
									xPlayer.removeAccountMoney('bank', amount)
									ESX.AddSocietyMoney(target, paymentToTarget)
									ESX.AddSocietyMoney('gouv', governmentTax)
									TriggerClientEvent('esx:showNotification', xPlayer.source,  "Facture réglée " .. ESX.Math.GroupDigits(amount) .. "$")
								end
							else
								xPlayer.removeAccountMoney('bank', amount)
								ESX.AddSocietyMoney(target, paymentToTarget)
								ESX.AddSocietyMoney('gouv', governmentTax)
								TriggerClientEvent('esx:showNotification', xPlayer.source,  "Facture réglée " .. ESX.Math.GroupDigits(amount) .. "$")
							end
						end)
					
						if xTarget ~= nil then
							TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez reçu un paiement de "..ESX.Math.GroupDigits(amount).."$ 2% de cette somme ont été pris par l'État")
						end
					
						cb()
					end)
					

				else
					TriggerClientEvent('esx:showNotification', xTarget.source, "La personne n'a pas assez d'argent sur son compte")

					if xTarget ~= nil then
						TriggerClientEvent('esx:showNotification', xTarget.source, "Vous n'avez pas assez d'argent")
					end

					cb()
				end
			end

		end

	end)
end)

function dump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

function sendWebhookforbill(name,message,color)
    local local_date = os.date('%H:%M:%S', os.time())
    local DiscordWebHook = 'https://discord.com/api/webhooks/1310476919778840607/Z-YsfXcId3ro_LDdlT84PL420qRBJd_CUO9h_xYjGeSivpKDY23O3QzWBKC6gbci0-D1'
    -- Modify here your discordWebHook username = name, content = message,embeds = embeds
  
  local embeds = {
      {
          ["title"]='Envoie facture',
		  ["description"]=message,
          ["type"]="rich",
          ["color"] = 1000849,
          ["footer"] =  {
            ["text"]= "Powered for OneLife ©   |  "..local_date.."",
            ["icon_url"] = "https://i.ibb.co/QJJ5kST/Logo.png"
          },
      }
  }
  
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end