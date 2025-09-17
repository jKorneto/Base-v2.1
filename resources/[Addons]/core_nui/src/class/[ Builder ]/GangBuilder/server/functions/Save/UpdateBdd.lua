function _OneLifeGangBuilder:UpdateBdd(dataType, data)

    if (dataType) then
        MySQL.Async.execute(("UPDATE gangbuilder SET `%s` = @%s WHERE id = @id"):format(dataType, dataType), {
            ["@id"] = self.id,
            [("@%s"):format(dataType)] = data
        });
    end

end