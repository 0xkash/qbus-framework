QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Functions.CreateCallback('qb-occasions:server:getVehicles', function(source, cb)
    QBCore.Functions.ExecuteSql(false, 'SELECT * FROM `occasion_vehicles`', function(result)
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

RegisterServerEvent('qb-occasions:server:ReturnVehicle')
AddEventHandler('qb-occasions:server:ReturnVehicle', function(vehicleData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData['plate'].."' AND `occasionId` = '"..vehicleData["oid"].."'", function(result)
        if result[1] ~= nil then 
            if result[1].seller == Player.PlayerData.citizenid then
                QBCore.Functions.ExecuteSql(true, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicleData["model"].."', '"..GetHashKey(vehicleData["model"]).."', '"..vehicleData["mods"].."', '"..vehicleData["plate"].."', '0')")
                QBCore.Functions.ExecuteSql(true, "DELETE FROM `occasion_vehicles` WHERE `occasionId` = '"..vehicleData["oid"].."'")
                TriggerClientEvent("qb-occasions:client:ReturnOwnedVehicle", src, result[1].mods)
                TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
            else
                TriggerClientEvent('QBCore:Notify', src, 'Dit is niet jouw voertuig...', 'error', 3500)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'Voertuig bestaat niet...', 'error', 3500)
        end
    end)
end)

RegisterServerEvent('qb-occasions:server:sellVehicle')
AddEventHandler('qb-occasions:server:sellVehicle', function(vehiclePrice, vehicleData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql(true, "DELETE FROM `player_vehicles` WHERE `plate` = '"..vehicleData.plate.."' AND `vehicle` = '"..vehicleData.model.."'")
    QBCore.Functions.ExecuteSql(true, "INSERT INTO `occasion_vehicles` (`seller`, `price`, `description`, `plate`, `model`, `mods`, `occasionId`) VALUES ('"..Player.PlayerData.citizenid.."', '"..vehiclePrice.."', '"..escapeSqli(vehicleData.desc).."', '"..vehicleData.plate.."', '"..vehicleData.model.."', '"..json.encode(vehicleData.mods).."', '"..generateOID().."')")
    
    TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "vehiclesold", {model=vehicleData.model, vehiclePrice=vehiclePrice})
    TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Voertuig te koop", "red", "**"..GetPlayerName(src) .. "** heeft een " .. vehicleData.model .. " te koop gezet voor "..vehiclePrice)

    TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
end)

RegisterServerEvent('qb-occasions:server:buyVehicle')
AddEventHandler('qb-occasions:server:buyVehicle', function(vehicleData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local ownerCid = vehicleData['owner']

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData['plate'].."' AND `occasionId` = '"..vehicleData["oid"].."'", function(result)
        local bankAmount = Player.PlayerData.money["bank"]
        local cashAmount = Player.PlayerData.money["cash"]
        if result[1] ~= nil then 
            if cashAmount >= result[1].price then
                Player.Functions.RemoveMoney('cash', result[1].price)
                QBCore.Functions.ExecuteSql(true, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicleData["model"].."', '"..GetHashKey(vehicleData["model"]).."', '"..vehicleData["mods"].."', '"..vehicleData["plate"].."', '0')")
                QBCore.Functions.ExecuteSql(true, "DELETE FROM `occasion_vehicles` WHERE `occasionId` = '"..vehicleData["oid"].."'")
                TriggerClientEvent('qb-occasions:client:BuyFinished', src, result[1].mods)
                QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE citizenid = '"..result[1].seller.."'", function(player)
                    local recieverSteam = QBCore.Functions.GetPlayerByCitizenId(player[1].citizenid)
            
                    if recieverSteam ~= nil then
                        recieverSteam.Functions.AddMoney('bank', math.ceil((result[1].price / 100) * 77))
                        TriggerClientEvent('qb-phone:client:newMailNotify', recieverSteam.PlayerData.source, {
                            sender = "Mosleys Occasions",
                            subject = "Uw voertuig is verkocht!",
                            message = "Je "..QBCore.Shared.Vehicles[vehicleData["model"]].name.." is verkocht voor €"..result[1].price..",-!"
                        })
                    else
                        local moneyInfo = json.decode(player[1].money)
                        moneyInfo.bank = math.ceil((moneyInfo.bank + (result[1].price / 100) * 77))
                        QBCore.Functions.ExecuteSql(false, "UPDATE `players` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..player[1].citizenid.."'")
                    end
                    TriggerEvent('qb-phone:server:sendNewMailToOffline', player[1].citizenid, {
                        sender = "Mosleys Occasions",
                        subject = "U heeft een voertuig verkocht!",
                        message = "Je "..QBCore.Shared.Vehicles[vehicleData["model"]].name.." is verkocht voor €"..result[1].price..",-!"
                    })
                    TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "vehiclebought", {model=vehicleData["model"], from=result[1].citizenid, moneyType="cash", vehiclePrice=result[1].price, plate=result[1].plate})
                    TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Occasion gekocht", "green", "**"..GetPlayerName(src) .. "** heeft een occasian gekocht voor "..result[1].price .. " (" .. result[1].plate .. ") van **"..player[1].citizenid.."**")
                    TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
                end)
            elseif bankAmount >= result[1].price then
                Player.Functions.RemoveMoney('bank', result[1].price, "occasions-bought-vehicle")
                QBCore.Functions.ExecuteSql(true, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicleData["model"].."', '"..GetHashKey(vehicleData["model"]).."', '"..vehicleData["mods"].."', '"..vehicleData["plate"].."', '0')")
                QBCore.Functions.ExecuteSql(true, "DELETE FROM `occasion_vehicles` WHERE `occasionId` = '"..vehicleData["oid"].."'")
                TriggerClientEvent('qb-occasions:client:BuyFinished', src, result[1].model, result[1].plate, result[1].mods)
        
                QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE citizenid = '"..ownerCid.."'", function(player)
                    local recieverSteam = QBCore.Functions.GetPlayerByCitizenId(player[1].citizenid)
            
                    if recieverSteam ~= nil then
                        recieverSteam.Functions.AddMoney('bank', math.ceil((result[1].price / 100) * 77))
                        TriggerClientEvent('qb-phone:client:newMailNotify', recieverSteam.PlayerData.source, {
                            sender = "Mosleys Occasions",
                            subject = "Uw voertuig is verkocht!",
                            message = "Je "..QBCore.Shared.Vehicles[vehicleData["model"]].name.." is verkocht voor €"..result[1].price..",-!"
                        })
                    else
                        local moneyInfo = json.decode(player[1].money)
                        moneyInfo.bank = math.ceil((moneyInfo.bank + (result[1].price / 100) * 77))
                        QBCore.Functions.ExecuteSql(false, "UPDATE `players` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..player[1].citizenid.."'")
                    end
                    TriggerEvent('qb-phone:server:sendNewMailToOffline', player[1].citizenid, {
                        sender = "Mosleys Occasions",
                        subject = "U heeft een voertuig verkocht!",
                        message = "Je "..QBCore.Shared.Vehicles[vehicleData["model"]].name.." is verkocht voor €"..result[1].price..",-!"
                    })
                    TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "vehiclebought", {model=vehicleData["model"], from=player[1].citizenid, moneyType="bank", vehiclePrice=result[1].price, plate=result[1].plate})
                    TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Occasion gekocht", "green", "**"..GetPlayerName(src) .. "** heeft een occasian gekocht voor "..result[1].price .. " (" .. result[1].plate .. ") van **"..player[1].citizenid.."**")
                    TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
                end)
            else
                TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet voldoende geld...', 'error', 3500)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'Voertuig bestaat niet...', 'error', 3500)
        end
    end)
end)

function generateOID()
    local num = math.random(1, 10)..math.random(111, 999)

    return "OC"..num
end

function round(number)
    return number - (number % 1)
end

function escapeSqli(str)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return str:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end