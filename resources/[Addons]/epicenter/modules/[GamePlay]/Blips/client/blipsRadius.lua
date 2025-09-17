Map = {
  {name="Unicorn", color=48, id=121, 12, x=129.246, y = -1300.6, z= 29.2, r= 0},
  {name="Galaxy", color=5, id=304, 12, x=331.09, y = 287.14, z= 115.00, r= 0},
  {name="Night 77", color=8, id=304, scale=0.6, 12, x=209.10, y = -3166.60, z= 41.39, r= 0},
}

Citizen.CreateThread(function()
  for i=1, #Map, 1 do
    local blip = AddBlipForCoord(Map[i].x, Map[i].y, Map[i].z) 
      SetBlipSprite (blip, Map[i].id)
      SetBlipDisplay(blip, 4)
      SetBlipScale  (blip, Map[i].scale or 0.5)
      SetBlipColour (blip, Map[i].color)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName("STRING") 
      AddTextComponentString(Map[i].name)
      EndTextCommandSetBlipName(blip)
      local zoneblip = AddBlipForRadius(Map[i].x, Map[i].y, Map[i].z, Map[i].r)
      SetBlipSprite(zoneblip,1)
      SetBlipColour(zoneblip,Map[i].color)
      SetBlipAlpha(zoneblip,100)
  end
end)