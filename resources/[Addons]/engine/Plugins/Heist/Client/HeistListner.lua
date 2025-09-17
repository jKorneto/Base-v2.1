---@overload fun(): HeistListener
HeistListener = Class.new(function(class)

    ---@class HeistListener: BaseObject
    local self = class
    local mainMenu = nil
    local sellMenu = nil
    local houseData = {
        category = nil,
        position = nil,
        hasSleepingPed = false,
        exitPosition = nil,
        enterZone = nil,
        exitZone = nil,
        resellZone = nil,
        globalTimer = nil,
        inHouse = false,
        sleepingPed = nil,
        resellPed = nil,
        inTakeItem = false,
        itemCount = 0,
        blips = {},
        resellBlip = nil,
    }

    ---@private
    function self:Constructor()
        Shared:Initialized("HeistListener")
        mainMenu = HeistStorage:Get("main_menu")
        sellMenu = HeistStorage:Get("sell_menu")
        self:heistBlip()
        self:heistPed()
        self:createZone()
    end


    function self:heistBlip()
        local coords = Engine["Config"]["Heist"]["Blip"].coords
        local label = Engine["Config"]["Heist"]["Blip"].label
        local sprite = Engine["Config"]["Heist"]["Blip"].sprite
        local color = Engine["Config"]["Heist"]["Blip"].color

        Game.Blip("Heist",
            {
                coords = coords,
                label = label,
                sprite = sprite,
                color = color,
                scale = 0.5
            }
        )
    end

    function self:heistPed()
        local model = Engine["Config"]["Heist"]["Ped"].model
        local position = Engine["Config"]["Heist"]["Ped"].position
        local heading = Engine["Config"]["Heist"]["Ped"].heading
        local dictionary = Engine["Config"]["Heist"]["Ped"].dictionary
        local animation = Engine["Config"]["Heist"]["Ped"].animation
        local bone = Engine["Config"]["Heist"]["Ped"].bone
        local prop = Engine["Config"]["Heist"]["Ped"].prop

        Game.Peds:Spawn(model, position, heading, true, true, function(entity)
            Game.Streaming:RequestAnimDict(dictionary, function()
                local x, y, z = table.unpack(GetEntityCoords(entity))
                local model = Game.Streaming:RequestModel(GetHashKey(prop))

                if (model) then
                    attachedProp = CreateObject(GetHashKey(prop), x, y, z + 0.2, false, true, true)
                    AttachEntityToEntity(attachedProp, entity, GetPedBoneIndex(entity, bone), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                        true, true, false, true, 1, true)
                    TaskPlayAnim(entity, dictionary, animation, 8.0, -8.0, -1, 33, 0, false, false, false)
                end
            end)
        end)
    end

    function self:createZone()
        local coords = Engine["Config"]["Heist"]["Ped"].position

        local heistZone = Game.Zone("heistZone")

        heistZone:Start(function()
            heistZone:SetTimer(1000)
            heistZone:SetCoords(coords)

            heistZone:IsPlayerInRadius(5.0, function()
                heistZone:SetTimer(0)
                heistZone:Marker()

                heistZone:IsPlayerInRadius(3.0, function()
                    Game.Notification:ShowHelp("Appuyez sur ~INPUT_CONTEXT~ pour parler à Lester")

                    heistZone:KeyPressed("E", function()
                        self:openMenu()
                    end)
                end, false, false)
            end, false, false)

            heistZone:RadiusEvents(5.0, nil, function()
                mainMenu:Close()
            end)
        end)
    end

    function self:openMenu()
        mainMenu:Toggle()
    end

    function self:openSellMenu()
        sellMenu:Toggle()
    end

    ---@return boolean
    function self:canHouseHeist()
        local clockHours = GetClockHours()
        local houseStartHeistHours = Engine["Config"]["Heist"]["HouseHeistHours"].start
        local houseEndHeistHours = Engine["Config"]["Heist"]["HouseHeistHours"].ending - 1
        local canHouseHeist = nil

        if (houseStartHeistHours > houseEndHeistHours) then
            canHouseHeist = clockHours >= houseStartHeistHours or clockHours <= houseEndHeistHours
        else
            canHouseHeist = clockHours >= houseStartHeistHours and clockHours <= houseEndHeistHours
        end

        return canHouseHeist
    end
    
    function self:canGoFast()
        return false
    end

    function self:canFleecaHeist()
        return false
    end

    function self:canPacificStandardHeist()
        return false
    end

    function self:startHouseHeist()
        Shared.Events:ToServer(Engine["Enums"].Heist.Events.startHouseHeist)
    end

    ---@param category string
    function self:setHouseCategory(category)
        houseData.category = category
    end

    ---@param position vector3
    function self:setHousePosition(position)
        houseData.position = position
    end

    function self:getHouseCategory()
        return houseData.category
    end

    function self:getHousePosition()
        return houseData.position
    end

    function self:setInHouse(value)
        houseData.inHouse = value
    end

    function self:isInHouse()
        return houseData.inHouse
    end

    function self:addItemCount()
        houseData.itemCount += 1
        self:changePlayerSpeed()
    end

    function self:getItemCount()
        return houseData.itemCount
    end

    function self:resetItemCount()
        houseData.itemCount = 0
    end

    function self:changePlayerSpeed()
        local baseSpeed = 6.0
        local minSpeed = 3.0
        local newSpeed = baseSpeed - ((baseSpeed - minSpeed) * (self:getItemCount() / 10))

        if (newSpeed < minSpeed) then
            newSpeed = minSpeed
        end

        SetEntityMaxSpeed(Client.Player.GetPed(), newSpeed)
    end

    function self:resetPlayerSpeed()
        SetEntityMaxSpeed(Client.Player.GetPed(), 8.0)
    end

    function self:teleportToHouse()
        local position = Engine["Config"]["Heist"]["HousesInterior"][self:getHouseCategory()]

        if (position) then
            DoScreenFadeOut(1000)
            Wait(1000)
            SetEntityCoords(Client.Player.GetPed(), position.x, position.y, position.z)
            Wait(1000)
            DoScreenFadeIn(1000)
        end
    end

    function self:teleportToExterior()
        if (houseData.position) then
            DoScreenFadeOut(1000)
            Wait(1000)
            self:deleteSleepingPed()
            SetEntityCoords(Client.Player.GetPed(), houseData.position.x, houseData.position.y, houseData.position.z)
            Wait(1000)
            DoScreenFadeIn(1000)
        end
    end

    function self:startGlobalHouseTimer()
        local time = Engine["Config"]["Heist"]["GlobalHouseTimer"][self:getHouseCategory()]

        if (time) then
            houseData.globalTimer = Shared.Timer(60 * time)
            houseData.globalTimer:Start()
            self:showGlobalHouseTimer()
            Game.Notification:showNotification("Le braquage vient de commencer, tu dois l'avoir terminer dans %s minutes sinon t'auras échoué la mission", false, houseData.globalTimer:ShowRemaining())
        end
    end

    function self:resetGlobalHouseTimer()
        if (houseData.globalTimer ~= nil) then
            houseData.globalTimer = nil
        end
    end

    function self:failedHouseHeist()
        if (houseData.globalTimer == nil) then
            if (self:isInHouse()) then
                self:teleportToExterior()
            end

            Shared.Events:ToServer(Engine["Enums"].Heist.Events.failedHouseHeist)
            Game.Notification:showNotification("Tu as échoué le braquage, reviens me voir quand tu seras capable de faire un braquage de maison", false)
        end
    end

    function self:showGlobalHouseTimer()
        local function DrawAdvancedText(text, x, y, color, font)
            SetTextFont(ServerFontStyle)
            SetTextScale(0.0, 0.25)
            SetTextColour(color[1], color[2], color[3], color[4])
            SetTextCentre(true)
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName(text)
            EndTextCommandDisplayText(x, y)
        end
    
        local safeZone = GetSafeZoneSize()
        local safeZoneX = (1.0 - safeZone) * 0.5
        local safeZoneY = (1.0 - safeZone) * 0.5
        local drawX = 0.950 - safeZoneX
        local drawY = 0.950 - safeZoneY
    
        CreateThread(function()
            while houseData.globalTimer and not houseData.globalTimer:HasPassed() do
                local time = houseData.globalTimer:ShowRemaining()

                DrawSprite("timerbars", "all_black_bg", drawX, drawY, 0.1, 0.03, 0.0, 0, 0, 0, 180)
                DrawAdvancedText("Temps restant : " ..time, drawX, drawY - 0.015, {255, 255, 255, 255}, 4)
                Wait(0)
            end

            houseData.globalTimer = nil
            self:stopHouseEnterZone()
            self:stopHouseExitZone()
        end)
    end

    function self:sleepyPedCallPolice()
        Shared.Events:ToServer(Engine["Enums"].Heist.Events.callPolice)
        Game.Notification:showNotification("L'individu dans la maison a alerté la police, car il ta entendu courir !", false)
    end

    function self:startCheckSound()
        SetTimeout(3000, function()
            CreateThread(function()
                while self:isInHouse() do
                    local isPlayerRunning = IsPedRunning(Client.Player.GetPed())

                    if (isPlayerRunning) then
                        self:sleepyPedCallPolice()
                        break
                    end

                    Wait(1000)
                end
            end)
        end)
    end

    function self:spawnSleepingPed()
        if (self:hasSleepingPed()) then
            local ped = Engine["Config"]["Heist"]["SleepingPed"][self:getHouseCategory()]

            if (ped) then
                Game.Peds:Spawn(ped.model, ped.position, ped.heading, true, true, function(entity)
                    Game.Streaming:RequestAnimDict("timetable@tracy@sleep@", function()
                        TaskPlayAnim(entity, "timetable@tracy@sleep@", "base", 8.0, -8.0, -1, 33, 0, false, false, false)
                        houseData.sleepingPed = entity
                        self:startCheckSound()
                    end)
                end)

                Game.Notification:showNotification("Un individu est endormi dans la maison, il ne faut pas le réveiller (évite de courir)", false)
            end
        end
    end

    function self:deleteSleepingPed()
        if (houseData.sleepingPed) then
            DeleteEntity(houseData.sleepingPed)
            houseData.sleepingPed = nil
        end
    end

    function self:setHasSleepingPed(bool)
        if (type(bool) == "boolean") then
            houseData.hasSleepingPed = bool
        end
    end

    function self:hasSleepingPed()
        return houseData.hasSleepingPed
    end

    function self:startHouseEnterZone()
        houseData.enterZone = Game.Zone("houseHeistEnterZone")

        houseData.enterZone:Start(function()
            houseData.enterZone:SetTimer(1000)
            houseData.enterZone:SetCoords(self:getHousePosition())

            houseData.enterZone:IsPlayerInRadius(5.0, function()
                houseData.enterZone:SetTimer(0)
                houseData.enterZone:Marker()

                houseData.enterZone:IsPlayerInRadius(3.0, function()
                    Game.Notification:ShowHelp("Appuyez sur ~INPUT_CONTEXT~ pour rentrer dans la maison")

                    houseData.enterZone:KeyPressed("E", function()
                        local result = exports["minigames"]:StartLockpick(7, 5, 3)

                        if (result) then
                            self:teleportToHouse()
                            self:setInHouse(true)
                            self:startHouseExitZone()
                            self:startHouseItemsZone()
                            self:stopHouseEnterZone()
                            self:spawnSleepingPed()
                        else
                            Shared.Events:ToServer(Engine["Enums"].Heist.Events.failedHouseHeist)
                        end
                    end)
                end, false, false)
            end, false, false)
        end)

        self:startGlobalHouseTimer()
    end

    function self:stopHouseEnterZone()
        if (houseData.enterZone) then
            zoneDelete("houseHeistEnterZone")
            houseData.enterZone = nil
        end
    end

    function self:startHouseResellZone()
        local ped = Engine["Config"]["Heist"]["ResellPed"]

        if (ped) then
            Game.Peds:Spawn(ped.model, ped.position, ped.heading, true, true, function(entity)
                Game.Streaming:RequestAnimDict(ped.dictionary, function()
                    TaskPlayAnim(entity, ped.dictionary, ped.animation, 8.0, -8.0, -1, 33, 0, false, false, false)
                    houseData.resellPed = entity
                end)
            end)

            houseData.resellZone = Game.Zone("houseHeistResellZone")

            houseData.resellZone:Start(function()
                houseData.resellZone:SetTimer(1000)
                houseData.resellZone:SetCoords(ped.position)

                houseData.resellZone:IsPlayerInRadius(5.0, function()
                    houseData.resellZone:SetTimer(0)
                    houseData.resellZone:Marker()

                    houseData.resellZone:IsPlayerInRadius(3.0, function()
                        Game.Notification:ShowHelp("Appuyez sur ~INPUT_CONTEXT~ pour vendre les objets")

                        houseData.resellZone:KeyPressed("E", function()
                            Shared.Events:ToServer(Engine["Enums"].Heist.Events.sellItem, self:getHouseCategory())
                        end)
                    end, false, false)
                end, false, false)
            end)

            houseData.resellBlip = AddBlipForCoord(ped.position.x, ped.position.y, ped.position.z)
            SetBlipRoute(houseData.resellBlip, 1)

            Game.Notification:showNotification("Bien joué ! Maintenant faut vendre les objets que ta volé, je mets la position sur ton GPS", false)
        end
    end

    function self:stopHouseResellZone()
        if (houseData.resellZone) then
            zoneDelete("houseHeistResellZone")
            houseData.resellZone = nil
        end
    end

    function self:deleteResellBlip()
        if (houseData.resellBlip) then
            RemoveBlip(houseData.resellBlip)
            houseData.resellBlip = nil
        end
    end

    function self:deleteResellPed()
        if (houseData.resellPed) then
            DeleteEntity(houseData.resellPed)
            houseData.resellPed = nil
        end
    end

    function self:startHouseExitZone()
        if (houseData.enterZone) then
            local exitPosition = Engine["Config"]["Heist"]["HousesInterior"][self:getHouseCategory()]
            houseData.exitZone = Game.Zone("houseHeistExitZone")

            houseData.exitZone:Start(function()
                houseData.exitZone:SetTimer(1000)
                houseData.exitZone:SetCoords(exitPosition)

                houseData.exitZone:IsPlayerInRadius(5.0, function()
                    houseData.exitZone:SetTimer(0)
                    houseData.exitZone:Marker()

                    houseData.exitZone:IsPlayerInRadius(3.0, function()
                        Game.Notification:ShowHelp("Appuyez sur ~INPUT_CONTEXT~ pour sortir de la maison")

                        houseData.exitZone:KeyPressed("E", function()
                            self:teleportToExterior()
                            self:stopHouseExitZone()
                            self:setInHouse(false)
                            self:setInTakeItem(false)
                            self:resetPlayerSpeed()
                            self:deleteAllItemsBlip()

                            if (self:getItemCount() > 0) then
                                self:startHouseResellZone()
                            else
                                self:resetGlobalHouseTimer()
                            end
                        end)
                    end, false, false)
                end, false, false)
            end)
        end
    end

    function self:stopHouseExitZone()
        if (houseData.exitZone) then
            zoneDelete("houseHeistExitZone")
            houseData.exitZone = nil
        end
    end

    ---@param position vector3
    function self:createItemsBlip(position, index)
        if (type(position) == "vector3") then
            local blip = AddBlipForCoord(position.x, position.y, position.z)
            SetBlipScale(blip, 0.6)

            houseData.blips[index] = blip
        end
    end

    ---@param index number
    function self:deleteItemsBlip(index)
        if (type(index) == "number") then
            local blip = houseData.blips[index]

            if (blip) then
                RemoveBlip(blip)
                houseData.blips[index] = nil
            end
        end
    end

    function self:deleteAllItemsBlip()
        for i = 1, #houseData.blips do
            self:deleteItemsBlip(i)
        end
    end

    function self:getBlipCount()
        return Shared.Table:SizeOf(houseData.blips)
    end

    function self:setInTakeItem(bool)
        if (type(bool) == "boolean") then
            houseData.inTakeItem = bool
        end
    end

    function self:isInTakeItem()
        return houseData.inTakeItem
    end

    function self:startHouseItemsZone()
        local items = Engine["Config"]["Heist"]["HouseReward"][self:getHouseCategory()]

        if (items) then
            for i = 1, #items do
                local item = items[i]
                local position = item.position
                local label = item.label
                local itemName = item.item
                local itemZone = Game.Zone("houseHeistItemZone#" ..i)

                self:createItemsBlip(position, i)

                itemZone:Start(function()
                    itemZone:SetTimer(1000)
                    itemZone:SetCoords(position)
    
                    itemZone:IsPlayerInRadius(5.0, function()
                        itemZone:SetTimer(0)
                        itemZone:Marker()
    
                        itemZone:IsPlayerInRadius(1.0, function()
                            Game.Notification:ShowHelp("Appuyez sur ~INPUT_CONTEXT~ pour voler "..label)
    
                            itemZone:KeyPressed("E", function()
                                if (not self:isInTakeItem()) then
                                    self:setInTakeItem(true)
                                    Shared.Events:ToServer(Engine["Enums"].Heist.Events.takeHouseItem, i, self:getBlipCount())
                                end
                            end)
                        end, false, false)
                    end, false, false)
                end)
            end
        end
    end

    ---@param index number
    function self:deleteHouseItemZone(index)
        if (type(index) == "number") then
            zoneDelete("houseHeistItemZone#" ..index)
        end
    end

    function self:makeAlertPolice(coords)
        local blip = AddBlipForCoord(coords)
        SetBlipSprite(blip, 161)
        SetBlipScale(blip, 1.2)
        SetBlipColour(blip, 0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('[~r~Alerte~s~] Braquage de maison')
        EndTextCommandSetBlipName(blip)
        
        SetTimeout(80000, function()
            RemoveBlip(blip)
        end)
    end

    return self
end)