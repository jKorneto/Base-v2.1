function _bot_api:GetPlayerInfoByDiscordId(discordId, cb)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE discord = @discord", {
        ["@discord"] = discordId
    }, function(result)
        if (not result[1]) then
            cb("Cette ID discord ne correspond a aucun joueur !")
        else
            local Identifier = "* **Identifier:** `"..tostring(result[1].identifier).."`\n"
            local Discord = "* **Discord_ID:** `"..tostring(result[1].discord).."`\n\n"

            local Permission = "* **Permission:** `"..tostring(result[1].permission_group).."`\n\n"

            local Job = "* **Job:** `"..tostring(result[1].job).."` **Grade:** `"..tostring(result[1].job_grade).."`\n"
            local Job2 = "* **Job_IL:** `"..tostring(result[1].job2).."` **Grade:** `"..tostring(result[1].job2_grade).."`\n\n"

            local NomPrenomRp = "* **Prenom:** `"..tostring(result[1].firstname).."` **Nom:** `"..tostring(result[1].lastname).."`\n\n"


            for k,v in pairs(json.decode(result[1].accounts)) do
                if (v.name == 'bank') then
                    BankAccount = "* **Argent(s) Banque:** `"..tostring(v.money).." $`\n"
                end
            end

            local CashAccount = "* **Argent(s) Cash:** `0 $`\n"
            local DirtCashAccount = "* **Argent(s) Sale:** `0 $`\n\n"

            local Items = "* **Inventaire:** `"
            local Weapons = "\n\n * **Weapons:** `"

            for key, value in pairs(json.decode(result[1].inventory)) do
                for i=1, #value, 1 do
                    if (value[i].type == "item") then
                        local data = {
                            item = value[i].name,
                            count = value[i].count
                        }
                        Items = Items..(json.encode(data)..", ")
                    elseif (value[i].type == "accounts") then
                        if (value[i].name == "cash") then
                            CashAccount = "* **Argent(s) Cash:** `"..tostring(value[i].count).." $`\n"
                        elseif (value[i].name == "dirtycash") then
                            DirtCashAccount = "* **Argent(s) Sale:** `"..tostring(value[i].count).." $`\n\n"
                        end
                    elseif (value[i].type == "weapons") then
                        local data = {
                            item = value[i].name,
                            count = value[i].count
                        }
                        Weapons = Weapons..(json.encode(data)..", ")
                    end
                end
            end

            Items = Items.."`"
            Weapons = Weapons.."`"
            

            cb(Identifier..Discord..Permission..Job..Job2..NomPrenomRp..BankAccount..CashAccount..DirtCashAccount..Items..Weapons)
        end
    end);
end