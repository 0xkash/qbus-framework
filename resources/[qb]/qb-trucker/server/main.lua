QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local DropPrice = math.random(200, 400)
local PaymentTax = 18

RegisterNetEvent('qb-trucker:server:01101110')
AddEventHandler('qb-trucker:server:01101110', function(drops)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local drops = tonumber(drops)
    local bonus = 0
    if drops > 5 then 
        bonus = math.ceil((DropPrice / 100) * 5)
    elseif drops > 10 then
        bonus = math.ceil((DropPrice / 100) * 7)
    elseif drops > 15 then
        bonus = math.ceil((DropPrice / 100) * 10)
    elseif drops > 20 then
        bonus = math.ceil((DropPrice / 100) * 12)
    end
    local price = (DropPrice * drops) + bonus
    local taxAmount = math.ceil((price / 100) * PaymentTax)
    local payment = price - taxAmount
    Player.Functions.AddJobReputation(1)
    Player.Functions.AddMoney("bank", payment)
    TriggerClientEvent('chatMessage', source, "BAAN", "warning", "Je hebt je salaris ontvangen van: €"..payment..", bruto: €"..price.." (waarvan €"..bonus.." bonus) en €"..taxAmount.." belasting ("..PaymentTax.."%)")
end)

