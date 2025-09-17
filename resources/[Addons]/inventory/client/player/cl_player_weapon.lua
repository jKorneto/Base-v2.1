local Weapons <const> = {}
---@type boolean
Weapons.armed = false
---@type string
Weapons.usedWeaponItemHash = nil
---@type number | nil
Weapons.floodProtect = GetGameTimer()

SetWeaponsNoAutoswap(CONFIG.NO_AUTOSWAP_ON_EMPTY)
SetWeaponsNoAutoreload(CONFIG.NO_AUTO_RELOAD)

local function findAmmoType(weaponHash)
    for k, v in pairs(CONFIG.AMMO_WEAPONS) do
        if k == weaponHash then
            return v
        end
    end
end

---@param item InventoryItem
function Weapons:Equip(item)
    local playerPed = PlayerPedId()

    local dict, anim = 'reaction@intimidation@1h', 'intro'
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end

    RequestWeaponAsset(item.data.weaponHash, 31, 0)
    while not HasWeaponAssetLoaded(item.data.weaponHash) do
        Wait(10)
    end

    TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, -1, 49, 0, false, false, false)

    self.usedWeaponItemHash = item.itemHash

    Wait(1000)

    --self:RecreateWeaponObject(item)
    self:SetArmedState(true)
    self:UpdateWeapon(item)
    self:UpdateAmmoCountInWearedWeapon()

    ClearPedTasks(playerPed)
end

local ammoThreadId = nil

---@param state boolean
function Weapons:SetArmedState(state)
    if self.armed == state then return end

    self.armed = state

    if self.armed then
        if ammoThreadId == nil then
            Citizen.CreateThreadNow(function(id)
                ammoThreadId = id

                while ammoThreadId ~= nil do
                    local playerPed = PlayerPedId()
                    local currentWeapon = GetSelectedPedWeapon(playerPed)

                    if IsPedShooting(playerPed) then
                        if CONFIG.MISC_WEAPONS[currentWeapon] and self.floodProtect < GetGameTimer() then
                            TriggerServerEvent("inventory:REDUCE_WEAPON_AMMO")
                            self.floodProtect = GetGameTimer() + 200
                        elseif CONFIG.AMMO_WEAPONS[currentWeapon] then
                            TriggerServerEvent("inventory:REDUCE_WEAPON_DURABILITY")
                            TriggerServerEvent('inventory:REDUCE_WEAPON_AMMO')
                        elseif CONFIG.THROWABLE_WEAPONS[currentWeapon] then
                            TriggerServerEvent('inventory:REDUCE_WEAPON_AMMO')
                        end
                    elseif IsControlJustReleased(0, 24) and IsPedPerformingMeleeAction(playerPed) and CONFIG.MELEE_WEAPONS[currentWeapon] and self.floodProtect < GetGameTimer() then
                        TriggerServerEvent("inventory:REDUCE_WEAPON_DURABILITY")
                        self.floodProtect = GetGameTimer() + 200
                    end

                    if not self.armed and self.thread then
                        self.thread.stop()
                        self.thread = nil
                    end

                    Wait(0)
                end
            end)
        end
    else
        if ammoThreadId ~= nil then
            ammoThreadId = nil
        end
    end
end

function Weapons:UpdateAmmoCountInWearedWeapon()
    if not self.armed then return end

    local playerPed = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(playerPed)

    local ammoCount = nil
    if CONFIG.AMMO_WEAPONS[currentWeapon] then
        local ammoType = findAmmoType(currentWeapon)
        if ammoType then
            ammoCount = ScriptClient.Player.Inventory:GetItemQuantityBy({ name = ammoType })
        end
    end

    if type(ammoCount) == "number" then
        SetPedAmmo(playerPed, currentWeapon, ammoCount)
    end
end

---@param item InventoryItem
function Weapons:UpdateWeapon(item)
    local playerPed = PlayerPedId()

    self.usedWeaponItemHash = item.itemHash

    local currentWeapon = GetSelectedPedWeapon(playerPed)
    if not currentWeapon then return end

    if CONFIG.MISC_WEAPONS[currentWeapon] then
        local weaponItem = ScriptClient.Player.Inventory:GetItemBy({ itemHash = self.usedWeaponItemHash })
        if weaponItem then
            SetPedInfiniteAmmo(playerPed, weaponItem.quantity > 0, currentWeapon)
        end
    elseif CONFIG.THROWABLE_WEAPONS[currentWeapon] then
        local weaponItem = ScriptClient.Player.Inventory:GetItemBy({ itemHash = self.usedWeaponItemHash })
        if weaponItem then
            SetPedAmmo(playerPed, currentWeapon, weaponItem.quantity)
        end
    end
end

---@param item InventoryItem
function Weapons:RecreateWeaponObject(item)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local weaponObject = CreateWeaponObject(item.data.weaponHash, 0, coords.x, coords.y, coords.z, true, 0.0, 0)

    if type(item.meta.attachments) == "table" then
        for i = 1, #item.meta.attachments do
            local attItemName = item.meta.attachments[i]
            local rockstarAtts = CONFIG.WEAPON_COMPONENTS[attItemName]
            if type(rockstarAtts) == "table" then
                for j = 1, #rockstarAtts do
                    local componentName = rockstarAtts[j]
                    if DoesWeaponTakeWeaponComponent(item.data.weaponHash, componentName) then
                        if not HasWeaponGotWeaponComponent(weaponObject, componentName) then
                            GiveWeaponComponentToWeaponObject(weaponObject, componentName)
                        end
                    end
                end
            end
        end
    end

    RemoveAllPedWeapons(playerPed, false)
    GiveWeaponObjectToPed(weaponObject, playerPed)
    RemoveWeaponAsset(item.data.weaponHash)
end

function Weapons:Disarm()
    local playerPed = PlayerPedId()

    local dict, anim = 'reaction@intimidation@1h', 'intro'

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(1)
    end

    TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, -1, 49, 0, false, false, false)

    self.usedWeaponItemHash = nil

    Wait(1000)
    ClearPedTasks(playerPed)
    RemoveAllPedWeapons(playerPed, false)
    self:SetArmedState(false)
end

---@param item InventoryItem
RegisterNetEvent("inventory:equipWeapon", function(item)
    --if (not exports["core"]:PlayerIsInSafeZone()) then
        Weapons:Equip(item)
    --end
end)
RegisterNetEvent("inventory:disarmWeapon", function()
    --if (not exports["core"]:PlayerIsInSafeZone()) then
        Weapons:Disarm()
    --end
end)
---@param item InventoryItem
RegisterNetEvent("inventory:updateCurrentWeapon", function(item)
    Weapons:UpdateWeapon(item)
end)
RegisterNetEvent("inventory:onPlayerItemUpdated", function(item)
    Weapons:UpdateAmmoCountInWearedWeapon()
end)
RegisterNetEvent("inventory:onPlayerItemRemoved", function(item)
    Weapons:UpdateAmmoCountInWearedWeapon()
end)
RegisterNetEvent("inventory:onPlayerItemAdded", function(item)
    Weapons:UpdateAmmoCountInWearedWeapon()
end)
---@param item InventoryItem
RegisterNetEvent("inventory:UpdateWeaponAttachments", function(item)
    --Weapons:RecreateWeaponObject(item)
    Weapons:Disarm()
end)

RegisterNetEvent("baseevents:onPlayerDied", function()
    Weapons:Disarm()
end)
