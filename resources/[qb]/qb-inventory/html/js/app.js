$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            Inventory.Close();
            break;
    }
});

$(".dragzones").draggable();
$(".dropzones").droppable({
    drop: function(event, ui) {
        items = [ui.draggable];
        console.log(ui.draggable.attr("data-slot"));
    }
})

(() => {
    Inventory = {};

    Inventory.Open = function(data) {
        $("#qbus-inventory").css("display", "block");
        for(i = 1; i < (data.slots + 1); i++) {
            $(".player-inventory").append('<div class="item-slot dropzones dragzones" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            $(".other-inventory").append('<div class="item-slot dropzones dragzones" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
        }
        if (data.items !== null) {
            $.each(data.items, function (i, item) {
                $(".player-inventory").find("[data-slot=" + i + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-label"><p>' + item.label + '</p></div>');
            });
        }
    };

    Inventory.Close = function() {
        $("#qbus-inventory").css("display", "none");
        $(".item-slot").remove();
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