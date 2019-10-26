QBCore.Players = {}
QBCore.Player = {}

QBCore.Player.Login = function(source, newData, citizenid)
	if source ~= nil then
		if citizenid ~= nil then
			QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `citizenid` = '"..citizenid.."'", function(result)
				local PlayerData = result[1]
				if PlayerData ~= nil then
					PlayerData.money = json.decode(PlayerData.money)
					PlayerData.job = json.decode(PlayerData.job)
					PlayerData.gang = json.decode(PlayerData.gang)
					PlayerData.position = json.decode(PlayerData.position)
					PlayerData.charinfo = json.decode(PlayerData.charinfo)
				end
				QBCore.Player.CheckPlayerData(source, PlayerData)
			end)
		else
			QBCore.Player.CheckPlayerData(source, newData)
		end
		return true
	else
		QBCore.ShowError(GetCurrentResourceName(), "ERROR QBCORE.PLAYER.LOGIN - NO SOURCE GIVEN!")
		return false
	end
end

QBCore.Player.CheckPlayerData = function(source, PlayerData)
	PlayerData = PlayerData ~= nil and PlayerData or {}

	PlayerData.source = source
	PlayerData.citizenid = PlayerData.citizenid ~= nil and PlayerData.citizenid or QBCore.Player.CreateCitizenId()
	PlayerData.steam = PlayerData.steam ~= nil and PlayerData.steam or QBCore.Functions.GetIdentifier(source, "steam")
	PlayerData.license = PlayerData.license ~= nil and PlayerData.license or QBCore.Functions.GetIdentifier(source, "license")
	PlayerData.name = GetPlayerName(source)
	PlayerData.cid = PlayerData.cid ~= nil and PlayerData.cid or 1

	PlayerData.money = PlayerData.money ~= nil and PlayerData.money or {}
	for moneytype, startamount in pairs(QBCore.Config.Money.MoneyTypes) do
		PlayerData.money[moneytype] = PlayerData.money[moneytype] ~= nil and PlayerData.money[moneytype] or startamount
	end

	PlayerData.permission = PlayerData.permission ~= nil and PlayerData.permission or "user"

	PlayerData.charinfo = PlayerData.charinfo ~= nil and PlayerData.charinfo or {}
	PlayerData.charinfo.firstname = PlayerData.charinfo.firstname ~= nil and PlayerData.charinfo.firstname or "Firstname"
	PlayerData.charinfo.lastname = PlayerData.charinfo.lastname ~= nil and PlayerData.charinfo.lastname or "Lastname"
	PlayerData.charinfo.birthdate = PlayerData.charinfo.birthdate ~= nil and PlayerData.charinfo.birthdate or "00-00-0000"
	PlayerData.charinfo.gender = PlayerData.charinfo.gender ~= nil and PlayerData.charinfo.gender or 1
	PlayerData.charinfo.backstory = PlayerData.charinfo.backstory ~= nil and PlayerData.charinfo.backstory or "placeholder backstory"
	PlayerData.charinfo.nationality = PlayerData.charinfo.nationality ~= nil and PlayerData.charinfo.nationality or "Nederlands"
	PlayerData.charinfo.phone = PlayerData.charinfo.phone ~= nil and PlayerData.charinfo.phone or "06"..math.random(11111111, 99999999)
	PlayerData.charinfo.account = PlayerData.charinfo.account ~= nil and PlayerData.charinfo.account or "NL0"..math.random(1,9).."QBBA"..math.random(1111,9999)..math.random(1111,9999)..math.random(11,99)
	
	PlayerData.job = PlayerData.job ~= nil and PlayerData.job or {}
	PlayerData.job.name = PlayerData.job.name ~= nil and PlayerData.job.name or "unemployed"
	PlayerData.job.label = PlayerData.job.label ~= nil and PlayerData.job.label or "Werkloos"
	PlayerData.job.grade = PlayerData.job.grade ~= nil and PlayerData.job.grade or 1
	PlayerData.job.gradelabel = PlayerData.job.gradelabel ~= nil and PlayerData.job.gradelabel or "Uitkering"
	PlayerData.job.payment = PlayerData.job.payment ~= nil and PlayerData.job.payment or 10
	PlayerData.job.onduty = PlayerData.job.onduty ~= nil and PlayerData.job.onduty or false
	
	PlayerData.gang = PlayerData.gang ~= nil and PlayerData.gang or {}
	PlayerData.gang.name = PlayerData.gang.name ~= nil and PlayerData.gang.name or "nogang"
	PlayerData.gang.label = PlayerData.gang.label ~= nil and PlayerData.gang.label or "Geen gang"
	PlayerData.gang.grade = PlayerData.gang.grade ~= nil and PlayerData.gang.grade or 1
	PlayerData.gang.gradelabel = PlayerData.gang.gradelabel ~= nil and PlayerData.gang.gradelabel or "gang"

	PlayerData.position = PlayerData.position ~= nil and PlayerData.position or QBConfig.DefaultSpawn

	PlayerData.items = QBCore.Player.LoadInventory(PlayerData)
	QBCore.Player.CreatePlayer(PlayerData)
