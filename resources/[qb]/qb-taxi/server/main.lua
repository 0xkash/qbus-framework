QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

RegisterServerEvent('qb-taxi:server:toggleMeter')
AddEventHandler('qb-taxi:server:toggleMeter', function(data)
    TriggerClientEvent('qb-taxi:server:toggleMeter', -1, data.enabled, data.plate)
end)