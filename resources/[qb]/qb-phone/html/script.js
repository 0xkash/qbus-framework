qbPhone = {}

var inPhone = false;
var phoneApps = null;
var allowNotifys = null;
var myNotify = false;
var currentApp = ".phone-home-page";
var homePage = ".phone-home-page";
var choosingBg = false;
var curBg = "bg-1";
var selectedContact = null;

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            qbPhone.Close();
            break;
    }
});

$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();

    console.log('QB Phone\'s javascript has succesfully loaded, no errors occured..')

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action = "phone") {
            if (!eventData.task) {
                if (eventData.open == true) {
                    qbPhone.Open()
                    qbPhone.setupPhoneApps(eventData.apps)
                } else if (eventData.open == false) {
                    qbPhone.Close()
                }
            }
        }

        if (eventData.task == "setPhoneMeta") {
            qbPhone.setPhoneMeta(eventData.pMeta, eventData.pData.charinfo.phone);
        }

        if (eventData.task == "setUserContacts") {
            qbPhone.setupPlayerContactInfo(eventData.pData.charinfo.firstname, eventData.pData.charinfo.lastname, eventData.pData.charinfo.phone);
            qbPhone.setupPlayerContacts(eventData.pContacts);
        }

        if (eventData.task == "setupBankData") {
            qbPhone.setBankData(eventData.pData)
        }

        if (eventData.task == "updateTime") {
            qbPhone.updateTime(eventData.time)
        }
    });

    $('.notify-btn').change(function() {
        if (allowNotifys == null) {
            if (myNotify) {
                allowNotifys = true;
                qbPhone.toggleNotify(true)
            } else {
                allowNotifys = false;
                qbPhone.toggleNotify(false)
            }
        } else {
            if (!allowNotifys) {
                allowNotifys = true;
                qbPhone.toggleNotify(true)
            } else {
                allowNotifys = false;
                qbPhone.toggleNotify(false)
            }
        }
    })
});

$(document).on('click', '.app', function(e){
    e.preventDefault();

    var appId = $(this).attr('id');
    var pressedApp = $('#'+appId).data('appData');

    if (pressedApp.app == "settings") {
        $(".settings-app").css({'display':'block'}).animate({
            top: "3%",
        }, 250);
        currentApp = ".settings-app";
    } else if (pressedApp.app == "contacts") {
        $(".contacts-app").css({'display':'block'}).animate({
            top: "3%",
        }, 250);
        $.post('http://qb-phone/setupContacts');
        currentApp = ".contacts-app";
    } else if (pressedApp.app == "bank") {
        $(".bank-app").css({'display':'block'}).animate({
            top: "3%",
        }, 250);
        $.post('http://qb-phone/getBankData')
        currentApp = ".bank-app";
    } else if (pressedApp.app == "messages") {
        $(".messages-app").css({'display':'block'}).animate({
            top: "3%",
        }, 250);
        // $.post('http://qb-phone/getBankData')
        currentApp = ".messages-app";
    }
    qbPhone.succesSound();
});

$(document).on('click', '#chat-window-arrow-left', function(e){
    e.preventDefault();

    $('.chat-window').css({"display":"block"}).animate({top: "103.5%",}, 250, function(){
        $(".chat-window").css({"display":"none"});
    });
})

$(document).on('click', '.chat', function(e){
    e.preventDefault();

    $('.chat-window').css({"display":"block"}).animate({top: "3%",}, 250);
    qbPhone.loadUserMessages();
});

$(document).on('click', '#background-item', function(e){
    e.preventDefault();

    $('.background-block').css({"display":"block"}).animate({top: "20%",}, 250);
    setTimeout(function(){
        choosingBg = true;
    }, 100)
    qbPhone.succesSound();
});

$(document).on('click', '.add-contact-btn', function(e){
    e.preventDefault();

    $('.add-contact-container').css({"display":"block"}).animate({top: "20%",}, 250);
    setTimeout(function(){
        $(".contactname-input").val("");
        $(".number-input").val("");
        addingContact = true;
    }, 100)
    qbPhone.succesSound();
});

