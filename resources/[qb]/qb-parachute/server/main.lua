QBCore.Functions.CreateUseableItem("parachute", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)

    TriggerClientEvent("qb-parachute:client:UseGear", source, true)
end)