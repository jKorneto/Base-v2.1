Config = {}

-- We also recommend vms_multichars for use on ESX, it fits perfectly with the style of the creator!

--|  Client trigger to open the creator is:
--|      "creator:openCreator"

Config.Core = "ESX" -- "ESX" / "QB-Core"
Config.CoreExport = function()
    return exports['Framework']:getSharedObject() -- ESX
    -- return exports['qb-core']:GetCoreObject() -- QB-CORE
end

-- @Config.SkinManager for ESX: "esx_skin" / "fivem-appearance" / "illenium-appearance"
-- @Config.SkinManager for QB-Core: "qb-clothing" / "fivem-appearance" / "illenium-appearance"
Config.SkinManager = "esx_skin"

Config.TestCommand = false -- /character -- command to test the character creator **(We do not recommend using this on the main server)**
if Config.TestCommand then
    RegisterCommand('character', function()
        TriggerEvent('creator:openCreator')
    end)
end

Config.AdminCommand = {
    Enabled = false,
    Group = {"support", "trialsupport", "moderator", "admin", "fondateur"},
    Name = "skin",
    Help = "Give the character creator to the player",
    ArgHelp = "Player ID",
}

Config.Hud = {
    Enable = function()
        TriggerEvent('iZeyy:Hud:StateStatus', true)
        TriggerEvent("iZeyy::Hud::StateHud", true)

    end,
    Disable = function()
        TriggerEvent('iZeyy:Hud:StateStatus', false)
        TriggerEvent("iZeyy::Hud::StateHud", false)
    end
}

Config.defaultCamDistance = 0.95 -- camera distance from player location (during character creation)
Config.CameraHeight = {
    ['parents'] = {z_height = 0.65, fov = 30.0}, -- default is camera on the face
    ['face'] = {z_height = 0.65, fov = 30.0}, -- default is camera on the face
    ['hairs'] = {z_height = 0.65, fov = 30.0}, -- default is camera on the face
    ['clothes'] = {z_height = -0.1, fov = 100.0}, -- default is camera on the torso
    ['clothesets'] = {z_height = -0.1, fov = 100.0}, -- default is camera on the torso
    ['makeup'] = {z_height = 0.65, fov = 30.0}, -- default is camera on the face
}

Config.TeleportPlayerByCommand = false -- when the player is given the character creation menu by the admin whether to be teleported to Config.creatingCharacterCoords

Config.EnableCancelButtonUI = true -- this is only displayed when the player is in the character creator via the admin command

Config.EnableHandsUpButtonUI = true -- Is there to be a button to raise hands on the UI
Config.HandsUpKey = 'x' -- Key JS (key.code) - https://www.toptal.com/developers/keycode
Config.HandsUpAnimation = {'missminuteman_1ig_2', 'handsup_enter', 50}

Config.creatingCharacterCoords = vector4(-76.228676, -803.288269, 242.385849, 251.719482242188) -- this is where the player player will stand during character creation vec3(-76.228676, -803.288269, 243.385849)

Config.afterCreateCharSpawn = vector4(-1039.066040, -2739.873779, 13.855000, 328.69552612305) -- this is where the player will spawn after completing character creation

Config.CharacterCreationPedAnimation = {"anim@heists@heist_corona@team_idles@male_a", "idle"} -- animation of the player during character creation

Config.soundsEffects = false -- if you want to sound effects by clicks set true
Config.blurBehindPlayer = false -- to see it you need to have PostFX upper Very High or Ultra

Config.EnableFirstCreationClothes = true -- You can set a default for the character the first outfit the player will be reborn with in the character creator - the default was laid out for both genders in just underwear so the player can see all the details of the character
Config.FirstCreationClothes = {
    ['m'] = {
        tshirt_1 = 4, tshirt_2 = 0, 
        torso_1 = 10, torso_2 = 0,
        arms = 1, arms_2 = 0,
        pants_1 = 10, pants_2 = 0,
        shoes_1 = 10, shoes_2 = 0,
        helmet_1 = -1, helmet_2 = 0, 
        chain_1 = 0, chain_2 = 0, 
        glasses_1 = -1, glasses_2 = 0,
    },
    ['f'] = {
        tshirt_1 = 0, tshirt_2 = 2, 
        torso_1 = 7, torso_2 = 0,
        arms = 1, arms_2 = 0,
        pants_1 = 11, pants_2 = 1,
        shoes_1 = 28, shoes_2 = 0,
        helmet_1 = -1, helmet_2 = 0, 
        chain_1 = -1, chain_2 = 0, 
        glasses_1 = 12, glasses_2 = 0,
    }
}

