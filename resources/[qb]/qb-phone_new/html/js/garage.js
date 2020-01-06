var OpenedVehicle = null;

$(document).on('click', '.garage-vehicle', function(e){
    e.preventDefault();

    var PressedVehicle = this;

    if (OpenedVehicle === null) {
        $(PressedVehicle).css({"height":"13vh"});
        OpenedVehicle = PressedVehicle;
    } else if (OpenedVehicle === PressedVehicle) {
        $(PressedVehicle).css({"height":"6vh"});
        OpenedVehicle = null;
    } else {
        $(PressedVehicle).css({"height":"13vh"});
        $(OpenedVehicle).css({"height":"6vh"});

        OpenedVehicle = PressedVehicle;
    }
});