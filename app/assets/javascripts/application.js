//= require jquery
//= require jquery_ujs
//= require jquery.ui.core
//= require jquery.ui.widget
//= require jquery.ui.mouse
//= require jquery.ui.draggable
//= require_tree .
//= require bootstrap-modal

var to_that_candidate, from_that_candidate;

function moveVotes(from, to) {
    console.log("Move votes from " + from + " to " + to);
    if (to && from !== to) {
        console.log("Ok, let's ajax this, baby! :D");
        $("#wait").show();
        $.ajax({
            dataType: "html",
            url: "/dashboard/candidates/move_votes?from=" + from + "&to=" + to,
            data: {},
            success: function(data) {
                console.log("Yey! Success! ^_^"); 
                $("#candidates-dash .container").html(data);
                makeDraggable();
            }
        });
    };
}

function makeDraggable() {
    $("#wait").hide();
    $(".drag").draggable({
        containment: $("#candidates-dash .container ul"),
        opacity: 0.55,
        revert: true,
        zIndex: 1,
        drag: function() { 
            from_that_candidate = $(this).attr("data-candidate");
        },
        stop: function(e) {
            var yourElement = document.elementFromPoint(e.clientX, e.clientY);
            console.log(yourElement);
            if (!yourElement.id) {
                to_that_candidate = yourElement.getAttribute("data-candidate");
                console.log("dC " + yourElement.getAttribute("data-candidate"));
            } else {
                to_that_candidate = yourElement.id;
                console.log("id");
            };
            moveVotes( from_that_candidate, to_that_candidate ); 
        }
    });
}

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

function changeVoteFront(object) {
    if (object.val()) {
        $.ajax({
            dataType: "html",
            url: "/votes/get_to_edit?vote_id=" + object.val(),
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
    $("#wait").height($('.left-column').height() + 60);
}

$(document).ready(function() {
    resizeLeftColumn();
    $(window).resize(function() { resizeLeftColumn(); });

    makeDraggable();

    closer();

    $('.edit-nomination').bind('click', function() {
        changeNomination( $(this) );
    });

    $('.edit-vote-front').bind('click', function() {
        changeVoteFront( $(this) );
    });

    $("#comments-picker .modal-footer .btn").bind('click', function() {
        commentCopy();
    });
})
