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

QBCore.Functions.CreateCallback('qb-drugs:server:RequestConfig', function(source, cb)
    cb(Config.Dealers)
end)

RegisterServerEvent('qb-drugs:server:succesDelivery')
AddEventHandler('qb-drugs:server:succesDelivery', function(deliveryData, inTime)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local curRep = Player.PlayerData.metadata["dealerrep"]

    if inTime then
        if Player.Functions.GetItemByName('weed_brick') ~= nil and Player.Functions.GetItemByName('weed_brick').amount >= deliveryData["amount"] then
            Player.Functions.RemoveItem('weed_brick', deliveryData["amount"])
            local cops = GetCurrentCops()
            local price = 3000
            if cops == 1 then
                price = 4000
            elseif cops == 2 then
                price = 5000
            elseif cops >= 3 then
                price = 6000
            end
            print("Drugs PRICE BRO: " .. price)
            if curRep < 10 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 8), "dilvery-drugs")
            elseif curRep >= 10 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "dilvery-drugs")
            elseif curRep >= 20 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 12), "dilvery-drugs")
            elseif curRep >= 30 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 15), "dilvery-drugs")
            elseif curRep >= 40 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 18), "dilvery-drugs")
            end

            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_brick"], "remove")
            TriggerClientEvent('QBCore:Notify', src, 'De bestelling is compleet afgeleverd', 'success')

            SetTimeout(math.random(5000, 10000), function()
                TriggerClientEvent('qb-drugs:client:sendDeliveryMail', src, 'perfect', deliveryData)

                Player.Functions.SetMetaData('dealerrep', (curRep + 1))
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Dit voldoet niet aan de bestelling...', 'error')

            if Player.Functions.GetItemByName('weed_brick').amount >= 0 then
                Player.Functions.RemoveItem('weed_brick', Player.Functions.GetItemByName('weed_brick').amount)
                Player.Functions.AddMoney('cash', (Player.Functions.GetItemByName('weed_brick').amount * 6000 / 100 * 5))
            end

            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_brick"], "remove")

            SetTimeout(math.random(5000, 10000), function()
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
        Player.Functions.AddMoney('cash', (deliveryData["amount"] * 6000 / 100 * 4), "dilvery-drugs-too-late")

        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_brick"], "remove")

        SetTimeout(math.random(5000, 10000), function()
            TriggerClientEvent('qb-drugs:client:sendDeliveryMail', src, 'late', deliveryData)

            if curRep - 1 > 0 then
                Player.Functions.SetMetaData('dealerrep', (curRep - 1))
            else
                Player.Functions.SetMetaData('dealerrep', 0)
            end
        end)
    end
end)

RegisterServerEvent('qb-drugs:server:callCops')
AddEventHandler('qb-drugs:server:callCops', function(streetLabel, coords)
    local msg = "Er is een verdachte situatie op "..streetLabel..", mogelijk drugs handel."
    local alertData = {
        title = "Drugshandel",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg
    }
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("qb-drugs:client:robberyCall", Player.PlayerData.source, msg, streetLabel, coords)
                TriggerClientEvent("qb-phone:client:addPoliceAlert", Player.PlayerData.source, alertData)
            end
        end
	end
end)

function GetCurrentCops()
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    print("COPS DRUGS AMOUNT: " .. amount)
    return amount
end