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

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Config.RandomStr = function(length)
	if length > 0 then
		return Config.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Config.RandomInt = function(length)
	if length > 0 then
		return Config.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Config.Dealers = {
    [1] = {
        ["name"] = "Tony",
        ["coords"] = {
            ["x"] = -1928.3, 
            ["y"] = 1779.46, 
            ["z"] = 173.09, 
        },
        ["time"] = {
            ["min"] = 22,
            ["max"] = 4,
        },
        ["products"] = {
            [1] = {
                name = "weed_white-widow",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 1,
                minrep = 0,
            },
            [2] = {
                name = "weed_og-kush",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 2,
                minrep = 60,
            },
            [3] = {
                name = "weed_white-widow_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 3,
                minrep = 100,
            },
            [4] = {
                name = "weed_og-kush_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 4,
                minrep = 160,
            },
        },
    },
    [2] = {
        ["name"] = "Garry",
        ["coords"] = {
            ["x"] = 1385.17, 
            ["y"] = 3659.42, 
            ["z"] = 34.92, 
        },
        ["time"] = {
            ["min"] = 1,
            ["max"] = 4,
        },
        ["products"] = {
            [1] = {
                name = "weed_skunk",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 1,
                minrep = 0,
            },
            [2] = {
                name = "weed_amnesia",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 2,
                minrep = 80,
            },
            [3] = {
                name = "weed_skunk_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 3,
                minrep = 120,
            },
            [4] = {
                name = "weed_amnesia_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 4,
                minrep = 180,
            },
            [5] = {
                name = "weapon_snspistol",
                price = 5000,
                amount = 1,
                info = {
                    serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
                },
                type = "item",
                slot = 5,
                minrep = 200,
            },
        },
    },
    [3] = {
        ["name"] = "Fred",
        ["coords"] = {
            ["x"] = -1263.55, 
            ["y"] = -1142.7, 
            ["z"] = 7.54, 
        },
        ["time"] = {
            ["min"] = 22,
            ["max"] = 10,
        },
        ["products"] = {
            [1] = {
                name = "weed_skunk",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 1,
                minrep = 0,
            },
            [2] = {
                name = "weed_purple-haze",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 2,
                minrep = 40,
            },
            [3] = {
                name = "weed_skunk_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 3,
                minrep = 120,
            },
            [4] = {
                name = "weed_purple-haze_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 4,
                minrep = 140,
            },
            [5] = {
                name = "weapon_snspistol",
                price = 7000,
                amount = 3,
                info = {
                    serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
                },
                type = "item",
                slot = 5,
                minrep = 650,
            },
        },
    },
    [4] = {
        ["name"] = "Viktor",
        ["coords"] = {
            ["x"] = 802.99, 
            ["y"] = 2174.9, 
            ["z"] = 53.07, 
        },
        ["time"] = {
            ["min"] = 22,
            ["max"] = 10,
        },
        ["products"] = {
            [1] = {
                name = "weed_white-widow",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 1,
                minrep = 0,
            },
            [2] = {
                name = "weed_skunk",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 2,
                minrep = 20,
            },
            [3] = {
                name = "weed_purple-haze",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 3,
                minrep = 40,
            },
            [4] = {
                name = "weed_og-kush",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 4,
                minrep = 60,
            },
            [5] = {
                name = "weed_amnesia",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 5,
                minrep = 80,
            },
            [6] = {
                name = "weed_white-widow_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 6,
                minrep = 100,
            },
            [7] = {
                name = "weed_skunk_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 7,
                minrep = 120,
            },
            [8] = {
                name = "weed_purple-haze_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 8,
                minrep = 140,
            },
            [9] = {
                name = "weed_og-kush_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 9,
                minrep = 160,
            },
            [10] = {
                name = "weed_amnesia_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 10,
                minrep = 180,
            },
        },
    },
    [5] = {
        ["name"] = "Julio",
        ["coords"] = {
            ["x"] = -252.12, 
            ["y"] = 6235.04, 
            ["z"] = 31.48, 
        },
        ["time"] = {
            ["min"] = 15,
            ["max"] = 22,
        },
        ["products"] = {
            [1] = {
                name = "weed_white-widow",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 1,
                minrep = 0,
            },
            [2] = {
                name = "weed_skunk",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 2,
                minrep = 20,
            },
            [3] = {
                name = "weed_purple-haze",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 3,
                minrep = 40,
            },
            [4] = {
                name = "weed_og-kush",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 4,
                minrep = 60,
            },
            [5] = {
                name = "weed_amnesia",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 5,
                minrep = 80,
            },
            [6] = {
                name = "weed_white-widow_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 6,
                minrep = 100,
            },
            [7] = {
                name = "weed_skunk_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 7,
                minrep = 120,
            },
            [8] = {
                name = "weed_purple-haze_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 8,
                minrep = 140,
            },
            [9] = {
                name = "weed_og-kush_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 9,
                minrep = 160,
            },
            [10] = {
                name = "weed_amnesia_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 10,
                minrep = 180,
            },
        },
    },
    [6] = {
        ["name"] = "Ricardo",
        ["coords"] = {
            ["x"] = -353.43, 
            ["y"] = -2265.67, 
            ["z"] = 7.6, 
        },
        ["time"] = {
            ["min"] = 15,
            ["max"] = 22,
        },
        ["products"] = {
            [1] = {
                name = "weed_white-widow",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 1,
                minrep = 0,
            },
            [2] = {
                name = "weed_skunk",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 2,
                minrep = 20,
            },
            [3] = {
                name = "weed_ak47_seed",
                price = 15,
                amount = 150,
                info = {},
                type = "item",
                slot = 3,
                minrep = 100,
            }
        },
    },
    [6] = {
        ["name"] = "Ouweheer",
        ["coords"] = {
            ["x"] = 1535.87, 
            ["y"] = 2231.97, 
            ["z"] = 77.69,
        },
        ["time"] = {
            ["min"] = 1,
            ["max"] = 23,
        },
        ["products"] = {
            [1] = {
                name = "bandage",
                price = 100,
                amount = 50,
                info = {},
                type = "item",
                slot = 1,
                minrep = 0,
            },
            [2] = {
                name = "painkillers",
                price = 500,
                amount = 2,
                info = {},
                type = "item",
                slot = 2,
                minrep = 0,
            },
        },
    },
}