end

QBCore.Player.CreatePlayer = function(PlayerData)
	local self = {}
	self.Functions = {}
	self.PlayerData = PlayerData

	self.Functions.HasAcePermission = function(permission)
		if IsPlayerAceAllowed(self.PlayerData.source, tostring(permission):lower()) then
			return true
		else
			return false
		end
	end

	self.Functions.UpdatePlayerData = function()
		TriggerClientEvent("QBCore:Player:SetPlayerData", self.PlayerData.source, self.PlayerData)
		QBCore.Commands.Refresh(self.PlayerData.source)
	end

	self.Functions.SetPermission = function(permission)
		local permission = permission:lower()
		self.PlayerData.permission = permission
		self.UpdatePlayerData()
	end

	self.Functions.SetJob = function(job, grade)
		local job = job:lower()
		local grade = tonumber(grade)
		local JobInfo = QBCore.Player.GetJobInfo(job, grade)
		if JobInfo ~= nil then
			self.PlayerData.job.name = JobInfo.name
			self.PlayerData.job.label = JobInfo.label
			self.PlayerData.job.grade = JobInfo.grade
			self.PlayerData.job.gradelabel = JobInfo.gradelabel
			self.Functions.UpdatePlayerData()
		else
			-- Job does not exist
		end
	end

	self.Functions.SetGang = function(gang, grade)
		local gang = gang:lower()
		local grade = tonumber(grade)
		local GangInfo = QBCore.Player.GetGangInfo(gang, grade)
		if GangInfo ~= nil then
			self.PlayerData.gang.name = JobInfo.name
			self.PlayerData.gang.label = JobInfo.label
			self.PlayerData.gang.grade = JobInfo.grade
			self.PlayerData.gang.gradelabel = JobInfo.gradelabel
			self.Functions.UpdatePlayerData()
		else
			-- gang does not exist
		end
	end

	self.Functions.AddMoney = function(moneytype, amount)
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if self.PlayerData.money[moneytype] ~= nil then
			self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype]+amount
			self.Functions.UpdatePlayerData()
			TriggerClientEvent("hud:client:OnMoneyChange", self.PlayerData.source, moneytype, amount, false)
			return true
		end
		return false
	end

	self.Functions.RemoveMoney = function(moneytype, amount)
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if self.PlayerData.money[moneytype] ~= nil then
			for _, mtype in pairs(QBCore.Config.Money.DontAllowMinus) do
				if mtype == moneytype then
					if self.PlayerData.money[moneytype] - amount < 0 then return false end
				end
			end
			self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount
			self.Functions.UpdatePlayerData()
			TriggerClientEvent("hud:client:OnMoneyChange", self.PlayerData.source, moneytype, amount, false)
			return true
		end
		return false
	end

	self.Functions.SetMoney = function(moneytype, amount)
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if self.PlayerData.money[moneytype] ~= nil then
			self.PlayerData.money[moneytype] = amount
			self.Functions.UpdatePlayerData()
			return true
		end
		return false
	end

	self.Functions.AddItem = function(item, amount, slot, info)
		local totalWeight = QBCore.Player.GetTotalWeight(self.PlayerData.items)
		local itemInfo = QBCore.Shared.Items[item:lower()]
		if itemInfo == nil then TriggerClientEvent('chatMessage', -1, "SYSTEM",  "warning", "No item found??") return end
		local amount = tonumber(amount)
		local slot = tonumber(slot) ~= nil and tonumber(slot) or QBCore.Player.GetFirstSlotByItem(self.PlayerData.items, item)
		if (totalWeight + (itemInfo["weight"] * amount)) < QBCore.Config.Player.MaxWeight then
			if (slot ~= nil and self.PlayerData.items[slot] ~= nil) and (self.PlayerData.items[slot].name:lower() == item:lower()) and (itemInfo["type"] == "item") then
				self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount + amount
				self.Functions.UpdatePlayerData()
				--TriggerClientEvent('QBCore:Notify', self.PlayerData.source, itemInfo["label"].. " toegevoegd!", "success")
				return true
			elseif (slot ~= nil and self.PlayerData.items[slot] == nil) then
				self.PlayerData.items[slot] = {name = itemInfo["name"], amount = amount, info = info ~= nil and info or "", label = itemInfo["label"], description = itemInfo["description"] ~= nil and itemInfo["description"] or "", weight = itemInfo["weight"], type = itemInfo["type"], unique = itemInfo["unique"], useable = itemInfo["useable"], image = itemInfo["image"], slot = slot}
				self.Functions.UpdatePlayerData()
				--TriggerClientEvent('QBCore:Notify', self.PlayerData.source, itemInfo["label"].. " toegevoegd!", "success")
				return true
			elseif (slot == nil) or (itemInfo["type"] == "weapon") then
				for i = 1, QBConfig.Player.MaxInvSlots, 1 do
					if self.PlayerData.items[i] == nil then
						self.PlayerData.items[i] = {name = itemInfo["name"], amount = amount, info = info ~= nil and info or "", label = itemInfo["label"], description = itemInfo["description"] ~= nil and itemInfo["description"] or "", weight = itemInfo["weight"], type = itemInfo["type"], unique = itemInfo["unique"], useable = itemInfo["useable"], image = itemInfo["image"], slot = i}
						self.Functions.UpdatePlayerData()
						--TriggerClientEvent('QBCore:Notify', self.PlayerData.source, itemInfo["label"].. " toegevoegd!", "success")
						return true
					end
				end
			end
		end
		return false
	end

	self.Functions.RemoveItem = function(item, amount, slot)
		local itemInfo = QBCore.Shared.Items[item:lower()]
		local amount = tonumber(amount)
		local slot = tonumber(slot)
		if slot ~= nil then
			if self.PlayerData.items[slot].amount > amount then
				self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amount
				self.Functions.UpdatePlayerData()
				--TriggerClientEvent('QBCore:Notify', self.PlayerData.source, itemInfo["label"].. " verwijderd!", "error")
				return true
			else
				self.PlayerData.items[slot] = nil
				self.Functions.UpdatePlayerData()
				--TriggerClientEvent('QBCore:Notify', self.PlayerData.source, itemInfo["label"].. " verwijderd!", "error")
				return true
			end
		else
			local slots = QBCore.Player.GetSlotsByItem(self.PlayerData.items, item)
			local amountToRemove = amount
			if slots ~= nil then
				for _, slot in pairs(slots) do
					if self.PlayerData.items[slot].amount > amountToRemove then
						self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amountToRemove
						self.Functions.UpdatePlayerData()
						--TriggerClientEvent('QBCore:Notify', self.PlayerData.source, itemInfo["label"].. " verwijderd!", "error")
						return true
					elseif self.PlayerData.items[slot].amount == amountToRemove then
						self.PlayerData.items[slot] = nil
						self.Functions.UpdatePlayerData()
						--TriggerClientEvent('QBCore:Notify', self.PlayerData.source, itemInfo["label"].. " verwijderd!", "error")
						return true
					end
				end
			end
		end
		return false
	end

	self.Functions.GetItemByName = function(item)
		local item = tostring(item):lower()
		local slot = QBCore.Player.GetFirstSlotByItem(self.PlayerData.items, item)
		if slot ~= nil then
			return self.PlayerData.items[slot]
		end
		return nil
	end

	self.Functions.GetItemBySlot = function(slot)
		local slot = tonumber(slot)
		if self.PlayerData.items[slot] ~= nil then
			return self.PlayerData.items[slot]
		end
		return nil
	end

	self.Functions.GetItemBySlot = function(slot)
		local slot = tonumber(slot)
		if self.PlayerData.items[slot] ~= nil then
			return self.PlayerData.items[slot]
		end
		return nil
	end

	self.Functions.Save = function()
		QBCore.Player.Save(self.PlayerData.source)
	end
	
	QBCore.Players[self.PlayerData.source] = self
	QBCore.Player.Save(self.PlayerData.source)
	self.Functions.UpdatePlayerData()
