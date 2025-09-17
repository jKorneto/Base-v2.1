exports("loadCoffreProperties", function(nameProperties, inventory, maxWeight)
    if (MOD_CoffreProperties.list[nameProperties] == nil) then
        _OneLifeCoffreProperties(inventory, nameProperties, maxWeight)
    end
end)