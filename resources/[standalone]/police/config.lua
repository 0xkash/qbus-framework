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