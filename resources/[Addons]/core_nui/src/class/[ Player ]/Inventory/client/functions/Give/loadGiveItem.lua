function _OneLifeInventory:loadGiveItem(data)
    self.CurrentGiveItem = true
    local CurrentIndex = 1

    CreateThread(function()
        while self.CurrentGiveItem do
            self.GiveItemTablePlayer = {}
            self:getPlayerCloset()

            if (self.CurrentGiveItem) then

                if CurrentIndex > #self.GiveItemTablePlayer then CurrentIndex = 1 end
                
                if CurrentIndex < 1 then CurrentIndex = 1 end


                local IdTarget = self.GiveItemTablePlayer[CurrentIndex]
                local Target = GetPlayerPed(IdTarget)
                local TargetCoords = GetEntityCoords(Target)

                DrawMarker(20, TargetCoords.x, TargetCoords.y, TargetCoords.z + 1.1, 0.0, 0.0, 0.0, 10, 180.0, 0.0, 0.4, 0.4, 0.4, 0, 137, 201, 100, true, true, 2, false, false, false, false)

                if (IsControlJustPressed(1, 73)) then
                    if (Target == GetPlayerPed(-1)) then
                        ESX.ShowNotification('~s~Vous ne pouvez pas donner un objet a vous même !')
                        return
                    end

                    TriggerServerEvent('OneLife:Inventory:GiveItemToPlayer', GetPlayerServerId(IdTarget), data)

                    self.CurrentGiveItem = false
                    self.GiveItemTablePlayer = {}
                end

                if (IsControlJustPressed(1, 44)) then
                    CurrentIndex = (CurrentIndex - 1)
                end
                
                if (IsControlJustPressed(1, 38)) then
                    CurrentIndex = (CurrentIndex + 1)
                end

                local ClosestPlayer, ClosestPlayerDistance = ESX.Game.GetClosestPlayer()

                if (ClosestPlayer == -1 or ClosestPlayerDistance > 3.0) then
                    ESX.ShowNotification('~s~Il n\'y a aucun joueur autour de vous !')
                    self.CurrentGiveItem = false
                    self.GiveItemTablePlayer = {}
                else
                    ESX.ShowNotification('Appuyez sur A ou E pour changer de cible et sur X pour valider.')
                end
            end

            Wait(0)
        end
    end)
end