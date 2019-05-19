QBCore.Players = {}
QBCore.Player = {}

QBCore.Player.Login = function(source)
	if source ~= nil then
		QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `"..QBConfig.IdentifierType.."` = '".. QBCore.Functions.GetIdentifier(source).."'", function(result)
			QBCore.Player.CheckPlayerData(source, result[1])
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
	PlayerData.steam = PlayerData.steam ~= nil and PlayerData.steam or QBCore.Functions.GetIdentifier(source, "steam")
	PlayerData.license = PlayerData.license ~= nil and PlayerData.license or QBCore.Functions.GetIdentifier(source, "license")
	PlayerData.name = GetPlayerName(source)
end

QBCore.Player.CreatePlayer = function(PlayerData)
	local self = {}
	self.Functions = {}
	self.PlayerData = PlayerData

	self.Functions.UpdatePlayerData = function()
		TriggerClientEvent('QBCore:OnPlayerDataUpdate', self.PlayerData.source)
	end

	QBCore.Players[self.PlayerData.source] = self
end

QBCore.Player.Save = function(source)
	local PlayerData = QBCore.Players[source].PlayerData
	if PlayerData ~= nil then
		if(QBCore.Functions.ExecuteSql("SELECT * FROM `players` WHERE `"..QBConfig.IdentifierType.."` = '".. QBCore.Functions.GetIdentifier(source).."'")[1] == nil) then
			QBCore.Functions.ExecuteSql("INSERT INTO `players` (`steamid`, `license`, `name`) VALUES ('"..PlayerData.steam.."', '"..PlayerData.license.."', '"..PlayerData.name.."')")
		else
			PTCore.Functions.ExecuteAsyncsyncSql("UPDATE `players` SET steam='"..PlayerData.steam.."',license='"..PlayerData.license.."',name='"..PlayerData.name.."' WHERE `"..QBConfig.IdentifierType.."` = '".. QBCore.Functions.GetIdentifier(source).."';")
		end
		QBCore.ShowSuccess(GetCurrentResourceName(), PlayerData.name .." SAVED!")
	else
		QBCore.ShowError(GetCurrentResourceName(), "ERROR QBCORE.PLAYER.SAVE - PLAYERDATA IS EMPTY!")
	end
end