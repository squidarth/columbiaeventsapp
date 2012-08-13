//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require twitter/bootstrap/bootstrap-tab
//= require bootstrap-datepicker
//= require bootstrap-timepicker
//= require jquery.expander
//= require moment
//
//= require underscore
//= require backbone
//= require backbone.marionette
//= require backbone_rails_sync
//= require backbone_datalink
//= require Backbone.ModelBinder-min
//= require app/event_salsa
//
//= require_self
//= require_directory .

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// FACEBOOK INIT

FB.init({
    appId  : '263515600329607',
    status : true, // check login status
    cookie : true, // enable cookies to allow the server to access the session
    xfbml  : true, // parse XFBML
    oauth : true // enables OAuth 2.0
});

// GOOGLE ANALYTICS INIT

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-25696864-1']);
_gaq.push(['_trackPageview']);

(function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
