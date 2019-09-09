QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("inv", "Open je inventory", {}, false, function(source, args)
	TriggerClientEvent("inventory:client:OpenInventory", source)
end)

QBCore.Commands.Add("setnui", "Zet nui aan/ui (0/1)", {}, true, function(source, args)
    if tonumber(args[1]) == 1 then
        TriggerClientEvent("inventory:client:EnableNui", src)
    else
        TriggerClientEvent("inventory:client:DisableNui", src)
    end
end)