QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local PlayerInjuries = {}
local PlayerWeaponWounds = {}
local bedsTaken = {}

RegisterServerEvent('hospital:server:SendToBed')
AddEventHandler('hospital:server:SendToBed', function(data)
	local src = source
	if data == nil then
		for k, v in pairs(Config.Locations["beds"]) do
			if not v.taken then
				v.taken = true
				bedsTaken[source] = k
				TriggerClientEvent('hospital:client:SendToBed', src, k, v, true)
				return
			end
		end
	else
		if not Config.Locations["beds"][data].taken then
			Config.Locations["beds"][data].taken = true
			bedsTaken[source] = k
			TriggerClientEvent('hospital:client:SendToBed', src, data, Config.Locations["beds"][data], false)
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
    Config.Locations["beds"][id].taken = false
end)

RegisterServerEvent('hospital:server:SyncInjuries')
AddEventHandler('hospital:server:SyncInjuries', function(data)
    local src = source
    PlayerInjuries[src] = data
end)


RegisterServerEvent('hospital:server:SetWeaponDamage')
AddEventHandler('hospital:server:SetWeaponDamage', function(data)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player ~= nil then 
		PlayerWeaponWounds[Player.PlayerData.source] = data
	end
end)

RegisterServerEvent('hospital:server:RestoreWeaponDamage')
AddEventHandler('hospital:server:RestoreWeaponDamage', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	PlayerWeaponWounds[Player.PlayerData.source] = nil
end)

RegisterServerEvent('hospital:server:SetDeathStatus')
AddEventHandler('hospital:server:SetDeathStatus', function(isDead)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.Functions.SetMetaData("isdead", isDead)
	end
end)

RegisterServerEvent('hospital:server:SetArmor')
AddEventHandler('hospital:server:SetArmor', function(amount)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.Functions.SetMetaData("armor", amount)
	end
end)

RegisterServerEvent('hospital:server:TreatWounds')
AddEventHandler('hospital:server:TreatWounds', function(playerId)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Patient = QBCore.Functions.GetPlayer(playerId)
	if Patient ~= nil then
		if Player.PlayerData.job.name == "doctor" then
			TriggerClientEvent("hospital:client:HealInjuries", Patient.PlayerData.source, "full")
		elseif Player.PlayerData.job.name == "ambulance" then
			TriggerClientEvent("hospital:client:HealInjuries", Patient.PlayerData.source, "partial")
		end
	end
end)

RegisterServerEvent('hospital:server:RevivePlayer')
AddEventHandler('hospital:server:RevivePlayer', function(playerId)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Patient = QBCore.Functions.GetPlayer(playerId)
	if Patient ~= nil then
		if Player.PlayerData.job.name == "doctor" then
			TriggerClientEvent('hospital:client:Revive', Patient.PlayerData.source)
		end
	end
end)

RegisterServerEvent('hospital:server:SendDoctorAlert')
AddEventHandler('hospital:server:SendDoctorAlert', function()
	local src = source
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
		local Player = QBCore.Functions.GetPlayer(k)
		if Player ~= nil then 
			if (Player.PlayerData.job.name == "doctor" and Player.PlayerData.job.onduty) then
				TriggerClientEvent("hospital:client:SendAlert", k, "Er is een dokter nodig bij Pillbox Ziekenhuis")
			end
		end
	end
end)

RegisterServerEvent('hospital:server:MakeDeadCall')
AddEventHandler('hospital:server:MakeDeadCall', function(blipSettings, gender, street1, street2)
	local src = source
	local genderstr = "Man"

	if gender == 1 then genderstr = "Vrouw" end

	if street2 ~= nil then
		TriggerClientEvent("112:client:SendAlert", -1, "Een ".. genderstr .." gewond bij " ..street1 .. " "..street2, blipSettings)
	else
		TriggerClientEvent("112:client:SendAlert", -1, "Een ".. genderstr .." gewond bij "..street1, blipSettings)
	end
end)

QBCore.Functions.CreateCallback('hospital:GetDoctors', function(source, cb)
	local amount = 0
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
		local Player = QBCore.Functions.GetPlayer(k)
		if Player ~= nil then 
			if (Player.PlayerData.job.name == "doctor" and Player.PlayerData.job.onduty) then
				amount = amount + 1
			end
		end
	end
	cb(amount)
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
	injuries["WEAPONWOUNDS"] = {}
	if Player ~= nil then
		if PlayerInjuries[Player.PlayerData.source] ~= nil then
			if (PlayerInjuries[Player.PlayerData.source].isBleeding > 0) then
				injuries["BLEED"] = PlayerInjuries[Player.PlayerData.source].isBleeding
			end
			for k, v in pairs(PlayerInjuries[Player.PlayerData.source].limbs) do
				if PlayerInjuries[Player.PlayerData.source].limbs[k].isDamaged then
					injuries[k] = PlayerInjuries[Player.PlayerData.source].limbs[k]
				end
			end
		end
		if PlayerWeaponWounds[Player.PlayerData.source] ~= nil then 
			for k, v in pairs(PlayerWeaponWounds[Player.PlayerData.source]) do
				injuries["WEAPONWOUNDS"][k] = v
			end
		end
	end
    cb(injuries)
end)

QBCore.Functions.CreateCallback('hospital:GetPlayerBleeding', function(source, cb)
	local src = source
	if PlayerInjuries[src] ~= nil and PlayerInjuries[src].isBleeding ~= nil then
		cb(PlayerInjuries[src].isBleeding)
	else
		cb(nil)
	end
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

QBCore.Commands.Add("revivep", "Help een persoon omhoog", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "doctor" then
		TriggerClientEvent("hospital:client:RevivePlayer", source)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
	end
end)

QBCore.Commands.Add("revive", "Revive een speler of jezelf", {{name="id", help="Speler ID (mag leeg zijn)"}}, false, function(source, args)
	if args[1] ~= nil then
		local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('hospital:client:Revive', Player.PlayerData.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		TriggerClientEvent('hospital:client:Revive', source)
	end
end, "admin")

QBCore.Commands.Add("setpain", "Zet een pijn voor jezelf of iemand anders", {{name="id", help="Speler ID (mag leeg zijn)"}}, false, function(source, args)
	if args[1] ~= nil then
		local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('hospital:client:SetPain', Player.PlayerData.source)
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
			TriggerClientEvent('hospital:client:KillPlayer', Player.PlayerData.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		TriggerClientEvent('hospital:client:KillPlayer', source)
	end
end, "god")