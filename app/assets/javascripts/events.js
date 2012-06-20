$(document).ready(function(){
    var from = 0, to = 5, step = 5, maxSize = 50;
    //var from = 0, to = 5, step = 5, maxSize = <%= @events.size ;%>

    function showNext(list) {
        list.find('li:lt(' + (to) + '):not(li:lt(' + (to-step) + '))').fadeIn();
        console.log($(document).height(), $(window).height());
        $("html, body").animate({ scrollTop: $(document).height()-$(window).height()}, 1000);
        to+= step;
        if(to >= maxSize){
            $('#more').hide();
            $('#back_to_top').show();
        }
    }
    function start(list){
        list.find('li').hide().end().find('li:lt(' + (to) + '):not(li:lt(' + from + '))').show();

        if(to >= maxSize){
            $('#more').hide();
            $('#back_to_top').show();
        }
        to+= step;
    }
    start($('ul#catshowpage'));
    $('#more').click(function(e){
        e.preventDefault();
        showNext($('ul#catshowpage'));
    });
    $('#back_to_top').click(function(e){
        e.preventDefault();
        $("html, body").animate({ scrollTop: 0 }, 700);
    });
});
