QBTuner = {}

$(document).ready(function(){
    $('.container').hide();

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "ui") {
            if (eventData.toggle) {
                QBTuner.Open()
            }
        }
    });
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            QBTuner.Close();
            break;
    }
});

$(document).on('click', '#save', function(){
    $.post('http://qb-tunerchip/save', JSON.stringify({
        boost: $("#boost-slider").val(),
        acceleration: $("#acceleration-slider").val(),
        gearchange: $("#gear-slider").val(),
        breaking: $("#breaking-slider").val(),
        drivetrain: $("#drivetrain-slider").val()
    }));

    console.log('yeet?')
});

$(document).on('click', '#cancel', function(){
    QBTuner.Close();
});

QBTuner.Open = function() {
    $('.container').fadeIn(250);
}

QBTuner.Close = function() {
    $('.container').fadeOut(250);
    $.post('http://qb-tunerchip/exit');
}