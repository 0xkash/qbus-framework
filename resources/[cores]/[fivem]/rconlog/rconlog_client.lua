local MaxPlayers = GetConvarInt('sv_maxclients', 32)

RegisterNetEvent('rlUpdateNames')
AddEventHandler('rlUpdateNames', function()
    local names = {}

    for i = 1, MaxPlayers do
        if NetworkIsPlayerActive(i) then
            names[GetPlayerServerId(i)] = { id = i, name = GetPlayerName(i) }
        end
    end

    TriggerServerEvent('rlUpdateNamesResult', names)
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('rlPlayerActivated')

			return
		end
	end
end)