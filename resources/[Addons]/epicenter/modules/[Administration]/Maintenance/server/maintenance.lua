--[[
  This file is part of OneLife RolePlay.
  Copyright (c) OneLife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local Licensestaff = {
    Staff = {
        ["license:xxxxxx"] = true, -- @todo: Ajouter votre license
    },
}

local maintenance = false

-- CreateThread(function()
--      --GET SERVER DEV
--      maintenance = GetConvar("server_dev", false)
-- end)

local function getLicense(src)
     for k,v in pairs(GetPlayerIdentifiers(src))do
          if string.sub(v, 1, string.len("license:")) == "license:" then
               return v
          end
     end
end

local function devStart(state)
     if state then
        maintenance = true
          local xPlayers = ESX.GetPlayers()
          for i = 1, #xPlayers, 1 do
               if not Licensestaff.Staff[getLicense(xPlayers[i])] then
                    print("Le joueur ^6"..GetPlayerName(xPlayers[i]).."^0 connexion ^1reffusé^0 (^5PasDEV^0)")
                    DropPlayer(xPlayers[i], "\n\nLe Serveur OneLife est en cours de maintenance, plus d'informations sur discord.gg/OneLiferp !")
               else
                    print("Le joueur ^6"..GetPlayerName(xPlayers[i]).."^0 connexion ^2accepté^0 (^5Dev^0)")
               end
          end
     else
        maintenance = false
     end
end

CreateThread(function() --Todo
    devStart(maintenance)
end)

AddEventHandler('playerConnecting', function(name, setReason)
    if maintenance then
         if not Licensestaff.Staff[getLicense(source)] then
            print("Le joueur ^6"..name.."^0 connexion ^1reffusé^0 (^5Maintenance^0)")
            setReason("\n\nLe Serveur OneLife est en cours de maintenance, plus d'informations sur discord.gg/OneLiferp !")
            CancelEvent()

            return
         end
    end
end)

CreateThread(function()
    while true do
        Wait(60*1000*4)
        if maintenance then
            print("Maintenance ^2détecté^0 !")
            local xPlayers = ESX.GetPlayers()
            for i = 1, #xPlayers, 1 do
                 if not Licensestaff.Staff[getLicense(xPlayers[i])] then
                      print("Le joueur ^6"..GetPlayerName(xPlayers[i]).."^0 est ^1reffusé^0 dans la maintenance et je le kick .")
                      DropPlayer(xPlayers[i], "\n\nLe Serveur OneLife est en cours de maintenance, plus d'informations sur discord.gg/OneLiferp !")
                 else
                      print("Le joueur ^6"..GetPlayerName(xPlayers[i]).."^0 est ^2accepté^0 dans la maintenance .")
                 end
            end
        else
        end
    end
end)

RegisterCommand("maintenance", function(source)
    if source == 0 then
         if not maintenance then
              print("Maintenance ^2actif^0 !")
              devStart(true)
         else
              print("Maintenance non ^1actif^0 !")
              devStart(false)
         end
    end
end)