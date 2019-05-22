-- Player joined
RegisterServerEvent("QBCore:PlayerJoined")
AddEventHandler('QBCore:PlayerJoined', function()
	local src = source
	if QBCore.Player.Login(src) then
		QBCore.ShowSuccess(GetCurrentResourceName(), GetPlayerName(source).." LOADED!")
	end
	--TriggerClientEvent('QBCore:OnPlayerJoined')
end)