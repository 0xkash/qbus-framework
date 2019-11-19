QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('lockGarage')
AddEventHandler('lockGarage', function(b,garage)
	tbl[tonumber(garage)].locked = b
	if not b then
		tbl[tonumber(garage)].player = nil
	else
		tbl[tonumber(garage)].player = source
	end
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)
RegisterServerEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)
AddEventHandler('playerDropped', function()
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				TriggerClientEvent('lockGarage',-1,tbl)
			end
		end
	end
end)

RegisterServerEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local bankBalance = Player.PlayerData.money["bank"]
	if button.price then -- check if button have price
		if Player.Functions.RemoveMoney("cash", button.price) then
			TriggerClientEvent("LSC:buttonSelected", source,name, button, true)
		elseif bankBalance >= button.price then
			Player.Functions.RemoveMoney("bank", button.price)
			TriggerClientEvent("LSC:buttonSelected", source,name, button, true)
		else
			TriggerClientEvent("LSC:buttonSelected", source,name, button, false)
		end
	end
end)

RegisterServerEvent("lscustoms:server:SaveVehicleProps")
AddEventHandler("lscustoms:server:SaveVehicleProps", function(vehicleProps)
	local src = source
    if IsVehicleOwned(vehicleProps.plate) then
        QBCore.Functions.ExecuteSql("UPDATE `player_vehicles` SET `mods` = '"..json.encode(vehicleProps).."' WHERE `plate` = '"..vehicleProps.plate.."'")
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    QBCore.Functions.ExecuteSql("SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end