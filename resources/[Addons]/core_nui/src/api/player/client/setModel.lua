---setModel
---@param modelName string
---@return void
---@public
function API_Player:setModel(modelName)
    assert(type(modelName) == "string" or type(modelName) == "number")
    if type(modelName) == "string" then
        modelName = GetHashKey(modelName)
    end

    if (not (IsModelInCdimage(modelName))) then
        return print("MODEL NOT FOUND")
    end

    modelName = API_Streaming:requestModel(modelName)

    SetPlayerModel(PlayerId(), modelName)
    SetModelAsNoLongerNeeded(modelName)
end