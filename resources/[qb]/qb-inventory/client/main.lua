QBCore = nil
local inventoryTest = {}
local currentWeapon = nil

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
        DisableControlAction(0, Keys["1"], true)
        DisableControlAction(0, Keys["2"], true)
        DisableControlAction(0, Keys["3"], true)
        DisableControlAction(0, Keys["4"], true)
        DisableControlAction(0, Keys["5"], true)
        if IsDisabledControlJustReleased(0, Keys["TAB"]) then
            TriggerServerEvent("inventory:server:OpenInventory")
        end

        if IsDisabledControlJustReleased(0, Keys["1"]) then
            TriggerServerEvent("inventory:server:UseItemSlot", 1)
        end

        if IsDisabledControlJustReleased(0, Keys["2"]) then
            TriggerServerEvent("inventory:server:UseItemSlot", 2)
        end

        if IsDisabledControlJustReleased(0, Keys["3"]) then
            TriggerServerEvent("inventory:server:UseItemSlot", 3)
        end

        if IsDisabledControlJustReleased(0, Keys["4"]) then
            TriggerServerEvent("inventory:server:UseItemSlot", 4)
        end

        if IsDisabledControlJustReleased(0, Keys["5"]) then
            TriggerServerEvent("inventory:server:UseItemSlot", 5)
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

RegisterNetEvent("inventory:client:UseWeapon")
AddEventHandler("inventory:client:UseWeapon", function(weaponName)
    local weaponName = tostring(weaponName)
    if currentWeapon == weaponName then
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey(currentWeapon))
        currentWeapon = nil
    else
        QBCore.Functions.TriggerCallback("weapon:server:GetWeaponAmmo", function(result)
            local ammo = tonumber(result)
            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponName), ammo, false, false)
            SetPedAmmo(GetPlayerPed(-1), GetHashKey(weaponName), ammo)
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(weaponName), true)
            currentWeapon = weaponName
        end, QBCore.Shared.Items[weaponName]["ammotype"])
    end
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("inventory:server:UseItem", data.inventory, data.item)
end)

RegisterNUICallback("SetInventoryData", function(data, cb)
    TriggerServerEvent("inventory:server:SetInventoryData", data.fromInventory, data.toInventory, data.fromSlot, data.toSlot, data.fromAmount, data.toAmount)
end)

RegisterNUICallback("PlayDropSound", function(data, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback("PlayDropFail", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)