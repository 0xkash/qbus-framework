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
                type = 'client',
                event = 'qb-radialmenu:client:giveidkaart',
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
            },
        }
    },
    {
        id = 'general',
        title = 'Algemeen',
        icon = '#general',
    },
    {
        id = 'vehicle',
        title = 'Voertuig Interactie',
        icon = '#vehicle',
        items = {
            {
                id    = 'givekey',
                title = 'Geef Sleutel',
                icon = '#vehiclekey',
                type = 'client',
                event = 'qb-radialmenu:client:giveidkaart',
                shouldClose = true,
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