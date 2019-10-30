qbPhone = {}

var inPhone = false;
var phoneApps = null;
var allowNotifys = null;
var myNotify = false;
var currentApp = ".phone-home-page";
var homePage = ".phone-home-page";
var choosingBg = false;
var curBg = "bg-1";

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            qbPhone.Close();
            break;
    }
});

$(document).ready(function(){

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
            qbPhone.setPhoneMeta(eventData.pMeta, eventData.pNum)
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
        $.post('http://qb-phone/getUserData');
    }
    qbPhone.succesSound();
});

$(document).on('click', '#background-item', function(e){
    e.preventDefault();

    $('.background-block').css({"display":"block"}).animate({top: "20%",}, 250);
    setTimeout(function(){
        choosingBg = true;
    }, 100)
    qbPhone.succesSound();
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

$(document).on('click', '.home-btn', function(e){
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