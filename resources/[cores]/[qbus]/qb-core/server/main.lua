QBCore = {}
QBCore.Config = QBConfig
QBCore.Shared = QBShared

function GetCoreObject()
	return QBCore
end

RegisterNetEvent('QBCore:GetObject')
AddEventHandler('QBCore:GetObject', function(cb)
	cb(GetCoreObject())
end)