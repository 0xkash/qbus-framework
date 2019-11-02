local trunkBusy = {}

RegisterServerEvent('qb-smallresources:trunk:server:setTrunkBusy')
AddEventHandler('qb-smallresources:trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

QBCore.Functions.CreateCallback('qb-smallresources:trunk:server:getTrunkBusy', function(source, cb, plate)
    if trunkBusy[plate] then
        cb(true)
    end
    cb(false)
end)