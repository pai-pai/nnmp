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
            url: "/dashboard/nominations/get_to_edit?nomination_id=" + object.val(),
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
            url: "/dashboard/candidates/get_to_edit?candidate_id=" + object.val(),
            data: {},
            success: function(data) {
                $("#" + object.val()).html(data);
                promptStyling();
            }
        });
    }
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
}

$(document).ready(function() {
    resizeLeftColumn();
    $(window).resize(function() { resizeLeftColumn(); });

    makeDraggable();

    closer();

    $('.edit-nomination').bind('click', function() { changeNomination( $(this) ) });

    $('.edit-candidate').bind('click', function() { changeCandidate( $(this) ) });

    $('.edit-vote-front').bind('click', function() { changeVoteFront( $(this) ) });

    $("#comments-picker .modal-footer .btn").bind('click', function() { commentCopy() });
})
