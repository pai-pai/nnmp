function promptStyling() {
    $(".choise").change(function() {
        if ($(this).val() < 1) {
            $(this).addClass("empty")
        } else {
            $(this).removeClass("empty")
        };
    });
    $(".choise").each( function() { $(this).change() });
}

$(document).ready(function() {
    promptStyling();
});
