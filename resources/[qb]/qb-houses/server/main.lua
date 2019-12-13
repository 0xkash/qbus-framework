
QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

Citizen.CreateThread(function()
	local HouseGarages = {}
	QBCore.Functions.ExecuteSql("SELECT * FROM `houselocations`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				local owned = false
				if tonumber(v.owned) == 1 then
					owned = true
				end
				local garage = v.garage ~= nil and json.decode(v.garage) or {}
				Config.Houses[v.name] = {
					coords = json.decode(v.coords),
					owned = v.owned,
					price = v.price,
					locked = true,
					adress = v.label, 
					tier = v.tier,
					garage = garage,
					decorations = {},
				}
				HouseGarages[v.name] = {
					label = v.label,
					takeVehicle = garage,
				}
			end
		end
		TriggerClientEvent("qb-garages:client:houseGarageConfig", -1, HouseGarages)
		TriggerClientEvent("qb-houses:client:setHouseConfig", -1, Config.Houses)
	end)
end)

local houseowneridentifier = {}
local houseownercid = {}
local housekeyholders = {}

RegisterServerEvent('qb-houses:server:setHouses')
AddEventHandler('qb-houses:server:setHouses', function()
	local src = source
	TriggerClientEvent("qb-houses:client:setHouseConfig", src, Config.Houses)
end)

RegisterServerEvent('qb-houses:server:addNewHouse')
AddEventHandler('qb-houses:server:addNewHouse', function(street, coords, price, tier)
	local src = source
	local street = street:gsub("%'", "")
	local price = tonumber(price)
	local tier = tonumber(tier)
	local houseCount = GetHouseStreetCount(street)
	local name = street:lower() .. tostring(houseCount)
	local label = street .. " " .. tostring(houseCount)
	QBCore.Functions.ExecuteSql("INSERT INTO `houselocations` (`name`, `label`, `coords`, `owned`, `price`, `tier`) VALUES ('"..name.."', '"..label.."', '"..json.encode(coords).."', 0,"..price..", "..tier..")")
	Config.Houses[name] = {
		coords = coords,
		owned = false,
		price = price,
		locked = true,
		adress = label, 
		tier = tier,
		garage = {},
		decorations = {},
	}
	TriggerClientEvent("qb-houses:client:setHouseConfig", -1, Config.Houses)
	TriggerClientEvent('QBCore:Notify', src, "Je hebt een huis toegevoegd: "..label)
end)

RegisterServerEvent('qb-houses:server:addGarage')
AddEventHandler('qb-houses:server:addGarage', function(house, coords)
	local src = source
	QBCore.Functions.ExecuteSql("UPDATE `houselocations` SET `garage` = '"..json.encode(coords).."' WHERE `name` = '"..house.."'")
	local garageInfo = {
		label = Config.Houses[house].adress,
		takeVehicle = coords,
	}
	TriggerClientEvent("qb-garages:client:addHouseGarage", -1, house, garageInfo)
	TriggerClientEvent('QBCore:Notify', src, "Je hebt een garage toegevoegd bij: "..garageInfo.label)
end)

RegisterServerEvent('qb-houses:server:viewHouse')
AddEventHandler('qb-houses:server:viewHouse', function(house)
	local src     		= source
	local pData 		= QBCore.Functions.GetPlayer(src)

	local houseprice   	= Config.Houses[house].price
	local brokerfee 	= (houseprice / 100 * 5)
	local bankfee 		= (houseprice / 100 * 10) 
	local taxes 		= (houseprice / 100 * 6)

	TriggerClientEvent('qb-houses:client:viewHouse', src, houseprice, brokerfee, bankfee, taxes, pData.PlayerData.charinfo.firstname, pData.PlayerData.charinfo.lastname)
end)

RegisterServerEvent('qb-houses:server:buyHouse')
AddEventHandler('qb-houses:server:buyHouse', function(house)
	local src     	= source
	local pData 	= QBCore.Functions.GetPlayer(src)
	local price   	= Config.Houses[house].price
	local keyyeet 	= {pData.PlayerData.citizenid}
	local bankBalance = pData.PlayerData.money["bank"]

	if (bankBalance >= price) then
		QBCore.Functions.ExecuteSql("INSERT INTO `player_houses` (`house`, `identifier`, `citizenid`, `keyholders`) VALUES ('"..house.."', '"..pData.PlayerData.steam.."', '"..pData.PlayerData.citizenid.."', '"..json.encode(keyyeet).."')")
		houseowneridentifier[house] = pData.PlayerData.steam
		houseownercid[house] = pData.PlayerData.citizenid
		housekeyholders[house] = json.encode(keyyeet)
		QBCore.Functions.ExecuteSql("UPDATE `houselocations` SET `owned` = 1 WHERE `name` = '"..house.."'")
		TriggerClientEvent('qb-houses:client:SetClosestHouse', src)
	else
		TriggerClientEvent('QBCore:Notify', source, "Je hebt niet genoeg geld..", "error")
	end
end)

