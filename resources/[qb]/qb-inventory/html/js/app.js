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
        for(i = 1; i < (data.slots + 1); i++) {
            $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            $(".other-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
        }
        if (data.items !== null) {
            $.each(data.items, function (i, item) {
                $(".player-inventory").find("[data-slot=" + i + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-label"><p>' + item.label + '</p></div>');
                $(".player-inventory").find("[data-slot=" + i + "]").data("item", item);
            });
        }

        $(function() {
            $(".item-slot").draggable({
                helper: "clone",
                appendTo: "body",
                zIndex: 99999,
                revert: "invalid",
                start: function(event, ui) {
                    $(this).css("background", "rgba(20,20,20,1.0)");
                    $(this).find("img").css("filter", "brightness(50%)");
                },
                stop: function() {
                    $(this).css("background", "rgba(20,20,20,0.5)");
                    $(this).find("img").css("filter", "brightness(100%)");
                },
            });

            $(".item-slot").droppable({
                drop: function(event, ui) {
                    fromSlot = ui.draggable.attr("data-slot");
                    fromInventory = ui.draggable.parent();
                    toSlot = $(this).attr("data-slot");
                    toInventory = $(this).parent();

                    swap(fromSlot, toSlot, fromInventory, toInventory);
                },
            });

            function swap($fromSlot, $toSlot, $fromInv, $toInv) {
                fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
                toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
                if (fromData !== undefined) {
                    $toInv.find("[data-slot=" + $toSlot + "]").data("item", fromData);
                    $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", toData);
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-label"><p>' + fromData.label + '</p></div>');
                    if (toData !== undefined) {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toData.image + '" alt="' + toData.name + '" /></div><div class="item-slot-label"><p>' + toData.label + '</p></div>');
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                    }
                }
            }
        });
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