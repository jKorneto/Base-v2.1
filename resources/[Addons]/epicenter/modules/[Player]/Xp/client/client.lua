local RockstarRanks = {800, 2100, 3800, 6100, 9500, 12500, 16000, 19800, 24000, 28500, 33400, 38700, 44200, 50200,56400, 63000, 69900, 77100, 84700, 92500, 100700, 109200, 118000, 127100, 136500, 146200, 156200,166500, 177100, 188000, 199200, 210700, 222400, 234500, 246800, 259400, 272300, 285500, 299000,312700, 326800, 341000, 355600, 370500, 385600, 401000, 416600, 432600, 448800, 465200, 482000,499000, 516300, 533800, 551600, 569600, 588000, 606500, 625400, 644500, 663800, 683400, 703300,723400, 743800, 764500, 785400, 806500, 827900, 849600, 871500, 893600, 916000, 938700, 961600,984700, 1008100, 1031800, 1055700, 1079800, 1104200, 1128800, 1153700, 1178800, 1204200, 1229800,1255600, 1281700, 1308100, 1334600, 1361400, 1388500, 1415800, 1443300, 1471100, 1499100,1527300, 1555800, 1584350}
UseRedBarWhenLosingXP = true
MaxPlayerLevel = 500
EnableZKeyForRankbar = true
CurrentPlayerXP = 0
local PalierCount = 0

-- RegisterKeyMapping('-xpBar', 'Afficher votre Niveau', 'keyboard', 'Z')

RegisterCommand("-xpBar", function()
    if not EnableZKeyForRankbar then
        return
    end
    CurLevel = GetLevelFromXP(CurrentPlayerXP)
    CreateRankBar(GetXPFloorForLevel(CurLevel), GetXPCeilingForLevel(CurLevel), CurrentPlayerXP,CurrentPlayerXP, CurLevel, false)
end)

exports('SetInitialXPLevels', function(EXCurrentXP, EXShowRankBar, EXShowRankBarAnimating)
    SetInitialXPLevels(EXCurrentXP, EXShowRankBar, EXShowRankBarAnimating)
end)
exports('AddPlayerXP', function(EXXPAmount)
    AddPlayerXP(EXXPAmount)
end)

exports('RemovePlayerXP', function(EXXPAmount)
    RemovePlayerXP(EXXPAmount)
end)
exports('GetCurrentPlayerXP', function()
    return tonumber(GetCurrentPlayerXP())
end)
exports('GetLevelFromXP', function(EXXPAmount)
    return GetLevelFromXP(EXXPAmount)
end)
exports('GetCurrentPlayerLevel', function()
    return tonumber(GetCurrentPlayerLevel())
end)

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    SetInitialXPLevels(xPlayer.xp, true, true)
end);

RegisterNetEvent("iZeyy:Player:ReloadPlayer", function(xPlayer)
    SetInitialXPLevels(xPlayer.xp, true, true)
end);

RegisterNetEvent("iZeyy:Player:Update:XP", function(xp)
    XNP_SetInitialXPLevels(xp, true, true)
end)

RegisterNetEvent("iZeyy:Player:AddXP", function(NetXPAmmount)
    AddPlayerXP(NetXPAmmount)
end)

RegisterNetEvent("iZeyy:Player:RemoveXP", function(NetXPAmmount)
    RemovePlayerXP(NetXPAmmount)
end)

function SetInitialXPLevels(CurrentXP, ShowRankBar, ShowRankBarAnimating)
    CurrentPlayerXP = CurrentXP
    if ShowRankBar then
        CurLevel = GetLevelFromXP(CurrentXP)
        AnimateFrom = CurrentXP
        if ShowRankBarAnimating then
            AnimateFrom = GetXPFloorForLevel(CurLevel)
        end
        CreateRankBar(GetXPFloorForLevel(CurLevel), GetXPCeilingForLevel(CurLevel), AnimateFrom,
            CurrentPlayerXP, CurLevel, false)
    end
end

