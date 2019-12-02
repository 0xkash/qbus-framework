Config = {}

Config.Keys = {
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

Config.Products = {
    ["normal"] = {
        [1] = {
            name = "tosti",
            price = 2,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "water_bottle",
            price = 2,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "kurkakola",
            price = 2,
            amount = 50,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "twerks_candy",
            price = 2,
            amount = 50,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "snikkel_candy",
            price = 2,
            amount = 50,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "sandwich",
            price = 2,
            amount = 50,
            info = {},
            type = "item",
            slot = 6,
        },
    },
    ["hardware"] = {
        [1] = {
            name = "lockpick",
            price = 200,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "weapon_wrench",
            price = 250,
            amount = 250,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "weapon_hammer",
            price = 250,
            amount = 250,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "repairkit",
            price = 1250,
            amount = 50,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "screwdriverset",
            price = 500,
            amount = 50,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "phone",
            price = 850,
            amount = 50,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "radio",
            price = 850,
            amount = 50,
            info = {},
            type = "item",
            slot = 7,
        },
    },
    ["coffeeshop"] = {
        [1] = {
            name = "joint",
            price = 10,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "weapon_poolcue",
            price = 100,
            amount = 250,
            info = {},
            type = "item",
            slot = 2,
        },
    },
    ["weapons"] = {
        [1] = {
            name = "weapon_knife",
            price = 250,
            amount = 250,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "weapon_switchblade",
            price = 250,
            amount = 250,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "weapon_hatchet",
            price = 250,
            amount = 250,
            info = {},
            type = "item",
            slot = 3,
        },
    },
}

Config.Locations = {
    ["ltdgasoline"] = {
        ["label"] = "LTD Gasoline",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -48.44,
                ["y"] = -1757.86,
                ["z"] = 29.42,
            },
            [2] = {
                ["x"] = -47.23,
                ["y"] = -1756.58,
                ["z"] = 29.42,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 25.7,
                ["y"] = -1347.3,
                ["z"] = 29.49,
            },
            [2] = {
                ["x"] = 25.7,
                ["y"] = -1344.99,
                ["z"] = 29.49,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["robsliquor"] = {
        ["label"] = "Rob's Liqour",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -1222.77,
                ["y"] = -907.19,
                ["z"] = 12.32,
            },
        },
        ["products"] = Config.Products["normal"],
    },
    ["ltdgasoline2"] = {
        ["label"] = "LTD Gasoline",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -707.41,
                ["y"] = -912.83,
                ["z"] = 19.21,
            },
            [2] = {
                ["x"] = -707.32,
                ["y"] = -914.65,
                ["z"] = 19.21,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["robsliquor2"] = {
        ["label"] = "Rob's Liqour",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -1487.7,
                ["y"] = -378.53,
                ["z"] = 40.16,
            },
        },
        ["products"] = Config.Products["normal"],
    },
    ["ltdgasoline3"] = {
        ["label"] = "LTD Gasoline",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -1820.33,
                ["y"] = 792.66,
                ["z"] = 138.1,
            },
            [2] = {
                ["x"] = -1821.55,
                ["y"] = 793.98,
                ["z"] = 138.1,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["robsliquor3"] = {
        ["label"] = "Rob's Liqour",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -2967.79,
                ["y"] = 391.64,
                ["z"] = 15.04,
            },
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket2"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -3038.71,
                ["y"] = 585.9,
                ["z"] = 7.9,
            },
            [2] = {
                ["x"] = -3041.04,
                ["y"] = 585.11,
                ["z"] = 7.9,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket3"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -3241.47,
                ["y"] = 1001.14,
                ["z"] = 12.83,
            },
            [2] = {
                ["x"] = -3243.98,
                ["y"] = 1001.35,
                ["z"] = 12.83,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket4"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 1728.66,
                ["y"] = 6414.16,
                ["z"] = 35.03,
            },
            [2] = {
                ["x"] = 1729.72,
                ["y"] = 6416.27,
                ["z"] = 35.03,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket5"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 1697.99,
                ["y"] = 4924.4,
                ["z"] = 42.06,
            },
            [2] = {
                ["x"] = 1699.44,
                ["y"] = 4923.47,
                ["z"] = 42.06,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket6"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 1961.48,
                ["y"] = 3739.96,
                ["z"] = 32.34,
            },
            [2] = {
                ["x"] = 1960.22,
                ["y"] = 3742.12,
                ["z"] = 32.34,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["robsliquor4"] = {
        ["label"] = "Rob's Liqour",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 1165.28,
                ["y"] = 2709.4,
                ["z"] = 38.15,
            },
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket7"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 547.79,
                ["y"] = 2671.79,
                ["z"] = 42.15,
            },
            [2] = {
                ["x"] = 548.1,
                ["y"] = 2669.38,
                ["z"] = 42.15,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket8"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 2679.25,
                ["y"] = 3280.12,
                ["z"] = 55.24,
            },
            [2] = {
                ["x"] = 2677.13,
                ["y"] = 3281.38,
                ["z"] = 55.24,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket9"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 2557.94,
                ["y"] = 382.05,
                ["z"] = 108.62,
            },
            [2] = {
                ["x"] = 2555.53,
                ["y"] = 382.18,
                ["z"] = 108.62,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["ltdgasoline4"] = {
        ["label"] = "LTD Gasoline",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 1163.7,
                ["y"] = -323.92,
                ["z"] = 69.2,
            },
            [2] = {
                ["x"] = 1163.4,
                ["y"] = -322.24,
                ["z"] = 69.2,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["robsliquor5"] = {
        ["label"] = "Rob's Liqour",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 1135.66,
                ["y"] = -982.76,
                ["z"] = 46.41,
            },
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket9"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 373.55,
                ["y"] = 325.56,
                ["z"] = 103.56,
            },
            [2] = {
                ["x"] = 374.29,
                ["y"] = 327.9,
                ["z"] = 103.56,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["hardware"] = {
        ["label"] = "Hardware Store",
        ["type"] = "hardware",
        ["coords"] = {
            [1] = {
                ["x"] = 45.55,
                ["y"] = -1749.01,
                ["z"] = 29.6,
            }
        },
        ["products"] = Config.Products["hardware"],
    },
    ["hardware2"] = {
        ["label"] = "Hardware Store",
        ["type"] = "hardware",
        ["coords"] = {
            [1] = {
                ["x"] = 2747.8,
                ["y"] = 3472.86,
                ["z"] = 55.67,
            },
        },
        ["products"] = Config.Products["hardware"],
    },
    ["coffeeshop"] = {
        ["label"] = "Superfly",
        ["type"] = "hardware",
        ["coords"] = {
            [1] = {
                ["x"] = -1172.43,
                ["y"] = -1572.24,
                ["z"] = 4.66,
            }
        },
        ["products"] = Config.Products["coffeeshop"],
    },
    ["ammunation1"] = {
        ["label"] = "Ammunation",
        ["type"] = "weapon",
        ["coords"] = {
            [1] = {
                ["x"] = -662.1, 
                ["y"] = -935.3, 
                ["z"] = 21.8
            }
        },
        ["products"] = Config.Products["weapons"],
    },
    ["ammunation2"] = {
        ["label"] = "Ammunation",
        ["type"] = "weapon",
        ["coords"] = {
            [1] = {
                ["x"] = 810.2, 
                ["y"] = -2157.3, 
                ["z"] = 29.6
            }
        },
        ["products"] = Config.Products["weapons"],
    },
    ["ammunation3"] = {
        ["label"] = "Ammunation",
        ["type"] = "weapon",
        ["coords"] = {
            [1] = {
                ["x"] = 1693.4, 
                ["y"] = 3759.5, 
                ["z"] = 34.7
            }
        },
        ["products"] = Config.Products["weapons"],
    },
    ["ammunation4"] = {
        ["label"] = "Ammunation",
        ["type"] = "weapon",
        ["coords"] = {
            [1] = {
                ["x"] = -330.2, 
                ["y"] = 6083.8, 
                ["z"] = 31.4
            }
        },
        ["products"] = Config.Products["weapons"],
    },
    ["ammunation5"] = {
        ["label"] = "Ammunation",
        ["type"] = "weapon",
        ["coords"] = {
            [1] = {
                ["x"] = 252.3, 
                ["y"] = -50.0, 
                ["z"] = 69.9
            }
        },
        ["products"] = Config.Products["weapons"],
    },
    ["ammunation6"] = {
        ["label"] = "Ammunation",
        ["type"] = "weapon",
        ["coords"] = {
            [1] = {
                ["x"] = 22.0, 
                ["y"] = -1107.2, 
                ["z"] = 29.8
            }
        },
        ["products"] = Config.Products["weapons"],
    },
    ["ammunation7"] = {
        ["label"] = "Ammunation",
        ["type"] = "weapon",
        ["coords"] = {
            [1] = {
                ["x"] = 2567.6, 
                ["y"] = 294.3, 
                ["z"] = 108.7
            }
        },
        ["products"] = Config.Products["weapons"],
    },
    ["ammunation8"] = {
        ["label"] = "Ammunation",
        ["type"] = "weapon",
        ["coords"] = {
            [1] = {
                ["x"] = -1117.5, 
                ["y"] = 2698.6, 
                ["z"] = 18.5
            }
        },
        ["products"] = Config.Products["weapons"],
    },
    ["ammunation9"] = {
        ["label"] = "Ammunation",
        ["type"] = "weapon",
        ["coords"] = {
            [1] = {
                ["x"] = 842.4, 
                ["y"] = -1033.4, 
                ["z"] = 28.1
            }
        },
        ["products"] = Config.Products["weapons"],
    },
}