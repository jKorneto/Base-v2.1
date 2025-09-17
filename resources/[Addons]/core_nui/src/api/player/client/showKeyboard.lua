---showKeyboard
---@param textEntry string
---@param exampleText string
---@param maxInputLength number
---@return string
---@public
function API_Player:showKeyboard(textEntry, exampleText, maxInputLength)
   local p = promise.new() 

   AddTextEntry("FMMC_KEY_TIP1", textEntry)
   DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", exampleText, "", "", "", maxInputLength)
   while (UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2) do
      Citizen.Wait(0)
   end

   if (UpdateOnscreenKeyboard() ~= 2) then
      local result  = GetOnscreenKeyboardResult()
      p:resolve(result)
   else
      p:resolve(nil)
   end

   return Citizen.Await(p)
end
