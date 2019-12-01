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

QBCore.Functions.CreateCallback("qb-occasions:server:getSellerInformation", function(source, cb, citizenid)
    local src = source

    exports['ghmattimysql']:execute('SELECT * FROM players WHERE citizenid = @citizenid', {['@citizenid'] = citizenid}, function(result)
        if result[1] ~= nil then
            cb(result[1])
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('qb-occasions:server:sellVehicle')
AddEventHandler('qb-occasions:server:sellVehicle', function(vehiclePrice, vehicleData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql("DELETE FROM `player_vehicles` WHERE `plate` = '"..vehicleData.plate.."' AND `vehicle` = '"..vehicleData.model.."'")
    QBCore.Functions.ExecuteSql("INSERT INTO `occasion_vehicles` (`seller`, `price`, `description`, `plate`, `model`, `mods`, `occasionId`) VALUES ('"..Player.PlayerData.citizenid.."', '"..vehiclePrice.."', '"..vehicleData.desc.."', '"..vehicleData.plate.."', '"..vehicleData.model.."', '"..json.encode(vehicleData.mods).."', '"..generateOID().."')")
    TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Voertuig te koop", "red", "**"..GetPlayerName(src) .. "** heeft een " .. vehicleData.model .. " te koop gezet voor "..vehiclePrice)

    TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
end)

RegisterServerEvent('qb-occasions:server:buyVehicle')
AddEventHandler('qb-occasions:server:buyVehicle', function(vehicleData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local ownerCid = vehicleData['owner']

    if Player.Functions.RemoveMoney('cash', vehicleData["price"]) then
        QBCore.Functions.ExecuteSql("INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicleData["model"].."', '"..GetHashKey(vehicleData["model"]).."', '"..vehicleData["mods"].."', '"..vehicleData["plate"].."', '0')")
        QBCore.Functions.ExecuteSql("DELETE FROM `occasion_vehicles` WHERE `occasionId` = '"..vehicleData["oid"].."'")


        QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE citizenid = '"..ownerCid.."'", function(result)
            local recieverSteam = QBCore.Functions.GetPlayerByCitizenId(result[1].citizenid)
    
            if recieverSteam then
                recieverSteam.Functions.AddMoney('bank', math.ceil((vehicleData["price"] / 100) * 77))
            else
                local moneyInfo = json.decode(result[1].money)
                moneyInfo.bank = math.ceil((moneyInfo.bank + (vehicleData["price"] / 100) * 77))
                QBCore.Functions.ExecuteSql("UPDATE `players` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..result[1].citizenid.."'")
            end
            TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Occasion gekocht", "green", "**"..GetPlayerName(src) .. "** heeft een occasian gekocht voor "..vehicleData["price"] .. " van **"..result[1].citizenid.."**")
        end)

        TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
    elseif Player.Functions.RemoveMoney('bank', vehicleData["price"]) then
        QBCore.Functions.ExecuteSql("INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicleData["model"].."', '"..GetHashKey(vehicleData["model"]).."', '"..vehicleData["mods"].."', '"..vehicleData["plate"].."', '0')")
        QBCore.Functions.ExecuteSql("DELETE FROM `occasion_vehicles` WHERE `occasionId` = '"..vehicleData["oid"].."'")


        QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE citizenid = '"..ownerCid.."'", function(result)
            local recieverSteam = QBCore.Functions.GetPlayerByCitizenId(result[1].citizenid)
    
            if recieverSteam then
                recieverSteam.Functions.AddMoney('bank', math.ceil((vehicleData["price"] / 100) * 77))
            else
                local moneyInfo = json.decode(result[1].money)
                moneyInfo.bank = math.ceil((moneyInfo.bank + (vehicleData["price"] / 100) * 77))
                QBCore.Functions.ExecuteSql("UPDATE `players` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..result[1].citizenid.."'")
            end
        end)
        TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Occasion gekocht", "green", "**"..GetPlayerName(src) .. "** heeft een occasian gekocht voor "..vehicleData["price"] .. " van **"..result[1].citizenid.."**")

        TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet voldoende geld...', 'error', 3500)
    end
end)

function generateOID()
    local num = math.random(1, 10)..math.random(111, 999)

    return "OC"..num
end

function round(number)
    return number - (number % 1)
end