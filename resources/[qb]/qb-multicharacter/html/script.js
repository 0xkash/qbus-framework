var selectedChar = null;
qbMultiCharacters = {}

$(document).ready(function (){

    // $('.container').hide();
    window.addEventListener('message', function (event) {
        var item = event.data;

        if (item.action == "openUI") {
            if (item.toggle == true) {
                $('.container').fadeIn(250);
            } else {
                $('.container').fadeOut(250);
            }
        }

        if (item.action == "setupCharacters") {
            setupCharacters(event.data.characters)
        }

        if (item.action == "setupCharInfo") {
            setupCharInfo(event.data.chardata)
        }
    });

    $('.continue-btn').click(function(e){
        e.preventDefault();

        qbMultiCharacters.fadeOutUp('.welcomescreen', 400);
        qbMultiCharacters.fadeOutDown('.server-log', 400);
        setTimeout(function(){
            qbMultiCharacters.fadeInDown('.characters-block', '17%', 400);
            $.post('http://qb-multicharacter/setupCharacters');
        }, 400)
    });

    $('.disconnect-btn').click(function(e){
        e.preventDefault();

        $.post('http://qb-multicharacter/closeUI');
        $.post('http://qb-multicharacter/disconnectButton');
    });

    $('.datepicker').datepicker();
    $('select').formSelect();
});

function setupCharInfo(cData) {
    if (cData == 'empty') {
        $('.character-info-valid').html('<span id="no-char">Het geselecteerde karakter slot is nog niet in gebruik.<br><br>Dit karakter heeft dus nog geen informatie.</span>');
    } else {
        $('.character-info-valid').html(
        '<div class="character-info-box"><span id="info-label">Name: </span><span class="char-info-js">'+cData.charinfo.firstname+' '+cData.charinfo.lastname+'</span></div>' +
        '<div class="character-info-box"><span id="info-label">DOB: </span><span class="char-info-js">'+cData.charinfo.birthdate+'</span></div>' +
        '<div class="character-info-box"><span id="info-label">Nationality: </span><span class="char-info-js">'+cData.charinfo.nationality+'</span></div>' +
        '<div class="character-info-box"><span id="info-label">Job: </span><span class="char-info-js">'+cData.job.label+'</span></div>' +
        '<div class="character-info-box"><span id="info-label">Function: </span><span class="char-info-js">'+cData.job.gradelabel+'</span></div><br>' +
        '<div class="character-info-box"><span id="info-label">Cash: </span><span class="char-info-js">$ '+cData.money.cash+'</span></div>' +
        '<div class="character-info-box"><span id="info-label">Bank: </span><span class="char-info-js">$ '+cData.money.bank+'</span></div><br>' +
        '<div class="character-info-box"><span id="info-label">Phone Number: </span><span class="char-info-js">'+cData.charinfo.phone+'</span></div>' +
        '<div class="character-info-box"><span id="info-label">Account: </span><span class="char-info-js">'+cData.charinfo.account+'</span></div>');
    }
}

function setupCharacters(characters) {
    $.each(characters, function(index, char){
        $('#char-'+char.cid).html("");
        $('#char-'+char.cid).data("citizenid", char.citizenid);
        setTimeout(function(){
            $('#char-'+char.cid).html('<span id="slot-name">'+char.charinfo.firstname+' '+char.charinfo.lastname+'<span id="cid">' + char.citizenid + '</span></span>');
            $('#char-'+char.cid).data('cData', char)
            $('#char-'+char.cid).data('cid', char.cid)
        }, 100)
    })
}

$(document).on('click', '#close-log', function(e){
    e.preventDefault();
    selectedLog = null;
    $('.welcomescreen').css("filter", "none");
    $('.server-log').css("filter", "none");
    $('.server-log-info').fadeOut(250);
    logOpen = false;
});

