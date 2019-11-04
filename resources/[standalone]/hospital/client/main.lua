Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

DoScreenFadeIn(100)

inBedDict = "misslamar1dead_body"
inBedAnim = "dead_idle"

getOutDict = 'switch@franklin@bed'
getOutAnim = 'sleep_getup_rubeyes'

isLoggedIn = false

isInHospitalBed = false
canLeaveBed = true

bedOccupying = nil
bedObject = nil
bedOccupyingData = nil
currentTp = nil
usedHiddenRev = false

isBleeding = 0
bleedTickTimer, advanceBleedTimer = 0, 0
fadeOutTimer, blackoutTimer = 0, 0

onPainKiller = 0
wasOnPainKillers = false

onDrugs = 0
wasOnDrugs = false

legCount = 0
armcount = 0
headCount = 0

playerHealth = nil
playerArmour = nil

isDead = false

closestBed = nil

BodyParts = {
    ['HEAD'] = { label = 'Hoofd', causeLimp = false, isDamaged = false, severity = 0 },
    ['NECK'] = { label = 'Nek', causeLimp = false, isDamaged = false, severity = 0 },
    ['SPINE'] = { label = 'Rug', causeLimp = true, isDamaged = false, severity = 0 },
    ['UPPER_BODY'] = { label = 'Boven Rug', causeLimp = false, isDamaged = false, severity = 0 },
    ['LOWER_BODY'] = { label = 'Onder Rug', causeLimp = true, isDamaged = false, severity = 0 },
    ['LARM'] = { label = 'Linker Arm', causeLimp = false, isDamaged = false, severity = 0 },
    ['LHAND'] = { label = 'Linker Hand', causeLimp = false, isDamaged = false, severity = 0 },
    ['LFINGER'] = { label = 'Linker Vingers', causeLimp = false, isDamaged = false, severity = 0 },
    ['LLEG'] = { label = 'Linker Been', causeLimp = true, isDamaged = false, severity = 0 },
    ['LFOOT'] = { label = 'Linker Voet', causeLimp = true, isDamaged = false, severity = 0 },
    ['RARM'] = { label = 'Rechter Arm', causeLimp = false, isDamaged = false, severity = 0 },
    ['RHAND'] = { label = 'Rechter Hand', causeLimp = false, isDamaged = false, severity = 0 },
    ['RFINGER'] = { label = 'Rechter Vingers', causeLimp = false, isDamaged = false, severity = 0 },
    ['RLEG'] = { label = 'Rechter Been', causeLimp = true, isDamaged = false, severity = 0 },
    ['RFOOT'] = { label = 'Rechter Voet', causeLimp = true, isDamaged = false, severity = 0 },
}