$(document).on('click', '.submit-contact-btn', function(e){
    var contactName = $(".contactname-input").val();
    var contactNum = $(".number-input").val();

    if(contactName != "" || contactNum != "") {
        if (!isNaN(contactNum)) {
            $('.add-contact-container').css({"display":"block"}).animate({top: "103%",}, 250);
            qbPhone.Notify('Contacten', 'success', contactName+" ("+contactNum+") is toegevoegd aan je contacten.")
            $.post('http://qb-phone/addToContact', JSON.stringify({
                contactName: contactName,
                contactNum: contactNum
            }))
        } else {
            qbPhone.Notify('Contacten', 'error', 'Het telefoon nummer moet bestaan uit cijfers.')
        }
    } else {
        qbPhone.Notify('Contacten', 'error', 'Je hebt niet alle contactgegevens ingevuld.')
    }
});

$(document).on('click', '.back-contact-btn', function(e){
    $('.add-contact-container').css({"display":"block"}).animate({top: "103%",}, 250, function(){
        $(".add-contact-container").css({"display":"none"});
    });
});

$(document).on('click', '.back-transfer-btn', function(e){
    $('.transfer-money-container').css({"display":"block"}).animate({top: "103%",}, 250, function(){
        $('.transfer-money-container').css({'display':'none'});
    });
});

$(document).on('click', '.bank-transfer-btn', function(e){
    $('.transfer-money-container').css({"display":"block"}).animate({top: "25.5%",}, 250);
});

$(document).on('click', '.submit-transfer-btn', function(e){
    var ibanVal = $(".iban-input").val();
    var amountVal = $(".euro-amount-input").val();
    var balance = $("#balance").val();

    if (ibanVal != "" && amountVal != "") {
        if (!isNaN(amountVal)) {
            if (balance - amountVal < 0) {
                qbPhone.Notify('Maze Bank', 'error', 'Je hebt niet genoeg saldo', 3500)
            } else {
                $('.transfer-money-container').css({"display":"block"}).animate({top: "103%",}, 250, function(){
                    $('.transfer-money-container').css({'display':'none'});
                    qbPhone.Notify('Maze Bank', 'success', 'Je hebt € '+amountVal+' overgemaakt naar '+ibanVal+'!', 3500)

                    $.post('http://qb-phone/transferMoney', JSON.stringify({
                        amount: amountVal,
                        iban: ibanVal
                    }))
                });
            }
        } else {
            qbPhone.Notify('Maze Bank', 'error', 'De hoeveelheid moet bestaan uit cijfers.', 3500)
        }
    } else {
        qbPhone.Notify('Maze Bank', 'error', 'Je hebt niet alle gegevens ingevuld.', 3500)
    }
});

$(document).on('click', '.settings-app', function(e){
    if (choosingBg) {
        $('.background-block').animate({top: "100%",}, 
        250, function(){
            $('.background-block').css({'display':'none'});
            choosingBg = false;
        });
    }
});

$(document).on('click', '.background-option', function(e){
    e.preventDefault();

    var selectedBackground = $(this).attr('id');
    $(".phone-home-page").css("background-image", "url(./img/"+selectedBackground+".png)");
    $("#"+curBg).removeClass("selected-bg");
    $(this).addClass("selected-bg");
    curBg = $(this).attr("id");

    if (curBg == "bg-1") {
        $("#current-background").html("Gradient Green");
    } else if (curBg == "bg-2") {
        $("#current-background").html("Abstract");
    }
    $.post('http://qb-phone/setPlayersBackground', JSON.stringify({
        background: selectedBackground
    }))
    qbPhone.succesSound();
});

$(document).on('click', '.home-container', function(e){
    e.preventDefault();

    if (currentApp != homePage) {
        $(currentApp).animate({top: "100%",}
        , 250, function() {
            $(currentApp).css({'display':'none'});
            $(homePage).css({'display':'block'});
            currentApp = homePage;
        });

        qbPhone.succesSound();
    } else {
        qbPhone.Close();
    }
});

qbPhone.Open = function() {
    inPhone = true;
    $(homePage).css({'display':'block'})
    $('.phone-container').css({'display':'block'}).animate({
        top: "41.3%",
    }, 300);
    $('.phone-frame').css({'display':'block'}).animate({
        top: "40%",
    }, 300);
    qbPhone.Log('Phone opened');
}

