-- QBCore Command Events
RegisterNetEvent('QBCore:Command:TeleportToPlayer')
AddEventHandler('QBCore:Command:TeleportToPlayer', function(othersource)
	local coords = QBCore.Functions.GetCoords(GetPlayerPed(GetPlayerFromServerId(othersource)))
	local entity = GetPlayerPed(-1)
	if IsPedInAnyVehicle(Entity, false) then
		entity = GetVehiclePedIsUsing(entity)
	end
	SetEntityCoords(entity, coords.x, coords.y, coords.z)
	SetEntityHeading(entity, coords.a)
end)

RegisterNetEvent('QBCore:Command:TeleportToCoords')
AddEventHandler('QBCore:Command:TeleportToCoords', function(x, y, z)
	local entity = GetPlayerPed(-1)
	if IsPedInAnyVehicle(Entity, false) then
		entity = GetVehiclePedIsUsing(entity)
	end
	SetEntityCoords(entity, x, y, z)
end)

RegisterNetEvent('QBCore:Command:SpawnVehicle')
AddEventHandler('QBCore:Command:SpawnVehicle', function(model)
	QBCore.Functions.SpawnVehicle(model, function(vehicle)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
	end)
end)

RegisterNetEvent('QBCore:Command:DeleteVehicle')
AddEventHandler('QBCore:Command:DeleteVehicle', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	else
		local vehicle = QBCore.Functions.GetClosestVehicle()
		QBCore.Functions.DeleteVehicle(vehicle)
	end
end)

RegisterNetEvent('QBCore:Command:Revive')
AddEventHandler('QBCore:Command:Revive', function()
	local coords = QBCore.Functions.GetCoords(GetPlayerPed(-1))
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z+0.2, coords.a, true, false)
	SetPlayerInvincible(GetPlayerPed(-1), false)
	ClearPedBloodDamage(GetPlayerPed(-1))
end)
-- Other stuff
RegisterNetEvent('QBCore:Player:SetPlayerData')
AddEventHandler('QBCore:Player:SetPlayerData', function(val)
	QBCore.PlayerData = val
end)

RegisterNetEvent('QBCore:Notify')
AddEventHandler('QBCore:Notify', function(text, type, length)
	print(text)
	print(type)
	QBCore.Functions.Notify(text, type, length)
end)