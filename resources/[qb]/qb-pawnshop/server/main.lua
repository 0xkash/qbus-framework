QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local ItemList = {
    ["goldchain"] = math.random(100, 250),
    ["diamond_ring"] = math.random(200, 350),
    ["rolex"] = math.random(300, 500),
}

local MeltItems = {
    ["rolex"] = 6,
    ["goldchain"] = 16,
}

local GoldBarsAmount = 0

RegisterServerEvent("qb-pawnshop:server:sellPawnItems")
AddEventHandler("qb-pawnshop:server:sellPawnItems", function()
    local src = source
    local price = 0
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price)
        TriggerClientEvent('QBCore:Notify', src, "Je hebt je items verkocht")
    end
end)

RegisterServerEvent("qb-pawnshop:server:getGoldBars")
AddEventHandler("qb-pawnshop:server:getGoldBars", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if GoldBarsAmount > 0 then
        if Player.Functions.AddItem("goldbar", GoldBarsAmount) then
            GoldBarsAmount = 0
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["goldbar"], "add")
            TriggerClientEvent("qb-pawnshop:client:pickedUp", -1)
        else
            TriggerClientEvent('QBCore:Notify', src, "Je hebt geen ruimte in je inventory", "error")
        end
    end
end)

RegisterServerEvent("qb-pawnshop:server:meltItems")
AddEventHandler("qb-pawnshop:server:meltItems", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local goldbars = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if MeltItems[Player.PlayerData.items[k].name] ~= nil then 
                    local amount = math.ceil(Player.PlayerData.items[k].amount / MeltItems[Player.PlayerData.items[k].name])
                    if amount > 0 then
                        if Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k) then
                            goldbars = goldbars + amount
                        end
                    end
                end
            end
        end
        if goldbars > 0 then
            GoldBarsAmount = goldbars
            TriggerClientEvent('qb-pawnshop:client:startMelting', -1)
        else
            TriggerClientEvent('QBCore:Notify', src, "Je hebt geen juiste items", "error")
        end
    end
end)

QBCore.Functions.CreateCallback('qb-pawnshop:server:getSellPrice', function(source, cb)
	local retval = 0
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    retval = retval + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                end
            end
        end
    end
    print(retval)
    cb(retval)
end)