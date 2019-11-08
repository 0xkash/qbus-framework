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