end

QBCore.Player.Save = function(source)
	local PlayerData = QBCore.Players[source].PlayerData
	if PlayerData ~= nil then
		QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `citizenid` = '"..PlayerData.citizenid.."'", function(result)
			if result[1] == nil then
				QBCore.Functions.ExecuteSql("INSERT INTO `players` (`citizenid`, `cid`, `steam`, `license`, `name`, `money`, `permission`, `charinfo`, `job`, `gang`, `position`) VALUES ('"..PlayerData.citizenid.."', '"..tonumber(PlayerData.cid).."', '"..PlayerData.steam.."', '"..PlayerData.license.."', '"..PlayerData.name.."', '"..json.encode(PlayerData.money).."', '"..PlayerData.permission.."', '"..json.encode(PlayerData.charinfo).."', '"..json.encode(PlayerData.job).."', '"..json.encode(PlayerData.gang).."', '"..json.encode(PlayerData.position).."')")
			else
				QBCore.Functions.ExecuteSql("UPDATE `players` SET steam='"..PlayerData.steam.."',license='"..PlayerData.license.."',name='"..PlayerData.name.."',money='"..json.encode(PlayerData.money).."',permission='"..PlayerData.permission.."',charinfo='"..json.encode(PlayerData.charinfo).."',job='"..json.encode(PlayerData.job).."',gang='"..json.encode(PlayerData.gang).."',position='"..json.encode(PlayerData.position).."' WHERE `citizenid` = '"..PlayerData.citizenid.."'")
			end			
			QBCore.Player.SaveInventory(PlayerData)
	    end)
		QBCore.ShowSuccess(GetCurrentResourceName(), PlayerData.name .." PLAYER SAVED!")
	else
		QBCore.ShowError(GetCurrentResourceName(), "ERROR QBCORE.PLAYER.SAVE - PLAYERDATA IS EMPTY!")
	end
