QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- code

RegisterNetEvent('qb-vehicleshop:server:buyVehicle')
AddEventHandler('qb-vehicleshop:server:buyVehicle', function(vehicleData, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local vData = QB.Vehicles[vehicleData.class][vehicleData.vehicle]
    local balance = pData.PlayerData.money["bank"]
    
    if (balance - vData.price) >= 0 then
        QBCore.Functions.ExecuteSql("INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `garage`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vData.vehicle.."', '"..GetHashKey(vData.vehicle).."', '{}', '"..GeneratePlate().."', '"..garage.."')")
		TriggerClientEvent("QBCore:Notify", src, "Gelukt! Je voertuig is afgeleverd bij "..QB.GarageLabel[garage], "success", 5000)
    else
		TriggerClientEvent("QBCore:Notify", src, "Je hebt niet voldoende geld, je mist €"..format_thousand(vData.price - balance), "error", 5000)
    end
end)

function format_thousand(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

function GeneratePlate()
    local start = "QB"
    local numbers = math.random(111111, 999999)
    local plate = start..numbers

    return plate
end