RegisterServerEvent('qb-houses:server:lockHouse')
AddEventHandler('qb-houses:server:lockHouse', function(bool, house)
	TriggerClientEvent('qb-houses:client:lockHouse', -1, bool, house)
end)

--------------------------------------------------------------

--------------------------------------------------------------

QBCore.Functions.CreateCallback('qb-houses:server:hasKey', function(source, cb, house)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local retval = false
	if Player ~= nil then 
		local identifier = Player.PlayerData.steam
		local CharId = Player.PlayerData.citizenid
		if hasKey(identifier, CharId, house) then
			retval = true
		elseif Player.PlayerData.job.name == "realestate" then
			retval = true
		else
			retval = false
		end
	end
	
	cb(retval)
end)

QBCore.Functions.CreateCallback('qb-houses:server:isOwned', function(source, cb, house)
	if houseowneridentifier[house] ~= nil and houseownercid[house] ~= nil then
		cb(true)
	else
		cb(false)
	end
end)

function hasKey(identifier, cid, house)
	if houseowneridentifier[house] ~= nil and houseownercid[house] ~= nil then
		if houseowneridentifier[house] == identifier and houseownercid[house] == cid then
			return true
		else
			for i = 1, (#housekeyholders[house]) do
				if housekeyholders[house][i] == cid then
					return true
				end
			end
		end
	end
	return false
end

RegisterServerEvent('qb-houses:server:giveKey')
AddEventHandler('qb-houses:server:giveKey', function(house, target)
	local pData = QBCore.Functions.GetPlayer(target)

	table.insert(housekeyholders[house], pData.PlayerData.citizenid)
	Wait(100)
	QBCore.Functions.ExecuteSql("UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
end)

function typeof(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end

local housesLoaded = false

Citizen.CreateThread(function()
	while true do
		if not housesLoaded then
			exports['ghmattimysql']:execute('SELECT * FROM player_houses', function(houses)
				if houses ~= nil then
					for _,house in pairs(houses) do
						houseowneridentifier[house.house] = house.identifier
						houseownercid[house.house] = house.citizenid
						housekeyholders[house.house] = json.decode(house.keyholders)
					end
				end
			end)
			housesLoaded = true
		end
		Citizen.Wait(7)
	end
end)

RegisterServerEvent('qb-houses:server:OpenDoor')
AddEventHandler('qb-houses:server:OpenDoor', function(target, house)
    local src = source
    local OtherPlayer = QBCore.Functions.GetPlayer(target)
    if OtherPlayer ~= nil then
        TriggerClientEvent('qb-houses:client:SpawnInApartment', OtherPlayer.PlayerData.source, house)
    end
end)

RegisterServerEvent('qb-houses:server:RingDoor')
AddEventHandler('qb-houses:server:RingDoor', function(house)
    local src = source
    TriggerClientEvent('qb-houses:client:RingDoor', -1, src, house)
end)

RegisterServerEvent('qb-houses:server:savedecorations')
AddEventHandler('qb-houses:server:savedecorations', function(house, decorations)
	local src = source
	QBCore.Functions.ExecuteSql("UPDATE `player_houses` SET `decorations` = '"..json.encode(decorations).."' WHERE `house` = '"..house.."'")
	TriggerClientEvent("qb-houses:server:sethousedecorations", -1, house, decorations)
end)

QBCore.Functions.CreateCallback('qb-houses:server:getHouseDecorations', function(source, cb, house)
	local retval = nil
	QBCore.Functions.ExecuteSql("SELECT * FROM `player_houses` WHERE `house` = '"..house.."'", function(result)
		if result[1] ~= nil then
			retval = json.decode(result[1].decorations)
		end
	end)
	cb(retval)
end)

QBCore.Functions.CreateCallback('qb-houses:server:getHouseLocations', function(source, cb, house)
	local retval = nil
	QBCore.Functions.ExecuteSql("SELECT * FROM `player_houses` WHERE `house` = '"..house.."'", function(result)
		if result[1] ~= nil then
			retval = result[1]
		end
	end)
	cb(retval)
end)

QBCore.Functions.CreateCallback('qb-houses:server:getHouseKeys', function(source, cb)
	local src = source
	local pData = QBCore.Functions.GetPlayer(src)
	local cid = pData.PlayerData.citizenid
end)

function mysplit (inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end

QBCore.Functions.CreateCallback('qb-houses:server:getOwnedHouses', function(source, cb)
	local src = source
	local pData = QBCore.Functions.GetPlayer(src)

	if pData then
		exports['ghmattimysql']:execute('SELECT * FROM player_houses WHERE identifier = @identifier AND citizenid = @citizenid', {['@identifier'] = pData.PlayerData.steam, ['@citizenid'] = pData.PlayerData.citizenid}, function(houses)
			local ownedHouses = {}

			for i=1, #houses, 1 do
				table.insert(ownedHouses, houses[i].house)
			end

			if houses ~= nil then
				cb(ownedHouses)
			else
				cb(nil)
			end
		end)
	end
end)

QBCore.Functions.CreateCallback('qb-houses:server:getSavedOutfits', function(source, cb)
	local src = source
	local pData = QBCore.Functions.GetPlayer(src)

	if pData then
		exports['ghmattimysql']:execute('SELECT * FROM player_outfits WHERE citizenid = @citizenid', {['@citizenid'] = pData.PlayerData.citizenid}, function(result)
			if result[1] ~= nil then
				cb(result)
			else
				cb(nil)
			end
		end)
	end
end)

QBCore.Commands.Add("decorate", "Decoreer je huisie :)", {}, false, function(source, args)
	TriggerClientEvent("qb-houses:client:decorate", source)
end)

function GetHouseStreetCount(street)
	local count = 1
	QBCore.Functions.ExecuteSql("SELECT * FROM `houselocations` WHERE `name` LIKE '%"..street.."%'", function(result)
		if result[1] ~= nil then 
			for i = 1, #result, 1 do
				count = count + 1
			end
		end
		return count
	end)
	return count
end

RegisterServerEvent('qb-houses:server:logOut')
AddEventHandler('qb-houses:server:logOut', function()
	local src = source
	QBCore.Player.Logout(src)
	Wait(100)
	TriggerClientEvent('qb-multicharacter:client:chooseChar', src)
end)

RegisterServerEvent('qb-houses:server:giveHouseKey')
AddEventHandler('qb-houses:server:giveHouseKey', function(target, house)
	local src = source
	local tPlayer = QBCore.Functions.GetPlayer(target)

	if tPlayer ~= nil then
		if housekeyholders[house] ~= nil then
			if typeof(housekeyholders[house]) ~= "table" then
				housekeyholders[house] = json.decode(housekeyholders[house])
			end
			table.insert(housekeyholders[house], tPlayer.PlayerData.citizenid)
			Wait(250)
			QBCore.Functions.ExecuteSql("UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
			TriggerClientEvent('qb-houses:client:refreshHouse', tPlayer.PlayerData.source)
			TriggerClientEvent('QBCore:Notify', tPlayer.PlayerData.source, 'Je hebt de sleuteltjes van '..Config.Houses[house].adress..' ontvagen', 'success', 2500)
		end
	else
		TriggerClientEvent('QBCore:Notify', src, 'Er is iets mis gegaan.. Probeer het opnieuw!', 'error', 2500)
	end
end)

RegisterServerEvent('qb-houses:server:setLocation')
AddEventHandler('qb-houses:server:setLocation', function(coords, house, type)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if type == 1 then
		QBCore.Functions.ExecuteSql("UPDATE `player_houses` SET `stash` = '"..json.encode(coords).."' WHERE `house` = '"..house.."'")
	elseif type == 2 then
		QBCore.Functions.ExecuteSql("UPDATE `player_houses` SET `outfit` = '"..json.encode(coords).."' WHERE `house` = '"..house.."'")
	elseif type == 3 then
		QBCore.Functions.ExecuteSql("UPDATE `player_houses` SET `logout` = '"..json.encode(coords).."' WHERE `house` = '"..house.."'")
	end

	TriggerClientEvent('qb-houses:client:refreshLocations', -1, house, json.encode(coords), type)
end)

QBCore.Commands.Add("createhouse", "Maak een huis aan als makelaar", {{name="price", help="Prijs van het huis"},{name="tier", help="Naam van het item (geen label)"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
	local price = tonumber(args[1])
	local tier = tonumber(args[2])
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("qb-houses:client:createHouses", source, price, tier)
	end
end)

QBCore.Commands.Add("addgarage", "Voeg garage toe bij dichtsbijzijnde huis", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("qb-houses:client:addGarage", source)
	end
end)