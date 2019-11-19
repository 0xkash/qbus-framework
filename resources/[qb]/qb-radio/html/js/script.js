$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            if (event.data.enable) {
                SlideUp()
            }
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://qb-radio/escape', JSON.stringify({}));
            SlideDown()
        }
    };
});

$(document).on('click', '#submit', function(e){
    e.preventDefault();

    $.post('http://qb-radio/joinRadio', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#disconnect', function(e){
    e.preventDefault();

    $.post('http://qb-radio/leaveRadio');
});

SlideUp = function() {
    $("#radio").css({"display":"block"}).animate({bottom: "6vh",}, 250);
}

SlideDown = function() {
    $("#radio").animate({bottom: "-80vh",}, 400);
}