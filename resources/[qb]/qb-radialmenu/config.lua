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
                event = 'qb-radialmenu:client:giveidkaart'
            },
            {
                id    = 'givedl',
                title = 'Geef Rijbewijs',
                icon = '#rijbewijs',
                type = 'client',
                event = 'qb-radialmenu:client:giveidkaart'
            },
            {
                id    = 'givenum',
                title = 'Geef Nummer',
                icon = '#nummer',
                type = 'client',
                event = 'qb-radialmenu:client:giveidkaart'
            },
            {
                id    = 'givebank',
                title = 'Geef Bank nr.',
                icon = '#banknr',
                type = 'client',
                event = 'qb-radialmenu:client:giveidkaart'
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
    },
}