$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            //Inventory.Close();
            break;
    }
});

(() => {
    Character = {};

    Character.Show = function(data) {

    };

    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case "show":
                    Character.Show(event.data);
                    break;
            }
        })
    }

})();