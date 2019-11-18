var minRot = -90,
    maxRot = 90,
    solveDeg = (Math.random() * 180) - 90,
    solvePadding = 4,
    maxDistFromSolve = 45,
    pinRot = 0,
    cylRot = 0,
    lastMousePos = 0,
    mouseSmoothing = 2,
    keyRepeatRate = 25,
    cylRotSpeed = 3,
    pinDamage = 20,
    pinHealth = 100,
    pinDamageInterval = 150,
    numPins = 1,
    userPushingCyl = false,
    gameOver = false,
    gamePaused = false,
    pin, cyl, driver, cylRotationInterval, pinLastDamaged;



var Keypad = {}

Keypad.Open = function(data) {
    $("#keypad").css("display", "block");
    $( "#keypad" ).html(
        "<form action='' method='' name='PINform' id='PINform' autocomplete='off' draggable='true'>" +
            "<input id='PINbox' type='password' value='' name='PINbox' disabled />" +
            "<br/>" +
            "<input type='button' class='PINbutton' name='1' value='1' id='1' onClick=addKeyPadNumber(this); />" +
            "<input type='button' class='PINbutton' name='2' value='2' id='2' onClick=addKeyPadNumber(this); />" +
            "<input type='button' class='PINbutton' name='3' value='3' id='3' onClick=addKeyPadNumber(this); />" +
            "<br>" +
            "<input type='button' class='PINbutton' name='4' value='4' id='4' onClick=addKeyPadNumber(this); />" +
            "<input type='button' class='PINbutton' name='5' value='5' id='5' onClick=addKeyPadNumber(this); />" +
            "<input type='button' class='PINbutton' name='6' value='6' id='6' onClick=addKeyPadNumber(this); />" +
            "<br>" +
            "<input type='button' class='PINbutton' name='7' value='7' id='7' onClick=addKeyPadNumber(this); />" +
            "<input type='button' class='PINbutton' name='8' value='8' id='8' onClick=addKeyPadNumber(this); />" +
            "<input type='button' class='PINbutton' name='9' value='9' id='9' onClick=addKeyPadNumber(this); />" +
            "<br>" +
            "<input type='button' class='PINbutton clear' name='-' value='clear' id='-' onClick=clearForm(this); />" +
            "<input type='button' class='PINbutton' name='0' value='0' id='0' onClick=addKeyPadNumber(this); />" +
            "<input type='button' class='PINbutton enter' name='+' value='enter' id='+' onClick=submitForm(PINbox); />" +
        "</form>"
    );
}

Keypad.Close = function(data) {
    $("#keypad").css("display", "none");
    if (data.error) {
        $.post('http://qb-storerobbery/CombinationFail');
    }
}

function addKeyPadNumber(e){
	//document.getElementById('PINbox').value = document.getElementById('PINbox').value+element.value;
    var v = $( "#PINbox" ).val();
    if (v.length < 4) {
        $( "#PINbox" ).val( v + e.value );
    }
}
function clearForm(e){
	//document.getElementById('PINbox').value = "";
	$( "#PINbox" ).val( "" );
}
function submitForm(e) {
	$.post("http://qb-storerobbery/TryCombination", JSON.stringify({
        combination: e.value,
    }));
};

$(function () {

    //pop vars
    pin = $('#pin');
    cyl = $('#cylinder');
    driver = $('#driver');

    $('#wrap').hide();

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "ui") {
            if (eventData.toggle) {
                $('#wrap').fadeIn(250);
                gameOver = false
                gamePaused = false
            } else {
                $('#wrap').fadeOut(50);
                gameOver = false
                gamePaused = false
            }
        }

        if (eventData.action == "openKeypad") {
            Keypad.Open(eventData);
        }

        if (eventData.action == "closeKeypad") {
            Keypad.Close(eventData);
        }
    })

    $('body').on('mousemove', function (e) {
        if (lastMousePos && !gameOver && !gamePaused) {
            var pinRotChange = (e.clientX - lastMousePos) / mouseSmoothing;
            pinRot += pinRotChange;
            pinRot = Util.clamp(pinRot, maxRot, minRot);
            pin.css({
                transform: "rotateZ(" + pinRot + "deg)"
            })
        }
        lastMousePos = e.clientX;
    });
    $('body').on('mouseleave', function (e) {
        lastMousePos = 0;
    });

    $('body').on('keydown', function (e) {
        if ((e.keyCode == 87 || e.keyCode == 65 || e.keyCode == 83 || e.keyCode == 68 || e.keyCode == 37 || e.keyCode == 39) && !userPushingCyl && !gameOver && !gamePaused) {
            pushCyl();
        }
    });

    $('body').on('keyup', function (e) {
        if ((e.keyCode == 87 || e.keyCode == 65 || e.keyCode == 83 || e.keyCode == 68 || e.keyCode == 37 || e.keyCode == 39) && !gameOver) {
            unpushCyl();
        }
    });

    //TOUCH HANDLERS
    $('body').on('touchstart', function (e) {
        if (!e.touchList) {
        }
        else if (e.touchList) {
        }
    })
    
    document.onkeyup = function (data) {
        if (data.which == 27 ) {
            $.post('http://qb-storerobbery/exit');
        }
    };
}); //docready

