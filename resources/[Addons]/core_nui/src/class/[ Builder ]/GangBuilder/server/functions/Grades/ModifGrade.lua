function _OneLifeGangBuilder:ModifGrade(gradeName, accesName, state)
    local gradeName = string.lower(gradeName)

    self.grades[gradeName][accesName] = state

    self:UpdateEvent("OneLife:GangBuilder:ReceiveGrades", self.grades)

    self:SaveOnBdd()
end