Decorations = {}

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

        if (item.type == "openObjects") {
            Decorations.Open(item);
        }

        if (item.type == "closeObjects") {
            Decorations.Close();
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27 ) {
            $.post('http://qb-houses/exit', JSON.stringify({}));
            Decorations.Close();
            return
        }
    };
})

Decorations.Open = function(data) {
    $("#decorate").css("display", "block");
    $.each(data.furniture, function (i, category) {
        $(".object-selectors").append('<div id="'+i+'" class="form-group object-category"><label for="obj-sel" class="object-select-label">'+category.label+':</label><select class="form-control select-object" id="sel1"></select><br /><button class="btn btn-group btn-spawnobj" id="spawn-object" data-category="'+i+'">Spawn</button>');
        $.each(data.furniture[i].items, function (j, item) {
            $("#"+i).find(".select-object").append('<option value="'+item.object+'">'+item.label+'</option>');
        });
    });

    $('.select-object').on('change', function() {
        var gtaobj = $(this).children("option:selected").val();
        $.post("http://qb-houses/chooseobject", JSON.stringify({
            object: gtaobj,
        }));
    });

    $('.btn-spawnobj').on('click', function() {
        var category = $(this).attr("data-category");
        var gtaobj = $("#"+category).find(".select-object").children("option:selected").val();
        Decorations.Close();
        $.post("http://qb-houses/spawnobject", JSON.stringify({
            object: gtaobj,
        }));
    });
}

Decorations.Close = function() {
    $("#decorate").css("display", "none");
    $(".object-category").remove();
    $.post("http://qb-houses/closedecorations", JSON.stringify({}));
}

$(".property-accept").click(function(e){
    $.post('http://qb-houses/buy', JSON.stringify({}))
})

$(".property-cancel").click(function(e){
    $.post('http://qb-houses/exit', JSON.stringify({}));
});