end

QBCore.Player.DeleteCharacter = function(source, citizenid)
	QBCore.Functions.ExecuteSql("DELETE FROM `players` WHERE `citizenid` = '"..citizenid.."'")
end

QBCore.Player.LoadInventory = function(PlayerData)
	local inventory = {}
	QBCore.Functions.ExecuteSql("SELECT * FROM `playeritems` WHERE `citizenid` = '"..PlayerData.citizenid.."'", function(result)
		if result ~= nil then
			for _, item in pairs(result) do
				local itemInfo = QBCore.Shared.Items[item.name:lower()]
				inventory[item.slot] = {name = itemInfo["name"], amount = item.amount, info = item.info ~= nil and item.info or "", label = itemInfo["label"], description = itemInfo["description"] ~= nil and itemInfo["description"] or "", weight = itemInfo["weight"], type = itemInfo["type"], unique = itemInfo["unique"], useable = itemInfo["useable"], image = itemInfo["image"], slot = item.slot}
			end
		end
	end)
	return inventory
end

QBCore.Player.SaveInventory = function(PlayerData)
	QBCore.Functions.ExecuteSql("DELETE FROM `playeritems` WHERE `citizenid` = '"..PlayerData.citizenid.."'")
	if PlayerData.items ~= nil then
		for slot, item in pairs(PlayerData.items) do
			if PlayerData.items[slot] ~= nil then
				QBCore.Functions.ExecuteSql("INSERT INTO `playeritems` (`citizenid`, `name`, `amount`, `info`, `type`, `slot`) VALUES ('"..PlayerData.citizenid.."', '"..PlayerData.items[slot].name.."', '"..PlayerData.items[slot].amount.."', '"..PlayerData.items[slot].info.."', '"..PlayerData.items[slot].type.."', '"..slot.."')")
			end
		end
	end
