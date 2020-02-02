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
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            if v ~= src then 
                DropPlayer(v, "Je bent gekicked uit de server:\n"..reason.."\n\n🔸 Kijk op onze discord voor meer informatie: https://discord.gg/Ttr6fY6")
            end
        end
    end
end)

local suffix = {
    "hihi",
    "#yolo",
    "hmm slurpie",
    "yeet terug naar esx",
}

RegisterServerEvent('qb-admin:server:banPlayer')
AddEventHandler('qb-admin:server:banPlayer', function(playerId, time, reason)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions["ban"]) then
        local time = tonumber(time)
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end
        local timeTable = os.date("*t", banTime)
        TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", GetPlayerName(playerId).." is verbannen voor: "..reason.." "..suffix[math.random(1, #suffix)])
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(playerId).."', '"..GetPlayerIdentifiers(playerId)[1].."', '"..GetPlayerIdentifiers(playerId)[2].."', '"..GetPlayerIdentifiers(playerId)[3].."', '"..GetPlayerIdentifiers(playerId)[4].."', '"..reason.."', "..banTime..", '"..GetPlayerName(src).."')")
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

    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-admin:client:SendReport', -1, GetPlayerName(source), source, msg)
    TriggerClientEvent('chatMessage', source, "REPORT VERSTUURD", "normal", msg)
    TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {message=msg})
end)

