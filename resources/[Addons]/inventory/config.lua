CONFIG = {}

CONFIG.IS_VEHICLE_EXIST = function(plate)
    -- You should have to add your mysql table here and query with mysql to see if its exist or not.
    -- EXAMPLE:
    -- return exports["oxmysql"]:single_async("SELECT * FROM vehicles WHERE plate = ?", { plate }) ~= nil

    return true
end

CONFIG.NEARBY_PLAYER_RANGE = 5.0
CONFIG.NEARBY_PLAYERS_SHOW_NAMES = true

CONFIG.PLAYER_INVENTORY_DEFAULTS = {
    SLOTS = 200,
    MAX_WEIGHT = 55
}

CONFIG.DROPPED_ITEMS = {
    REMAIN_ON_GROUND = 86400, -- (os.time() + REMAIN_ON_GROUND)
    GRID_RANGE = 5.0,
    GRID_MAX_WEIGHT = 1000.0,
    GRID_SLOTS = 20,
    DEFAULT_DROPPED_MODEL = GetHashKey("ba_prop_battle_ps_box_01")
}

CONFIG.SHOP_OPEN_RANGE = 3.0

CONFIG.CHEST_OPEN_RANGE = 5.0
CONFIG.CHEST_INVENTORIES = {} -- don't touch

CONFIG.SAVE_INVENTORIES_MS = 60000 * 15   -- (30 minutes by default)
CONFIG.FACTION_CREATE_SAFE_OBJECTS = true -- (If disabled then the safe objects will not be created on the clients.)
CONFIG.FACTION_SAFE_OPEN_RANGE = 3.0
CONFIG.FACTION_SAFE_OBJECT_MODEL =  GetHashKey("p_v_43_safe_s")
CONFIG.FACTION_INVENTORIES = {
    -- ["police"] = {
    --     header = "Police",
    --     x = 185.98327636719,
    --     y = -1023.8818969727,
    --     z = 29.360219955444,
    --     heading = 60.0,
    --     slotsAmount = 40,
    --     maxWeight = 2000
    -- }
}

CONFIG.AMMO_WEAPONS = {
    [GetHashKey("weapon_pistol")] = "9mm_bullet",
    [GetHashKey("weapon_pistol_mk2")] = "9mm_bullet",
    [GetHashKey("weapon_combatpistol")] = "9mm_bullet",
    [GetHashKey("weapon_appistol")] = "9mm_bullet",
    [GetHashKey("weapon_pistol50")] = "9mm_bullet",
    [GetHashKey("weapon_snspistol")] = "9mm_bullet",
    [GetHashKey("weapon_snspistol_mk2")] = "9mm_bullet",
    [GetHashKey("weapon_heavypistol")] = "9mm_bullet",
    [GetHashKey("weapon_vintagepistol")] = "9mm_bullet",
    [GetHashKey("weapon_marksmanpistol")] = "9mm_bullet",
    [GetHashKey("weapon_revolver")] = "9mm_bullet",
    [GetHashKey("weapon_revolver_mk2")] = "9mm_bullet",
    [GetHashKey("weapon_doubleaction")] = "9mm_bullet",
    [GetHashKey("weapon_raypistol")] = "9mm_bullet",
    [GetHashKey("weapon_ceramicpistol")] = "9mm_bullet",
    [GetHashKey("weapon_navyrevolver")] = "9mm_bullet",
    [GetHashKey("weapon_gadgetpistol")] = "9mm_bullet",
    [GetHashKey("weapon_pistolxm3")] = "9mm_bullet",

    [GetHashKey("weapon_microsmg")] = "45_acp_bullet",
    [GetHashKey("weapon_smg")] = "45_acp_bullet",
    [GetHashKey("weapon_smg_mk2")] = "45_acp_bullet",
    [GetHashKey("weapon_assaultsmg")] = "45_acp_bullet",
    [GetHashKey("weapon_machinepistol")] = "45_acp_bullet",
    [GetHashKey("weapon_minismg")] = "45_acp_bullet",
    [GetHashKey("weapon_tecpistol")] = "45_acp_bullet",
    [GetHashKey("weapon_tec9m")] = "45_acp_bullet",

    [GetHashKey("weapon_pumpshotgun")] = "12_gauge_bullet",
    [GetHashKey("weapon_pumpshotgun_mk2")] = "12_gauge_bullet",
    [GetHashKey("weapon_sawnoffshotgun")] = "12_gauge_bullet",
    [GetHashKey("weapon_assaultshotgun")] = "12_gauge_bullet",
    [GetHashKey("weapon_bullpupshotgun")] = "12_gauge_bullet",
    [GetHashKey("weapon_musket")] = "12_gauge_bullet",
    [GetHashKey("weapon_heavyshotgun")] = "12_gauge_bullet",
    [GetHashKey("weapon_dbshotgun")] = "12_gauge_bullet",
    [GetHashKey("weapon_autoshotgun")] = "12_gauge_bullet",
    [GetHashKey("weapon_combatshotgun")] = "12_gauge_bullet",

    [GetHashKey("weapon_assaultrifle")] = "5.56mm_bullet",
    [GetHashKey("weapon_assaultrifle_mk2")] = "5.56mm_bullet",
    [GetHashKey("weapon_carbinerifle")] = "5.56mm_bullet",
    [GetHashKey("weapon_carbinerifle_mk2")] = "5.56mm_bullet",
    [GetHashKey("weapon_advancedrifle")] = "5.56mm_bullet",
    [GetHashKey("weapon_specialcarbine")] = "5.56mm_bullet",
    [GetHashKey("weapon_specialcarbine_mk2")] = "5.56mm_bullet",
    [GetHashKey("weapon_bullpuprifle")] = "5.56mm_bullet",
    [GetHashKey("weapon_bullpuprifle_mk2")] = "5.56mm_bullet",
    [GetHashKey("weapon_compactrifle")] = "5.56mm_bullet",
    [GetHashKey("weapon_militaryrifle")] = "5.56mm_bullet",
    [GetHashKey("weapon_heavyrifle")] = "5.56mm_bullet",
    [GetHashKey("weapon_tacticalrifle")] = "5.56mm_bullet",
    [GetHashKey("weapon_scar17")] = "5.56mm_bullet",

    [GetHashKey("weapon_mg")] = "7.62mm_bullet",
    [GetHashKey("weapon_combatmg")] = "7.62mm_bullet",
    [GetHashKey("weapon_combatmg_mk2")] = "7.62mm_bullet",
    [GetHashKey("weapon_gusenberg")] = "7.62mm_bullet",

    [GetHashKey("weapon_sniperrifle")] = "7.62mm_bullet",
    [GetHashKey("weapon_heavysniper")] = "7.62mm_bullet",
    [GetHashKey("weapon_heavysniper_mk2")] = "7.62mm_bullet",
    [GetHashKey("weapon_marksmanrifle")] = "7.62mm_bullet",
    [GetHashKey("weapon_marksmanrifle_mk2")] = "7.62mm_bullet",
    [GetHashKey("weapon_precisionrifle")] = "7.62mm_bullet",

    [GetHashKey("weapon_rpg")] = "rocket_bullet",
    [GetHashKey("weapon_grenadelauncher")] = "rocket_bullet",
    [GetHashKey("weapon_grenadelauncher_smoke")] = "rocket_bullet",
    [GetHashKey("weapon_minigun")] = "rocket_bullet",
    [GetHashKey("weapon_firework")] = "rocket_bullet",
    [GetHashKey("weapon_railgun")] = "rocket_bullet",
    [GetHashKey("weapon_hominglauncher")] = "rocket_bullet",
    [GetHashKey("weapon_compactlauncher")] = "rocket_bullet",
    [GetHashKey("weapon_rayminigun")] = "rocket_bullet",
    [GetHashKey("weapon_emplauncher")] = "rocket_bullet",
    [GetHashKey("weapon_railgunxm3")] = "rocket_bullet",
}

