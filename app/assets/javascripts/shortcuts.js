$(function(){
    $(window).keypress(function(event){
        // Overview
        if( ($('article').length > 1) && String.fromCharCode(event.keyCode) == 'A') {
            $("a[data-type='mark_all_seen']").click();
        }
        // Entry
        if($('article').length == 1) {
            switch (String.fromCharCode(event.keyCode)){
                case 'm':
                    $("a[data-type='read_unread']").click();
                    break;
                case 's':
                    $("a[data-type='star_unstar']").click();
                    break;
                case 'j':
                    Turbolinks.visit($("a[rel='next']").attr('href'));
                    break;
                case 'k':
                    Turbolinks.visit($("a[rel='prev']").attr('href'));
                    break;
                case 'v':
                    window.location.href = $("a[data-type='web']").attr('href');
                    break;
            }
        }
    });
});