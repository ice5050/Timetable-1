// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
// require turbolinks
//= require_tree .

$(document).ready(function() {
    $('#new').click(function() {
        $('this').hide();
        $('edit').show();
    })
});

$(document).ready(function() {
    $('.target').click(function() {
        $(this).find(".subject").toggle(200);
    });
});

$(document).ready(function() {
    $('#button-add').click(function() {
        $("#newClass").toggle(100);
    });
});

$(document).ready(function() {
    $('.alert').fadeOut(4000);
});

$(document).ready(function() {
    $('.saveClass').click(function() {
        $("#newClass").hide(100);
        $("#load").show(100);
    })
})


$(document).ready(function() {

    $('form').change(function() {
        if ($('#class_subject_code').val().length <= 0 ||
            $('#class_subject').val().length <= 0 ||
            $('#class_room').val().length <= 0 || 
            $('#class_section').val().length <= 0) {

            $('.saveClass').prop('disabled', true);
            $('.saveClass').addClass('bg-silver');
        } else if (parseInt($('#class_start').val()) >= parseInt($('#class_finish').val())) {
            $('#invalidTime').show(200);
            $('.saveClass').prop('disabled', true);
            $('.saveClass').addClass('bg-silver'); 
        } else {
            $('#invalidTime').hide(200);
            $('.saveClass').prop('disabled', false);
            $('.saveClass').removeClass('bg-silver');
        }
    });
});

$(document).ready(function() {
    $('#241115_show').show();
    $('#241115_click').prop('disabled', false);

    $('#241115_click').click(function() {
        updateOpenCloseStatus();

        $('#241115_click i').addClass('glyphicon-triangle-bottom');
        $('#241115_show').show(200);
    });

    $('#231115_click').click(function() {
        updateOpenCloseStatus();
        
        $('#231115_click i').addClass('glyphicon-triangle-bottom');
        $('#231115_show').show(200);
    });

    $('#211115_click').click(function() {
        updateOpenCloseStatus();

        $('#211115_click i').addClass('glyphicon glyphicon-triangle-bottom');
        $('#211115_show').show(200);
    });
});

function updateOpenCloseStatus() {
    $('.update-header i').removeClass();
    $('.update-header i').addClass('glyphicon glyphicon-triangle-right');
    $('.update-content').hide(200);
}




// $(document).ready(function() {
//     $('#switch-1').click(function() {
//         $('.table-detail').toggle(200);
//         $('.subject-detail').toggle(200);
//     })
// });


// $(document).ready(function() {
//     $('#subject_code').keypress(function(){
//         if ($('#subject_code').val().length >= 5) {
//             $('#save').prop("disabled",false);
//             $('#save').addClass('bg-green');
//             $('#save').removeClass('bg-silver');
//         } else if ($('#subject_code').val().length < 5){
//             $('#save').prop("disabled",true);
//             $('#save').addClass('bg-silver');
//             $('#save').removeClass('bg-green');
//         }
//     });
// })


