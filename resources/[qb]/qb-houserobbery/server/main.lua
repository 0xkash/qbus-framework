QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code


RegisterServerEvent('qb-houserobbery:server:loadHouseData')
AddEventHandler('qb-houserobbery:server:loadHouseData', function()
    local src = source
    TriggerClientEvent("qb-houserobbery:client:setHouseData", src, Config.Houses)
end)

RegisterServerEvent('qb-houserobbery:server:enterHouse')
AddEventHandler('qb-houserobbery:server:enterHouse', function(house)
    local src = source
    local itemInfo = QBCore.Shared.Items["lockpick"]
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('qb-houserobbery:client:enterHouse', src, house)
    TriggerClientEvent('qb-houserobbery:client:setHouseState', -1, house, true)
    Config.Houses[house]["opened"] = true
end)

RegisterServerEvent('qb-houserobbery:server:searchCabin')
AddEventHandler('qb-houserobbery:server:searchCabin', function(cabin, house)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local luck = math.random(1, 10)
    local itemFound = math.random(1, 4)
    local itemCount = 1

    if itemFound < 4 then
        if luck == 10 then
            itemCount = 3
        elseif luck >= 6 and luck <= 8 then
            itemCount = 2
        end

        for i = 1, itemCount, 1 do
            local randomItem = Config.Rewards[Config.Houses[house]["furniture"][cabin]["type"]][math.random(1, #Config.Rewards[Config.Houses[house]["furniture"][cabin]["type"]])]
            local itemInfo = QBCore.Shared.Items[randomItem]
            if math.random(1, 100) == 69 then
                randomItem = "painkillers"
                itemInfo = QBCore.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            else
                if not itemInfo["unqiue"] then
                    local itemAmount = math.random(1, 3)
                    if randomItem == "plastic" then
                        itemAmount = math.random(15, 30)
                    elseif randomItem == "goldchain" then
                        itemAmount = math.random(5, 8)
                    end
                    Player.Functions.AddItem(randomItem, itemAmount)
                    --TriggerClientEvent('QBCore:Notify', src, '+'..itemAmount..' '..itemInfo["label"], 'success', 3500)
                else
                    Player.Functions.AddItem(randomItem, 1)
                end
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            end
            Citizen.Wait(500)
            -- local weaponChance = math.random(1, 100)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Het kastje is leeg broooo', 'error', 3500)
    end

    TriggerClientEvent('qb-houserobbery:client:setCabinState', -1, house, cabin, true)
end)