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
        case 9: // TAB
            Inventory.Close();
            break;
    }
});

var disableRightMouse = false;
var selectedItem = null;

$(document).on("contextmenu", ".item-slot", function(e){
    // $(".item-slot").css("border", "1px solid rgba(255, 255, 255, 0.1)")
    if (disableRightMouse == false) {
        if (selectedItem == null) {
            if ($(".ply-hotbar-inventory").css("display") === "block")  {
                $(this).css("border", "1px solid rgba(177, 36, 36, 0.5)")
                $(".ply-hotbar-inventory").fadeOut(250);
                $(".ply-iteminfo-container").fadeIn(250);
                disableRightMouse = true;
                selectedItem = this;
                setTimeout(function(){
                    $(".ply-hotbar-inventory").css("display", "none");
                    $(".ply-iteminfo-container").css("display", "block");
                    disableRightMouse = false;
                }, 500)
            } else {
                $(this).css("border", "1px solid rgba(255, 255, 255, 0.1)")
                $(".ply-hotbar-inventory").fadeIn(250);
                $(".ply-iteminfo-container").fadeOut(250);
                disableRightMouse = true;
                selectedItem = null;
                setTimeout(function(){
                    $(".ply-hotbar-inventory").css("display", "block");
                    $(".ply-iteminfo-container").css("display", "none");
                    disableRightMouse = false;
                }, 500)
            }
        } else {
            $(selectedItem).css("border", "1px solid rgba(255, 255, 255, 0.1)")
            $(this).css("border", "1px solid rgba(177, 36, 36, 0.5)")
            if (selectedItem == this) {
                if ($(".ply-iteminfo-container").css("display") === "block")  {
                    $(this).css("border", "1px solid rgba(255, 255, 255, 0.1)")
                    $(".ply-hotbar-inventory").fadeIn(250);
                    $(".ply-iteminfo-container").fadeOut(250);
                    disableRightMouse = true;
                    selectedItem = null;
                    setTimeout(function(){
                        $(".ply-hotbar-inventory").css("display", "block");
                        $(".ply-iteminfo-container").css("display", "none");
                        disableRightMouse = false;
                    }, 500)
                }
            } else {
                $(this).css("border", "1px solid rgba(177, 36, 36, 0.5)")
                $(".ply-hotbar-inventory").fadeOut(250);
                $(".ply-iteminfo-container").fadeIn(250);
                disableRightMouse = true;
                selectedItem = this;
                setTimeout(function(){
                    $(".ply-hotbar-inventory").css("display", "none");
                    $(".ply-iteminfo-container").css("display", "block");
                    disableRightMouse = false;
                }, 500)
            }
        }
    }

    FormatItemInfo($(this).data("item"));
});

 function FormatItemInfo(itemData) {
    if (itemData != null && itemData.info != "") {
        if (itemData.name == "id_card") {
            var gender = "Man";
            if (itemData.info.gender == 1) {
                gender = "Vrouw";
            }
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>BSN: </strong><span>' + itemData.info.citizenid + '</span></p><p><strong>Voornaam: </strong><span>' + itemData.info.firstname + '</span></p><p><strong>Achternaam: </strong><span>' + itemData.info.lastname + '</span></p><p><strong>Geboortedatum: </strong><span>' + itemData.info.birthdate + '</span></p><p><strong>Geslacht: </strong><span>' + gender + '</span></p><p><strong>Nationaliteit: </strong><span>' + itemData.info.nationality + '</span></p>');
        } else if (itemData.name == "driver_license") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Voornaam: </strong><span>' + itemData.info.firstname + '</span></p><p><strong>Achternaam: </strong><span>' + itemData.info.lastname + '</span></p><p><strong>Geboortedatum: </strong><span>' + itemData.info.birthdate + '</span></p><p><strong>Rijbewijzen: </strong><span>' + itemData.info.type + '</span></p>');
        } else if (itemData.type == "weapon") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            if (itemData.info.attachments != null) {
                var attachmentString = "";
                $.each(itemData.info.attachments, function (i, attachment) {
                    if (i == (itemData.info.attachments.length - 1)) {
                        attachmentString += attachment.label
                    } else {
                        attachmentString += attachment.label + ", "
                    }
                });
                $(".item-info-description").html('<p><strong>Serienummer: </strong><span>' + itemData.info.serie + '</span></p><p><strong>Attachments: </strong><span>' + attachmentString + '</span></p><p>' + itemData.description + '</p>');
            } else{
                $(".item-info-description").html('<p><strong>Serienummer: </strong><span>' + itemData.info.serie + '</span></p><p>' + itemData.description + '</p>');
            }
        } else if (itemData.name == "filled_evidence_bag") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            if (itemData.info.type == "casing") {
                $(".item-info-description").html('<p><strong>Bewijstuk: </strong><span>' + itemData.info.label + '</span></p><p><strong>Type nummer: </strong><span>' + itemData.info.ammotype + '</span></p><p><strong>Kaliber: </strong><span>' + itemData.info.ammolabel + '</span></p><p><strong>Serienummer: </strong><span>' + itemData.info.serie + '</span></p><p><strong>Plaats delict: </strong><span>' + itemData.info.street + '</span></p><br /><p>' + itemData.description + '</p>');
            }else if (itemData.info.type == "blood") {
                $(".item-info-description").html('<p><strong>Bewijstuk: </strong><span>' + itemData.info.label + '</span></p><p><strong>Bloodgroep: </strong><span>' + itemData.info.bloodtype + '</span></p><p><strong>DNA Code: </strong><span>' + itemData.info.dnalabel + '</span></p><p><strong>Plaats delict: </strong><span>' + itemData.info.street + '</span></p><br /><p>' + itemData.description + '</p>');
            }else if (itemData.info.type == "fingerprint") {
                $(".item-info-description").html('<p><strong>Bewijstuk: </strong><span>' + itemData.info.label + '</span></p><p><strong>Vingerpatroon: </strong><span>' + itemData.info.fingerprint + '</span></p><p><strong>Plaats delict: </strong><span>' + itemData.info.street + '</span></p><br /><p>' + itemData.description + '</p>');
            }
        } else if (itemData.info.costs != undefined && itemData.info.costs != null) {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p>'+ itemData.info.costs + '</p>');
        } else if (itemData.name == "stickynote") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p>'+ itemData.info.label + '</p>');
        } else {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p>' + itemData.description + '</p>')
        }
    } else {
        $(".item-info-title").html('<p>'+itemData.label+'</p>')
        $(".item-info-description").html('<p>' + itemData.description + '</p>')
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

            $(".item-slot").css("border", "1px solid rgba(255, 255, 255, 0.1)")

            var itemData = $(this).data("item");
            var dragAmount = $("#item-amount").val();
            if (!itemData.useable) {
                $("#item-use").css("background", "rgba(35,35,35, 0.5");
            }

            if ( dragAmount == 0) {
                if (itemData.price != null) {
                    $(this).find(".item-slot-amount p").html('0 (0.0)');
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html('('+itemData.amount+') €' + itemData.price);
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                } else {
                    $(this).find(".item-slot-amount p").html('0 (0.0)');
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html(itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')');
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                }
            } else if(dragAmount > itemData.amount) {
                if (itemData.price != null) {
                    $(this).find(".item-slot-amount p").html('('+itemData.amount+') €' + itemData.price);
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                } else {
                    $(this).find(".item-slot-amount p").html(itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')');
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                }
                InventoryError($(this).parent(), $(this).attr("data-slot"));
            } else if(dragAmount > 0) {
                if (itemData.price != null) {
                    $(this).find(".item-slot-amount p").html('('+itemData.amount+') €' + itemData.price);
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html('('+itemData.amount+') €' + itemData.price);
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                } else {
                    $(this).find(".item-slot-amount p").html((itemData.amount - dragAmount) + ' (' + ((itemData.weight * (itemData.amount - dragAmount)) / 1000).toFixed(1) + ')');
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html(dragAmount + ' (' + ((itemData.weight * dragAmount) / 1000).toFixed(1) + ')');
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
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
            $(this).css("background", "rgba(0, 0, 0, 0.2)");
            $(this).find("img").css("filter", "brightness(100%)");
            $("#item-use").css("background", "rgba(235, 235, 235, 0.08)");
        },
    });

    $(".item-slot").droppable({
        hoverClass: 'item-slot-hoverClass',
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
                if (updateweights(fromSlot, toSlot, fromInventory, toInventory, toAmount)) {
                    swap(fromSlot, toSlot, fromInventory, toInventory, toAmount);
                }
            }
        },
    });

    $("#item-use").droppable({
        hoverClass: 'button-hover',
        drop: function(event, ui) {
            fromData = ui.draggable.data("item");
            fromInventory = ui.draggable.parent().attr("data-inventory");
            if(fromData.useable) {
                if (fromData.shouldClose) {
                    Inventory.Close();
                }
                $.post("http://qb-inventory/UseItem", JSON.stringify({
                    inventory: fromInventory,
                    item: fromData,
                }));
            }
        }
    });

    $("#item-drop").droppable({
        hoverClass: 'item-slot-hoverClass',
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
        return true;
    }

    if (($fromInv.attr("data-inventory").split("-")[0] == "itemshop" && $toInv.attr("data-inventory").split("-")[0] == "itemshop") || ($fromInv.attr("data-inventory") == "crafting" && $toInv.attr("data-inventory") == "crafting")) {
        itemData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>('+itemData.amount+') €'+itemData.price+'</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        } else {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>'+itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');

        }

        InventoryError($fromInv, $fromSlot);
        return false;
    }

    if ($toAmount == 0 && ($fromInv.attr("data-inventory").split("-")[0] == "itemshop" || $fromInv.attr("data-inventory") == "crafting")) {
        itemData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>('+itemData.amount+') €'+itemData.price+'</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        } else {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>'+itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        }
 
        InventoryError($fromInv, $fromSlot);
        return false;
    }

    if ($toInv.attr("data-inventory").split("-")[0] == "itemshop" || $toInv.attr("data-inventory") == "crafting") {
        itemData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        if ($toInv.attr("data-inventory").split("-")[0] == "itemshop") {
            $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>('+itemData.amount+') €'+itemData.price+'</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        } else {
            $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>'+itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        }
 
        InventoryError($fromInv, $fromSlot);
        return false;
    }

    if ($fromInv.attr("data-inventory") != $toInv.attr("data-inventory")) {
        fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        if ($toAmount == 0) {$toAmount=fromData.amount}
        if (toData == null || fromData.name == toData.name) {
            if ($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") {
                totalWeight = totalWeight - (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther + (fromData.weight * $toAmount);
            } else {
                totalWeight = totalWeight + (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther - (fromData.weight * $toAmount);
            }
        } else {
            if ($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") {
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

    if (totalWeight > playerMaxWeight || (totalWeightOther > otherMaxWeight && $fromInv.attr("data-inventory").split("-")[0] != "itemshop" && $fromInv.attr("data-inventory") != "crafting")) {
        InventoryError($fromInv, $fromSlot);
        return false;
    }

    $("#player-inv-weight").html((parseInt(totalWeight) / 1000).toFixed(2) + " / " + (playerMaxWeight / 1000).toFixed(2) + " kg");
    if ($fromInv.attr("data-inventory").split("-")[0] != "itemshop" && $toInv.attr("data-inventory").split("-")[0] != "itemshop" && $fromInv.attr("data-inventory") != "crafting" && $toInv.attr("data-inventory") != "crafting") {
        $("#other-inv-label").html(otherLabel)
        $("#other-inv-weight").html((parseInt(totalWeightOther) / 1000).toFixed(2) + " / " + (otherMaxWeight / 1000).toFixed(2) + " kg")
    }

    return true;
}

var combineslotData = null;

$(document).on('click', '.CombineItem', function(e){
    e.preventDefault();
    if (combineslotData.toData.combinable.anim != null) {
        Inventory.Close();

        $.post('http://qb-inventory/combineWithAnim', JSON.stringify({
            combineData: combineslotData.toData.combinable,
            usedItem: combineslotData.toData.name,
            requiredItem: combineslotData.fromData.name
        }))
    } else {
        $(".combine-option-container").hide();
        blurInventory(false)
    
        $.post('http://qb-inventory/combineItem', JSON.stringify({
            reward: combineslotData.toData.combinable.reward,
            toItem: combineslotData.toData.name,
            fromItem: combineslotData.fromData.name
        }))
    
        var $fromSlot = combineslotData.fromSlot
        var $toSlot = combineslotData.toSlot
        var $fromInv = combineslotData.fromInv
        var $toInv = combineslotData.toInv
        var $toAmount = combineslotData.toAmount
    
        if (combineslotData.fromData.amount - 1 <= 0) {
            $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-drag");
            $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-nodrag");
    
            $fromInv.find("[data-slot=" + $fromSlot + "]").removeData("item");
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
        }
    
        if (combineslotData.toData.amount - 1 <= 0) {
            $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-drag");
            $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-nodrag");
    
            $toInv.find("[data-slot=" + $toSlot + "]").removeData("item");
            $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
        }
    }
});

$(document).on('click', '.SwitchItem', function(e){
    e.preventDefault();
    $(".combine-option-container").hide();
    blurInventory(false)

    optionSwitch(combineslotData.fromSlot, combineslotData.toSlot, combineslotData.fromInv, combineslotData.toInv, combineslotData.toAmount, combineslotData.toData, combineslotData.fromData)

});

function optionSwitch($fromSlot, $toSlot, $fromInv, $toInv, $toAmount, toData, fromData) {
    fromData.slot = parseInt($toSlot);
    
    $toInv.find("[data-slot=" + $toSlot + "]").data("item", fromData);

    $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
    $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

    
    if ($toInv.attr("data-inventory") == "hotbar") {
        $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>[' + $toSlot + ']</p></div><div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + fromData.label + '</p></div>');
    } else {
        $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + fromData.label + '</p></div>');
    }

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
}

function swap($fromSlot, $toSlot, $fromInv, $toInv, $toAmount) {
    fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
    toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
    if (fromData !== undefined && fromData.amount >= $toAmount) {
        if (($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") && $toInv.attr("data-inventory").split("-")[0] == "itemshop" && $toInv.attr("data-inventory") == "crafting") {
            InventoryError($fromInv, $fromSlot);
            return;
        }

        if ($toAmount == 0 && $fromInv.attr("data-inventory").split("-")[0] == "itemshop" && $fromInv.attr("data-inventory") == "crafting") {
            InventoryError($fromInv, $fromSlot);
            return;
        } else if ($toAmount == 0) {
            $toAmount=fromData.amount
        }
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
                newDataFrom.price = fromData.price;
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
                } else if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>('+newDataFrom.amount+') €'+newDataFrom.price+'</p></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>');
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
                if (toData != undefined && toData.combinable != null && isItemAllowed(fromData.name, toData.combinable.accept)) {
                    $.post('http://qb-inventory/getCombineItem', JSON.stringify({item: toData.combinable.reward}), function(item){
                        $('.combine-option-text').html("<p>Als je dit item combined krijg je een: <b>"+item.label+"</b></p>");
                    })
                    $(".combine-option-container").fadeIn(100);
                    blurInventory(true);
                    combineslotData = []
                    combineslotData.fromData = fromData
                    combineslotData.toData = toData
                    combineslotData.fromSlot = $fromSlot
                    combineslotData.toSlot = $toSlot
                    combineslotData.fromInv = $fromInv
                    combineslotData.toInv = $toInv
                    combineslotData.toAmount = $toAmount
                    return
                }

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
                newDataFrom.price = fromData.price;
                newDataFrom.info = fromData.info;
                newDataFrom.useable = fromData.useable;
                newDataFrom.unique = fromData.unique;
                newDataFrom.slot = parseInt($fromSlot);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", newDataFrom);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
    
                if ($fromInv.attr("data-inventory") == "hotbar") {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>[' + $fromSlot + ']</p></div><div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>');
                }  else if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>('+newDataFrom.amount+') €'+newDataFrom.price+'</p></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>');
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

function isItemAllowed(item, allowedItems) {
    var retval = false
    $.each(allowedItems, function(index, i){
        if (i == item) {
            retval = true;
        }
    });
    return retval
}

function blurInventory(toggle) {
    if (toggle) {
        $(".inv-options").css("filter", "blur(2px)");
        $(".other-inventory").css("filter", "blur(2px)");
        $(".player-inventory").css("filter", "blur(2px)");
        $(".ply-hotbar-inventory").css("filter", "blur(2px)");
    } else {
        $(".inv-options").css("filter", "none");
        $(".other-inventory").css("filter", "none");
        $(".player-inventory").css("filter", "none");
        $(".ply-hotbar-inventory").css("filter", "none");
    }
}

function InventoryError($elinv, $elslot) {
    $elinv.find("[data-slot=" + $elslot + "]").css("background", "rgba(156, 20, 20, 0.5)").css("transition", "background 500ms");
    setTimeout(function() {
        $elinv.find("[data-slot=" + $elslot + "]").css("background", "rgba(20, 20, 20, 0.5)");
    }, 500)
    $.post("http://qb-inventory/PlayDropFail", JSON.stringify({}));
}

var requiredItemOpen = false;

(() => {
    Inventory = {};

    Inventory.slots = 40;

    Inventory.dropslots = 30;
    Inventory.droplabel = "Grond";
    Inventory.dropmaxweight = 100000

    Inventory.Error = function() {
        $.post("http://qb-inventory/PlayDropFail", JSON.stringify({}));
    }

    Inventory.Open = function(data) {
        totalWeight = 0;
        totalWeightOther = 0;

        $(".player-inventory").find(".item-slot").remove();
        $(".ply-hotbar-inventory").find(".item-slot").remove();

        if (requiredItemOpen) {
            $(".requiredItem-container").hide();
            requiredItemOpen = false;
        }

        $("#qbus-inventory").fadeIn(300);
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
                    if (item.price != null) {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>('+item.amount+') €'+item.price+'</p></div><div class="item-slot-label"><p>' + item.label + '</p></div>');
                    } else {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + item.label + '</p></div>');
                    }
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                }
            });
        }

        $("#player-inv-weight").html((totalWeight / 1000).toFixed(2) + " / " + (data.maxweight / 1000).toFixed(2) + " kg");
        playerMaxWeight = data.maxweight;
        if (data.other != null) 
        {
            var name = data.other.name.toString()
            if (name != null && (name.split("-")[0] == "itemshop" || name == "crafting")) {
                $("#other-inv-label").html(data.other.label);
            } else {
                $("#other-inv-label").html(data.other.label)
                $("#other-inv-weight").html((totalWeightOther / 1000).toFixed(2) + " / " + (data.other.maxweight / 1000).toFixed(2) + " kg")
            }
            otherMaxWeight = data.other.maxweight;
            otherLabel = data.other.label;
        } else {
            $("#other-inv-label").html(Inventory.droplabel)
            $("#other-inv-weight").html((totalWeightOther / 1000).toFixed(2) + " / " + (Inventory.dropmaxweight / 1000).toFixed(2) + " kg")
            otherMaxWeight = Inventory.dropmaxweight;
            otherLabel = Inventory.droplabel;
        }

        handleDragDrop();
    };

    Inventory.Close = function() {
        $(".item-slot").css("border", "1px solid rgba(255, 255, 255, 0.1)");
        $(".ply-hotbar-inventory").css("display", "block");
        $(".ply-iteminfo-container").css("display", "none");
        $("#qbus-inventory").fadeOut(300);
        $(".combine-option-container").hide();
        blurInventory(false);
        $(".item-slot").remove();
        $.post("http://qb-inventory/CloseInventory", JSON.stringify({}));
    };

    Inventory.Update = function(data) {
        totalWeight = 0;
        totalWeightOther = 0;
        $(".player-inventory").find(".item-slot").remove();
        $(".ply-hotbar-inventory").find(".item-slot").remove();
        if (data.error) {
            Inventory.Error();
        }
        // Hotbar
        for(i = 1; i < 6; i++) {
            $(".ply-hotbar-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
        }
        // Inventory
        for(i = 6; i < (data.slots + 1); i++) {
            $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
        }

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

        $("#player-inv-weight").html((totalWeight / 1000).toFixed(2) + " / " + (data.maxweight / 1000).toFixed(2) + " kg");

        handleDragDrop();
    };

    Inventory.ToggleHotbar = function(data) {
        if (data.open) {
            $(".z-hotbar-inventory").html("");
            for(i = 1; i < 6; i++) {
                var elem = '<div class="z-hotbar-item-slot" data-zhotbarslot="'+i+'"> <div class="z-hotbar-item-slot-key"><p>['+i+']</p></div><div class="z-hotbar-item-slot-img"></div><div class="z-hotbar-item-slot-label"><p>&nbsp;</p></div></div>'
                $(".z-hotbar-inventory").append(elem);
            }
            $.each(data.items, function(i, item){
                if (item != null) {
                    $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").html('<div class="z-hotbar-item-slot-key"><p>[' + item.slot + ']</p></div><div class="z-hotbar-item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="z-hotbar-item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div><div class="z-hotbar-item-slot-label"><p>' + item.label + '</p></div>');
                }
            });
            $(".z-hotbar-inventory").fadeIn(150);
        } else {
            $(".z-hotbar-inventory").fadeOut(150, function(){
                $(".z-hotbar-inventory").html("");
            });
        }
    }

    Inventory.UseItem = function(data) {
        $(".itembox-container").hide();
        $(".itembox-container").fadeIn(250);
        $("#itembox-action").html("<p>Gebruikt</p>");
        $("#itembox-label").html("<p>"+data.item.label+"</p>");
        $("#itembox-image").html('<div class="item-slot-img"><img src="images/' + data.item.image + '" alt="' + data.item.name + '" /></div>')
        setTimeout(function(){
            $(".itembox-container").fadeOut(250);
        }, 2000)
    };

    var itemBoxtimer = null;
    var requiredTimeout = null;

    Inventory.itemBox = function(data) {
        if (itemBoxtimer !== null) {
            clearTimeout(itemBoxtimer)
        }
        if (data.type == "use") {
            $("#itembox-action").html("<p>Gebruikt</p>");
        } else if (data.type == "add") {
            $("#itembox-action").html("<p>Ontvangen</p>");
        } else if (data.type == "remove") { 
            $("#itembox-action").html("<p>Verwijderd</p>");
        }

        $(".itembox-container").hide();
        $(".itembox-container").fadeIn(250);
        $("#itembox-label").html("<p>"+data.item.label+"</p>");
        $("#itembox-image").html('<div class="item-slot-img"><img src="images/' + data.item.image + '" alt="' + data.item.name + '" /></div>')
        itemBoxtimer = setTimeout(function(){
            $(".itembox-container").fadeOut(250);
        }, 2000)
    };

    Inventory.RequiredItem = function(data) {
        if (requiredTimeout !== null) {
            clearTimeout(requiredTimeout)
        }
        if (data.toggle) {
            if (!requiredItemOpen) {
                $(".requiredItem-container").html("");
                $.each(data.items, function(index, item){
                    var element = '<div class="requiredItem-box"><div id="requiredItem-action">Nodig</div><div id="requiredItem-label"><p>'+item.label+'</p></div><div id="requiredItem-image"><div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div></div></div>'
                    $(".requiredItem-container").hide();
                    $(".requiredItem-container").append(element);
                    $(".requiredItem-container").fadeIn(100);
                });
                requiredItemOpen = true;
            }
        } else {
            $(".requiredItem-container").fadeOut(100);
            requiredTimeout = setTimeout(function(){
                $(".requiredItem-container").html("");
                requiredItemOpen = false;
            }, 100)
        }
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
                case "itemBox":
                    Inventory.itemBox(event.data);
                    break;
                case "requiredItem":
                    Inventory.RequiredItem(event.data);
                    break;
                case "toggleHotbar":
                    Inventory.ToggleHotbar(event.data);
                    break;
            }
        })
    }

})();