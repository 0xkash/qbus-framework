QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

--- CODE

AvailableWeatherTypes = {
    {label = "Extra Sunny",         weather = 'EXTRASUNNY',}, 
    {label = "Clear",               weather = 'CLEAR',}, 
    {label = "Neutral",             weather = 'NEUTRAL',}, 
    {label = "Smog",                weather = 'SMOG',}, 
    {label = "Foggy",               weather = 'FOGGY',}, 
    {label = "Overcast",            weather = 'OVERCAST',}, 
    {label = "Clouds",              weather = 'CLOUDS',}, 
    {label = "Clearing",            weather = 'CLEARING',}, 
    {label = "Rain",                weather = 'RAIN',}, 
    {label = "Thunder",             weather = 'THUNDER',}, 
    {label = "Snow",                weather = 'SNOW',}, 
    {label = "Blizzard",            weather = 'BLIZZARD',}, 
    {label = "Snowlight",           weather = 'SNOWLIGHT',}, 
    {label = "XMAS (Heavy Snow)",   weather = 'XMAS',}, 
    {label = "Halloween (Scarry)",  weather = 'HALLOWEEN',},
}

BanTimes = {
    [1] = 3600,
    [2] = 21600,
    [3] = 43200,
    [4] = 86400,
    [5] = 259200,
    [6] = 604800,
    [7] = 2678400,
    [8] = 8035200,
    [9] = 16070400,
    [10] = 32140800,
    [11] = 99999999999,
}

ServerTimes = {
    [1] = {hour = 0, minute = 0},
    [2] = {hour = 1, minute = 0},
    [3] = {hour = 2, minute = 0},
    [4] = {hour = 3, minute = 0},
    [5] = {hour = 4, minute = 0},
    [6] = {hour = 5, minute = 0},
    [7] = {hour = 6, minute = 0},
    [8] = {hour = 7, minute = 0},
    [9] = {hour = 8, minute = 0},
    [10] = {hour = 9, minute = 0},
    [11] = {hour = 10, minute = 0},
    [12] = {hour = 11, minute = 0},
    [13] = {hour = 12, minute = 0},
    [14] = {hour = 13, minute = 0},
    [15] = {hour = 14, minute = 0},
    [16] = {hour = 15, minute = 0},
    [17] = {hour = 16, minute = 0},
    [18] = {hour = 17, minute = 0},
    [19] = {hour = 18, minute = 0},
    [20] = {hour = 19, minute = 0},
    [21] = {hour = 20, minute = 0},
    [22] = {hour = 21, minute = 0},
    [23] = {hour = 22, minute = 0},
    [24] = {hour = 23, minute = 0},
}

isNoclip = false

function getPlayers()
    players = {}
    for _, player in ipairs(GetActivePlayers()) do
        table.insert(players, {
            ['ped'] = GetPlayerPed(player),
            ['name'] = GetPlayerName(player),
            ['id'] = player,
            ['serverid'] = GetPlayerServerId(player),
        })
    end

    return players
end

RegisterNetEvent('qb-admin:client:openMenu')
AddEventHandler('qb-admin:client:openMenu', function()
    WarMenu.OpenMenu('admin')
end)

local currentPlayerMenu = nil
local currentPlayer = 0

