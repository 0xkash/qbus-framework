QBTuner = {}

var headlightVal = 0;

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

$(document).on('click', '.option-button', function(e){
    e.preventDefault();

    var software = $(this).data('software');

    if (software == "tuning") {
        $.post('http://qb-tunerchip/checkItem', JSON.stringify({software: "tunerlaptop"}), function(hasItem){
            if (hasItem) {
                $(".tunerchip-software").css({"display": "block"});
            }
        })
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
});

$(document).on('click', '#reset', function(){
    $.post('http://qb-tunerchip/reset');
});

$(document).on('click', '#cancel', function(){
    QBTuner.Close();
});

$(document).on('click', "#neon", function(){
    $(".tunerchip-block").css("display", "none");
    $(".headlights-block").css("display", "none");
    $(".neon-block").css("display", "block");
})

$(document).on('click', "#headlights", function(){
    $(".tunerchip-block").css("display", "none");
    $(".neon-block").css("display", "none");
    $(".headlights-block").css("display", "block");
})

$(document).on('click', "#tuning", function(){
    $(".headlights-block").css("display", "none");
    $(".neon-block").css("display", "none");
    $(".tunerchip-block").css("display", "block");
})

$(document).on('click', "#save-neon", function(){
    $.post('http://qb-tunerchip/saveNeon', JSON.stringify({
        neonEnabled: $("#neon-slider").val(),
        r: $("#color-r").val(),
        g: $("#color-g").val(),
        b: $("#color-b").val(),
    }))
})

$(document).on('click', '#save-headlights', function(){
    $.post('http://qb-tunerchip/saveHeadlights', JSON.stringify({
        value: headlightVal
    }))
});

$(document).on('click', ".neon-software-color-pallete-color", function(){

    var r = $(this).data('r')
    var g = $(this).data('g')
    var b = $(this).data('b')

    $("#color-r").val(r)
    $("#color-g").val(g)
    $("#color-b").val(b)

    var headlightValue = $(this).data('value')

    if (headlightValue != null) {
        headlightVal = headlightValue
        var colorValue = $(this).css("background-color");
        $(".neon-software-color-pallete-color-current").css("background-color", colorValue);
    }
});

QBTuner.Open = function() {
    $('.container').fadeIn(250);
}

QBTuner.Close = function() {
    $('.container').fadeOut(250);
    $.post('http://qb-tunerchip/exit');
}