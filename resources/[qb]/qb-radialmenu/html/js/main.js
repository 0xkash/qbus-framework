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
            
            $.post('http://qb-radialmenu/selectItem', JSON.stringify({
                itemData: item
            }))
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