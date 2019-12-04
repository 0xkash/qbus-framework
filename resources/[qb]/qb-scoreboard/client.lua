QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local scoreboardOpen = false



Citizen.CreateThread(function()
    while true do

        if IsControlJustPressed(0, Config.OpenKey) then
            if not scoreboardOpen then
                SendNUIMessage({
                    action = "open",
                    players = GetCurrentPlayers(),
                    maxPlayers = Config.MaxPlayers,
                    requiredCops = Config.IllegalActions,
                    currentCops = Config.CurrentCops,
                })
                scoreboardOpen = true
            end
        end

        if IsControlJustReleased(0, Config.OpenKey) then
            if scoreboardOpen then
                SendNUIMessage({
                    action = "close",
                })
                scoreboardOpen = false
            end
        end

        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
        if QBCore ~= nil then
            QBCore.Functions.TriggerCallback('qb-scoreboard:server:GetActiveCops', function(cops, config)
                Config.CurrentCops = cops
                Config.IllegalActions = config
            end)
        end
        Citizen.Wait(10000)
    end
end)

function GetCurrentPlayers()
    local TotalPlayers = 0

    for _, player in ipairs(GetActivePlayers()) do
        TotalPlayers = TotalPlayers + 1
    end

    return TotalPlayers
end

RegisterNetEvent('qb-scoreboard:client:SetActivityBusy')
AddEventHandler('qb-scoreboard:client:SetActivityBusy', function(activity, busy)
    Config.IllegalActions[activity].busy = busy
end)