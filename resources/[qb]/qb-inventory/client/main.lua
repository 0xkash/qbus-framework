QBCore = nil

inInventory = false
hotbarOpen = false

local inventoryTest = {}
local currentWeapon = nil
local currentOtherInventory = nil

local Drops = {}
local CurrentDrop = 0
local DropsNear = {}

local CurrentVehicle = nil
local CurrentGlovebox = nil
local CurrentStash = nil
local isCrafting = false

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
        DisableControlAction(0, Keys["TAB"], true)
        DisableControlAction(0, Keys["1"], true)
        DisableControlAction(0, Keys["2"], true)
        DisableControlAction(0, Keys["3"], true)
        DisableControlAction(0, Keys["4"], true)
        DisableControlAction(0, Keys["5"], true)
        if IsDisabledControlJustReleased(0, Keys["TAB"]) and not isCrafting then
            QBCore.Functions.GetPlayerData(function(PlayerData)
                if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] then
                    local curVeh = nil
                    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        CurrentGlovebox = GetVehicleNumberPlateText(vehicle)
                        curVeh = vehicle
                        CurrentVehicle = nil
                    else
                        local vehicle = QBCore.Functions.GetClosestVehicle()
                        if vehicle ~= 0 and vehicle ~= nil then
                            local pos = GetEntityCoords(GetPlayerPed(-1))
                            local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            end
                            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos) < 2.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                                if GetVehicleDoorLockStatus(vehicle) <= 2 then
                                    CurrentVehicle = GetVehicleNumberPlateText(vehicle)
                                    curVeh = vehicle
                                    CurrentGlovebox = nil
                                else
                                    QBCore.Functions.Notify("Voertuig staat op slot..", "error")
                                    return
                                end
                            else
                                CurrentVehicle = nil
                            end
                        else
                            CurrentVehicle = nil
                        end
                    end

                    if CurrentVehicle ~= nil then
                        local maxweight = 0
                        local slots = 0
                        if GetVehicleClass(curVeh) == 0 then
                            maxweight = 38000
                            slots = 30
                        elseif GetVehicleClass(curVeh) == 1 then
                            maxweight = 50000
                            slots = 40
                        elseif GetVehicleClass(curVeh) == 2 then
                            maxweight = 75000
                            slots = 50
                        elseif GetVehicleClass(curVeh) == 3 then
                            maxweight = 42000
                            slots = 35
                        elseif GetVehicleClass(curVeh) == 4 then
                            maxweight = 38000
                            slots = 30
                        elseif GetVehicleClass(curVeh) == 5 then
                            maxweight = 30000
                            slots = 25
                        elseif GetVehicleClass(curVeh) == 6 then
                            maxweight = 30000
                            slots = 25
                        elseif GetVehicleClass(curVeh) == 7 then
                            maxweight = 30000
                            slots = 25
                        elseif GetVehicleClass(curVeh) == 8 then
                            maxweight = 15000
                            slots = 15
                        elseif GetVehicleClass(curVeh) == 9 then
                            maxweight = 60000
                            slots = 35
                        else
                            maxweight = 60000
                            slots = 35
                        end
                        local other = {
                            maxweight = maxweight,
                            slots = slots,
                        }
                        TriggerServerEvent("inventory:server:OpenInventory", "trunk", CurrentVehicle, other)
                        OpenTrunk()
                    elseif CurrentGlovebox ~= nil then
                        TriggerServerEvent("inventory:server:OpenInventory", "glovebox", CurrentGlovebox)
                    elseif CurrentDrop ~= 0 then
                        TriggerServerEvent("inventory:server:OpenInventory", "drop", CurrentDrop)
                    else
                        TriggerServerEvent("inventory:server:OpenInventory")
                    end
                end
            end)
        end

        if IsControlJustPressed(0, Keys["Z"]) then
            ToggleHotbar(true)
        end

        if IsControlJustReleased(0, Keys["Z"]) then
            ToggleHotbar(false)
        end

        if IsDisabledControlJustReleased(0, Keys["1"]) then
            QBCore.Functions.GetPlayerData(function(PlayerData)
                if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] then
                    TriggerServerEvent("inventory:server:UseItemSlot", 1)
                end
            end)
        end

        if IsDisabledControlJustReleased(0, Keys["2"]) then
            QBCore.Functions.GetPlayerData(function(PlayerData)
                if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] then
                    TriggerServerEvent("inventory:server:UseItemSlot", 2)
                end
            end)
        end

        if IsDisabledControlJustReleased(0, Keys["3"]) then
            QBCore.Functions.GetPlayerData(function(PlayerData)
                if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] then
                    TriggerServerEvent("inventory:server:UseItemSlot", 3)
                end
            end)
        end

        if IsDisabledControlJustReleased(0, Keys["4"]) then
            QBCore.Functions.GetPlayerData(function(PlayerData)
                if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] then
                    TriggerServerEvent("inventory:server:UseItemSlot", 4)
                end
            end)
        end

        if IsDisabledControlJustReleased(0, Keys["5"]) then
            QBCore.Functions.GetPlayerData(function(PlayerData)
                if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] then
                    TriggerServerEvent("inventory:server:UseItemSlot", 5)
                end
            end)
        end
    end