Citizen.CreateThread(function()
    local menus = {
        "admin",
        "playerMan",
        "serverMan",
        currentPlayer,
        "playerOptions",
        "teleportOptions",
        "weatherOptions",
        "adminOptions",
    }

    local bans = {
        "1 uur",
        "6 uur",
        "12 uur",
        "1 dag",
        "3 dagen",
        "1 week",
        "1 maand",
        "3 maanden",
        "6 maanden",
        "1 jaar",
        "Perm",
        "Zelf",
    }

    local times = {
        "00:00",
        "01:00",
        "02:00",
        "03:00",
        "04:00",
        "05:00",
        "06:00",
        "07:00",
        "08:00",
        "09:00",
        "10:00",
        "11:00",
        "12:00",
        "13:00",
        "14:00",
        "15:00",
        "16:00",
        "17:00",
        "18:00",
        "19:00",
        "20:00",
        "21:00",
        "22:00",
        "23:00",
    }

    
    local currentBanIndex = 1
    local selectedBanIndex = 1

    WarMenu.CreateMenu('admin', 'Qbus Admin')
    WarMenu.CreateSubMenu('playerMan', 'admin')
    WarMenu.CreateSubMenu('serverMan', 'admin')

    --WarMenu.CreateSubMenu('playerOptions', currentPlayer)
    --WarMenu.CreateSubMenu('teleportOptions', currentPlayer)

    WarMenu.CreateSubMenu('weatherOptions', 'serverMan')
    
    --for k, v in pairs(players) do
        --WarMenu.CreateSubMenu(v, 'playerMan', GetPlayerServerId(v).." | "..GetPlayerName(v))
   -- end

    for k, v in pairs(menus) do
        WarMenu.SetMenuX(v, 0.71)
        WarMenu.SetMenuY(v, 0.15)
        WarMenu.SetMenuWidth(v, 0.23)
        WarMenu.SetTitleColor(v, 255, 255, 255, 255)
        WarMenu.SetTitleBackgroundColor(v, 0, 0, 0, 111)
    end

    while true do
        if WarMenu.IsMenuOpened('admin') then
            WarMenu.MenuButton('Player Management', 'playerMan')
            WarMenu.MenuButton('Server Management', 'serverMan')

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('playerMan') then
            local players = getPlayers()
            for k, v in pairs(players) do
                WarMenu.CreateSubMenu(v["id"], 'playerMan', v["serverid"].." | "..v["name"])
            end
            if WarMenu.MenuButton('#'..GetPlayerServerId(PlayerId()).." | "..GetPlayerName(PlayerId()), PlayerId()) then
                currentPlayer = PlayerId()
                if WarMenu.CreateSubMenu('playerOptions', currentPlayer) then
                    currentPlayerMenu = 'playerOptions'
                elseif WarMenu.CreateSubMenu('teleportOptions', currentPlayer) then
                    currentPlayerMenu = 'teleportOptions'
                elseif WarMenu.CreateSubMenu('adminOptions', currentPlayer) then
                    currentPlayerMenu = 'adminOptions'
                end
            end
            for k, v in pairs(players) do
                if v["id"] ~= PlayerId() then
                    if WarMenu.MenuButton('#'..v["serverid"].." | "..v["name"], v["id"]) then
                        currentPlayer = v["id"]
                        if WarMenu.CreateSubMenu('playerOptions', currentPlayer) then
                            currentPlayerMenu = 'playerOptions'
                        elseif WarMenu.CreateSubMenu('teleportOptions', currentPlayer) then
                            currentPlayerMenu = 'teleportOptions'
                        elseif WarMenu.CreateSubMenu('adminOptions', currentPlayer) then
                            currentPlayerMenu = 'adminOptions'
                        end
                    end
                end
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('serverMan') then
            WarMenu.MenuButton('Weather Options', 'weatherOptions')
            if WarMenu.ComboBox('Server time', times, currentBanIndex, selectedBanIndex, function(currentIndex, selectedIndex)
                currentBanIndex = currentIndex
                selectedBanIndex = selectedIndex
            end) then
                local time = ServerTimes[currentBanIndex]
                TriggerServerEvent("qb-weathersync:server:setTime", time.hour, time.minute)
            end
            if WarMenu.MenuButton('Kick All', "serverMan") then
                DisplayOnscreenKeyboard(1, "Reden", "", "Reden", "", "", "", 128 + 1)
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(7)
				end
                local reason = GetOnscreenKeyboardResult()
                if reason ~= nil and reason ~= "" then
                    TriggerServerEvent("qb-admin:server:serverKick", reason)
                end
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened(currentPlayer) then
            WarMenu.MenuButton('Player Options', 'playerOptions')
            WarMenu.MenuButton('Teleport Options', 'teleportOptions')
            WarMenu.MenuButton('Admin Options', 'adminOptions')
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('playerOptions') then
            if WarMenu.MenuButton('Slay', currentPlayer) then
                local target = GetPlayerPed(currentPlayer)
                local ply = GetPlayerPed(-1)
                SetEntityHealth(target, 0)
            end
            if WarMenu.MenuButton('Revive', currentPlayer) then
                local target = GetPlayerServerId(currentPlayer)
                TriggerServerEvent('qb-admin:server:revivePlayer', target)
            end
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('teleportOptions') then
            if WarMenu.MenuButton('Goto', currentPlayer) then
                local target = GetPlayerPed(currentPlayer)
                local ply = GetPlayerPed(-1)
                SetEntityCoords(ply, GetEntityCoords(target))
            end
            if WarMenu.MenuButton('Bring', currentPlayer) then
                local target = GetPlayerPed(currentPlayer)
                local ply = GetPlayerPed(-1)

                SetEntityCoords(target, GetEntityCoords(ply))
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('adminOptions') then
            if WarMenu.CheckBox("Noclip", isNoclip, function(checked) isNoclip = checked end) then
                local target = GetPlayerServerId(currentPlayer)
                TriggerServerEvent("qb-admin:server:togglePlayerNoclip", target)
            end
            if WarMenu.ComboBox('Ban lengte', bans, currentBanIndex, selectedBanIndex, function(currentIndex, selectedIndex)
                currentBanIndex = currentIndex
                selectedBanIndex = selectedIndex
            end) then
                local time = BanTimes[currentBanIndex]
                local index = currentBanIndex
                if index == 12 then
                    DisplayOnscreenKeyboard(1, "Tijd", "", "Lengte", "", "", "", 128 + 1)
                    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                        Citizen.Wait(7)
                    end
                    time = tonumber(GetOnscreenKeyboardResult())
                    time = time * 3600
                end
                DisplayOnscreenKeyboard(1, "Reden", "", "Reden", "", "", "", 128 + 1)
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(7)
				end
                local reason = GetOnscreenKeyboardResult()
                if reason ~= nil and reason ~= "" and time ~= 0 then
                    local target = GetPlayerServerId(currentPlayer)
                    TriggerServerEvent("qb-admin:server:banPlayer", target, time, reason)
                end
            end
            if WarMenu.MenuButton('Kick', currentPlayer) then
                DisplayOnscreenKeyboard(1, "Reden", "", "Reden", "", "", "", 128 + 1)
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(7)
				end
                local reason = GetOnscreenKeyboardResult()
                if reason ~= nil and reason ~= "" then
                    local target = GetPlayerServerId(currentPlayer)
                    TriggerServerEvent("qb-admin:server:kickPlayer", target, reason)
                end
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('weatherOptions') then
            for k, v in pairs(AvailableWeatherTypes) do
                if WarMenu.MenuButton(AvailableWeatherTypes[k].label, 'weatherOptions') then
                    TriggerServerEvent('qb-weathersync:server:setWeather', AvailableWeatherTypes[k].weather)
                    QBCore.Functions.Notify('Weer is veranderd naar: '..AvailableWeatherTypes[k].label)
                end
            end
            
            WarMenu.Display()
        end

        Citizen.Wait(0)
    end
end)


-- if WarMenu.MenuButton('Slay', currentPlayer) then
--     local target = GetPlayerPed(currentPlayer)
--     local ply = GetPlayerPed(-1)
--     SetEntityHealth(target, 0)
-- end
-- if WarMenu.MenuButton('Goto', currentPlayer) then
--     local target = GetPlayerPed(currentPlayer)
--     local ply = GetPlayerPed(-1)
--     SetEntityCoords(ply, GetEntityCoords(target))
-- end
-- if WarMenu.MenuButton('Bring', currentPlayer) then
--     local target = GetPlayerPed(currentPlayer)
--     local ply = GetPlayerPed(-1)

--     SetEntityCoords(target, GetEntityCoords(ply))
-- end