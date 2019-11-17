QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    if ply.Functions.RemoveMoney('bank', amount) then
        ply.Functions.AddMoney('cash', amount)
    else
      TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet voldoende geld op je bank..', 'error')
    end
end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    if ply.Functions.RemoveMoney('cash', amount) then
        ply.Functions.AddMoney('bank', amount)
    else
      TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet voldoende geld op zak..', 'error')
    end
end)