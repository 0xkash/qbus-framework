QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local permissions = {
    ["kick"] = "admin",
    ["ban"] = "admin",
    ["noclip"] = "admin",
    ["kickall"] = "admin",
}

RegisterServerEvent('qb-admin:server:togglePlayerNoclip')
AddEventHandler('qb-admin:server:togglePlayerNoclip', function(playerId, reason)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("qb-admin:client:toggleNoclip", playerId)
    end
end)

RegisterServerEvent('qb-admin:server:killPlayer')
AddEventHandler('qb-admin:server:killPlayer', function(playerId)
    TriggerClientEvent('hospital:client:KillPlayer', playerId)
end)

RegisterServerEvent('qb-admin:server:kickPlayer')
AddEventHandler('qb-admin:server:kickPlayer', function(playerId, reason)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions["kick"]) then
        DropPlayer(playerId, "Je bent gekicked uit de server:\n"..reason.."\n\n🔸 Kijk op onze discord voor meer informatie: https://discord.gg/Ttr6fY6")
    end
end)

RegisterServerEvent('qb-admin:server:Freeze')
AddEventHandler('qb-admin:server:Freeze', function(playerId, toggle)
    TriggerClientEvent('qb-admin:client:Freeze', playerId, toggle)
end)

RegisterServerEvent('qb-admin:server:serverKick')
AddEventHandler('qb-admin:server:serverKick', function(reason)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions["kickall"]) then
        local players = QBCore.Functions.GetPlayers()
        for k, Player in pairs(players) do
            if k ~= src then 
                DropPlayer(k, "Je bent gekicked uit de server:\n"..reason.."\n\n🔸 Kijk op onze discord voor meer informatie: https://discord.gg/Ttr6fY6")
            end
        end
    end
end)

RegisterServerEvent('qb-admin:server:banPlayer')
AddEventHandler('qb-admin:server:banPlayer', function(playerId, time, reason)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions["ban"]) then
        local time = tonumber(time)
        local banTime = tonumber(os.time() + time)----
        local timeTable = os.date("*t", banTime)
        QBCore.Functions.ExecuteSql("INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`) VALUES ('"..GetPlayerName(playerId).."', '"..GetPlayerIdentifiers(playerId)[1].."', '"..GetPlayerIdentifiers(playerId)[2].."', '"..GetPlayerIdentifiers(playerId)[3].."', '"..GetPlayerIdentifiers(playerId)[4].."', '"..reason.."', "..banTime..")")
        DropPlayer(playerId, "Je bent verbannen van de server:\n"..reason.."\n\nJe ban verloopt "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\n🔸 Kijk op onze discord voor meer informatie: https://discord.gg/Ttr6fY6")
    end
end)

RegisterServerEvent('qb-admin:server:revivePlayer')
AddEventHandler('qb-admin:server:revivePlayer', function(target)
	TriggerClientEvent('hospital:client:Revive', target)
end)

QBCore.Commands.Add("announce", "Stuur een bericht naar iedereen", {}, false, function(source, args)
    local msg = table.concat(args, " ")
    for i = 1, 3, 1 do
        TriggerClientEvent('chatMessage', -1, "SYSTEM", "error", msg)
    end
end, "admin")

QBCore.Commands.Add("admin", "Open admin menu", {}, false, function(source, args)
    local group = QBCore.Functions.GetPermission(source)
    TriggerClientEvent('qb-admin:client:openMenu', source, group)
end, "admin")

QBCore.Commands.Add("report", "Stuur een report naar admins (alleen wanneer nodig, MAAK HIER GEEN MISBRUIK VAN)", {{name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local msg = table.concat(args, " ")
    local players = QBCore.Functions.GetPlayers()

	for k, Player in pairs(players) do
        if QBCore.Functions.HasPermission(k, "god") then
            if QBCore.Config.Server.PermissionList[GetPlayerIdentifiers(k)[1]].optin then 
                TriggerClientEvent('chatMessage', k, "REPORT - " .. GetPlayerName(source) .. " ("..source..")", "report", msg)
            end
		end
    end
    TriggerClientEvent('chatMessage', source, "REPORT VERSTUURD", "normal", msg)
end)

QBCore.Commands.Add("reportr", "Toggle inkomende reports uit of aan", {}, false, function(source, args)
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, " ")
    TriggerClientEvent('chatMessage', playerId, "ADMIN - "..GetPlayerName(source), "warning", msg)
    TriggerClientEvent('QBCore:Notify', source, "Reactie gestuurd")
end, "admin")

QBCore.Commands.Add("reporttoggle", "Toggle inkomende reports uit of aan", {}, false, function(source, args)
    local identifier = GetPlayerIdentifiers(source)[1]
    local optin = QBCore.Config.Server.PermissionList[identifier].optin
    QBCore.Config.Server.PermissionList[identifier].optin = not optin
    if QBCore.Config.Server.PermissionList[identifier].optin then
        TriggerClientEvent('QBCore:Notify', source, "Je krijgt WEL reports", "success")
    else
        TriggerClientEvent('QBCore:Notify', source, "Je krijgt GEEN reports", "error")
    end
end, "admin")

RegisterServerEvent('qb-admin:server:bringTp')
AddEventHandler('qb-admin:server:bringTp', function(targetId, coords)
    TriggerClientEvent('qb-admin:client:bringTp', targetId, coords)
end)

QBCore.Functions.CreateCallback('qb-admin:server:hasPermissions', function(source, cb, group)
    local src = source
    local retval = false

    if QBCore.Functions.HasPermission(src, group) then
        retval = true
    end
    cb(retval)
end)

RegisterServerEvent('qb-admin:server:setPermissions')
AddEventHandler('qb-admin:server:setPermissions', function(targetId, group)
    QBCore.Functions.AddPermission(targetId, group.rank)
    TriggerClientEvent('QBCore:Notify', targetId, 'Je permissie groep is gezet naar '..group.label)
end)

RegisterServerEvent('qb-admin:server:OpenSkinMenu')
AddEventHandler('qb-admin:server:OpenSkinMenu', function(targetId)
    TriggerClientEvent("qb-clothing:client:openMenu", targetId)
end)