QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('vehicletuning:server:SaveVehicleProps')
AddEventHandler('vehicletuning:server:SaveVehicleProps', function(vehicleProps)
    local src = source
    if IsVehicleOwned(vehicleProps.plate) then
        QBCore.Functions.ExecuteSql("UPDATE `player_vehicles` SET `mods` = '"..json.encode(vehicleProps).."' WHERE `plate` = '"..vehicleProps.plate.."'")
    end
end)

RegisterServerEvent('vehicletuning:server:BuyUpgrade')
AddEventHandler('vehicletuning:server:BuyUpgrade', function(costs)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local bankBalance = Player.PlayerData.money["bank"]
    if Player.Functions.RemoveMoney("cash", costs) then
        -- :)
    elseif bankBalance >= costs then
        Player.Functions.RemoveMoney("bank", costs)
    else
        TriggerClientEvent('QBCore:Notify', src, "Je hebt niet genoeg geld!", "error")
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

QBCore.Functions.CreateUseableItem("repairkit", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehicletuning:client:RepairVehicle", source)
    end
end)