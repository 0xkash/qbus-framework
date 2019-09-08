$(document).ready(function () {
    $("#spawn-object").unbind("click").click(function() {
        var gtaobj = $(".select-object").children("option:selected").val();
        $.post("http://houses/SpawnObject", JSON.stringify({
            objname: gtaobj,
        }));
        Decorate.Close();
    });
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            Decorate.Close();
            break;
        case 112: // F1
            Decorate.Close();
            break;
    }
});

(() => {
    Decorate = {};

    Decorate.Open = function(data) {
        $(".decorate-main").css("display", "block");
    };

    Decorate.Close = function() {
        $(".decorate-main").css("display", "none");
        $.post("http://houses/CloseUI", JSON.stringify({}));
    };

    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case "open":
                    Decorate.Open(event.data);
                    break;
            }
        })
    }

})();