QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

--CODE

local Races = {}
RegisterServerEvent('qb-streetraces:NewRace')
AddEventHandler('qb-streetraces:NewRace', function(RaceTable)
    local src = source
    local RaceId = math.random(1000, 9999)
    local xPlayer = QBCore.Functions.GetPlayer(src)
    Races[RaceId] = RaceTable
    Races[RaceId].creator = GetPlayerIdentifiers(src)[1]
    table.insert(Races[RaceId].joined, GetPlayerIdentifiers(src)[1])
    if xPlayer.Functions.RemoveMoney('cash', Races[RaceId].amount) then
        TriggerClientEvent('qb-streetraces:SetRace', -1, Races)
        TriggerClientEvent('qb-streetraces:SetRaceId', src, RaceId)
        TriggerClientEvent('QBCore:Notify', src, "Je doet mee aan de race voor €"..Races[RaceId].amount..",-", 'success')
    end
end)

RegisterServerEvent('qb-streetraces:RaceWon')
AddEventHandler('qb-streetraces:RaceWon', function(RaceId)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    xPlayer.Functions.AddMoney('cash', Races[RaceId].pot)
    TriggerClientEvent('QBCore:Notify', src, "Je hebt de race gewonnen en €"..Races[RaceId].pot..",- ontvangen", 'success')
    TriggerClientEvent('qb-streetraces:SetRace', -1, Races)
    TriggerClientEvent('qb-streetraces:RaceDone', -1, RaceId, GetPlayerName(src))
end)

RegisterServerEvent('qb-streetraces:JoinRace')
AddEventHandler('qb-streetraces:JoinRace', function(RaceId)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local zPlayer = QBCore.Functions.GetPlayer(Races[RaceId].creator)
    if zPlayer ~= nil then
        if xPlayer.PlayerData.money.cash >= Races[RaceId].amount then
            Races[RaceId].pot = Races[RaceId].pot + Races[RaceId].amount
            table.insert(Races[RaceId].joined, GetPlayerIdentifiers(src)[1])
            if xPlayer.Functions.RemoveMoney('cash', Races[RaceId].amount) then
                TriggerClientEvent('qb-streetraces:SetRace', -1, Races)
                TriggerClientEvent('qb-streetraces:SetRaceId', src, RaceId)
                TriggerClientEvent('QBCore:Notify', zPlayer.PlayerData.source, GetPlayerName(src).." is de race gejoined!", 'primary')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "Je hebt niet genoeg cash op zak!", 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Degene die de race heeft gemaakt is offline!", 'error')
        Races[RaceId] = {}
    end
end)

QBCore.Commands.Add("race", "", {}, false, function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local amount = tonumber(args[1])
    if GetJoinedRace(GetPlayerIdentifiers(src)[1]) == 0 then
        if xPlayer.PlayerData.money.cash >= amount then
            TriggerClientEvent('qb-streetraces:CreateRace', src, amount)
        else
            TriggerClientEvent('QBCore:Notify', src, "Je hebt niet genoeg cash op zak!", 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Je zit al in een race!", 'error')
    end
end)

QBCore.Commands.Add("stoprace", "", {}, false, function(source, args)
    local src = source
    CancelRace(src)
end)

QBCore.Commands.Add("quitrace", "", {}, false, function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local RaceId = GetJoinedRace(GetPlayerIdentifiers(src)[1])
    local zPlayer = QBCore.Functions.GetPlayer(Races[RaceId].creator)
    if RaceId ~= 0 then
        if GetCreatedRace(GetPlayerIdentifiers(src)[1]) ~= RaceId then
            RemoveFromRace(GetPlayerIdentifiers(src)[1])
            zPlayer.Functions.AddMoney('cash', Races[RaceId].amount)
            TriggerClientEvent('QBCore:Notify', src, "Je zit al in een race!", 'error')
            TriggerClientEvent('QBCore:Notify', zPlayer.PlayerData.source, "Je zit al in een race!", 'error')
            TriggerClientEvent('esx:showNotification', zPlayer.PlayerData.source, GetPlayerName(src) .." is uit de race gestapt!", "red")
        else
            TriggerClientEvent('QBCore:Notify', src, "/stoprace om de race te stoppen!", 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Je zit niet in een race..", 'error')
    end
end)

QBCore.Commands.Add("startrace", "", {}, false, function(source, args)
    local src = source
    local RaceId = GetCreatedRace(GetPlayerIdentifiers(src)[1])
    if RaceId ~= 0 then
        Races[RaceId].started = true
        TriggerClientEvent('qb-streetraces:SetRace', -1, Races)
        TriggerClientEvent("qb-streetraces:StartRace", -1, RaceId)
    else
        TriggerClientEvent('QBCore:Notify', src, "Je bent geen race gestart!", 'error')
    end
end)

function CancelRace(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and Races[key].creator == xPlayer.identifier and not Races[key].started then
            for _, iden in pairs(Races[key].joined) do
                local xdPlayer = QBCore.Functions.GetPlayer(iden)
                xdPlayer.Functions.AddMoney('cash', Races[key].amount)
                TriggerClientEvent('QBCore:Notify', xdPlayer.PlayerData.source, "Race is gestopt, je hebt €"..Races[key].amount..",- terug ontvangen!", 'error')
                TriggerClientEvent('qb-streetraces:StopRace', xdPlayer.PlayerData.source)
				RemoveFromRace(iden)
            end
            TriggerClientEvent('QBCore:Notify', source, "Race stopgezet!", 'error')
			Races[key] = nil
        end
    end
    TriggerClientEvent('qb-streetraces:SetRace', -1, Races)
end

function RemoveFromRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for i, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    table.remove(Races[key].joined, i)
                end
            end
        end
    end
end

function GetJoinedRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for _, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    return key
                end
            end
        end
    end
    return 0
end

function GetCreatedRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and Races[key].creator == identifier and not Races[key].started then
            return key
        end
    end
    return 0
end
