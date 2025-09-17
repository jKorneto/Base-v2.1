ConfigWipe = {
    ESX = "",
    MessageWipe = "Vous venez d'etre WIPE, vous pouvez des a presents vous reconnectez, bon jeux sur OneLife !",

    Autorized = {
        ["fondateur"] = true,
        ["gerant"] = true,
        ["gamemaster"] = true,
        ["responsable"] = true,
        ["gerantstaff"] = true,
        ['admin'] = true,
    },

    Logs = {
        WebHook = "https://discord.com/api/webhooks/1310473050004918342/e4rmeZ5BA3rO9lpZK5v-QC2wYWPrL5RmXXvi6t7ARVS9nY4zt5XnHGQgddQzMTPq-co9"
    },

    WeaponPerm = {
        ["WEAPON_FRAGILE"] = true,
        ["WEAPON_PENIS"] = true,
        ["WEAPON_WOLFKNIFE"] = true,
        ["WEAPON_SPECIALHAMMER"] = true,
        ["WEAPON_MAZE"] = true,
        -- New
        ["WEAPON_SCAR17"] = true,
        ["WEAPON_TEC9M"] = true,
    },

    -- Delete
    TableDelete = {
        {name = "account_info", id = "license"},
        {name = "clothes_data", id = "identifier"},
        {name = "kq_extra", id = "player"},
        {name = "phone_clock_alarms", id = "id"},
        {name = "properties_list", id = "owner"},
        {name = "staff", id = "license"},
        {name = "vehicleclaimsell", id = "owner"},
        {name = "vehicletosell", id = "owner"},
        {name = "user_licenses", id = "owner"},
        {name = "billing", id = "identifier"},
        {name = "playerstattoos", id = "identifier"},
        {name = "jail", id = "identifier"},
        {name = "phone_phones", id = "id"},
        {name = "phone_backups", id = "identifier"},
        {name = "phone_crypto", id = "identifier"}
    },

    -- Update 
    TableUpdate = {
        {name = "users", var = "firstname", id = "identifier", value = nil},
        {name = "users", var = "lastname", id = "identifier", value = nil},
        {name = "users", var = "position", id = "identifier", value = nil},
        {name = "users", var = "skin", id = "identifier", value = nil},
        {name = "users", var = "inventory", id = "identifier", value = nil},
        {name = "users", var = "clothes", id = "identifier", value = nil},
        {name = "users", var = "job", id = "identifier", value = "unemployed"},
        {name = "users", var = "job2", id = "identifier", value = "unemployed2"},
        {name = "users", var = "job_grade", id = "identifier", value = 0},
        {name = "users", var = "job2_grade", id = "identifier", value = 0},
        {name = "users", var = "isDead", id = "identifier", value = 0},
        {name = "users", var = "IsHurt", id = "identifier", value = 0},
        {name = "users", var = "hurtTime", id = "identifier", value = 0},
        {name = "users", var = "underPants", id = "identifier", value = nil}
    }

}