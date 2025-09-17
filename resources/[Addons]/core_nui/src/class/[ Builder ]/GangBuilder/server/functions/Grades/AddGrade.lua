function _OneLifeGangBuilder:AddGrade(gradeName)
    local gradeLabel = gradeName
    local gradeName = string.lower(gradeName)

    if (not self.grades[gradeName]) then
        self.grades[gradeName] = {
            label = gradeLabel,
            grades = OneLife.enums.GangBuilder.DefaultGradeAcces
        }
    end

    self:UpdateEvent("OneLife:GangBuilder:ReceiveGrades", self.grades)

    self:SaveOnBdd()
end