end

QBCore.Player.GetTotalWeight = function(items)
	local weight = 0
	if items ~= nil then
		for slot, item in pairs(items) do
			weight = weight + (item.weight * item.amount)
		end
	end
	return tonumber(weight)
end

QBCore.Player.GetSlotsByItem = function(items, itemName)
	local slotsFound = {}
	if items ~= nil then
		for slot, item in pairs(items) do
			if item.name:lower() == itemName:lower() then
				table.insert(slotsFound, slot)
			end
		end
	end
	return slotsFound
end

QBCore.Player.GetFirstSlotByItem = function(items, itemName)
	if items ~= nil then
		for slot, item in pairs(items) do
			if item.name:lower() == itemName:lower() then
				return tonumber(slot)
			end
		end
	end
	return nil
end

QBCore.Player.CreateCitizenId = function()
	local UniqueFound = false
	local CitizenId = nil

	while not UniqueFound do
		CitizenId = tostring(QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(5)):upper()
		QBCore.Functions.ExecuteSql("SELECT COUNT(*) as count FROM `players` WHERE `citizenid` = '"..CitizenId.."'", function(result)
			if result[1].count == 0 then
				UniqueFound = true
			end
		end)
	end
	return CitizenId
end

QBCore.Player.GetJobInfo = function(job, grade)
	local job = job:lower()
	local grade = tonumber(grade)
	local JobInfo = {}
	QBCore.Functions.ExecuteSql("SELECT * FROM `jobs`", function(result)
		for _, info in pairs(result) do
			if tostring(info.name) == tostring(job) then
				for _, gradeinfo in pairs(info.grades) do
					JobInfo.name = info.name
					JobInfo.label = info.label
					JobInfo.grade = gradeinfo.grade
					JobInfo.gradelabel = gradeinfo.gradelabel
					JobInfo.payment = info.payment
					JobInfo.onduty = false
				end
			end
		end
	end)
	return JobInfo
end

QBCore.Player.GetGangInfo = function(gang, grade)
	local gang = gang:lower()
	local grade = tonumber(grade)
	local GangInfo = {}
	QBCore.Functions.ExecuteSql("SELECT * FROM `gangs`", function(result)
		for _, info in pairs(result) do
			if tostring(info.name) == tostring(gang) then
				for _, gradeinfo in pairs(info.grades) do
					GangInfo.name = info.name
					GangInfo.label = info.label
					GangInfo.grade = gradeinfo.grade
					GangInfo.gradelabel = gradeinfo.gradelabel
				end
			end
		end
	end)
	return GangInfo
end