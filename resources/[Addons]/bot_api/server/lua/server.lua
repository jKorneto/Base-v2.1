ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- MYSQL
local Lite = {};
function Lite:Logs(Executed, Message)
    local Started = Executed;
end
LiteMySQL = {};
local Select = {};
local Where = {}
local Wheres = {}
function LiteMySQL:Insert(Table, Content)
    local executed = GetGameTimer();
    local fields = "";
    local keys = "";
    local id = nil;
    for key, _ in pairs(Content) do
        fields = string.format('%s`%s`,', fields, key)
        key = string.format('@%s', key)
        keys = string.format('%s%s,', keys, key)
    end
    MySQL.Async.insert(string.format("INSERT INTO %s (%s) VALUES (%s)", Table, string.sub(fields, 1, -2), string.sub(keys, 1, -2)), Content, function(insertId)
        id = insertId;
    end)
    while (id == nil) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^2INSERT %s', Table))
    if (id ~= nil) then
        return id;
    else
        error("InsertId is nil")
    end
end
function LiteMySQL:Update(Table, Column, Operator, Value, Content)
    local executed = GetGameTimer();
    self.affectedRows = nil;
    self.keys = "";
    self.args = {};
    for key, value in pairs(Content) do
        self.keys = string.format("%s`%s` = @%s, ", self.keys, key, key)
        self.args[string.format('@%s', key)] = value;
    end
    self.args['@value'] = Value;
    local query = string.format("UPDATE %s SET %s WHERE %s %s @value", Table, string.sub(self.keys, 1, -3), Column, Operator, Value)
    MySQL.Async.execute(query, self.args, function(affectedRows)
        self.affectedRows = affectedRows;
    end)
    while (self.affectedRows == nil) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^4UPDATED %s', Table))
    if (self.affectedRows ~= nil) then
        return self.affectedRows;
    end
end
function LiteMySQL:UpdateWheres(Table, Where, Content)
    local executed = GetGameTimer();
    self.affectedRows = nil;
    self.keys = "";
    self.content = "";
    self.args = {};
    for key, value in pairs(Content) do
        self.content = string.format("%s`%s` = @%s, ", self.content, key, key)
        self.args[string.format('@%s', key)] = value;
    end
    for _, value in pairs(Where) do
        self.keys = string.format("%s `%s` %s @%s AND ", self.keys, value.column, value.operator, value.column)
        self.args[string.format('@%s', value.column)] = value.value;
    end
    local query = string.format('UPDATE %s SET %s WHERE %s', Table, string.sub(self.content, 1, -3), string.sub(self.keys, 1, -5));
    MySQL.Async.execute(query, self.args, function(affectedRows)
        self.affectedRows = affectedRows;
    end)
    while (self.affectedRows == nil) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^4UPDATED %s', Table))
    if (self.affectedRows ~= nil) then
        return self.affectedRows;
    end
end
function LiteMySQL:Select(Table)
    self.SelectTable = Table
    return Select;
end
function LiteMySQL:GetSelectTable()
    return self.SelectTable;
end
function Select:All()
    local executed = GetGameTimer();
    local storage = nil;
    MySQL.Async.fetchAll(string.format('SELECT * FROM %s', LiteMySQL:GetSelectTable()), { }, function(result)
        if (result ~= nil) then
            storage = result
        end
    end)
    while (storage == nil) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^5SELECTED ALL %s', LiteMySQL:GetSelectTable()))
    return #storage, storage;
end
function Select:Delete(Column, Operator, Value)
    local executed = GetGameTimer();
    local count = 0;
    MySQL.Async.execute(string.format('DELETE FROM %s WHERE %s %s @value', LiteMySQL:GetSelectTable(), Column, Operator), { ['@value'] = Value }, function(affectedRows)
        count = affectedRows
    end)
    while (count == 0) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^8DELETED %s WHERE %s %s %s', LiteMySQL:GetSelectTable(), Column, Operator, Value))
    return count;