injured = {}

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
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        local armor = GetPedArmour(ped)

        if not playerHealth then
            playerHealth = health
        end

        if not playerArmor then
            playerArmor = armor
        end

        local armorDamaged = (playerArmor ~= armor and armor < (playerArmor - Config.ArmorDamage) and armor > 0) -- Players armor was damaged
        local healthDamaged = (playerHealth ~= health) -- Players health was damaged

        local damageDone = (playerHealth - health)

        if armorDamaged or healthDamaged then
            local hit, bone = GetPedLastDamageBone(ped)
            local bodypart = Config.Bones[bone]
            local weapon = GetDamagingWeapon(ped)

            if hit and bodypart ~= 'NONE' then
                if damageDone >= Config.HealthDamage then
                    local checkDamage = true
                    if weapon ~= nil then
                        if armorDamaged and (bodypart == 'SPINE' or bodypart == 'UPPER_BODY') or weapon == Config.WeaponClasses['NOTHING'] then
                            checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
                        end
    
                        if checkDamage then
    
                            if IsDamagingEvent(damageDone, weapon) then
                                CheckDamage(ped, bone, weapon, damageDone)
                            end
                        end
                    end
                elseif Config.AlwaysBleedChanceWeapons[weapon] then
                    if math.random(100) < Config.AlwaysBleedChance then
                        ApplyBleed(1)
                    end
                end
            end
        end

        playerHealth = health
        playerArmor = armor

        if not isInHospitalBed then
            ProcessDamage(ped)
        end
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait((1000 * Config.MessageTimer))
        DoLimbAlert()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        SetClosestBed()
    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.Locations["checking"].x, Config.Locations["checking"].y, Config.Locations["checking"].z)
    SetBlipSprite(blip, 61)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 25)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pillbox Ziekenhuis")
    EndTextCommandSetBlipName(blip)
    while true do
        Citizen.Wait(7)
        if QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["checking"].x, Config.Locations["checking"].y, Config.Locations["checking"].z, true) < 1.5) then
                QBCore.Functions.DrawText3D(Config.Locations["checking"].x, Config.Locations["checking"].y, Config.Locations["checking"].z, "~g~E~w~ - Inchecken")
                if IsControlJustReleased(0, Keys["E"]) then
                    TriggerEvent('animations:client:EmoteCommandStart', {"notepad"})
                    QBCore.Functions.Progressbar("hospital_checkin", "Inchecken..", 2000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function() -- Done
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        TriggerEvent("hospital:client:RespawnAtHospital")
                    end, function() -- Cancel
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        QBCore.Functions.Notify("Niet ingecheckt!", "error")
                    end)
                end
            elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["checking"].x, Config.Locations["checking"].y, Config.Locations["checking"].z, true) < 4.5) then
                QBCore.Functions.DrawText3D(Config.Locations["checking"].x, Config.Locations["checking"].y, Config.Locations["checking"].z, "Inchecken")
            end

            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, true) < 5) then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job.name == "doctor" or PlayerData.job.name == "ambulance" then
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, true) < 1.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, "~g~E~w~ - Omkleden | ~g~H~w~ - Outfit opslaan | ~g~G~w~ - Outfits")
                            if IsControlJustReleased(0, Keys["E"]) then
                                if PlayerData.charinfo.gender == 0 then
                                    TriggerEvent("maleclothesstart", false)
                                else
                                    TriggerEvent("femaleclothesstart", false)
                                end
                                DoScreenFadeIn(50)
                            elseif IsControlJustPressed(0, Keys["G"]) then
                                MenuOutfits()
                                Menu.hidden = not Menu.hidden
                            end
                            Menu.renderGUI()
                        elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, true) < 4.5) then
                            QBCore.Functions.DrawText3D(Config.Locations["clothing"].x, Config.Locations["clothing"].y, Config.Locations["clothing"].z, "Omkleden")
                        end  
                    end
                end)
            end
            
            if closestBed ~= nil and not isInHospitalBed then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["beds"][closestBed].x, Config.Locations["beds"][closestBed].y, Config.Locations["beds"][closestBed].z, true) < 1.5) then
                    QBCore.Functions.DrawText3D(Config.Locations["beds"][closestBed].x, Config.Locations["beds"][closestBed].y, Config.Locations["beds"][closestBed].z + 0.3, "~g~E~w~ - Om in bed te liggen")
                    if IsControlJustReleased(0, Keys["E"]) then
                        TriggerServerEvent("hospital:server:SendToBed", closestBed)
                    end
                end
            end
            
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if QBCore ~= nil then
            if isInHospitalBed and canLeaveBed then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                QBCore.Functions.DrawText3D(pos.x, pos.y, pos.z, "~g~E~w~ - Om uit bet te stappen..")
                if IsControlJustReleased(0, Keys["E"]) then
                    LeaveBed()
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('hospital:client:Revive')
AddEventHandler('hospital:client:Revive', function()
    local player = PlayerPedId()

	if isDead then
		local playerPos = GetEntityCoords(player, true)
        NetworkResurrectLocalPlayer(playerPos, true, true, false)
        TriggerServerEvent("hospital:server:SetDeathStatus", false)
        isDead = false
        SetEntityInvincible(GetPlayerPed(-1), false)
    end

    if isInHospitalBed then
        loadAnimDict(inBedDict)
        TaskPlayAnim(player, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
        SetEntityInvincible(GetPlayerPed(-1), true)
        SetEntityHeading(player, bedOccupyingData.h + 180)
        canLeaveBed = true
    end

    SetEntityHealth(player, GetEntityMaxHealth(player))
    ClearPedBloodDamage(player)
    SetPlayerSprint(PlayerId(), true)

    ResetAll()
    
    QBCore.Functions.Notify("Je bent weer helemaal top!")
end)

RegisterNetEvent('hospital:client:SetBleeding')
AddEventHandler('hospital:client:SetBleeding', function()
    ApplyBleed(1)
end)

RegisterNetEvent('hospital:client:KillPlayer')
AddEventHandler('hospital:client:KillPlayer', function()
    SetEntityHealth(GetPlayerPed(-1), 0)
end)

RegisterNetEvent('hospital:client:SendToBed')
AddEventHandler('hospital:client:SendToBed', function(id, data, isRevive)
    bedOccupying = id
    bedOccupyingData = data
    SetBedCam()
    Citizen.CreateThread(function ()
        Citizen.Wait(5)
        local player = PlayerPedId()
        if isRevive then
            QBCore.Functions.Notify("Je wordt geholpen..")
            Citizen.Wait(Config.AIHealTimer * 1000)
            TriggerEvent("hospital:client:Revive")
        else
            canLeaveBed = true
        end
    end)
end)


RegisterNetEvent('hospital:client:RespawnAtHospital')
AddEventHandler('hospital:client:RespawnAtHospital', function()
    TriggerServerEvent("hospital:server:SendToBed")
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    isLoggedIn = true
    QBCore.Functions.GetPlayerData(function(PlayerData)
        isDead = PlayerData.metadata["isdead"]
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    TriggerServerEvent("hospital:server:SetDeathStatus", false)
    isDead = false
    deathTime = 0
    SetEntityInvincible(GetPlayerPed(-1), false)
    ResetAll()
end)

function GetDamagingWeapon(ped)
    for k, v in pairs(Config.Weapons) do
        if HasPedBeenDamagedByWeapon(ped, k, 0) then
            ClearEntityLastDamageEntity(ped)
            return v
        end
    end

    return nil
end

function IsDamagingEvent(damageDone, weapon)
    math.randomseed(GetGameTimer())
    local luck = math.random(100)
    local multi = damageDone / Config.HealthDamage

    return luck < (Config.HealthDamage * multi) or (damageDone >= Config.ForceInjury or multi > Config.MaxInjuryChanceMulti or Config.ForceInjuryWeapons[weapon])
end

function DoLimbAlert()
    local player = PlayerPedId()
    if not isDead then
        if #injured > 0 then
            local limbDamageMsg = ''
            if #injured <= Config.AlertShowInfo then
                for k, v in pairs(injured) do
                    limbDamageMsg = "Jouw " .. v.label .. " voelt "..Config.WoundStates[v.severity]
                    if k < #injured then
                        limbDamageMsg = limbDamageMsg .. " | "
                    end
                end
            else
                limbDamageMsg = "Je hebt pijn op veel plekken.."
            end
            QBCore.Functions.Notify(limbDamageMsg, "primary", 5000)
        end
    end
end

function DoBleedAlert()
    local player = PlayerPedId()
    if not isDead and isBleeding > 0 then
        QBCore.Functions.Notify("Je bent "..Config.BleedingStates[isBleeding].label, "error", 5000)
        if math.random(100) < Config.BleedingStates[isBleeding].chance then
            local damage = Config.BleedingStates[isBleeding].damage
            SetEntityHealth(player, GetEntityHealth(player) - damage)
        end
    end
end

function IsInjuryCausingLimp()
    for k, v in pairs(BodyParts) do
        if v.causeLimp and v.isDamaged then
            return true
        end
    end

    return false
end

function SetClosestBed() 
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil
    for k, v in pairs(Config.Locations["beds"]) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, Config.Locations["beds"][k].x, Config.Locations["beds"][k].y, Config.Locations["beds"][k].z, true) < dist)then
                current = k
                dist = GetDistanceBetweenCoords(pos, Config.Locations["beds"][k].x, Config.Locations["beds"][k].y, Config.Locations["beds"][k].z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, Config.Locations["beds"][k].x, Config.Locations["beds"][k].y, Config.Locations["beds"][k].z, true)
            current = k
        end
    end
    if current ~= closestBed and not isInHospitalBed then
        closestBed = current
    end
