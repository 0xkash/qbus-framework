QBCore = nil
local inventoryTest = {}

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
        Citizen.Wait(7)
        DisableControlAction(0, Keys["TAB"], true)
        if IsDisabledControlJustReleased(0, Keys["TAB"]) then
            TriggerServerEvent("inventory:server:OpenInventory")
        end
    end
end)

RegisterNetEvent("inventory:client:OpenInventory")
AddEventHandler("inventory:client:OpenInventory", function(inventory, otherinventory)
    if not IsEntityDead(GetPlayerPed(-1)) then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "open",
            inventory = inventory,
            slots = MaxInventorySlots,
            otherinventory = otherinventory,
            maxweight = QBCore.Config.Player.MaxWeight,
        })
    end
end)

RegisterNetEvent("inventory:client:UpdatePlayerInventory")
AddEventHandler("inventory:client:UpdatePlayerInventory", function(playerItems)
    SendNUIMessage({
        action = "update",
        items = playerItems,
        inventory = "player",
    })
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    SetNuiFocus(false, false)
end)