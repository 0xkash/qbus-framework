QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local ItemTable = {
    [1] = {name = "metalscrap", label = "Metaalschroot", maxAmount = 3},
    [2] = {name = "plastic", label = "Plastic", maxAmount = 5},
    [3] = {name = "copper", label = "Koper", maxAmount = 3},
}

RegisterServerEvent("qb-recycle:server:getItem")
AddEventHandler("qb-recycle:server:getItem", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local randItem = ItemTable[math.random(1, #ItemTable)]
    local amount = math.random(1,randItem.maxAmount)
    Player.Functions.AddItem(randItem.name, amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem.name], 'add')
end)