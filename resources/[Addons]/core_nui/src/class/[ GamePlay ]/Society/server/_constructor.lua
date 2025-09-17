OneLifeSociety = {}

local __instance = {
    __index = OneLifeSociety
}

setmetatable(OneLifeSociety, {
    __call = function(_, society)
        local self = setmetatable({}, __instance)

        self.name = society.name
        self.label = society.label

        self.canUseOffShore = society.canUseOffShore

        self.grades = {}
        self.employees = {}
        
        self.posBoss = MOD_Zones:AddZone(OneLife.enums.Society.Zones[string.lower(self.name)]?.pos or society.posBoss, function(xPlayer, Zone)
            if (xPlayer.job.name == self.name and xPlayer.job.grade_name == "boss") then
                -- print('SOCIETY OPEN')
                TriggerClientEvent("OneLife:Society:OpenMenuBoss", xPlayer.source, {
                    name = self.name,
                    label = self.label,
                    canUseOffShore = self.canUseOffShore
                })
            elseif (xPlayer.job.name == self.name and xPlayer.job.grade_name ~= "boss") then
                xPlayer.showNotification("Vous n'avez pas accès à ce menu")
            end            
        end, { name = self.name, type = "job" }, 0.8, OneLife.enums.Society.OpenMenuBoss, true)

        self.HasCoffre = OneLife.enums.Society.Zones[string.lower(self.name)]?.coffre

        if (self.HasCoffre) then
            self.posCoffre = MOD_Zones:AddZone(OneLife.enums.Society.Zones[string.lower(self.name)]?.coffreInfos.pos, function(xPlayer, Zone)
                TriggerEvent('OneLife:Inventory:OpenSecondInventory', "coffresociety", self.name, xPlayer)
            end, { name = self.name, type = "job" }, 0.8, OneLife.enums.Society.OpenMenuCoffre, true)

            self.maxWeight = OneLife.enums.Society.Zones[string.lower(self.name)]?.coffreInfos.maxWeight;
            self.maxSlots = OneLife.enums.Society.Zones[string.lower(self.name)]?.coffreInfos.maxSlots;
        end

        self:Initialize(function()
            if (self.HasCoffre) then
                self.inventory = MOD_CoffreSociety:loadCoffreSociety(self.name, self.posCoffre.coords, self.inventory or {}, self.maxWeight, self.maxSlots)
            end
        end)
        

        CreateThread(function()
            Wait(2000)

            for _, playerId in ipairs(GetPlayers()) do
                local xPlayer = ESX.GetPlayerFromId(playerId)

                if (xPlayer) then
                    if (xPlayer.job.name == self.name) then
                        MOD_Zones:loadZonesByJob(playerId, xPlayer.job)
                    end
                end
            end  
        end)

        --Functions
        exportMetatable(OneLifeSociety, self)

        return (self)
    end
})