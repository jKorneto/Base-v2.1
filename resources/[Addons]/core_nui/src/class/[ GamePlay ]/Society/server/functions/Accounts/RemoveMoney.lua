function OneLifeSociety:RemoveMoney(amount)
    self.money -= tonumber(amount)

    self:Update("money", self.money)
end