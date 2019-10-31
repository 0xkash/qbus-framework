QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

Drops = {}
Trunks = {}
Gloveboxes = {}

RegisterServerEvent("inventory:server:OpenInventory")
AddEventHandler('inventory:server:OpenInventory', function(name, id)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if name ~= nil and id ~= nil then
		local secondInv = {}
		if name == "stash" then
			secondInv.name = "stash-"..id
			secondInv.label = "Stash-"..id
			secondInv.maxweight = 1000000
			secondInv.inventory = GetStashItems(id)
			secondInv.slots = 100
		elseif name == "trunk" then
			secondInv.name = "trunk-"..id
			secondInv.label = "Trunk-"..id
			secondInv.maxweight = 1000000
			secondInv.inventory = {}
			secondInv.slots = 69
			if Trunks[id] ~= nil then
				secondInv.inventory = Trunks[id].items
			elseif GetOwnedVehicleItems(id) ~= nil then
				secondInv.inventory = GetOwnedVehicleItems(id)
			else
				Trunks[id] = {}
				Trunks[id].items = {}
			end
		elseif name == "glovebox" then
			secondInv.name = "glovebox-"..id
			secondInv.label = "Glovebox-"..id
			secondInv.maxweight = 10000
			secondInv.inventory = {}
			secondInv.slots = 5
			if Gloveboxes[id] ~= nil then
				secondInv.inventory = Gloveboxes[id].items
			elseif GetOwnedVehicleGloveboxItems(id) ~= nil then
				secondInv.inventory = GetOwnedVehicleGloveboxItems(id)
			else
				Gloveboxes[id] = {}
				Gloveboxes[id].items = {}
			end
		else
			if Drops[id] ~= nil then
				secondInv.name = id
				secondInv.label = "Dropped-"..tostring(id)
				secondInv.maxweight = 900000
				secondInv.inventory = Drops[id].items
				secondInv.slots = 100
			end
		end
		TriggerClientEvent("inventory:client:OpenInventory", src, Player.PlayerData.items, secondInv)
	else
		TriggerClientEvent("inventory:client:OpenInventory", src, Player.PlayerData.items)
	end
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
			TriggerClientEvent("QBCore:Client:UseItem", src, itemData)
		end
	end
end)

