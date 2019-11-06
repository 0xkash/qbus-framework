Config = {}

Config.Locations = {
   ["duty"] = {x = 440.085, y = -974.924, z = 30.689, h = 90.654},
   ["clothing"] = {x = 454.456, y = -988.743, z = 30.689, h = 90.654},
   ["vehicle"] = {x = 448.159, y = -1017.41, z = 28.562, h = 90.654},
   ["helicopter"] = {x = 449.168, y = -981.325, z = 43.691, h = 87.234},
   ["armory"] = {x = 453.075, y = -980.124, z = 30.889, h = 90.654},
}

Config.Helicopter = "polmav"

Config.SecurityCameras = {
    hideradar = false,
    cameras = {
        {label = "Pacific Bank 1", x = 257.45, y = 210.07, z = 109.08, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = false, isOnline = false},
        {label = "Pacific Bank 2", x = 232.86, y = 221.46, z = 107.83, r = {x = -25.0, y = 0.0, z = -140.91}, canRotate = false, isOnline = true},
        {label = "Pacific Bank 3", x = 252.27, y = 225.52, z = 103.99, r = {x = -35.0, y = 0.0, z = -74.87}, canRotate = false, isOnline = true},
        {label = "Limited Ltd Grove St. CAM#1", x = -53.1433, y = -1746.714, z = 31.546, r = {x = -35.0, y = 0.0, z = -168.9182}, canRotate = false, isOnline = true},
    },
}

Config.Vehicles = {
    ["police"] = "Politie Cruiser",
    ["police2"] = "Politie Buffalo",
    ["police3"] = "Politie Interceptor",
    ["police4"] = "Politie Undercover",
    ["policeT"] = "Politie Bus",
}

Config.Radars = {
	{x = -623.44421386719, y = -823.08361816406, z = 25.25704574585, h = 145.0 },
	{x = -652.44421386719, y = -854.08361816406, z = 24.55704574585, h = 325.0 },
	{x = 1623.0114746094, y = 1068.9924316406, z = 80.903594970703, h = 84.0 },
	{x = -2604.8994140625, y = 2996.3391113281, z = 27.528566360474, h = 175.0 },
	{x = 2136.65234375, y = -591.81469726563, z = 94.272926330566, h = 318.0 },
	{x = 2117.5764160156, y = -558.51013183594, z = 95.683128356934, h = 158.0 },
	{x = 406.89505004883, y = -969.06286621094, z = 29.436267852783, h = 33.0 },
	{x = 657.315, y = -218.819, z = 44.06, h = 320.0 },
	{x = 2118.287, y = 6040.027, z = 50.928, h = 172.0 },
	{x = -106.304, y = -1127.5530, z = 30.778, h = 230.0 },
	{x = -823.3688, y = -1146.980, z = 8.0, h = 300.0 },
}

Config.Items = {
    label = "Politie Wapenkluis",
    items = {
        [1] = {
            name = "weapon_combatpistol",
            price = 0,
            amount = 99,
            info = {},
            type = "weapon",
            slot = 1,
        },
        [2] = {
            name = "weapon_stungun",
            price = 0,
            amount = 99,
            info = {},
            type = "weapon",
            slot = 2,
        },
        [3] = {
            name = "weapon_pumpshotgun",
            price = 0,
            amount = 99,
            info = {},
            type = "weapon",
            slot = 3,
        },
        [4] = {
            name = "weapon_smg",
            price = 0,
            amount = 99,
            info = {},
            type = "weapon",
            slot = 4,
        },
        [5] = {
            name = "weapon_carbinerifle",
            price = 0,
            amount = 99,
            info = {},
            type = "weapon",
            slot = 5,
        },
        [6] = {
            name = "weapon_nightstick",
            price = 0,
            amount = 99,
            info = {},
            type = "weapon",
            slot = 6,
        },
        [7] = {
            name = "pistol_ammo",
            price = 0,
            amount = 99,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "smg_ammo",
            price = 0,
            amount = 99,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "shotgun_ammo",
            price = 0,
            amount = 99,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "rifle_ammo",
            price = 0,
            amount = 99,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "handcuffs",
            price = 0,
            amount = 99,
            info = {},
            type = "item",
            slot = 11,
        },
    }
}