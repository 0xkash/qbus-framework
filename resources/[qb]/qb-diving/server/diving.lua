local CurrentDivingArea = 0

Citizen.CreateThread(function()
    Wait(1000)
    CurrentDivingArea = math.random(1, #QBDiving.Locations)
    print('Divingspot has been set! : '..CurrentDivingArea)
    TriggerClientEvent('qb-diving:client:SetDivingLocation', -1, CurrentDivingArea)
end)