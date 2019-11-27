QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local robberyBusy = false
local timeOut = false
local blackoutActive = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if blackoutActive then
            Citizen.Wait(1000 * 60 * 10)
            TriggerEvent("qb-weathersync:server:toggleBlackout")
            TriggerClientEvent("police:client:EnableAllCameras", -1)
            TriggerClientEvent("qb-bankrobbery:client:enableAllBankSecurity", -1)
            blackoutActive = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 30)
        TriggerClientEvent("qb-bankrobbery:client:enableAllBankSecurity", -1)
        TriggerClientEvent("police:client:EnableAllCameras", -1)
    end
end)

RegisterServerEvent('qb-bankrobbery:server:setBankState')
AddEventHandler('qb-bankrobbery:server:setBankState', function(bankId, state)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["isOpened"] = state
        TriggerClientEvent('qb-bankrobbery:client:setBankState', -1, bankId, state)
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["isOpened"] = state
        TriggerClientEvent('qb-bankrobbery:client:setBankState', -1, bankId, state)
    else
        Config.SmallBanks[bankId]["isOpened"] = state
        TriggerClientEvent('qb-bankrobbery:client:setBankState', -1, bankId, state)
    end
    

    if not robberyBusy then
        robberyBusy = true
    end
end)

RegisterServerEvent('qb-bankrobbery:server:setLockerState')
AddEventHandler('qb-bankrobbery:server:setLockerState', function(bankId, lockerId, state, bool)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["lockers"][lockerId][state] = bool
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["lockers"][lockerId][state] = bool
    else
        Config.SmallBanks[bankId]["lockers"][lockerId][state] = bool
    end

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
    elseif type == "paleto" then
        local itemType = math.random(#Config.RewardTypes)
        local tierChance = math.random(1, 100)
        local tier = 1
        if tierChance < 25 then tier = 1 elseif tierChance >= 25 and tierChance < 70 then tier = 2 elseif tierChance >= 70 and tierChance < 95 then tier = 3 else tier = 4 end

        if tier ~= 4 then
            if Config.RewardTypes[itemType].type == "item" then
                local item = Config.LockerRewards["tier"..tier][math.random(#Config.LockerRewards["tier"..tier])]
                local itemAmount = math.random(item.maxAmount)

                ply.Functions.AddItem(item.item, itemAmount)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], "add")
            elseif Config.RewardTypes[itemType].type == "money" then
                local moneyAmount = math.random(500, 5000)
                ply.Functions.AddMoney('cash', moneyAmount)
            end
        else
            ply.Functions.AddItem('security_card_02', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['security_card_02'], "add")
        end
    elseif type == "pacific" then
        local itemType = math.random(#Config.RewardTypes)
        local tierChance = math.random(1, 100)
        local tier = 1
        if tierChance < 10 then tier = 1 elseif tierChance >= 25 and tierChance < 50 then tier = 2 elseif tierChance >= 50 and tierChance < 95 then tier = 3 else tier = 4 end
        if tier ~= 4 then
            if Config.RewardTypes[itemType].type == "item" then
                local item = Config.LockerRewards["tier"..tier][math.random(#Config.LockerRewards["tier"..tier])]
                local maxAmount = item.maxAmount
                if tier == 3 then
                    maxAmount = 7
                elseif tier == 2 then
                    maxAmount = 18
                else
                    maxAmount = 25
                end
                local itemAmount = math.random(maxAmount)

                ply.Functions.AddItem(item.item, itemAmount)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], "add")
            elseif Config.RewardTypes[itemType].type == "money" then
                local moneyAmount = math.random(1200, 7000)
                ply.Functions.AddMoney('cash', moneyAmount)
            end
        else
            local info = {
                crypto = math.random(1, 3)
            }
            ply.Functions.AddItem("cryptostick", 1, false, info)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['cryptostick'], "add")
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
    local cameraId = 4
    local bank = "Fleeca"
    local msg = ""
    if type == "small" then
        cameraId = Config.SmallBanks[key]["camId"]
        bank = "Fleeca"
        msg = "Poging bankoverval bij "..bank.. " " ..streetLabel.." (CAMERA ID: "..cameraId..")"
    elseif type == "paleto" then
        cameraId = Config.BigBanks["paleto"]["camId"]
        bank = "Blaine County Savings"
        msg = "Groot alarm! Poging bankoverval bij "..bank.. " Paleto Bay (CAMERA ID: "..cameraId..")"
    elseif type == "pacific" then
        bank = "Pacific Standard Bank"
        msg = "Groot alarm! Poging bankoverval bij "..bank.. " Alta St (CAMERA ID: 1/2/3)"
    end
    local alertData = {
        title = "Bankoverval",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    for source, Player in pairs(players) do
		if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
            TriggerClientEvent("qb-bankrobbery:client:robberyCall", Player.PlayerData.source, type, bank, streetLabel, coords)
            TriggerClientEvent("qb-phone:client:addPoliceAlert", Player.PlayerData.source, alertData)
		end
	end
end)

RegisterServerEvent('qb-bankrobbery:server:SetStationStatus')
AddEventHandler('qb-bankrobbery:server:SetStationStatus', function(key, isHit)
    Config.PowerStations[key].hit = isHit
    TriggerClientEvent("qb-bankrobbery:client:SetStationStatus", -1, key, isHit)
    if AllStationsHit() then
        TriggerEvent("qb-weathersync:server:toggleBlackout")
        TriggerClientEvent("police:client:DisableAllCameras", -1)
        TriggerClientEvent("qb-bankrobbery:client:disableAllBankSecurity", -1)
        blackoutActive = true
    else
        CheckStationHits()
    end
end)

function CheckStationHits()
    if Config.PowerStations[1].hit and Config.PowerStations[2].hit and Config.PowerStations[3].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 19, false)
    end
    if Config.PowerStations[3].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 18, false)
        TriggerClientEvent("police:client:SetCamera", -1, 7, false)
    end
    if Config.PowerStations[4].hit and Config.PowerStations[5].hit and Config.PowerStations[6].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 4, false)
        TriggerClientEvent("police:client:SetCamera", -1, 8, false)
        TriggerClientEvent("police:client:SetCamera", -1, 5, false)
        TriggerClientEvent("police:client:SetCamera", -1, 6, false)
    end
    if Config.PowerStations[1].hit and Config.PowerStations[2].hit and Config.PowerStations[3].hit and Config.PowerStations[4].hit and Config.PowerStations[5].hit and Config.PowerStations[6].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 1, false)
        TriggerClientEvent("police:client:SetCamera", -1, 2, false)
        TriggerClientEvent("police:client:SetCamera", -1, 3, false)
    end
    if Config.PowerStations[7].hit and Config.PowerStations[8].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 9, false)
        TriggerClientEvent("police:client:SetCamera", -1, 10, false)
    end
    if Config.PowerStations[9].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 11, false)
        TriggerClientEvent("police:client:SetCamera", -1, 12, false)
        TriggerClientEvent("police:client:SetCamera", -1, 13, false)
    end
    if Config.PowerStations[9].hit and Config.PowerStations[10].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 14, false)
        TriggerClientEvent("police:client:SetCamera", -1, 17, false)
        TriggerClientEvent("police:client:SetCamera", -1, 19, false)
    end
    if Config.PowerStations[7].hit and Config.PowerStations[9].hit and Config.PowerStations[10].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 15, false)
        TriggerClientEvent("police:client:SetCamera", -1, 16, false)
    end
    if Config.PowerStations[10].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 20, false)
    end
    if Config.PowerStations[11].hit and Config.PowerStations[1].hit and Config.PowerStations[2].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 21, false)
        TriggerClientEvent("qb-bankrobbery:client:BankSecurity", 1, false)
        TriggerClientEvent("police:client:SetCamera", -1, 22, false)
        TriggerClientEvent("qb-bankrobbery:client:BankSecurity", 2, false)
    end
    if Config.PowerStations[8].hit and Config.PowerStations[4].hit and Config.PowerStations[5].hit and Config.PowerStations[6].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 23, false)
        TriggerClientEvent("qb-bankrobbery:client:BankSecurity", 3, false)
    end
    if Config.PowerStations[12].hit and Config.PowerStations[13].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 24, false)
        TriggerClientEvent("qb-bankrobbery:client:BankSecurity", 4, false)
        TriggerClientEvent("police:client:SetCamera", -1, 25, false)
        TriggerClientEvent("qb-bankrobbery:client:BankSecurity", 5, false)
    end
end

function AllStationsHit()
    local retval = true
    for k, v in pairs(Config.PowerStations) do
        if not Config.PowerStations[k].hit then
            retval = false
        end
    end
    return retval
end

QBCore.Functions.CreateUseableItem("thermite", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem('thermite', 1, item.slot) then
        TriggerClientEvent("thermite:UseThermite", source)
    end
end)

QBCore.Functions.CreateUseableItem("security_card_01", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('security_card_01') ~= nil then
        TriggerClientEvent("qb-bankrobbery:UseBankcardA", source)
    end
end)

QBCore.Functions.CreateUseableItem("security_card_02", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('security_card_02') ~= nil then
        TriggerClientEvent("qb-bankrobbery:UseBankcardB", source)
    end
end)