RegisterServerEvent("inventory:server:UseItem")
AddEventHandler('inventory:server:UseItem', function(inventory, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if inventory == "player" or inventory == "hotbar" then
		local itemData = Player.Functions.GetItemBySlot(item.slot)
		if itemData ~= nil then
			TriggerClientEvent("QBCore:Client:UseItem", src, itemData)
		end
	end
end)

RegisterServerEvent("inventory:server:SetInventoryData")
AddEventHandler('inventory:server:SetInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, fromAmount, toAmount, fromType)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local fromSlot = tonumber(fromSlot)
	local toSlot = tonumber(toSlot)
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
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "trunk" then
				local plate = QBCore.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = {}
				if IsVehicleOwned(plate) then
					toItemData = GetOwnedVehicleItems(plate)[toSlot]
				else
					toItemData = Trunks[plate].items[toSlot]
				end
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromTrunk(plate, fromSlot, itemInfo["name"], toAmount)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToTrunk(plate, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
			elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "glovebox" then
				local plate = QBCore.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = {}
				if IsVehicleOwned(plate) then
					toItemData = GetOwnedVehicleGloveboxItems(plate)[toSlot]
				else
					toItemData = Gloveboxes[plate].items[toSlot]
				end
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], toAmount)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToGlovebox(plate, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
			elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "stash" then
				local stashId = QBCore.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = GetStashItems(stashId)[toSlot]
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromStash(stashId, fromSlot, itemInfo["name"], toAmount)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToStash(stashId, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
			else
				-- drop
				toInventory = tonumber(toInventory)
				if toInventory == nil or toInventory == 0 then
					CreateNewDrop(src, fromSlot, toSlot, fromAmount)
				else
					local toItemData = Drops[toInventory].items[toSlot]
					Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
					--Player.PlayerData.items[toSlot] = fromItemData
					if toItemData ~= nil then
						--Player.PlayerData.items[fromSlot] = toItemData
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
						if toItemData.name ~= fromItemData.name then
							RemoveFromDrop(toInventory, fromSlot, itemInfo["name"], toAmount)
							Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
						end
					else
						--Player.PlayerData.items[fromSlot] = nil
					end
					local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
					AddToDrop(toInventory, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
				end
			end
		else
			TriggerClientEvent("QBCore:Notify", src, "Je hebt dit item niet!", "error")
		end
	elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "trunk" then
		local plate = QBCore.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = {}
		if IsVehicleOwned(plate) then
			fromItemData = GetOwnedVehicleItems(plate)[fromSlot]
		else
			fromItemData = Trunks[plate].items[fromSlot]
		end
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromTrunk(plate, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToTrunk(plate, fromSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = {}
				if IsVehicleOwned(plate) then
					toItemData = GetOwnedVehicleItems(plate)[toSlot]
				else
					toItemData = Trunks[plate].items[toSlot]
				end
				RemoveFromTrunk(plate, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveFromTrunk(plate, toSlot, itemInfo["name"], toAmount)
						AddToTrunk(plate, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToTrunk(plate, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("QBCore:Notify", src, "Item bestaat niet??", "error")
		end
	elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "glovebox" then
		local plate = QBCore.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = {}
		if IsVehicleOwned(plate) then
			fromItemData = GetOwnedVehicleGloveboxItems(plate)[fromSlot]
		else
			fromItemData = Gloveboxes[plate].items[fromSlot]
		end
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToGlovebox(plate, fromSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = {}
				if IsVehicleOwned(plate) then
					toItemData = GetOwnedVehicleGloveboxItems(plate)[toSlot]
				else
					toItemData = Gloveboxes[plate].items[toSlot]
				end
				RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveFromGlovebox(plate, toSlot, itemInfo["name"], toAmount)
						AddToGlovebox(plate, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToGlovebox(plate, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("QBCore:Notify", src, "Item bestaat niet??", "error")
		end
	elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "stash" then
		local stashId = QBCore.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = GetStashItems(stashId)[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToStash(stashId, fromSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = GetStashItems(stashId)[toSlot]
				RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveFromStash(stashId, toSlot, itemInfo["name"], toAmount)
						AddToStash(stashId, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToStash(stashId, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("QBCore:Notify", src, "Item bestaat niet??", "error")
		end
	else
		-- drop
		fromInventory = tonumber(fromInventory)
		local fromItemData = Drops[fromInventory].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromDrop(fromInventory, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToDrop(fromInventory, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				toInventory = tonumber(toInventory)
				local toItemData = Drops[toInventory].items[toSlot]
				RemoveFromDrop(fromInventory, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveFromDrop(toInventory, toSlot, itemInfo["name"], toAmount)
						AddToDrop(fromInventory, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToDrop(toInventory, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("QBCore:Notify", src, "Item bestaat niet??", "error")
		end
	end
end)

function IsVehicleOwned(plate)
	QBCore.Functions.ExecuteSql("SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
		if (result[1] ~= nil) then
			return true
		end
		return false
	end)
	return false
end

-- Stash Items
function GetStashItems(stashId)
	local items = {}
	QBCore.Functions.ExecuteSql("SELECT * FROM `stashitems` WHERE `stash` = '"..stashId.."'", function(result)
		if result[1] ~= nil then
			for k, item in pairs(result) do
				local itemInfo = QBCore.Shared.Items[item.name:lower()]
				items[item.slot] = {
					name = itemInfo["name"],
					amount = tonumber(item.amount),
					info = json.decode(item.info) ~= nil and json.decode(item.info) or "",
					label = itemInfo["label"],
					description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
					weight = itemInfo["weight"], 
					type = itemInfo["type"], 
					unique = itemInfo["unique"], 
					useable = itemInfo["useable"], 
					image = itemInfo["image"],
					slot = item.slot,
				}
			end
		end
	end)
	return items
end

function SaveStashItems(stashId, items)
	QBCore.Functions.ExecuteSql("DELETE FROM `stashitems` WHERE `stash` = '"..stashId.."'")
	if items ~= nil then
		for slot, item in pairs(items) do
			if items[slot] ~= nil then
				QBCore.Functions.ExecuteSql("INSERT INTO `stashitems` (`stash`, `name`, `amount`, `info`, `type`, `slot`) VALUES ('"..stashId.."', '"..items[slot].name.."', '"..items[slot].amount.."', '"..json.encode(items[slot].info).."', '"..items[slot].type.."', '"..slot.."')")
			end
		end
	end
end

function AddToStash(stashId, slot, itemName, amount, info)
	local amount = tonumber(amount)
	local stashItems = GetStashItems(stashId)
	if stashItems[slot] ~= nil and stashItems[slot].name == itemName then
		stashItems[slot].amount = stashItems[slot].amount + amount
	else
		local itemInfo = QBCore.Shared.Items[itemName:lower()]
		stashItems[slot] = {
			name = itemInfo["name"],
			amount = amount,
			info = info ~= nil and info or "",
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = slot,
		}
	end
	SaveStashItems(stashId, stashItems)
end

function RemoveFromStash(stashId, slot, itemName, amount)
	local stashItems = GetStashItems(stashId)
	if stashItems[slot] ~= nil and stashItems[slot].name == itemName then
		if stashItems[slot].amount > amount then
			stashItems[slot].amount = stashItems[slot].amount - amount
		else
			stashItems[slot] = nil
			if next(stashItems) == nil then
				stashItems = nil
			end
		end
	else
		stashItems[slot ]= nil
		if stashItems == nil then
			stashItems[slot] = nil
		end
	end
	SaveStashItems(stashId, stashItems)
end

-- Trunk items
function GetOwnedVehicleItems(plate)
	local items = {}
	QBCore.Functions.ExecuteSql("SELECT * FROM `trunkitems` WHERE `plate` = '"..plate.."'", function(result)
		if result[1] ~= nil then
			for k, item in pairs(result) do
				local itemInfo = QBCore.Shared.Items[item.name:lower()]
				items[item.slot] = {
					name = itemInfo["name"],
					amount = tonumber(item.amount),
					info = json.decode(item.info) ~= nil and json.decode(item.info) or "",
					label = itemInfo["label"],
					description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
					weight = itemInfo["weight"], 
					type = itemInfo["type"], 
					unique = itemInfo["unique"], 
					useable = itemInfo["useable"], 
					image = itemInfo["image"],
					slot = item.slot,
				}
			end
		end
	end)
	return items
end

function SaveOwnedVehicleItems(plate, items)
	QBCore.Functions.ExecuteSql("DELETE FROM `trunkitems` WHERE `plate` = '"..plate.."'")
	if items ~= nil then
		for slot, item in pairs(items) do
			if items[slot] ~= nil then
				QBCore.Functions.ExecuteSql("INSERT INTO `trunkitems` (`plate`, `name`, `amount`, `info`, `type`, `slot`) VALUES ('"..plate.."', '"..items[slot].name.."', '"..items[slot].amount.."', '"..json.encode(items[slot].info).."', '"..items[slot].type.."', '"..slot.."')")
			end
		end
	end
end

function AddToTrunk(plate, slot, itemName, amount, info)
	local amount = tonumber(amount)
	if IsVehicleOwned(plate) then
		local trunkItems = GetOwnedVehicleItems(plate)
		if trunkItems[slot] ~= nil and trunkItems[slot].name == itemName then
			trunkItems[slot].amount = trunkItems[slot].amount + amount
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			trunkItems[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
		SaveOwnedVehicleItems(plate, trunkItems)
	else
		if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
			Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount + amount
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Trunks[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	end
end

function RemoveFromTrunk(plate, slot, itemName, amount)
	if IsVehicleOwned(plate) then
		local trunkItems = GetOwnedVehicleItems(plate)
		if trunkItems[slot] ~= nil and trunkItems[slot].name == itemName then
			if trunkItems[slot].amount > amount then
				trunkItems[slot].amount = trunkItems[slot].amount - amount
			else
				trunkItems[slot] = nil
				if next(trunkItems) == nil then
					trunkItems = nil
				end
			end
		else
			trunkItems[slot ]= nil
			if trunkItems == nil then
				trunkItems[slot] = nil
			end
		end
		SaveOwnedVehicleItems(plate, trunkItems)
	else
		if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
			if Trunks[plate].items[slot].amount > amount then
				Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount - amount
			else
				Trunks[plate].items[slot] = nil
				if next(Trunks[plate].items) == nil then
					Trunks[plate].items = {}
				end
			end
		else
			Trunks[plate].items[slot]= nil
			if Trunks[plate].items == nil then
				Trunks[plate].items[slot] = nil
			end
		end
	end
end

-- Glovebox items
function GetOwnedVehicleGloveboxItems(plate)
	local items = {}
	QBCore.Functions.ExecuteSql("SELECT * FROM `gloveboxitems` WHERE `plate` = '"..plate.."'", function(result)
		if result[1] ~= nil then
			for k, item in pairs(result) do
				local itemInfo = QBCore.Shared.Items[item.name:lower()]
				items[item.slot] = {
					name = itemInfo["name"],
					amount = tonumber(item.amount),
					info = json.decode(item.info) ~= nil and json.decode(item.info) or "",
					label = itemInfo["label"],
					description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
					weight = itemInfo["weight"], 
					type = itemInfo["type"], 
					unique = itemInfo["unique"], 
					useable = itemInfo["useable"], 
					image = itemInfo["image"],
					slot = item.slot,
				}
			end
		end
	end)
	return items
end

function SaveOwnedVehicleGloveboxItems(plate, items)
	QBCore.Functions.ExecuteSql("DELETE FROM `gloveboxitems` WHERE `plate` = '"..plate.."'")
	if items ~= nil then
		for slot, item in pairs(items) do
			if items[slot] ~= nil then
				QBCore.Functions.ExecuteSql("INSERT INTO `gloveboxitems` (`plate`, `name`, `amount`, `info`, `type`, `slot`) VALUES ('"..plate.."', '"..items[slot].name.."', '"..items[slot].amount.."', '"..json.encode(items[slot].info).."', '"..items[slot].type.."', '"..slot.."')")
			end
		end
	end
end

function AddToGlovebox(plate, slot, itemName, amount, info)
	local amount = tonumber(amount)
	if IsVehicleOwned(plate) then
		local gloveItems = GetOwnedVehicleGloveboxItems(plate)
		if gloveItems[slot] ~= nil and gloveItems[slot].name == itemName then
			gloveItems[slot].amount = gloveItems[slot].amount + amount
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			gloveItems[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
		SaveOwnedVehicleGloveboxItems(plate, gloveItems)
	else
		if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
			Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount + amount
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	end
end

function RemoveFromGlovebox(plate, slot, itemName, amount)
	if IsVehicleOwned(plate) then
		local gloveItems = GetOwnedVehicleGloveboxItems(plate)
		if gloveItems[slot] ~= nil and gloveItems[slot].name == itemName then
			if gloveItems[slot].amount > amount then
				gloveItems[slot].amount = gloveItems[slot].amount - amount
			else
				gloveItems[slot] = nil
				if next(gloveItems) == nil then
					gloveItems = nil
				end
			end
		else
			gloveItems[slot ]= nil
			if gloveItems == nil then
				gloveItems[slot] = nil
			end
		end
		SaveOwnedVehicleGloveboxItems(plate, gloveItems)
	else
		if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
			if Gloveboxes[plate].items[slot].amount > amount then
				Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount - amount
			else
				Gloveboxes[plate].items[slot] = nil
				if next(Gloveboxes[plate].items) == nil then
					Gloveboxes[plate].items = {}
				end
			end
		else
			Gloveboxes[plate].items[slot]= nil
			if Gloveboxes[plate].items == nil then
				Gloveboxes[plate].items[slot] = nil
			end
		end
	end
end

-- Drop items
function AddToDrop(dropId, slot, itemName, amount, info)
	local amount = tonumber(amount)
	if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
		Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount + amount
	else
		local itemInfo = QBCore.Shared.Items[itemName:lower()]
		Drops[dropId].items[slot] = {
			name = itemInfo["name"],
			amount = amount,
			info = info ~= nil and info or "",
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = slot,
			id = dropId,
		}
	end
end

function RemoveFromDrop(dropId, slot, itemName, amount)
	if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
		if Drops[dropId].items[slot].amount > amount then
			Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount - amount
		else
			Drops[dropId].items[slot] = nil
			if next(Drops[dropId].items) == nil then
				Drops[dropId].items = {}
				--TriggerClientEvent("inventory:client:RemoveDropItem", -1, dropId)
			end
		end
	else
		Drops[dropId].items[slot] = nil
		if Drops[dropId].items == nil then
			Drops[dropId].items[slot] = nil
			--TriggerClientEvent("inventory:client:RemoveDropItem", -1, dropId)
		end
	end
end

function CreateDropId()
	if Drops ~= nil then
		local id = math.random(10000, 99999)
		local dropid = id
		while Drops[dropid] ~= nil do
			id = math.random(10000, 99999)
			dropid = id
		end
		return dropid
	else
		local id = math.random(10000, 99999)
		local dropid = id
		return dropid
	end
end

function CreateNewDrop(source, fromSlot, toSlot, itemAmount)
	local Player = QBCore.Functions.GetPlayer(source)
	local itemData = Player.Functions.GetItemBySlot(fromSlot)
	if Player.Functions.RemoveItem(itemData.name, itemAmount, itemData.slot) then
		local itemInfo = QBCore.Shared.Items[itemData.name:lower()]
		local dropId = CreateDropId()
		Drops[dropId] = {}
		Drops[dropId].items = {}

		Drops[dropId].items[toSlot] = {
			name = itemInfo["name"],
			amount = itemAmount,
			info = itemData.info ~= nil and itemData.info or "",
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = toSlot,
			id = dropId,
		}
		TriggerClientEvent("inventory:client:DropItemAnim", source)
		TriggerClientEvent("inventory:client:AddDropItem", -1, dropId, source)
	else
		TriggerClientEvent("QBCore:Notify", src, "Je hebt dit item niet!", "error")
		return
	end
end

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

QBCore.Commands.Add("kofferbak", "Laat kofferbak positie zien", {}, false, function(source, args)
	TriggerClientEvent("inventory:client:ShowTrunkPos", source)
end)

QBCore.Commands.Add("giveitem", "Geef een item aan een speler", {{name="id", help="Speler ID"},{name="item", help="Naam van het item (geen label)"}, {name="amount", help="Aantal items"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	local amount = tonumber(args[3])
	local itemData = QBCore.Shared.Items[tostring(args[2]):lower()]
	if Player ~= nil then
		if amount > 0 then
			if itemData ~= nil then
				-- check iteminfo
				local info = {}
				if itemData["name"] == "id_card" then
					info.citizenid = Player.PlayerData.citizenid
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.gender = Player.PlayerData.charinfo.gender
					info.nationality = Player.PlayerData.charinfo.nationality
				end

				if Player.Functions.AddItem(itemData["name"], amount, nil, info) then
					TriggerClientEvent('QBCore:Notify', source, "Je hebt " ..GetPlayerName(tonumber(args[1])).." " .. itemData["name"] .. " ("..amount.. ") gegeven", "success")
				else
					TriggerClientEvent('QBCore:Notify', source,  "Kan item niet geven!", "error")
				end
			else
				TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Item bestaat niet!")
			end
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Aantal moet hoger zijn dan 0!")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

QBCore.Functions.CreateUseableItem("id_card", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("inventory:client:ShowId", -1, source, Player.PlayerData.citizenid, item.info)
    end
end)