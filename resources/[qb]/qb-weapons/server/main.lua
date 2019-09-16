QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local WeaponAmmo = {}

RegisterServerEvent("weapons:server:LoadWeaponAmmo")
AddEventHandler('weapons:server:LoadWeaponAmmo', function()
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql("SELECT * FROM `playerammo` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            local ammo = json.decode(result[1].ammo)
            local ammoData = {}
            if ammo ~= nil then
                for ammotype, amount in pairs(ammo) do 
                    table.insert(ammoData, {type = ammotype, amount = amount})
                end
            end
            WeaponAmmo[Player.PlayerData.citizenid] = {}
            WeaponAmmo[Player.PlayerData.citizenid].ammo = {}
            table.insert(WeaponAmmo[Player.PlayerData.citizenid].ammo, {type = type, amount = amount})
        end
	end)
end)

RegisterServerEvent("weapons:server:AddWeaponAmmo")
AddEventHandler('weapons:server:AddWeaponAmmo', function(type, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local type = tostring(type):upper()
    local amount = tonumber(amount)
    if WeaponAmmo[Player.PlayerData.citizenid] ~= nil and WeaponAmmo[Player.PlayerData.citizenid].ammo ~= nil then
        for _, ammoData in pairs(WeaponAmmo[Player.PlayerData.citizenid].ammo) do
            if type == ammoData.type then
                ammoData.amount = ammoData.amount + amount
                return
            end
        end
    end
    if WeaponAmmo[Player.PlayerData.citizenid] == nil then
        WeaponAmmo[Player.PlayerData.citizenid] = {}
        WeaponAmmo[Player.PlayerData.citizenid].ammo = {}
        table.insert(WeaponAmmo[Player.PlayerData.citizenid].ammo, {type = type, amount = amount})
        return
    else
        table.insert(WeaponAmmo[Player.PlayerData.citizenid].ammo, {type = type, amount = amount})
        return
    end
end)

RegisterServerEvent("weapons:server:UpdateWeaponAmmo")
AddEventHandler('weapons:server:UpdateWeaponAmmo', function(type, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local type = tostring(type):upper()
    local amount = tonumber(amount)
    if WeaponAmmo[Player.PlayerData.citizenid] ~= nil and WeaponAmmo[Player.PlayerData.citizenid].ammo ~= nil then
        for _, ammoData in pairs(WeaponAmmo[Player.PlayerData.citizenid].ammo) do
            if type == ammoData.type then
                ammoData.amount = amount
                return
            end
        end
    end
end)

RegisterServerEvent("weapons:server:SaveWeaponAmmo")
AddEventHandler('weapons:server:SaveWeaponAmmo', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player ~= nil then
        QBCore.Functions.ExecuteSql("SELECT * FROM `playerammo` WHERE `citizenid` = '".. Player.PlayerData.citizenid.."'", function(result)
            if result[1] == nil then
                QBCore.Functions.ExecuteSql("INSERT INTO `playerammo` (`citizenid`, `ammo`) VALUES ('"..Player.PlayerData.citizenid.."', '"..json.encode(WeaponAmmo[Player.PlayerData.citizenid].ammo).."')")
            else
                if WeaponAmmo[Player.PlayerData.citizenid] ~= nil and WeaponAmmo[Player.PlayerData.citizenid].ammo ~= nil then
                    QBCore.Functions.ExecuteSql("UPDATE `playerammo` SET ammo='"..json.encode(WeaponAmmo[Player.PlayerData.citizenid].ammo).."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
                end
            end
        end)
        QBCore.ShowSuccess(GetCurrentResourceName(), Player.PlayerData.name .." WEAPON AMMO SAVED!")
    end
end)

QBCore.Functions.CreateCallback("weapon:server:GetWeaponAmmo", function(source, cb, ammotype)
    local Player = QBCore.Functions.GetPlayer(source)
    if WeaponAmmo[Player.PlayerData.citizenid] ~= nil and WeaponAmmo[Player.PlayerData.citizenid].ammo ~= nil then
        for _, ammoData in pairs(WeaponAmmo[Player.PlayerData.citizenid].ammo) do
            if ammoData ~= nil and ammotype == ammoData.type then
                cb(ammoData.amount)
            end
        end
    end
    cb(0)
end)

QBCore.Functions.CreateUseableItem("pistol_ammo", function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem("pistol_ammo", 1) then
        TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_PISTOL", 15)
        TriggerClientEvent('QBCore:Notify', source, QBCore.Shared.Items["pistol_ammo"]["label"].. " gebruikt")
    end
end)
