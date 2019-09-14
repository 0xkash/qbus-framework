QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent("inventory:server:OpenInventory")
AddEventHandler('inventory:server:OpenInventory', function()
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	TriggerClientEvent("inventory:client:OpenInventory", source, Player.PlayerData.items)
end)

RegisterServerEvent("inventory:server:UseItemSlot")
AddEventHandler('inventory:server:UseItemSlot', function(slot)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local itemData = Player.Functions.GetItemBySlot(slot)
	if itemData ~= nil then
		if itemData.type == "weapon" then
			TriggerClientEvent("inventory:client:UseWeapon", src, itemData.name)
		elseif itemData.useable then
			TriggerClientEvent("QBCore:Client:UseItem", src, itemData.name)
		end
	end
end)

RegisterServerEvent("inventory:server:UseItem")
AddEventHandler('inventory:server:UseItem', function(inventory, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if inventory == "player" then
		local itemData = Player.Functions.GetItemByName(item.name)
		if itemData ~= nil then
			TriggerClientEvent("QBCore:Client:UseItem", src, itemData.name)
		end
	end
end)

RegisterServerEvent("inventory:server:SetInventoryData")
AddEventHandler('inventory:server:SetInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, fromAmount, toAmount)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if fromInventory == "player" or fromInventory == "hotbar" then
		local fromItemData = Player.Functions.GetItemBySlot(fromSlot)
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot)
			end
		else
			TriggerClientEvent("QBCore:Notify", src, "Je hebt dit item niet!")
		end
	end
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
		if Player.Functions.AddItem(tostring(args[2]), tonumber(args[3])) then
			TriggerClientEvent('QBCore:Notify', source, "Je hebt " ..GetPlayerName(tonumber(args[1])).." " .. tostring(args[2]) .. " ("..tonumber(args[3]).. ") gegeven", "success")
		else
			TriggerClientEvent('QBCore:Notify', source,  "Kan item niet geven!", "error")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Speler is niet online!")
	end
end, "admin")