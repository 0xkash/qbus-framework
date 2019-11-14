Decorations = {}

var houseCategorys = {};

var selectedObject = null;

$(".container").hide();

$('document').ready(function() {

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
            houseCategorys = item.furniture;
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 116 ) {
            $.post('http://qb-houses/toggleCursor');
        }

        if (data.which == 13 ) {
            if (selectedObject !== null) {
                var objId = $(selectedObject).attr('id');
                var objData = $('#'+objId).data('objectData');

                $.post("http://qb-houses/spawnobject", JSON.stringify({
                    object: objData.object,
                }));
                $(".decorate-items").fadeOut(150);
            }
        }
    };
})

Decorations.Open = function(data) {
    $("#decorate").fadeIn(250);

    // $.each(data.furniture, function (i, category) {
    //     $(".object-selectors").append('<div id="'+i+'" class="form-group object-category"><label for="obj-sel" class="object-select-label">'+category.label+':</label><select class="form-control select-object" id="sel1"></select><br /><button class="btn btn-group btn-spawnobj" id="spawn-object" data-category="'+i+'">Spawn</button>');
    //     $.each(data.furniture[i].items, function (j, item) {
    //         $("#"+i).find(".select-object").append('<option value="'+item.object+'">'+item.label+'</option>');
    //     });
    // });

    // $('.select-object').on('change', function() {
    //     var gtaobj = $(this).children("option:selected").val();
    //     $.post("http://qb-houses/chooseobject", JSON.stringify({
    //         object: gtaobj,
    //     }));
    // });

    // $('.btn-spawnobj').on('click', function() {
    //     var category = $(this).attr("data-category");
    //     var gtaobj = $("#"+category).find(".select-object").children("option:selected").val();
    //     Decorations.Close();
    //     $.post("http://qb-houses/spawnobject", JSON.stringify({
    //         object: gtaobj,
    //     }));
    // });
}

Decorations.SetupCategorys = function() {
    $(".decorate-footer-buttons").html("");
    $(".decorate-footer-buttons").hide();
    $.each(houseCategorys, function(key, category){
        var elem = '<div class="footer-btn" id="'+key+'"><p>'+category.label+'</p></div>';

        $(".decorate-footer-buttons").append(elem);
        $("#"+key).data('categoryData', category)
    });
    $(".decorate-footer-buttons").fadeIn(150);
}

var selectedHeaderButton = null;

$(document).on('click', '.header-btn', function(){

    if ($(this).attr('id') == "objects-list") {
        if ($(this).hasClass('header-btn-selected')) {
            $(selectedHeaderButton).removeClass('header-btn-selected');
            $(".decorate-footer-buttons").fadeOut(150);
        } else {
            $(selectedHeaderButton).removeClass('header-btn-selected');
            $(this).addClass('header-btn-selected');
            $('.decorate-items').fadeOut(150);
            Decorations.SetupCategorys();
        }
    }

    if ($(this).attr('id') == "close") {
        Decorations.Close();
    }

    if ($(this).attr('id') == "my-objects") {
        if ($(this).hasClass('header-btn-selected')) {
            $(selectedHeaderButton).removeClass('header-btn-selected');
            $('.decorate-items').fadeOut(150);
        } else {
            $(selectedHeaderButton).removeClass('header-btn-selected');
            $(this).addClass('header-btn-selected');
            $(".decorate-footer-buttons").fadeOut(150);
            $.post('http://qb-houses/setupMyObjects', JSON.stringify({}), function(myObjects){
                $('.decorate-items').html("");
                $.each(myObjects, function(i, object){
                    var elem = '<div class="decorate-item" id="myobject-'+i+'" data-type="myObject"><span id="decorate-item-name"><b>Object: </b>'+object.hashname+'</span><span id="decorate-item-category"><strong>Prijs: </strong><span id="item-price" style="color: green;">OWNED</span></span></div>';
                    $('.decorate-items').append(elem);
                    $('#myobject-'+i).data('myObjectData', object);
                });
                $(".decorate-items").fadeIn(150);
            });
        }
    }

    selectedHeaderButton = this;
})

$(document).on('click', '.footer-btn', function(){
    var selectedCategory = $(this).attr('id');
    $('.decorate-items').html("");
    $.each(houseCategorys[selectedCategory].items, function(i, item){
        var elem = '<div class="decorate-item" id="object-'+i+'" data-type="newObject"><span id="decorate-item-name"><b>Object: </b>'+item.label+'</span><span id="decorate-item-category"><strong>Prijs: </strong><span id="item-price" style="color: green;">€'+item.price+'</span></span></div>';
        $('.decorate-items').append(elem);
        $('#object-'+i).data('objectData', item);
    });
    $(".decorate-items").fadeIn(150);
});

$(document).on('click', '.decorate-item', function(){
    var objId = $(this).attr('id');
    var objData = $('#'+objId).data('objectData');
    var myObjectData = $('#'+objId).data('myObjectData');
    if (selectedObject != null) {
        $(selectedObject).removeClass('selected-object');
    }

    if ($("#"+objId).data('type') == "newObject") {
        if (selectedObject == this) {
            $(this).removeClass('selected-object');
            selectedObject = null;
            $.post('http://qb-houses/removeObject');
        } else {
            $(this).addClass('selected-object');
            selectedObject = this;
            $.post("http://qb-houses/chooseobject", JSON.stringify({
                object: objData.object,
            }));
        }
    } else if ($("#"+objId).data('type') == "myObject") {
        if (selectedObject == this) {
            $(this).removeClass('selected-object');
            $.post('http://qb-houses/deselectOwnedObject')
            selectedObject = null;
        } else {
            $(this).addClass('selected-object');
            selectedObject = this;
            $.post('http://qb-houses/selectOwnedObject', JSON.stringify({
                objectData: myObjectData
            }))
        }
    }
});

Decorations.Close = function() {
    $("#decorate").css("display", "none");
    $.post("http://qb-houses/closedecorations", JSON.stringify({}));
}

$(".property-accept").click(function(e){
    $.post('http://qb-houses/buy', JSON.stringify({}))
});

$(".property-cancel").click(function(e){
    $.post('http://qb-houses/exit', JSON.stringify({}));
});