end)

RegisterNetEvent('inventory:client:ItemBox')
AddEventHandler('inventory:client:ItemBox', function(itemData, type)
    SendNUIMessage({
        action = "itemBox",
        item = itemData,
        type = type
    })
end)

RegisterNetEvent('inventory:client:requiredItems')
AddEventHandler('inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k, v in pairs(items) do
            table.insert(itemTable, {
                item = items[k].name,
                label = QBCore.Shared.Items[items[k].name]["label"],
                image = items[k].image,
            })
        end
    end
    
    SendNUIMessage({
        action = "requiredItem",
        items = itemTable,
        toggle = bool
    })
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if DropsNear ~= nil then
            for k, v in pairs(DropsNear) do
                if DropsNear[k] ~= nil then
                    DrawMarker(20, v.coords.x, v.coords.y, v.coords.z - 0.1, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 209, 165, 33, 100, false, true, 2, false, false, false, false)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if Drops ~= nil and next(Drops) ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
            for k, v in pairs(Drops) do
                if Drops[k] ~= nil then 
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 7.5 then
                        DropsNear[k] = v
                        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 2 then
                            CurrentDrop = k
                        else
                            CurrentDrop = nil
                        end
                    else
                        DropsNear[k] = nil
                    end
                end
            end
        else
            DropsNear = {}
        end
        Citizen.Wait(500)
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    --TriggerServerEvent("inventory:server:LoadDrops")
end)

RegisterNetEvent("inventory:client:OpenInventory")
AddEventHandler("inventory:client:OpenInventory", function(inventory, other)
    if not IsEntityDead(GetPlayerPed(-1)) then
        ToggleHotbar(false)
        SetNuiFocus(true, true)
        if other ~= nil then
            currentOtherInventory = other.name
        end
        SendNUIMessage({
            action = "open",
            inventory = inventory,
            slots = MaxInventorySlots,
            other = other,
            maxweight = QBCore.Config.Player.MaxWeight,
        })
        inInventory = true
        --SetTimecycleModifier('hud_def_blur')
    end
end)

RegisterNetEvent("inventory:client:ShowTrunkPos")
AddEventHandler("inventory:client:ShowTrunkPos", function()
    showTrunkPos = true
end)

RegisterNetEvent("inventory:client:UpdatePlayerInventory")
AddEventHandler("inventory:client:UpdatePlayerInventory", function(isError)
    SendNUIMessage({
        action = "update",
        inventory = QBCore.Functions.GetPlayerData().items,
        maxweight = QBCore.Config.Player.MaxWeight,
        slots = MaxInventorySlots,
        error = isError,
    })
end)

RegisterNetEvent("inventory:client:CraftItems")
AddEventHandler("inventory:client:CraftItems", function(itemName, itemCosts, amount, toSlot, points)
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    QBCore.Functions.Progressbar("repair_vehicle", "Bezig met craften..", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:CraftItems", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemName], 'add')
        isCrafting = false
	end, function() -- Cancel
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
        QBCore.Functions.Notify("Mislukt!", "error")
        isCrafting = false
	end)
end)

RegisterNetEvent("inventory:client:PickupSnowballs")
AddEventHandler("inventory:client:PickupSnowballs", function()
    RequestAnimDict('anim@mp_snowball')
    TaskPlayAnim(GetPlayerPed(-1), 'anim@mp_snowball', 'pickup_snowball', 3.0, 3.0, -1, 0, 1, 0, 0, 0)
    QBCore.Functions.Progressbar("pickupsnowball", "Sneeuwballen oprapen..", 1500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(GetPlayerPed(-1))
        TriggerServerEvent('QBCore:Server:AddItem', "snowball", math.random(1, 5))
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["snowball"], "add")
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        QBCore.Functions.Notify("Geannuleerd..", "error")
    end)
end)

RegisterNetEvent("inventory:client:UseSnowball")
AddEventHandler("inventory:client:UseSnowball", function(amount)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_snowball"), amount, false, false)
    SetPedAmmo(GetPlayerPed(-1), GetHashKey("weapon_snowball"), amount)
    SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("weapon_snowball"), true)
end)

