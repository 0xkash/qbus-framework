QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local Plates = {}
cuffedPlayers = {}
PlayerStatus = {}
Casings = {}
BloodDrops = {}
FingerDrops = {}
local Objects = {}

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

RegisterServerEvent('police:server:BillPlayer')
AddEventHandler('police:server:BillPlayer', function(playerId, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "police" then
        if OtherPlayer ~= nil then
            OtherPlayer.Functions.RemoveMoney("bank", price)
            TriggerClientEvent('QBCore:Notify', OtherPlayer.PlayerData.source, "Je hebt een boete ontvangen van €"..price)
        end
    end
end)

RegisterServerEvent('police:server:JailPlayer')
AddEventHandler('police:server:JailPlayer', function(playerId, time)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    local currentDate = os.date("*t")
    if currentDate.day == 31 then currentDate.day = 30 end

    if Player.PlayerData.job.name == "police" then
        if OtherPlayer ~= nil then
            OtherPlayer.Functions.SetMetaData("injail", time)
            OtherPlayer.Functions.SetMetaData("criminalrecord", {
                ["hasRecord"] = true,
                ["date"] = currentDate
            })
            TriggerClientEvent("police:client:SendToJail", OtherPlayer.PlayerData.source, time)
            TriggerClientEvent('QBCore:Notify', src, "Je hebt de persoon naar de gevangenis gestuurd voor "..time.." maanden")
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

RegisterServerEvent('police:server:PoliceAlertMessage')
AddEventHandler('police:server:PoliceAlertMessage', function(msg, coords)
    local src = source
    local players = QBCore.Functions.GetPlayers()

	for k, Player in pairs(players) do
		if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
            TriggerClientEvent("police:client:PoliceAlertMessage", k, msg, coords)
        elseif Player.Functions.GetItemByName("radioscanner") ~= nil and math.random(1, 100) <= 50 then
            TriggerClientEvent("police:client:PoliceAlertMessage", k, msg, coords)
		end
    end
end)

RegisterServerEvent('police:server:GunshotAlert')
AddEventHandler('police:server:GunshotAlert', function(streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
    local src = source
    local players = QBCore.Functions.GetPlayers()

	for k, Player in pairs(players) do
		if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
            TriggerClientEvent("police:client:GunShotAlert", k, streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
        elseif Player.Functions.GetItemByName("radioscanner") ~= nil and math.random(1, 100) <= 50 then
            TriggerClientEvent("police:client:GunShotAlert", k, streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
		end
    end
end)

RegisterServerEvent('police:server:VehicleCall')
AddEventHandler('police:server:VehicleCall', function(coords, msg)
    local src = source
    local players = QBCore.Functions.GetPlayers()
    local alertData = {
        title = "Voertuigdiefstal",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
	for k, Player in pairs(players) do
        if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
            TriggerClientEvent("police:client:VehicleCall", k, coords, msg)
            TriggerClientEvent("qb-phone:client:addPoliceAlert", k, alertData)
		end
    end
end)

RegisterServerEvent('police:server:HouseRobberyCall')
AddEventHandler('police:server:HouseRobberyCall', function(coords, message)
    local src = source
    local players = QBCore.Functions.GetPlayers()
    local alertData = {
        title = "Huisinbraak",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = message,
    }
	for k, Player in pairs(players) do
		if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
            TriggerClientEvent("police:client:HouseRobberyCall", k, coords, message)
            TriggerClientEvent("qb-phone:client:addPoliceAlert", k, alertData)
		end
    end
end)

RegisterServerEvent('police:server:SendEmergencyMessage')
AddEventHandler('police:server:SendEmergencyMessage', function(coords, message)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local players = QBCore.Functions.GetPlayers()
    local alertData = {
        title = "112 Melding - "..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. " ("..src..")",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = message,
    }
	for k, Player in pairs(players) do
		if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
            TriggerClientEvent('chatMessage', k, Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. " ("..src..")", "warning", message)
            TriggerClientEvent("qb-phone:client:addPoliceAlert", k, alertData)
            TriggerClientEvent("police:client:EmergencySound", k)
		end
    end
end)

RegisterServerEvent('police:server:SearchPlayer')
AddEventHandler('police:server:SearchPlayer', function(playerId)
    local src = source
    local SearchedPlayer = QBCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Persoon heeft €"..SearchedPlayer.PlayerData.money["cash"]..",- op zak..")
        TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, "Je wordt gefouilleerd..")
    end
end)

RegisterServerEvent('police:server:RobPlayer')
AddEventHandler('police:server:RobPlayer', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local SearchedPlayer = QBCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        local money = SearchedPlayer.PlayerData.money["cash"]
        Player.Functions.AddMoney("cash", money)
        SearchedPlayer.Functions.RemoveMoney("cash", money)
        TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, "Je bent van €"..money.." beroofd")
    end
end)

RegisterServerEvent('police:server:UpdateBlips')
AddEventHandler('police:server:UpdateBlips', function()
    local src = source
    TriggerClientEvent("police:client:UpdateBlips", -1)
end)

RegisterServerEvent('police:server:spawnObject')
AddEventHandler('police:server:spawnObject', function(object)
    local src = source
    local objectId = CreateObjectId()
    Objects[objectId] = object
    TriggerClientEvent("police:client:spawnObject", -1, objectId, object, src)
end)

RegisterServerEvent('police:server:deleteObject')
AddEventHandler('police:server:deleteObject', function(objectId)
    local src = source
    TriggerClientEvent('police:client:removeObject', -1, objectId)
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

RegisterServerEvent('evidence:server:CreateBloodDrop')
AddEventHandler('evidence:server:CreateBloodDrop', function(citizenid, bloodtype, coords)
    local src = source
    local bloodId = CreateBloodId()
    BloodDrops[bloodId] = {dna = citizenid, bloodtype = bloodtype}
    TriggerClientEvent("evidence:client:AddBlooddrop", -1, bloodId, citizenid, bloodtype, coords)
end)

RegisterServerEvent('evidence:server:CreateFingerDrop')
AddEventHandler('evidence:server:CreateFingerDrop', function(coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local fingerId = CreateFingerId()
    FingerDrops[fingerId] = Player.PlayerData.metadata["fingerprint"]
    TriggerClientEvent("evidence:client:AddFingerPrint", -1, fingerId, Player.PlayerData.metadata["fingerprint"], coords)
end)

RegisterServerEvent('evidence:server:ClearBlooddrops')
AddEventHandler('evidence:server:ClearBlooddrops', function(blooddropList)
    if blooddropList ~= nil and next(blooddropList) ~= nil then 
        for k, v in pairs(blooddropList) do
            TriggerClientEvent("evidence:client:RemoveBlooddrop", -1, v)
            BloodDrops[v] = nil
        end
    end
end)

RegisterServerEvent('evidence:server:AddBlooddropToInventory')
AddEventHandler('evidence:server:AddBlooddropToInventory', function(bloodId, bloodInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, bloodInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveBlooddrop", -1, bloodId)
            BloodDrops[bloodId] = nil
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Je moet een leeg bewijszakje bij je hebben", "error")
    end
end)

RegisterServerEvent('evidence:server:AddFingerprintToInventory')
AddEventHandler('evidence:server:AddFingerprintToInventory', function(fingerId, fingerInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, fingerInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveFingerprint", -1, fingerId)
            FingerDrops[fingerId] = nil
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Je moet een leeg bewijszakje bij je hebben", "error")
    end
end)

RegisterServerEvent('evidence:server:CreateCasing')
AddEventHandler('evidence:server:CreateCasing', function(weapon, coords)
    local src = source
    local casingId = CreateCasingId()
    TriggerClientEvent("evidence:client:AddCasing", -1, casingId, weapon, coords)
end)


RegisterServerEvent('police:server:UpdateCurrentCops')
AddEventHandler('police:server:UpdateCurrentCops', function()
    local players = QBCore.Functions.GetPlayers()
	local amount = 0
	for source, Player in pairs(players) do
		if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
			amount = amount + 1
		end
    end
    TriggerClientEvent("police:SetCopCount", -1, amount)
end)

RegisterServerEvent('evidence:server:ClearCasings')
AddEventHandler('evidence:server:ClearCasings', function(casingList)
    if casingList ~= nil and next(casingList) ~= nil then 
        for k, v in pairs(casingList) do
            TriggerClientEvent("evidence:client:RemoveCasing", -1, v)
            Casings[v] = nil
        end
    end
end)

RegisterServerEvent('evidence:server:AddCasingToInventory')
AddEventHandler('evidence:server:AddCasingToInventory', function(casingId, casingInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, casingInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveCasing", -1, casingId)
            Casings[casingId] = nil
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Je moet een leeg bewijszakje bij je hebben", "error")
    end
end)

RegisterServerEvent('police:server:showFingerprint')
AddEventHandler('police:server:showFingerprint', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(playerId)
    -- if Player ~= nil then 
    --     TriggerClientEvent('chatMessage', source, "SYSTEM", false, "Vingerpatroon: " .. Player.PlayerData.metadata["fingerprint"])
    -- end

    TriggerClientEvent('police:client:showFingerprint', playerId, src)
    TriggerClientEvent('police:client:showFingerprint', src, playerId)
end)

RegisterServerEvent('police:server:showFingerprintId')
AddEventHandler('police:server:showFingerprintId', function(sessionId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(sessionId)
    local fid = Player.PlayerData.metadata["fingerprint"]

    TriggerClientEvent('police:client:showFingerprintId', sessionId, fid)
    TriggerClientEvent('police:client:showFingerprintId', src, fid)
end)

QBCore.Functions.CreateCallback('police:server:isPlayerDead', function(source, cb, playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    print(Player.PlayerData.metadata["isdead"])
    cb(Player.PlayerData.metadata["isdead"])
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

QBCore.Functions.CreateCallback('police:IsSilencedWeapon', function(source, cb, weapon)
    local Player = QBCore.Functions.GetPlayer(source)
    local itemInfo = Player.Functions.GetItemByName(QBCore.Shared.Weapons[weapon]["name"])
    local retval = false
    if itemInfo ~= nil then 
        if itemInfo.info ~= nil and itemInfo.info.attachments ~= nil then 
            for k, v in pairs(itemInfo.info.attachments) do
                if itemInfo.info.attachments[k].component == "COMPONENT_AT_AR_SUPP_02" or itemInfo.info.attachments[k].component == "COMPONENT_AT_AR_SUPP" or itemInfo.info.attachments[k].component == "COMPONENT_AT_PI_SUPP_02" or itemInfo.info.attachments[k].component == "COMPONENT_AT_PI_SUPP" then
                    retval = true
                end
            end
        end
    end
    cb(retval)
end)

QBCore.Functions.CreateCallback('police:GetDutyPlayers', function(source, cb)
    local players = QBCore.Functions.GetPlayers()
    local dutyPlayers = {}
	for k, Player in pairs(players) do
		if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
            table.insert(dutyPlayers, {
                source = Player.PlayerData.source,
                label = Player.PlayerData.metadata["callsign"],
                job = Player.PlayerData.job.name,
            })
		end
    end
    cb(dutyPlayers)
end)

function CreateBloodId()
    if BloodDrops ~= nil then
		local bloodId = math.random(10000, 99999)
		while BloodDrops[caseId] ~= nil do
			bloodId = math.random(10000, 99999)
		end
		return bloodId
	else
		local bloodId = math.random(10000, 99999)
		return bloodId
	end
end

function CreateFingerId()
    if FingerDrops ~= nil then
		local fingerId = math.random(10000, 99999)
		while FingerDrops[caseId] ~= nil do
			fingerId = math.random(10000, 99999)
		end
		return fingerId
	else
		local fingerId = math.random(10000, 99999)
		return fingerId
	end
end

function CreateCasingId()
    if Casings ~= nil then
		local caseId = math.random(10000, 99999)
		while Casings[caseId] ~= nil do
			caseId = math.random(10000, 99999)
		end
		return caseId
	else
		local caseId = math.random(10000, 99999)
		return caseId
	end
end

function CreateObjectId()
    if Objects ~= nil then
		local objectId = math.random(10000, 99999)
		while Objects[caseId] ~= nil do
			objectId = math.random(10000, 99999)
		end
		return objectId
	else
		local objectId = math.random(10000, 99999)
		return objectId
	end
end

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

QBCore.Functions.CreateCallback('police:GetCops', function(source, cb)
	local players = QBCore.Functions.GetPlayers()
	local amount = 0
	for source, Player in pairs(players) do
		if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
			amount = amount + 1
		end
    end
	cb(amount)
end)

QBCore.Commands.Add("pobject", "Plaats/Verwijder een object", {{name="type", help="Type object dat je wilt of 'delete' om te verwijderen"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local type = args[1]:lower()
    if Player.PlayerData.job.name == "police" then
        if type == "pion" then
            TriggerClientEvent("police:client:spawnCone", source)
        elseif type == "barier" then
            TriggerClientEvent("police:client:spawnBarier", source)
        elseif type == "schotten" then
            TriggerClientEvent("police:client:spawnSchotten", source)
        elseif type == "tent" then
            TriggerClientEvent("police:client:spawnTent", source)
        elseif type == "light" then
            TriggerClientEvent("police:client:spawnLight", source)
        elseif type == "delete" then
            TriggerClientEvent("police:client:deleteObject", source)
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("cuff", "Boei een speler", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:CuffPlayer", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("databank", "Toggle politie databank", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:toggleDatabank", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("callsign", "Zet de naam van je callsign (roepnummer)", {{name="name", help="Naam van je callsign"}}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.SetMetaData("callsign", table.concat(args, " "))
end)

QBCore.Commands.Add("clearcasings", "Haal kogelhulsen in de buurt weg (zorg ervoor dat je wel wat heb opgepakt)", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("evidence:client:ClearCasingsInArea", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("boete", "Schrijf een boete uit voor een persoon", {{name="id", help="Speler ID"},{name="prijs", help="Prijs van de boete"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        local playerId = tonumber(args[1])
        local price = tonumber(args[2])
        if price > 0 then
            TriggerClientEvent("police:client:BillCommand", source, playerId, price)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Prijs moet hoger zijn dan 0")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("jail", "Stuur een persoon naar de gevangenis", {{name="id", help="Speler ID"},{name="tijd", help="Tijd hoelang hij moet rotten >:)"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        local playerId = tonumber(args[1])
        local time = tonumber(args[2])
        if time > 0 then
            TriggerClientEvent("police:client:JailCommand", source, playerId, time)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Tijd moet hoger zijn dan 0")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("gimme", ":)", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local info = {
        serie = "K"..math.random(10,99).."SH"..math.random(100,999).."HJ"..math.random(1,9),
        attachments = {
            {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
            {component = "COMPONENT_AT_AR_SUPP_02", label = "Supressor"},
            {component = "COMPONENT_AT_AR_AFGRIP", label = "Grip"},
            {component = "COMPONENT_AT_SCOPE_MACRO", label = "1x Scope"},
            {component = "COMPONENT_ASSAULTRIFLE_CLIP_02", label = "Extended Clip"},
        }
    }
    if Player.Functions.AddItem("weapon_assaultrifle", 1, false, info) then
        print("Smile :)")
    end
end, "god")

QBCore.Commands.Add("gimme2", ":)", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local info = {
        serie = "K"..math.random(10,99).."SH"..math.random(100,999).."HJ"..math.random(1,9),
        attachments = {
            {component = "COMPONENT_AT_AR_SUPP_02", label = "Supressor"},
        }
    }
    if Player.Functions.AddItem("weapon_pistol50", 1, false, info) then
        print("s0me1 is de beste KEKW")
    end
end, "god")

QBCore.Commands.Add("clearblood", "Haal bloed in de buurt weg (zorg ervoor dat je wel wat heb opgepakt)", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("evidence:client:ClearBlooddropsInArea", source)
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

QBCore.Commands.Add("112", "Stuur een melding naar hulpdiensten", {{name="bericht", help="Bericht die je wilt sturen naar de hulpdiensten"}}, true, function(source, args)
    local message = table.concat(args, " ")
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("police:client:SendEmergencyMessage", source, message)
end)

QBCore.Commands.Add("112a", "Stuur een anonieme melding naar hulpdiensten (geeft geen locatie)", {{name="bericht", help="Bericht die je wilt sturen naar de hulpdiensten"}}, true, function(source, args)
    local message = table.concat(args, " ")
    local Player = QBCore.Functions.GetPlayer(source)
    local players = QBCore.Functions.GetPlayers()
    TriggerClientEvent("police:client:CallAnim", src)
    for k, Player in pairs(players) do
        if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
            TriggerClientEvent('chatMessage', k, "ANONIEME MELDING", "warning", message)
            TriggerClientEvent("police:client:EmergencySound", k)
		end
    end
end)

QBCore.Commands.Add("112r", "Stuur een bericht terug naar een melding", {{name="id", help="ID van de melding"}, {name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local OtherPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    table.remove(args, 1)
    local message = table.concat(args, " ")
    TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "(POLITIE) " ..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, "error", message)
    TriggerClientEvent("police:client:EmergencySound", OtherPlayer.PlayerData.source)
    TriggerClientEvent("police:client:CallAnim", OtherPlayer.PlayerData.source)
end)