function GetCurrentPlayerXP()
    return CurrentPlayerXP
end
function GetCurrentPlayerLevel()
    return GetLevelFromXP(CurrentPlayerXP)
end
function OnPlayerLevelUp()
end
function OnPlayerLevelsLost()
end
function AddPlayerXP(XPAmount)
    if not is_int(XPAmount) then
        return
    end
    if XPAmount < 0 then
        return
    end
    local CurrentLevel = GetLevelFromXP(CurrentPlayerXP)
    local CurrentXPWithAddedXP = CurrentPlayerXP + XPAmount
    local NewLevel = GetLevelFromXP(CurrentXPWithAddedXP)
    local LevelDifference = 0
    if NewLevel > MaxPlayerLevel - 1 then
        NewLevel = MaxPlayerLevel - 1
        CurrentXPWithAddedXP = GetXPCeilingForLevel(MaxPlayerLevel - 1)
    end
    if NewLevel > CurrentLevel then
        LevelDifference = NewLevel - CurrentLevel
    end
    if LevelDifference > 0 then
        StartAtLevel = CurrentLevel
        CreateRankBar(GetXPFloorForLevel(StartAtLevel), GetXPCeilingForLevel(StartAtLevel), CurrentPlayerXP,
            GetXPCeilingForLevel(StartAtLevel), StartAtLevel, false)
        for i = 1, LevelDifference, 1 do
            StartAtLevel = StartAtLevel + 1
            if i == LevelDifference then
                CreateRankBar(GetXPFloorForLevel(StartAtLevel), GetXPCeilingForLevel(StartAtLevel),
                    GetXPFloorForLevel(StartAtLevel), CurrentXPWithAddedXP, StartAtLevel, false)
            else
                CreateRankBar(GetXPFloorForLevel(StartAtLevel), GetXPCeilingForLevel(StartAtLevel),
                    GetXPFloorForLevel(StartAtLevel), GetXPCeilingForLevel(StartAtLevel), StartAtLevel, false)
            end
        end
    else
        CreateRankBar(GetXPFloorForLevel(NewLevel), GetXPCeilingForLevel(NewLevel), CurrentPlayerXP,
            CurrentXPWithAddedXP, NewLevel, false)
    end
    CurrentPlayerXP = CurrentXPWithAddedXP
    if LevelDifference > 0 then
        OnPlayerLevelUp()
    end
end
function RemovePlayerXP(XPAmount)
    if not is_int(XPAmount) then
        return
    end
    if XPAmount < 0 then
        return
    end
    local CurrentLevel = GetLevelFromXP(CurrentPlayerXP)
    local CurrentXPWithRemovedXP = CurrentPlayerXP - XPAmount
    local NewLevel = GetLevelFromXP(CurrentXPWithRemovedXP)
    local LevelDifference = 0
    if NewLevel < 1 then
        NewLevel = 1
    end
    if CurrentXPWithRemovedXP < 0 then
        CurrentXPWithRemovedXP = 0
    end
    if NewLevel < CurrentLevel then
        LevelDifference = math.abs(NewLevel - CurrentLevel)
    end
    if LevelDifference > 0 then
        StartAtLevel = CurrentLevel
        CreateRankBar(GetXPFloorForLevel(StartAtLevel), GetXPCeilingForLevel(StartAtLevel), CurrentPlayerXP,
            GetXPFloorForLevel(StartAtLevel), StartAtLevel, true)
        for i = 1, LevelDifference, 1 do
            StartAtLevel = StartAtLevel - 1
            if i == LevelDifference then
                CreateRankBar(GetXPFloorForLevel(StartAtLevel), GetXPCeilingForLevel(StartAtLevel),
                    GetXPCeilingForLevel(StartAtLevel), CurrentXPWithRemovedXP, StartAtLevel, true)
            else
                CreateRankBar(GetXPFloorForLevel(StartAtLevel), GetXPCeilingForLevel(StartAtLevel),
                    GetXPCeilingForLevel(StartAtLevel), GetXPFloorForLevel(StartAtLevel), StartAtLevel, true)
            end
        end
    else
        CreateRankBar(GetXPFloorForLevel(NewLevel), GetXPCeilingForLevel(NewLevel), CurrentPlayerXP,
            CurrentXPWithRemovedXP, NewLevel, true)
    end
    CurrentPlayerXP = CurrentXPWithRemovedXP
    if LevelDifference > 0 then
        OnPlayerLevelsLost()
    end
