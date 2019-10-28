var totalWeight = 0;
var totalWeightOther = 0;

var playerMaxWeight = 0;
var otherMaxWeight = 0;

var otherLabel = "";

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            Inventory.Close();
            break;
    }
});

$(document).on("contextmenu", ".item-slot", function(e){
    $(".item-slot").css("border", "1px solid rgba(255, 255, 255, 0.05)")
    $(this).css("border", "1px solid rgba(0, 118, 214, 1)")
    $(".ply-hotbar-inventory").css("display", "none");
    $(".ply-iteminfo-container").css("display", "block");

    FormatItemInfo($(this).data("item"));
 });

 function FormatItemInfo(itemData) {
    if (itemData != null && itemData.info != "") {
        if (itemData.name == "id_card") {
            var gender = "Man";
            if (itemData.info.gender == 1) {
                gender = "Vrouw";
            }
            $(".iteminfo-content").html('<p><strong>BSN: </strong><span>' + itemData.info.citizenid + '</span></p><p><strong>Voornaam: </strong><span>' + itemData.info.firstname + '</span></p><p><strong>Achternaam: </strong><span>' + itemData.info.lastname + '</span></p><p><strong>Geboortedatum: </strong><span>' + itemData.info.birthdate + '</span></p><p><strong>Geslacht: </strong><span>' + gender + '</span></p><p><strong>Nationaliteit: </strong><span>' + itemData.info.nationality + '</span></p>')
        }
    } else {
        $(".iteminfo-content").html('<p><strong>Omschrijving:</strong> ' + itemData.description + '</p>')
    }
 }

function handleDragDrop() {
    $(".item-drag").draggable({
        helper: "clone",
        scroll: false,
        appendTo: "body",
        revertDuration: 0,
        zIndex: 99999,
        revert: "invalid",
        cancel: ".item-nodrag",
        start: function(event, ui) {
           // $(this).css("background", "rgba(20,20,20,1.0)");
            $(this).find("img").css("filter", "brightness(50%)");

            $(".item-slot").css("border", "1px solid rgba(255, 255, 255, 0.05)")
            $(".ply-hotbar-inventory").css("display", "block");
            $(".ply-iteminfo-container").css("display", "none");

            var itemData = $(this).data("item");
            var dragAmount = $("#item-amount").val();
            if (!itemData.useable) {
                $("#item-use").css("background", "rgba(35,35,35, 0.5");
            }

            if ( dragAmount == 0) {
                $(this).find(".item-slot-amount p").html('0 (0.0)');
                $(".ui-draggable-dragging").find(".item-slot-amount p").html(itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')');
                if ($(this).parent().attr("data-inventory") == "hotbar") {
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                }
            } else if(dragAmount > itemData.amount) {
                $(this).find(".item-slot-amount p").html(itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')');
                if ($(this).parent().attr("data-inventory") == "hotbar") {
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                }
                InventoryError($(this).parent(), $(this).attr("data-slot"));
            } else if(dragAmount > 0) {
                $(this).find(".item-slot-amount p").html((itemData.amount - dragAmount) + ' (' + ((itemData.weight * (itemData.amount - dragAmount)) / 1000).toFixed(1) + ')');
                $(".ui-draggable-dragging").find(".item-slot-amount p").html(dragAmount + ' (' + ((itemData.weight * dragAmount) / 1000).toFixed(1) + ')');
                if ($(this).parent().attr("data-inventory") == "hotbar") {
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                }
            } else {
                if ($(this).parent().attr("data-inventory") == "hotbar") {
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                }
                $(this).find(".item-slot-amount p").html(itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')');
                InventoryError($(this).parent(), $(this).attr("data-slot"));
            }
        },
        stop: function() {
            $(this).css("background", "rgba(20,20,20,0.5)");
            $(this).find("img").css("filter", "brightness(100%)");
            $("#item-use").css("background", "rgba(235, 235, 235, 0.08)");
        },
    });

    $(".item-slot").droppable({
        drop: function(event, ui) {
            fromSlot = ui.draggable.attr("data-slot");
            fromInventory = ui.draggable.parent();
            toSlot = $(this).attr("data-slot");
            toInventory = $(this).parent();
            toAmount = $("#item-amount").val()

            if (fromSlot == toSlot && fromInventory == toInventory) {
                return;
            }
            if (toAmount >= 0) {
                updateweights(fromSlot, toSlot, fromInventory, toInventory, toAmount);
                swap(fromSlot, toSlot, fromInventory, toInventory, toAmount);
            }
        },
    });

    $("#item-use").droppable({
        hoverClass: 'button-hover',
        drop: function(event, ui) {
            fromData = ui.draggable.data("item");
            fromInventory = ui.draggable.parent().attr("data-inventory");
            if(fromData.useable) {
                $.post("http://qb-inventory/UseItem", JSON.stringify({
                    inventory: fromInventory,
                    item: fromData,
                }));
            }
        }
    });

    $("#item-drop").droppable({
        drop: function(event, ui) {
            fromData = ui.draggable.data("item");
            fromInventory = ui.draggable.parent().attr("data-inventory");
            amount = $("#item-amount").val();
            if (amount == 0) {amount=fromData.amount}
            $(this).css("background", "rgba(35,35,35, 0.7");
            $.post("http://qb-inventory/DropItem", JSON.stringify({
                inventory: fromInventory,
                item: fromData,
                amount: parseInt(amount),
            }));
        }
    })
}

