RegisterServerEvent('qb-drugs:server:updateDealerItems')
AddEventHandler('qb-drugs:server:updateDealerItems', function(itemData, amount, dealer)
    Config.Dealers[dealer]["products"][itemData.slot].amount = Config.Dealers[dealer]["products"][itemData.slot].amount - amount

    TriggerClientEvent('qb-drugs:client:setDealerItems', -1, itemData, amount, dealer)
end)