function MOD_Society:LoadSociety(society)
    if (not self.list[society.name]) then
        self.list[society.name] = OneLifeSociety(society)
    else
        API_Logs:Error("This society is already loaded")
    end
end