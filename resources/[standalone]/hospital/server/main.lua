QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local PlayerInjuries = {}

local beds = {
    { x = 356.73, y = -585.71, z = 43.11, h = -20.0, taken = false, model = 1631638868 },
    { x = 360.51, y = -586.66, z = 43.11, h = -20.0, taken = false, model = -1091386327 },
    { x = 353.12, y = -584.66, z = 43.50, h = -20.0, taken = false, model = 1631638868 },
    { x = 349.62, y = -583.53, z = 43.022, h = -20.0, taken = false, model = -1091386327 },
    { x = 344.80, y = -581.12, z = 43.02, h = 80.0, taken = false, model = -1091386327 },
    { x = 334.09, y = -578.43, z = 43.01, h = 80.0, taken = false, model = -1091386327 },
    { x = 323.64, y = -575.16, z = 43.02, h = -20.0, taken = false, model = -1091386327 },
    { x = 326.97, y = -576.229, z = 43.02, h = -20.0, taken = false, model = -1091386327 },
    { x = 354.24, y = -592.74, z = 43.11, h = 160.0, taken = false, model = 2117668672 },
    { x = 357.34, y = -594.45, z = 43.11, h = 160.0, taken = false, model = 2117668672 },
    { x = 350.80, y = -591.72, z = 43.11, h = 160.0, taken = false, model = 2117668672 },
    { x = 346.89, y = -591.01, z = 42.58, h = 160.0, taken = false, model = 2117668672 },
}

local bedsTaken = {}

RegisterServerEvent('hospital:server:SendToBed')
AddEventHandler('hospital:server:SendToBed', function(data)
	local src = source
	if data == nil then
		for k, v in pairs(beds) do
			if not v.taken then
				v.taken = true
				bedsTaken[source] = k
				TriggerClientEvent('hospital:client:SendToBed', src, k, v, true)
				return
			end
		end
	else
		if not beds[data].taken then
			beds[data].taken = true
			bedsTaken[source] = k
			TriggerClientEvent('hospital:client:SendToBed', src, data, beds[data], false)
			return
		else
			TriggerClientEvent('QBCore:Notify', src, "Bed is bezet!", "error")
			return
		end
	end
	TriggerClientEvent('QBCore:Notify', src, "Alle bedden zijn bezet!", "error")
end)

RegisterServerEvent('hospital:server:LeaveBed')
AddEventHandler('hospital:server:LeaveBed', function(id)
    beds[id].taken = false
end)

RegisterServerEvent('hospital:server:SyncInjuries')
AddEventHandler('hospital:server:SyncInjuries', function(data)
    local src = source
    PlayerInjuries[src] = data
end)

RegisterServerEvent('hospital:server:SetDeathStatus')
AddEventHandler('hospital:server:SetDeathStatus', function(isDead)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.Functions.SetMetaData("isdead", isDead)
	end
end)

RegisterServerEvent('hospital:server:TreatWounds')
AddEventHandler('hospital:server:TreatWounds', function(playerId)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Patient = QBCore.Functions.GetPlayer(playerId)
	if Player.PlayerData.job.name == "doctor" then
		TriggerClientEvent("hospital:client:HealInjuries", Patient.PlayerData.source, "full")
	elseif Player.PlayerData.job.name == "ambulance" then
		TriggerClientEvent("hospital:client:HealInjuries", Patient.PlayerData.source, "partial")
	end
end)

function GetCharsInjuries(source)
    return PlayerInjuries[source]
end

function GetActiveInjuries(source)
	local injuries = {}
	if (PlayerInjuries[source].isBleeding > 0) then
		injuries["BLEED"] = PlayerInjuries[source].isBleeding
	end
	for k, v in pairs(PlayerInjuries[source].limbs) do
		if PlayerInjuries[source].limbs[k].isDamaged then
			injuries[k] = PlayerInjuries[source].limbs[k]
		end
	end
    return injuries
end


QBCore.Functions.CreateCallback('hospital:GetPlayerStatus', function(source, cb, playerId)
	local Player = QBCore.Functions.GetPlayer(playerId)
	local injuries = {}
	if Player ~= nil then
		if (PlayerInjuries[Player.PlayerData.source].isBleeding > 0) then
			injuries["BLEED"] = PlayerInjuries[Player.PlayerData.source].isBleeding
		end
		for k, v in pairs(PlayerInjuries[Player.PlayerData.source].limbs) do
			if PlayerInjuries[Player.PlayerData.source].limbs[k].isDamaged then
				injuries[k] = PlayerInjuries[Player.PlayerData.source].limbs[k]
			end
		end
	end
    cb(injuries)
end)

QBCore.Commands.Add("status", "Check gezondheid van een persoon", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "doctor" or Player.PlayerData.job.name == "ambulance" then
		TriggerClientEvent("hospital:client:CheckStatus", source)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
	end
end)

QBCore.Commands.Add("genees", "Help de verwondingen van een persoon", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "doctor" or Player.PlayerData.job.name == "ambulance" then
		TriggerClientEvent("hospital:client:TreatWounds", source)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
	end
end)

QBCore.Commands.Add("revive", "Revive een speler of jezelf", {{name="id", help="Speler ID (mag leeg zijn)"}}, false, function(source, args)
	if args[1] ~= nil then
		local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('hospital:client:Revive', Player.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		TriggerClientEvent('hospital:client:Revive', source)
	end
end, "moderator")

QBCore.Commands.Add("setpain", "Zet een pijn voor jezelf of iemand anders", {{name="id", help="Speler ID (mag leeg zijn)"}}, false, function(source, args)
	if args[1] ~= nil then
		local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('hospital:client:SetPain', Player.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		TriggerClientEvent('hospital:client:SetPain', source)
	end
end, "god")

QBCore.Commands.Add("kill", "Vermoord een speler of jezelf", {{name="id", help="Speler ID (mag leeg zijn)"}}, false, function(source, args)
	if args[1] ~= nil then
		local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('hospital:client:KillPlayer', Player.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		TriggerClientEvent('hospital:client:KillPlayer', source)
	end
end, "god")