RegisterNetEvent("inventory:client:UseWeapon")
AddEventHandler("inventory:client:UseWeapon", function(weaponData)
    local weaponName = tostring(weaponData.name)
    if currentWeapon == weaponName then
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(GetPlayerPed(-1), true)
        currentWeapon = nil
    elseif weaponName == "weapon_stickybomb" then
        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponName), ammo, false, false)
        SetPedAmmo(GetPlayerPed(-1), GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(weaponName), true)
        TriggerServerEvent('QBCore:Server:RemoveItem', weaponName, 1)
        currentWeapon = weaponName
    elseif weaponName == "weapon_snowball" then
        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponName), ammo, false, false)
        SetPedAmmo(GetPlayerPed(-1), GetHashKey(weaponName), 10)
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(weaponName), true)
        TriggerServerEvent('QBCore:Server:RemoveItem', weaponName, 1)
        currentWeapon = weaponName
    else
        QBCore.Functions.TriggerCallback("weapon:server:GetWeaponAmmo", function(result)
            local ammo = tonumber(result)
            if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then ammo = 4000 end
            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponName), ammo, false, false)
            SetPedAmmo(GetPlayerPed(-1), GetHashKey(weaponName), ammo)
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(weaponName), true)
            if weaponData.info.attachments ~= nil then
                for _, attachment in pairs(weaponData.info.attachments) do
                    GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(weaponName), GetHashKey(attachment.component))
                end
            end
            currentWeapon = weaponName
        end, QBCore.Shared.Items[weaponName]["ammotype"])
    end
end)

RegisterNetEvent("inventory:client:CheckWeapon")
AddEventHandler("inventory:client:CheckWeapon", function(weaponName)
    if currentWeapon == weaponName then 
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(GetPlayerPed(-1), true)
        currentWeapon = nil
    end
end)

RegisterNetEvent("inventory:client:AddDropItem")
AddEventHandler("inventory:client:AddDropItem", function(dropId, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(player)))
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
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        local gender = "Man"
        if character.gender == 1 then
            gender = "Vrouw"
        end
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>BSN:</strong> {1} <br><strong>Voornaam:</strong> {2} <br><strong>Achternaam:</strong> {3} <br><strong>Geboortedag:</strong> {4} <br><strong>Geslacht:</strong> {5} <br><strong>Nationaliteit:</strong> {6}</div></div>',
            args = {'ID-kaart', citizenid, character.firstname, character.lastname, character.birthdate, gender, character.nationality}
        })
    end
end)

RegisterNetEvent("inventory:client:ShowDriverLicense")
AddEventHandler("inventory:client:ShowDriverLicense", function(sourceId, citizenid, character)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Voornaam:</strong> {1} <br><strong>Achternaam:</strong> {2} <br><strong>Geboortedag:</strong> {3} <br><strong>Rijbwijzen:</strong> {4}</div></div>',
            args = {'Rijbewijs', character.firstname, character.lastname, character.birthdate, character.type}
        })
    end
end)

RegisterNetEvent("inventory:client:SetCurrentStash")
AddEventHandler("inventory:client:SetCurrentStash", function(stash)
    CurrentStash = stash
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(QBCore.Shared.Items[data.item])
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    if currentOtherInventory == "none-inv" then
        CurrentDrop = 0
        CurrentVehicle = nil
        CurrentGlovebox = nil
        CurrentStash = nil
        SetNuiFocus(false, false)
        inInventory = false
        ClearPedTasks(GetPlayerPed(-1))
        return
    end
    if CurrentVehicle ~= nil then
        CloseTrunk()
        TriggerServerEvent("inventory:server:SaveInventory", "trunk", CurrentVehicle)
        CurrentVehicle = nil
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
        CurrentGlovebox = nil
    elseif CurrentStash ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "stash", CurrentStash)
        CurrentStash = nil
    else
        TriggerServerEvent("inventory:server:SaveInventory", "drop", CurrentDrop)
        CurrentDrop = 0
    end
    SetNuiFocus(false, false)
    inInventory = false
    TransitionFromBlurred(250)
end)

RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("inventory:server:UseItem", data.inventory, data.item)
end)

RegisterNUICallback("combineItem", function(data)
    TriggerServerEvent('inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
    Citizen.Wait(100)
    SendNUIMessage({
        action = "update",
        inventory = QBCore.Functions.GetPlayerData().items,
        maxweight = QBCore.Config.Player.MaxWeight,
    })
end)

RegisterNUICallback('combineWithAnim', function(data)
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    local animText = combineData.anim.text
    local animTimeout = combineData.anim.timeOut

    QBCore.Functions.Progressbar("combine_anim", animText, animTimeout, false, true, {
        disableMovement = false,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = aDict,
        anim = aLib,
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), aDict, aLib, 1.0)
        TriggerServerEvent('inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[combineData.reward], 'add')
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), aDict, aLib, 1.0)
        QBCore.Functions.Notify("Mislukt!", "error")
    end)
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

function ToggleHotbar(toggle)
    local HotbarItems = {
        [1] = QBCore.Functions.GetPlayerData().items[1],
        [2] = QBCore.Functions.GetPlayerData().items[2],
        [3] = QBCore.Functions.GetPlayerData().items[3],
        [4] = QBCore.Functions.GetPlayerData().items[4],
        [5] = QBCore.Functions.GetPlayerData().items[5],
    } 

    if toggle then
        SendNUIMessage({
            action = "toggleHotbar",
            open = true,
            items = HotbarItems
        })
    else
        SendNUIMessage({
            action = "toggleHotbar",
            open = false,
        })
    end
end