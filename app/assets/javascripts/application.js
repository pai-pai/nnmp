//= require jquery
//= require jquery_ujs
//= require_tree .

function changeNomination(object) {
    if (object.val()) {
        $.ajax({
            dataType: "html",
            url: "/dashboard/nominations/get_to_edit?nomination_id=" + object.val(),
            data: {},
            success: function(data) {
                $(".nmt-" + object.val()).html(data);
            }
        });
    }
    alertRemover();
}

function closer() {
    $(".closer").bind('click', function() {
        $(this).parent().remove();
    })
}

function alertRemover() {
    if ($(".for-alert .alert")) { $(".for-alert .alert").remove() };
}

function resizeLeftColumn() {
    if ($('.right-column').height() < $(window).height()) {
        $('.left-column').height($(window).height() - 60);
    } else {
        $('.left-column').height($('.right-column').height());
    }
}

$(document).ready(function() {
    resizeLeftColumn();
    $(window).resize(function() { resizeLeftColumn(); });

    $('.edit-nomination').bind('click', function() {
        changeNomination( $(this) );
    });
})
