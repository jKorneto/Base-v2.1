function _OneLifeGangBuilder:MembreTemplate()
    local payload = {}

    for license, membre in pairs(self.membres) do
        payload[license] = {
            grade = membre.grade,
            isOwner = membre.isOwner
        }
    end

    return (payload)
end