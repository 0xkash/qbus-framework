qbPhone = {}

var inPhone = false;
var phoneApps = null;
var allowNotifys = true;
var currentApp = ".phone-home-page";
var homePage = ".phone-home-page";

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
            if (eventData.open) {
                qbPhone.Open()
                qbPhone.setupPhoneApps(eventData.apps)
            } else {
                qbPhone.Close()
            }
        }
    });

    $('.notify-btn').change(function() {

        if (!allowNotifys) {
            allowNotifys = true;
            qbPhone.toggleNotify(true)
        } else {
            allowNotifys = false;
            qbPhone.toggleNotify(false)
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
    }
    qbPhone.succesSound();
});

$(document).on('click', '.home-btn', function(e){
    e.preventDefault();

    if (currentApp != homePage) {
        $(currentApp).animate({top: "100%",}
        , 250, function() {
            $(currentApp).css({'display':'none'})
            currentApp = homePage;
        });

        qbPhone.succesSound();
    } else {
        qbPhone.Close();
    }
});

qbPhone.Open = function() {
    inPhone = true;
    $('.phone-container').css({'display':'block'}).animate({
        top: "32%",
    }, 300);
    qbPhone.Log('Phone opened');
}

qbPhone.Close = function() {
    inPhone = false;
    $('.phone-container').css({'display':'block'}).animate({
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
        $("#current-setting-status").html("Aan");
    } else {
        $("#current-setting-status").html("Uit")
    }

    $.post('http://qb-phone/setNotifications', JSON.stringify({status: bool}));
    qbPhone.succesSound();
}

qbPhone.succesSound = function() {
    $.post('http://qb-phone/succesSound');
}

qbPhone.errorSound = function() {
    $.post('http://qb-phone/errorSound');
}