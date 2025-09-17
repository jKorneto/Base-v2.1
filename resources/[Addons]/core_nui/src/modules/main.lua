local uiReady = promise.new()
function sendUIMessage(message)
	Citizen.Await(uiReady)
	SendNUIMessage(message)
end

RegisterNUICallback("nui:OneLife:Mounted", function(data, cb)
	uiReady:resolve(true)

	cb('ok')
end)
