AddEventHandler('onServerResourceStart', function(resourceName)

    Wait(500)

    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local results = {}
    local queries = {
        { query = 'SELECT COUNT(*) FROM banlist', label = 'Nombre de Bannisements' },
        { query = 'SELECT COUNT(*) FROM jailed_players', label = 'Nombre de joueurs Jail' },
        { query = 'SELECT COUNT(*) FROM jobs WHERE societyType = 1', label = 'Nombre de sociétés légales' },
        { query = 'SELECT COUNT(*) FROM jobs WHERE societyType = 2', label = 'Nombre de sociétés illégales' }
    }
    local completedQueries = 0

    local function checkCompletion()
        completedQueries = completedQueries + 1
        if completedQueries == #queries then
            for _, result in ipairs(results) do
                print("[^5INFO^7] => " .. result.label .. ": " .. result.count)
            end
        end
    end

    for _, query in ipairs(queries) do
        MySQL.Async.fetchScalar(query.query, {}, function(count)
            table.insert(results, { label = query.label, count = count })
            checkCompletion()
        end)
    end
end)