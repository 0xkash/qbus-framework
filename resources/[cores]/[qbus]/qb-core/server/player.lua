QBCore.Players = {}
QBCore.Player = {}

QBCore.Player.Login = function(source)
	if source ~= nil then
		QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `"..QBCore.Config.IdentifierType.."` = '".. QBCore.Functions.GetIdentifier(source).."'", function(result)
			local PlayerData = result[1]
			if PlayerData ~= nil then
				PlayerData.money = json.decode(PlayerData.money)
			end
			QBCore.Player.CheckPlayerData(source, PlayerData)
			--TriggerClientEvent('QBCore:OnPlayerLoaded', source)
			return true
		end)
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

	PlayerData.money = PlayerData.money ~= nil and PlayerData.money or {}
	for moneytype, startamount in pairs(QBCore.Config.Money.MoneyTypes) do
		PlayerData.money[moneytype] = PlayerData.money[moneytype] ~= nil and PlayerData.money[moneytype] or startamount
	end

	PlayerData.permission = PlayerData.permission ~= nil and PlayerData.permission or "user"
	
	PlayerData.job = PlayerData.job ~= nil and PlayerData.job or {}
	PlayerData.job.name = PlayerData.job.name ~= nil and PlayerData.job.name or "unemployed"
	PlayerData.job.label = PlayerData.job.label ~= nil and PlayerData.job.label or "Werkloos"
	PlayerData.job.grade = PlayerData.job.grade ~= nil and PlayerData.job.grade or 1
	PlayerData.job.gradelabel = PlayerData.job.gradelabel ~= nil and PlayerData.job.gradelabel or "Uitkering"
	
	PlayerData.gang = PlayerData.gang ~= nil and PlayerData.gang or {}
	PlayerData.gang.name = PlayerData.gang.name ~= nil and PlayerData.gang.name or "nogang"
	PlayerData.gang.label = PlayerData.gang.label ~= nil and PlayerData.gang.label or "Geen gang"
	PlayerData.gang.grade = PlayerData.gang.grade ~= nil and PlayerData.gang.grade or 1
	PlayerData.gang.gradelabel = PlayerData.gang.gradelabel ~= nil and PlayerData.gang.gradelabel or "gang"

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
	end

	self.Functions.UpdatePlayerData()
	QBCore.Players[self.PlayerData.source] = self
	QBCore.Player.Save(self.PlayerData.source)
end

QBCore.Player.Save = function(source)
	local PlayerData = QBCore.Players[source].PlayerData
	if PlayerData ~= nil then
		QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `"..QBCore.Config.IdentifierType.."` = '".. QBCore.Functions.GetIdentifier(source).."'", function(result)
			if result[1] == nil then
				QBCore.Functions.ExecuteSql("INSERT INTO `players` (`citizenid`, `steam`, `license`, `name`, `money`, `permission`, `job`, `gang`) VALUES ('"..PlayerData.citizenid.."', '"..PlayerData.steam.."', '"..PlayerData.license.."', '"..PlayerData.name.."', '"..json.encode(PlayerData.money).."', '"..PlayerData.permission.."', '"..json.encode(PlayerData.job).."', '"..json.encode(PlayerData.gang).."')")
			else
				QBCore.Functions.ExecuteSql("UPDATE `players` SET citizenid='"..PlayerData.citizenid.."',steam='"..PlayerData.steam.."',license='"..PlayerData.license.."',name='"..PlayerData.name.."',money='"..json.encode(PlayerData.money).."',permission='"..PlayerData.permission.."',job='"..json.encode(PlayerData.job).."',gang='"..json.encode(PlayerData.gang).."' WHERE `"..QBCore.Config.IdentifierType.."` = '".. QBCore.Functions.GetIdentifier(source).."'")
			end
	    end)
		QBCore.ShowSuccess(GetCurrentResourceName(), PlayerData.name .." SAVED!")
	else
		QBCore.ShowError(GetCurrentResourceName(), "ERROR QBCORE.PLAYER.SAVE - PLAYERDATA IS EMPTY!")
	end
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