CONFIG.MELEE_WEAPONS = {
    ["weapon_dagger"] = true,
    ["weapon_bat"] = true,
    ["weapon_bottle"] = true,
    ["weapon_crowbar"] = true,
    ["weapon_flashlight"] = true,
    ["weapon_golfclub"] = true,
    ["weapon_hammer"] = true,
    ["weapon_hatchet"] = true,
    ["weapon_knuckle"] = true,
    ["weapon_knife"] = true,
    ["weapon_switchblade"] = true,
    ["weapon_machete"] = true,
    ["weapon_nightstick"] = true,
    ["weapon_wrench"] = true,
    ["weapon_battleaxe"] = true,
    ["weapon_poolcue"] = true,
    ["weapon_stone_hatchet"] = true,
    ["weapon_candycane"] = true,
}

CONFIG.THROWABLE_WEAPONS = {
    [GetHashKey("weapon_grenade")] = true,
    [GetHashKey("weapon_bzgas")] = true,
    [GetHashKey("weapon_molotov")] = true,
    [GetHashKey("weapon_stickybomb")] = true,
    [GetHashKey("weapon_proxmine")] = true,
    [GetHashKey("weapon_snowball")] = true,
    [GetHashKey("weapon_pipebomb")] = true,
    [GetHashKey("weapon_ball")] = true,
    [GetHashKey("weapon_smokegrenade")] = true,
    [GetHashKey("weapon_flare")] = true,
    [GetHashKey("weapon_acidpackage")] = true,
}

CONFIG.MISC_WEAPONS = {
    ["weapon_petrolcan"] = true,
    ["weapon_fireextinguisher"] = true,
    ["weapon_hazardcan"] = true,
    ["weapon_fertilizercan"] = true
}

CONFIG.NO_AUTO_RELOAD = false                                    -- (Do not reload the weapon automatically)
CONFIG.NO_AUTOSWAP_ON_EMPTY = false                              -- (Do not swap to empty hand when the bullet rans out)
CONFIG.REDUCE_WEAPON_DURABILITY_CHANCE = 25
CONFIG.REDUCE_WEAPON_DURABILITY_AMOUNT = { MIN = 10, MAX = 35 } -- This will be divided with /100, so 0.25 and 0.5
CONFIG.DELETE_WEAPON_ON_DURABILITY_ZERO = true                  -- (Delete the item if the durability reached zero)

