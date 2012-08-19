EventSalsa.module "Routing", (Routing, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------

  # Change the browser URL without refiring the route's function
  # Include the new URL in Google Analytics
  Routing.showRoute = ->
    # Hijack Array.slice to treat arguments as an Array
    route = Array.prototype.slice.call(arguments).join('/')
    Backbone.history.navigate route, false
    window._gaq.push ['_trackPageview', "/#{route}"]
