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

    $('.container').hide();
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

    $('#notification-toggle').change(function() {
        var status = $(this).prop('checked');

        if (status) {
            qbPhone.toggleNotify(true)
        } else {
            qbPhone.toggleNotify(false)
        }
    })
});

$(document).on('click', '.app', function(e){
    e.preventDefault();

    var appId = $(this).attr('id');
    var pressedApp = $('#'+appId).data('appData');

    if (pressedApp.app == "settings") {
        $('.phone-home-page').hide();
        $('.settings-app').show();
    }
    qbPhone.succesSound();

    currentApp = ".settings-app";
});

$(document).on('click', '.home-btn', function(e){
    e.preventDefault();

    if (currentApp != homePage) {
        $(currentApp).hide();
        $(homePage).show();

        currentApp = homePage;
        qbPhone.succesSound();
    } else {
        qbPhone.Log('You are already on your homepage!')
    }
});

qbPhone.Open = function() {
    inPhone = true;
    $('.container').fadeIn(200);
    qbPhone.Log('Phone opened');
}

qbPhone.Close = function() {
    inPhone = false;
    $('.container').fadeOut(200);
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