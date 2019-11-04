QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local doorInfo = {}

RegisterServerEvent('qb-doorlock:server:updateState')
AddEventHandler('qb-doorlock:server:updateState', function(doorID, state)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	doorInfo[doorID] = state

	TriggerClientEvent('qb-doorlock:client:setState', -1, doorID, state)
end)

QBCore.Functions.CreateCallback('qb-doorlock:server:getDoorInfo', function(source, cb)
	cb(doorInfo)
end)