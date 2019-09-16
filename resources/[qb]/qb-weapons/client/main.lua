QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

Citizen.CreateThread(function() 
    while true do
        TriggerServerEvent("weapons:server:SaveWeaponAmmo")
        Citizen.Wait(((1000 * 60) * 5))
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if IsPedShooting(GetPlayerPed(-1)) then
            local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
            local ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), weapon)
            TriggerServerEvent("weapons:server:UpdateWeaponAmmo", QBCore.Shared.Weapons[weapon]["ammotype"], tonumber(ammo))
        end
    end 
end)

RegisterNetEvent('weapon:client:AddAmmo')
AddEventHandler('weapon:client:AddAmmo', function(type, amount)
    local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    if QBCore.Shared.Weapons[weapon]["ammotype"] == type:upper() then
        local total = (GetAmmoInPedWeapon(GetPlayerPed(-1), weapon) + amount)
        SetPedAmmo(GetPlayerPed(-1), weapon, total)
    end
    TriggerServerEvent("weapons:server:AddWeaponAmmo", type, amount)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	TriggerServerEvent("weapons:server:LoadWeaponAmmo")
end)