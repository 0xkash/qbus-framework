QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('lscustoms:server:setGarageBusy')
AddEventHandler('lscustoms:server:setGarageBusy', function(garage, busy)
	TriggerClientEvent('lscustoms:server:setGarageBusy', -1, garage, busy)
end)

RegisterServerEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local bankBalance = Player.PlayerData.money["bank"]
	if not button.purchased then
		if button.price then -- check if button have price
			if Player.Functions.RemoveMoney("cash", button.price, "lscustoms-bought") then
				TriggerClientEvent("LSC:buttonSelected", source, name, button, true)
				TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "vehicleupgraded", {name=name, moneyType="cash", price=button.price, plate="unkown"})
				TriggerEvent("qb-log:server:CreateLog", "vehicleupgrades", "Upgrade gekocht", "green", "**"..GetPlayerName(src).."** heeft en upgrade gekocht ("..name..") voor €" .. button.price)
			elseif bankBalance >= button.price then
				Player.Functions.RemoveMoney("bank", button.price, "lscustoms-bought")
				TriggerClientEvent("LSC:buttonSelected", source, name, button, true)
				TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "vehicleupgraded", {name=name, moneyType="bank", price=button.price, plate="unkown"})
				TriggerEvent("qb-log:server:CreateLog", "vehicleupgrades", "Upgrade gekocht", "green", "**"..GetPlayerName(src).."** heeft en upgrade gekocht ("..name..") voor €" .. button.price)
			else
				TriggerClientEvent("LSC:buttonSelected", source, name, button, false)
			end
		end
	else
		TriggerClientEvent("LSC:buttonSelected", source, name, button, false)
	end
end)

RegisterServerEvent("lscustoms:server:SaveVehicleProps")
AddEventHandler("lscustoms:server:SaveVehicleProps", function(vehicleProps)
	local src = source
    if IsVehicleOwned(vehicleProps.plate) then
        QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `mods` = '"..json.encode(vehicleProps).."' WHERE `plate` = '"..vehicleProps.plate.."'")
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end