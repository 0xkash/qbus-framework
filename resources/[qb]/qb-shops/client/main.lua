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

-- code

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local openedMenu = nil

-- Menu

normalMenu = {
	opened = false,
	title = "Winkel",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Etenswaren", description = ""},
				{name = "Dranken", description = ""},
			}
		},
		["etenswaren"] = {
			title = "Etenswaren",
			name = "etenswaren",
			buttons = {}
		},	
		["dranken"] = {
			title = "Dranken",
			name = "dranken",
			buttons = {}
		},	
	}
}

hardwareMenu = {
	opened = false,
	title = "Winkel",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Tools", description = ""},
			}
		},
		["tools"] = {
			title = "Tools",
			name = "tools",
			buttons = {}
		},	
	}
}

function OpenMenu(menu)
    openedMenu.lastmenu = openedMenu.currentmenu
	openedMenu.menu.from = 1
	openedMenu.menu.to = 10
	openedMenu.selectedbutton = 0
	openedMenu.currentmenu = menu
end

function OpenCreator(newMenu)
    newMenu.currentmenu = "main"
    newMenu.opened = true
    newMenu.selectedbutton = 0
    openedMenu = newMenu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if openedMenu.currentmenu == "main" then
		CloseCreator()
	else
		OpenMenu(openedMenu.lastmenu)
	end
end

function CloseCreator()
    openedMenu.opened = false
    openedMenu.menu.from = 1
    openedMenu.menu.to = 10
end

function ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = openedMenu.currentmenu
    local btn = button.name
    
    if this == "main" then
        if btn == "Etenswaren" then
		    OpenMenu('etenswaren')
        end

        if btn == "Dranken" then
            OpenMenu('dranken')
        end

        if btn == "Tools" then
            OpenMenu('tools')
        end
	end
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function drawMenuButton(button,x,y,selected)
	local menu = openedMenu.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0, 0, 0,220)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = openedMenu.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,250)
	DrawText(0.255, 0.254)
end

function drawMenuRight(txt,x,y,selected)
	local menu = openedMenu.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.2, 0.2)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0,0,0, 255)
	else
		SetTextColour(255, 255, 255, 255)
		
	end
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 + 0.025, y - menu.height/3 + 0.0002)

	if selected then
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,255, 255, 255,250)
	else
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,0, 0, 0,250) 
	end
end

function drawMenuTitle(txt,x,y)
	local menu = openedMenu.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)

	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,250)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

-- Menu>

Citizen.CreateThread(function()
    while true do
        local InRange = false
        local PlayerPed = GetPlayerPed(-1)
        local PlayerPos = GetEntityCoords(PlayerPed)

        for shop, _ in pairs(Config.Locations) do
            local position = Config.Locations[shop]["coords"]
            for _, loc in pairs(position) do
                local dist = GetDistanceBetweenCoords(PlayerPos, loc["x"], loc["y"], loc["z"])
                if dist < 10 then
                    InRange = true
                    DrawMarker(2, loc["x"], loc["y"], loc["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.2, 0.1, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)
                    if dist < 1 then
                        DrawText3Ds(loc["x"], loc["y"], loc["z"] + 0.15, '~g~E~w~ - Winkelen')
						if IsControlJustPressed(0, Config.Keys["E"]) then
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", shop, Config.Products[shop])
                        end
                    end

                    -- if dist > 1 then
                    --     if Config.Locations[shop]["menu"].opened then
                    --         CloseCreator()
                    --     end
                    -- end
                end
            end
        end

        if not InRange then
            Citizen.Wait(5000)
        end
        Citizen.Wait(5)
    end
end)

Citizen.CreateThread(function()
    for store,_ in pairs(Config.Locations) do
        StoreBlip = AddBlipForCoord(Config.Locations[store]["coords"][1]["x"], Config.Locations[store]["coords"][1]["y"], Config.Locations[store]["coords"][1]["z"])

        SetBlipSprite(StoreBlip, 52)
        SetBlipDisplay(StoreBlip, 4)
        SetBlipScale(StoreBlip, 0.65)
        SetBlipAsShortRange(StoreBlip, true)
        SetBlipColour(StoreBlip, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations[store]["label"])
        EndTextCommandSetBlipName(StoreBlip)
    end
end)