//CYL INTERACTIVITY EVENTS
function pushCyl() {
    var distFromSolve, cylRotationAllowance;
    clearInterval(cylRotationInterval);
    userPushingCyl = true;
    //set an interval based on keyrepeat that will rotate the cyl forward, and if cyl is at or past maxCylRotation based on pick distance from solve, display "bounce" anim and do damage to pick. If pick is within sweet spot params, allow pick to rotate to maxRot and trigger solve functionality

    //SO...to calculate max rotation, we need to create a linear scale from solveDeg+padding to maxDistFromSolve - if the user is more than X degrees away from solve zone, they are maximally distant and the cylinder cannot travel at all. Let's start with 45deg. So...we need to create a scale and do a linear conversion. If user is at or beyond max, return 0. If user is within padding zone, return 100. Cyl may travel that percentage of maxRot before hitting the damage zone.

    distFromSolve = Math.abs(pinRot - solveDeg) - solvePadding;
    distFromSolve = Util.clamp(distFromSolve, maxDistFromSolve, 0);

    cylRotationAllowance = Util.convertRanges(distFromSolve, 0, maxDistFromSolve, 1, 0.02); //oldval is distfromsolve, oldmin is....0? oldMax is maxDistFromSolve, newMin is 100 (we are at solve, so cyl may travel 100% of maxRot), newMax is 0 (we are at or beyond max dist from solve, so cyl may not travel at all - UPDATE - must give cyl just a teensy bit of travel so user isn't hammered);
    cylRotationAllowance = cylRotationAllowance * maxRot;

    cylRotationInterval = setInterval(function () {
        cylRot += cylRotSpeed;
        if (cylRot >= maxRot) {
            cylRot = maxRot;
            // do happy solvey stuff
            clearInterval(cylRotationInterval);
            unlock();
        }
        else if (cylRot >= cylRotationAllowance) {
            cylRot = cylRotationAllowance;
            // do sad pin-hurty stuff
            damagePin();
        }

        cyl.css({
            transform: "rotateZ(" + cylRot + "deg)"
        });
        driver.css({
            transform: "rotateZ(" + cylRot + "deg)"
        });
    }, keyRepeatRate);
}

function unpushCyl() {
    userPushingCyl = false;
    //set an interval based on keyrepeat that will rotate the cyl backward, and if cyl is at or past origin, set to origin and stop.
    clearInterval(cylRotationInterval);
    cylRotationInterval = setInterval(function () {
        cylRot -= cylRotSpeed;
        cylRot = Math.max(cylRot, 0);
        cyl.css({
            transform: "rotateZ(" + cylRot + "deg)"
        })
        driver.css({
            transform: "rotateZ(" + cylRot + "deg)"
        })
        if (cylRot <= 0) {
            cylRot = 0;
            clearInterval(cylRotationInterval);
        }
    }, keyRepeatRate);
}

//PIN AND SOLVE EVENTS

function damagePin() {
    if (!pinLastDamaged || Date.now() - pinLastDamaged > pinDamageInterval) {
        var tl = new TimelineLite();
        pinHealth -= pinDamage;
        pinLastDamaged = Date.now()

        //pin damage/lock jiggle animation
        tl.to(pin, (pinDamageInterval / 4) / 1000, {
            rotationZ: pinRot - 2
        });
        tl.to(pin, (pinDamageInterval / 4) / 1000, {
            rotationZ: pinRot
        });
        if (pinHealth <= 0) {
            breakPin();
        }
    }
}

function breakPin() {
    var tl, pinTop, pinBott;
    gamePaused = true;
    clearInterval(cylRotationInterval);
    numPins--;
    $('span').text(numPins)
    pinTop = pin.find('.top');
    pinBott = pin.find('.bott');
    tl = new TimelineLite();
    tl.to(pinTop, 0.7, {
        rotationZ: -400,
        x: -200,
        y: -100,
        opacity: 0
    });
    tl.to(pinBott, 0.7, {
        rotationZ: 400,
        x: 200,
        y: 100,
        opacity: 0,
        onComplete: function () {
            if (numPins > 0) {
                gamePaused = false;
                reset();
            } else {
                outOfPins();
            }
        }
    }, 0)
    tl.play();
}

function reset() {
    cylRot = 0;
    pinHealth = 100;
    pinRot = 0;
    pin.css({
        transform: "rotateZ(" + pinRot + "deg)"
    })
    cyl.css({
        transform: "rotateZ(" + cylRot + "deg)"
    })
    driver.css({
        transform: "rotateZ(" + cylRot + "deg)"
    })
    TweenLite.to(pin.find('.top'), 0, {
        rotationZ: 0,
        x: 0,
        y: 0,
        opacity: 1
    });
    TweenLite.to(pin.find('.bott'), 0, {
        rotationZ: 0,
        x: 0,
        y: 0,
        opacity: 1
    });
}

function outOfPins() {
    gameOver = true;
    $.post('http://qb-storerobbery/fail');
    setTimeout(function(){
        reset()
    }, 250)
}

function unlock() {
    gameOver = true;
    $.post('http://qb-storerobbery/success');
    solveDeg = (Math.random() * 180) - 90
    solvePadding = 4
    maxDistFromSolve = 45
    pinRot = 1
    cylRot = 1
    lastMousePos = 0
}

//UTIL
Util = {};
Util.clamp = function (val, max, min) {
    return Math.min(Math.max(val, min), max);
}
Util.convertRanges = function (OldValue, OldMin, OldMax, NewMin, NewMax) {
    return (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
}