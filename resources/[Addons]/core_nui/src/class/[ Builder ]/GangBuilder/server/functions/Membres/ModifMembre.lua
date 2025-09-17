function _OneLifeGangBuilder:ModifMembre(license, name)
    self.membres[license].grade = name

    self:UpdateEvent("OneLife:GangBuilder:ReceiveMembres", self.membres)

    self:SaveOnBdd()
end