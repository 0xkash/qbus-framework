QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

local robberyBusy = false
local timeOut = false

RegisterServerEvent('qb-bankrobbery:server:setBankState')
AddEventHandler('qb-bankrobbery:server:setBankState', function(bankId, state)
    Config.SmallBanks[bankId]["isOpened"] = state
    TriggerClientEvent('qb-bankrobbery:client:setBankState', -1, bankId, state)

    if not robberyBusy then
        robberyBusy = true
    end
end)

RegisterServerEvent('qb-bankrobbery:server:setLockerState')
AddEventHandler('qb-bankrobbery:server:setLockerState', function(bankId, lockerId, state, bool)
    Config.SmallBanks[bankId]["lockers"][lockerId][state] = bool

    TriggerClientEvent('qb-bankrobbery:client:setLockerState', -1, bankId, lockerId, state, bool)
end)

RegisterServerEvent('qb-bankrobbery:server:recieveItem')
AddEventHandler('qb-bankrobbery:server:recieveItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    if type == "small" then
        local itemType = math.random(#Config.RewardTypes)
        local tierChance = math.random(1, 100)
        local tier = 1
        if tierChance < 50 then tier = 1 elseif tierChance >= 50 and tierChance < 80 then tier = 2 elseif tierChance >= 80 and tierChance < 95 then tier = 3 else tier = 4 end

        if tier ~= 4 then
            if Config.RewardTypes[itemType].type == "item" then
                local item = Config.LockerRewards["tier"..tier][math.random(#Config.LockerRewards["tier"..tier])]
                local itemAmount = math.random(item.maxAmount)

                ply.Functions.AddItem(item.item, itemAmount)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], "add")
            elseif Config.RewardTypes[itemType].type == "money" then
                local moneyAmount = math.random(Config.RewardTypes[itemType].maxAmount)
                ply.Functions.AddMoney('cash', moneyAmount)
            end
        else
            ply.Functions.AddItem('security_card_01', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['security_card_01'], "add")
        end
    end
end)

QBCore.Functions.CreateCallback('qb-bankrobbery:server:isRobberyActive', function(source, cb)
    cb(robberyBusy)
end)

RegisterServerEvent('qb-bankrobbery:server:setTimeout')
AddEventHandler('qb-bankrobbery:server:setTimeout', function()
    if not timeOut then
        timeOut = true
        Citizen.CreateThread(function()
            Citizen.Wait(30 * 60 * 1000)

            for k,_ in pairs(Config.SmallBanks) do
                Config.SmallBanks[k]["isOpened"] = false
                for _, v in pairs(Config.SmallBanks[k]["lockers"]) do
                    v["isOpened"] = false
                end
            end
            timeOut = false
        end)
    end
end)

RegisterServerEvent('qb-bankrobbery:server:callCops')
AddEventHandler('qb-bankrobbery:server:callCops', function(type, bank, streetLabel, coords)
    local players = QBCore.Functions.GetPlayers()
    for source, Player in pairs(players) do
		if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
			TriggerClientEvent("qb-bankrobbery:client:robberyCall", Player.PlayerData.source, type, bank, streetLabel, coords)
		end
	end
end)