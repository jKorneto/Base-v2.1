local function CreateCamForShop(fov)
   CreateThread(function()
        local fov = tonumber(string.format("%.1f", fov or 40)) or 45.0
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)

        SetCamActive(cam, true)
        SetCamCoord(cam, -146.09744262695, -600.02667236328, 168.00030517578)
        SetCamFov(cam, fov or 45.0)
        PointCamAtCoord(cam, -147.47764587402, -593.23937988281, 167.00012207031)

        RenderScriptCams(1, 1, 1500, 0, 0)
   end)
end

local function KillCam()
   RenderScriptCams(0, 1, 1500, 0, 0)
   SetCamActive(cam, false)
   ClearPedTasks(PlayerPedId())
   DestroyAllCams(true)
end

local function Repair(netID)
    local vehicle = NetworkGetEntityFromNetworkId(netID)

    if (vehicle == 0) then
        return
    end

    local ped = PlayerPedId()
    local currentColor = GetVehicleXenonLightsColor(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleEngineOn(vehicle, true, false)
    ClearVehicleCustomPrimaryColour(vehicle)
    SetVehicleColours(vehicle, 1, 121)
    SetVehicleExtraColours(vehicle, 7, wheelColor)
    SetVehicleInteriorColor(vehicle, 2)
    SetVehicleLights(vehicle, 3)
    ToggleVehicleMod(vehicle, Enums.Vehicles.Customisation.modXenon, true)
    SetVehicleXenonLightsColour(vehicle, -1)
end

RegisterNetEvent('boutique:repairVehicle', function(netID)
    Repair(netID)
end)

---todo disable this for public
active = false
RegisterCommand("Camera", function(source, args)
    active = not active
    if active then
        CreateCamForShop(args[1])
        SetEntityCoords(PlayerPedId(), -141.26071166992, -604.31726074219, 167.59603881836)
    else
        DisplayRadar(false)
        exports["core"]:toggleHUD(false)
        KillCam()
    end
end)

RegisterCommand("photobou", function(source, args)
    local lavoiture = args[1]
    DisplayRadar(false)
    exports["core"]:toggleHUD(false)
    TriggerServerEvent("boutique:spawnVehicle", lavoiture)
end)

RegisterCommand("setCamFov", function(source, args)
    local fov = args[1]
    if (fov) then
        local fov = tonumber(string.format("%.1f", fov or 40)) or 40.0
        SetCamFov(cam, fov or 45.0)
    end
end)local function CreateCamForShop(fov)
   CreateThread(function()
        local fov = tonumber(string.format("%.1f", fov or 40)) or 45.0
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)

        SetCamActive(cam, true)
        SetCamCoord(cam, -146.09744262695, -600.02667236328, 168.00030517578)
        SetCamFov(cam, fov or 45.0)
        PointCamAtCoord(cam, -147.47764587402, -593.23937988281, 167.00012207031)

        RenderScriptCams(1, 1, 1500, 0, 0)
   end)
end

local function KillCam()
   RenderScriptCams(0, 1, 1500, 0, 0)
   SetCamActive(cam, false)
   ClearPedTasks(PlayerPedId())
   DestroyAllCams(true)
end

local function Repair(netID)
    local vehicle = NetworkGetEntityFromNetworkId(netID)

    if (vehicle == 0) then
        return
    end

    local ped = PlayerPedId()
    local currentColor = GetVehicleXenonLightsColor(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleEngineOn(vehicle, true, false)
    ClearVehicleCustomPrimaryColour(vehicle)
    SetVehicleColours(vehicle, 1, 121)
    SetVehicleExtraColours(vehicle, 7, wheelColor)
    SetVehicleInteriorColor(vehicle, 2)
    SetVehicleLights(vehicle, 3)
    ToggleVehicleMod(vehicle, Enums.Vehicles.Customisation.modXenon, true)
    SetVehicleXenonLightsColour(vehicle, -1)
end

RegisterNetEvent('boutique:repairVehicle', function(netID)
    Repair(netID)
end)

---todo disable this for public
active = false
RegisterCommand("Camera", function(source, args)
    active = not active
    if active then
        CreateCamForShop(args[1])
        SetEntityCoords(PlayerPedId(), -141.26071166992, -604.31726074219, 167.59603881836)
    else
        DisplayRadar(false)
        exports["core"]:toggleHUD(false)
        KillCam()
    end
end)

RegisterCommand("photobou", function(source, args)
    local lavoiture = args[1]
    DisplayRadar(false)
    exports["core"]:toggleHUD(false)
    TriggerServerEvent("boutique:spawnVehicle", lavoiture)
end)

RegisterCommand("setCamFov", function(source, args)
    local fov = args[1]
    if (fov) then
        local fov = tonumber(string.format("%.1f", fov or 40)) or 40.0
        SetCamFov(cam, fov or 45.0)
    end
end)local function CreateCamForShop(fov)
   CreateThread(function()
        local fov = tonumber(string.format("%.1f", fov or 40)) or 45.0
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)

        SetCamActive(cam, true)
        SetCamCoord(cam, -146.09744262695, -600.02667236328, 168.00030517578)
        SetCamFov(cam, fov or 45.0)
        PointCamAtCoord(cam, -147.47764587402, -593.23937988281, 167.00012207031)

        RenderScriptCams(1, 1, 1500, 0, 0)
   end)
end

local function KillCam()
   RenderScriptCams(0, 1, 1500, 0, 0)
   SetCamActive(cam, false)
   ClearPedTasks(PlayerPedId())
   DestroyAllCams(true)
end

local function Repair(netID)
    local vehicle = NetworkGetEntityFromNetworkId(netID)

    if (vehicle == 0) then
        return
    end

    local ped = PlayerPedId()
    local currentColor = GetVehicleXenonLightsColor(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleEngineOn(vehicle, true, false)
    ClearVehicleCustomPrimaryColour(vehicle)
    SetVehicleColours(vehicle, 1, 121)
    SetVehicleExtraColours(vehicle, 7, wheelColor)
    SetVehicleInteriorColor(vehicle, 2)
    SetVehicleLights(vehicle, 3)
    ToggleVehicleMod(vehicle, Enums.Vehicles.Customisation.modXenon, true)
    SetVehicleXenonLightsColour(vehicle, -1)
end

RegisterNetEvent('boutique:repairVehicle', function(netID)
    Repair(netID)
end)

---todo disable this for public
active = false
RegisterCommand("Camera", function(source, args)
    active = not active
    if active then
        CreateCamForShop(args[1])
        SetEntityCoords(PlayerPedId(), -141.26071166992, -604.31726074219, 167.59603881836)
    else
        DisplayRadar(false)
        InteractMenuShowHud()
        KillCam()
    end
end)

RegisterCommand("photobou", function(source, args)
    local lavoiture = args[1]
    DisplayRadar(false)
    InteractMenuShowHud()
    TriggerServerEvent("boutique:spawnVehicle", lavoiture)
end)

RegisterCommand("setCamFov", function(source, args)
    local fov = args[1]
    if (fov) then
        local fov = tonumber(string.format("%.1f", fov or 40)) or 40.0
        SetCamFov(cam, fov or 45.0)
    end
end)