QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- code

RegisterNetEvent('qb-vehicleshop:server:buyVehicle')
AddEventHandler('qb-vehicleshop:server:buyVehicle', function(vehicleData, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local vData = QB.Vehicles[vehicleData.class][vehicleData.vehicle]
    
    if pData.Functions.RemoveMoney('bank', vData.price) then
        QBCore.Functions.ExecuteSql("INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `garage`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vData.vehicle.."', '"..GetHashKey(vData.vehicle).."', '{}', '"..GeneratePlate().."', '"..garage.."')")
        TriggerClientEvent('qb-vehicleshop:client:spawnBoughtVehicle', src, vData.vehicle)
    end
end)

function GeneratePlate()
    local start = "QB"
    local numbers = math.random(111111, 999999)
    local plate = start..numbers

    return plate
end