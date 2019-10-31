QBCore = nil

inInventory = false

local inventoryTest = {}
local currentWeapon = nil

local Drops = {}
local CurrentDrop = 0
local DropsNear = {}

local CurrentVehicle = nil
local showTrunkPos = false

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
        if showTrunkPos and not inInventory then
            local vehicle = QBCore.Functions.GetClosestVehicle()
            if vehicle ~= 0 and vehicle ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                local vehpos = GetEntityCoords(vehicle)
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 5.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                    local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                    if (IsBackEngine(GetEntityModel(vehicle))) then
                        drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                    end
                    QBCore.Functions.DrawText3D(drawpos.x, drawpos.y, drawpos.z, "Kofferbak")
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, drawpos) < 2.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                        CurrentVehicle = GetVehicleNumberPlateText(vehicle)
                        showTrunkPos = false
                    end
                else
                    showTrunkPos = false
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if QBCore ~= nil and not inInventory then
            
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
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                CurrentVehicle = GetVehicleNumberPlateText(vehicle)
            else
                local vehicle = QBCore.Functions.GetClosestVehicle()
                if vehicle ~= 0 and vehicle ~= nil then
                    local pos = GetEntityCoords(GetPlayerPed(-1))
                    local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                    if (IsBackEngine(GetEntityModel(vehicle))) then
                        trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                    end
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos) < 2.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                        CurrentVehicle = GetVehicleNumberPlateText(vehicle)
                    else
                        CurrentVehicle = nil
                    end
                else
                    CurrentVehicle = nil
                end
            end

            if CurrentVehicle ~= nil then
                if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                    TriggerServerEvent("inventory:server:OpenInventory", "glovebox", CurrentVehicle)
                else
                    TriggerServerEvent("inventory:server:OpenInventory", "trunk", CurrentVehicle)
                    OpenTrunk()
                end
            elseif CurrentDrop ~= 0 then
                TriggerServerEvent("inventory:server:OpenInventory", "drop", CurrentDrop)
            else
                TriggerServerEvent("inventory:server:OpenInventory")
            end
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
        Citizen.Wait(1)
        if DropsNear ~= nil then
            for k, v in pairs(DropsNear) do
                if v ~= nil then
                    DrawMarker(20, v.coords.x, v.coords.y, v.coords.z - 0.1, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 209, 165, 33, 100, false, true, 2, false, false, false, false)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if next(Drops) ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
            for k, v in pairs(Drops) do
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 7.5 then
                    DropsNear[k] = v
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 1.5 then
                        CurrentDrop = k
                    else
                        CurrentDrop = nil
                    end
                else
                    DropsNear[k] = nil
                end
            end
        else
            DropsNear = {}
        end
        Citizen.Wait(1000)
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
        inInventory = true
        SetTimecycleModifier('hud_def_blur')
    end
end)

RegisterNetEvent("inventory:client:ShowTrunkPos")
AddEventHandler("inventory:client:ShowTrunkPos", function()
    showTrunkPos = true
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
            if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then ammo = 4000 end
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

RegisterNetEvent("inventory:client:RemoveDropItem")
AddEventHandler("inventory:client:RemoveDropItem", function(dropId)
    Drops[dropId] = nil
    CurrentDrop = 0
end)

RegisterNetEvent("inventory:client:DropItemAnim")
AddEventHandler("inventory:client:DropItemAnim", function()
    SendNUIMessage({
        action = "close",
    })
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Citizen.Wait(7)
    end
    TaskPlayAnim(GetPlayerPed(-1), "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Citizen.Wait(2000)
    ClearPedTasks(GetPlayerPed(-1))
end)


RegisterNetEvent("inventory:client:ShowId")
AddEventHandler("inventory:client:ShowId", function(sourceId, citizenid, character)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    
    print(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true))
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        local gender = "Man"
        if character.gender == 1 then
            gender = "Vrouw"
        end
        TriggerEvent("chatMessage", "BSN", "advert", citizenid)
        TriggerEvent("chatMessage", "Voornaam", "advert", character.firstname)
        TriggerEvent("chatMessage", "Achternaam", "advert", character.lastname)
        TriggerEvent("chatMessage", "Geboortedatum", "advert", character.birthdate)
        TriggerEvent("chatMessage", "Geslacht", "advert", gender)
        TriggerEvent("chatMessage", "Nationaliteit", "advert", character.nationality)
    end
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    if CurrentVehicle ~= nil then
        CloseTrunk()
    end
    SetNuiFocus(false, false)
    inInventory = false
    SetTimecycleModifier('default')
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

function OpenTrunk()
    local vehicle = QBCore.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

function CloseTrunk()
    local vehicle = QBCore.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
end

function IsBackEngine(vehModel)
    for _, model in pairs(BackEngineVehicles) do
        if GetHashKey(model) == vehModel then
            return true
        end
    end
    return false
end