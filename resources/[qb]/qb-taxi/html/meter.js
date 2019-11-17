var meterStarted = false;
var meterPlate = null;

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            $.post('http://qb-taxi/hideMouse');
            break;
    }
});

$(document).ready(function(){

    $('.container').hide();

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "openMeter") {
            if (eventData.toggle) {
                openMeter(eventData.meterData)
                meterPlate = eventData.plate;
                console.log(meterPlate)
            } else {
                closeMeter()
                meterPlate = null;
            }
        }

        if (eventData.action == "toggleMeter") {
            toggleMeter(eventData.enabled)
        }
    });
});

$(document).on('click', '.toggle-meter-btn', function(){
    if (!meterStarted) {
        $.post('http://qb-taxi/enableMeter', JSON.stringify({
            enabled: true,
        }));
        toggleMeter(true)
        meterStarted = true;
    } else {
        $.post('http://qb-taxi/enableMeter', JSON.stringify({
            enabled: false,
        }));
        toggleMeter(false)
        meterStarted = false;
    }
});

function toggleMeter(enabled) {
    if (enabled) {
        $(".toggle-meter-btn").html("<p>Stop</p>");
        $(".toggle-meter-btn p").css({"color": "rgb(231, 30, 37)"});
    } else {
        $(".toggle-meter-btn").html("<p>Start</p>");
        $(".toggle-meter-btn p").css({"color": "rgb(51, 160, 37)"});
    }
}

function openMeter(meterData) {
    $('.container').fadeIn(150);
    $('#total-price-per-100m').html("€ " + (meterData.defaultPrice).toFixed(2))
}

function closeMeter() {
    $('.container').fadeOut(150);
}