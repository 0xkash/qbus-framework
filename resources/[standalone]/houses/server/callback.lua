Callbacks = {}

RegisterServerEvent('callback:server:triggercallback')
AddEventHandler('callback:server:triggercallback', function(name, requestid, ...)
	local src = source
	TriggerCallback(name, requestid, src, function(...)
		TriggerClientEvent('callback:client:callback', src, requestid, ...)
	end, ...)
end)

function CreateCallback(name, cb)
	Callbacks[name] = cb
end

function TriggerCallback(name, requestid, source, cb, ...)
	if Callbacks[name] ~= nil then
		Callbacks[name](source, cb, ...)
	end
end