end
function Select:GetWhereResult()
    return self.whereStorage;
end
function Select:GetWhereConditions(Id)
    return self.whereConditions[Id or 1];
end
function Select:GetWheresResult()
    return self.wheresStorage;
end
function Select:GetWheresConditions()
    return self.wheresConditions;
end
function Select:Where(Column, Operator, Value)
    local executed = GetGameTimer();
    self.whereStorage = nil;
    self.whereConditions = { Column, Operator, Value };
    MySQL.Async.fetchAll(string.format('SELECT * FROM %s WHERE %s %s @value', LiteMySQL:GetSelectTable(), Column, Operator), { ['@value'] = Value }, function(result)
        if (result ~= nil) then
            self.whereStorage = result
        end
    end)
    while (self.whereStorage == nil) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^5SELECTED %s WHERE %s %s %s', LiteMySQL:GetSelectTable(), Column, Operator, Value))
    return Where;
end
function Where:Update(Content)
    if (self:Exists()) then
        local Table = LiteMySQL:GetSelectTable();
        local Column = Select:GetWhereConditions(1);
        local Operator = Select:GetWhereConditions(2);
        local Value = Select:GetWhereConditions(3);
        LiteMySQL:Update(Table, Column, Operator, Value, Content)
    else
        error('Not exists')
    end
end
function Where:Exists()
    return Select:GetWhereResult() ~= nil and #Select:GetWhereResult() >= 1
end
function Where:Get()
    local result = Select:GetWhereResult();
    return #result, result;
end
function Select:Wheres(Table)
    local executed = GetGameTimer();
    self.wheresStorage = nil;
    self.keys = "";
    self.args = {};
    for key, value in pairs(Table) do
        self.keys = string.format("%s `%s` %s @%s AND ", self.keys, value.column, value.operator, value.column)
        self.args[string.format('@%s', value.column)] = value.value;
    end
    local query = string.format('SELECT * FROM %s WHERE %s', LiteMySQL:GetSelectTable(), string.sub(self.keys, 1, -5));
    MySQL.Async.fetchAll(query, self.args, function(result)
        if (result ~= nil) then
            self.wheresStorage = result
        end
    end)
    while (self.wheresStorage == nil) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^5SELECT %s WHERE %s', LiteMySQL:GetSelectTable(), json.encode(self.args)))
    return Wheres;
end
function Wheres:Exists()
    return Select:GetWheresResult() ~= nil and #Select:GetWheresResult() >= 1
end
function Wheres:Get()
    local result = Select:GetWheresResult();
    return #result, result;
end


