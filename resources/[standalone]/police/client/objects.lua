local ObjectList = {}

RegisterNetEvent('police:client:spawnCone')
AddEventHandler('police:client:spawnCone', function()
    QBCore.Functions.Progressbar("spawn_object", "Object plaatsen..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("police:server:spawnObject", "cone")
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        QBCore.Functions.Notify("Geannuleerd..", "error")
    end)
end)

RegisterNetEvent('police:client:spawnBarier')
AddEventHandler('police:client:spawnBarier', function()
    QBCore.Functions.Progressbar("spawn_object", "Object plaatsen..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("police:server:spawnObject", "barier")
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        QBCore.Functions.Notify("Geannuleerd..", "error")
    end)
end)

RegisterNetEvent('police:client:spawnSchotten')
AddEventHandler('police:client:spawnSchotten', function()
    QBCore.Functions.Progressbar("spawn_object", "Object plaatsen..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("police:server:spawnObject", "schotten")
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        QBCore.Functions.Notify("Geannuleerd..", "error")
    end)
end)

RegisterNetEvent('police:client:spawnTent')
AddEventHandler('police:client:spawnTent', function()
    QBCore.Functions.Progressbar("spawn_object", "Object plaatsen..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("police:server:spawnObject", "tent")
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        QBCore.Functions.Notify("Geannuleerd..", "error")
    end)
end)

RegisterNetEvent('police:client:spawnLight')
AddEventHandler('police:client:spawnLight', function()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    QBCore.Functions.Progressbar("spawn_object", "Object plaatsen..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("police:server:spawnObject", "light")
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        QBCore.Functions.Notify("Geannuleerd..", "error")
    end)
end)

RegisterNetEvent('police:client:deleteObject')
AddEventHandler('police:client:deleteObject', function()
    if PlayerJob.name == "police" then 
        local objectId, dist = GetClosestPoliceObject()
        if dist < 5.0 then
            QBCore.Functions.Progressbar("remove_object", "Object verwijderen..", 2500, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
                anim = "plant_floor",
                flags = 16,
            }, {}, {}, function() -- Done
                StopAnimTask(GetPlayerPed(-1), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
                TriggerServerEvent("police:server:deleteObject", objectId)
            end, function() -- Cancel
                StopAnimTask(GetPlayerPed(-1), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
                QBCore.Functions.Notify("Geannuleerd..", "error")
            end)
        end
    end
end)

RegisterNetEvent('police:client:removeObject')
AddEventHandler('police:client:removeObject', function(objectId)
    if PlayerJob.name == "police" then 
        DeleteObject(ObjectList[objectId].object)
        ObjectList[objectId] = nil
    end
end)

RegisterNetEvent('police:client:spawnObject')
AddEventHandler('police:client:spawnObject', function(objectId, type, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local heading = GetEntityHeading(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(GetPlayerPed(-1))
    local x, y, z = table.unpack(coords + forward * 0.5)
    local spawnedObj = CreateObject(Config.Objects[type].model, x, y, z, false, false, false)
    PlaceObjectOnGroundProperly(spawnedObj)
    SetEntityHeading(spawnedObj, heading)
    FreezeEntityPosition(spawnedObj, Config.Objects[type].freeze)
    if PlayerJob.name == "police" then 
        ObjectList[objectId] = {
            id = objectId,
            object = spawnedObj,
            coords = {
                x = x,
                y = y,
                z = z - 0.3,
            },
        }
    end
end)

function GetClosestPoliceObject()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil

    for id, data in pairs(ObjectList) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true)
            current = id
        end
    end
    return current, dist
end