//= require jquery
//= require jquery_ujs
//= require jquery.ui.core
//= require jquery.ui.widget
//= require jquery.ui.mouse
//= require jquery.ui.draggable
//= require jquery.ui.autocomplete
//= require jquery.ui.menu
//= require jquery.ui.position
//= require_tree .
//= require bootstrap-modal

var to_that_candidate, from_that_candidate, first_names;

function moveVotes(from, to) {
    if (to && from !== to) {
        $("#wait").show();
        $.ajax({
            dataType: "html",
            url: "/dashboard/move-votes?from=" + from + "&to=" + to,
            data: {},
            success: function(data) {
                $("#candidates-dash .container").html(data);
                makeDraggable();
            }
        });
    };
}

function showComment(object) {
    $.ajax({
        dataType: "html",
        url: "/dashboard/get-votes-comment?vote_id=" + object.attr("class"),
        data: {},
        success: function(data) {
            $("#comment").html(data);
        }
    });
}

function makeDraggable() {
    $("#wait").hide();
    $('.edit-candidate').bind('click', function() { changeCandidate( $(this) ) });
    $(".drag").each(function() {
        var id = $(this).attr("id");
        $(this).find('*').attr('data-candidate', id);
    });
    $(".drag").draggable({
        containment: $("#candidates-dash .container ul"),
        opacity: 0.55,
        revert: true,
        zIndex: 1,
        drag: function() {
            if ($(this).attr("id")) {
                from_that_candidate = $(this).attr("id");
            } else {
                from_that_candidate = $(this).attr("data-candidate");
            }
        },
        stop: function(e) {
            var draggOn = document.elementFromPoint(e.clientX, e.clientY);
            if (!draggOn.id) {
                to_that_candidate = draggOn.getAttribute("data-candidate");
            } else {
                to_that_candidate = draggOn.id;
            };
            moveVotes( from_that_candidate, to_that_candidate ); 
        }
    });
}

function changeNomination(object) {
    if (object.val()) {
        $.ajax({
            dataType: "html",
            url: "/dashboard/get-nomination-to-edit?nomination_id=" + object.val(),
            data: {},
            success: function(data) {
                $(".nmt-" + object.val()).html(data);
            }
        });
    }
    alertRemover();
}

function changeCandidate(object) {
    if (object.val()) {
        $.ajax({
            dataType: "html",
            url: "/dashboard/get-candidate-to-edit?candidate_id=" + object.val(),
            data: {},
            success: function(data) {
                $("#" + object.val()).html(data);
                promptStyling();
                $("#candidates-dash form input[type='submit']").click(function() { $("#wait").show() });
            }
        });
    }
}

function changeVoteFront(object) {
    if (object.val()) {
        $.ajax({
            dataType: "html",
            url: "/get-vote-to-edit?vote_id=" + object.val(),
            data: {},
            success: function(data) {
                $(".vote-" + object.val() + " blockquote").html(data);
            }
        });
    }
}

function closer() {
    $(".closer").bind('click', function() {
        $(this).parent().remove();
    })
}

function alertRemover() {
    if ($(".for-alert .alert")) { $(".for-alert .alert").remove() };
}

function commentCopy() {
    $(".modal-body input:checked").each(function(){
        if ($("#vote_comment").val() === "") {
            $("#vote_comment").val( $("#vote_comment").val() + $(this).val() );
        } else {
            $("#vote_comment").val( $("#vote_comment").val() + "\n\n" + $(this).val() );
        }
    });
    $('#comments-picker').modal('hide');
}

function resizeLeftColumn() {
    if ($('.right-column').height() < $(window).height()) {
        $('.left-column').height($(window).height() - 60);
    } else {
        $('.left-column').height($('.right-column').height());
    };
}

$(document).ready(function() {
    resizeLeftColumn();
    $("#wait").hide();
    $(window).resize(function() { resizeLeftColumn(); });

    $("#vote_first_name").autocomplete({
        source: function( request, response ) {
            $.ajax({
                url: "/get-io",
                dataType: "json",
                data: { search_first: request.term },
                success: function(data) {
                    response( $.map( data.names, function( item ){ return item.name; }));
                }
            });
        }
    });

    $("#vote_sec_name").autocomplete({
        source: function( request, response ) {
            $.ajax({
                url: "/get-io",
                dataType: "json",
                data: { search_sec: request.term },
                success: function(data) {
                    response( $.map( data.names, function( item ){ return item.name; }));
                }
            });
        }
    });

    makeDraggable();

    closer();

    $('.edit-nomination').bind('click', function() { changeNomination( $(this) ) });

    $('.edit-candidate').bind('click', function() { changeCandidate( $(this) ) });

    $('.edit-vote-front').bind('click', function() { changeVoteFront( $(this) ) });

    $("#new_vote .btn").click(function() { $("#wait").show(); });

    $("#comments-picker .modal-footer .btn").bind('click', function() { commentCopy() });

    $(".container-men div").each(function(){
        $(this).mouseenter( function(e) {
            var x = e.clientX;
            var y = e.clientY;
            console.log("X: " + x + "px, Y: " + y + "px");
            showComment($(this));
            $("#comment").css({ 'top' : x, 'left' : y }).show();
        } ).mouseleave( function() {
            $("#comment").hide();
            $("#comment .container-men").remove();
        } );
    });
})