$(document).on('click', '.character', function(e) {
    e.preventDefault();
    if (selectedChar === null) {
        selectedChar = $(this);
        if ((selectedChar).data('cid') == "") {
            $(selectedChar).addClass("char-selected");
            setupCharInfo('empty')
            $("#play-text").html("Karakter aanmaken");
            if ($("#delete").css("display") != "none") {
                $("#delete").hide();
            }
            $("#play").css({"display":"block"});
            $("#delete").css({"display":"none"});
        } else {
            $(selectedChar).addClass("char-selected");
            setupCharInfo($(this).data('cData'))
            $("#play-text").html("Karakter Spelen");
            $("#delete-text").html("Karakter Verwijderen");
            $("#play").css({"display":"block"});
            $("#delete").css({"display":"block"});
        }
    } else {
        $(selectedChar).removeClass("char-selected");
        selectedChar = $(this);
        if ((selectedChar).data('cid') == "") {
            $(selectedChar).addClass("char-selected");
            setupCharInfo('empty')
            $("#play-text").html("Karakter aanmaken");
            $("#play").css({"display":"block"});
            $("#delete").css({"display":"none"});
        } else {
            $(selectedChar).addClass("char-selected");
            setupCharInfo($(this).data('cData'))
            $("#play-text").html("Karakter Spelen");
            $("#delete-text").html("Karakter Verwijderen");
            $("#play").css({"display":"block"});
            $("#delete").css({"display":"block"});
        }
    }
});

$(document).on('click', '#create', function(e){
    e.preventDefault();

    $.post('http://qb-multicharacter/createNewCharacter', JSON.stringify({
        firstname: $('#first_name').val(),
        lastname: $('#last_name').val(),
        nationality: $('#nationality').val(),
        birthdate: $('#datepicker').val(),
        gender: $('#sex').val(),
        cid: $(selectedChar).attr('id').replace('char-', ''),
    }))
    $('.character-register').fadeOut(150);
    $('.characters-block').css("filter", "none");
    refreshCharacters()
});

$(document).on('click', '#accept-delete', function(e){
    $.post('http://qb-multicharacter/removeCharacter', JSON.stringify({
        citizenid: $(selectedChar).data("citizenid"),
    }));
    $('.character-delete').fadeOut(150);
    $('.characters-block').css("filter", "none");
    refreshCharacters()
});

function refreshCharacters() {
    $('.characters-list').html('<div class="character" id="char-1" data-cid=""><span id="slot-name">Empty Slot<span id="cid"></span></span></div><div class="character" id="char-2" data-cid=""><span id="slot-name">Empty Slot<span id="cid"></span></span></div><div class="character" id="char-3" data-cid=""><span id="slot-name">Empty Slot<span id="cid"></span></span></div><div class="character" id="char-4" data-cid=""><span id="slot-name">Empty Slot<span id="cid"></span></span></div><div class="character" id="char-5" data-cid=""><span id="slot-name">Empty Slot<span id="cid"></span></span></div>')
    setTimeout(function(){
        $(selectedChar).removeClass("char-selected");
        selectedChar = null;
        $.post('http://qb-multicharacter/setupCharacters');
        $("#play-text").html("Select a character");
        $("#delete-text").html("Select a character");
    }, 100)
}

$("#close-reg").click(function (e) {
    e.preventDefault();
    $('.characters-block').css("filter", "none");
    $('.character-register').fadeOut(150);
})

$("#close-del").click(function (e) {
    e.preventDefault();
    $('.characters-block').css("filter", "none");
    $('.character-delete').fadeOut(150);
})


$("#play").click(function (e) {
    e.preventDefault();
    var charData = $(selectedChar).data('cid');

    if (selectedChar !== null) {
        if (charData !== "") {
            $.post('http://qb-multicharacter/selectCharacter', JSON.stringify({
                cData: $(selectedChar).data('cData')
            }));
        } else {
            $('.characters-block').css("filter", "blur(2px)")
            $('.character-register').fadeIn(250);
        }
    } else {
        console.log('Select a character')
    }
});

$("#delete").click(function (e) {
    e.preventDefault();
    var charData = $(selectedChar).data('cid');

    if (selectedChar !== null) {
        if (charData !== "") {
            $('.characters-block').css("filter", "blur(2px)")
            $('.character-delete').fadeIn(250);
        }
    }
});

qbMultiCharacters.fadeOutUp = function(element, time) {
    $(element).css({"display":"block"}).animate({top: "-50.5%",}, time, function(){
        $(element).css({"display":"none"});
    });
}

qbMultiCharacters.fadeOutDown = function(element, time) {
    $(element).css({"display":"block"}).animate({top: "103.5%",}, time, function(){
        $(element).css({"display":"none"});
    });
}

qbMultiCharacters.fadeInDown = function(element, percent, time) {
    $(element).css({"display":"block"}).animate({top: percent,}, time);
}