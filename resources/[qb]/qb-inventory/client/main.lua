QBCore = nil
local inventoryTest = {}
local currentWeapon = nil
local Drops = {}
local ClosestDrop = {}

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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if Drops ~= nil and ClosestDrop ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Drops[ClosestDrop].coords.x, Drops[ClosestDrop].coords.y, Drops[ClosestDrop].coords.z, true) < 7.0 then
                DrawMarker(20, Drops[ClosestDrop].coords.x, Drops[ClosestDrop].coords.y, Drops[ClosestDrop].coords.z - 0.1, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 209, 165, 33, 100, false, true, 2, false, false, false, false)
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Drops[ClosestDrop].coords.x, Drops[ClosestDrop].coords.y, Drops[ClosestDrop].coords.z, true) < 2.0 then
                    QBCore.Functions.DrawText3D(Drops[ClosestDrop].coords.x, Drops[ClosestDrop].coords.y, Drops[ClosestDrop].coords.z, "[~g~H~w~] Drop")
                    if (IsControlJustReleased(0, Keys["H"])) then
                        TriggerServerEvent("inventory:server:OpenInventory", ClosestDrop)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        SetClosestDrop()
        Citizen.Wait(5000)
    end
end)

RegisterNetEvent("inventory:client:OpenInventory")
AddEventHandler("inventory:client:OpenInventory", function(inventory, other)
    if not IsEntityDead(GetPlayerPed(-1)) then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "open",
            inventory = inventory,
            slots = MaxInventorySlots,
            other = other,
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

RegisterNetEvent("inventory:client:AddDropItem")
AddEventHandler("inventory:client:AddDropItem", function(dropId, player)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local forward = GetEntityForwardVector(GetPlayerPed(-1))
	local x, y, z = table.unpack(coords + forward * 0.5)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent("inventory:client:DropItemAnim")
AddEventHandler("inventory:client:DropItemAnim", function()
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Citizen.Wait(7)
    end
    TaskPlayAnim(GetPlayerPed(-1), "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Citizen.Wait(2000)
    ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("inventory:server:UseItem", data.inventory, data.item)
end)

RegisterNUICallback("DropItem", function(data, cb)
    TriggerServerEvent("inventory:server:CreateDropItem", data.inventory, data.item, data.amount)
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

function SetClosestDrop()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local current = nil
	local lastdist = 0
	if Drops ~= nil then
		for id, drop in pairs(Drops) do
			if current ~= nil then 
				if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Drops[drop].coords.x, Drops[drop].coords.y, Drops[drop].coords.z, true) < lastdist then 
					current = id
					lastdist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Drops[drop].coords.x, Drops[drop].coords.y, Drops[drop].coords.z, true)
				end
			else
				current = id
			end
		end
		ClosestDrop = current
	end
end