Config.CornerSellingDrugsList = {
    "weed_white-widow",
    "weed_skunk",
    "weed_purple-haze",
    "weed_og-kush",
    "weed_amnesia",
    "weed_ak47",
}

Config.DrugsPrice = {
    ["weed_white-widow"] = 1,
    ["weed_skunk"] = 2,
    ["weed_purple-haze"] = 3,
    ["weed_og-kush"] = 1,
    ["weed_amnesia"] = 2,
    ["weed_ak47"] = 10,
}

Config.DeliveryLocations = {
    [1] = {
        ["label"] = "Stripclub",
        ["coords"] = {
            ["x"] = 106.24,
            ["y"] = -1280.32,
            ["z"] = 29.24,
        }
    },
    [2] = {
        ["label"] = "Vinewood Video",
        ["coords"] = {
            ["x"] = 223.98,
            ["y"] = 121.53,
            ["z"] = 102.76,
        }
    },
    [3] = {
        ["label"] = "Vinewood Video",
        ["coords"] = {
            ["x"] = 223.98,
            ["y"] = 121.53,
            ["z"] = 102.76,
        }
    },
    [4] = {
        ["label"] = "Resort",
        ["coords"] = {
            ["x"] = -1245.63,
            ["y"] = 376.21,
            ["z"] = 75.34,
        }
    },
    [5] = {
        ["label"] = "Bahama Mamas",
        ["coords"] = {
            ["x"] = -1383.1,
            ["y"] = -639.99,
            ["z"] = 28.67,
        }
    },
}

Config.CornerSellingZones = {
    [1] = {
        ["coords"] = {
            ["x"] = -1415.53,
            ["y"] = -1041.51,
            ["z"] = 4.62,
        },
        ["time"] = {
            ["min"] = 12,
            ["max"] = 18,
        },
    },
}

Config.DeliveryItems = {
    [1] = {
        ["item"] = "weed_brick",
        ["minrep"] = 0,
    },
}