function updateweights($fromSlot, $toSlot, $fromInv, $toInv, $toAmount) {
    if (($fromInv.attr("data-inventory") == "hotbar" && $toInv.attr("data-inventory") == "player") || ($fromInv.attr("data-inventory") == "player" && $toInv.attr("data-inventory") == "hotbar") || ($fromInv.attr("data-inventory") == "player" && $toInv.attr("data-inventory") == "player") || ($fromInv.attr("data-inventory") == "hotbar" && $toInv.attr("data-inventory") == "hotbar")) {
        return;
    }

    if ($fromInv != $toInv) {
        fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        if ($toAmount == 0) {$toAmount=fromData.amount}
        if (toData == null || fromData.name == toData.name) {
            if ($fromInv.attr("data-inventory") == "player") {
                totalWeight = totalWeight - (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther + (fromData.weight * $toAmount);
            } else {
                totalWeight = totalWeight + (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther - (fromData.weight * $toAmount);
            }
        } else {
            if ($fromInv.attr("data-inventory") == "player") {
                totalWeight = totalWeight - (fromData.weight * $toAmount);
                totalWeight = totalWeight + (toData.weight * toData.amount)

                totalWeightOther = totalWeightOther + (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther - (toData.weight * toData.amount);
            } else {
                totalWeight = totalWeight + (fromData.weight * $toAmount);
                totalWeight = totalWeight - (toData.weight * toData.amount)

                totalWeightOther = totalWeightOther - (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther + (toData.weight * toData.amount);
            }
        }
    }

    $(".player-inv-info p").html("Speler Inventaris " + (parseInt(totalWeight) / 1000).toFixed(2) + " / " + (playerMaxWeight / 1000).toFixed(2) + " KG");
    $(".other-inv-info p").html(otherLabel + " " + (parseInt(totalWeightOther) / 1000).toFixed(2) + " / " + (otherMaxWeight / 1000).toFixed(2) + " KG");
}

function swap($fromSlot, $toSlot, $fromInv, $toInv, $toAmount) {
    fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
    toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
    if (fromData !== undefined && fromData.amount >= $toAmount) {
        if ($toAmount == 0) {$toAmount=fromData.amount}
        if((toData != undefined || toData != null) && toData.name == fromData.name && !fromData.unique) {
            var newData = [];
            newData.name = toData.name;
            newData.label = toData.label;
            newData.amount = (parseInt($toAmount) + parseInt(toData.amount));
            newData.type = toData.type;
            newData.description = toData.description;
            newData.image = toData.image;
            newData.weight = toData.weight;
            newData.info = toData.info;
            newData.useable = toData.useable;
            newData.unique = toData.unique;
            newData.slot = parseInt($toSlot);

            if (fromData.amount == $toAmount) {
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newData);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                if ($toInv.attr("data-inventory") == "hotbar") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>[' + $toSlot + ']</p></div><div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + newData.label + '</p></div>');
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + newData.label + '</p></div>');
                }

                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-nodrag");

                $fromInv.find("[data-slot=" + $fromSlot + "]").removeData("item");
                $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
            } else if(fromData.amount > $toAmount) {
                var newDataFrom = [];
                newDataFrom.name = fromData.name;
                newDataFrom.label = fromData.label;
                newDataFrom.amount = parseInt((fromData.amount - $toAmount));
                newDataFrom.type = fromData.type;
                newDataFrom.description = fromData.description;
                newDataFrom.image = fromData.image;
                newDataFrom.weight = fromData.weight;
                newDataFrom.info = fromData.info;
                newDataFrom.useable = fromData.useable;
                newDataFrom.unique = fromData.unique;
                newDataFrom.slot = parseInt($fromSlot);

                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newData);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");
                
                if ($toInv.attr("data-inventory") == "hotbar") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>[' + $toSlot + ']</p></div><div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + newData.label + '</p></div>');
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + newData.label + '</p></div>');
                }
                
                // From Data zooi
                $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", newDataFrom);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");

                if ($fromInv.attr("data-inventory") == "hotbar") {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>[' + $fromSlot + ']</p></div><div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>');
                } else {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>');
                }    
            }
            $.post("http://qb-inventory/PlayDropSound", JSON.stringify({}));
            $.post("http://qb-inventory/SetInventoryData", JSON.stringify({
                fromInventory: $fromInv.attr("data-inventory"),
                toInventory: $toInv.attr("data-inventory"),
                fromSlot: $fromSlot,
                toSlot: $toSlot,
                fromAmount: $toAmount,
            }));
        } else {
            if (fromData.amount == $toAmount) {
                fromData.slot = parseInt($toSlot);
    
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", fromData);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                
                if ($toInv.attr("data-inventory") == "hotbar") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>[' + $toSlot + ']</p></div><div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + fromData.label + '</p></div>');
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + fromData.label + '</p></div>');
                }
    
                if (toData != undefined) {
                    toData.slot = parseInt($fromSlot);
    
                    $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
                    
                    $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", toData);
                    if ($fromInv.attr("data-inventory") == "hotbar") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>[' + $fromSlot + ']</p></div><div class="item-slot-img"><img src="images/' + toData.image + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + ' (' + ((toData.weight * toData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + toData.label + '</p></div>');
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toData.image + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + ' (' + ((toData.weight * toData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + toData.label + '</p></div>');
                    }
                    $.post("http://qb-inventory/SetInventoryData", JSON.stringify({
                        fromInventory: $fromInv.attr("data-inventory"),
                        toInventory: $toInv.attr("data-inventory"),
                        fromSlot: $fromSlot,
                        toSlot: $toSlot,
                        fromAmount: $toAmount,
                        toAmount: toData.amount,
                    }));
                } else {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-drag");
                    $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-nodrag");
    
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeData("item");
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');

                    $.post("http://qb-inventory/SetInventoryData", JSON.stringify({
                        fromInventory: $fromInv.attr("data-inventory"),
                        toInventory: $toInv.attr("data-inventory"),
                        fromSlot: $fromSlot,
                        toSlot: $toSlot,
                        fromAmount: $toAmount,
                    }));
                }
                $.post("http://qb-inventory/PlayDropSound", JSON.stringify({}));
            } else if(fromData.amount > $toAmount && (toData == undefined || toData == null)) {
                var newDataTo = [];
                newDataTo.name = fromData.name;
                newDataTo.label = fromData.label;
                newDataTo.amount = parseInt($toAmount);
                newDataTo.type = fromData.type;
                newDataTo.description = fromData.description;
                newDataTo.image = fromData.image;
                newDataTo.weight = fromData.weight;
                newDataTo.info = fromData.info;
                newDataTo.useable = fromData.useable;
                newDataTo.unique = fromData.unique;
                newDataTo.slot = parseInt($toSlot);
    
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newDataTo);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");
                if ($toInv.attr("data-inventory") == "hotbar") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>[' + $toSlot + ']</p></div><div class="item-slot-img"><img src="images/' + newDataTo.image + '" alt="' + newDataTo.name + '" /></div><div class="item-slot-amount"><p>' + newDataTo.amount + ' (' + ((newDataTo.weight * newDataTo.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + newDataTo.label + '</p></div>');
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataTo.image + '" alt="' + newDataTo.name + '" /></div><div class="item-slot-amount"><p>' + newDataTo.amount + ' (' + ((newDataTo.weight * newDataTo.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + newDataTo.label + '</p></div>');
                }

                var newDataFrom = [];
                newDataFrom.name = fromData.name;
                newDataFrom.label = fromData.label;
                newDataFrom.amount = parseInt((fromData.amount - $toAmount));
                newDataFrom.type = fromData.type;
                newDataFrom.description = fromData.description;
                newDataFrom.image = fromData.image;
                newDataFrom.weight = fromData.weight;
                newDataFrom.info = fromData.info;
                newDataFrom.useable = fromData.useable;
                newDataFrom.unique = fromData.unique;
                newDataFrom.slot = parseInt($fromSlot);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", newDataFrom);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
    
                if ($fromInv.attr("data-inventory") == "hotbar") {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>[' + $fromSlot + ']</p></div><div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>');
                } else {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>');
                }
                $.post("http://qb-inventory/PlayDropSound", JSON.stringify({}));
                $.post("http://qb-inventory/SetInventoryData", JSON.stringify({
                    fromInventory: $fromInv.attr("data-inventory"),
                    toInventory: $toInv.attr("data-inventory"),
                    fromSlot: $fromSlot,
                    toSlot: $toSlot,
                    fromAmount: $toAmount,
                }));
            } else {
                InventoryError($fromInv, $fromSlot);
            }
        }
    } else {
        //InventoryError($fromInv, $fromSlot);
    }
    handleDragDrop();
}

