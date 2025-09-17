---@type xPlayer
function CreatePlayer(source, identifier, userData)
	---@class xPlayer
	local self = {};

	self.source = source
	self.identifier = identifier

	self.character_id = userData.character_id
	self.name = userData.name

	self.permission_group = userData.permission_group
	self.permission_level = userData.permission_level

	self.accounts = userData.accounts

	self.job = userData.job
	self.job2 = userData.job2
	
	self.lastPosition = userData.lastPosition
	

    self.xp = userData.xp;
	self.vip = false;
	self.coins = userData.coins

	self.firstname = userData.firstname;
	self.lastname = userData.lastname;
	self.sex = userData.sex;
	self.discord = userData.discord;
	self.fivem = userData.fivem;
	self.positionSaveReady = false

	self.dead = (userData.isDead == 1 and true) or false;
	self.hurt = (userData.isHurt == 1 and true) or false;
	self.hurtTime = userData.hurtTime;
	self.underPants = userData.underPants;

	-- self.removeAccountsNameFistLoad = function(accountName)
	-- 	for i=1, #self.accounts, 1 do
	-- 		if (self.accounts[i] ~= nil) then
	-- 			if (self.accounts[i].name == accountName) then
	-- 				table.remove(self.accounts, i)
	-- 			end
	-- 		end
	-- 	end
	-- end

	local defaultSlots = 50
	exports['core_nui']:LoadPlayerInventory(self.identifier, userData.inventory, userData.clothes, defaultSlots, Config.MaxWeight, self)

	self.ReloadInventoryPlayer = function()
		exports['core_nui']:LoadPlayerInventory(self.identifier, userData.inventory, userData.clothes, defaultSlots, Config.MaxWeight, self)
	end

	---@return boolean
	self.isDead = function()
		return self.dead;
	end
	
	---@return boolean
	self.isHurt = function()
		return self.hurt;
	end

	---@return number
	self.getHurtTime = function()
		return self.hurtTime;
	end

	---@param hurt boolean | number 0 or 1
	---@param time number
	self.setHurt = function(hurt, time)
		local isHurt = (hurt == 1 or hurt == true and 1) or 0;
		local hurtTime = time or 0;

		self.hurt = (isHurt == 1 and true) or false;
		self.hurtTime = hurtTime;

		MySQL.update('UPDATE users SET isHurt = ?, hurtTime = ? WHERE identifier = ?', {
			isHurt,
			hurtTime,
			self.identifier
		});
	end

	self.getUnderPants = function()
		return self.underPants
	end

	---@param data table
	self.setUnderPants = function(data)
		if (type(data) == "table") then
			self.underPants = data

			MySQL.update('UPDATE users SET underPants = ? WHERE identifier = ?', {
				json.encode(self.getUnderPants()),
				self.identifier
			});
		end
	end

	---@param dead boolean | number 0 or 1
	self.setDead = function(dead)

		local isDead = (dead == 1 or dead == true and 1) or 0;

		self.dead = (isDead == 1 and true) or false;

		if (self.dead) then
			if (self.hasWeapon('gadget_parachute')) then
				self.removeWeapon('gadget_parachute');
			end
		end

		MySQL.update('UPDATE users SET isDead = ? WHERE identifier = ?', {

			isDead,
			self.identifier

		});

	end

    self.onRevive = function()
		self.clearAllInventoryWeapons(false)
		self.showNotification("Vous avez ~y~perdu~s~ toutes vos armes ~c~(~b~sauf les armes permanentes~c~)~s~")
	end

	----INV
	self.SecondInvData = {}

	self.setSecondInvData = function(data)
		self.SecondInvData = data
	end
	self.getSecondInvData = function()
		return self.SecondInvData
	end

	self.getInventory = function(minimal)
		local inventory = exports["inventory"]:GetInventoryItems(self.identifier)

		if minimal then
			local minimalInventory = {}

			for k, v in pairs(inventory) do
				table.insert(minimalInventory, {name = v.name, count = v.quantity, extra = v.meta})
			end

			return minimalInventory
		else
			return inventory
		end
	end

	self.getInventoryItem = function(name)
		local res = exports["inventory"]:GetItemBy(self.identifier, {
			name = name,
		})

		return res
	end

	self.saveInventory = function()
		return exports['core_nui']:saveInventory(self.identifier)
	end

	self.addInventoryItem = function(name, count, extra)
		if type(name) ~= 'string' then return end
		if type(count) ~= 'number' then return end
		count = ESX.Math.Round(count)
		if count < 1 then return end
		exports["inventory"]:AddItem(self.identifier, name, count, extra)

		return true
	end

	self.removeInventoryItemAtSlot = function(slot, count)
		if type(slot) ~= 'number' then return end
		if type(count) ~= 'number' then return end
		
		return exports['core_nui']:removeInventoryItemAtSlot(self.identifier, slot, count)
	end

	self.removeInventoryItem = function(name, count)
		if type(name) ~= 'string' then return end
		if type(count) ~= 'number' then return end
		count = ESX.Math.Round(count)
		if count < 1 then return end

		exports["inventory"]:RemoveItemBy(self.identifier, count, {
			name = name
		})

		return true
	end

	self.clearInventoryItem = function()
		return exports["inventory"]:ClearItems(self.identifier)
	end

	self.setInventoryItem = function(name, count, identifier)
		local item = self.getInventoryItem(name, identifier)

		if item and count >= 0 then
			count = ESX.Math.Round(count)

			if count > item.count then
				self.addInventoryItem(item.name, count - item.count)
			else
				self.removeInventoryItem(item.name, item.count - count)
			end
		end
	end

	self.hasInventoryItem = function(name)
		local res = exports["inventory"]:GetItemQuantityBy(self.identifier, {
			name = name
		})

		if res >= 1 then return true end

		return false
	end

	self.hasWeapon = function(weaponName)
        if type(weaponName) ~= 'string' then return false end
        weaponName = string.lower(weaponName)
		local isWeapon = exports["inventory"]:hasWeapon(self.identifier, weaponName)

        return isWeapon
    end

	self.getWeight = function()
		return exports["inventory"]:GetWeight(self.identifier)
	end

	self.getMaxWeight = function()
		return exports['core_nui']:getMaxWeight(self.identifier)
	end

	self.canCarryItem = function(name, count)
		return exports["inventory"]:CanCarryItem(self.identifier, name, count)
	end

	self.canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
		local firstItemObject = self.getInventoryItem(firstItem)

		if firstItemObject.count >= firstItemCount then
			local weightWithoutFirstItem = ESX.Math.Round(self.getWeight() - (ESX.Items[firstItem].weight * firstItemCount))
			local weightWithTestItem = ESX.Math.Round(weightWithoutFirstItem + (ESX.Items[testItem].weight * testItemCount))

			return weightWithTestItem <= self.maxWeight
		end

		return false
	end

	self.clearAllInventoryWeapons = function(perma)
		return exports["inventory"]:ClearWeapons(self.identifier, perma)
	end
	
	---@param weaponName string
	---@param quantity number
	---@return boolean
	self.addWeapon = function(weaponName, quantity, metadata)
		if type(weaponName) ~= 'string' then return end
		local weaponName = string.lower(weaponName);
		local isWeapon = exports["inventory"]:isWeapon(weaponName)

		if (isWeapon) then
			for i = 1, quantity do
				exports["inventory"]:AddItem(self.identifier, weaponName, 1, metadata)
			end

			return true
		end

		return false

	end

	self.removeWeapon = function(weaponName, serial)
		if type(weaponName) ~= 'string' then return end
		local weaponName = string.lower(weaponName)
		local isWeapon = exports["inventory"]:isWeapon(weaponName)
		local countofWeapon = exports["inventory"]:GetItemQuantityBy(self.identifier, {name = string.lower(weaponName)})

		if (isWeapon) then
			local ped = GetPlayerPed(self.source)
			local weapon = GetSelectedPedWeapon(ped)
			local unarmed = GetHashKey("WEAPON_UNARMED")

			if (weapon ~= unarmed) then
				RemoveAllPedWeapons(ped, true)
			end

			for i  = 1, countofWeapon do
				exports["inventory"]:RemoveItemBy(self.identifier, 1, {
					name = weaponName,
					meta = {
						serial = serial
					}
				})
			end

			return true
		end

		return false

	end

	self.CurrentWeaponId = nil
	self.getCurrentWeaponId = function()
		return CurrentWeaponId
	end
	self.setCurrentWeaponId = function(id)
		CurrentWeaponId = id
	end

	self.getWeaponsById = function(id)
		return exports['core_nui']:getWeaponsById(self.identifier, id)
	end

	self.getWeapon = function(weaponName)
		local isWeapon = exports["inventory"]:isWeapon(string.lower(weaponName))

		if (isWeapon) then
			local hasWeapon = exports["inventory"]:GetItemQuantityBy(self.identifier, {name = string.lower(weaponName)}) > 0 and true or false

			return hasWeapon
		end

		return false
	end

	self.setWeaponsAmmoById = function(id, ammo)
		exports['core_nui']:setWeaponsAmmoById(self.identifier, id, ammo)
	end

	self.getAccount = function(accountName)
		for i = 1, #self.accounts, 1 do
			if self.accounts[i].name == accountName then
				return self.accounts[i]
			end
		end
	end

	self.addAccountMoney = function(accountName, money)
		mny = ESX.Math.Check(ESX.Math.Round(money))
	
		if mny > 0 then
			local account = self.getAccount(accountName)

			if account then
				if (accountName == "cash" or accountName == "dirtycash") then
					if (self.hasInventoryItem(account.name)) then
						exports["inventory"]:SetItemQuantity(self.identifier, account.name, account.money + mny)
					else
						exports["inventory"]:AddItem(self.identifier, account.name, account.money + mny)
					end
				end

				local newMoney = ESX.Math.Check(account.money + mny)
				account.money = newMoney
				self.triggerEvent('esx:setAccountMoney', account)
				return true
			end
		end

		return false
	end

	self.removeAccountMoney = function(accountName, money)
		mny = ESX.Math.Check(ESX.Math.Round(money))
	
		if mny > 0 then
			local account = self.getAccount(accountName)

			if account then
				if (accountName == "cash" or accountName == "dirtycash") then
					if (self.hasInventoryItem(account.name)) then
						exports["inventory"]:SetItemQuantity(self.identifier, account.name, account.money - mny)
					end
				end

				local newMoney = ESX.Math.Check(account.money - mny)
				account.money = newMoney
				self.triggerEvent('esx:setAccountMoney', account)
				return true
			end
		end

		return false
	end

	self.getAccounts = function(minimal)
		if minimal then
			local minimalAccounts = {}

			for i = 1, #self.accounts, 1 do
				table.insert(minimalAccounts, {
					name = self.accounts[i].name,
					money = self.accounts[i].money
				})
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	self.setAccountMoney = function(accountName, money)
		money = ESX.Math.Check(ESX.Math.Round(money))
	
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				account.money = money
				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end
	-- ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.identifier, self.permission_group))

	---@return string
	self.getFirstName = function()
		return self.firstname;
	end

	---@return string
	self.getLastName = function()
		return self.lastname;
	end

	self.getSex = function()
		return self.sex
	end

	---@param discord string
	self.setDiscordID = function(discord)
		if (type(discord) == "string") then
			self.discord = discord
		end
	end
	
	self.getDiscordID = function()
		return self.discord
	end

	---@param discord string
	self.setFivemID = function(fivem)
		if (type(fivem) == "string") then
			self.fivem = fivem
		end
	end

	self.getFivemID = function()
		local fivem = GetPlayerIdentifierByType(self.source, "fivem")

		if (fivem) then
			fivem = string.gsub(fivem, "^fivem:", "")
			return fivem
		end

		return 0
	end

	self.triggerEvent = function(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	self.chatMessage = function(msg, author, color)
		self.triggerEvent('chat:addMessage', {color = color or {0, 0, 0}, args = {author or 'SYSTEME', msg or ''}})
	end

	self.GetVIP = function()
		return exports["engine"]:isPlayerVip(self.fivem, self.identifier);
	end

	self.GetCoins = function()
		return self.coins
	end

	---@param number number
	---@return boolean
	self.AddCoins = function(number)
		if (type(number) == "number") then
			self.coins += number

			MySQL.update('UPDATE users SET coins = ? WHERE identifier = ?', {
				self.coins,
				self.identifier
			})

			return true
		end

		return false
	end

	---@param number number
	---@return boolean
	self.RemoveCoins = function(number)
		if (type(number) == "number") then
			if ((self.coins - number) >= 0) then
				self.coins -= number

				MySQL.update('UPDATE users SET coins = ? WHERE identifier = ?', {
					self.coins,
					self.identifier
				})

				return true
			end
		end

		return false
	end

    function self.getXP()
		return self.xp;
	end

    function self.setXP(xp)
		self.xp = xp;
		self.saveXP();
		self.triggerEvent("iZeyy:Player:Update:XP", self.xp);
	end

	function self.addXP(xp)
        self.xp = self.xp + xp;
		self.saveXP();
		self.triggerEvent("iZeyy:Player:AddXP", xp);
	end

	function self.removeXP(xp)
		self.xp = self.xp - xp;
		self.saveXP();
		self.triggerEvent("iZeyy:Player:RemoveXP", xp);
	end

	function self.saveXP()
		MySQL.Async.execute('UPDATE users SET xp = @xp WHERE identifier = @identifier', {
			['@identifier'] = self.identifier,
			['@xp'] = self.xp
		});
	end

	self.kick = function(reason)
		DropPlayer(self.source, reason)
	end

	self.set = function(key, value)
		self[key] = value
	end

	self.get = function(key)
		return self[key]
	end

	self.getLevel = function()
		return self.permission_level
	end

	self.setLevel = function(level)
		local lastLevel = permission_level

		if type(level) == "number" then
			self.permission_level = level

			TriggerEvent('esx:setLevel', self.source, self.permission_level, lastLevel)
			self.triggerEvent('esx:setLevel', self.permission_level, lastLevel)
		end
	end

	self.getGroup = function()
		return self.permission_group
	end

	self.setGroup = function(groupName)
		local lastGroup = self.permission_group;

		if ESX.Groups[groupName] then
			self.permission_group = groupName

			for k, v in pairs(ESX.Groups) do
				ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.identifier, k))
			end
			-- ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.identifier, groupName))
			-- TriggerEvent('esx:setGroup', self.source, self.permission_group, lastGroup);
			self.triggerEvent('esx:setGroup', self.permission_group, lastGroup);
		else
			-- print(('[^3WARNING^7] Ignoring invalid .setGroup() usage for "%s"'):format(self.identifier))
		end
	end

	self.getIdentifier = function()
		return self.identifier
	end

	self.getJob = function()
		return self.job
	end

	self.getJob2 = function()
		return self.job2
	end

	self.getUniqueId = function()
		return self.uniqueid
	end

	self.getName = function()
		return self.name
	end

	self.setName = function(name)
		self.name = name
	end

	self.getCoords = function()
		local coords = GetEntityCoords(GetPlayerPed(self.source))

		if type(coords) ~= 'vector3' or ((coords.x >= -1.0 and coords.x <= 1.0) and (coords.y >= -1.0 and coords.y <= 1.0) and (coords.z >= -1.0 and coords.z <= 1.0)) then
			coords = self.getLastPosition()
		end

		return coords
	end

	self.getLastPosition = function()
		return self.lastPosition
	end

	self.setLastPosition = function(coords)
		self.lastPosition = coords
	end


	self.setJob = function(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
			local skins = ESX.ConvertJobSkins(gradeObject);

			self.job.id = jobObject.id or nil
			self.job.name = jobObject.name
			self.job.label = jobObject.label
			self.job.canWashMoney = jobObject.canWashMoney
			self.job.canUseOffshore = jobObject.canUseOffshore

			self.job.grade = tonumber(grade)
			self.job.grade_name = gradeObject.name
			self.job.grade_label = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			if gradeObject.skin_male then
				self.job.skin_male = skins["male"];
			end

			if gradeObject.skin_female then
				self.job.skin_female = skins["female"];
			end

			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
			self.triggerEvent('esx:setJob', self.job)
		else
			-- print(('[^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.identifier))
		end
	end

	self.setJob2 = function(job2, grade2)
		grade2 = tostring(grade2)
		local lastJob2 = json.decode(json.encode(self.job2))

		if ESX.DoesJobExist(job2, grade2) then
			local job2Object, grade2Object = ESX.Jobs[job2], ESX.Jobs[job2].grades[grade2]

			local skins = ESX.ConvertJobSkins(grade2Object);

			self.job2.id = job2Object.id
			self.job2.name = job2Object.name
			self.job2.label = job2Object.label
			self.job2.canWashMoney = job2Object.canWashMoney
			self.job2.canUseOffshore = job2Object.canUseOffshore

			self.job2.grade = tonumber(grade2)
			self.job2.grade_name = grade2Object.name
			self.job2.grade_label = grade2Object.label
			self.job2.grade_salary = grade2Object.salary

			if grade2Object.skin_male ~= nil then
				self.job2.skin_male = skins["male"];
			end

			if grade2Object.skin_female ~= nil then
				self.job2.skin_female = skins["female"];
			end

			TriggerEvent('esx:setJob2', self.source, self.job2, lastJob2)
			self.triggerEvent('esx:setJob2', self.job2)
		else
			-- print(('[^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.identifier))
		end
	end

	self.showNotification = function(msg, hudColorIndex)
		self.triggerEvent('esx:showNotification', msg, hudColorIndex)
	end

	self.showAdvancedNotification = function(title, subject, msg, icon, iconType, hudColorIndex)
		self.triggerEvent('esx:showAdvancedNotification', title, subject, msg, icon, iconType, hudColorIndex)
	end

	self.showHelpNotification = function(msg)
		self.triggerEvent('esx:showHelpNotification', msg)
	end

	---@param time number
	---@param message string
	self.ban = function(time, message)
		exports["WaveShield"]:banPlayer(self.source, message, "Protect Trigger", "Main", time)
	end

	return self
end
