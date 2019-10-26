'use strict';

// var menuItems = []

var menuItems = [
    {
        id   : 'walk',
        title: 'Walk',
        icon: '#walk'
    },
    {
        id   : 'run',
        title: 'Run',
        icon: '#run'
    },
    {
        id   : 'drive',
        title: 'Drive',
        icon: '#drive'
    },
    {
        id   : 'figth',
        title: 'Fight',
        icon: '#fight'
    },
    {
        id   : 'more',
        title: 'More...',
        icon: '#more',
        items: [
            {
                id   : 'eat',
                title: 'Eat',
                icon: '#eat'
            },
            {
                id   : 'sleep',
                title: 'Sleep',
                icon: '#sleep'
            },
            {
                id   : 'shower',
                title: 'Take Shower',
                icon: '#shower'
            },
            {
                id   : 'workout',
                icon : '#workout',
                title: 'Work Out'
            }
        ]
    },
    {
        id: 'weapon',
        title: 'Weapon...',
        icon: '#weapon',
        items: [
            {
                id: 'firearm',
                icon: '#firearm',
                title: 'Firearm...',
                items: [
                    {
                        id: 'glock',
                        title: 'Glock 22'
                    },
                    {
                        id: 'beretta',
                        title: 'Beretta M9'
                    },
                    {
                        id: 'tt',
                        title: 'TT'
                    },
                    {
                        id: 'm16',
                        title: 'M16 A2'
                    },
                    {
                        id: 'ak47',
                        title: 'AK 47'
                    }
                ]
            },
            {
                id: 'knife',
                icon: '#knife',
                title: 'Knife'
            },
            {
                id: 'machete',
                icon: '#machete',
                title: 'Machete'
            }, {
                id: 'grenade',
                icon: '#grenade',
                title: 'Grenade'
            }
        ]
    }
];

var QBRadialMenu = null;

$(document).ready(function(){

    console.log('yeet')

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "ui") {
            if (eventData.radial) {
                createMenu(eventData.items)
                QBRadialMenu.open();
            } else {
                QBRadialMenu.close();
            }
        }
    });
});

function createMenu(items) {
    QBRadialMenu = new RadialMenu({
        parent      : document.body,
        size        : 375,
        closeOnClick: false,
        menuItems   : items,
        onClick     : function(item) {
            $.post('http://qb-radialmenu/selectItem', JSON.stringify({
                itemData: item
            }))
            $.post('http://qb-radialmenu/closeRadial')
        }
    });
}

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            $.post('http://qb-radialmenu/closeRadial')
            break;
    }
});