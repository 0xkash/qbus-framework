'use strict';

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

        if (eventData.action == "setPlayers") {
            createMenu(eventData.items)
        }
    });
});

function createMenu(items) {
    QBRadialMenu = new RadialMenu({
        parent      : document.body,
        size        : 375,
        menuItems   : items,
        onClick     : function(item) {
            if (item.shouldClose) {
                $.post('http://qb-radialmenu/closeRadial')
            }
            
            if (item.event !== null) {
                if (item.data !== null) {
                    $.post('http://qb-radialmenu/selectItem', JSON.stringify({
                        itemData: item,
                        data: item.data
                    }))
                } else {
                    $.post('http://qb-radialmenu/selectItem', JSON.stringify({
                        itemData: item
                    }))
                }
            }
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