CONFIG.WEAPON_COMPONENTS = {
    ["at_flashlight"] = {
        "COMPONENT_AT_AR_FLSH",
        "COMPONENT_AT_AR_FLSH_REH",
        "COMPONENT_AT_PI_FLSH",
        "COMPONENT_AT_PI_FLSH_02",
        "COMPONENT_AT_PI_FLSH_03"
    },
    ["at_suppressor_light"] = {
        "COMPONENT_AT_PI_SUPP",
        "COMPONENT_AT_PI_SUPP_02",
        "COMPONENT_CERAMICPISTOL_SUPP",
        "COMPONENT_PISTOLXM3_SUPP"
    },
    ["at_suppressor_heavy"] = {
        "COMPONENT_AT_AR_SUPP",
        "COMPONENT_AT_AR_SUPP_02",
        "COMPONENT_AT_SR_SUPP",
        "COMPONENT_AT_SR_SUPP_03"
    },
    ["at_grip"] = {
        "COMPONENT_AT_AR_AFGRIP",
        "COMPONENT_AT_AR_AFGRIP_02"
    },
    ["at_barrel"] = {
        "COMPONENT_AT_AR_BARREL_02",
        "COMPONENT_AT_BP_BARREL_02",
        "COMPONENT_AT_CR_BARREL_02",
        "COMPONENT_AT_MG_BARREL_02",
        "COMPONENT_AT_MRFL_BARREL_02",
        "COMPONENT_AT_SB_BARREL_02",
        "COMPONENT_AT_SC_BARREL_02",
        "COMPONENT_AT_SR_BARREL_02"
    },
    ["at_clip_extended_pistol"] = {
        "COMPONENT_APPISTOL_CLIP_02",
        "COMPONENT_CERAMICPISTOL_CLIP_02",
        "COMPONENT_COMBATPISTOL_CLIP_02",
        "COMPONENT_HEAVYPISTOL_CLIP_02",
        "COMPONENT_PISTOL_CLIP_02",
        "COMPONENT_PISTOL_MK2_CLIP_02",
        "COMPONENT_PISTOL50_CLIP_02",
        "COMPONENT_SNSPISTOL_CLIP_02",
        "COMPONENT_SNSPISTOL_MK2_CLIP_02",
        "COMPONENT_VINTAGEPISTOL_CLIP_02"
    },
    ["at_clip_extended_smg"] = {
        "COMPONENT_ASSAULTSMG_CLIP_02",
        "COMPONENT_COMBATPDW_CLIP_02",
        "COMPONENT_MACHINEPISTOL_CLIP_02",
        "COMPONENT_MICROSMG_CLIP_02",
        "COMPONENT_MINISMG_CLIP_02",
        "COMPONENT_SMG_CLIP_02",
        "COMPONENT_SMG_MK2_CLIP_02"
    },
    ["at_clip_extended_shotgun"] = {
        "COMPONENT_ASSAULTSHOTGUN_CLIP_02",
        "COMPONENT_HEAVYSHOTGUN_CLIP_02"
    },
    ["at_clip_extended_rifle"] = {
        "COMPONENT_ADVANCEDRIFLE_CLIP_02",
        "COMPONENT_ASSAULTRIFLE_CLIP_02",
        "COMPONENT_ASSAULTRIFLE_MK2_CLIP_02",
        "COMPONENT_BULLPUPRIFLE_CLIP_02",
        "COMPONENT_BULLPUPRIFLE_MK2_CLIP_02",
        "COMPONENT_CARBINERIFLE_CLIP_02",
        "COMPONENT_CARBINERIFLE_MK2_CLIP_02",
        "COMPONENT_COMPACTRIFLE_CLIP_02",
        "COMPONENT_HEAVYRIFLE_CLIP_02",
        "COMPONENT_MILITARYRIFLE_CLIP_02",
        "COMPONENT_SPECIALCARBINE_CLIP_02",
        "COMPONENT_SPECIALCARBINE_MK2_CLIP_02",
        "COMPONENT_TACTICALRIFLE_CLIP_02"
    },
    ["at_clip_extended_mg"] = {
        "COMPONENT_GUSENBERG_CLIP_02",
        "COMPONENT_MG_CLIP_02",
        "COMPONENT_COMBATMG_CLIP_02",
        "COMPONENT_COMBATMG_MK2_CLIP_02"
    },
    ["at_clip_extended_sniper"] = {
        "COMPONENT_HEAVYSNIPER_MK2_CLIP_02",
        "COMPONENT_MARKSMANRIFLE_CLIP_02",
        "COMPONENT_MARKSMANRIFLE_MK2_CLIP_02"
    },
    ["at_clip_drum_smg"] = {
        "COMPONENT_COMBATPDW_CLIP_03",
        "COMPONENT_MACHINEPISTOL_CLIP_03",
        "COMPONENT_SMG_CLIP_03"
    },
    ["at_clip_drum_shotgun"] = {
        "COMPONENT_HEAVYSHOTGUN_CLIP_03"
    },
    ["at_clip_drum_rifle"] = {
        "COMPONENT_ASSAULTRIFLE_CLIP_03",
        "COMPONENT_COMPACTRIFLE_CLIP_03",
        "COMPONENT_CARBINERIFLE_CLIP_03",
        "COMPONENT_SPECIALCARBINE_CLIP_03"
    },
    ["at_compensator"] = {
        "COMPONENT_AT_PI_COMP",
        "COMPONENT_AT_PI_COMP_02",
        "COMPONENT_AT_PI_COMP_03"
    },
    ["at_scope_macro"] = {
        "COMPONENT_AT_SCOPE_MACRO",
        "COMPONENT_AT_SCOPE_MACRO_02",
        "COMPONENT_AT_SCOPE_MACRO_MK2",
        "COMPONENT_AT_SCOPE_MACRO_02_MK2",
        "COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2"
    },
    ["at_scope_small"] = {
        "COMPONENT_AT_SCOPE_SMALL",
        "COMPONENT_AT_SCOPE_SMALL_02",
        "COMPONENT_AT_SCOPE_SMALL_MK2",
        "COMPONENT_AT_SCOPE_SMALL_SMG_MK2"
    },
    ["at_scope_medium"] = {
        "COMPONENT_AT_SCOPE_MEDIUM",
        "COMPONENT_AT_SCOPE_MEDIUM_MK2"
    },
    ["at_scope_large"] = {
        "COMPONENT_AT_SCOPE_LARGE_MK2"
    },
    ["at_scope_advanced"] = {
        "COMPONENT_AT_SCOPE_MAX"
    },
    ["at_scope_nv"] = {
        "COMPONENT_AT_SCOPE_NV"
    },
    ["at_scope_thermal"] = {
        "COMPONENT_AT_SCOPE_THERMAL"
    },
    ["at_scope_holo"] = {
        "COMPONENT_AT_PI_RAIL",
        "COMPONENT_AT_PI_RAIL_02",
        "COMPONENT_AT_SIGHTS",
        "COMPONENT_AT_SIGHTS_SMG"
    },
    ["at_muzzle_flat"] = {
        "COMPONENT_AT_MUZZLE_01"
    },
    ["at_muzzle_tactical"] = {
        "COMPONENT_AT_MUZZLE_02"
    },
    ["at_muzzle_fat"] = {
        "COMPONENT_AT_MUZZLE_03"
    },
    ["at_muzzle_precision"] = {
        "COMPONENT_AT_MUZZLE_04"
    },
    ["at_muzzle_heavy"] = {
        "COMPONENT_AT_MUZZLE_05"
    },
    ["at_muzzle_slanted"] = {
        "COMPONENT_AT_MUZZLE_06"
    },
    ["at_muzzle_split"] = {
        "COMPONENT_AT_MUZZLE_07"
    },
    ["at_muzzle_squared"] = {
        "COMPONENT_AT_MUZZLE_08"
    },
    ["at_muzzle_bell"] = {
        "COMPONENT_AT_MUZZLE_09"
    },
    ["at_skin_luxe"] = {
        "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE",
        "COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER",
        "COMPONENT_CARBINERIFLE_VARMOD_LUXE",
        "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER",
        "COMPONENT_MARKSMANRIFLE_VARMOD_LUXE",
        "COMPONENT_MG_VARMOD_LOWRIDER",
        "COMPONENT_MICROSMG_VARMOD_LUXE",
        "COMPONENT_PISTOL_VARMOD_LUXE",
        "COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER",
        "COMPONENT_SMG_VARMOD_LUXE"
    },
    ["at_skin_wood"] = {
        "COMPONENT_HEAVYPISTOL_VARMOD_LUXE",
        "COMPONENT_SNIPERRIFLE_VARMOD_LUXE",
        "COMPONENT_SNSPISTOL_VARMOD_LOWRIDER"
    },
    ["at_skin_metal"] = {
        "COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE",
        "COMPONENT_APPISTOL_VARMOD_LUXE",
        "COMPONENT_BULLPUPRIFLE_VARMOD_LOW",
        "COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE",
        "COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER"
    },
    ["at_skin_pearl"] = {
        "COMPONENT_PISTOL50_VARMOD_LUXE"
    },
    ["at_skin_camo"] = {
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO",
        "COMPONENT_BULLPUPRIFLE_MK2_CAMO",
        "COMPONENT_CARBINERIFLE_MK2_CAMO",
        "COMPONENT_COMBATMG_MK2_CAMO",
        "COMPONENT_HEAVYSNIPER_MK2_CAMO",
        "COMPONENT_MARKSMANRIFLE_MK2_CAMO",
        "COMPONENT_PISTOL_MK2_CAMO",
        "COMPONENT_PUMPSHOTGUN_MK2_CAMO",
        "COMPONENT_REVOLVER_MK2_CAMO",
        "COMPONENT_SMG_MK2_CAMO",
        "COMPONENT_SNSPISTOL_MK2_CAMO",
        "COMPONENT_SPECIALCARBINE_MK2_CAMO"
    },
    ["at_skin_brushstroke"] = {
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_02",
        "COMPONENT_BULLPUPRIFLE_MK2_CAMO_02",
        "COMPONENT_CARBINERIFLE_MK2_CAMO_02",
        "COMPONENT_COMBATMG_MK2_CAMO_02",
        "COMPONENT_HEAVYSNIPER_MK2_CAMO_02",
        "COMPONENT_MARKSMANRIFLE_MK2_CAMO_02",
        "COMPONENT_PISTOL_MK2_CAMO_02",
        "COMPONENT_PUMPSHOTGUN_MK2_CAMO_02",
        "COMPONENT_REVOLVER_MK2_CAMO_02",
        "COMPONENT_SMG_MK2_CAMO_02",
        "COMPONENT_SNSPISTOL_MK2_CAMO_02",
        "COMPONENT_SPECIALCARBINE_MK2_CAMO_02"
    },
    ["at_skin_woodland"] = {
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_03",
        "COMPONENT_BULLPUPRIFLE_MK2_CAMO_03",
        "COMPONENT_CARBINERIFLE_MK2_CAMO_03",
        "COMPONENT_COMBATMG_MK2_CAMO_03",
        "COMPONENT_HEAVYSNIPER_MK2_CAMO_03",
        "COMPONENT_MARKSMANRIFLE_MK2_CAMO_03",
        "COMPONENT_PISTOL_MK2_CAMO_03",
        "COMPONENT_PUMPSHOTGUN_MK2_CAMO_03",
        "COMPONENT_REVOLVER_MK2_CAMO_03",
        "COMPONENT_SMG_MK2_CAMO_03",
        "COMPONENT_SNSPISTOL_MK2_CAMO_03",
        "COMPONENT_SPECIALCARBINE_MK2_CAMO_03"
    },
    ["at_skin_skull"] = {
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_04",
        "COMPONENT_BULLPUPRIFLE_MK2_CAMO_04",
        "COMPONENT_CARBINERIFLE_MK2_CAMO_04",
        "COMPONENT_COMBATMG_MK2_CAMO_04",
        "COMPONENT_HEAVYSNIPER_MK2_CAMO_04",
        "COMPONENT_MARKSMANRIFLE_MK2_CAMO_04",
        "COMPONENT_PISTOL_MK2_CAMO_04",
        "COMPONENT_PUMPSHOTGUN_MK2_CAMO_04",
        "COMPONENT_REVOLVER_MK2_CAMO_04",
        "COMPONENT_SMG_MK2_CAMO_04",
        "COMPONENT_SNSPISTOL_MK2_CAMO_04",
        "COMPONENT_SPECIALCARBINE_MK2_CAMO_04"
    },
    ["at_skin_sessanta"] = {
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_05",
        "COMPONENT_BULLPUPRIFLE_MK2_CAMO_05",
        "COMPONENT_CARBINERIFLE_MK2_CAMO_05",
        "COMPONENT_COMBATMG_MK2_CAMO_05",
        "COMPONENT_HEAVYSNIPER_MK2_CAMO_05",
        "COMPONENT_MARKSMANRIFLE_MK2_CAMO_05",
        "COMPONENT_PISTOL_MK2_CAMO_05",
        "COMPONENT_PUMPSHOTGUN_MK2_CAMO_05",
        "COMPONENT_REVOLVER_MK2_CAMO_05",
        "COMPONENT_SMG_MK2_CAMO_05",
        "COMPONENT_SNSPISTOL_MK2_CAMO_05",
        "COMPONENT_SPECIALCARBINE_MK2_CAMO_05"
    },
    ["at_skin_perseus"] = {
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_06",
        "COMPONENT_BULLPUPRIFLE_MK2_CAMO_06",
        "COMPONENT_CARBINERIFLE_MK2_CAMO_06",
        "COMPONENT_COMBATMG_MK2_CAMO_06",
        "COMPONENT_HEAVYSNIPER_MK2_CAMO_06",
        "COMPONENT_MARKSMANRIFLE_MK2_CAMO_06",
        "COMPONENT_PISTOL_MK2_CAMO_06",
        "COMPONENT_PUMPSHOTGUN_MK2_CAMO_06",
        "COMPONENT_REVOLVER_MK2_CAMO_06",
        "COMPONENT_SMG_MK2_CAMO_06",
        "COMPONENT_SNSPISTOL_MK2_CAMO_06",
        "COMPONENT_SPECIALCARBINE_MK2_CAMO_06"
    },
    ["at_skin_leopard"] = {
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_07",
        "COMPONENT_BULLPUPRIFLE_MK2_CAMO_07",
        "COMPONENT_CARBINERIFLE_MK2_CAMO_07",
        "COMPONENT_COMBATMG_MK2_CAMO_07",
        "COMPONENT_HEAVYSNIPER_MK2_CAMO_07",
        "COMPONENT_MARKSMANRIFLE_MK2_CAMO_07",
        "COMPONENT_PISTOL_MK2_CAMO_07",
        "COMPONENT_PUMPSHOTGUN_MK2_CAMO_07",
        "COMPONENT_REVOLVER_MK2_CAMO_07",
        "COMPONENT_SMG_MK2_CAMO_07",
        "COMPONENT_SNSPISTOL_MK2_CAMO_07",
        "COMPONENT_SPECIALCARBINE_MK2_CAMO_07"
    },
    ["at_skin_zebra"] = {
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_08",
        "COMPONENT_BULLPUPRIFLE_MK2_CAMO_08",
        "COMPONENT_CARBINERIFLE_MK2_CAMO_08",
        "COMPONENT_COMBATMG_MK2_CAMO_08",
        "COMPONENT_HEAVYSNIPER_MK2_CAMO_08",
        "COMPONENT_MARKSMANRIFLE_MK2_CAMO_08",
        "COMPONENT_PISTOL_MK2_CAMO_08",
        "COMPONENT_PUMPSHOTGUN_MK2_CAMO_08",
        "COMPONENT_REVOLVER_MK2_CAMO_08",
        "COMPONENT_SMG_MK2_CAMO_08",
        "COMPONENT_SNSPISTOL_MK2_CAMO_08",
        "COMPONENT_SPECIALCARBINE_MK2_CAMO_08"
    },
    ["at_skin_geometric"] = {
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_09",
        "COMPONENT_BULLPUPRIFLE_MK2_CAMO_09",
        "COMPONENT_CARBINERIFLE_MK2_CAMO_09",
        "COMPONENT_COMBATMG_MK2_CAMO_09",
        "COMPONENT_HEAVYSNIPER_MK2_CAMO_09",
        "COMPONENT_MARKSMANRIFLE_MK2_CAMO_09",
        "COMPONENT_PISTOL_MK2_CAMO_09",
        "COMPONENT_PUMPSHOTGUN_MK2_CAMO_09",
        "COMPONENT_REVOLVER_MK2_CAMO_09",
        "COMPONENT_SMG_MK2_CAMO_09",
        "COMPONENT_SNSPISTOL_MK2_CAMO_09",
        "COMPONENT_SPECIALCARBINE_MK2_CAMO_09"
    },
    ["at_skin_boom"] = {
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_10",
        "COMPONENT_BULLPUPRIFLE_MK2_CAMO_10",
        "COMPONENT_CARBINERIFLE_MK2_CAMO_10",
        "COMPONENT_COMBATMG_MK2_CAMO_10",
        "COMPONENT_HEAVYSNIPER_MK2_CAMO_10",
        "COMPONENT_MARKSMANRIFLE_MK2_CAMO_10",
        "COMPONENT_PISTOL_MK2_CAMO_10",
        "COMPONENT_PUMPSHOTGUN_MK2_CAMO_10",
        "COMPONENT_REVOLVER_MK2_CAMO_10",
        "COMPONENT_SMG_MK2_CAMO_10",
        "COMPONENT_SNSPISTOL_MK2_CAMO_10",
        "COMPONENT_SPECIALCARBINE_MK2_CAMO_10"
    },
    ["at_skin_patriotic"] = {
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01",
        "COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01",
        "COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01",
        "COMPONENT_COMBATMG_MK2_CAMO_IND_01",
        "COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01",
        "COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01",
        "COMPONENT_PISTOL_MK2_CAMO_IND_01",
        "COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01",
        "COMPONENT_REVOLVER_MK2_CAMO_IND_01",
        "COMPONENT_SMG_MK2_CAMO_IND_01",
        "COMPONENT_SNSPISTOL_MK2_CAMO_IND_01",
        "COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01"
    }
}

