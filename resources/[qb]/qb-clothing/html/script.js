QBClothing = {}

var selectedTab = ".characterTab"
var lastCategory = "character"

$(document).on('click', '.clothing-menu-header-btn', function(e){
    var category = $(this).data('category');

    $(selectedTab).removeClass("selected");
    $(this).addClass("selected");
    $(".clothing-menu-"+lastCategory+"-container").css({"display": "none"});

    lastCategory = category;
    selectedTab = this;

    $(".clothing-menu-"+category+"-container").css({"display": "block"});
})

$(document).on('click', '.clothing-menu-option-item-right', function(e){
    e.preventDefault();

    var clothingCategory = $(this).parent().parent().data('type');
    var buttonType = $(this).data('type');
    var inputElem = $(this).parent().find('input');
    var inputVal = $(inputElem).val();
    var newValue = parseFloat(inputVal) + 1;

    if (newValue != 0) {
        $(inputElem).val(newValue);
    }

    $.post('http://qb-clothing/updateSkin', JSON.stringify({
        clothingType: clothingCategory,
        articleNumber: newValue,
        type: buttonType,
    }));

    if (clothingCategory == "model") {
        $.post('http://qb-clothing/setCurrentPed', JSON.stringify({ped: newValue}), function(model){
            $("#current-model").html("<p>"+model+"</p>")
        });
    }
})

$(document).on('click', '.clothing-menu-option-item-left', function(e){
    e.preventDefault();

    var clothingCategory = $(this).parent().parent().data('type');
    var buttonType = $(this).data('type');
    var inputElem = $(this).parent().find('input');
    var inputVal = $(inputElem).val();
    var newValue = parseFloat(inputVal) - 1;

    if (newValue != 0) {
        $(inputElem).val(newValue);
    }

    $.post('http://qb-clothing/updateSkin', JSON.stringify({
        clothingType: clothingCategory,
        articleNumber: newValue,
        type: buttonType,
    }));

    if (clothingCategory == "model") {
        $.post('http://qb-clothing/setCurrentPed', JSON.stringify({ped: newValue}), function(model){
            $("#current-model").html("<p>"+model+"</p>")
        });
    }
})

$(document).on('change', '.item-number', function(){
    var clothingCategory = $(this).parent().parent().data('type');
    var buttonType = $(this).data('type');
    var inputVal = $(this).val();

    $.post('http://qb-clothing/updateSkinOnInput', JSON.stringify({
        clothingType: clothingCategory,
        articleNumber: parseFloat(inputVal),
        type: buttonType,
    }));
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            QBClothing.Close();
            break;
    }
});

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                QBClothing.Open(event.data);
                break;
            case "close":
                QBClothing.Close();
                break;
        }
    })
});

QBClothing.Open = function(data) {
    $(".clothing-menu-container").css({"display":"block"}).animate({right: 0,}, 200);
}

QBClothing.Close = function() {
    $.post('http://qb-clothing/close');
    $(".clothing-menu-container").css({"display":"block"}).animate({right: "-25vw",}, 200, function(){
        $(".clothing-menu-container").css({"display":"none"});
    });
}