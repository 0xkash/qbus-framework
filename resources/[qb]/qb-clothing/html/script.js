QBClothing = {}

var selectedTab = ".characterTab"
var lastCategory = "character"

var clothingCategorys = ["arms", "t-shirt", "torso2", "pants", "shoes", "eyebrows", "face"]

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

    if (clothingCategory == "model") {
        $(inputElem).val(newValue);
        $.post('http://qb-clothing/setCurrentPed', JSON.stringify({ped: newValue}), function(model){
            $("#current-model").html("<p>"+model+"</p>")
        });
        QBClothing.ResetValues()
    } else if (clothingCategory == "hair") {
        $(inputElem).val(newValue);
        $.post('http://qb-clothing/updateSkin', JSON.stringify({
            clothingType: clothingCategory,
            articleNumber: newValue,
            type: buttonType,
        }));
    } else {
        if (buttonType == "item") {
            var buttonMax = $(this).parent().find('[data-headertype="item-header"]').data('maxItem');
            if (newValue <= parseInt(buttonMax)) {
                $(inputElem).val(newValue);
                $.post('http://qb-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
            }
        } else {
            var buttonMax = $(this).parent().find('[data-headertype="texture-header"]').data('maxTexture');
            if (newValue <= parseInt(buttonMax)) {
                $(inputElem).val(newValue);
                $.post('http://qb-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
            }
        }
    }
})

$(document).on('click', '.clothing-menu-option-item-left', function(e){
    e.preventDefault();

    var clothingCategory = $(this).parent().parent().data('type');
    var buttonType = $(this).data('type');
    var inputElem = $(this).parent().find('input');
    var inputVal = $(inputElem).val();
    var newValue = parseFloat(inputVal) - 1;

    if (newValue != -2) {
        $(inputElem).val(newValue);
        $.post('http://qb-clothing/updateSkin', JSON.stringify({
            clothingType: clothingCategory,
            articleNumber: newValue,
            type: buttonType,
        }));
    
        if (clothingCategory == "model") {
            $.post('http://qb-clothing/setCurrentPed', JSON.stringify({ped: newValue}), function(model){
                $("#current-model").html("<p>"+model+"</p>")
            });
            QBClothing.ResetValues()
        }
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

var selectedCam = null;

$(document).on('click', '.clothing-menu-header-camera-btn', function(e){
    e.preventDefault();

    var camValue = parseFloat($(this).data('value'));

    if (selectedCam == null) {
        $(this).addClass("selected-cam");
        $.post('http://qb-clothing/setupCam', JSON.stringify({
            value: camValue
        }));
        selectedCam = this;
    } else {
        if (selectedCam == this) {
            $(selectedCam).removeClass("selected-cam");
            $.post('http://qb-clothing/setupCam', JSON.stringify({
                value: 0
            }));

            selectedCam = null;
        } else {
            $(selectedCam).removeClass("selected-cam");
            $(this).addClass("selected-cam");
            $.post('http://qb-clothing/setupCam', JSON.stringify({
                value: camValue
            }));

            selectedCam = this;
        }
    }
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 68: // D
            $.post('http://qb-clothing/rotateRight');
            break;
        case 65: // A
            $.post('http://qb-clothing/rotateLeft');
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
            case "updateMax":
                QBClothing.SetMaxValues(event.data.maxValues);
                break
        }
    })
});

$(document).on('click', "#save-menu", function(e){
    e.preventDefault();
    QBClothing.Close();
    $.post('http://qb-clothing/saveClothing');
});

$(document).on('click', "#cancel-menu", function(e){
    e.preventDefault();
    QBClothing.Close();
});

QBClothing.Open = function(data) {
    $(".clothing-menu-container").css({"display":"block"}).animate({right: 0,}, 200);
    QBClothing.SetMaxValues(data.maxValues)
    $(".clothing-menu-header").html("");
    $.each(data.menus, function(i, menu){
        if (menu.selected) {
            $(".clothing-menu-header").append('<div class="clothing-menu-header-btn '+menu.menu+'Tab selected" data-category="'+menu.menu+'"><p>'+menu.label+'</p></div>')
        } else {
            $(".clothing-menu-header").append('<div class="clothing-menu-header-btn '+menu.menu+'Tab" data-category="'+menu.menu+'"><p>'+menu.label+'</p></div>')
        }
    });

    var menuWidth = (100 / data.menus.length)

    $(".clothing-menu-header-btn").css("width", menuWidth + "%")
}

QBClothing.Close = function() {
    $.post('http://qb-clothing/close');
    $(".clothing-menu-container").css({"display":"block"}).animate({right: "-25vw",}, 200, function(){
        $(".clothing-menu-container").css({"display":"none"});
    });
}

QBClothing.SetMaxValues = function(maxValues) {
    $.each(maxValues, function(i, cat){
        if (cat.type == "character") {
            var containers = $(".clothing-menu-character-container").find('[data-type="'+i+'"]');
            var itemMax = $(containers).find('[data-headertype="item-header"]');
            var headerMax = $(containers).find('[data-headertype="texture-header"]');
    
            $(itemMax).data('maxItem', maxValues[containers.data('type')].item)
            $(headerMax).data('maxTexture', maxValues[containers.data('type')].texture)
    
            $(itemMax).html("<p>Item: " + maxValues[containers.data('type')].item + "</p>")
            $(headerMax).html("<p>Texture: " + maxValues[containers.data('type')].texture + "</p>")
        } else if (cat.type == "hair") {
            var containers = $(".clothing-menu-clothing-container").find('[data-type="'+i+'"]');
            var itemMax = $(containers).find('[data-headertype="item-header"]');
            var headerMax = $(containers).find('[data-headertype="texture-header"]');
    
            $(itemMax).data('maxItem', maxValues[containers.data('type')].item)
            $(headerMax).data('maxTexture', maxValues[containers.data('type')].texture)
    
            $(itemMax).html("<p>Item: " + maxValues[containers.data('type')].item + "</p>")
            $(headerMax).html("<p>Texture: " + maxValues[containers.data('type')].texture + "</p>")
        } else if (cat.type == "accessoires") {
            var containers = $(".clothing-menu-accessoires-container").find('[data-type="'+i+'"]');
            var itemMax = $(containers).find('[data-headertype="item-header"]');
            var headerMax = $(containers).find('[data-headertype="texture-header"]');
    
            $(itemMax).data('maxItem', maxValues[containers.data('type')].item)
            $(headerMax).data('maxTexture', maxValues[containers.data('type')].texture)
    
            $(itemMax).html("<p>Item: " + maxValues[containers.data('type')].item + "</p>")
            $(headerMax).html("<p>Texture: " + maxValues[containers.data('type')].texture + "</p>")
        }
    })
}

QBClothing.ResetValues = function() {
    $.each(clothingCategorys, function(i, cat){
        var containers = $(".clothing-menu-character-container").find('[data-type="'+cat+'"]');
        var inputs = $(containers).find('input');

        inputs.val(0);
    })
}

// QBClothing.Open()