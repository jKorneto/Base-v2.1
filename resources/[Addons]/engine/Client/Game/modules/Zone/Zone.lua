---@type Zone[]
local Zones = {}

---@type GameZone
GameZone = Class.new(function(class)
    
    ---@class GameZone: BaseObject
    local self = class

    ---@private
    ---@param data table @data.job string @data.jobGrade string @data.job2 string @data.job2Grade string @data.timer number @data.coords vector3
    function self:Constructor(id, data)
        if data == nil then data = {} end
        if not id or type(id) ~= "string" then return error(("^3Zone^7 | ^1 Id must be a string^7"):format(GetCurrentResourceName())) end
        self.id = id
        self.data = {
            job = data.job or "not",
            jobGrade = data.jobGrade or "not",
            job2 = data.job2 or "not",
            job2Grade = data.job2Grade or "not",
            coords = data.coords or {}
        }

        self.radius = {}
        self.timer = (data and data.timer) or 0
        self.running = false

        Zones[self.id] = self
    end

    ---@param callback function
    function self:SetCallback(callback)
        self.callback = callback
    end

    ---@param callback function
    function self:Start(callback)
        if callback then self.callback = callback end
        self.running = true
        CreateThread(function()
            while not Client.Player do Wait(0) end
            while self.running do
                self.callback()
                Wait(self.timer)
            end
        end)
    end

    ---@param timer number
    function self:SetTimer(timer)
        self.timer = timer
    end

    ---@param timer number
    function self:AddTimer(timer)
        Wait(timer)
    end

    ---@return number
    function self:GetTimer()
        return self.timer
    end

    ---Resume the zone
    function self:Resume()
        if not self.running then
            self:Start()
        end
    end

    ---Stop the zone
    function self:Stop()
        self.running = false
    end

    ---Delete the zone
    function zoneDelete(id)
        for k, _ in pairs(Zones) do
            local zone = Zones[k]
            if zone.id == id then
                zone:Stop()
                Zones[k] = nil
                break
            end
        end
    end

    ---@return boolean
    function self:IsRunning()
        return self.running
    end

    ---@param zAxis number
    ---@param marker number
    ---@param radius number
    ---@param rgb table<r, g, b, a1, a2>
    function self:Marker(zAxis, marker, radius, markerType, rgb)
        if markerType == "vehicle" then
            return DrawMarker(
                marker or 6, 
                self.coords.x, 
                self.coords.y, 
                self.coords.z + (zAxis or - 0.98),
                0.0, 
                0.0, 
                0.0, 
                -90.0,
                0.0, 
                0.0, 
                radius or 3.0, 
                radius or 3.0, 
                radius or 3.0, 
                rgb and rgb.r or 225,
                rgb and rgb.g or 225,
                rgb and rgb.b or 225,
                rgb and rgb.a1 or 230,
                false, 
                false, 
                nil, 
                false, 
                false, 
                false, 
                false
            ),
            DrawMarker(
                1, 
                self.coords.x, 
                self.coords.y, 
                self.coords.z + (zAxis or - 0.98), 
                0.0, 
                0.0, 
                0.0, 
                0.0, 
                0.0, 
                0.0, 
                radius or 0.50, 
                radius or 0.50,  
                0.50,
                rgb and rgb.r or 255,
                rgb and rgb.g or 255,
                rgb and rgb.b or 255,
                rgb and rgb.a1 or 100,
                false, 
                true, 
                nil, 
                false, 
                false, 
                false, 
                false
            )
        end
        return DrawMarker(
            marker or 23, 
            self.coords.x, 
            self.coords.y, 
            self.coords.z + (zAxis or - 0.98),
            0.0, 
            0.0, 
            0.0, 
            0.0,
            0.0, 
            0.0, 
            radius or 0.50, 
            radius or 0.50, 
            radius or 0.50, 
            rgb and rgb.r or 225,
            rgb and rgb.g or 225,
            rgb and rgb.b or 225,
            rgb and rgb.a1 or 225,
            false, 
            true, 
            nil, 
            false, 
            false, 
            false, 
            false
        )
    end

    ---@param text string
    ---@param size number
    ---@param zAxis number
    function self:Text(text, size, zAxis)
        if (RageUI.NotificationEnabled) then
            return Game:DrawText3D(vector3(self.coords.x, self.coords.y, self.coords.z + (zAxis or 0.2)), text, size or 0.6)
        end
    end

    ---@return number
    function self:GetDistance()
        return #(GetEntityCoords(PlayerPedId()) - self.coords)
    end

    ---@param radius number
    ---@param callback function
    ---@param allowVehicle boolean
    ---@param onlyInVehicle boolean
    function self:IsPlayerInRadius(radius, callback, allowVehicle, onlyInVehicle)
        if self:GetDistance() <= radius 
            and (
                    (   
                        not allowVehicle 
                        and not onlyInVehicle 
                        and not Client.Player:IsInVehicle(-1)
                    )
                    or (
                            allowVehicle 
                            and not onlyInVehicle
                        )
                    or (
                        not allowVehicle 
                        and onlyInVehicle 
                        and Client.Player:IsInVehicle(-1)
                    )
                )
        then
            if (callback) then callback() end
        end
    end

    ---@param radius number
    ---@param onEnter function
    ---@param onLeave function
    function self:RadiusEvents(radius, onEnter, onLeave)
        local name = tostring(radius).. self.coords
        if (not self.radius[name]) then
            self.radius[name] = "N/A"
        end
        if (
                self.radius[name] == "N/A" 
                and self:GetDistance() <= radius
            )
        then
            self.radius[name] = "IN"
            if (onEnter) then onEnter() end
        elseif self:GetDistance() > radius
            and self.radius[name] == "IN"
        then
            self.radius[name] = "N/A"
            if (onLeave) then onLeave() end
        end
    end

    ---@param key string
    ---@param value any
    function self:SetData(key, value)
        self.data[key] = value
    end

    ---@param key string
    function self:GetData(key)
        return self.data[key]
    end

    ---@param key string
    ---@param callback function
    function self:KeyPressed(key, callback)
        if (IsControlJustReleased(0, Engine["Enums"].Controls[key])) then
            if (callback) then callback() else return end
        end
    end

    ---@param coords vector3
    function self:SetCoords(coords)
        self.coords = coords
    end

    return self
end)

