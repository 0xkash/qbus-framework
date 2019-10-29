
QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

--CODE

local houseprices = {
	["mirrorpark01"] = 200000,
	["mirrorpark02"] = 250000,
}

local houseowneridentifier = {}
local houseownercid = {}
local housekeyholders = {}

RegisterServerEvent('qb-houses:server:viewHouse')
AddEventHandler('qb-houses:server:viewHouse', function(house)
	local src     		= source
	local pData 		= QBCore.Functions.GetPlayer(src)

	local houseprice   	= houseprices[house]
	local brokerfee 	= (houseprice / 100 * 5)
	local bankfee 		= (houseprice / 100 * 10)
	local taxes 		= (houseprice / 100 * 6)

	TriggerClientEvent('qb-houses:client:viewHouse', src, houseprice, brokerfee, bankfee, taxes, pData.PlayerData.charinfo.firstname, pData.PlayerData.charinfo.lastname)
end)

RegisterServerEvent('qb-houses:server:buyHouse')
AddEventHandler('qb-houses:server:buyHouse', function(house)
	local src     	= source
	local pData 	= QBCore.Functions.GetPlayer(src)
	local price   	= houseprices[house]

	if pData.Functions.RemoveMoney('bank', price) then
		QBCore.Functions.ExecuteSql("INSERT INTO `player_houses` (`house`, `identifier`, `citizenid`) VALUES ('"..house.."', '"..pData.PlayerData.steam.."', '"..pData.PlayerData.citizenid.."')")
		houseowneridentifier[house] = pData.PlayerData.steam
		houseownercid[house] = pData.PlayerData.citizenid
		housekeyholders[house] = json.encode(pData.PlayerData.steam)
		TriggerClientEvent('qb-houses:client:SetClosestHouse', src)
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

	local identifier = Player.PlayerData.steam
	local CharId = Player.PlayerData.citizenid

	cb(hasKey(identifier, CharId, house))
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