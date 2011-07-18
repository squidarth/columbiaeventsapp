// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

    $(document).ready(function() {
      
      function addMega(){
        $(this).addClass("hovering");
        }

      function removeMega(){
        $(this).removeClass("hovering");
        }

    var megaConfig = {
         interval: 500,
         sensitivity: 4,
         over: addMega,
         timeout: 500,
         out: removeMega
    };

    $("li.mega").hoverIntent(megaConfig)

      
    });