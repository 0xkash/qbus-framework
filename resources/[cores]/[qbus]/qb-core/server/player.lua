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
	for moneytype, startamount in pairs(QBCore.Config.MoneyTypes) do
		PlayerData.money[moneytype] = PlayerData.money[moneytype] ~= nil and PlayerData.money[moneytype] or startamount
	end

	QBCore.Player.CreatePlayer(PlayerData)
end

QBCore.Player.CreatePlayer = function(PlayerData)
	local self = {}
	self.Functions = {}
	self.PlayerData = PlayerData

	self.Functions.UpdatePlayerData = function()
		--TriggerClientEvent('QBCore:OnPlayerDataUpdate', -1, self.PlayerData)
	end

	QBCore.Debug(GetCurrentResourceName(), self.PlayerData.money["cash"])

	QBCore.Players[self.PlayerData.source] = self
	QBCore.Player.Save(self.PlayerData.source)
end

QBCore.Player.Save = function(source)
	local PlayerData = QBCore.Players[source].PlayerData
	if PlayerData ~= nil then
		QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `"..QBCore.Config.IdentifierType.."` = '".. QBCore.Functions.GetIdentifier(source).."'", function(result)
			if result[1] == nil then
				QBCore.Functions.ExecuteSql("INSERT INTO `players` (`citizenid`, `steam`, `license`, `name`, `money`) VALUES ('"..PlayerData.citizenid.."', '"..PlayerData.steam.."', '"..PlayerData.license.."', '"..PlayerData.name.."', '"..json.encode(PlayerData.money).."')")
			else
				QBCore.Functions.ExecuteSql("UPDATE `players` SET citizenid='"..PlayerData.citizenid.."',steam='"..PlayerData.steam.."',license='"..PlayerData.license.."',name='"..PlayerData.name.."',money='"..json.encode(PlayerData.money).."' WHERE `"..QBCore.Config.IdentifierType.."` = '".. QBCore.Functions.GetIdentifier(source).."'")
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