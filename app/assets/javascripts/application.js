//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require twitter/bootstrap
//= require twitter/bootstrap/bootstrap-tab
//= require twitter/bootstrap/bootstrap-tooltip
//= require twitter/bootstrap/bootstrap-popover
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
//
//= require_self
//= require_directory .
//= require app/event_salsa

// FACEBOOK INIT

FB.init({
    appId  : '263515600329607',
    status : true, // check login status
    cookie : true, // enable cookies to allow the server to access the session
    xfbml  : true, // parse XFBML
    oauth : true // enables OAuth 2.0
});
