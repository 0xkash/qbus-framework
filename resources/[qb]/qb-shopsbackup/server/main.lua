QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

--CODE

RegisterServerEvent('qb-shops:server:buyItem')
AddEventHandler('qb-shops:server:buyItem', function(price, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveMoney('cash', price) then
        Player.Functions.AddItem(item, 1)
        TriggerClientEvent('QBCore:Notify', src, 'Product gekocht voor €'..price..',-', 'success', 1500)
        TriggerClientEvent('QBCore:Notify', src, '+1 '..QBCore.Shared.Items[item]["label"], 'success', 1500)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet voldoende geld...', 'error', 1500)
    end
end)