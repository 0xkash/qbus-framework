QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- code

QBCore.Functions.CreateCallback("qb-garage:server:GetUserVehicles", function(source, cb, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE citizenid = @citizenid AND garage = @garage', {['@citizenid'] = pData.PlayerData.citizenid, ['@garage'] = garage}, function(result)
        cb(result)
    end)
end)

RegisterServerEvent('qb-garage:server:updateVehicleState')
AddEventHandler('qb-garage:server:updateVehicleState', function(state, plate, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('UPDATE player_vehicles SET state = @state WHERE plate = @plate AND citizenid = @citizenid AND garage = @garage', {['@state'] = state, ['@plate'] = plate, ['@citizenid'] = pData.PlayerData.citizenid, ['@garage'] = garage})
end)

RegisterServerEvent('qb-garage:server:updateVehicleStatus')
AddEventHandler('qb-garage:server:updateVehicleStatus', function(fuel, engine, body, plate, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    print(engine)

    if engine > 1000 then
        engine = engine / 1000
    end

    if body > 1000 then
        body = body / 1000
    end

    exports['ghmattimysql']:execute('UPDATE player_vehicles SET fuel = @fuel, engine = @engine, body = @body WHERE plate = @plate AND citizenid = @citizenid AND garage = @garage', {
        ['@fuel'] = fuel, 
        ['@engine'] = engine, 
        ['@body'] = body,
        ['@plate'] = plate,
        ['@garage'] = garage,
        ['@citizenid'] = pData.PlayerData.citizenid
    })
end)

