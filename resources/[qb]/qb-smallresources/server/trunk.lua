local trunkBusy = {}

RegisterServerEvent('qb-smallresources:trunk:server:setTrunkBusy')
AddEventHandler('qb-smallresources:trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

QBCore.Commands.Add("kofferbak", "Ga in of uit kofferbak", {}, false, function(source, args)
	TriggerClientEvent('qb-smallresources:trunk:client:getInTrunk', source)
end)

QBCore.Functions.CreateCallback('qb-smallresources:trunk:server:getTrunkBusy', function(source, cb, plate)
    if trunkBusy[plate] then
        cb(true)
    end
    cb(false)
end)