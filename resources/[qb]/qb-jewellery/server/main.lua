QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

local timeOut = false

local alarmTriggered = false

RegisterServerEvent('qb-jewellery:server:setVitrineState')
AddEventHandler('qb-jewellery:server:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
    TriggerClientEvent('qb-jewellery:client:setVitrineState', -1, stateType, state, k)
end)

RegisterServerEvent('qb-jewellery:server:vitrineReward')
AddEventHandler('qb-jewellery:server:vitrineReward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local item = math.random(1, #Config.VitrineRewards)
    local amount = math.random(1, Config.VitrineRewards[item]["amount"]["max"])

    if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Je hebt teveel op zak..', 'error')
    end
    --TriggerClientEvent('QBCore:Notify', src, 'Je hebt '..amount..'x '..QBCore.Shared.Items[Config.VitrineRewards[item]["item"]]["label"]..' ontvangen', 'success')
    
end)

RegisterServerEvent('qb-jewellery:server:setTimeout')
AddEventHandler('qb-jewellery:server:setTimeout', function()
    if not timeOut then
        timeOut = true
        Citizen.CreateThread(function()
            Citizen.Wait(Config.Timeout)

            for k, v in pairs(Config.Locations) do
                Config.Locations[k]["isOpened"] = false
                TriggerClientEvent('qb-jewellery:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('qb-jewellery:client:setAlertState', -1, false)
            end
            timeOut = false
            alarmTriggered = false
        end)
    end
end)

RegisterServerEvent('qb-jewellery:server:PoliceAlertMessage')
AddEventHandler('qb-jewellery:server:PoliceAlertMessage', function(msg, coords, blip)
    local src = source

    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(k)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if blip then
                    if not alarmTriggered then
                        TriggerClientEvent("qb-jewellery:client:PoliceAlertMessage", k, msg, coords, blip)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("qb-jewellery:client:PoliceAlertMessage", k, msg, coords, blip)
                end
            end
        end
    end
end)

QBCore.Functions.CreateCallback('qb-jewellery:server:getCops', function(source, cb)
	local amount = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(k)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
	end
	cb(amount)
end)