end

function ResetAll()
    isBleeding = 0
    bleedTickTimer = 0
    advanceBleedTimer = 0
    fadeOutTimer = 0
    blackoutTimer = 0
    onDrugs = 0
    wasOnDrugs = false
    onPainKiller = 0
    wasOnPainKillers = false
    injured = {}

    for k, v in pairs(BodyParts) do
        v.isDamaged = false
        v.severity = 0
    end
    
    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })

    ProcessRunStuff(PlayerPedId())
    DoLimbAlert()
    DoBleedAlert()

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })
end

function SetBedCam()
    isInHospitalBed = true
    canLeaveBed = false
    local player = PlayerPedId()

    DoScreenFadeOut(1000)

    while not IsScreenFadedOut() do
        Citizen.Wait(100)
    end

	if IsPedDeadOrDying(player) then
		local playerPos = GetEntityCoords(player, true)
		NetworkResurrectLocalPlayer(playerPos, true, true, false)
    end
    
    bedObject = GetClosestObjectOfType(bedOccupyingData.x, bedOccupyingData.y, bedOccupyingData.z, 1.0, bedOccupyingData.model, false, false, false)
    FreezeEntityPosition(bedObject, true)

    SetEntityCoords(player, bedOccupyingData.x, bedOccupyingData.y, bedOccupyingData.z + 0.02)
    SetEntityInvincible(PlayerPedId(), true)

    loadAnimDict(inBedDict)

    TaskPlayAnim(player, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    SetEntityHeading(player, bedOccupyingData.h + 180)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(cam, player, 31085, 0, 1.0, 1.0 , true)
    SetCamFov(cam, 90.0)
    SetCamRot(cam, -45.0, 0.0, GetEntityHeading(player) + 180, true)

    DoScreenFadeIn(1000)

    Citizen.Wait(1000)
    FreezeEntityPosition(player, true)
end

function LeaveBed()
    local player = PlayerPedId()

    RequestAnimDict(getOutDict)
    while not HasAnimDictLoaded(getOutDict) do
        Citizen.Wait(0)
    end
    
    FreezeEntityPosition(player, false)
    SetEntityInvincible(player, false)
    SetEntityHeading(player, bedOccupyingData.h - 90)
    TaskPlayAnim(player, getOutDict , getOutAnim, 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Citizen.Wait(4000)
    ClearPedTasks(player)
    TriggerServerEvent('hospital:server:LeaveBed', bedOccupying)
    FreezeEntityPosition(bedObject, true)

    
    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(cam, false)

    bedOccupying = nil
    bedObject = nil
    bedOccupyingData = nil
    isInHospitalBed = false
end

function MenuOutfits()
    ped = GetPlayerPed(-1);
    MenuTitle = "Outfits"
    ClearMenu()
    Menu.addButton("Mijn Outfits", "OutfitsLijst", nil)
    Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
end

function changeOutfit()
	Wait(200)
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(3100)
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function OutfitsLijst()
    QBCore.Functions.TriggerCallback('apartments:GetOutfits', function(outfits)
        ped = GetPlayerPed(-1);
        MenuTitle = "My Outfits :"
        ClearMenu()

        if outfits == nil then
            QBCore.Functions.Notify("Je hebt geen outfits opgeslagen...", "error", 3500)
            closeMenuFull()
        else
            for k, v in pairs(outfits) do
                Menu.addButton(outfits[k].outfitname, "optionMenu", outfits[k]) 
            end
        end
        Menu.addButton("Terug", "MenuOutfits",nil)
    end)
end

function optionMenu(outfitData)
    ped = GetPlayerPed(-1);
    MenuTitle = "What now?"
    ClearMenu()

    Menu.addButton("Kies Outfit", "selectOutfit", outfitData) 
    Menu.addButton("Verwijder Outfit", "removeOutfit", outfitData) 
    Menu.addButton("Terug", "OutfitsLijst",nil)
end

function selectOutfit(oData)
    TriggerServerEvent('clothes:selectOutfit', oData.model, oData.skin)
    QBCore.Functions.Notify(oData.outfitname.." gekozen", "success", 2500)
    closeMenuFull()
    changeOutfit()
end

function removeOutfit(oData)
    TriggerServerEvent('clothes:removeOutfit', oData.outfitname)
    QBCore.Functions.Notify(oData.outfitname.." is verwijderd", "success", 2500)
    closeMenuFull()
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function loadAnimDict(dict)
	while(not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end