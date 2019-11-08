QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Functions.CreateCallback('qb-occasions:server:getVehicles', function(source, cb)
    QBCore.Functions.ExecuteSql('SELECT * FROM `occasion_vehicles`', function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

QBCore.Functions.CreateCallback("qb-garage:server:checkVehicleOwner", function(source, cb, plate)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE plate = @plate AND citizenid = @citizenid', {['@plate'] = plate, ['@citizenid'] = pData.PlayerData.citizenid}, function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('qb-occasions:server:sellVehicle')
AddEventHandler('qb-occasions:server:sellVehicle', function(vehiclePrice, vehicleData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("DELETE FROM `player_vehicles` WHERE `plate` = '"..vehicleData.plate.."' AND `vehicle` = '"..vehicleData.model.."'")
    QBCore.Functions.ExecuteSql("INSERT INTO `occasion_vehicles` (`seller`, `price`, `description`, `model`, `mods`, `occasionId`) VALUES ('"..Player.PlayerData.citizenid.."', '"..vehiclePrice.."', '"..vehicleData.desc.."', '"..vehicleData.model.."', '"..json.encode(vehicleData.mods).."', '"..generateOID().."')")
    TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
end)

RegisterServerEvent('qb-occasions:server:buyVehicle')
AddEventHandler('qb-occasions:server:buyVehicle', function(occasionId, vehicleData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql("INSERT INTO `player_vehicles` (`citizenid`, `vehicle`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.citizenid.."', '"..vehicleData.model.."', '"..vehicleData.mods.."', '"..vehicleData.plate.."', '0')")
    QBCore.Functions.ExecuteSql("DELETE FROM `occasion_vehicles` WHERE `occasionId` = '"..occasionId.."'")

    TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
end)

function generateOID()
    local num = math.random(1, 10)..math.random(111, 999)

    return "OC"..num
end