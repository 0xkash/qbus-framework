$(document).ready(function() {

    $(".container").hide();
    $("#submit-spawn").hide()

    window.addEventListener('message', function(event) {
        var data = event.data;
        if (data.type === "ui") {
            if (data.status == true) {
                $(".container").fadeIn(250);
            } else {
                $(".container").fadeOut(250);
            }
        }

        if (data.action == "setupLocations") {
            setupLocations(data.locations)
        }
    })
})

var currentLocation = null

$(document).on('click', '.location', function(evt){
    evt.preventDefault(); //dont do default anchor stuff
    var location = $(this).data('location'); //get the text
    var label = $(this).data('label'); //get the text
    $("#spawn-label").html("Locatie bevestigen (" + label +")")
    $("#submit-spawn").attr("data-location", location);
    $("#submit-spawn").fadeIn(100)
    $.post('http://qb-spawn/setCam', JSON.stringify({
        posname: location
    }));
    if (currentLocation !== null) {
        $(currentLocation).removeClass('selected');
    }
    $(this).addClass('selected');
    currentLocation = this
});

$(document).on('click', '#submit-spawn', function(evt){
    evt.preventDefault(); //dont do default anchor stuff
    var location = $(this).attr('data-location');
    $(".container").addClass("hideContainer").fadeOut("9000");
    setTimeout(function(){
        $(".hideContainer").removeClass("hideContainer");
    }, 900);
    $.post('http://qb-spawn/spawnplayer', JSON.stringify({
        spawnloc: location
    }));
});

function setupLocations(locations) {
    var parent = $('.spawn-locations')
    $(parent).append('<div class="location" id="location" data-location="current" data-label="Last Locations"><p><span id="current-location">Last Location</span></p></div>');

    $.each(locations, function(index, location){
        $(parent).append('<div class="location" id="location" data-location="'+location.location+'" data-label="'+location.label+'"><p><span id="'+location.location+'">'+location.label+'</span></p></div>')
    });
    $(parent).append('<div class="submit-spawn" id="submit-spawn"><p><span id="spawn-label"></span></p></div>');
    $('.submit-spawn').hide();
}
