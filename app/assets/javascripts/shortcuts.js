$(function(){
    $(window).keypress(function(event){
        var charCode = event.which || event.keyCode;
        var key = String.fromCharCode(charCode);


        if ($('input:focus').length <= 0 && $('textarea:focus').length <= 0){

            // Overview
            if(($('article').length > 1) && (key == 'A')) {
                $("a[data-type='mark_all_seen']").click();
            }
            // Entry
            if($('article').length == 1) {
                switch (key){
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

        }

    });
});