-- @BlockedClothes:
--  For the clothing blockage to work correctly in the table, there must be at least two values. Only one value, for example {10}, cannot exist.
--  To block only one value, you need to set the second value as a number that does not exist, for example {10, 100000}.
Config.BlockedClothes = {
    ['male'] = {
        -- ['hair_1'] = {},
        -- ['beard_1'] = {},
        -- ['eyebrows_1'] = {},
        -- ['chest_1'] = {},
        -- ['makeup_1'] = {},
        -- ['blush_1'] = {},
        -- ['lipstick_1'] = {},
        -- ['helmet_1'] = {46, 100000},
        -- ['mask_1'] = {},
        -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
        -- ['torso_1'] = {},
        -- ['arms'] = {},
        -- ['decals_1'] = {},
        -- ['bproof_1'] = {},
        -- ['pants_1'] = {},
        -- ['shoes_1'] = {},
        -- ['chain_1'] = {},
        -- ['glasses_1'] = {},
        -- ['watches_1'] = {},
        -- ['bracelets_1'] = {},
        -- ['ears_1'] = {},
        -- ['bags_1'] = {},
    },
    ['female'] = {
        -- ['hair_1'] = {},
        -- ['beard_1'] = {},
        -- ['eyebrows_1'] = {},
        -- ['chest_1'] = {},
        -- ['makeup_1'] = {},
        -- ['blush_1'] = {},
        -- ['lipstick_1'] = {},
        -- ['helmet_1'] = {46, 100000},
        -- ['mask_1'] = {},
        -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
        -- ['torso_1'] = {},
        -- ['arms'] = {},
        -- ['decals_1'] = {},
        -- ['bproof_1'] = {},
        -- ['pants_1'] = {},
        -- ['shoes_1'] = {},
        -- ['chain_1'] = {},
        -- ['glasses_1'] = {},
        -- ['watches_1'] = {},
        -- ['bracelets_1'] = {},
        -- ['ears_1'] = {},
        -- ['bags_1'] = {},
    },
}

Config.EnablesCategories = { -- these are the available categories that the player should have when creating a character, if you don't want any, set it to false
    ['parents'] = true,
    ['face'] = true,
    ['hairs'] = true,
    ['clothes'] = true,
    ['clothesets'] = true,
    ['makeup'] = true,
}

Config.AvailableItems = {
    ['parents'] = {
        sex = true,
        parents = true,
        face_md_weight = true,
        skin_md_weight = true,
    },
    ['face'] = {
        neck_thickness = true,
        age = true,
        eyebrows = true,
        nose = true,
        cheeks = true,
        lip_thickness = true,
        jaw = true,
        chin = true,
        eye_color = true,
        blemishes = true,
        complexion = true,
        sun = true,
        moles = true,
    },
    ['clothes'] = {
        tshirt = true,
        torso = true,
        decals = true,
        arms = true,
        pants = true,
        shoes = true,
        mask = true,
        bproof = true,
        chain = true,
        helmet = true,
        glasses = true,
        watches = true,
        bracelets = true,
        bags = true,
        ears = true,
    },
    ['hairs'] = {
        hair = true,
        beard = true,
        eyebrow = true,
        chesthair = true,
    },
    ['makeup'] = {
        makeup = true,
        lipstick = true,
        blush = true,
    },
}

Config.clotheSets = { -- here are sets of clothes, you can create some suggested clothes for the player
    [0] = {
        ['name'] = "FORMAL",
        ['m'] = {
            tshirt_1 = 4, tshirt_2 = 0, 
            torso_1 = 10, torso_2 = 0,
            arms = 1, arms_2 = 0,
            pants_1 = 10, pants_2 = 0,
            shoes_1 = 10, shoes_2 = 0,
            helmet_1 = -1, helmet_2 = 0, 
            chain_1 = 0, chain_2 = 0, 
        },
        ['f'] = {
            tshirt_1 = 0, tshirt_2 = 2, 
            torso_1 = 7, torso_2 = 0,
            arms = 1, arms_2 = 0,
            pants_1 = 11, pants_2 = 1,
            shoes_1 = 28, shoes_2 = 0,
            helmet_1 = -1, helmet_2 = 0, 
            chain_1 = -1, chain_2 = 0, 
            glasses_1 = 12, glasses_2 = 0,
        },
    },
    [1] = {
        ['name'] = "NORMAL 1",
        ['m'] = {
            tshirt_1 = 4, tshirt_2 = 0, 
            torso_1 = 10, torso_2 = 0,
            arms = 1, arms_2 = 0,
            pants_1 = 10, pants_2 = 0,
            shoes_1 = 10, shoes_2 = 0,
            helmet_1 = -1, helmet_2 = 0, 
            chain_1 = 0, chain_2 = 0, 
        },
        ['f'] = {
            tshirt_1 = 0, tshirt_2 = 2, 
            torso_1 = 7, torso_2 = 0,
            arms = 1, arms_2 = 0,
            pants_1 = 11, pants_2 = 1,
            shoes_1 = 28, shoes_2 = 0,
            helmet_1 = -1, helmet_2 = 0, 
            chain_1 = -1, chain_2 = 0, 
            glasses_1 = 12, glasses_2 = 0,
        },
    },
    [2] = {
        ['name'] = "NORMAL 2",
        ['m'] = {
            tshirt_1 = 4, tshirt_2 = 0, 
            torso_1 = 10, torso_2 = 0,
            arms = 1, arms_2 = 0,
            pants_1 = 10, pants_2 = 0,
            shoes_1 = 10, shoes_2 = 0,
            helmet_1 = -1, helmet_2 = 0, 
            chain_1 = 0, chain_2 = 0, 
        },
        ['f'] = {
            tshirt_1 = 0, tshirt_2 = 2, 
            torso_1 = 7, torso_2 = 0,
            arms = 1, arms_2 = 0,
            pants_1 = 11, pants_2 = 1,
            shoes_1 = 28, shoes_2 = 0,
            helmet_1 = -1, helmet_2 = 0, 
            chain_1 = -1, chain_2 = 0, 
            glasses_1 = 12, glasses_2 = 0,
        },
    },
}