function GetIdentifiers(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers[_]
        end
        return identifiers
    else
        error("source is nil")
    end
end

TonnoBot = {}

TonnoBot.SendCoins = function(id, montant, cb)
    local identifier = GetIdentifiers(id);
    local xPlayer = ESX.GetPlayerFromId(id)
    if xPlayer ~= nil then
        if (identifier['fivem']) then
            local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
            LiteMySQL:Insert('tebex_players_wallet', {
                identifiers = after,
                transaction = 'Ajout de OneLifeCoins via la console',
                price = 0,
                currency = 'Points',
                points = montant,
            });
            xPlayer.showNotification('Vous avez reçu ~r~'..montant.. ' OneLifeCoins')
            cb('Montant donner : '..montant..' Coins\nJoueurs : '..xPlayer.name)
        else
            cb('Aucun compte FiveM de lié')
        end
    else
        cb('Joueurs non connecter')
    end
end



TonnoBot.SetGroup = function(id, group, cb)
	local xPlayer = ESX.GetPlayerFromId(id)
	if xPlayer then
        if group == "fondateur" or group == "gerant" or group == "admin" or group == "moderateur" or group == "helpeur" then
            xPlayer.setGroup(group);
            if (xPlayer) then
                cb('Grouppe donner : '..group..'\nJoueurs : '..xPlayer.name)
            end
        else
            cb('Grouppe invalide !')
        end
    else
        cb('ID invalide !')
    end
end

TonnoBot.GetTopMoney = function(number, cb)
    Money = {}
    EmbedReturn = ""

    UserSql = MySQL.Sync.fetchAll("SELECT * FROM `users`", {})
    for i=1, #UserSql do

        for k,v in pairs(json.decode(UserSql[i].accounts)) do
            if (v.name == "cash") then
                table.insert(Money, {
                    license = UserSql[i].identifier,
                    name = tostring(UserSql[i].firstname)..' '..tostring(UserSql[i].lastname),
                    money = v.money
                })
            end
        end
    end

    
    table.sort(Money, function(a, b) return a.money > b.money end)

    for k,v in pairs(Money) do
        if (k < (number + 1)) then
            EmbedReturn = EmbedReturn.."\n"..k.." | "..v.license.." money: "..format_int(v.money)
        else
            break
        end
    end

    cb(EmbedReturn)
end

TonnoBot.GetTopBank = function(number, cb)
    Bank = {}
    EmbedReturn = ""

    UserSql = MySQL.Sync.fetchAll("SELECT * FROM `users`", {})
    for i=1, #UserSql do
        if (UserSql[i].accounts ~= nil) then
            for k,v in pairs(json.decode(UserSql[i].accounts)) do
                if (v.name == "bank") then
                    table.insert(Bank, {
                        license = UserSql[i].identifier,
                        name = tostring(UserSql[i].firstname)..' '..tostring(UserSql[i].lastname),
                        money = v.money
                    })
                end
            end
        end
    end

    
    table.sort(Bank, function(a, b) return a.money > b.money end)

    for k,v in pairs(Bank) do
        if (k < (number + 1)) then
            EmbedReturn = EmbedReturn.."\n"..k.." | "..v.license.." Bank: "..format_int(v.money)
        else
            break
        end
    end

    cb(EmbedReturn)
end

TonnoBot.GetTopDirtyCash = function(number, cb)
    DirtyCash = {}
    EmbedReturn = ""

    UserSql = MySQL.Sync.fetchAll("SELECT * FROM `users`", {})
    for i=1, #UserSql do

        for k,v in pairs(json.decode(UserSql[i].accounts)) do
            if (v.name == "dirtycash") then
                table.insert(DirtyCash, {
                    license = UserSql[i].identifier,
                    name = tostring(UserSql[i].firstname)..' '..tostring(UserSql[i].lastname),
                    money = v.money
                })
            end
        end
    end
    
    table.sort(DirtyCash, function(a, b) return a.money > b.money end)

    for k,v in pairs(DirtyCash) do
        if (k < (number + 1)) then
            EmbedReturn = EmbedReturn.."\n"..k.." | "..v.license.." DirtyCash: "..format_int(v.money)
        else
            break
        end
    end

    cb(EmbedReturn)
end


TonnoBot.GetServerMoney = function(cb)
    Bank = 0
    Money = 0
    DirtyCash = 0

    UserSql = MySQL.Sync.fetchAll("SELECT * FROM `users`", {})
    for i=1, #UserSql do

        for k,v in pairs(json.decode(UserSql[i].accounts)) do
            if (v.name == "cash") then
                Money += v.money
            elseif (v.name == "bank") then
                Bank += v.money
            elseif (v.name == "dirtycash") then
                DirtyCash += v.money
            end
        end
    end

    cb('Money: ' ..format_int(Money)..'\n Black_Money: '..format_int(DirtyCash)..'\nBank: '..format_int(Bank))
end

function format_int(number)

local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')

-- reverse the int-string and append a comma to all blocks of 3 digits
int = int:reverse():gsub("(%d%d%d)", "%1,")

-- reverse the int-string back remove an optional comma and put the 
-- optional minus and fractional part back
return minus .. int:reverse():gsub("^,", "") .. fraction
end



exports('GetFunctionTonnoBot', function()
    return TonnoBot
end)