Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = Config or {}

Config.ItemTiers = 1

Config.RewardTypes = {
    [1] = {
        type = "item",
    },
    [2] = {
        type = "money",
        maxAmount = 500
    }
}

Config.PowerStations = {
    [1] = { -- Big Power Station 1
        coords = {x = 2835.24, y = 1505.68, z = 24.72},
        hit = false,
    },
    [2] = { -- Big Power Station 2
        coords = {x = 2811.76, y = 1500.6, z = 24.72},
        hit = false,
    },
    [3] = { -- Power Station Windmills
        coords = {x = 2137.73, y = 1949.62, z = 93.78},
        hit = false,
    },
    [4] = {
        coords = {x = 708.92, y = 117.49, z = 80.95},
        hit = false,
    },
    [5] = {
        coords = {x = 670.23, y = 128.14, z = 80.95},
        hit = false,
    },
    [6] = {
        coords = {x = 692.17, y = 160.28, z = 80.94},
        hit = false,
    },
    [7] = {
        coords = {x = 2459.16, y = 1460.94, z = 36.2},
        hit = false,
    },
    [8] = {
        coords = {x = 2280.45, y = 2964.83, z = 46.75},
        hit = false,
    },
    [9] = {
        coords = {x = 2059.68, y = 3683.8, z = 34.58},
        hit = false,
    },
    [10] = {
        coords = {x = 2589.5, y = 5057.38, z = 44.91},
        hit = false,
    },
    [11] = {
        coords = {x = 1343.61, y = 6388.13, z = 33.41},
        hit = false,
    },
    [12] = {
        coords = {x = 236.61, y = 6406.1, z = 31.83},
        hit = false,
    },
    [13] = {
        coords = {x = -293.1, y = 6023.54, z = 31.54},
        hit = false,
    },
}

Config.LockerRewards = {
    ["tier1"] = {
        [1] = {item = "rolex", maxAmount = 5},
    },
    ["tier2"] = {
        [1] = {item = "rolex", maxAmount = 5},
    },
    ["tier3"] = {
        [1] = {item = "rolex", maxAmount = 5},
    },
}

Config.SmallBanks = {
    [1] = {
        ["label"] = "Lol",
        ["coords"] = {
            ["x"] = 311.15,
            ["y"] = -284.49,
            ["z"] = 54.16,
        },
        ["alarm"] = true,
        ["object"] = GetHashKey("v_ilev_gb_vauldr"),
        ["heading"] = {
            closed = 250.0,
            open = 160.0,
        },
        ["camId"] = 21,
        ["isOpened"] = false,
        ["lockers"] = {
            [1] = {
                x = 311.16, 
                y = -287.71, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = 311.86, 
                y = -286.21, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = 313.39, 
                y = -289.15, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = 311.7, 
                y = -288.45, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = 314.23, 
                y = -288.77, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = 314.83, 
                y = -287.33, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = 315.24, 
                y = -284.85, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [8] = {
                x = 314.08, 
                y = -283.38, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
    },
    [2] = {
        ["label"] = "Legion Square",
        ["coords"] = {
            ["x"] = 146.92,
            ["y"] = -1046.11,
            ["z"] = 29.36,
        },
        ["alarm"] = true,
        ["object"] = GetHashKey("v_ilev_gb_vauldr"),
        ["heading"] = {
            closed = 250.0,
            open = 160.0,
        },
        ["camId"] = 22,
        ["isOpened"] = false,
        ["lockers"] = {
            [1] = {
                x = 149.84, 
                y = -1044.9, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = 151.16, 
                y = -1046.64, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = 147.16, 
                y = -1047.72, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = 146.54, 
                y = -1049.28, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = 146.88, 
                y = -1050.33, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = 150.0, 
                y = -1050.67, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = 149.47, 
                y = -1051.28, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [8] = {
                x = 150.58, 
                y = -1049.09, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
    },
    [3] = {
        ["label"] = "Hawick Ave",
        ["coords"] = {
            ["x"] = -353.82,
            ["y"] = -55.37,
            ["z"] = 49.03,
        },
        ["alarm"] = true,
        ["object"] = GetHashKey("v_ilev_gb_vauldr"),
        ["heading"] = {
            closed = 250.0,
            open = 160.0,
        },
        ["camId"] = 23,
        ["isOpened"] = false,
        ["lockers"] = {
            [1] = {
                x = -350.99, 
                y = -54.13, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = -349.53, 
                y = -55.77, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = -353.54, 
                y = -56.94, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = -354.09, 
                y = -58.55, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = -353.81, 
                y = -59.48, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = -349.8, 
                y = -58.3, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = -351.14, 
                y = -60.37, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [8] = {
                x = -350.4, 
                y = -59.92, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
    },
    [4] = {
        ["label"] = "Del Perro Blvd",
        ["coords"] = {
            ["x"] = -1210.77,
            ["y"] = -336.57,
            ["z"] = 37.78,
        },
        ["alarm"] = true,
        ["object"] = GetHashKey("v_ilev_gb_vauldr"),
        ["heading"] = {
            closed = 296.863,
            open = 206.863,
        },
        ["camId"] = 24,
        ["isOpened"] = false,
        ["lockers"] = {
            [1] = {
                x = -1209.68, 
                y = -333.65, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = -1207.46, 
                y = -333.77, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = -1209.45, 
                y = -337.47, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = -1208.65, 
                y = -339.06, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = -1207.75, 
                y = -339.42, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = -1205.28,
                y = -338.14, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = -1205.08, 
                y = -337.28, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [8] = {
                x = -1205.92, 
                y = -335.75, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
    },
    [5] = {
        ["label"] = "Great Ocean Hwy",
        ["coords"] = {
            ["x"] = -2956.55,
            ["y"] = 481.74,
            ["z"] = 15.69,
        },
        ["alarm"] = true,
        ["object"] = GetHashKey("hei_prop_heist_sec_door"),
        ["heading"] = {
            closed = 357.542,
            open = 267.542,
        },
        ["camId"] = 25,
        ["isOpened"] = false,
        ["lockers"] = {
            [1] = {
                x = -2958.54, 
                y = 484.1, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = -2957.3, 
                y = 485.95, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = -2955.09, 
                y = 482.43, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = -2953.26, 
                y = 482.42, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = -2952.63, 
                y = 483.09, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = -2952.45, 
                y = 485.66, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = -2953.13, 
                y = 486.26, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [8] = {
                x = -2954.98, 
                y = 486.37, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
    },
}