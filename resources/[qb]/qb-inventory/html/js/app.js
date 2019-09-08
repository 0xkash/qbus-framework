$(document).ready(function () {
    $("#inv-item-search").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $(".item-name > span").filter(function () {
            $(".ply-inv-item").each(function() {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
            });
        });
    });

    $("#item-amount").on("change", function () {
        $(".inv-info").html("");
    });
});

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
        var itemN;
        var iItem = {};
        iItem["cash"] = {};
        iItem["blackmoney"] = {};


        $('#container').css({"display":"block"}).animate({
            opacity: 1,
        }, 250, function() {

        });
        if(data.money.cash > 0) {
            $(".ply-inventory").append('<div class="ply-inv-item" data-item-id="cash" data-item-name="cash"><div class="item-amount inv-cash"><span>&euro;'+ data.money.cash +',-</span></div><div class="item-img"><img src="https://i.imgur.com/gTmuaFR.png" /></div><div class="item-name"><span>Geld</span></div></div>');
            iItem["cash"].amount = data.money.cash;
            iItem["cash"].label = "Contant geld";
            iItem["cash"].useable = 0;
            iItem["cash"].name = "cash";
            iItem["cash"].id = "cash";
        } else {
            $("[data-item-name=cash]").css({"display":"none"});
        }

        if(data.money.blackmoney > 0) {
            $(".ply-inventory").append('<div class="ply-inv-item" data-item-id="blackmoney" data-item-name="blackmoney"><div class="item-amount inv-blackmoney"><span>&euro;'+ data.money.blackmoney +',-</span></div><div class="item-img"><img src="https://i.imgur.com/ujNzRn7.png" /></div><div class="item-name"><span>Zwart geld</span> </div></div>');
            iItem["blackmoney"].amount = data.money.blackmoney;
            iItem["blackmoney"].label = "Contant geld";
            iItem["blackmoney"].useable = 0;
            iItem["blackmoney"].name = "blackmoney";
            iItem["blackmoney"].id = "blackmoney";
        } else {
            $("[data-item-name=blackmoney]").css({"display":"none"});
        }

        // SPELER INVENTORY ENZO
        $(".inv-container").css({"display":"block", "width":"100%"});
        $(".iteminfo-box").css({"display":"none"});
        $(".btn-use").css({"display":"none"});
        $(".btn-give").css({"display":"inline-block"});
        $(".btn-drop").css({"display":"inline-block"});
        $.each(data.items, function (i, item) {
            if(item.amount > 0) {
                iItem[item.id] = item;
                if(item.maxamount > 0){
                    $(".ply-inventory").append('<div class="ply-inv-item" data-item-id="' + item.id + '" data-item-name="' + item.name + '"><div class="item-amount"><span>' + item.amount + '/<small>' + item.maxamount + '</small></span></div><div class="item-img"><img src="' + item.imgurl + '" /></div><div class="item-name"><span>' + item.label + '</span></div></div>');
                } else if (item.name.toLowerCase() === "id_card" || item.name.toLowerCase() === "driver_license" || item.name.toLowerCase().indexOf("weapon_") >= 0) {
                    $(".ply-inventory").append('<div class="ply-inv-item" data-item-id="' + item.id + '" data-item-name="' + item.name + '"><div class="item-amount"><span>&nbsp</span></div><div class="item-img"><img src="' + item.imgurl + '" /></div><div class="item-name"><span>' + item.label + '</span></div></div>');
                } else {
                    $(".ply-inventory").append('<div class="ply-inv-item" data-item-id="' + item.id + '" data-item-name="' + item.name + '"><div class="item-amount"><span>' + item.amount + '</span></div><div class="item-img"><img src="' + item.imgurl + '" /></div><div class="item-name"><span>' + item.label + '</span></div></div>');
                }
            }
        });

        $(".ply-inv-item").each(function() {
            $(this).hover(function() {
                $(this).addClass("selected");
            }, function() {
                $(this).removeClass("selected");
            });
            $(this).click(function () {
                $(".ply-inv-item").removeClass("active");
                $(".other-inv-item").removeClass("active");
                $(this).addClass("active");
                itemid = $(this).attr("data-item-id");
                itemN = $(this).attr("data-item-name");
                if (itemN.toLowerCase().indexOf("weapon_") >= 0) {
                    $(".amount-label").css({"display":"none"});
                    $("#item-amount").css({"display":"none"});
                } else if (itemN.toLowerCase() === "driver_license" || itemN.toLowerCase() === "id_card") {
                    $(".amount-label").css({"display":"none"});
                    $("#item-amount").css({"display":"none"});
                    $(".iteminfo-box").css({"display":"block"});
                    if (itemN.toLowerCase() === "id_card") {
                        $(".iteminfo-item").html('<h3 class="iteminfo-title">Identiteitskaart</h3><p><strong>BSN:</strong> '+iItem[itemid].iteminfo.bsn+'</p><p><strong>Naam:</strong> '+iItem[itemid].iteminfo.name+'</p><p><strong>Geboortedatum:</strong> '+iItem[itemid].iteminfo.birthday+'</p><p><strong>Geslacht:</strong> '+iItem[itemid].iteminfo.gender+'</p>');
                    } else if (itemN.toLowerCase() === "driver_license") {
                        $(".iteminfo-item").html('<h3 class="iteminfo-title">Rijbewijs</h3><p><strong>Naam:</strong> '+iItem[itemid].iteminfo.name+'</p><p><strong>Geboortedatum:</strong> '+iItem[itemid].iteminfo.birthday+'</p><p><strong>Type:</strong> '+iItem[itemid].iteminfo.type+'</p>');
                    }
                } else{
                    if (!data.multi) {
                        $(".amount-label").css({"display":"inline-block"});
                        $(".btn-give").css({"display":"inline-block"});
                        $(".btn-drop").css({"display":"inline-block"});
                    }
                    $("#item-amount").css({"display":"inline-block"});
                    $(".iteminfo-box").css({"display":"none"});
                }
                if(iItem[itemid].useable === 1) {
                    if (!data.multi) {
                        $(".btn-use").css({"display":"inline-block"});
                    }
                } else {
                    $(".btn-use").css({"display":"none"});
                }
            });
        });

        $(".btn-drop").unbind("click").click(function () {
            var invAmount = iItem[itemid].amount;
            if (itemN.toLowerCase().indexOf("weapon_") >= 0) {
                $.post("http://pt_inventory/DropItem", JSON.stringify({
                    itemName: itemN,
                    itemAmount: invAmount,
                    itemLabel: iItem[itemid].label,
                    itemid: iItem[itemid].id,
                }));
                Inventory.Close();
            } else {
                if (itemN.toLowerCase() === "driver_license" || itemN.toLowerCase() === "id_card") {
                    $.post("http://pt_inventory/DropItem", JSON.stringify({
                        itemName: itemN,
                        itemAmount: 1,
                        itemLabel: iItem[itemid].label,
                        itemid: iItem[itemid].id,
                    }));
                    Inventory.Close();
                } else {
                    var amount = $("#item-amount").val();
                    if(amount === '' || amount <= 0) {
                        $(".inv-info").css({"color":"red"}).html("Vul een aantal in!");
                    }else if(amount <= invAmount) {
                        $.post("http://pt_inventory/DropItem", JSON.stringify({
                            itemName: itemN,
                            itemAmount: amount,
                            itemLabel: iItem[itemid].label,
                            itemid: iItem[itemid].id,
                        }));
                        Inventory.Close();
                    } else {
                        $(".inv-info").css({"color":"red"}).html("Je hebt niet genoeg aantal <strong>" + iItem[itemid].label + "</strong>!");
                    }
                }
            }
        });

        $(".btn-give").unbind("click").click(function () {
            var invAmount = iItem[itemid].amount;
            if (itemN.toLowerCase().indexOf("weapon_") >= 0) {
                $.post("http://pt_inventory/GiveItem", JSON.stringify({
                    itemName: itemN,
                    itemAmount: invAmount,
                    itemLabel: iItem[itemid].label,
                    itemid: iItem[itemid].id,
                }));
                Inventory.Close();
            } else {
                if (itemN.toLowerCase() === "driver_license" || itemN.toLowerCase() === "id_card") {
                    $.post("http://pt_inventory/GiveItem", JSON.stringify({
                        itemName: itemN,
                        itemAmount: 1,
                        itemLabel: iItem[itemid].label,
                        itemid: iItem[itemid].id,
                    }));
                    Inventory.Close();
                } else {
                    var amount = $("#item-amount").val();
                    if(amount === '' || amount <= 0) {
                        $(".inv-info").css({"color":"red"}).html("Vul een aantal in!");
                    } else if(amount <= invAmount) {
                        $.post("http://pt_inventory/GiveItem", JSON.stringify({
                            itemName: itemN,
                            itemAmount: amount,
                            itemLabel: iItem[itemid].label,
                            itemid: iItem[itemid].id,
                        }));
                        Inventory.Close();
                    } else {
                        $(".inv-info").css({"color":"red"}).html("Je hebt niet de correcte hoeveelheid van <strong>" + iItem[itemid].label + "</strong>!");
                    }
                }
            }
        });

        $(".btn-use").unbind("click").click(function () {
            $.post("http://pt_inventory/UseItem", JSON.stringify({
                itemName: itemN,
                itemid: itemid,
            }));
            Inventory.Close();
        });
        if (data.multi) {
            var oItem = {};
            oItem["cash"] = {};
            oItem["blackmoney"] = {};
            $(".inv-container").css({"width":"45%"});
            $(".other-inv-container").css({"display":"block"});
            $(".switch-button-container").css({"display":"block"});
            $(".btn-give").css({"display":"none"});
            $(".btn-drop").css({"display":"none"});

            if (data.otheritems !== null && data.otheritems !== {}) {
                $.each(data.otheritems, function (i, item) {
                    if(item.amount > 0) {
                        if(item.name === "cash") {
                            $(".other-inventory").append('<div class="other-inv-item" data-item-id="cash" data-item-name="othercash"><div class="item-amount inv-cash"><span>&euro;'+ item.amount +',-</span></div><div class="item-img"><img src="https://i.imgur.com/gTmuaFR.png" /></div><div class="item-name"><span>Geld</span></div></div>');
                            oItem["cash"].amount = item.amount;
                            oItem["cash"].label = "Contant geld";
                            oItem["cash"].useable = 0;
                            oItem["cash"].name = "cash";
                            oItem["cash"].id = "cash";
                        } else {
                            delete oItem["cash"];
                            $("[data-item-name=othercash]").css({"display":"none"});
                        }

                        if(item.name === "blackmoney") {
                            $(".other-inventory").append('<div class="other-inv-item" data-item-id="blackmoney" data-item-name="otherblackmoney"><div class="item-amount inv-blackmoney"><span>&euro;'+ item.amount +',-</span></div><div class="item-img"><img src="https://i.imgur.com/ujNzRn7.png" /></div><div class="item-name"><span>Zwart geld</span> </div></div>');
                            oItem["blackmoney"].amount = item.amount;
                            oItem["blackmoney"].label = "Contant geld";
                            oItem["blackmoney"].useable = 0;
                            oItem["blackmoney"].name = "blackmoney";
                            oItem["blackmoney"].id = "blackmoney";
                        } else {
                            delete oItem["blackmoney"];
                            $("[data-item-name=otherblackmoney]").css({"display":"none"});
                        }
                        if(item.name !== "cash" && item.name !== "blackmoney") {
                            oItem[item.id] = item;
                            if(item.maxamount > 0){
                                $(".other-inventory").append('<div class="other-inv-item" data-item-id="' + item.id + '" data-item-name="' + item.name + '"><div class="item-amount"><span>' + item.amount + '/<small>' + item.maxamount + '</small></span></div><div class="item-img"><img src="' + item.imgurl + '" /></div><div class="item-name"><span>' + item.label + '</span></div></div>');
                            } else if (item.name.toLowerCase() === "id_card" || item.name.toLowerCase() === "driver_license" || item.name.toLowerCase().indexOf("weapon_") >= 0) {
                                $(".other-inventory").append('<div class="other-inv-item" data-item-id="' + item.id + '" data-item-name="' + item.name + '"><div class="item-amount"><span>&nbsp</span></div><div class="item-img"><img src="' + item.imgurl + '" /></div><div class="item-name"><span>' + item.label + '</span></div></div>');
                            } else {
                                $(".other-inventory").append('<div class="other-inv-item" data-item-id="' + item.id + '" data-item-name="' + item.name + '"><div class="item-amount"><span>' + item.amount + '</span></div><div class="item-img"><img src="' + item.imgurl + '" /></div><div class="item-name"><span>' + item.label + '</span></div></div>');
                            }
                        }
                    }
                });
                $(".other-inv-item").each(function() {
                    $(this).hover(function() {
                        $(this).addClass("selected");
                    }, function() {
                        $(this).removeClass("selected");
                    });
                    $(this).click(function () {
                        $(".ply-inv-item").removeClass("active");
                        $(".other-inv-item").removeClass("active");
                        itemid = $(this).attr("data-item-id");
                        $(this).addClass("active");
                    });
                });
                // VAN ANDERE INV NAAR SPELER
                $(".btn-to-ply-inv").unbind("click").click(function () {
                    var invAmount = oItem[itemid].amount;
                    var GivenItem = oItem[itemid];
                    if (GivenItem !== null && GivenItem !== "" && GivenItem !== {}) {
                        if (oItem[itemid].name.toLowerCase().indexOf("weapon_") >= 0) {
                            delete oItem[itemid];
                            $.post("http://pt_inventory/OtherToPlayer", JSON.stringify({
                                GivenItem: GivenItem,
                                GivenAmount: invAmount,
                                OtherItems: oItem,
                                OtherType: data.type,
                            }));
                            Inventory.Close();
                        } else {
                            var amount = $("#other-item-amount").val();
                            if(amount === '' || amount <= 0) {
                                $(".other-inv-info").css({"color":"red"}).html("Vul een aantal in!");
                            }else if(amount <= invAmount) {
                                if (oItem[itemid].amount - amount < 1) {
                                    delete oItem[itemid];
                                } else {
                                    oItem[itemid].amount = oItem[itemid].amount - amount;
                                }
                                $.post("http://pt_inventory/OtherToPlayer", JSON.stringify({
                                    GivenItem: GivenItem,
                                    GivenAmount: amount,
                                    OtherItems: oItem,
                                    OtherType: data.type,
                                    ExtraInfo: data.extra,
                                }));
                                Inventory.Close();
                            } else {
                                $(".other-inv-info").css({"color":"red"}).html("Je hebt niet genoeg aantal <strong>" + oItem[itemid].label + "</strong>!");
                            }
                        }
                    } else {
                        $(".other-inv-info").css({"color":"red"}).html("Je hebt een verkeerde item geselecteerd!");
                    }
                });
                // VAN SPELER NAAR ANDERE INV
                $(".btn-to-other-inv").unbind("click").click(function () {
                    var invAmount = iItem[itemid].amount;
                    var GivenItem = iItem[itemid];
                    if (GivenItem !== null && GivenItem !== "" && GivenItem !== {}) {
                        if (iItem[itemid].name.toLowerCase().indexOf("weapon_") >= 0) {
                            $.post("http://pt_inventory/PlayerToOther", JSON.stringify({
                                GivenItem: GivenItem,
                                GivenAmount: invAmount,
                                OtherType: data.type,
                            }));
                            Inventory.Close();
                        } else {
                            var amount = $("#item-amount").val();
                            if(amount === '' || amount <= 0) {
                                $(".inv-info").css({"color":"red"}).html("Vul een aantal in!");
                            }else if(amount <= invAmount) {
                                if (iItem[itemid].amount - amount < 1) {
                                    delete iItem[itemid];
                                } else {
                                    iItem[itemid].amount = iItem[itemid].amount - amount;
                                }
                                $.post("http://pt_inventory/PlayerToOther", JSON.stringify({
                                    GivenItem: GivenItem,
                                    GivenAmount: amount,
                                    OtherType: data.type,
                                    ExtraInfo: data.extra,
                                }));
                                Inventory.Close();
                            } else {
                                $(".inv-info").css({"color":"red"}).html("Je hebt niet genoeg aantal <strong>" + iItem[itemid].label + "</strong>!");
                            }
                        }
                    } else {
                        $(".inv-info").css({"color":"red"}).html("Je hebt een verkeerde item geselecteerd!");
                    }
                });
            }


        }
    };

    Inventory.Close = function(data) {

        $.post("http://pt_inventory/CloseInventory", JSON.stringify({}));

        $('#container').animate({
            opacity: 0,
        }, 250, function() {
            $(".ply-inv-item").remove();
            $(".other-inv-item").remove();
            $(".inv-container").css({"display":"none"});
            $(".other-inv-container").css({"display":"none"});
            $(".switch-button-container").css({"display":"none"});
            $("#item-amount").val('');
            $("#other-item-amount").val('');
            $(this).css({"display":"none"});
        });
    };

    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case "open":
                    Inventory.Open(event.data);
                    break;
            }
        })
    }

})();