qbPhone.Close = function() {
    inPhone = false;
    $('.phone-container').css({'display':'block'}).animate({
        top: "100%",
    }, 300);
    $('.phone-frame').css({'display':'block'}).animate({
        top: "100%",
    }, 300);
    $.post('http://qb-phone/closePhone');
    qbPhone.Log('Phone closed');
}

qbPhone.setupPhoneApps = function(apps) {
    if (phoneApps === null) {
        $.each(apps, function(index, app) {
            $('.slot-'+app.slot).html("");
            var appElement = '<div class="app" id="slot-'+app.slot+'" style="background-color: '+app.color+';" data-toggle="tooltip" data-placement="bottom" title="'+app.tooltipText+'"><i class="'+app.icon+'" id="app-icon" style="'+app.style+'"></i></div>'
            $('.slot-'+app.slot).append(appElement);
            $('.slot-'+app.slot).removeClass("empty-slot");
            $('#slot-'+app.slot).data('appData', app);
        });
        qbPhone.Log('Phone apps have been generated');
        $('[data-toggle="tooltip"]').tooltip();
    }
    phoneApps = apps
}

qbPhone.Log = function(log) {
    console.log(log)
}

qbPhone.toggleNotify = function(bool) {
    allowNotifys = bool;
    if (bool) {
        $(".notify-state").html("Aan");
    } else {
        $(".notify-state").html("Uit");
    }

    $.post('http://qb-phone/setNotifications', JSON.stringify({allow: bool}));
    qbPhone.succesSound();
}

qbPhone.succesSound = function() {
    $.post('http://qb-phone/succesSound');
}

qbPhone.errorSound = function() {
    $.post('http://qb-phone/errorSound');
}

qbPhone.setPhoneMeta = function(phoneMeta, phoneNumber) {
    qbPhone.setPlayersNotification(phoneMeta.settings.notification)
    qbPhone.setPlayersBackground(phoneMeta.settings.background)
    qbPhone.setPlayersPhoneNumber(phoneNumber)
}

qbPhone.setPlayersNotification = function(allow) {
    myNotify = allow;
    if (allow) {
        $("#notification-toggle").bootstrapToggle('on')
    } else {
        $("#notification-toggle").bootstrapToggle('off')
    }
}

qbPhone.setPlayersPhoneNumber = function(num) {
    $('.phone-num').html(num);
}

qbPhone.setPlayersBackground = function(background) {
    $(".phone-home-page").css("background-image", "url(./img/"+background+".png)");
    $("#"+background).addClass("selected-bg");
    curBg = background;
    $("#current-background").html("Gradient Green");
    if (background == "bg-1") {
        $("#current-background").html("Gradient Green");
    } else if (background == "bg-2") {
        $("#current-background").html("Abstract");
    }
}

qbPhone.updateTime = function(time) {
    $("#time").html(time.hour+"."+time.minute);
}

qbPhone.setupPlayerContactInfo = function(firstName, lastName, phoneNumber) {
    $("#firstletters").html((firstName).charAt(0).toUpperCase()+""+(lastName).charAt(0).toUpperCase());
    $("#myi-number").html(phoneNumber);
}

var editContactData = null;

$(document).on('click', '.edit-contact', function(e){
    e.preventDefault();

    var cId = $(this).attr('id');
    var contactData = $("#"+cId).data('cData');

    $('.edit-contact-container').css({"display":"block"}).animate({top: "20%",}, 250);
    editContactData = contactData;
    setTimeout(function(){
        $(".edit-contactname-input").val(contactData.name);
        $(".edit-number-input").val(contactData.number);
    }, 100)
    qbPhone.succesSound();
})

$(document).on('click', '.back-edit-contact-btn', function(e){
    $('.edit-contact-container').css({"display":"block"}).animate({top: "103%",}, 250, function(){
        $(".edit-contact-container").css({"display":"none"});
    });

    editContactData = null;
});

