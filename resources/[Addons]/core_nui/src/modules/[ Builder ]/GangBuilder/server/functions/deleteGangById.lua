function MOD_GangBuilder:deleteGangById(id)

    local gang = self:getGangById(id)

    if (not gang) then
        return print("[core_nui] Trying delete invalid gang id"..id)
    end

    MySQL.Async.execute('DELETE FROM gangbuilder WHERE id = @id', { ['@id'] = gang.id })
    MySQL.Async.execute("DELETE FROM job_grades WHERE job_name = @job_name", { ['job_name'] = gang.name, })
    MySQL.Async.execute("DELETE FROM jobs WHERE name = @name", { ['name'] = gang.name, })

    
    TriggerEvent("esx:SocietyRemoved", gang.name)

    self.list[gang.id] = nil

    return true
end