QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(2500)
        GenerateVehicleList()
        Citizen.Wait((1000 * 60) * 60)
    end
end)

RegisterServerEvent('qb-scrapyard:server:ScrapVehicle')
AddEventHandler('qb-scrapyard:server:ScrapVehicle', function(listKey)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    if Config.CurrentVehicles[listKey] ~= nil then 
        local rewards = Config.Rewards[math.random(1, #Config.Rewards)]
        for k, v in pairs(rewards) do
            Player.Functions.AddItem(k, rewards[k])
            TriggerClientEvent('QBCore:Notify', src, QBCore.Shared.Items[k]["label"] .. " ontvangen")
        end
        Config.CurrentVehicles[listKey] = nil
        TriggerClientEvent("qb-scapyard:client:setNewVehicles", -1, Config.CurrentVehicles)
    end
end)

function GenerateVehicleList()
    Config.CurrentVehicles = {}
    for i = 1, 11, 1 do
        local randVehicle = Config.Vehicles[math.random(1, #Config.Vehicles)]
        if not IsInList(randVehicle) then
            Config.CurrentVehicles[i] = randVehicle
        end
    end
    TriggerClientEvent("qb-scapyard:client:setNewVehicles", -1, Config.CurrentVehicles)
end

function IsInList(name)
    local retval = false
    if Config.CurrentVehicles ~= nil and next(Config.CurrentVehicles) ~= nil then 
        for k, v in pairs(Config.CurrentVehicles) do
            if Config.CurrentVehicles[k] == name then 
                retval = true
            end
        end
    end
    return retval
end