CONFIG.VEHICLE_SIZES = {
    DEFAULT_TRUNK_SLOT = 20,
    DEFAULT_TRUNK_WEIGHT = 50.0,
    DEFAULT_GLOVEBOX_SLOT = 10,
    DEFAULT_GLOVEBOX_WEIGHT = 10.0,
    DATA = {
        --Boats
        [GetHashKey("avisa")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("dinghy")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("dinghy2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("dinghy3")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("dinghy4")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("dinghy5")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("jetmax")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("kosatka")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("longfin")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("marquis")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("patrolboat")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("seashark")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("seashark2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("seashark3")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("speeder")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("speeder2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("squalo")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("submersible")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("submersible2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("suntrap")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("toro")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("toro2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("tropic")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("tropic2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },
        [GetHashKey("tug")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 5, WEIGHT = 5.0 } },

        --Commercial
        [GetHashKey("benson")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("benson2")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("biff")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("cerberus")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("cerberus2")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("cerberus3")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("hauler")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("hauler2")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("mule")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("mule2")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("mule3")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("mule4")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("mule5")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("packer")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("phantom")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("phantom2")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("phantom3")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("phantom4")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("pounder")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("pounder2")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("stockade")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("stockade3")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("terbyte")] = { TRUNK = { SLOT = 20, WEIGHT = 220.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },

        --Compacts
        [GetHashKey("asbo")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("blista")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("brioso")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("brioso2")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("brioso3")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("club")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("dilettante")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("dilettante2")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("kanjo")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("issi2")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("issi3")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("issi4")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("issi5")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("issi6")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("panto")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("prairie")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("rhapsody")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("weevil")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },

        -- Coupes
        [GetHashKey("cogcabrio")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("exemplar")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("f620")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("felon")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("felon2")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("jackal")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("kanjosj")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("oracle")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("oracle2")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("postlude")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("previon")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("sentinel")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("sentinel2")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("windsor")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("windsor2")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("zion")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("zion2")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        
        --Cycles
        [GetHashKey("bmx")] = { TRUNK = { SLOT = 1, WEIGHT = 20 }, GLOVEBOX = { SLOT = 1, WEIGHT = 5.0 } },
        [GetHashKey("cruiser")] = { TRUNK = { SLOT = 1, WEIGHT = 20 }, GLOVEBOX = { SLOT = 1, WEIGHT = 5.0 } },
        [GetHashKey("fixter")] = { TRUNK = { SLOT = 1, WEIGHT = 20 }, GLOVEBOX = { SLOT = 1, WEIGHT = 5.0 } },
        [GetHashKey("scorcher")] = { TRUNK = { SLOT = 1, WEIGHT = 20 }, GLOVEBOX = { SLOT = 1, WEIGHT = 5.0 } },
        [GetHashKey("tribike")] = { TRUNK = { SLOT = 1, WEIGHT = 20 }, GLOVEBOX = { SLOT = 1, WEIGHT = 5.0 } },
        [GetHashKey("tribike2")] = { TRUNK = { SLOT = 1, WEIGHT = 20 }, GLOVEBOX = { SLOT = 1, WEIGHT = 5.0 } },
        [GetHashKey("tribike3")] = { TRUNK = { SLOT = 1, WEIGHT = 20 }, GLOVEBOX = { SLOT = 1, WEIGHT = 5.0 } },

        --Emergency
        [GetHashKey("ambulance")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("fbi")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("fbi2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("firetruk")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("lguard")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("pbus")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("police")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("police2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("police3")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("police4")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("policeb")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("polmav")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("policeold1")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("policeold2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("policet")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("pranger")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("predator")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("riot")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("riot2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("sheriff")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("sheriff2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },

        --Helicopters
        [GetHashKey("akula")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("annihilator")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("annihilator2")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("buzzard")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("buzzard2")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("cargobob")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("cargobob2")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("cargobob3")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("cargobob4")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("conada")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("frogger")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("frogger2")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("havok")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("hunter")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("maverick")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("savage")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("seasparrow")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("seasparrow2")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("seasparrow3")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("skylift")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("supervolito")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("supervolito2")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("swift")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("swift2")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("valkyrie")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("valkyrie2")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("volatus")] = { TRUNK = { SLOT = 20, WEIGHT = 170.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },

        --Industrial
        [GetHashKey("bulldozer")] = { TRUNK = { SLOT = 20, WEIGHT = 500.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("cutter")] = { TRUNK = { SLOT = 20, WEIGHT = 500.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("dump")] = { TRUNK = { SLOT = 20, WEIGHT = 500.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("flatbed")] = { TRUNK = { SLOT = 20, WEIGHT = 500.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("guardian")] = { TRUNK = { SLOT = 20, WEIGHT = 500.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("handler")] = { TRUNK = { SLOT = 20, WEIGHT = 500.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("mixer")] = { TRUNK = { SLOT = 20, WEIGHT = 500.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("mixer2")] = { TRUNK = { SLOT = 20, WEIGHT = 500.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("rubble")] = { TRUNK = { SLOT = 20, WEIGHT = 500.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("tiptruck")] = { TRUNK = { SLOT = 20, WEIGHT = 500.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("tiptruck2")] = { TRUNK = { SLOT = 20, WEIGHT = 500.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },

        --Military
        [GetHashKey("apc")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("barracks")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("barracks2")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("barracks3")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("barrage")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("chernobog")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("crusader")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("halftrack")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("khanjali")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("minitank")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("rhino")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("scarab")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("scarab2")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("scarab3")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("thruster")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("trailersmall2")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("vetir")] = { TRUNK = { SLOT = 20, WEIGHT = 210.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },

        --Motorcycles
        [GetHashKey("akuma")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("avarus")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("bagger")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("bati")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("bati2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("bf400")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("carbonrs")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("chimera")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("cliffhanger")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("daemon")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("daemon2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("defiler")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("deathbike")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("deathbike2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("deathbike3")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("diablous")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("diablous2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("double")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("enduro")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("esskey")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("faggio")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("faggio2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("faggio3")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("fcr")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("fcr2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gargoyle")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("hakuchou")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("hakuchou2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("hexer")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("innovation")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("lectro")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("manchez")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("manchez2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("manchez3")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("nemesis")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("nightblade")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("oppressor")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("oppressor2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("pcj")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("powersurge")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("ratbike")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("reever")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("ruffian")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("rrocket")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("sanchez")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("sanchez2")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("sanctus")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("shinobi")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("shotaro")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("sovereign")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("stryder")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("thrust")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("vader")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("vindicator")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("vortex")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("wolfsbane")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("zombiea")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("zombieb")] = { TRUNK = { SLOT = 20, WEIGHT = 10.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },

        --Muscle
        [GetHashKey("blade")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("broadway")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("buccaneer")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("buccaneer2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("chino")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("chino2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("clique")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("coquette3")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("deviant")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("dominator")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("dominator2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("dominator3")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("dominator4")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("dominator5")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("dominator6")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("dominator7")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("dukes")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("dukes2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("dukes3")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("faction")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("faction2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("faction3")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("ellie")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("eudora")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gauntlet")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gauntlet2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gauntlet3")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gauntlet4")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gauntlet5")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("greenwood")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("hermes")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("hotknife")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("hustler")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("impaler")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("impaler2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("impaler3")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("impaler4")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("imperator")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("imperator2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("imperator3")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("lurcher")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("moonbeam")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("moonbeam2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("nightshade")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("peyote2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("phoenix")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("picador")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("ratloader")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("ratloader2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("ruiner")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("ruiner2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("ruiner3")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("ruiner4")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("sabregt")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("sabregt2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("slamvan")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("slamvan2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("slamvan3")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("slamvan4")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("slamvan5")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("slamvan6")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("tornado")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("tornado2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("tornado3")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("tornado4")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("tornado5")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("tornado6")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("turismo2")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("viseris")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("z190")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("ztype")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("zion3")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },

        --Sports
        [GetHashKey("adder")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("autarch")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("bullet")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("champion")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("cheetah")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("cyclone")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("entity2")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("entity3")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("entityxf")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("emerus")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("fmj")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("furia")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gp1")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("ignus")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("infernus")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("italigtb")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("italigtb2")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("krieger")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("le7b")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("lm87")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("nero")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("nero2")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("osiris")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("penetrator")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("pfister811")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("prototipo")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("reaper")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("s80")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("sc1")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("scramjet")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("sheava")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("sultanrs")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("t20")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("taipan")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("tempesta")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("tezeract")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("thrax")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("tigon")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("torero2")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("turismor")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("tyrant")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("tyrus")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("vacca")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("vagner")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("vigilante")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("virtue")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("visione")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("voltic")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("voltic2")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("xa21")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("zentorno")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("zeno")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("zorrusso")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },

        --Vans
        [GetHashKey("bison")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("bison2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("bison3")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("bobcatxl")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("boxville")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("boxville2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("boxville3")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("boxville4")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("boxville5")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("burrito")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("burrito2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("burrito3")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("burrito4")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("burrito5")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("camper")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gburrito")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gburrito2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("journey")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("journey2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("minivan")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("minivan2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("paradise")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("pony")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("pony2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("rumpo")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("rumpo2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("rumpo3")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("speedo")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("speedo2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("speedo4")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("surfer")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("surfer2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("surfer3")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("taco")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("youga")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("youga2")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("youga3")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("youga4")] = { TRUNK = { SLOT = 20, WEIGHT = 200.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },

        --Add-On
        [GetHashKey("gb811s2")] = { TRUNK = { SLOT = 20, WEIGHT = 40.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbargento7f")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbbanshees")] = { TRUNK = { SLOT = 20, WEIGHT = 40.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbbisonhf")] = { TRUNK = { SLOT = 20, WEIGHT = 250.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbclubxr")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbcomets1t")] = { TRUNK = { SLOT = 20, WEIGHT = 40.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbcomets2r")] = { TRUNK = { SLOT = 20, WEIGHT = 40.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbdominatorgsx")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbprospero")] = { TRUNK = { SLOT = 20, WEIGHT = 40.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbsapphire")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbschlagenr")] = { TRUNK = { SLOT = 20, WEIGHT = 40.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbschlagensp")] = { TRUNK = { SLOT = 20, WEIGHT = 40.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbschrauber")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbschwartzers")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbsentinelgts")] = { TRUNK = { SLOT = 20, WEIGHT = 60.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbsolace")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbsolacev")] = { TRUNK = { SLOT = 20, WEIGHT = 50.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbvivant")] = { TRUNK = { SLOT = 20, WEIGHT = 30.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbvoyagerb2")] = { TRUNK = { SLOT = 50, WEIGHT = 800.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbcomets2rc")] = { TRUNK = { SLOT = 20, WEIGHT = 40.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbeon")] = { TRUNK = { SLOT = 20, WEIGHT = 40.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },
        [GetHashKey("gbblod4")] = { TRUNK = { SLOT = 20, WEIGHT = 250.0 }, GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 } },

        [GetHashKey("aleutian")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("astron")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("baller")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("baller2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("baller3")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("baller4")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("baller5")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("baller6")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("baller7")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("bjxl")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("cavalcade")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("cavalcade2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("contender")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("dubsta")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("dubsta2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("fq2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("granger")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("granger2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("gresley")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("habanero")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("huntley")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("issi8")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("iwagen")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("jubilee")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("landstalker")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("landstalker2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("mesa")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("mesa2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("novak")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("patriot")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("patriot2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("radi")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("rebla")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("rocoto")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("seminole")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("seminole2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("serrano")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("squaddie")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("toros")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("xls")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("xls2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 250.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },

        [GetHashKey("asea")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("asea2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("asterope")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("asterope2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("cinquemila")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("cog55")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("cog552")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("cognoscenti")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("cognoscenti2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("deity")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("emperor")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("emperor2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("emperor3")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("fugitive")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("glendale")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("glendale2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("ingot")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("intruder")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("limo2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("premier")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("primo")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("primo2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("regina")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("rhinehart")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("romero")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("stafford")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("stanier")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("stratum")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("stretch")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("superd")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("surge")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("tailgater")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("warrener")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("washington")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },
        [GetHashKey("tailgater2")] = {
            TRUNK = { SLOT = 20, WEIGHT = 30.0 },
            GLOVEBOX = { SLOT = 7, WEIGHT = 15.0 }
        },    
    },

    getTrunkSlots = function(modelHash)
        local ref = CONFIG.VEHICLE_SIZES.DATA[modelHash]
        return (ref and ref.TRUNK and type(ref.TRUNK.SLOT) == "number")
            and
            ref.TRUNK.SLOT
            or
            CONFIG.VEHICLE_SIZES.DEFAULT_TRUNK_SLOT
    end,
    getTrunkMaxWeight = function(modelHash)
        local ref = CONFIG.VEHICLE_SIZES.DATA[modelHash]
        return (ref and ref.TRUNK and type(ref.TRUNK.WEIGHT) == "number")
            and
            ref.TRUNK.WEIGHT
            or
            CONFIG.VEHICLE_SIZES.DEFAULT_TRUNK_WEIGHT
    end,
    getGloveboxSlots = function(modelHash)
        local ref = CONFIG.VEHICLE_SIZES.DATA[modelHash]
        return (ref and ref.GLOVEBOX and type(ref.GLOVEBOX.SLOT) == "number")
            and
            ref.GLOVEBOX.SLOT
            or
            CONFIG.VEHICLE_SIZES.DEFAULT_GLOVEBOX_SLOT
    end,
    getGloveboxMaxWeight = function(modelHash)
        local ref = CONFIG.VEHICLE_SIZES.DATA[modelHash]
        return (ref and ref.GLOVEBOX and type(ref.GLOVEBOX.WEIGHT) == "number")
            and
            ref.GLOVEBOX.WEIGHT
            or
            CONFIG.VEHICLE_SIZES.DEFAULT_GLOVEBOX_WEIGHT
    end
}
