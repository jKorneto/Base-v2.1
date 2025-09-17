function generateUniquePlate(callback)

    local function generatePlate()
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        local digits = "0123456789"
        local plate = ""

        for i = 1, 3 do
            local randomIndex = math.random(1, #digits)
            plate = plate .. digits:sub(randomIndex, randomIndex)
        end

        for i = 1, 5 do
            local source = math.random(1, 2) == 1 and chars or digits
            local randomIndex = math.random(1, #source)
            plate = plate .. source:sub(randomIndex, randomIndex)
        end

        local shuffledplate = ""
        for i = 1, #plate do
            local randomIndex = math.random(1, #plate)
            shuffledplate = shuffledplate .. plate:sub(randomIndex, randomIndex)
            plate = plate:sub(1, randomIndex - 1) .. plate:sub(randomIndex + 1)
        end

        return shuffledplate
    end

    local plate = generatePlate()
    MySQL.Async.fetchScalar("SELECT plate FROM owned_vehicles WHERE plate = @plate", {["@plate"] = plate}, function(result)
        if (result) then
            generateUniquePlate(callback)
        else
            callback(plate)
        end
    end)

end

