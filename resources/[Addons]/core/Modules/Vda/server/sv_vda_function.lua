local vdaAccess = {}

CreateThread(function()
    MySQL.Async.fetchAll("SELECT * FROM wl_vda", {}, function(results)
        for _, result in ipairs(results) do
            table.insert(vdaAccess, {
                license = result.license,
                type = result.type,
            })
        end
    end)
end)

function hasAccess(identifier, type)
    for _, access in ipairs(vdaAccess) do
        if access.license == identifier and access.type == type then
            return true
        end
    end
    return false
end


function vdaGetPlayerType(license)
    for _, access in ipairs(vdaAccess) do
        if access.license == license then
            return access.type
        end
    end
    return nil
end