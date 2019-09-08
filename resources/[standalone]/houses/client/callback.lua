Callbacks = {}
RequestId = 0

RegisterNetEvent('callback:client:callback')
AddEventHandler('callback:client:callback', function(requestid, ...)
	Callbacks[requestid](...)
	Callbacks[requestid] = nil
end)

function TriggerCallback(name, cb, ...)
	Callbacks[RequestId] = cb
	TriggerServerEvent("callback:server:triggercallback", name, RequestId, ...)

	if RequestId < 65535 then
		RequestId = RequestId + 1
	else
		RequestId = 0
	end
end