$(document).on('click', '.change-contact-btn', function(e){
    var oldContactName = editContactData.name;
    var oldContactNum =  editContactData.number;

    if($(".edit-number-input").val() != "" || $(".edit-contactname-input").val() != "") {
        if (!isNaN($(".edit-number-input").val())) {
            $.post('http://qb-phone/editContact', JSON.stringify({
                oldContactName: oldContactName,
                oldContactNum: oldContactNum,
                newContactName: $(".edit-contactname-input").val(),
                newContactNum: $(".edit-number-input").val(),
            }))
            qbPhone.Notify('Contacten', 'success', 'Contact opgeslagen');
            $('.edit-contact-container').css({"display":"block"}).animate({top: "103%",}, 250, function(){
                $(".edit-contact-container").css({"display":"none"});
            });
        } else {
            qbPhone.Notify('Contacten', 'error', 'Het telefoon nummer moet bestaan uit cijfers.')
        }
    } else {
        qbPhone.Notify('Contacten', 'error', 'Je hebt niet alle contactgegevens ingevuld.')
    }

    editContactData = null;
});

function changecName() {
    var currentVal = $(".contactname-input").val();

    $(".contactname-input").val(currentVal);
}

$(document).on('click', '.delete-contact-btn', function(e){
    $('.edit-contact-container').css({"display":"block"}).animate({top: "103%",}, 250, function(){
        $(".edit-contact-container").css({"display":"none"});
    });

    editContactData = null;
});

qbPhone.setupPlayerContacts = function(contacts) {
    $(".contact-list").html("");
    $.each(contacts, function(index, contact){
        var contactHTML = '<div class="contact"><div class="contact-status" id="contact-'+index+'"></div><div class="contact-options">' +
        '<div class="contact-option call-contact" id="cData-'+index+'"><i class="fa fa-phone" id="call-contact-icon"></i></div>' +
        '<div class="contact-option sms-contact" id="cData-'+index+'"><i class="fa fa-sms" id="sms-contact-icon"></i></div>' +
        '<div class="contact-option edit-contact" id="cData-'+index+'"><i class="fa fa-edit" id="edit-contact-icon"></i></div></div>' +
        '<span id="contact-name">'+contact.name+'</span></div>'
        $(".contact-list").append(contactHTML);
        if (contact.status === "unknown") {
            $("#contact-"+index).addClass("unknown");
        } else if (contact.status === true) {
            $("#contact-"+index).addClass("online");
        } else if (contact.status === false) {
            $("#contact-"+index).addClass("offline");
        }

        console.log(contact.status)
        $("#contact-"+index).data("contactData", contact);
        $("#cData-"+index).data("cData", contact);
    });
}

var timeout = null;

qbPhone.Notify = function(title, type, message, wait) {
    if (timeout != undefined) {
        clearTimeout(timeout);
    }
    $('.phone-notify').css({'display':'block', 'top':'-10%'})
    if (type == 'error') {
        $("#notify-titel").css("color", "rgb(126, 9, 9);");
    } else if (type == 'success') {
        $("#notify-titel").css("color", "rgb(9, 126, 9);");
    }
    $("#notify-titel").html(title);
    $("#notify-message").html(message);
    $('.phone-notify').css({'display':'block'}).animate({
        top: "5%",
    }, 300);
    if (wait == null) {
        timeout = setTimeout(function(){
            $('.phone-notify').css({'display':'block'}).animate({
                top: "-10%",
            }, 300, function(){
                $('.phone-notify').css({'display':'none'})
            });
        }, 3500)
    } else {
        timeout = setTimeout(function(){
            $('.phone-notify').css({'display':'block'}).animate({
                top: "-10%",
            }, 300, function(){
                $('.phone-notify').css({'display':'none'})
            });
        }, wait)
    }
}

qbPhone.setBankData = function(playerData) {
    $(".welcome-title").html("<p>Hallo, "+playerData.charinfo.firstname+" "+playerData.charinfo.lastname+"!</p>");
    $("#balance").html(playerData.money.bank);
    $("#balance").val(playerData.money.bank);
    $("#iban").html(playerData.charinfo.account);
}

qbPhone.loadUserMessages = function() {
    var messageScreen = $('.messages');
    var height = messageScreen[0].scrollHeight;
    messageScreen.scrollTop(height);
}

updateNewBalance = function() {
    var balance = $("#balance").val();
    var minAmount = $(".euro-amount-input").val();
    $("#new-balance").html(balance - minAmount);
    console.log(balance)
}