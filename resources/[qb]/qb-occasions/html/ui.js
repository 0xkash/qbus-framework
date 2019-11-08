QBOccasions = {}

$(document).ready(function(){
    $('.container').hide();

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "sellVehicle") {
            $('.container').fadeIn(150);
            QBOccasions.setupContract(eventData)
        }
    });
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            $('.container').fadeOut(100);
            $.post('http://qb-occasions/close');
            break;
    }
});

$(document).on('click', '#sell-vehicle', function(){
    if ($('.vehicle-sell-price').val() != "") {
        if (!isNaN($('.vehicle-sell-price').val())) {
            $.post('http://qb-occasions/sellVehicle', JSON.stringify({
                price: $('.vehicle-sell-price').val(),
                desc: $('.vehicle-description').val()
            }));
        
            $('.container').fadeOut(100);
            $.post('http://qb-occasions/close');
        } else {
            $.post('http://qb-occasions/error', JSON.stringify({
                message: "Bedrag moet bestaan uit cijfers.."
            }))
        }
    } else {
        $.post('http://qb-occasions/error', JSON.stringify({
            message: "Vul een bedrag in.."
        }))
    }
});

QBOccasions.setupContract = function(data) {
    $("#seller-name").html(data.pData.charinfo.firstname + " " + data.pData.charinfo.lastname);
    $("#seller-banknr").html(data.pData.charinfo.account);
    $("#seller-telnr").html(data.pData.charinfo.phone);
    $("#vehicle-plate").html(data.plate);
}

function calculatePrice() {
    var priceVal = $('.vehicle-sell-price').val();
    
    $('#tax').html("&euro; " + (priceVal / 100 * 19).toFixed(0));
    $('#mosley-cut').html("&euro; " + (priceVal / 100 * 4).toFixed(0));
    $('#total-money').html("&euro; " + (priceVal / 100 * 77).toFixed(0));
}