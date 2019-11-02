QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('apartments:server:CreateApartment')
AddEventHandler('apartments:server:CreateApartment', function(type)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local apartmentId = CreateApartmentId(type)
    QBCore.Functions.ExecuteSql("INSERT INTO `apartments` (`name`, `type`, `citizenid`) VALUES ('"..apartmentId.."', '"..type.."', '"..Player.PlayerData.citizenid.."')")

    TriggerClientEvent('QBCore:Notify', src, "Je hebt een appartementje!", "success")
    TriggerClientEvent("apartments:client:SpawnInApartment", src, apartmentId, type)
    TriggerClientEvent("apartments:client:SetHomeBlip", src, type)
end)

RegisterServerEvent('apartments:server:UpdateApartment')
AddEventHandler('apartments:server:UpdateApartment', function(type)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql("UPDATE `apartments` SET type='"..type.."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")

    TriggerClientEvent('QBCore:Notify', src, "Je bent van appartement veranderd!")
    TriggerClientEvent("apartments:client:SetHomeBlip", src, type)
end)

RegisterServerEvent('apartments:server:RingDoor')
AddEventHandler('apartments:server:RingDoor', function(target)
    local src = source
    local OtherPlayer = QBCore.Functions.GetPlayer(target)
    if OtherPlayer ~= nil then
        TriggerClientEvent('apartments:client:RingDoor', OtherPlayer.PlayerData.source, src)
    end
end)

RegisterServerEvent('apartments:server:OpenDoor')
AddEventHandler('apartments:server:OpenDoor', function(target, apartmentId, apartment)
    print(target)
    local src = source
    local OtherPlayer = QBCore.Functions.GetPlayer(target)
    if OtherPlayer ~= nil then
        print(apartmentId)
        TriggerClientEvent('apartments:client:SpawnInApartment', OtherPlayer.PlayerData.source, apartmentId, apartment)
        TriggerClientEvent('QBCore:Notify', src, "Hij is binnen!", "success")
    end
end)

function CreateApartmentId(type)
    local UniqueFound = false
	local AparmentId = nil

	while not UniqueFound do
		AparmentId = tostring(type .. tostring(math.random(10000, 99999)))
		QBCore.Functions.ExecuteSql("SELECT COUNT(*) as count FROM `apartments` WHERE `name` = '"..AparmentId.."'", function(result)
			if result[1].count == 0 then
				UniqueFound = true
			end
		end)
	end
	return AparmentId
end

function GetOwnedApartment(citizenid)
    QBCore.Functions.ExecuteSql("SELECT * FROM `apartments` WHERE `citizenid` = '"..citizenid.."' ", function(result)
        if result[1] ~= nil then 
            return result[1]
        end
        return nil
    end)
    return nil
end

QBCore.Functions.CreateCallback('apartments:GetOwnedApartment', function(source, cb)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql("SELECT * FROM `apartments` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' ", function(result)
        if result[1] ~= nil then 
            return cb(result[1])
        end
        return cb(nil)
    end)
    return cb(nil)
end)

QBCore.Functions.CreateCallback('apartments:IsOwner', function(source, cb, apartment)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql("SELECT * FROM `apartments` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' ", function(result)
        if result[1] ~= nil then 
            if result[1].type == apartment then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)


QBCore.Functions.CreateCallback('apartments:GetOutfits', function(source, cb)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if Player then
        QBCore.Functions.ExecuteSql("SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
			if result[1] ~= nil then
				cb(result)
			else
				cb(nil)
			end
		end)
	end
end)