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
        // $("#newClass").hide(100);
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
    $('#261115_show').show();

    $('.update-header').click(function() {
        updateOpenCloseStatus();
        $(this).next('.update-content').show(200)
        $(this).find('i').addClass('glyphicon glyphicon-triangle-bottom');
    })
})

function updateOpenCloseStatus() {
    $('.update-header i').removeClass();
    $('.update-header i').addClass('glyphicon glyphicon-triangle-right');
    $('.update-content').hide(200);
}

$(document).ready(function() {
    $('.subject-header').click(function() {
        $(this).next('.subject-detail').toggle();
    });
})

$(document).ready(function() {
    $('#sample6').focus(function() {
        $('#search-hint').css("display", "inline");
    });

    $('#sample6').focusout(function() {
        $('#search-hint').css("display", "none");
    });
})

$(document).ready(function() {
    // if ($('.fixme').hasClass()) {
        var fixmeTop = $('.fixme').offset().top;     
    // }
    

    $(window).scroll(function() {                  // assign scroll event listener
        
        var currentScroll = $(window).scrollTop(); // get current position

        if (currentScroll >= fixmeTop) {           // apply position: fixed if you
            $('.fixme').css({                      // scroll to that element or below it
                position: 'fixed',
                top: '0',
                background: '#fff',
                borderRadius: '0px 0px 10px 10px',
                paddingRight: '10px',
                paddingLeft: '10px',
            });
        } else {                                   // apply position: static
            $('.fixme').css({                      // if you scroll above it
                position: 'static',
                background: '#fff',
                padding: '0px',
            });
        }
    });
})


jQuery(window).load(function () {
    $('#searching').hide(500);
});


$(document).ready(function() { 
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-68588922-1']);
    _gaq.push(['_trackPageview']);

    (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();

    (function(b){(function(a){"__CF"in b&&"DJS"in b.__CF?b.__CF.DJS.push(a):"addEventListener"in b?b.addEventListener("load",a,!1):b.attachEvent("onload",a)})(function(){"FB"in b&&"Event"in FB&&"subscribe"in FB.Event&&(FB.Event.subscribe("edge.create",function(a){_gaq.push(["_trackSocial","facebook","like",a])}),FB.Event.subscribe("edge.remove",function(a){_gaq.push(["_trackSocial","facebook","unlike",a])}),FB.Event.subscribe("message.send",function(a){_gaq.push(["_trackSocial","facebook","send",a])}));"twttr"in b&&"events"in twttr&&"bind"in twttr.events&&twttr.events.bind("tweet",function(a){if(a){var b;if(a.target&&a.target.nodeName=="IFRAME")a:{if(a=a.target.src){a=a.split("#")[0].match(/[^?=&]+=([^&]*)?/g);b=0;for(var c;c=a[b];++b)if(c.indexOf("url")===0){b=unescape(c.split("=")[1]);break a}}b=void 0}_gaq.push(["_trackSocial","twitter","tweet",b])}})})})(window);
});