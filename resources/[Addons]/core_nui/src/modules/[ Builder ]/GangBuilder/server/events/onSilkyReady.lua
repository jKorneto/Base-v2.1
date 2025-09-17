OneLife:onOneLifeReady(function()
    local GangBuilderList = MySQL.Sync.fetchAll('SELECT * FROM gangbuilder')

    for i=1, #GangBuilderList do
        local Gang = _OneLifeGangBuilder(false, {
            id = GangBuilderList[i].id,
            name = GangBuilderList[i].name, 
            label = GangBuilderList[i].label, 
            posGarage = json.decode(GangBuilderList[i].posGarage), 
            posSpawnVeh = json.decode(GangBuilderList[i].posSpawnVeh),
            posDeleteVeh = json.decode(GangBuilderList[i].posDeleteVeh),
            posCoffre = json.decode(GangBuilderList[i].posCoffre),
            posBoss = json.decode(GangBuilderList[i].posBoss),
            vehicules = json.decode(GangBuilderList[i].vehicules),
            inventory = json.decode(GangBuilderList[i].inventory),

            grades = json.decode(GangBuilderList[i].grades),
            membres = json.decode(GangBuilderList[i].membres),
        })

        if (MOD_GangBuilder.list[Gang.id] == nil) then
            MOD_GangBuilder.list[Gang.id] = Gang
        end
    end
end)

-- RegisterCommand("transferSocietyTrunk", function(source, args)
--     if (source == 0) then
--         local SocietyList = MySQL.Sync.fetchAll('SELECT * FROM societies_storage')

--         for i=1, #SocietyList do
--             local society = SocietyList[i]
--             local societyInventory = json.decode(society.inventory)
--             local hasInventory = exports["inventory"]:GetInventory(society.name.."-stash")

--             if (not hasInventory) then
--                 exports["inventory"]:RegisterStash({
--                     isPublic = false,
--                     isPermanent = true,
--                     inventoryName = "Coffre "..society.name,
--                     maxWeight = 5000,
--                     slotsAmount = 150,
--                     uniqueID = society.name.."-stash",
--                     groups = {
--                         [society.name] = 0,
--                     }
--                 })
--             end

--             Wait(100)

--             for k, v in pairs(societyInventory) do
--                 if (v.type == "item") then
--                     exports["inventory"]:AddItem(society.name.."-stash", v.name, v.count)
--                 elseif (v.type == "weapon") then
--                     exports["inventory"]:AddItem(society.name.."-stash", v.name, v.count)
--                 end
--             end

--             print("saved", society.name.."-stash")
--             exports["inventory"]:Save(society.name.."-stash")
--             Wait(100)
--         end
--     end
-- end)

-- RegisterCommand("transferGangTrunk", function(source, args)
--     local GangsList = MySQL.Sync.fetchAll('SELECT * FROM gangbuilder')

--     if (source == 0) then
--         for i=1, #GangsList do
--             local gang = GangsList[i]
--             local gangInventory = json.decode(gang.inventory)
--             local hasInventory = exports["inventory"]:GetInventory(gang.name.."-stash")

--             if (not hasInventory) then
--                 exports["inventory"]:RegisterStash({
--                     isPublic = false,
--                     isPermanent = true,
--                     inventoryName = "Coffre "..gang.name,
--                     maxWeight = 5000,
--                     slotsAmount = 150,
--                     uniqueID = gang.name.."-stash",
--                     groups = {
--                         [gang.name] = 0,
--                     }
--                 })
--             end

--             for k, v in pairs(gangInventory) do
--                 if (v.type == "item") then
--                     exports["inventory"]:AddItem(gang.name.."-stash", v.name, v.count)
--                 elseif (v.type == "weapons") then
--                     exports["inventory"]:AddItem(gang.name.."-stash", v.name, v.count)
--                 end
--             end

--             print("saved", gang.name.."-stash")
--             exports["inventory"]:Save(gang.name.."-stash")
--             Wait(100)
--         end
--     end
-- end)

-- RegisterCommand("transferUserInventory", function(source, args)
--     local userList = MySQL.Sync.fetchAll('SELECT * FROM users')

--     if (source == 0) then
--         for i=1, #userList do
--             local user = userList[i]
--             local userInventory = json.decode(user.inventory)
--             local hasInventory = exports["inventory"]:GetInventory(user.identifier)

--             if (not hasInventory) then
--                 exports["inventory"]:createNewInventory(i, user.identifier)
--             end

--             Wait(100)

--             if (userInventory ~= nil) then
--                 for k, v in pairs(userInventory) do
--                     if (json.encode(v) ~= nil) then
--                         for j, f in pairs(v) do
--                             if (f.type == "item") then
--                                 exports["inventory"]:AddItem(user.identifier, f.name, f.count)
--                             elseif (f.type == "weapons") then
--                                 exports["inventory"]:AddItem(user.identifier, f.name, f.count)
--                             end
--                         end
--                     end
--                 end
--             end

--             print("saved", user.identifier)
--             exports["inventory"]:Save(user.identifier)
--             Wait(100)
--         end
--     end
-- end)