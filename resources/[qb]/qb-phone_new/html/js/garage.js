// var OpenedVehicle = null;

// $(document).on('click', '.garage-vehicle', function(e){
//     e.preventDefault();

//     var PressedVehicle = this;

//     if (OpenedVehicle === null) {
//         $(PressedVehicle).css({"height":"13vh"});
//         OpenedVehicle = PressedVehicle;
//     } else if (OpenedVehicle === PressedVehicle) {
//         $(PressedVehicle).css({"height":"6vh"});
//         OpenedVehicle = null;
//     } else {
//         $(PressedVehicle).css({"height":"13vh"});
//         $(OpenedVehicle).css({"height":"6vh"});

//         OpenedVehicle = PressedVehicle;
//     }
// });

$(document).on('click', '#my-vehicles-back', function(e){
    e.preventDefault();

    $(".garage-vehicle-information").animate({
        left: -30+"vh",
    }, 150);
    $(".garage-vehicles").animate({
        left: 0+"vh",
    }, 150);

});

$(document).on('click', '.garage-vehicle', function(e){
    e.preventDefault();

    $(".garage-vehicle-information").animate({
        left: 0+"vh",
    }, 150);
    $(".garage-vehicles").animate({
        left: -30+"vh",
    }, 150);
});