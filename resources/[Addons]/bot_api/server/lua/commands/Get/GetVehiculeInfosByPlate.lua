function _bot_api:GetVehiculeInfosByPlate(plate, cb)
	local data = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate=@plate",{['@plate'] = plate})	

    if (not data[1]) then
        cb("Cette plaque ne correspond a aucun vehicule !")
    else
        local VehOwner = data[1].owner

        local VehData = MySQL.Sync.fetchAll("SELECT * FROM trunk_inventory WHERE vehiclePlate=@vehiclePlate",{['@vehiclePlate'] = data[1].plate})

        
        local StrOwner = "* **OwnerVeh:** `"..tostring(VehOwner).."`\n\n"
        local StrModelVeh = "* **Model Veh:** `"..tostring(VehData[1].vehicleModel).."`\n\n"

        
        local CashAccount = "* **Argent(s) Cash:** `0 $`\n"
        local DirtCashAccount = "* **Argent(s) Sale:** `0 $`\n\n"

        local Items = "* **Inventaire:** `"
        local Weapons = "\n\n * **Weapons:** `"

        for key, value in pairs(json.decode(VehData[1].items)) do
            if (value.type == "item") then
                local data = {
                    item = value.name,
                    count = value.count
                }
                Items = Items..(json.encode(data)..", ")
            elseif (value.type == "accounts") then
                if (value.name == "cash") then
                    CashAccount = "* **Argent(s) Cash:** `"..tostring(value.count).." $`\n"
                elseif (value.name == "dirtycash") then
                    DirtCashAccount = "* **Argent(s) Sale:** `"..tostring(value.count).." $`\n\n"
                end
            elseif (value.type == "weapons") then
                local data = {
                    item = value.name,
                    count = value.count
                }
                Weapons = Weapons..(json.encode(data)..", ")
            end
        end
        

        cb(StrOwner..StrModelVeh..CashAccount..DirtCashAccount..Items..Weapons)
    end
end