// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

	  $(document).ready(function() {
    		$("#event_date").datepicker({dateFormat: 'dd-mm-yy'});
    		$('#event_time').timepicker({
    			showPeriod: true,
    			showLeadingZero: true
    		});
  	  });