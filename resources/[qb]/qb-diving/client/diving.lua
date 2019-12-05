local CurrentDivingLocation = {
    Area = 0,
    Blip = {
        Radius = nil,
        Label = nil
    }
}

RegisterNetEvent('qb-diving:client:NewLocations')
AddEventHandler('qb-diving:client:NewLocations', function()
    QBCore.Functions.TriggerCallback('qb-diving:server:GetDivingConfig', function(Config, Area)
        QBDiving.Locations = Config
        TriggerEvent('qb-diving:client:SetDivingLocation', Area)
    end)
end)

RegisterNetEvent('qb-diving:client:SetDivingLocation')
AddEventHandler('qb-diving:client:SetDivingLocation', function(DivingLocation)
    CurrentDivingLocation.Area = DivingLocation

    for _,Blip in pairs(CurrentDivingLocation.Blip) do
        if Blip ~= nil then
            RemoveBlip(Blip)
        end
    end
    
    Citizen.CreateThread(function()
        RadiusBlip = AddBlipForRadius(QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.z, 100.0)
        
        SetBlipRotation(RadiusBlip, 0)
        SetBlipColour(RadiusBlip, 47)

        CurrentDivingLocation.Blip.Radius = RadiusBlip

        LabelBlip = AddBlipForCoord(QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.z)

        SetBlipSprite (LabelBlip, 597)
        SetBlipDisplay(LabelBlip, 4)
        SetBlipScale  (LabelBlip, 0.7)
        SetBlipColour(LabelBlip, 0)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Duikgebied')
        EndTextCommandSetBlipName(LabelBlip)

        CurrentDivingLocation.Blip.Label = LabelBlip
    end)
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

Citizen.CreateThread(function()
    while true do
        local inRange = false
        local Ped = GetPlayerPed(-1)
        local Pos = GetEntityCoords(Ped)

        if CurrentDivingLocation.Area ~= 0 then
            local AreaDistance = GetDistanceBetweenCoords(Pos, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.z)
            local CoralDistance = nil

            if AreaDistance < 100 then
                inRange = true
            end

            if inRange then
                for cur, CoralLocation in pairs(QBDiving.Locations[CurrentDivingLocation.Area].coords.Coral) do
                    CoralDistance = GetDistanceBetweenCoords(Pos, CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z, true)

                    if CoralDistance ~= nil then
                        if CoralDistance <= 20 then
                            if not CoralLocation.PickedUp then
                                DrawMarker(32, CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 1.0, 0.4, 255, 223, 0, 255, true, false, false, false, false, false, false)
                                if CoralDistance <= 1.5 then
                                    DrawText3D(CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z, '[E] Koraal verzamelen')
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        -- loadAnimDict("pickup_object")
                                        local times = math.random(2, 5)
                                        FreezeEntityPosition(Ped, true)
                                        QBCore.Functions.Progressbar("take_coral", "Koraal aan het verzamelen..", times * 1000, false, true, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
                                            anim = "plant_floor",
                                            flags = 16,
                                        }, {}, {}, function() -- Done
                                            TakeCoral(cur)
                                            ClearPedTasks(Ped)
                                            FreezeEntityPosition(Ped, false)
                                        end, function() -- Cancel
                                            ClearPedTasks(Ped)
                                            FreezeEntityPosition(Ped, false)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(2500)
        end

        Citizen.Wait(3)
    end
end)

function TakeCoral(coral)
    QBDiving.Locations[CurrentDivingLocation.Area].coords.Coral[coral].PickedUp = true
    TriggerServerEvent('qb-diving:server:TakeCoral', CurrentDivingLocation.Area, coral, true)
end

RegisterNetEvent('qb-diving:client:UpdateCoral')
AddEventHandler('qb-diving:client:UpdateCoral', function(Area, Coral, Bool)
    QBDiving.Locations[Area].coords.Coral[Coral].PickedUp = Bool
end)