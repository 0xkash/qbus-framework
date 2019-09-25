QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local ServerStatus = {
    closed = false,
    reason = nil,
}

RegisterServerEvent("qbadmin:server:CloseServer")
AddEventHandler('qbadmin:server:CloseServer', function(reason)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.permission == "admin" or Player.PlayerData.permission == "god" then 
        local reason = reason ~= nil and reason or "Geen reden opgegeven..."
        ServerStatus.closed = true
        ServerStatus.reason = reason
        TriggerClientEvent("qbadmin:client:SetServerStatus", -1, true)
    else
        DropPlayer(src, "Je hebt hier geen permissie voor loser..")
    end
end)

RegisterServerEvent("qbadmin:server:OpenServer")
AddEventHandler('qbadmin:server:OpenServer', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.permission == "admin" or Player.PlayerData.permission == "god" then
        ServerStatus.closed = false
        TriggerClientEvent("qbadmin:client:SetServerStatus", -1, false)
    else
        DropPlayer(src, "Je hebt hier geen permissie voor loser..")
    end
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	deferrals.defer()
	local src = source
	deferrals.update("\nChecking server status...")
	local name = GetPlayerName(src)
    if (ServerStatus.closed and not IsPlayerAceAllowed(src, "qbadmin.join")) then
        KickPlayer(src, 'De server is gesloten: \n '..ServerStatus.reason, setKickReason, deferrals)
        CancelEvent()
        return false
    end
    deferrals.done()
end)

function KickPlayer(source, reason, setKickReason, deferrals)
	local src = source
	reason = "\n"..reason.."\n🔸 Kijk op onze discord voor meer informatie: discord"
	Citizen.CreateThread(function()
		if(deferrals ~= nil)then
			deferrals.update(reason)
			Citizen.Wait(2500)
		end
		DropPlayer(src, reason)
		local i = 0
		while (i <= 4) do
			i = i + 1
			while true do
				if(GetPlayerPing(src) >= 0) then
					break
				end
				Citizen.Wait(100)
				Citizen.CreateThread(function() 
					DropPlayer(src, reason)
				end)
			end
			Citizen.Wait(5000)
		end
	end)
end