end
function GetXPFloorForLevel(intLevelNr)
    if is_int(intLevelNr) then
        if intLevelNr > 7999 then
            intLevelNr = 7999
        end
        if intLevelNr < 2 then
            return 0
        end
        if intLevelNr > 100 then
            BaseXP = RockstarRanks[99]
            ExtraAddPerLevel = 50
            MainAddPerLevel = 28550
            BaseLevel = intLevelNr - 100
            CurXPNeeded = 0
            for i = 1, BaseLevel, 1 do
                MainAddPerLevel = MainAddPerLevel + 50
                CurXPNeeded = CurXPNeeded + MainAddPerLevel
            end
            return BaseXP + CurXPNeeded
        end
        return RockstarRanks[intLevelNr - 1]
    else
        return 0
    end
end
function GetXPCeilingForLevel(intLevelNr)
    if is_int(intLevelNr) then
        if intLevelNr > 7999 then
            intLevelNr = 7999
        end
        if intLevelNr < 1 then
            return 800
        end
        if intLevelNr > 99 then
            BaseXP = RockstarRanks[99]
            ExtraAddPerLevel = 50
            MainAddPerLevel = 28550
            BaseLevel = intLevelNr - 99
            CurXPNeeded = 0
            for i = 1, BaseLevel, 1 do
                MainAddPerLevel = MainAddPerLevel + 50
                CurXPNeeded = CurXPNeeded + MainAddPerLevel
            end
            return BaseXP + CurXPNeeded
        end
        return RockstarRanks[intLevelNr]
    else
        return 0
    end
end
function GetLevelFromXP(intXPAmount)
    if is_int(intXPAmount) then
        local SearchingFor = intXPAmount
        if SearchingFor < 0 then
            return 1
        end
        if SearchingFor < RockstarRanks[99] then
            local CurLevelFound = -1
            local CurrentLevelScan = 0
            for k, v in pairs(RockstarRanks) do
                CurrentLevelScan = CurrentLevelScan + 1
                if SearchingFor < v then
                    break
                end
            end
            return CurrentLevelScan
        else
            BaseXP = RockstarRanks[99]
            ExtraAddPerLevel = 50
            MainAddPerLevel = 28550
            CurXPNeeded = 0
            local CurLevelFound = -1
            for i = 1, MaxPlayerLevel - 99, 1 do
                MainAddPerLevel = MainAddPerLevel + 50
                CurXPNeeded = CurXPNeeded + MainAddPerLevel
                CurLevelFound = i
                if SearchingFor < (BaseXP + CurXPNeeded) then
                    break
                end
            end
            return CurLevelFound + 99
        end
    else
        return 1
    end
end
function CreateRankBar(XP_StartLimit_RankBar, XP_EndLimit_RankBar, playersPreviousXP, playersCurrentXP,
    CurrentPlayerLevel, TakingAwayXP)
    RankBarColor = 116
    if TakingAwayXP and UseRedBarWhenLosingXP then
        RankBarColor = 6
    end
    if not HasHudScaleformLoaded(19) then
        RequestHudScaleform(19)
        while not HasHudScaleformLoaded(19) do
            Wait(1)
        end
    end
    BeginScaleformMovieMethodHudComponent(19, "SET_COLOUR")
    PushScaleformMovieFunctionParameterInt(RankBarColor)
    EndScaleformMovieMethodReturn()
    BeginScaleformMovieMethodHudComponent(19, "SET_RANK_SCORES")
    PushScaleformMovieFunctionParameterInt(XP_StartLimit_RankBar)
    PushScaleformMovieFunctionParameterInt(XP_EndLimit_RankBar)
    PushScaleformMovieFunctionParameterInt(playersPreviousXP)
    PushScaleformMovieFunctionParameterInt(playersCurrentXP)
    PushScaleformMovieFunctionParameterInt(CurrentPlayerLevel)
    PushScaleformMovieFunctionParameterInt(100)
    EndScaleformMovieMethodReturn()
