RegisterNetEvent("consumables:client:UseJoint")
AddEventHandler("consumables:client:UseJoint", function()
    QBCore.Functions.Progressbar("smoke_joint", "Joint opsteken..", 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["joint"], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"smokeweed"})
        
        TriggerEvent("evidence:client:SetStatus", "weedsmell", 300)
    end, function() -- Cancel
        
    end)
end)

RegisterNetEvent("consumables:client:UseArmor")
AddEventHandler("consumables:client:UseArmor", function()
    QBCore.Functions.Progressbar("use_armor", "Vest aantrekken..", 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["armor"], "remove")
        SetPedArmour(GetPlayerPed(-1), 100)
    end)
end)

RegisterNetEvent("consumables:client:Eat")
AddEventHandler("consumables:client:Eat", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
    QBCore.Functions.Progressbar("eat_something", "Eten..", 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)

RegisterNetEvent("consumables:client:Drink")
AddEventHandler("consumables:client:Drink", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
    QBCore.Functions.Progressbar("drink_something", "Drinken..", 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
    end)
end)