QBCore.Commands.Add("staffchat", "Bericht naar alle staff sturen", {{name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('qb-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

QBCore.Commands.Add("s", "Bericht naar alle staff sturen", {{name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('qb-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

QBCore.Commands.Add("warn", "Geef een persoon een waarschuwing", {{name="ID", help="Persoon"}, {name="Reden", help="Vul een reden in"}}, true, function(source, args)
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local senderPlayer = QBCore.Functions.GetPlayer(source)
    table.remove(args, 1)
    local msg = table.concat(args, " ")

    local myName = senderPlayer.PlayerData.name

    local warnId = "WARN-"..math.random(1111, 9999)

    if targetPlayer ~= nil then
        TriggerClientEvent('chatMessage', targetPlayer.PlayerData.source, "SYSTEM", "error", "Je bent gewaarschuwd door: "..GetPlayerName(source)..", Reden: "..msg)
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt "..GetPlayerName(targetPlayer.PlayerData.source).." gewaarschuwd voor: "..msg)
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_warns` (`senderIdentifier`, `targetIdentifier`, `reason`, `warnId`) VALUES ('"..senderPlayer.PlayerData.steam.."', '"..targetPlayer.PlayerData.steam.."', '"..msg.."', '"..warnId.."')")
    else
        TriggerClientEvent('QBCore:Notify', source, 'Dit persoon is niet in de stad #YOLO, hmm ik ben '..myName..' en ik stink loloololo', 'error')
    end 
end, "admin")

QBCore.Commands.Add("checkwarns", "Geef een persoon een waarschuwing", {{name="ID", help="Persoon"}, {name="Warning", help="Nummer van waarschuwing, (1, 2 of 3 etc..)"}}, false, function(source, args)
    if args[2] == nil then
        local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(result)
            print(json.encode(result))
            TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", targetPlayer.PlayerData.name.." heeft "..tablelength(result).." waarschuwingen!")
        end)
    else
        local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))

        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
            local selectedWarning = tonumber(args[2])

            if warnings[selectedWarning] ~= nil then
                local sender = QBCore.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

                TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", targetPlayer.PlayerData.name.." is gewaarschuwd door "..sender.PlayerData.name..", Reden: "..warnings[selectedWarning].reason)
            end
        end)
    end
end, "admin")

QBCore.Commands.Add("verwijderwarn", "Verwijder waarschuwing van persoon", {{name="ID", help="Persoon"}, {name="Warning", help="Nummer van waarschuwing, (1, 2 of 3 etc..)"}}, true, function(source, args)
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
        local selectedWarning = tonumber(args[2])

        if warnings[selectedWarning] ~= nil then
            local sender = QBCore.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

            TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Je hebt waarschuwing ("..selectedWarning..") verwijderd, Reden: "..warnings[selectedWarning].reason)
            QBCore.Functions.ExecuteSql(false, "DELETE FROM `player_warns` WHERE `warnId` = '"..warnings[selectedWarning].warnId.."'")
        end
    end)
end, "admin")

function tablelength(table)
    local count = 0
    for _ in pairs(table) do 
        count = count + 1 
    end
    return count
end

QBCore.Commands.Add("reportr", "Reply op een report", {}, false, function(source, args)
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, " ")
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    local Player = QBCore.Functions.GetPlayer(source)
    if OtherPlayer ~= nil then
        TriggerClientEvent('chatMessage', playerId, "ADMIN - "..GetPlayerName(source), "warning", msg)
        TriggerClientEvent('QBCore:Notify', source, "Reactie gestuurd")
        TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {otherCitizenId=OtherPlayer.PlayerData.citizenid, message=msg})
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            if QBCore.Functions.HasPermission(v, "admin") then
                if QBCore.Functions.IsOptin(v) then
                    TriggerClientEvent('chatMessage', v, "ReportReply("..source..") - "..GetPlayerName(source), "warning", msg)
                end
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "Persoon is niet online", "error")
    end
end, "admin")

QBCore.Commands.Add("admincar", "Plaats voertuig in je garage", {}, false, function(source, args)
    local ply = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-admin:client:SaveCar', source)
end, "admin")

RegisterServerEvent('qb-admin:server:SaveCar')
AddEventHandler('qb-admin:server:SaveCar', function(mods, vehicle, hash, plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] == nil then
            QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicle.model.."', '"..vehicle.hash.."', '"..json.encode(mods).."', '"..plate.."', 0)")
            TriggerClientEvent('QBCore:Notify', src, 'Het voertuig staat nu op je naam!', 'success', 5000)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Dit voertuig staat al in je garage..', 'error', 3000)
        end
    end)
end)

QBCore.Commands.Add("reporttoggle", "Toggle inkomende reports uit of aan", {}, false, function(source, args)
    QBCore.Functions.ToggleOptin(source)
    if QBCore.Functions.IsOptin(source) then
        TriggerClientEvent('QBCore:Notify', source, "Je krijgt WEL reports", "success")
    else
        TriggerClientEvent('QBCore:Notify', source, "Je krijgt GEEN reports", "error")
    end
end, "admin")

RegisterCommand("kickall", function(source, args, rawCommand)
    local src = source
    
    if src > 0 then
        local reason = table.concat(args, ' ')
        local Player = QBCore.Functions.GetPlayer(src)

        if QBCore.Functions.HasPermission(src, "god") then
            if args[1] ~= nil then
                for k, v in pairs(QBCore.Functions.GetPlayers()) do
                    local Player = QBCore.Functions.GetPlayer(v)
                    if Player ~= nil then 
                        DropPlayer(Player.PlayerData.source, reason)
                    end
                end
            else
                TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Geef een reden op..')
            end
        else
            TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Dit kan jij niet zomaar doen kindje..')
        end
    else
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(v)
            if Player ~= nil then 
                DropPlayer(Player.PlayerData.source, "Server restart, kijk op discord voor meer informatie! (discord.gg/KeHgZcZ)")
            end
        end
    end
end, false)

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

RegisterServerEvent('qb-admin:server:SendReport')
AddEventHandler('qb-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    local Players = QBCore.Functions.GetPlayers()

    if QBCore.Functions.HasPermission(src, "admin") then
        if QBCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "REPORT - "..name.." ("..targetSrc..")", "report", msg)
        end
    end
end)

RegisterServerEvent('qb-admin:server:StaffChatMessage')
AddEventHandler('qb-admin:server:StaffChatMessage', function(name, msg)
    local src = source
    local Players = QBCore.Functions.GetPlayers()

    if QBCore.Functions.HasPermission(src, "admin") then
        if QBCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "STAFFCHAT - "..name, "error", msg)
        end
    end
end)