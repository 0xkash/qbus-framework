QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent("inventory:server:OpenInventory")
AddEventHandler('inventory:server:OpenInventory', function()
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	TriggerClientEvent("inventory:client:OpenInventory", source, Player.PlayerData.items)
end)

RegisterServerEvent("inventory:server:SetInventoryData")
AddEventHandler('inventory:server:SetInventoryData', function(fromSlot, fromInventory, toSlot, toInventory, itemData)
	
end)

QBCore.Commands.Add("inv", "Open je inventory", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
	TriggerClientEvent("inventory:client:OpenInventory", source, Player.PlayerData.items)
end)

QBCore.Commands.Add("setnui", "Zet nui aan/ui (0/1)", {}, true, function(source, args)
    if tonumber(args[1]) == 1 then
        TriggerClientEvent("inventory:client:EnableNui", src)
    else
        TriggerClientEvent("inventory:client:DisableNui", src)
    end
end)

QBCore.Commands.Add("giveitem", "Geef een item aan een speler", {{name="id", help="Speler ID"},{name="item", help="Naam van het item (geen label)"}, {name="amount", help="Aantal items"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.AddItem(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Speler is niet online!")
	end
end, "admin")