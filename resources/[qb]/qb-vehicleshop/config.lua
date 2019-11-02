QB = {}

QB.VehicleShops = {
    {x = -56.71, y = -1096.65, z = 26.42}
}

QB.Vehicles = {
    ["sedans"] = {
        ["schafter2"] = {vehicle = "schafter2", name = "Schafter", class = "sedans", classlabel = "Sedans", image = "schafter", price = 110000},
    },

    ["coupes"] = {
        ["windsor"] = {vehicle = "windsor", name = "Windsor", class = "coupes", classlabel = "Coupes", image = "windsor", price = 210000},
    },

    ["sports"] = {
        ["buffalo"] = {vehicle = "buffalo", name = "Buffalo", class = "sports", classlabel = "Sports", image = "buffalo", price = 150000},
    },

    ["super"] = {
        ["adder"] = {vehicle = "adder", name = "Adder", class = "super", classlabel = "Super", image = "adder", price = 750000},
        ["t20"] = {vehicle = "t20", name = "T20", class = "super", classlabel = "Super", image = "t20", price = 650000},
    }
}

QB.GarageLabel = {
    ["motelgarage"] = "Motel Garage",
    ["sapcounsel"]  = "San Andreas Parking Counsel",
}

QB.SpawnPoint = {x = -59.18, y = -1109.71, z = 25.45, h = 68.5}

QB.DefaultGarage = "centralgarage"


QB.ShowroomVehicles = {
    [1] = {
        coords = {x = -46.26, y = -1093.47, z = 26.42, h = 205.5},
        defaultVehicle = "adder",
        chosenVehicle = "adder",
        inUse = false,
    },
    [2] = {
        coords = {x = -48.27, y = -1101.86, z = 26.42, h = 294.5},
        defaultVehicle = "schafter2",
        chosenVehicle = "schafter2",
        inUse = false,
    },
    [3] = {
        coords = {x = -41.24, y = -1093.86, z = 26.42, h = 200.5},
        defaultVehicle = "comet2",
        chosenVehicle = "comet2",
        inUse = false,
    },
    [4] = {
        coords = {x = -51.21, y = -1096.77, z = 26.42, h = 254.5},
        defaultVehicle = "schwarzer2",
        chosenVehicle = "schwarzer2",
        inUse = false,
    },
    [5] = {
        coords = {x = -40.18, y = -1104.13, z = 26.42, h = 338.5},
        defaultVehicle = "t20",
        chosenVehicle = "t20",
        inUse = false,
    },
}

QB.VehicleMenuCategories = {
    ["sports"]  = {label = "Sports"},
    ["super"]   = {label = "Super"},
    ["sedans"]  = {label = "Sedans"},
    ["coupes"]  = {label = "Coupes"},
    ["suvs"]    = {label = "SUV's"},
    ["offroad"] = {label = "Offroad"},
}

QB.CategoryVehicles = {
    ["sports"] = {
        ["comet2"] = {
            vehicle = "comet2",
            price = 250000,
            label = "Comet",
        },
    },
    ["super"] = {
        ["t20"] = {
            vehicle = "t20",
            price = 250000,
            label = "T20",
        }
    }
}

QB.Classes = {
    [0] = "compacts",  
    [1] = "sedans",  
    [2] = "suvs",  
    [3] = "coupes",  
    [4] = "muscle",  
    [5] = "sportsclassics ", 
    [6] = "sports",  
    [7] = "super",  
    [8] = "motorcycles",  
    [9] = "offroad", 
    [10] = "industrial",  
    [11] = "utility",  
    [12] = "vans",  
    [13] = "cycles",  
    [14] = "boats",  
    [15] = "helicopters",  
    [16] = "planes",  
    [17] = "service",  
    [18] = "emergency",  
    [19] = "military",  
    [20] = "commercial",  
    [21] = "trains",  
}

QB.DefaultBuySpawn = {x = -56.79, y = -1109.85, z = 26.43, h = 71.5}