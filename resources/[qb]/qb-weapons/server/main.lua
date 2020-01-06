QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local WeaponAmmo = {}

RegisterServerEvent("weapons:server:LoadWeaponAmmo")
AddEventHandler('weapons:server:LoadWeaponAmmo', function()
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    WeaponAmmo[Player.PlayerData.citizenid] = {}
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `playerammo` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            local ammo = json.decode(result[1].ammo)
            if ammo ~= nil then
                for ammotype, amount in pairs(ammo) do 
                    WeaponAmmo[Player.PlayerData.citizenid][ammotype] = amount
                end
            end
        end
	end)
end)

RegisterServerEvent("weapons:server:AddWeaponAmmo")
AddEventHandler('weapons:server:AddWeaponAmmo', function(type, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local type = tostring(type):upper()
    local amount = tonumber(amount)
    if WeaponAmmo[Player.PlayerData.citizenid] ~= nil then
        if next(WeaponAmmo[Player.PlayerData.citizenid]) ~= nil then
            if WeaponAmmo[Player.PlayerData.citizenid][type] ~= nil then
                WeaponAmmo[Player.PlayerData.citizenid][type] = WeaponAmmo[Player.PlayerData.citizenid][type] + amount
            else
                WeaponAmmo[Player.PlayerData.citizenid][type] = amount
            end
        else
            WeaponAmmo[Player.PlayerData.citizenid][type] = amount
        end
    end
end)

RegisterServerEvent("weapons:server:UpdateWeaponAmmo")
AddEventHandler('weapons:server:UpdateWeaponAmmo', function(type, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local type = tostring(type):upper()
    local amount = tonumber(amount)
    if WeaponAmmo[Player.PlayerData.citizenid] ~= nil and next(WeaponAmmo[Player.PlayerData.citizenid]) ~= nil then
        for ammotype, ammo in pairs(WeaponAmmo[Player.PlayerData.citizenid]) do
            if type == ammotype then
                WeaponAmmo[Player.PlayerData.citizenid][ammotype] = amount
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
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `playerammo` WHERE `citizenid` = '".. Player.PlayerData.citizenid.."'", function(result)
            if result[1] == nil then
                QBCore.Functions.ExecuteSql(false, "INSERT INTO `playerammo` (`citizenid`, `ammo`) VALUES ('"..Player.PlayerData.citizenid.."', '"..json.encode(WeaponAmmo[Player.PlayerData.citizenid]).."')")
            else
                QBCore.Functions.ExecuteSql(false, "UPDATE `playerammo` SET ammo='"..json.encode(WeaponAmmo[Player.PlayerData.citizenid]).."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
            end
        end)
    end
end)

QBCore.Functions.CreateCallback("weapon:server:GetWeaponAmmo", function(source, cb, ammotype)
    local Player = QBCore.Functions.GetPlayer(source)
    local ammotype = tostring(ammotype):upper()
    if Player ~= nil then 
        if WeaponAmmo[Player.PlayerData.citizenid] ~= nil and next(WeaponAmmo[Player.PlayerData.citizenid]) ~= nil then
            local amount = tonumber(WeaponAmmo[Player.PlayerData.citizenid][ammotype]) ~= 0 and tonumber(WeaponAmmo[Player.PlayerData.citizenid][ammotype]) or 0
            cb(amount)
        else
            cb(0)
        end
    end
    cb(0)
end)

QBCore.Functions.CreateUseableItem("pistol_ammo", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem("pistol_ammo", 1, item.slot) then
        TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_PISTOL", 15)
        TriggerClientEvent('QBCore:Notify', source, QBCore.Shared.Items["pistol_ammo"]["label"].. " gebruikt")
    end
end)

QBCore.Functions.CreateUseableItem("rifle_ammo", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem("rifle_ammo", 1, item.slot) then
        TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_RIFLE", 30)
        TriggerClientEvent('QBCore:Notify', source, QBCore.Shared.Items["rifle_ammo"]["label"].. " gebruikt")
    end
end)

QBCore.Functions.CreateUseableItem("smg_ammo", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem("smg_ammo", 1, item.slot) then
        TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_SMG", 20)
        TriggerClientEvent('QBCore:Notify', source, QBCore.Shared.Items["smg_ammo"]["label"].. " gebruikt")
    end
end)

QBCore.Functions.CreateUseableItem("shotgun_ammo", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem("shotgun_ammo", 1, item.slot) then
        TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_SHOTGUN", 10)
        TriggerClientEvent('QBCore:Notify', source, QBCore.Shared.Items["shotgun_ammo"]["label"].. " gebruikt")
    end
end)

QBCore.Functions.CreateUseableItem("mg_ammo", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem("mg_ammo", 1, item.slot) then
        TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_MG", 30)
        TriggerClientEvent('QBCore:Notify', source, QBCore.Shared.Items["mg_ammo"]["label"].. " gebruikt")
    end
end)
