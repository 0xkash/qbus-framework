$('document').ready(function() {

    $(".container").hide();

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type == "toggle") {
            if (item.status == true) {
                $(".container").fadeIn(250);
            } else {
                $(".container").fadeOut(250);
            }
        }

        if (item.type == "setupContract") {
            $("#welcome-name").html(item.firstname + " " + item.lastname)
            $("#property-adress").html(item.street)
            $("#property-price").html("$ " + item.houseprice);
            $("#property-brokerfee").html("$ " + item.brokerfee);
            $("#property-bankfee").html("$ " + item.bankfee);
            $("#property-taxes").html("$ " + item.taxes);
            $("#property-totalprice").html("$ " + item.totalprice);
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27 ) {
            $.post('http://qb-houses/exit', JSON.stringify({}));
            return
        }
    };
})

$(".property-accept").click(function(e){
    $.post('http://qb-houses/buy', JSON.stringify({}))
})

$(".property-cancel").click(function(e){
    $.post('http://qb-houses/exit', JSON.stringify({}));
});