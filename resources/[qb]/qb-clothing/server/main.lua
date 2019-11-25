QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Commands.Add("skin", "Ooohja toch", {}, false, function(source, args)
	TriggerClientEvent("qb-clothing:client:openMenu", source)
end)

RegisterServerEvent("qb-clothing:saveSkin")
AddEventHandler('qb-clothing:saveSkin', function(model, skin)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	print(skin)

    if model ~= nil and skin ~= nil then 
		QBCore.Functions.ExecuteSql("DELETE FROM `playerskins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
        Citizen.Wait(500)
        QBCore.Functions.ExecuteSql("INSERT INTO `playerskins` (`citizenid`, `model`, `skin`, `active`) VALUES ('"..Player.PlayerData.citizenid.."', '"..model.."', '"..skin.."', 1)")
    end
end)

RegisterServerEvent("qb-clothes:loadPlayerSkin")
AddEventHandler('qb-clothes:loadPlayerSkin', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql("SELECT * FROM `playerskins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `active` = 1", function(result)
        if result[1] ~= nil then
            TriggerClientEvent("qb-clothes:loadSkin", src, false, result[1].model, result[1].skin)
        else
            TriggerClientEvent("qb-clothes:loadSkin", src, true)
        end
    end)
end)