local function reloadZones()
    CreateThread(function()
        for k, _ in pairs(Zones) do
            local player = Client.Player
            local zone = Zones[k]
            if player:GetJob().name == zone.data.job and zone.data.jobGrade == "not"
                    or (Shared:IsJob2Enabled()) and player:GetJob2().name == zone.data.job2 and zone.data.job2Grade == "not"
                    or player:GetJob().name == zone.data.job and zone.data.jobGrade == player:GetJob().grade_name
                    or (Shared:IsJob2Enabled()) and player:GetJob2().name == zone.data.job2 and zone.data.job2Grade == player:GetJob2().grade_name
                    or zone.data.job == "not" and zone.data.jobGrade == player:GetJob().grade_name
                    or (Shared:IsJob2Enabled()) and zone.data.job2 == "not" and zone.data.job2Grade == player:GetJob2().grade_name
            then
                if (not zone:IsRunning() and zone.callback) then
                    zone:Resume()
                end
            elseif zone.data.job == "not" 
                and zone.data.jobGrade == "not" 
                and zone.data.job2 == "not" 
                and zone.data.job2Grade == "not" 
            then
                if (not zone:IsRunning() and zone.callback) then
                    zone:Resume()
                end
            else
                if (zone:IsRunning()) then
                    zone:Stop()
                end
            end
        end
    end)
end

Shared.Events:On(Engine["Enums"].Player.Events.updateZonesAndBlips, function()
    reloadZones()
end)