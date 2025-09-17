ESX.AddGroupCommand('sGangBuilder', 'responsable', function(source, args, user)

	local payload = {}

	for _, gang in pairs(MOD_GangBuilder:getAllGangs()) do
		payload[#payload + 1] = gang:minify()
	end

	TriggerClientEvent('OneLife:GangBuilder:OpenGangBuilder', source, payload)
end, { help = "GangBuilder" })