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
    end)
end)

RegisterNetEvent("consumables:client:UseArmor")
AddEventHandler("consumables:client:UseArmor", function()
    QBCore.Functions.Progressbar("use_armor", "Vest aantrekken..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["armor"], "remove")
        SetPedArmour(GetPlayerPed(-1), 75)
    end)
end)
local currentVest = nil
local currentVestTexture = nil
RegisterNetEvent("consumables:client:UseHeavyArmor")
AddEventHandler("consumables:client:UseHeavyArmor", function()
    QBCore.Functions.Progressbar("use_heavyarmor", "Vest aantrekken..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        currentVest = GetPedDrawableVariation(GetPlayerPed(-1), 9)
        currentVestTexture = GetPedTextureVariation(GetPlayerPed(-1), 9)
        if GetPedDrawableVariation(GetPlayerPed(-1), 9) == 7 then
            SetPedComponentVariation(GetPlayerPed(-1), 9, 18, GetPedTextureVariation(GetPlayerPed(-1), 9), 2)
        else
            SetPedComponentVariation(GetPlayerPed(-1), 9, 12, 1, 2) -- blauw
        end
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["armor"], "remove")
        SetPedArmour(GetPlayerPed(-1), 100)
    end)
end)

RegisterNetEvent("consumables:client:ResetArmor")
AddEventHandler("consumables:client:ResetArmor", function()
    if currentVest ~= nil and currentVestTexture ~= nil then 
        QBCore.Functions.Progressbar("remove_armor", "Vest uittrekken..", 2500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetPedComponentVariation(GetPlayerPed(-1), 9, currentVest, currentVestTexture, 2)
            SetPedArmour(GetPlayerPed(-1), 0)
        end)
    else
        QBCore.Functions.Notify("Vest niet gezet..", "error")
    end
end)

RegisterNetEvent("consumables:client:Eat")
AddEventHandler("consumables:client:Eat", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
    QBCore.Functions.Progressbar("eat_something", "Eten..", 2500, false, true, {
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
    QBCore.Functions.Progressbar("drink_something", "Drinken..", 2500, false, true, {
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