QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local SafeCodes = {
    [1] = math.random(1000, 9999),
    [2] = {math.random(0, 39), math.random(0, 39), math.random(0, 39), math.random(0, 39), math.random(0, 39)}
}

RegisterServerEvent('qb-storerobbery:server:takeMoney')
AddEventHandler('qb-storerobbery:server:takeMoney', function(register)
    local src   = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('cash', Config.RegisterEarnings)
    if math.random(1, 100) <= 2 then
        local code = SafeCodes[Config.Registers[register].safeKey]
        local info = {}
        if Config.Safes[Config.Registers[register].safeKey].type == "keypad" then
            info = {
                label = "Kluis code: "..tostring(code)
            }
        else
            info = {
                label = "Kluis code: "..tostring(code[1]).."-"..tostring(code[2]).."-"..tostring(code[3]).."-"..tostring(code[4]).."-"..tostring(code[5])
            }
        end
        Player.Functions.AddItem("stickynote", 1, nil, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["stickynote"], "add")
    end
end)

RegisterServerEvent('qb-storerobbery:server:setRegisterStatus')
AddEventHandler('qb-storerobbery:server:setRegisterStatus', function(register)
    TriggerClientEvent('qb-storerobbery:client:setRegisterStatus', -1, register, true)
    Config.Registers[register].robbed   = true
    Config.Registers[register].time     = Config.resetTime
end)

RegisterServerEvent('qb-storerobbery:server:setSafeStatus')
AddEventHandler('qb-storerobbery:server:setSafeStatus', function(safe)
    TriggerClientEvent('qb-storerobbery:client:setSafeStatus', -1, safe, true)
    Config.Safes[safe].robbed = true
end)

RegisterServerEvent('qb-storerobbery:server:SafeReward')
AddEventHandler('qb-storerobbery:server:SafeReward', function(safe)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', math.random(500, 800))
end)

RegisterServerEvent('qb-storerobbery:server:callCops')
AddEventHandler('qb-storerobbery:server:callCops', function(type, safe, streetLabel, coords)
    local players = QBCore.Functions.GetPlayers()
    for source, Player in pairs(players) do
		if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
			TriggerClientEvent("qb-storerobbery:client:robberyCall", Player.PlayerData.source, type, safe, streetLabel, coords)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        for k, v in pairs(Config.Registers) do
            if Config.Registers[k].time > 0 and (Config.Registers[k].time - Config.tickInterval) >= 0 then
                Config.Registers[k].time = Config.Registers[k].time - Config.tickInterval
            else
                Config.Registers[k].time = 0
                Config.Registers[k].robbed = false
                TriggerClientEvent('qb-storerobbery:client:setRegisterStatus', -1, k, false)
            end
        end
        Citizen.Wait(Config.tickInterval)
    end
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:isCombinationRight', function(source, cb, safe)
    cb(SafeCodes[safe])
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:getPadlockCombination', function(source, cb, safe)
    cb(SafeCodes[safe])
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:getRegisterStatus', function(source, cb)
    cb(Config.Registers)
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:getRegisterStatus', function(source, cb)
    cb(Config.Safes)
end)