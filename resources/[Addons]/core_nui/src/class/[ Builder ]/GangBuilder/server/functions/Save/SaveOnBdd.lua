function _OneLifeGangBuilder:SaveOnBdd()

    MySQL.Async.execute("UPDATE gangbuilder SET grades = @grades, membres = @membres WHERE id = @id", {
        ["@id"] = self.id,
        ["@grades"] = json.encode(self.grades),
        ["@membres"] = json.encode(self:MembreTemplate()),
    })

end