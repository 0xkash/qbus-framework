QBCore = nil
local inventoryTest = {}

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
        if QBCore ~= nil then
            inventoryTest[1] = {name = QBCore.Shared.Items[83]["name"], amount = 2, info = "", label = QBCore.Shared.Items[83]["label"], description = QBCore.Shared.Items[83]["description"] ~= nil and QBCore.Shared.Items[83]["description"] or "", weight = QBCore.Shared.Items[83]["weight"], type = QBCore.Shared.Items[83]["type"], unique = QBCore.Shared.Items[83]["unique"], useable = QBCore.Shared.Items[83]["useable"], image = QBCore.Shared.Items[83]["image"]}
            inventoryTest[24] = {name = QBCore.Shared.Items[84]["name"], amount = 34, info = "", label = QBCore.Shared.Items[84]["label"], description = QBCore.Shared.Items[84]["description"] ~= nil and QBCore.Shared.Items[84]["description"] or "", weight = QBCore.Shared.Items[84]["weight"], type = QBCore.Shared.Items[84]["type"], unique = QBCore.Shared.Items[84]["unique"], useable = QBCore.Shared.Items[84]["useable"], image = QBCore.Shared.Items[84]["image"]}
            inventoryTest[4] = {name = QBCore.Shared.Items[81]["name"], amount = 69, info = "", label = QBCore.Shared.Items[81]["label"], description = QBCore.Shared.Items[81]["description"] ~= nil and QBCore.Shared.Items[81]["description"] or "", weight = QBCore.Shared.Items[81]["weight"], type = QBCore.Shared.Items[81]["type"], unique = QBCore.Shared.Items[81]["unique"], useable = QBCore.Shared.Items[81]["useable"], image = QBCore.Shared.Items[81]["image"]}
            inventoryTest[8] = {name = QBCore.Shared.Items[85]["name"], amount = 11, info = "", label = QBCore.Shared.Items[85]["label"], description = QBCore.Shared.Items[85]["description"] ~= nil and QBCore.Shared.Items[85]["description"] or "", weight = QBCore.Shared.Items[85]["weight"], type = QBCore.Shared.Items[85]["type"], unique = QBCore.Shared.Items[85]["unique"], useable = QBCore.Shared.Items[85]["useable"], image = QBCore.Shared.Items[85]["image"]}
            return false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if IsDisabledControlJustReleased(0, Keys["TAB"]) then
            TriggerEvent("inventory:client:OpenInventory")
        end
    end
end)

RegisterNetEvent("inventory:client:OpenInventory")
AddEventHandler("inventory:client:OpenInventory", function(inventory)
    if not IsEntityDead(GetPlayerPed(-1)) then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "open",
            items = inventoryTest,
            slots = MaxInventorySlots,
        })
    end
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    SetNuiFocus(false, false)
end)