end
function is_int(n)
    if type(n) == "number" then
        if math.floor(n) == n then
            return true
        end
    end
    return false
end

local disabledSafeZonesKeys = {
	{
    	group = 2,
    	key = 37,
    	message = 'Vous n\'avez pas le niveau nécéssaire afin de pouvoir utiliser cette action'
    },
 	{
    	group = 0,
    	key = 24,
    	message = 'Vous n\'avez pas le niveau nécéssaire afin de pouvoir utiliser cette action'
	}, 
	{
    	group = 0,
    	key = 69,
    	message = 'Vous n\'avez pas le niveau nécéssaire afin de pouvoir utiliser cette action'
	}, 
	{
    	group = 0,
    	key = 92,
    	message = 'Vous n\'avez pas le niveau nécéssaire afin de pouvoir utiliser cette action'
	}, 
	{
    	group = 0,
    	key = 160,
    	message = 'Vous n\'avez pas le niveau nécéssaire afin de pouvoir utiliser cette action'
	}, 
	{
    	group = 0,
    	key = 45,
    	message = 'Vous n\'avez pas le niveau nécéssaire afin de pouvoir utiliser cette action'
	}, 
	{
    	group = 0,
    	key = 80,
    	message = 'Vous n\'avez pas le niveau nécéssaire afin de pouvoir utiliser cette action'
	},
	{
    	group = 0,
    	key = 140,
    	message = 'Vous n\'avez pas le niveau nécéssaire afin de pouvoir utiliser cette action'
	},
	{
    	group = 0,
    	key = 250,
    	message = 'Vous n\'avez pas le niveau nécéssaire afin de pouvoir utiliser cette action'
	},
	{
    	group = 0,
    	key = 263,
    	message = 'Vous n\'avez pas le niveau nécéssaire afin de pouvoir utiliser cette action'
	},
	{
    	group = 0,
    	key = 363,
    	message = 'Vous n\'avez pas le niveau nécéssaire'
	}
}

local sendNotification = false

CreateThread(function()
    while true do
        if CurrentPlayerXP < 3 then
            Wait(0)
        else
            Wait(5000)
        end

        if CurrentPlayerXP < 3 then
            N_0x4757f00bc6323cfe(-1553120962, 0.0)

            for i = 1, #disabledSafeZonesKeys, 1 do
                DisableControlAction(disabledSafeZonesKeys[i].group, disabledSafeZonesKeys[i].key, true)

                if IsDisabledControlJustPressed(disabledSafeZonesKeys[i].group, disabledSafeZonesKeys[i].key) then
                    local playerPed = PlayerPedId()
                    SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)

                    if disabledSafeZonesKeys[i].message then
                        if not sendNotification then
                            sendNotification = true
                            ESX.ShowNotification("Ce genre d'action est interdite en dessous du niveau 3")
                            SetTimeout(10000, function()
                                sendNotification = false
                            end)
                        end
                    end
                end
            end

            local playerPed = PlayerPedId()
            local currentWeapon = GetSelectedPedWeapon(playerPed)

            if currentWeapon ~= `WEAPON_UNARMED` then
                SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
                ESX.ShowNotification("Les armes ne sont pas autorisées en dessous du niveau 3")
            end
        else
            EnableAllControlActions(0)
        end
    end
end)


function GetLevel()
    return GetLevelFromXP(CurrentPlayerXP)
end

exports('getPlayerLevel', function()
    return GetLevelFromXP(CurrentPlayerXP)
end)