--[[
  This file is part of OneLife RolePlay.
  Copyright (c) OneLife RolePlay - All Rights Reserved
  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

generatePlate = function(identifier)
    local plate = string.upper(GetRandomLetter(3)..GetRandomNumber(3))
    return plate
end