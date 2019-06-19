-- QBCore Command Events
RegisterNetEvent('QBCore:Command:TeleportToPlayer')
AddEventHandler('QBCore:Command:TeleportToPlayer', function(othersource)
	local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(othersource)))
	local entity = GetPlayerPed(-1)
	if IsPedInAnyVehicle(Entity, false) then
		entity = GetVehiclePedIsUsing(entity)
	end
	SetEntityCoords(entity, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('QBCore:Command:TeleportToCoords')
AddEventHandler('QBCore:Command:TeleportToCoords', function(x, y, z)
	local entity = GetPlayerPed(-1)
	if IsPedInAnyVehicle(Entity, false) then
		entity = GetVehiclePedIsUsing(entity)
	end
	SetEntityCoords(entity, x, y, z)
end)
-- Other stuff
RegisterNetEvent('QBCore:Player:SetPlayerData')
AddEventHandler('QBCore:Player:SetPlayerData', function(val)
	QBCore.PlayerData = val
end)