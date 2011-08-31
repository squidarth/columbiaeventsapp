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