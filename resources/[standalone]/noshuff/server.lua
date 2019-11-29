QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Commands.Add("shuff", "Van stoel schuiven", {}, false, function(source, args)
    TriggerClientEvent('qb-seatshuff:client:Shuff', source)
end)