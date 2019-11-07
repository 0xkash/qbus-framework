QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- code

RegisterServerEvent('qb-admin:server:kickPlayer')
AddEventHandler('qb-admin:server:kickPlayer', function(ply)
    DropPlayer(ply, "You have been kicked, yeeeeeeeeeeeeeeeeeeet.")
end)

QBCore.Commands.Add("admin", "Open het admin menu!", {}, false, function(source, args)
    TriggerClientEvent('qb-admin:client:openMenu', source)
end)