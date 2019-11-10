RegisterServerEvent('qb-drugs:server:updateDealerItems')
AddEventHandler('qb-drugs:server:updateDealerItems', function(itemData, amount, dealer)
    Config.Dealers[dealer]["products"][itemData.slot].amount = Config.Dealers[dealer]["products"][itemData.slot].amount - amount

    TriggerClientEvent('qb-drugs:client:setDealerItems', -1, itemData, amount, dealer)
end)

RegisterServerEvent('qb-drugs:server:giveDeliveryItems')
AddEventHandler('qb-drugs:server:giveDeliveryItems', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddItem('weed_brick', amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_brick"], "add")
end)

RegisterServerEvent('qb-drugs:server:succesDelivery')
AddEventHandler('qb-drugs:server:succesDelivery', function(deliveryData, inTime)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local curRep = Player.PlayerData.metadata["dealerrep"]

    if inTime then
        if Player.Functions.GetItemByName('weed_brick').amount >= deliveryData["amount"] then
            Player.Functions.RemoveItem('weed_brick', deliveryData["amount"])

            if curRep < 10 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * 6000 / 100 * 8))
            elseif curRep >= 10 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * 6000 / 100 * 10))
            elseif curRep >= 20 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * 6000 / 100 * 12))
            elseif curRep >= 30 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * 6000 / 100 * 15))
            elseif curRep >= 40 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * 6000 / 100 * 18))
            end

            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_brick"], "remove")
            TriggerClientEvent('QBCore:Notify', src, 'De bestelling is compleet afgeleverd', 'success')

            SetTimeout(math.random(2000, 8000), function()
                TriggerClientEvent('qb-drugs:client:sendDeliveryMail', src, 'perfect', deliveryData)

                Player.Functions.SetMetaData('dealerrep', (curRep + 1))
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Dit voldoet niet aan de bestelling...', 'error')

            Player.Functions.RemoveItem('weed_brick', deliveryData["amount"])
            Player.Functions.AddMoney('cash', (deliveryData["amount"] * 6000 / 100 * 5))

            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_brick"], "remove")

            SetTimeout(math.random(2000, 8000), function()
                TriggerClientEvent('qb-drugs:client:sendDeliveryMail', src, 'bad', deliveryData)

                if curRep - 1 > 0 then
                    Player.Functions.SetMetaData('dealerrep', (curRep - 1))
                else
                    Player.Functions.SetMetaData('dealerrep', 0)
                end
            end)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Je bent te laat...', 'error')

        Player.Functions.RemoveItem('weed_brick', deliveryData["amount"])
        Player.Functions.AddMoney('cash', (deliveryData["amount"] * 6000 / 100 * 4))

        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_brick"], "remove")

        SetTimeout(math.random(2000, 8000), function()
            TriggerClientEvent('qb-drugs:client:sendDeliveryMail', src, 'late', deliveryData)

            if curRep - 1 > 0 then
                Player.Functions.SetMetaData('dealerrep', (curRep - 1))
            else
                Player.Functions.SetMetaData('dealerrep', 0)
            end
        end)
    end
end)