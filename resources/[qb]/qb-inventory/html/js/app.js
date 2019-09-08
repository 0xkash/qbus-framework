$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            Inventory.Close();
            break;
    }
});

(() => {
    Inventory = {};

    Inventory.Open = function(data) {
        $("#qbus-inventory").css("display", "block");
    };

    Inventory.Close = function() {
        $("#qbus-inventory").css("display", "none");
        $.post("http://qb-inventory/CloseInventory", JSON.stringify({}));
    };

    Inventory.Update = function(data) {

    };

    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case "open":
                    Inventory.Open(event.data);
                    break;
                case "close":
                    Inventory.Close();
                    break;
                case "update":
                    Inventory.Update(event.data);
                    break;
            }
        })
    }

})();