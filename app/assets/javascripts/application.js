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
    $('.alert').fadeOut(1000);
});

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