function InventoryError($elinv, $elslot) {
    $elinv.find("[data-slot=" + $elslot + "]").css("background", "rgba(156, 20, 20, 0.5)").css("transition", "background 500ms");
    setTimeout(function() {
        $elinv.find("[data-slot=" + $elslot + "]").css("background", "rgba(20, 20, 20, 0.5)");
    }, 500)
    $.post("http://qb-inventory/PlayDropFail", JSON.stringify({}));
}

(() => {
    Inventory = {};

    Inventory.slots = 40;

    Inventory.dropslots = 100;
    Inventory.droplabel = "Drop :)";
    Inventory.dropmaxweight = 900000

    Inventory.Open = function(data) {
        totalWeight = 0;
        totalWeightOther = 0;

        $("#qbus-inventory").fadeIn(250);
        if(data.other != null && data.other != "") {
            $(".other-inventory").attr("data-inventory", data.other.name);
        } else {
            $(".other-inventory").attr("data-inventory", 0);
        }
        // Hotbar
        for(i = 1; i < 6; i++) {
            $(".ply-hotbar-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
        }
        // Inventory
        for(i = 6; i < (data.slots + 1); i++) {
            $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
        }

        if (data.other != null && data.other != "") {
            for(i = 1; i < (data.other.slots + 1); i++) {
                $(".other-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            }
        } else {
            for(i = 1; i < (Inventory.dropslots + 1); i++) {
                $(".other-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            }
        }

        if (data.inventory !== null) {
            $.each(data.inventory, function (i, item) {
                if (item != null) {
                    totalWeight += (item.weight * item.amount);
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + item.label + '</p></div>');
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);

                    $(".ply-hotbar-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    $(".ply-hotbar-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>[' + item.slot + ']</p></div><div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + item.label + '</p></div>');
                    $(".ply-hotbar-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                }
                
            });
        }

        if ((data.other != null && data.other != "") && data.other.inventory != null) {
            $.each(data.other.inventory, function (i, item) {
                if (item != null) {
                    totalWeightOther += (item.weight * item.amount);
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + item.label + '</p></div>');
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                }
            });
        }

        $(".player-inv-info p").html("Speler Inventaris " + (totalWeight / 1000).toFixed(2) + " / " + (data.maxweight / 1000).toFixed(2) + " KG");
        playerMaxWeight = data.maxweight;
        if (data.other != null) {
            $(".other-inv-info p").html(data.other.label + " " + (totalWeightOther / 1000).toFixed(2) + " / " + (data.other.maxweight / 1000).toFixed(2) + " KG");
            otherMaxWeight = data.other.maxweight;
            otherLabel = data.other.label;
        } else {
            $(".other-inv-info p").html(Inventory.droplabel + " " + (totalWeightOther / 1000).toFixed(2) + " / " + (Inventory.dropmaxweight / 1000).toFixed(2) + " KG");
            otherMaxWeight = Inventory.dropmaxweight;
            otherLabel = Inventory.droplabel;
        }

        handleDragDrop();
    };

    Inventory.Close = function() {
        $(".item-slot").css("border", "1px solid rgba(255, 255, 255, 0.05)")
        $(".ply-hotbar-inventory").css("display", "block");
        $(".ply-iteminfo-container").css("display", "none");
        $("#qbus-inventory").fadeOut(300);
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