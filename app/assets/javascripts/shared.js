$(document).ready(function() {
    $(".choise").change(function() {
        if ($(this).val() < 1) {
            $(this).addClass("empty")
        } else {
            $(this).removeClass("empty")
        };
        console.log('Ho-ho-ho!');
    });
    $(".choise").each( function() { $(this).change() });
});
