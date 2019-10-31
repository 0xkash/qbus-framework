Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Config = {}

Config.MenuItems = {
    {
        id = 'citizen',
        title = 'Burger Interactie',
        icon = '#citizen',
        items = {
            {
                id    = 'givelc',
                title = 'Geef ID-kaart',
                icon = '#idkaart',
                type = 'server',
                event = 'inventory:server:ShowIdRadial',
                shouldClose = true,
            },
            {
                id    = 'givedl',
                title = 'Geef Rijbewijs',
                icon = '#rijbewijs',
                type = 'client',
                event = 'qb-radialmenu:client:giveidkaart',
                shouldClose = true,
            },
            {
                id    = 'givenum',
                title = 'Geef Nummer',
                icon = '#nummer',
                type = 'client',
                event = 'qb-radialmenu:client:giveidkaart',
                shouldClose = true,
            },
            {
                id    = 'givebank',
                title = 'Geef Bank nr.',
                icon = '#banknr',
                type = 'client',
                event = 'qb-radialmenu:client:giveidkaart',
                shouldClose = true,
            }
        }
    },
    {
        id = 'general',
        title = 'Algemeen',
        icon = '#general',
        items = {
            {
                id = 'house',
                title = 'Huis Interactie',
                icon = '#house',
                items = {
                    {
                        id    = 'givehousekey',
                        title = 'Geef Huis Sleutel',
                        icon = '#vehiclekey',
                        type = 'client',
                        event = 'qb-radialmenu:client:playerCheck',
                        shouldClose = false,
                        items = {},
                    },
                    {
                        id    = 'togglelock',
                        title = 'Toggle Deurslot',
                        icon = '#vehiclekey',
                        type = 'client',
                        event = 'qb-houses:client:toggleDoorlock',
                        shouldClose = true,
                    },
                }
            }
        }
    },
    {
        id = 'vehicle',
        title = 'Voertuig Interactie',
        icon = '#vehicle',
        items = {
            {
                id    = 'givekey',
                title = 'Geef Voertuig Sleutel',
                icon = '#vehiclekey',
                type = 'client',
                event = 'qb-radialmenu:client:playerCheck',
                shouldClose = false,
                items = {},
            },
            {
                id    = 'vehicledoors',
                title = 'Voertuig Deuren',
                icon = '#vehicledoors',
                items = {
                    {
                        id    = 'door0',
                        title = 'Links Voor',
                        icon = '#leftdoor',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door4',
                        title = 'Motorkap',
                        icon = '#idkaart',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door1',
                        title = 'Rechts Voor',
                        icon = '#rightdoor',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door3',
                        title = 'Rechts Achter',
                        icon = '#rightdoor',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door5',
                        title = 'Kofferbak',
                        icon = '#idkaart',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door2',
                        title = 'Links Achter',
                        icon = '#leftdoor',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                }
            },
        }
    },
}