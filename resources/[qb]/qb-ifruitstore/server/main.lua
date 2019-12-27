QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local alarmTriggered = false

RegisterServerEvent('qb-ifruitstore:server:LoadLocationList')
AddEventHandler('qb-ifruitstore:server:LoadLocationList', function()
    local src = source 
    TriggerClientEvent("qb-ifruitstore:server:LoadLocationList", src, Config.Locations)
end)

RegisterServerEvent('qb-ifruitstore:server:setSpotState')
AddEventHandler('qb-ifruitstore:server:setSpotState', function(stateType, state, spot)
    if stateType == "isBusy" then
        Config.Locations["takeables"][spot].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["takeables"][spot].isDone = state
    end
    TriggerClientEvent('qb-ifruitstore:client:setSpotState', -1, stateType, state, spot)
end)

RegisterServerEvent('qb-ifruitstore:server:SetThermiteStatus')
AddEventHandler('qb-ifruitstore:server:SetThermiteStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["thermite"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["thermite"].isDone = state
    end
    TriggerClientEvent('qb-ifruitstore:client:SetThermiteStatus', -1, stateType, state)
end)

RegisterServerEvent('qb-ifruitstore:server:itemReward')
AddEventHandler('qb-ifruitstore:server:itemReward', function(spot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Config.Locations["takeables"][spot].reward

    if Player.Functions.AddItem(item, 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Je hebt teveel op zak..', 'error')
    end    
end)

RegisterServerEvent('qb-ifruitstore:server:PoliceAlertMessage')
AddEventHandler('qb-ifruitstore:server:PoliceAlertMessage', function(msg, coords, blip)
    local src = source
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if blip then
                    if not alarmTriggered then
                        TriggerClientEvent("qb-jewellery:client:PoliceAlertMessage", v, msg, coords, blip)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("qb-jewellery:client:PoliceAlertMessage", v, msg, coords, blip)
                end
            end
        end
    end
end)