QBCore = nil

Citizen.CreateThread(function() 
    while QBCore == nil then 
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

RegisterNetEvent("inventory:client:OpenInventory")
AddEventHandler("inventory:client:OpenInventory", function(inventory)
    if not IsEntityDead(GetPlayerPed(-1)) then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "open",
            items = inventory,
        })
    end
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    SetNuiFocus(false, false)
end)