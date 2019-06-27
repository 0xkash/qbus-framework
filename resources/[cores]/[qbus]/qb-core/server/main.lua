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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		QBCore.Functions.ExecuteSql("SELECT * FROM `items`", function(result)
			if result ~= nil then
				for _, item in pairs(result) do
					QBCore.Shared.Items[item.name:lower()] = {name = item.name, label = item.label, info = {}, description = item.description, weight = item.weight, useable = item.useable}
				end
			end
		end)
		return nil
	end
end)