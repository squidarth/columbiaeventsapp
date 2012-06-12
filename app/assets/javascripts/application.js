//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.ui.timepicker
//= require_self
//= require_directory .

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({
    'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});	

jQuery.fn.submitWithAjax = function(){
    this.submit(function(){
        $.post(this.action, $(this).serialize(), null, "script");
        return false
    });
    return this;
};

$(document).ready(function() {
    $("#event_date").datepicker({dateFormat: 'dd-mm-yy'});
    $('#event_time').timepicker({
        showPeriod: true,
        showLeadingZero: true
    });
    $("#attend").submitWithAjax();
    $("#maybe").submitWithAjax();	
});

FB.init({
    appId  : '263515600329607',
    status : true, // check login status
    cookie : true, // enable cookies to allow the server to access the session
    xfbml  : true, // parse XFBML
    oauth : true // enables OAuth 2.0
});

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-25696864-1']);
_gaq.push(['_trackPageview']);

(function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

$(document).ready(function(){
    var height = 45;
    $(window).scroll(function(){
        if($(window).scrollTop() > height){
            $("#top-part-nav").css('position','fixed').css('top',0).next().css("padding-top", "60px");
        }else{
            $("#top-part-nav").css('position', 'static').next().css("padding-top", "none");
        }
    });
});

/*
$(function(){
    var event_obs = [];
    <% Event.all.each do |event| %>
    event_obs.push("<%= event.name %>");
<% end %>
    $("#search_field").autocomplete({
        source: event_obs
    });	
});
*/
