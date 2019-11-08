QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local Plates = {}
cuffedPlayers = {}

PlayerStatus = {}

RegisterServerEvent('police:server:CuffPlayer')
AddEventHandler('police:server:CuffPlayer', function(playerId, isSoftcuff)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local CuffedPlayer = QBCore.Functions.GetPlayer(playerId)
    if CuffedPlayer ~= nil then
        if Player.Functions.GetItemByName("handcuffs") ~= nil or Player.PlayerData.job.name == "police" then
            if not CuffedPlayer.PlayerData.metadata["ishandcuffed"] then
                TriggerClientEvent("police:client:GetCuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source, isSoftcuff)
                table.insert(cuffedPlayers, {
                    target = CuffedPlayer.PlayerData.citizenid,
                    cuffer = Player.PlayerData.citizenid
                })
            else
                for k, v in pairs(cuffedPlayers) do
                    if cuffedPlayers[k].target == CuffedPlayer.PlayerData.citizenid and cuffedPlayers[k].cuffer == Player.PlayerData.citizenid then
                        TriggerClientEvent("police:client:GetCuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source, isSoftcuff)
                        cuffedPlayers[k] = nil
                    elseif Player.PlayerData.job.name == "police" then
                        TriggerClientEvent("police:client:GetCuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source, isSoftcuff)
                        cuffedPlayers[k] = nil
                    else
                        TriggerClientEvent('QBCore:Notify', src, 'Je hebt geen sleutels van de handboeien..', 'error', 3500)
                    end
                end
            end
        end
    end
end)

RegisterServerEvent('police:server:EscortPlayer')
AddEventHandler('police:server:EscortPlayer', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("police:client:GetEscorted", EscortPlayer.PlayerData.source, Player.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('police:server:SetPlayerOutVehicle')
AddEventHandler('police:server:SetPlayerOutVehicle', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("police:client:SetOutVehicle", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('police:server:PutPlayerInVehicle')
AddEventHandler('police:server:PutPlayerInVehicle', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("police:client:PutInVehicle", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('police:server:SetHandcuffStatus')
AddEventHandler('police:server:SetHandcuffStatus', function(isHandcuffed)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.Functions.SetMetaData("ishandcuffed", isHandcuffed)
	end
end)

RegisterServerEvent('heli:spotlight')
AddEventHandler('heli:spotlight', function(state)
	local serverID = source
	TriggerClientEvent('heli:spotlight', -1, serverID, state)
end)

RegisterServerEvent('police:server:FlaggedPlateTriggered')
AddEventHandler('police:server:FlaggedPlateTriggered', function(camId, plate, street1, street2, blipSettings)
    local src = source
    local players = QBCore.Functions.GetPlayers()

	for k, Player in pairs(players) do
		if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
			if street2 ~= nil then
				TriggerClientEvent("112:client:SendPoliceAlert", k, "flagged", "Flitser #"..camId.." - Gemarkeerd voertuig ("..plate..") gesignaleerd bij ".. street1 .. " | " .. street2, blipSettings)
			else
				TriggerClientEvent("112:client:SendPoliceAlert", k, "flagged", "Flitser #"..camId.." - Gemarkeerd voertuig ("..plate..") gesignaleerd bij ".. street1, blipSettings)
			end
		end
	end
end)

RegisterServerEvent('police:server:Impound')
AddEventHandler('police:server:Impound', function(plate, fullImpound, price)
    local src = source
    local price = price ~= nil and price or 0
    if IsVehicleOwned(plate) then
        if not fullImpound then
            exports['ghmattimysql']:execute('UPDATE player_vehicles SET state = @state, depotprice = @depotprice WHERE plate = @plate', {['@state'] = 0, ['@depotprice'] = price, ['@plate'] = plate})
            TriggerClientEvent('QBCore:Notify', src, "Voertuig opgenomen in depot voor €"..price.."!")
        else
            exports['ghmattimysql']:execute('UPDATE player_vehicles SET state = @state WHERE plate = @plate', {['@state'] = 2, ['@plate'] = plate})
            TriggerClientEvent('QBCore:Notify', src, "Voertuig volledig in beslag genomen!")
        end
    end
end)

RegisterServerEvent('evidence:server:UpdateStatus')
AddEventHandler('evidence:server:UpdateStatus', function(data)
    local src = source
    PlayerStatus[src] = data
end)

QBCore.Functions.CreateCallback('police:GetPlayerStatus', function(source, cb, playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    local statList = {}
	if Player ~= nil then
        if PlayerStatus[Player.PlayerData.source] ~= nil and next(PlayerStatus[Player.PlayerData.source]) ~= nil then
            for k, v in pairs(PlayerStatus[Player.PlayerData.source]) do
                table.insert(statList, PlayerStatus[Player.PlayerData.source][k].text)
            end
        end
	end
    cb(statList)
end)

function IsVehicleOwned(plate)
    local val = false
	QBCore.Functions.ExecuteSql("SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
		if (result[1] ~= nil) then
			val = true
		else
			val = false
		end
	end)
	return val
end

QBCore.Functions.CreateCallback('police:GetImpoundedVehicles', function(source, cb)
    local vehicles = {}
    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE state = @state', {['@state'] = 2}, function(result)
        if result[1] ~= nil then
            vehicles = result
        end
        cb(vehicles)
    end)
end)

QBCore.Functions.CreateCallback('police:IsPlateFlagged', function(source, cb, plate)
    local retval = false
    if Plates ~= nil and Plates[plate] ~= nil then
        if Plates[plate].isflagged then
            retval = true
        end
    end
    cb(retval)
end)

QBCore.Commands.Add("cuff", "Boei een speler", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:CuffPlayer", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("sc", "Boei iemand maar laat hem wel lopen", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:CuffPlayerSoft", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("cam", "Bekijk beveiligings camera", {{name="camid", help="Camera ID"}}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:ActiveCamera", source, tonumber(args[1]))
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("flagplate", "Markeer een voertuig", {{name="plate", help="Kenteken"}, {name="reden", help="Reden voor markeren"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if Player.PlayerData.job.name == "police" then
        local reason = {}
        for i = 2, #args, 1 do
            table.insert(reason, args[i])
        end
        Plates[args[1]:upper()] = {
            isflagged = true,
            reason = table.concat(reason, " ")
        }
        TriggerClientEvent('QBCore:Notify', source, "Voertuig ("..args[1]:upper()..") is gemarkeerd voor: "..table.concat(reason, " "))
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("unflagplate", "Zet een voertuig ongemarkeerd", {{name="plate", help="Kenteken"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        if Plates ~= nil and Plates[args[1]:upper()] ~= nil then
            if Plates[args[1]:upper()].isflagged then
                Plates[args[1]:upper()].isflagged = false
                TriggerClientEvent('QBCore:Notify', source, "Voertuig ("..args[1]:upper()..") is niet meer gemarkeerd")
            else
                TriggerClientEvent('chatMessage', source, "MELDKAMER", "error", "Voertuig is niet gemarkeerd!")
            end
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Voertuig is niet gemarkeerd!")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("plateinfo", "Markeer een voertuig", {{name="plate", help="Kenteken"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        if Plates ~= nil and Plates[args[1]:upper()] ~= nil then
            if Plates[args[1]:upper()].isflagged then
                TriggerClientEvent('chatMessage', source, "MELDKAMER", "normal", "Voertuig ("..args[1]:upper()..") is gemarkeerd voor: "..Plates[args[1]:upper()].reason)
            else
                TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Voertuig is niet gemarkeerd!")
            end
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Voertuig is niet gemarkeerd!")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("depot", "Stuur een voertuig naar het depot", {{name="prijs", help="Prijs voor hoeveel degene moet betalen (mag leeg zijn)"}}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:ImpoundVehicle", source, false, tonumber(args[1]))
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("beslag", "Neem een voertuig in beslag", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:ImpoundVehicle", source, true)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("radar", "Toggle snelheidsradar :)", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("wk:toggleRadar", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Functions.CreateUseableItem("handcuffs", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("police:client:CuffPlayer", source)
    end
end)