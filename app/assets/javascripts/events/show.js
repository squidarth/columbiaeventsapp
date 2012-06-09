$(document).ready(function(){
    $('#dim').css("height", $(document).height());
    $('#javasign').click(function(e){
        $("#dim").fadeIn();
        $(".highlighted_content").fadeIn();
        $(".highlighted_content").animate({height: '150px'}, {queue:false, duration:1500});
        return false;
    });
    $('.close').click(function(e){
        $('.highlighted_content').animate({height: '5px'}, {queue:false, duration:1500});
        $('.highlighted_content').fadeOut();
        $('#dim').fadeOut();
    });


});
