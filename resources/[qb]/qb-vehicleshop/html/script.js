var selectedCategory = null;

$(document).ready(function(){
    $('.container').hide();
    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "ui") {
            if (eventData.ui) {
                $('.container').fadeIn(200);
            } else {
                $('.container').fadeOut(200);
            }
        }

        if (eventData.action == "setupVehicles") {
            setupVehicles(eventData.vehicles)
        }
    })

    $('.vehicle-category').click(function(e){
        e.preventDefault();

        $(this).addClass('selected');
        if (selectedCategory !== null && selectedCategory !== this) {
            $(selectedCategory).removeClass('selected');
        }
        $.post('http://qb-vehicleshop/GetCategoryVehicles', JSON.stringify({
            selectedCategory: $(this).attr('id')
        }))
        selectedCategory = this;
    });
});

function setupVehicles(vehicles) {
    $('.vehicles').html("");
    $.each(vehicles, function(index, vehicle){
        $('.vehicles').append('<div class="vehicle" id='+index+'><span id="vehicle-name">'+vehicle.name+' - '+vehicle.class+'</span><span id="vehicle-price">$ '+vehicle.price+'</span><div class="vehicle-buy-btn" data-vehicle="'+vehicle+'"><p>Koop Voertuig</p></div></div>');
        $('#'+index).data('vehicleData', "");
        $('#'+index).data('vehicleData', vehicle);
    })
}

$(document).on('click', '.vehicle-buy-btn', function(e){
    e.preventDefault();

    var vehicleId = $(this).parent().attr('id');
    var vehicleData = $('#'+vehicleId).data('vehicleData');

})

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            $.post('http://qb-vehicleshop/exit')
            break;
    }
});