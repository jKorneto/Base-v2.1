-- local IsWide = false
-- local scaleform = nil
-- local kickTimer = nil

-- CreateThread(function()    
--     while true do
--         Wait(1000)
--         local res = GetIsWidescreen()
--         if not res and not IsWide then
--             startTimer()
--             IsWide = true
--         elseif res and IsWide then
--             IsWide = false
--             if kickTimer then
--                 kickTimer = nil
--             end
--         end
--     end
-- end)

-- function startTimer()

--     local text = "~r~Anti Résolution"
--     local initialTime = 60

--     CreateThread(function()
--         scaleform = RequestScaleformMovie("mp_big_message_freemode")
--         while not HasScaleformMovieLoaded(scaleform) do
--             Wait(0)
--         end

--         kickTimer = GetGameTimer() + initialTime * 1000

--         BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
--         PushScaleformMovieMethodParameterString(text)
--         PushScaleformMovieMethodParameterString("Changez votre résolution en 16:9 ( ~r~Kick dans " .. initialTime .. " secondes~s~ )")
--         EndScaleformMovieMethod()

--         while IsWide do
--             local remainingTime = math.ceil((kickTimer - GetGameTimer()) / 1000)
--             local subText = "Changez votre résolution en 16:9 ( ~r~Kick dans " .. remainingTime .. " secondes~s~ )"

--             BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
--             PushScaleformMovieMethodParameterString(text)
--             PushScaleformMovieMethodParameterString(subText)
--             EndScaleformMovieMethod()

--             Wait(0)
--             DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

--             if kickTimer and GetGameTimer() > kickTimer then
--                 QuitGame()
--                 break
--             end
--         end

--         SetScaleformMovieAsNoLongerNeeded(scaleform)
--         scaleform = nil
--     end)

-- end