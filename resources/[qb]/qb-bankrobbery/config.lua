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
        }
    }
}