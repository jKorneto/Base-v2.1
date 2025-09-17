--[[
  This file is part of OneLife RolePlay.
  Copyright (c) OneLife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@author Razzway
---@version 3.0
---@class CreatorConfig
CreatorConfig = {
    getESX = "esx:getSharedObject", --> Trigger de déclaration ESX | Défaut : esx:getSharedObject
    consoleLogs = true, --> Activer/Désactiver les print dans la console
    serverName = "OneLife", --> Nom de votre serveur rp
    afterMessage = true, --> Message de bienvenue après la création

    use = {calif = true}, --> Si vous utilisez la base calif : true | Sinon si ESX normal : false

    events = { --> Vos events & préfix d'events (si base calif, rajouter votre préfix | exemple : 
        showNotification = "esx:showNotification", --> Calif = esx:showNotification
        skinchanger = "skinchanger", --> Calif = skinchanger
        skin = "esx_skin", --> Calif = esx_skin
    },

    starterPack = {
        enable = false, --> Activer/Désactiver le système de starterPack
        legal = { --> Configuration du pack legal
            ["cash"] = 5000,
            ["bank"] = 30000,
        },
        illegal = { --> Configuration du pack illegal
            ["bank"] = 10000,
            ["black_money"] = 5000,
            ["weapon"] = "weapon_pistol",
        },
    },

    afterSpawn = { --> Lieu de spawn possible après la création du perso
        {name = 'Ville', pos = vector3(-407.97003173828,-1682.8178710938, 18.156454086304), head = 124.97},
        --{name = 'Aéroport', pos = vector3(-1037.82, -2737.85, 20.36), head = 330.81},
        --{name = 'Sandy Shores', pos = vector3(1841.15, 3669.22, 33.87), head = 208.88}
        --{name = 'Exemple', pos = vector3(0, 0, 0), head = 0.0}
    },

    firstSpawn = { --> Premier lieu de spawn du joueur lors de la création
        -- pos = vector3(-77.565643, -810.739014, 242.385849),
        -- heading = 70.30,
        pos = vector3(-407.97003173828, -1682.8178710938, 18.156454086304),
        heading = 188.34008789062,
    },
    cloakRoom = { --> Une fois l'identité validé, le lieu où l'on change l'apparence
        pos = vector3(-763.23, 330.84, 199.48-1),
        heading = 178.67,
    },
    kitchen = { --> Une fois le personnage validé, le lieu où l'on choisit son kit de départ
        pos = vector3(-776.85, 325.81, 196.08-1),
        heading = 308.63,
    },
    lift = { --> Lieu où l'on choisit l'endroit de spawn du personnage
        pos = vector3(-775.78, 314.45, 195.88-1),
        heading = 331.69,
    },

    outfit = { --> Configuration des tenues prédéfinies
        {label = "Tenue détente",
            clothes = {
                ["male"] = {
                    bags_1 = 0, bags_2 = 0,
                    tshirt_1 = 0, tshirt_2 = 4,
                    torso_1 = 7, torso_2 = 2,
                    arms = 1,
                    pants_1 = 5, pants_2 = 0,
                    shoes_1 = 7, shoes_2 = 0,
                    mask_1 = 0, mask_2 = 0,
                    bproof_1 = 0, bproof_2 = 0,
                    helmet_1 = -1, helmet_2 = 0,
                    chain_1 = 0, chain_2 = 0,
                    decals_1 = 0, decals_2 = 0,
                },
                ["female"] = {
                    bags_1 = 0, bags_2 = 0,
                    tshirt_1 = 14, tshirt_2 = 0,
                    torso_1 = 3, torso_2 = 0,
                    arms = 3,
                    pants_1 = 11, pants_2 = 1,
                    shoes_1 = 27, shoes_2 = 0,
                    mask_1 = 0, mask_2 = 0,
                    bproof_1 = 0, bproof_2 = 0,
                    helmet_1 = -1, helmet_2 = 0,
                    glasses_1 = -1, glasses_2 = 0,
                    chain_1 = 0, chain_2 = 0,
                    decals_1 = 0, decals_2 = 0,
                }, 
            },
        },
        {label = "Tenue d'affaires",
            clothes = {
                ["male"] = {
                    bags_1 = 0, bags_2 = 0,
                    tshirt_1 = 10, tshirt_2 = 0,
                    torso_1 = 24, torso_2 = 9,
                    arms = 4,
                    pants_1 = 22, pants_2 = 9,
                    shoes_1 = 30, shoes_2 = 0,
                    mask_1 = 0, mask_2 = 0,
                    bproof_1 = 0, bproof_2 = 0,
                    helmet_1 = -1, helmet_2 = 0,
                    chain_1 = 0, chain_2 = 0,
                    decals_1 = 0, decals_2 = 0,
                },
                ["female"] = {
                    bags_1 = 0, bags_2 = 0,
                    tshirt_1 = 41, tshirt_2 = 2,
                    torso_1 = 24, torso_2 = 0,
                    arms = 5,
                    pants_1 = 23, pants_2 = 0,
                    shoes_1 = 30, shoes_2 = 0,
                    mask_1 = 0, mask_2 = 0,
                    bproof_1 = 0, bproof_2 = 0,
                    helmet_1 = -1, helmet_2 = 0,
                    glasses_1 = -1, glasses_2 = 0,
                    chain_1 = 0, chain_2 = 0,
                    decals_1 = 0, decals_2 = 0,
                },
            },
        },
    },
}

_Client = _Client or {};
_Client.open = {};
_Prefix = "creator";
Render = {};
arrow = "~s~→~s~ ";