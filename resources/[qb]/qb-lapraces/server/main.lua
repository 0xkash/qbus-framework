QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local Races = {}
local RaceList = {}

RegisterServerEvent('qb-lapraces:server:JoinRace')
AddEventHandler('qb-lapraces:server:JoinRace', function(raceId)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local cashAmount = Player.PlayerData.money["cash"]
    if Races[raceId] ~= nil then 
        if cashAmount >= Races[raceId].price then
            Player.Functions.RemoveMoney("cash", Races[raceId].price)
            Races[raceId].pot = Races[raceId].pot + Races[raceId].price
            TriggerClientEvent("qb-lapraces:client:RaceJoined", src, raceId)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Race does not exist??", "error")
    end
end)

RegisterServerEvent('qb-lapraces:client:Refund')
AddEventHandler('qb-lapraces:client:Refund', function(raceId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Races[raceId] ~= nil then 
        Player.Functions.AddMoney("cash", Races[raceId].price)
    else
        TriggerClientEvent('QBCore:Notify', src, "Race does not exist??", "error")
    end
end)

QBCore.Commands.Add("laprace", "Maak een laprace..", {{name="type", help="Welke race wil je? (standard, sandy, highway)"}, {name="bedrag", help="Inleg voor de race"}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local racetype = args[1]:lower()
    local amount = tonumber(args[2])
    local cashAmount = Player.PlayerData.money["cash"]
    if RaceList[racetype] ~= nil then 
        if cashAmount >= amount then 
            local raceId = CreateRaceId()
            Races[raceId] = {
                label = RaceList[racetype].label,
                checkpoints = RaceList.checkpoints,
                creator = Player.PlayerData.citizenid,
                started = false,
                active = true,
                price = amount,
            }
            Player.Functions.RemoveMoney("cash", amount)
            TriggerClientEvent("qb-lapraces:client:RaceCreated", -1, raceId, Races[raceId])
            TriggerClientEvent('QBCore:Notify', src, "Race (" .. RaceList[racetype].label .. ") aangemaakt!")
            Citizen.Wait(500)
            TriggerClientEvent("qb-lapraces:client:RaceJoined", src, raceId)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Race type does not exist??", "error")
    end
end)

QBCore.Commands.Add("startlaprace", "Start de race die je hebt gemaakt..", {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local raceId = GetRaceIdByCreator(Player.PlayerData.citizenid)
    if raceId ~= 0 then 
        TriggerClientEvent("qb-lapraces:client:StartRace", -1, raceId)
    else
        TriggerClientEvent('QBCore:Notify', src, "You are not a creator of a race..", "error")
    end
end)

QBCore.Commands.Add("stoplaprace", "Stop de race die je hebt gemaakt..", {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local raceId = GetRaceIdByCreator(Player.PlayerData.citizenid)
    if raceId ~= 0 then 
        TriggerClientEvent("qb-lapraces:client:StopRace", -1, raceId)
    else
        TriggerClientEvent('QBCore:Notify', src, "You are not a creator of a race..", "error")
    end
end)

function GetRaceIdByCreator(citizenid)
    local retval = 0
    if Races ~= nil then 
        for k, v in pairs(Races) do 
            if Races[k] ~= nil then 
                if Races[k].creator == citizenid then
                    retval = k
                end
            end
        end
    end
    return retval
end

function CreateRaceId()
    local raceId = math.random(1, 9999)
    while Races[raceId] ~= nil do 
        raceId = math.random(1, 9999)
    end
    return raceId
end
